1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
8 
9 pragma solidity 0.8.7;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
90 
91 
92 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
93 
94 pragma solidity 0.8.7;
95 
96 
97 /**
98  * @dev Interface for the optional metadata functions from the ERC20 standard.
99  *
100  * _Available since v4.1._
101  */
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 // File: @openzeppelin/contracts/utils/Context.sol
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
123 
124 pragma solidity 0.8.7;
125 
126 /**
127  * @dev Provides information about the current execution context, including the
128  * sender of the transaction and its data. While these are generally available
129  * via msg.sender and msg.data, they should not be accessed in such a direct
130  * manner, since when dealing with meta-transactions the account sending and
131  * paying for execution may not be the actual sender (as far as an application
132  * is concerned).
133  *
134  * This contract is only required for intermediate, library-like contracts.
135  */
136 abstract contract Context {
137     function _msgSender() internal view virtual returns (address) {
138         return msg.sender;
139     }
140 
141     function _msgData() internal view virtual returns (bytes calldata) {
142         return msg.data;
143     }
144 }
145 
146 
147 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
148 
149 
150 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
151 
152 pragma solidity 0.8.7;
153 
154 
155 
156 
157 /**
158  * @dev Implementation of the {IERC20} interface.
159  *
160  * This implementation is agnostic to the way tokens are created. This means
161  * that a supply mechanism has to be added in a derived contract using {_mint}.
162  * For a generic mechanism see {ERC20PresetMinterPauser}.
163  *
164  * TIP: For a detailed writeup see our guide
165  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
166  * to implement supply mechanisms].
167  *
168  * We have followed general OpenZeppelin Contracts guidelines: functions revert
169  * instead returning `false` on failure. This behavior is nonetheless
170  * conventional and does not conflict with the expectations of ERC20
171  * applications.
172  *
173  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
174  * This allows applications to reconstruct the allowance for all accounts just
175  * by listening to said events. Other implementations of the EIP may not emit
176  * these events, as it isn't required by the specification.
177  *
178  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
179  * functions have been added to mitigate the well-known issues around setting
180  * allowances. See {IERC20-approve}.
181  */
182 contract ERC20 is Context, IERC20, IERC20Metadata {
183     mapping(address => uint256) private _balances;
184 
185     mapping(address => mapping(address => uint256)) private _allowances;
186 
187     uint256 private _totalSupply;
188 
189     string private _name;
190     string private _symbol;
191 
192     /**
193      * @dev Sets the values for {name} and {symbol}.
194      *
195      * The default value of {decimals} is 18. To select a different value for
196      * {decimals} you should overload it.
197      *
198      * All two of these values are immutable: they can only be set once during
199      * construction.
200      */
201     constructor(string memory name_, string memory symbol_) {
202         _name = name_;
203         _symbol = symbol_;
204     }
205 
206     /**
207      * @dev Returns the name of the token.
208      */
209     function name() public view virtual override returns (string memory) {
210         return _name;
211     }
212 
213     /**
214      * @dev Returns the symbol of the token, usually a shorter version of the
215      * name.
216      */
217     function symbol() public view virtual override returns (string memory) {
218         return _symbol;
219     }
220 
221     /**
222      * @dev Returns the number of decimals used to get its user representation.
223      * For example, if `decimals` equals `2`, a balance of `505` tokens should
224      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
225      *
226      * Tokens usually opt for a value of 18, imitating the relationship between
227      * Ether and Wei. This is the value {ERC20} uses, unless this function is
228      * overridden;
229      *
230      * NOTE: This information is only used for _display_ purposes: it in
231      * no way affects any of the arithmetic of the contract, including
232      * {IERC20-balanceOf} and {IERC20-transfer}.
233      */
234     function decimals() public view virtual override returns (uint8) {
235         return 18;
236     }
237 
238     /**
239      * @dev See {IERC20-totalSupply}.
240      */
241     function totalSupply() public view virtual override returns (uint256) {
242         return _totalSupply;
243     }
244 
245     /**
246      * @dev See {IERC20-balanceOf}.
247      */
248     function balanceOf(address account) public view virtual override returns (uint256) {
249         return _balances[account];
250     }
251 
252     /**
253      * @dev See {IERC20-transfer}.
254      *
255      * Requirements:
256      *
257      * - `recipient` cannot be the zero address.
258      * - the caller must have a balance of at least `amount`.
259      */
260     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
261         _transfer(_msgSender(), recipient, amount);
262         return true;
263     }
264 
265     /**
266      * @dev See {IERC20-allowance}.
267      */
268     function allowance(address owner, address spender) public view virtual override returns (uint256) {
269         return _allowances[owner][spender];
270     }
271 
272     /**
273      * @dev See {IERC20-approve}.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      */
279     function approve(address spender, uint256 amount) public virtual override returns (bool) {
280         _approve(_msgSender(), spender, amount);
281         return true;
282     }
283 
284     /**
285      * @dev See {IERC20-transferFrom}.
286      *
287      * Emits an {Approval} event indicating the updated allowance. This is not
288      * required by the EIP. See the note at the beginning of {ERC20}.
289      *
290      * Requirements:
291      *
292      * - `sender` and `recipient` cannot be the zero address.
293      * - `sender` must have a balance of at least `amount`.
294      * - the caller must have allowance for ``sender``'s tokens of at least
295      * `amount`.
296      */
297     function transferFrom(
298         address sender,
299         address recipient,
300         uint256 amount
301     ) public virtual override returns (bool) {
302         _transfer(sender, recipient, amount);
303 
304         uint256 currentAllowance = _allowances[sender][_msgSender()];
305         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
306         unchecked {
307             _approve(sender, _msgSender(), currentAllowance - amount);
308         }
309 
310         return true;
311     }
312 
313     /**
314      * @dev Atomically increases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
326         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
327         return true;
328     }
329 
330     /**
331      * @dev Atomically decreases the allowance granted to `spender` by the caller.
332      *
333      * This is an alternative to {approve} that can be used as a mitigation for
334      * problems described in {IERC20-approve}.
335      *
336      * Emits an {Approval} event indicating the updated allowance.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      * - `spender` must have allowance for the caller of at least
342      * `subtractedValue`.
343      */
344     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
345         uint256 currentAllowance = _allowances[_msgSender()][spender];
346         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
347         unchecked {
348             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
349         }
350 
351         return true;
352     }
353 
354     /**
355      * @dev Moves `amount` of tokens from `sender` to `recipient`.
356      *
357      * This internal function is equivalent to {transfer}, and can be used to
358      * e.g. implement automatic token fees, slashing mechanisms, etc.
359      *
360      * Emits a {Transfer} event.
361      *
362      * Requirements:
363      *
364      * - `sender` cannot be the zero address.
365      * - `recipient` cannot be the zero address.
366      * - `sender` must have a balance of at least `amount`.
367      */
368     function _transfer(
369         address sender,
370         address recipient,
371         uint256 amount
372     ) internal virtual {
373         require(sender != address(0), "ERC20: transfer from the zero address");
374         require(recipient != address(0), "ERC20: transfer to the zero address");
375 
376         _beforeTokenTransfer(sender, recipient, amount);
377 
378         uint256 senderBalance = _balances[sender];
379         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
380         unchecked {
381             _balances[sender] = senderBalance - amount;
382         }
383         _balances[recipient] += amount;
384 
385         emit Transfer(sender, recipient, amount);
386 
387         _afterTokenTransfer(sender, recipient, amount);
388     }
389 
390     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
391      * the total supply.
392      *
393      * Emits a {Transfer} event with `from` set to the zero address.
394      *
395      * Requirements:
396      *
397      * - `account` cannot be the zero address.
398      */
399     function _mint(address account, uint256 amount) internal virtual {
400         require(account != address(0), "ERC20: mint to the zero address");
401 
402         _beforeTokenTransfer(address(0), account, amount);
403 
404         _totalSupply += amount;
405         _balances[account] += amount;
406         emit Transfer(address(0), account, amount);
407 
408         _afterTokenTransfer(address(0), account, amount);
409     }
410 
411     /**
412      * @dev Destroys `amount` tokens from `account`, reducing the
413      * total supply.
414      *
415      * Emits a {Transfer} event with `to` set to the zero address.
416      *
417      * Requirements:
418      *
419      * - `account` cannot be the zero address.
420      * - `account` must have at least `amount` tokens.
421      */
422     function _burn(address account, uint256 amount) internal virtual {
423         require(account != address(0), "ERC20: burn from the zero address");
424 
425         _beforeTokenTransfer(account, address(0), amount);
426 
427         uint256 accountBalance = _balances[account];
428         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
429         unchecked {
430             _balances[account] = accountBalance - amount;
431         }
432         _totalSupply -= amount;
433 
434         emit Transfer(account, address(0), amount);
435 
436         _afterTokenTransfer(account, address(0), amount);
437     }
438 
439     /**
440      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
441      *
442      * This internal function is equivalent to `approve`, and can be used to
443      * e.g. set automatic allowances for certain subsystems, etc.
444      *
445      * Emits an {Approval} event.
446      *
447      * Requirements:
448      *
449      * - `owner` cannot be the zero address.
450      * - `spender` cannot be the zero address.
451      */
452     function _approve(
453         address owner,
454         address spender,
455         uint256 amount
456     ) internal virtual {
457         require(owner != address(0), "ERC20: approve from the zero address");
458         require(spender != address(0), "ERC20: approve to the zero address");
459 
460         _allowances[owner][spender] = amount;
461         emit Approval(owner, spender, amount);
462     }
463 
464     /**
465      * @dev Hook that is called before any transfer of tokens. This includes
466      * minting and burning.
467      *
468      * Calling conditions:
469      *
470      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
471      * will be transferred to `to`.
472      * - when `from` is zero, `amount` tokens will be minted for `to`.
473      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
474      * - `from` and `to` are never both zero.
475      *
476      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
477      */
478     function _beforeTokenTransfer(
479         address from,
480         address to,
481         uint256 amount
482     ) internal virtual {}
483 
484     /**
485      * @dev Hook that is called after any transfer of tokens. This includes
486      * minting and burning.
487      *
488      * Calling conditions:
489      *
490      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
491      * has been transferred to `to`.
492      * - when `from` is zero, `amount` tokens have been minted for `to`.
493      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
494      * - `from` and `to` are never both zero.
495      *
496      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
497      */
498     function _afterTokenTransfer(
499         address from,
500         address to,
501         uint256 amount
502     ) internal virtual {}
503 }
504 
505 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Burnable.sol)
509 
510 pragma solidity 0.8.7;
511 
512 
513 
514 /**
515  * @dev Extension of {ERC20} that allows token holders to destroy both their own
516  * tokens and those that they have an allowance for, in a way that can be
517  * recognized off-chain (via event analysis).
518  */
519 abstract contract ERC20Burnable is Context, ERC20 {
520     /**
521      * @dev Destroys `amount` tokens from the caller.
522      *
523      * See {ERC20-_burn}.
524      */
525     function burn(uint256 amount) public virtual {
526         _burn(_msgSender(), amount);
527     }
528 
529     /**
530      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
531      * allowance.
532      *
533      * See {ERC20-_burn} and {ERC20-allowance}.
534      *
535      * Requirements:
536      *
537      * - the caller must have allowance for ``accounts``'s tokens of at least
538      * `amount`.
539      */
540     function burnFrom(address account, uint256 amount) public virtual {
541         uint256 currentAllowance = allowance(account, _msgSender());
542         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
543         unchecked {
544             _approve(account, _msgSender(), currentAllowance - amount);
545         }
546         _burn(account, amount);
547     }
548 }
549 
550 // File: @openzeppelin/contracts/access/Ownable.sol
551 
552 
553 // File: contracts/lynkey.sol
554 pragma solidity 0.8.7;
555 
556 
557 contract Lynkey is ERC20Burnable {
558     event event_lockSystemWallet(address _caller, address _wallet, uint256 _amountSum, uint256 _startTime, uint8 _forHowManyPeriods, uint256 _periodInSeconds);
559     event event_transferAndLock(address _caller, address _receiver, uint256 _amount, uint256 _releaseTime);
560     event event_transfer_by_admin(address _caller, address _receiver, uint256 _amount);
561     
562     address private _owner;
563 
564     address ecosystemWallet; 
565 	address crowdsaleWallet; 
566 	address stakingRewardWallet;
567 	address reserveLiquidityWallet;
568 	address teamWallet;
569 	address partnerWallet;
570 	
571     // #tokens at at issuance; actual token supply tokenSupply() may be less due to possible future token burning 
572 	uint256 private totalSupplyAtBirth; 
573     
574     struct LockItem {
575         uint256  releaseTime;
576         uint256  amount;
577     }
578     mapping (address => LockItem[]) public lockList;
579     
580     function decimals() public pure override returns (uint8) {
581         return 8;
582     }
583     
584 	constructor() ERC20("LynKey", "LYNK") {  
585 
586         // all these 6 system addresses are Gnosis multi-sig:  
587         
588         crowdsaleWallet = 0x07188d46b305b8183F0c7FA204a7bcbB6C2E59e9;
589 	    ecosystemWallet = 0x9968c39f7D8ea29648203A6043CA1eef51c4e509;
590 	    stakingRewardWallet = 0xfee25971dc356acE41fF004Fd2c8661A5B87C177;
591 	    reserveLiquidityWallet = 0x261f04b695361672210D6F02AD0dC0a371Bb4b1C;
592 	    teamWallet = 0x4eAC98E2f866830440b7E5Fa4e3e78ce0a8516d9;
593 	    partnerWallet = 0x611A909aB6218046872a0438E29f80d067A42d42;
594 	        
595         _owner = msg.sender;
596 
597         totalSupplyAtBirth = 1000000000 * 10 ** uint256(decimals());
598 
599         // allocate tokens to the system main wallets according to the Token Allocation
600         _mint(crowdsaleWallet, totalSupplyAtBirth  * 25/100); // 25% allocation
601         _mint(ecosystemWallet,  totalSupplyAtBirth * 20/100); // 20%
602         _mint(reserveLiquidityWallet,  totalSupplyAtBirth * 23/100); // 23%
603         _mint(teamWallet,  totalSupplyAtBirth * 12/100); // 12%
604         _mint(partnerWallet,  totalSupplyAtBirth * 10/100); // 10%
605         _mint(stakingRewardWallet,  totalSupplyAtBirth * 10/100); // 10%
606         
607         uint256 starttime = block.timestamp;
608         // releasing linearly quarterly for the next 12 quarterly periods (3 years)
609         lockSystemWallet(ecosystemWallet,  totalSupplyAtBirth * 20/100, starttime, 12, 7884000); 
610         lockSystemWallet(reserveLiquidityWallet, totalSupplyAtBirth  * 23/100, starttime, 12, 7884000); 
611         lockSystemWallet(teamWallet, totalSupplyAtBirth  * 12/100, starttime, 12, 7884000); 
612         lockSystemWallet(partnerWallet, totalSupplyAtBirth *  10/100, starttime, 12, 7884000); 
613         lockSystemWallet(stakingRewardWallet, totalSupplyAtBirth *  10/100, starttime, 12, 7884000); 
614 
615     }
616 
617     /**
618      * @dev allocate tokens and lock to release periodically
619      * allocate tokens from owner to system wallets when smart contract is deployed
620      */
621     function lockSystemWallet(address _wallet, uint256 _amountSum, uint256 _startTime, uint8 _forHowManyPeriods, uint256 _periodInSeconds) private {        
622         uint256 amount = _amountSum/_forHowManyPeriods;
623         for(uint8 i = 0; i< _forHowManyPeriods; i++) {
624             uint256 releaseTime = _startTime + uint256(i)*_periodInSeconds; 
625             if (i==_forHowManyPeriods-1) {
626                 // last month includes all the rest
627                 amount += (_amountSum - amount * _forHowManyPeriods); // all the rest
628             }
629     	    lockFund(_wallet, amount, releaseTime);
630          }
631          emit event_lockSystemWallet(msg.sender, _wallet,  _amountSum,  _startTime,  _forHowManyPeriods,  _periodInSeconds);
632     }
633 
634 	
635 	/**
636      * @dev Returns the address of the current owner.
637      */
638     function owner() external view returns (address) {
639         return _owner;
640     }
641 	
642 	receive () payable external {   
643         revert();
644     }
645     
646     fallback () payable external {   
647         revert();
648     }
649     
650     
651     /**
652      * @dev check if this address is one of the system's reserve wallets
653      * @return the bool true if success.
654      * @param _addr The address to verify.
655      */
656     function isAdminWallet(address _addr) private view returns (bool) {
657         return (
658             _addr == crowdsaleWallet || 
659             _addr == ecosystemWallet ||
660             _addr == stakingRewardWallet ||
661             _addr == reserveLiquidityWallet ||
662             _addr == teamWallet ||
663             _addr == partnerWallet 
664         );
665     }
666     
667      /**
668      * @dev transfer of token to another address.
669      * always require the sender has enough balance
670      * @return the bool true if success. 
671      * @param _receiver The address to transfer to.
672      * @param _amount The amount to be transferred.
673      */
674      
675 	function transfer(address _receiver, uint256 _amount) public override returns (bool) {
676 	    require(_amount > 0, "amount must be larger than 0");
677         require(_receiver != address(0), "cannot send to the zero address");
678         require(msg.sender != _receiver, "receiver cannot be the same as sender");
679 	    require(_amount <= getAvailableBalance(msg.sender), "not enough enough fund to transfer");
680 
681         if (isAdminWallet(msg.sender)) {
682             emit event_transfer_by_admin(msg.sender, _receiver, _amount);
683         }
684         return ERC20.transfer(_receiver, _amount);
685 	}
686 	
687 	/**
688      * @dev transfer of token on behalf of the owner to another address. 
689      * always require the owner has enough balance and the sender is allowed to transfer the given amount
690      * @return the bool true if success. 
691      * @param _from The address to transfer from.
692      * @param _receiver The address to transfer to.
693      * @param _amount The amount to be transferred.
694      */
695     function transferFrom(address _from, address _receiver, uint256 _amount) public override  returns (bool) {
696         require(_amount > 0, "amount must be larger than 0");
697         require(_receiver != address(0), "cannot send to the zero address");
698         require(_from != _receiver, "receiver cannot be the same as sender");
699         require(_amount <= getAvailableBalance(_from), "not enough enough fund to transfer");
700         return ERC20.transferFrom(_from, _receiver, _amount);
701     }
702 
703     /**
704      * @dev transfer to a given address a given amount and lock this fund until a given time
705      * used by system wallets for sending fund to team members, partners, etc who needs to be locked for certain time
706      * @return the bool true if success.
707      * @param _receiver The address to transfer to.
708      * @param _amount The amount to transfer.
709      * @param _releaseTime The date to release token.
710      */
711 	
712 	function transferAndLock(address _receiver, uint256 _amount, uint256 _releaseTime) external  returns (bool) {
713 	    require(isAdminWallet(msg.sender), "Only system wallets can have permission to transfer and lock");
714 	    require(_amount > 0, "amount must be larger than 0");
715         require(_receiver != address(0), "cannot send to the zero address");
716         require(msg.sender != _receiver, "receiver cannot be the same as sender");
717         require(_amount <= getAvailableBalance(msg.sender), "not enough enough fund to transfer");
718         
719 	    ERC20.transfer(_receiver,_amount);
720     	lockFund(_receiver, _amount, _releaseTime);
721 		
722         emit event_transferAndLock(msg.sender, _receiver,   _amount,   _releaseTime);
723 
724         return true;
725 	}
726 	
727 	
728 	/**
729      * @dev set a lock to free a given amount only to release at given time
730      */
731 	function lockFund(address _addr, uint256 _amount, uint256 _releaseTime) private {
732     	LockItem memory item = LockItem({amount:_amount, releaseTime:_releaseTime});
733 		lockList[_addr].push(item);
734 	} 
735 	
736 	
737     /**
738      * @return the total amount of locked funds of a given address.
739      * @param lockedAddress The address to check.
740      */
741 	function getLockedAmount(address lockedAddress) private view returns(uint256) {
742 	    uint256 lockedAmount =0;
743 	    for(uint256 j = 0; j<lockList[lockedAddress].length; j++) {
744 	        if(block.timestamp < lockList[lockedAddress][j].releaseTime) {
745 	            uint256 temp = lockList[lockedAddress][j].amount;
746 	            lockedAmount += temp;
747 	        }
748 	    }
749 	    return lockedAmount;
750 	}
751 	
752 	/**
753      * @return the total amount of locked funds of a given address.
754      * @param lockedAddress The address to check.
755      */
756 	function getAvailableBalance(address lockedAddress) public view returns(uint256) {
757 	    uint256 bal = balanceOf(lockedAddress);
758 	    uint256 locked = getLockedAmount(lockedAddress);
759         if (bal <= locked) return 0;
760 	    return bal-locked;
761 	}
762 
763 	    
764 }