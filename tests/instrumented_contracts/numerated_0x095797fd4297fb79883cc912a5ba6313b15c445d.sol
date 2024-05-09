1 /**
2  *Submitted for verification at BscScan.com on 2022-08-18
3 */
4 
5 /**
6  *Submitted for verification at BscScan.com on 2022-08-18
7 // */
8 //                   TOKENOMICS 
9 // ERC Wallet	       percentage	        amount
10 // Agartha	            24.14%	         GOL17,500,000.00
11 // Mining	            15.52%	         GOL11,250,000.00
12 // NFT	                17.24%	         GOL12,500,000.00
13 // Gol Blockchain	    27.59%	         GOL20,000,000.00
14 // Rest	                15.52%	         GOL11,250,000.00
15 // total ERC wallet	    25.00%	         GOL72,500,000.00
16 
17 
18 
19 
20 
21 
22 
23 
24 // ///File: contracts/IERC20.sol
25 
26 // SPDX-License-Identifier: MIT
27 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the name of the token.
37      */
38     function name() external view returns (string memory);
39 
40     /**
41      * @dev Returns the symbol of the token.
42      */
43     function symbol() external view returns (string memory);
44 
45     /**
46      * @dev Returns the decimals places of the token.
47      */
48     function decimals() external view returns (uint8);
49     
50     /**
51      * @dev Returns the amount of tokens in existence.
52      */
53     function totalSupply() external view returns (uint256);
54 
55     /**
56      * @dev Returns the amount of tokens owned by `account`.
57      */
58     function balanceOf(address account) external view returns (uint256);
59 
60     /**
61      * @dev Moves `amount` tokens from the caller's account to `to`.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transfer(address to, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Returns the remaining number of tokens that `spender` will be
71      * allowed to spend on behalf of `owner` through {transferFrom}. This is
72      * zero by default.
73      *
74      * This value changes when {approve} or {transferFrom} are called.
75      */
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     /**
79      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * IMPORTANT: Beware that changing an allowance with this method brings the risk
84      * that someone may use both the old and the new allowance by unfortunate
85      * transaction ordering. One possible solution to mitigate this race
86      * condition is to first reduce the spender's allowance to 0 and set the
87      * desired value afterwards:
88      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89      *
90      * Emits an {Approval} event.
91      */
92     function approve(address spender, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Moves `amount` tokens from `from` to `to` using the
96      * allowance mechanism. `amount` is then deducted from the caller's
97      * allowance.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(address from, address to, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Emitted when `value` tokens are moved from one account (`from`) to
107      * another (`to`).
108      *
109      * Note that `value` may be zero.
110      */
111     event Transfer(address indexed from, address indexed to, uint256 value);
112 
113     /**
114      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
115      * a call to {approve}. `value` is the new allowance.
116      */
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // File: contracts/Context.sol
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
123 
124 pragma solidity ^0.8.0;
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
146 // File: contracts/Errors.sol
147 
148 
149 pragma solidity ^0.8.0;
150 
151 library Errors {
152     string constant MINT_DISABLED = "Token: Minting is disabled";
153     string constant BURN_DISABLED = "Token: Burning is disabled";
154     string constant MINT_ALREADY_ENABLED = "Token: Minting is already enabled";
155     string constant MINT_ALREADY_DISABLED = "Token: Minting is already disabled";
156     string constant BURN_ALREADY_ENABLED = "Token: Burning is already enabled";
157     string constant BURN_ALREADY_DISABLED = "Token: Burning is already disabled";
158     string constant NON_ZERO_ADDRESS = "Token: Address can not be 0x0";
159     string constant NOT_APPROVED = "Token: You are not approved to spend this amount of tokens";
160     string constant TRANSFER_EXCEEDS_BALANCE = "Token: Transfer amount exceeds balance";
161     string constant BURN_EXCEEDS_BALANCE = "Token: Burn amount exceeds balance";
162     string constant INSUFFICIENT_ALLOWANCE = "Token: Insufficient allowance";
163     string constant NOTHING_TO_WITHDRAW = "Token: The balance must be greater than 0";
164     string constant ALLOWANCE_BELOW_ZERO = "Token: Decreased allowance below zero";
165     string constant ABOVE_CAP = "Token: Amount is above the cap";
166 
167     string constant NOT_OWNER = "Ownable: Caller is not the owner";
168     string constant OWNABLE_NON_ZERO_ADDRESS = "Ownable: Address can not be 0x0";
169 
170     string constant NOT_ORACLE_OR_HANDLER = "Oracle: Caller is not the oracle or handler";
171     string constant ADDRESS_IS_HANDLER = "Oracle: Address is already a Bridge Handler";
172     string constant ADDRESS_IS_NOT_HANDLER = "Oracle: Address is not a Bridge Handler";
173     string constant TOKEN_NOT_ALLOWED_IN_BRIDGE = "Oracle: Your token is not allowed in JM Bridge";
174     string constant SET_HANDLER_ORACLE_FIRST = "Oracle: Set the handler oracle address first";
175     string constant ORACLE_NOT_SET = "Oracle: No oracle set";
176     string constant IS_NOT_ORACLE = "Oracle: You are not the oracle";
177     string constant NOT_ALLOWED_TO_EDIT_ORACLE = "Oracle: Not allowed to edit the Handler Oracle address";
178     string constant NON_ZERO_ADDRESS_SENDER = "Oracle: Sender can not be 0x0";
179 }
180 
181 // File: contracts/Ownable.sol
182 
183 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 
188 /**
189  * @dev Contract module which provides a basic access control mechanism, where
190  * there is an account (an owner) that can be granted exclusive access to
191  * specific functions.
192  *
193  * By default, the owner account will be the one that deploys the contract. This
194  * can later be changed with {transferOwnership}.
195  *
196  * This module is used through inheritance. It will make available the modifier
197  * `onlyOwner`, which can be applied to your functions to restrict their use to
198  * the owner.
199  */
200 abstract contract Ownable is Context {
201     address private _owner;
202 
203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
204     
205     /**
206      * @dev Initializes the contract setting the deployer as the initial owner.
207      */
208     constructor() {
209         _transferOwnership(_msgSender());
210     }
211 
212     /**
213      * @dev Returns the address of the current owner.
214      */
215     function owner() public view virtual returns (address) {
216         return _owner;
217     }
218 
219     /**
220      * @dev Throws if called by any account other than the owner.
221      */
222     modifier onlyOwner() {
223         require(owner() == _msgSender(), Errors.NOT_OWNER);
224         _;
225     }
226 
227     /**
228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
229      * Can only be called by the current owner.
230      */
231     function transferOwnership(address newOwner) public virtual onlyOwner {
232         require(newOwner != address(0), Errors.OWNABLE_NON_ZERO_ADDRESS);
233         _transferOwnership(newOwner);
234     }
235 
236     /**
237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
238      * Internal function without access restriction.
239      */
240     function _transferOwnership(address newOwner) internal virtual {
241         address oldOwner = _owner;
242         _owner = newOwner;
243         emit OwnershipTransferred(oldOwner, newOwner);
244     }
245 }
246 
247 // File: contracts/BridgeOracle.sol
248 
249 
250 pragma solidity ^0.8.0;
251 
252 interface HandlerOracle {
253     function approveHandlerChange() external returns (bool);
254     function approveManualMint() external returns (bool);
255     function isTokenContract(address tokenContract) external view returns (bool);
256     function isAllowedToChangeOracle(address tokenContract) external view returns (bool);
257 }
258 
259 abstract contract BridgeOracle is Ownable {
260     HandlerOracle internal _handlerOracle;
261     address private _bridgeHandler;
262 
263     event BridgeHandlerSet(address indexed added);
264 
265     /**
266      * @dev Returns true if the address is a bridge handler.
267      */
268     function isBridgeHandler(address account) public view returns (bool) {
269         return _bridgeHandler == account;
270     }
271     
272     /**
273      * @dev Throws if called by any account other than the oracle or a bridge handler.
274      */
275     modifier onlyOracleAndBridge() {
276         require(_msgSender() != address(0), Errors.NON_ZERO_ADDRESS_SENDER);
277         require(isBridgeHandler(_msgSender()) || address(_handlerOracle) == _msgSender(), Errors.NOT_ORACLE_OR_HANDLER);
278         _;
279     }
280     
281     modifier onlyHandlerOracle() {
282         require(_msgSender() != address(0), Errors.ORACLE_NOT_SET);
283         require(_msgSender() == address(_handlerOracle), Errors.IS_NOT_ORACLE);
284         _;
285     }
286 
287     function approveOracleToSetHandler() public onlyOwner returns (bool) {
288         require(address(_handlerOracle) != address(0), Errors.SET_HANDLER_ORACLE_FIRST);
289         require(_handlerOracle.isTokenContract(address(this)) == true, Errors.TOKEN_NOT_ALLOWED_IN_BRIDGE);
290 
291         return _handlerOracle.approveHandlerChange();
292     }
293     
294     function approveOracleToManualMint() public onlyOwner returns (bool) {
295         require(address(_handlerOracle) != address(0), Errors.SET_HANDLER_ORACLE_FIRST);
296         require(_handlerOracle.isTokenContract(address(this)) == true, Errors.TOKEN_NOT_ALLOWED_IN_BRIDGE);
297 
298         return _handlerOracle.approveManualMint();
299     }
300 
301     /**
302      * @dev Add handler address (`account`) that can mint and burn.
303      * Can only be called by the 'Handler Oracle Contract' after it was approved.
304      */
305     function setBridgeHandler(address account) public onlyHandlerOracle {
306         require(account != address(0), Errors.OWNABLE_NON_ZERO_ADDRESS);
307         require(!isBridgeHandler(account), Errors.ADDRESS_IS_HANDLER);
308 
309         emit BridgeHandlerSet(account);
310         _bridgeHandler = account;
311     }
312 
313     function setHandlerOracle(address newHandlerOracle) public onlyOwner {
314         require(HandlerOracle(newHandlerOracle).isTokenContract(address(this)) == true, Errors.TOKEN_NOT_ALLOWED_IN_BRIDGE);
315 
316         if ( address(_handlerOracle) == address(0) ) {
317             _handlerOracle = HandlerOracle(newHandlerOracle);
318         } else {
319             require(_handlerOracle.isAllowedToChangeOracle(address(this)) == true, Errors.NOT_ALLOWED_TO_EDIT_ORACLE);
320 
321             _handlerOracle = HandlerOracle(newHandlerOracle);
322         }
323     }
324 }
325 
326 // File: contracts/GOLCOIN.sol
327 
328 // @Title GOLCOIN Bridged Token
329 // @Author Team GOLCOIN
330 
331 pragma solidity ^0.8.0;
332 
333 
334 /**
335  * @dev Implementation of the {IERC20} interface.
336  *
337  * This implementation is agnostic to the way tokens are created. This means
338  * that a supply mechanism has to be added in a derived contract using {_mint}.
339  * For a generic mechanism see {ERC20PresetMinterPauser}.
340  *
341  * TIP: For a detailed writeup see our guide
342  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
343  * to implement supply mechanisms].
344  *
345  * We have followed general OpenZeppelin Contracts guidelines: functions revert
346  * instead returning `false` on failure. This behavior is nonetheless
347  * conventional and does not conflict with the expectations of ERC20
348  * applications.
349  *
350  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
351  * This allows applications to reconstruct the allowance for all accounts just
352  * by listening to said events. Other implementations of the EIP may not emit
353  * these events, as it isn't required by the specification.
354  *
355  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
356  * functions have been added to mitigate the well-known issues around setting
357  * allowances. See {IERC20-approve}.
358  */
359 contract GOLCOIN is BridgeOracle, IERC20 {
360     mapping(address => uint256) private _balances;
361 
362     mapping(address => mapping(address => uint256)) private _allowances;
363 
364     uint256 private constant _max = 290000000 * 10**18;
365     uint256 private _totalSupply;
366     uint256 private _totalBurned;
367 
368     bool public isMintingEnabled = false;
369     bool public isBurningEnabled = true;
370     
371     string private _name = "GOLCOIN";
372     string private _symbol = "GOLC";
373     uint8 private _decimals = 18;
374 
375     constructor() {
376         uint256 initialAmount = 72500000 * 10**18;
377         _totalSupply = initialAmount;
378         _balances[_msgSender()] = initialAmount;
379     }
380 
381     modifier mintingEnabled() {
382         require(isMintingEnabled, Errors.MINT_DISABLED);
383         _;
384     }
385     
386     modifier burningEnabled() {
387         require(isBurningEnabled, Errors.BURN_DISABLED);
388         _;
389     }
390     
391     modifier nonZeroAddress(address _account) {
392         require(_account != address(0), Errors.NON_ZERO_ADDRESS);
393         _;
394     }
395     
396     modifier belowCap(uint256 amount) {
397         require(amount <= (_max - _totalSupply - _totalBurned), Errors.ABOVE_CAP);
398         _;
399     }
400 
401     /**
402      * @dev Returns the name of the token.
403      */
404     function name() public view override returns (string memory) {
405         return _name;
406     }
407 
408     /**
409      * @dev Returns the symbol of the token, usually a shorter version of the
410      * name.
411      */
412     function symbol() public view override returns (string memory) {
413         return _symbol;
414     }
415 
416     /**
417      * @dev Returns the number of decimals used to get its user representation.
418      * For example, if `decimals` equals `2`, a balance of `505` tokens should
419      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
420      *
421      * Tokens usually opt for a value of 18, imitating the relationship between
422      * Ether and Wei. This is the value {ERC20} uses, unless this function is
423      * overridden;
424      *
425      * NOTE: This information is only used for _display_ purposes: it in
426      * no way affects any of the arithmetic of the contract, including
427      * {IERC20-balanceOf} and {IERC20-transfer}.
428      */
429     function decimals() public view override returns (uint8) {
430         return _decimals;
431     }
432 
433     /**
434      * @dev See {IERC20-totalSupply}.
435      */
436     function totalSupply() public view override returns (uint256) {
437         return _totalSupply;
438     }
439 
440     function totalBurned() public view returns (uint256) {
441         return _totalBurned;
442     }
443 
444     /**
445      * @dev See {IERC20-balanceOf}.
446      */
447     function balanceOf(address account) public view override returns (uint256) {
448         return _balances[account];
449     }
450     
451     /**
452      * @dev See {IERC20-transfer}.
453      *
454      * Requirements:
455      *
456      * - `to` cannot be the zero address.
457      * - the caller must have a balance of at least `amount`.
458      */
459     function transfer(address to, uint256 amount) public override returns (bool) {
460         address owner = _msgSender();
461         _transfer(owner, to, amount);
462         return true;
463     }
464 
465     /**
466      * @dev See {IERC20-allowance}.
467      */
468     function allowance(address owner, address spender) public view override returns (uint256) {
469         return _allowances[owner][spender];
470     }
471 
472     /**
473      * @dev See {IERC20-approve}.
474      *
475      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
476      * `transferFrom`. This is semantically equivalent to an infinite approval.
477      *
478      * Requirements:
479      *
480      * - `spender` cannot be the zero address.
481      */
482     function approve(address spender, uint256 amount) public override returns (bool) {
483         address owner = _msgSender();
484         _approve(owner, spender, amount);
485         return true;
486     }
487 
488     /**
489      * @dev See {IERC20-transferFrom}.
490      *
491      * Emits an {Approval} event indicating the updated allowance. This is not
492      * required by the EIP. See the note at the beginning of {ERC20}.
493      *
494      * NOTE: Does not update the allowance if the current allowance
495      * is the maximum `uint256`.
496      *
497      * Requirements:
498      *
499      * - `from` and `to` cannot be the zero address.
500      * - `from` must have a balance of at least `amount`.
501      * - the caller must have allowance for ``from``'s tokens of at least
502      * `amount`.
503      */
504     function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
505         address spender = _msgSender();
506         require(amount <= _allowances[from][spender], Errors.NOT_APPROVED);
507         
508         _spendAllowance(from, spender, amount);
509         _transfer(from, to, amount);
510         return true;
511     }
512 
513     /**
514      * @dev Atomically increases the allowance granted to `spender` by the caller.
515      *
516      * This is an alternative to {approve} that can be used as a mitigation for
517      * problems described in {IERC20-approve}.
518      *
519      * Emits an {Approval} event indicating the updated allowance.
520      *
521      * Requirements:
522      *
523      * - `spender` cannot be the zero address.
524      */
525     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
526         address owner = _msgSender();
527         _approve(owner, spender, _allowances[owner][spender] + addedValue);
528         return true;
529     }
530 
531     /**
532      * @dev Atomically decreases the allowance granted to `spender` by the caller.
533      *
534      * This is an alternative to {approve} that can be used as a mitigation for
535      * problems described in {IERC20-approve}.
536      *
537      * Emits an {Approval} event indicating the updated allowance.
538      *
539      * Requirements:
540      *
541      * - `spender` cannot be the zero address.
542      * - `spender` must have allowance for the caller of at least
543      * `subtractedValue`.
544      */
545     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
546         address owner = _msgSender();
547         uint256 currentAllowance = _allowances[owner][spender];
548         require(currentAllowance >= subtractedValue, Errors.ALLOWANCE_BELOW_ZERO);
549         unchecked {
550             _approve(owner, spender, currentAllowance - subtractedValue);
551         }
552 
553         return true;
554     }
555     
556     function enableMinting() public onlyHandlerOracle returns (string memory retMsg) {
557         require(!isMintingEnabled, Errors.MINT_ALREADY_ENABLED);
558         
559         isMintingEnabled = true;
560         emit MintingEnabled();
561         retMsg = "Enabled Minting";
562     }
563 
564     function disableMinting() public onlyHandlerOracle returns (string memory retMsg) {
565         require(isMintingEnabled, Errors.MINT_ALREADY_DISABLED);
566         
567         isMintingEnabled = false;
568         emit MintingDisabled();
569         retMsg = "Disabled Minting";
570     }
571     
572     function enableBurning() public onlyHandlerOracle returns (string memory retMsg) {
573         require(!isBurningEnabled, Errors.BURN_ALREADY_ENABLED);
574         
575         isBurningEnabled = true;
576         emit BurningEnabled();
577         retMsg = "Enabled Burning";
578     }
579 
580     function disableBurning() public onlyHandlerOracle returns (string memory retMsg) {
581         require(isBurningEnabled, Errors.BURN_ALREADY_DISABLED);
582         
583         isBurningEnabled = false;
584         emit BurningDisabled();
585         retMsg = "Disabled Burning";
586     }
587     
588     /**
589      * @dev Moves `amount` of tokens from `sender` to `recipient`.
590      *
591      * This internal function is equivalent to {transfer}, and can be used to
592      * e.g. implement automatic token fees, slashing mechanisms, etc.
593      *
594      * Emits a {Transfer} event.
595      *
596      * Requirements:
597      *
598      * - `from` cannot be the zero address.
599      * - `to` cannot be the zero address.
600      * - `from` must have a balance of at least `amount`.
601      */
602     function _transfer(address from, address to, uint256 amount) internal nonZeroAddress(from) nonZeroAddress(to) {
603         uint256 fromBalance = _balances[from];
604         require(fromBalance >= amount, Errors.TRANSFER_EXCEEDS_BALANCE);
605         unchecked { _balances[from] = fromBalance - amount; }
606         _balances[to] += amount;
607 
608         emit Transfer(from, to, amount);
609     }
610     
611     /**
612      * @dev Creates `amount` new tokens for `to`.
613      *
614      * See {ERC20-_mint}.
615      *
616      * Requirements:
617      *
618      * - the caller must be the bridge or owner.
619      */
620     function mint(address to, uint256 amount) public onlyOracleAndBridge {
621         _mint(to, amount);
622     }
623 
624     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
625      * the total supply.
626      *
627      * Emits a {Transfer} event with `from` set to the zero address.
628      *
629      * Requirements:
630      *
631      * - minting and burning must be enabled.
632      * - `account` cannot be the zero address.
633      */
634     function _mint(address account, uint256 amount) internal mintingEnabled nonZeroAddress(account) belowCap(amount) {
635         _totalSupply += amount;
636         _balances[account] += amount;
637         emit Transfer(address(0), account, amount);
638 
639         address mintBy = _msgSender();
640         if ( isBridgeHandler(mintBy) ) {
641             emit BridgeMint(mintBy, account, amount);
642         } else {
643             emit ManualMint(mintBy, account, amount);
644         }
645     }
646     
647     /**
648      * @dev Destroys `amount` tokens from `account`, reducing the
649      * total supply.
650      *
651      * Emits a {Transfer} event with `to` set to the zero address.
652      *
653      * Requirements:
654      *
655      * - `account` cannot be the zero address.
656      * - `account` must have at least `amount` tokens.
657      */
658     function _burn(address account, uint256 amount) internal burningEnabled nonZeroAddress(account) {
659         uint256 accountBalance = _balances[account];
660         require(accountBalance >= amount, Errors.BURN_EXCEEDS_BALANCE);
661         unchecked { _balances[account] = accountBalance - amount; }
662         _totalSupply -= amount;
663 
664         emit Transfer(account, address(0), amount);
665 
666         address burnBy = _msgSender();
667         if ( isBridgeHandler(burnBy) || burnBy == address(_handlerOracle) ) {
668             emit BridgeBurn(account, burnBy, amount);
669         } else {
670             unchecked { _totalBurned += amount; }
671             emit NormalBurn(account, burnBy, amount);
672         }
673     }
674     
675     /**
676      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
677      *
678      * This private function is equivalent to `approve`, and can be used to
679      * e.g. set automatic allowances for certain subsystems, etc.
680      *
681      * Emits an {Approval} event.
682      *
683      * Requirements:
684      *
685      * - `owner` cannot be the zero address.
686      * - `spender` cannot be the zero address.
687      */
688     function _approve(address owner, address spender, uint256 amount) private nonZeroAddress(owner) nonZeroAddress(spender) {
689         _allowances[owner][spender] = amount;
690         emit Approval(owner, spender, amount);
691     }
692 
693     /**
694      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
695      *
696      * Does not update the allowance amount in case of infinite allowance.
697      * Revert if not enough allowance is available.
698      *
699      * Might emit an {Approval} event.
700      */
701     function _spendAllowance(address owner, address spender, uint256 amount) internal {
702         uint256 currentAllowance = allowance(owner, spender);
703         if (currentAllowance != type(uint256).max) {
704             require(currentAllowance >= amount, Errors.INSUFFICIENT_ALLOWANCE);
705             unchecked {
706                 _approve(owner, spender, currentAllowance - amount);
707             }
708         }
709     }
710     
711     /**
712      * @dev Destroys `amount` tokens from the caller.
713      *
714      * See {ERC20-_burn}.
715      */
716     function burn(uint256 amount) public {
717         _burn(_msgSender(), amount);
718     }
719 
720     
721     /**
722      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
723      * allowance.
724      *
725      * See {ERC20-_burn} and {ERC20-allowance}.
726      *
727      * Requirements:
728      *
729      * - the caller must have allowance for ``accounts``'s tokens of at least
730      * `amount`.
731      */
732     function burnFrom(address account, uint256 amount) public {
733         require(amount <= _allowances[account][_msgSender()], Errors.NOT_APPROVED);
734         
735         _spendAllowance(account, _msgSender(), amount);
736         _burn(account, amount);
737     }
738     
739     function withdrawBASE(address payable recipient) external onlyOwner nonZeroAddress(recipient) {
740         require(address(this).balance > 0, Errors.NOTHING_TO_WITHDRAW);
741 
742         recipient.transfer(address(this).balance);
743     }
744 
745     function withdrawERC20token(address _token, address payable recipient) external onlyOwner nonZeroAddress(recipient) returns (bool) {
746         uint256 bal = IERC20(_token).balanceOf(address(this));
747         require(bal > 0, Errors.NOTHING_TO_WITHDRAW);
748 
749         return IERC20(_token).transfer(recipient, bal);
750     }
751 
752 
753     
754     event BridgeMint(address indexed by, address indexed to, uint256 value);
755     event ManualMint(address indexed by, address indexed to, uint256 value);
756     event BridgeBurn(address indexed from, address indexed by, uint256 value);
757     event NormalBurn(address indexed from, address indexed to, uint256 value);
758     event MintingEnabled();
759     event MintingDisabled();
760     event BurningEnabled();
761     event BurningDisabled();
762 }