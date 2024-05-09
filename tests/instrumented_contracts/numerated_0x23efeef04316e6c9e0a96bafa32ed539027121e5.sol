1 // SPDX-License-Identifier: MIT
2 
3 /**
4  *       $$$$$                                                                                                              
5  *       $:::$                                                                                                              
6  *   $$$$$:::$$$$$$ BBBBBBBBBBBBBBBBB        OOOOOOOOO     NNNNNNNN        NNNNNNNNEEEEEEEEEEEEEEEEEEEEEE   SSSSSSSSSSSSSSS 
7  * $$::::::::::::::$B::::::::::::::::B     OO:::::::::OO   N:::::::N       N::::::NE::::::::::::::::::::E SS:::::::::::::::S
8  *$:::::$$$$$$$::::$B::::::BBBBBB:::::B  OO:::::::::::::OO N::::::::N      N::::::NE::::::::::::::::::::ES:::::SSSSSS::::::S
9  *$::::$       $$$$$BB:::::B     B:::::BO:::::::OOO:::::::ON:::::::::N     N::::::NEE::::::EEEEEEEEE::::ES:::::S     SSSSSSS
10  *$::::$              B::::B     B:::::BO::::::O   O::::::ON::::::::::N    N::::::N  E:::::E       EEEEEES:::::S            
11  *$::::$              B::::B     B:::::BO:::::O     O:::::ON:::::::::::N   N::::::N  E:::::E             S:::::S            
12  *$:::::$$$$$$$$$     B::::BBBBBB:::::B O:::::O     O:::::ON:::::::N::::N  N::::::N  E::::::EEEEEEEEEE    S::::SSSS         
13  * $$::::::::::::$$   B:::::::::::::BB  O:::::O     O:::::ON::::::N N::::N N::::::N  E:::::::::::::::E     SS::::::SSSSS    
14  *   $$$$$$$$$:::::$  B::::BBBBBB:::::B O:::::O     O:::::ON::::::N  N::::N:::::::N  E:::::::::::::::E       SSS::::::::SS  
15  *            $::::$  B::::B     B:::::BO:::::O     O:::::ON::::::N   N:::::::::::N  E::::::EEEEEEEEEE          SSSSSS::::S 
16  *            $::::$  B::::B     B:::::BO:::::O     O:::::ON::::::N    N::::::::::N  E:::::E                         S:::::S
17  *$$$$$       $::::$  B::::B     B:::::BO::::::O   O::::::ON::::::N     N:::::::::N  E:::::E       EEEEEE            S:::::S
18  *$::::$$$$$$$:::::$BB:::::BBBBBB::::::BO:::::::OOO:::::::ON::::::N      N::::::::NEE::::::EEEEEEEE:::::ESSSSSSS     S:::::S
19  *$::::::::::::::$$ B:::::::::::::::::B  OO:::::::::::::OO N::::::N       N:::::::NE::::::::::::::::::::ES::::::SSSSSS:::::S
20  * $$$$$$:::$$$$$   B::::::::::::::::B     OO:::::::::OO   N::::::N        N::::::NE::::::::::::::::::::ES:::::::::::::::SS 
21  *      $:::$       BBBBBBBBBBBBBBBBB        OOOOOOOOO     NNNNNNNN         NNNNNNNEEEEEEEEEEEEEEEEEEEEEE SSSSSSSSSSSSSSS   
22  *      $$$$$                                                                                                               
23  *            
24  *     .-.
25  *    (o.o)
26  *     |=|
27  *    __|__
28  *  //.=|=.\\
29  * // .=|=. \\
30  * \\ .=|=. //
31  *  \\(_=_)//
32  *   (:| |:)
33  *    || ||
34  *    () ()
35  *    || ||
36  *    || ||
37  *   ==' '==                                                                                                              
38  *                                                                                                                                                                                                                                                 
39  * 
40  * $BONES is NOT an investment vehicle and holds no economic or monetary value. 
41  * The sole purpose of $BONES is to allow functionality within the Spectral Skellies Ecosystem.
42  * 
43  * Dev: @White_Oak_Kong
44  * Contract inspiration from CryptoHoots TWIGS
45  */
46 
47 
48 // File: @openzeppelin/contracts/utils/Context.sol
49 
50 
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Provides information about the current execution context, including the
56  * sender of the transaction and its data. While these are generally available
57  * via msg.sender and msg.data, they should not be accessed in such a direct
58  * manner, since when dealing with meta-transactions the account sending and
59  * paying for execution may not be the actual sender (as far as an application
60  * is concerned).
61  *
62  * This contract is only required for intermediate, library-like contracts.
63  */
64 abstract contract Context {
65     function _msgSender() internal view virtual returns (address) {
66         return msg.sender;
67     }
68 
69     function _msgData() internal view virtual returns (bytes calldata) {
70         return msg.data;
71     }
72 }
73 
74 // File: @openzeppelin/contracts/access/Ownable.sol
75 
76 
77 
78 pragma solidity ^0.8.0;
79 
80 
81 /**
82  * @dev Contract module which provides a basic access control mechanism, where
83  * there is an account (an owner) that can be granted exclusive access to
84  * specific functions.
85  *
86  * By default, the owner account will be the one that deploys the contract. This
87  * can later be changed with {transferOwnership}.
88  *
89  * This module is used through inheritance. It will make available the modifier
90  * `onlyOwner`, which can be applied to your functions to restrict their use to
91  * the owner.
92  */
93 abstract contract Ownable is Context {
94     address private _owner;
95 
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     /**
99      * @dev Initializes the contract setting the deployer as the initial owner.
100      */
101     constructor() {
102         _setOwner(_msgSender());
103     }
104 
105     /**
106      * @dev Returns the address of the current owner.
107      */
108     function owner() public view virtual returns (address) {
109         return _owner;
110     }
111 
112     /**
113      * @dev Throws if called by any account other than the owner.
114      */
115     modifier onlyOwner() {
116         require(owner() == _msgSender(), "Ownable: caller is not the owner");
117         _;
118     }
119 
120     /**
121      * @dev Leaves the contract without owner. It will not be possible to call
122      * `onlyOwner` functions anymore. Can only be called by the current owner.
123      *
124      * NOTE: Renouncing ownership will leave the contract without an owner,
125      * thereby removing any functionality that is only available to the owner.
126      */
127     function renounceOwnership() public virtual onlyOwner {
128         _setOwner(address(0));
129     }
130 
131     /**
132      * @dev Transfers ownership of the contract to a new account (`newOwner`).
133      * Can only be called by the current owner.
134      */
135     function transferOwnership(address newOwner) public virtual onlyOwner {
136         require(newOwner != address(0), "Ownable: new owner is the zero address");
137         _setOwner(newOwner);
138     }
139 
140     function _setOwner(address newOwner) private {
141         address oldOwner = _owner;
142         _owner = newOwner;
143         emit OwnershipTransferred(oldOwner, newOwner);
144     }
145 }
146 
147 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
148 
149 
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Interface of the ERC20 standard as defined in the EIP.
155  */
156 interface IERC20 {
157     /**
158      * @dev Returns the amount of tokens in existence.
159      */
160     function totalSupply() external view returns (uint256);
161 
162     /**
163      * @dev Returns the amount of tokens owned by `account`.
164      */
165     function balanceOf(address account) external view returns (uint256);
166 
167     /**
168      * @dev Moves `amount` tokens from the caller's account to `recipient`.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * Emits a {Transfer} event.
173      */
174     function transfer(address recipient, uint256 amount) external returns (bool);
175 
176     /**
177      * @dev Returns the remaining number of tokens that `spender` will be
178      * allowed to spend on behalf of `owner` through {transferFrom}. This is
179      * zero by default.
180      *
181      * This value changes when {approve} or {transferFrom} are called.
182      */
183     function allowance(address owner, address spender) external view returns (uint256);
184 
185     /**
186      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * IMPORTANT: Beware that changing an allowance with this method brings the risk
191      * that someone may use both the old and the new allowance by unfortunate
192      * transaction ordering. One possible solution to mitigate this race
193      * condition is to first reduce the spender's allowance to 0 and set the
194      * desired value afterwards:
195      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196      *
197      * Emits an {Approval} event.
198      */
199     function approve(address spender, uint256 amount) external returns (bool);
200 
201     /**
202      * @dev Moves `amount` tokens from `sender` to `recipient` using the
203      * allowance mechanism. `amount` is then deducted from the caller's
204      * allowance.
205      *
206      * Returns a boolean value indicating whether the operation succeeded.
207      *
208      * Emits a {Transfer} event.
209      */
210     function transferFrom(
211         address sender,
212         address recipient,
213         uint256 amount
214     ) external returns (bool);
215 
216     /**
217      * @dev Emitted when `value` tokens are moved from one account (`from`) to
218      * another (`to`).
219      *
220      * Note that `value` may be zero.
221      */
222     event Transfer(address indexed from, address indexed to, uint256 value);
223 
224     /**
225      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
226      * a call to {approve}. `value` is the new allowance.
227      */
228     event Approval(address indexed owner, address indexed spender, uint256 value);
229 }
230 
231 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
232 
233 
234 
235 pragma solidity ^0.8.0;
236 
237 
238 /**
239  * @dev Interface for the optional metadata functions from the ERC20 standard.
240  *
241  * _Available since v4.1._
242  */
243 interface IERC20Metadata is IERC20 {
244     /**
245      * @dev Returns the name of the token.
246      */
247     function name() external view returns (string memory);
248 
249     /**
250      * @dev Returns the symbol of the token.
251      */
252     function symbol() external view returns (string memory);
253 
254     /**
255      * @dev Returns the decimals places of the token.
256      */
257     function decimals() external view returns (uint8);
258 }
259 
260 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
261 
262 
263 
264 pragma solidity ^0.8.0;
265 
266 
267 
268 
269 /**
270  * @dev Implementation of the {IERC20} interface.
271  *
272  * This implementation is agnostic to the way tokens are created. This means
273  * that a supply mechanism has to be added in a derived contract using {_mint}.
274  * For a generic mechanism see {ERC20PresetMinterPauser}.
275  *
276  * TIP: For a detailed writeup see our guide
277  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
278  * to implement supply mechanisms].
279  *
280  * We have followed general OpenZeppelin Contracts guidelines: functions revert
281  * instead returning `false` on failure. This behavior is nonetheless
282  * conventional and does not conflict with the expectations of ERC20
283  * applications.
284  *
285  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
286  * This allows applications to reconstruct the allowance for all accounts just
287  * by listening to said events. Other implementations of the EIP may not emit
288  * these events, as it isn't required by the specification.
289  *
290  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
291  * functions have been added to mitigate the well-known issues around setting
292  * allowances. See {IERC20-approve}.
293  */
294 contract ERC20 is Context, IERC20, IERC20Metadata {
295     mapping(address => uint256) private _balances;
296 
297     mapping(address => mapping(address => uint256)) private _allowances;
298 
299     uint256 private _totalSupply;
300 
301     string private _name;
302     string private _symbol;
303 
304     /**
305      * @dev Sets the values for {name} and {symbol}.
306      *
307      * The default value of {decimals} is 18. To select a different value for
308      * {decimals} you should overload it.
309      *
310      * All two of these values are immutable: they can only be set once during
311      * construction.
312      */
313     constructor(string memory name_, string memory symbol_) {
314         _name = name_;
315         _symbol = symbol_;
316     }
317 
318     /**
319      * @dev Returns the name of the token.
320      */
321     function name() public view virtual override returns (string memory) {
322         return _name;
323     }
324 
325     /**
326      * @dev Returns the symbol of the token, usually a shorter version of the
327      * name.
328      */
329     function symbol() public view virtual override returns (string memory) {
330         return _symbol;
331     }
332 
333     /**
334      * @dev Returns the number of decimals used to get its user representation.
335      * For example, if `decimals` equals `2`, a balance of `505` tokens should
336      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
337      *
338      * Tokens usually opt for a value of 18, imitating the relationship between
339      * Ether and Wei. This is the value {ERC20} uses, unless this function is
340      * overridden;
341      *
342      * NOTE: This information is only used for _display_ purposes: it in
343      * no way affects any of the arithmetic of the contract, including
344      * {IERC20-balanceOf} and {IERC20-transfer}.
345      */
346     function decimals() public view virtual override returns (uint8) {
347         return 18;
348     }
349 
350     /**
351      * @dev See {IERC20-totalSupply}.
352      */
353     function totalSupply() public view virtual override returns (uint256) {
354         return _totalSupply;
355     }
356 
357     /**
358      * @dev See {IERC20-balanceOf}.
359      */
360     function balanceOf(address account) public view virtual override returns (uint256) {
361         return _balances[account];
362     }
363 
364     /**
365      * @dev See {IERC20-transfer}.
366      *
367      * Requirements:
368      *
369      * - `recipient` cannot be the zero address.
370      * - the caller must have a balance of at least `amount`.
371      */
372     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
373         _transfer(_msgSender(), recipient, amount);
374         return true;
375     }
376 
377     /**
378      * @dev See {IERC20-allowance}.
379      */
380     function allowance(address owner, address spender) public view virtual override returns (uint256) {
381         return _allowances[owner][spender];
382     }
383 
384     /**
385      * @dev See {IERC20-approve}.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      */
391     function approve(address spender, uint256 amount) public virtual override returns (bool) {
392         _approve(_msgSender(), spender, amount);
393         return true;
394     }
395 
396     /**
397      * @dev See {IERC20-transferFrom}.
398      *
399      * Emits an {Approval} event indicating the updated allowance. This is not
400      * required by the EIP. See the note at the beginning of {ERC20}.
401      *
402      * Requirements:
403      *
404      * - `sender` and `recipient` cannot be the zero address.
405      * - `sender` must have a balance of at least `amount`.
406      * - the caller must have allowance for ``sender``'s tokens of at least
407      * `amount`.
408      */
409     function transferFrom(
410         address sender,
411         address recipient,
412         uint256 amount
413     ) public virtual override returns (bool) {
414         _transfer(sender, recipient, amount);
415 
416         uint256 currentAllowance = _allowances[sender][_msgSender()];
417         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
418         unchecked {
419             _approve(sender, _msgSender(), currentAllowance - amount);
420         }
421 
422         return true;
423     }
424 
425     /**
426      * @dev Atomically increases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      */
437     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
438         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
439         return true;
440     }
441 
442     /**
443      * @dev Atomically decreases the allowance granted to `spender` by the caller.
444      *
445      * This is an alternative to {approve} that can be used as a mitigation for
446      * problems described in {IERC20-approve}.
447      *
448      * Emits an {Approval} event indicating the updated allowance.
449      *
450      * Requirements:
451      *
452      * - `spender` cannot be the zero address.
453      * - `spender` must have allowance for the caller of at least
454      * `subtractedValue`.
455      */
456     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
457         uint256 currentAllowance = _allowances[_msgSender()][spender];
458         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
459         unchecked {
460             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
461         }
462 
463         return true;
464     }
465 
466     /**
467      * @dev Moves `amount` of tokens from `sender` to `recipient`.
468      *
469      * This internal function is equivalent to {transfer}, and can be used to
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
487 
488         _beforeTokenTransfer(sender, recipient, amount);
489 
490         uint256 senderBalance = _balances[sender];
491         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
492         unchecked {
493             _balances[sender] = senderBalance - amount;
494         }
495         _balances[recipient] += amount;
496 
497         emit Transfer(sender, recipient, amount);
498 
499         _afterTokenTransfer(sender, recipient, amount);
500     }
501 
502     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
503      * the total supply.
504      *
505      * Emits a {Transfer} event with `from` set to the zero address.
506      *
507      * Requirements:
508      *
509      * - `account` cannot be the zero address.
510      */
511     function _mint(address account, uint256 amount) internal virtual {
512         require(account != address(0), "ERC20: mint to the zero address");
513 
514         _beforeTokenTransfer(address(0), account, amount);
515 
516         _totalSupply += amount;
517         _balances[account] += amount;
518         emit Transfer(address(0), account, amount);
519 
520         _afterTokenTransfer(address(0), account, amount);
521     }
522 
523     /**
524      * @dev Destroys `amount` tokens from `account`, reducing the
525      * total supply.
526      *
527      * Emits a {Transfer} event with `to` set to the zero address.
528      *
529      * Requirements:
530      *
531      * - `account` cannot be the zero address.
532      * - `account` must have at least `amount` tokens.
533      */
534     function _burn(address account, uint256 amount) internal virtual {
535         require(account != address(0), "ERC20: burn from the zero address");
536 
537         _beforeTokenTransfer(account, address(0), amount);
538 
539         uint256 accountBalance = _balances[account];
540         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
541         unchecked {
542             _balances[account] = accountBalance - amount;
543         }
544         _totalSupply -= amount;
545 
546         emit Transfer(account, address(0), amount);
547 
548         _afterTokenTransfer(account, address(0), amount);
549     }
550 
551     /**
552      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
553      *
554      * This internal function is equivalent to `approve`, and can be used to
555      * e.g. set automatic allowances for certain subsystems, etc.
556      *
557      * Emits an {Approval} event.
558      *
559      * Requirements:
560      *
561      * - `owner` cannot be the zero address.
562      * - `spender` cannot be the zero address.
563      */
564     function _approve(
565         address owner,
566         address spender,
567         uint256 amount
568     ) internal virtual {
569         require(owner != address(0), "ERC20: approve from the zero address");
570         require(spender != address(0), "ERC20: approve to the zero address");
571 
572         _allowances[owner][spender] = amount;
573         emit Approval(owner, spender, amount);
574     }
575 
576     /**
577      * @dev Hook that is called before any transfer of tokens. This includes
578      * minting and burning.
579      *
580      * Calling conditions:
581      *
582      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
583      * will be transferred to `to`.
584      * - when `from` is zero, `amount` tokens will be minted for `to`.
585      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
586      * - `from` and `to` are never both zero.
587      *
588      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
589      */
590     function _beforeTokenTransfer(
591         address from,
592         address to,
593         uint256 amount
594     ) internal virtual {}
595 
596     /**
597      * @dev Hook that is called after any transfer of tokens. This includes
598      * minting and burning.
599      *
600      * Calling conditions:
601      *
602      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
603      * has been transferred to `to`.
604      * - when `from` is zero, `amount` tokens have been minted for `to`.
605      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
606      * - `from` and `to` are never both zero.
607      *
608      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
609      */
610     function _afterTokenTransfer(
611         address from,
612         address to,
613         uint256 amount
614     ) internal virtual {}
615 }
616 
617 // File: contracts/BONESTestContract1.sol
618 
619 
620 pragma solidity ^0.8.0;
621 
622 interface iSkellies {
623     function balanceOf(address _user) external view returns(uint256);
624     function ownerOf(uint256 _tokenId) external view returns(address);
625     function totalSupply() external view returns (uint256);
626 }
627 
628 contract BonesOfficial is ERC20("Bones", "BONES"), Ownable {
629     struct ContractSettings {
630         uint256 baseRate;
631         uint256 initIssuance;
632         uint256 start;
633         uint256 end;
634     }
635 
636     mapping(address => ContractSettings) public contractSettings;
637     mapping(address => bool) public trustedContracts;
638 
639     uint256 constant public MAX_BASE_RATE = 10 ether;
640     uint256 constant public MAX_INITIAL_ISSUANCE = 70 ether;
641 
642     // Prevents new contracts from being added or changes to disbursement if permanently locked
643     bool public isLocked = false;
644     mapping(bytes32 => uint256) public lastClaim;
645     
646     event RewardPaid(address indexed user, uint256 reward);
647 
648     constructor() {}
649 
650     /**
651         - needs onlyOwner flag
652         - needs to check that the baseRate and initIssuance are not greater than the max settings
653         - require that contract isn't locked
654      */
655     function addContract(address _contractAddress, uint256 _baseRate, uint256 _initIssuance) public onlyOwner {
656         require(_baseRate <= MAX_BASE_RATE && _initIssuance <= MAX_INITIAL_ISSUANCE, "baseRate or initIssuance exceeds max value.");
657         require(!isLocked, "Cannot add any more contracts.");
658 
659         // add to trustedContracts
660         trustedContracts[_contractAddress] = true;
661 
662         // initialize contractSettings
663         contractSettings[_contractAddress] = ContractSettings({ 
664             baseRate: _baseRate,
665             initIssuance: _initIssuance,
666             start: block.timestamp,
667             end: type(uint256).max
668         });
669     }
670 
671     /**
672         - sets an end date for when rewards officially end
673      */
674     function setEndDateForContract(address _contractAddress, uint256 _endTime) public onlyOwner {
675         require(!isLocked, "Cannot modify end dates after lock");
676         require(trustedContracts[_contractAddress], "Not a trusted contract");
677         
678         contractSettings[_contractAddress].end = _endTime;
679     }
680 
681     function claimReward(address _contractAddress, uint256 _tokenId) public returns (uint256) {
682         require(trustedContracts[_contractAddress], "Not a trusted contract.");
683         require(contractSettings[_contractAddress].end > block.timestamp, "Time for claiming on that contract has expired.");
684         require(iSkellies(_contractAddress).ownerOf(_tokenId) == msg.sender, "Caller does not own the token being claimed for.");
685 
686         // compute Bones to be claimed
687         uint256 unclaimedReward = computeUnclaimedReward(_contractAddress, _tokenId);
688 
689         // update the lastClaim date for tokenId and contractAddress
690         bytes32 lastClaimKey = keccak256(abi.encode(_contractAddress, _tokenId));
691         lastClaim[lastClaimKey] = block.timestamp;
692 
693         // mint the tokens and distribute to msg.sender
694         _mint(msg.sender, unclaimedReward);
695         emit RewardPaid(msg.sender, unclaimedReward);
696 
697         return unclaimedReward;
698     }
699 
700     function claimRewards(address _contractAddress, uint256[] calldata _tokenIds) public returns (uint256) {
701         require(trustedContracts[_contractAddress], "Not a trusted contract.");
702         require(contractSettings[_contractAddress].end > block.timestamp, "Time for claiming has expired");
703 
704         uint256 totalUnclaimedRewards = 0;
705 
706         for(uint256 i = 0; i < _tokenIds.length; i++) {
707             uint256 _tokenId = _tokenIds[i];
708 
709             require(iSkellies(_contractAddress).ownerOf(_tokenId) == msg.sender, "Caller does not own the token being claimed for.");
710 
711             // compute Bones to be claimed
712             uint256 unclaimedReward = computeUnclaimedReward(_contractAddress, _tokenId);
713             totalUnclaimedRewards = totalUnclaimedRewards + unclaimedReward;
714 
715             // update the lastClaim date for tokenId and contractAddress
716             bytes32 lastClaimKey = keccak256(abi.encode(_contractAddress, _tokenId));
717             lastClaim[lastClaimKey] = block.timestamp;
718         }
719 
720         // mint the tokens and distribute to msg.sender
721         _mint(msg.sender, totalUnclaimedRewards);
722         emit RewardPaid(msg.sender, totalUnclaimedRewards);
723 
724         return totalUnclaimedRewards;
725     }
726 
727     function permanentlyLock() public onlyOwner {
728         isLocked = true;
729     }
730 
731     function getUnclaimedRewardAmount(address _contractAddress, uint256 _tokenId) public view returns (uint256) {
732         require(trustedContracts[_contractAddress], "Not a trusted contract");
733 
734         uint256 unclaimedReward  = computeUnclaimedReward(_contractAddress, _tokenId);
735         return unclaimedReward;
736     }
737 
738     function getUnclaimedRewardsAmount(address _contractAddress, uint256[] calldata _tokenIds) public view returns (uint256) {
739         require(trustedContracts[_contractAddress], "Not a trusted contract");
740 
741         uint256 totalUnclaimedRewards = 0;
742 
743         for(uint256 i = 0; i < _tokenIds.length; i++) {
744             totalUnclaimedRewards += computeUnclaimedReward(_contractAddress, _tokenIds[i]);
745         }
746 
747         return totalUnclaimedRewards;
748     }
749 
750     function getTotalUnclaimedRewardsForContract(address _contractAddress) public view returns (uint256) {
751         require(trustedContracts[_contractAddress], "Not a trusted contract");
752 
753         uint256 totalUnclaimedRewards = 0;
754         uint256 totalSupply = iSkellies(_contractAddress).totalSupply();
755 
756         for(uint256 i = 0; i < totalSupply; i++) {
757             totalUnclaimedRewards += computeUnclaimedReward(_contractAddress, i);
758         }
759 
760         return totalUnclaimedRewards;
761     }
762 
763     function getLastClaimedTime(address _contractAddress, uint256 _tokenId) public view returns (uint256) {
764         require(trustedContracts[_contractAddress], "Not a trusted contract");
765 
766         bytes32 lastClaimKey = keccak256(abi.encode(_contractAddress, _tokenId));
767 
768         return lastClaim[lastClaimKey];
769     }
770 
771     function computeAccumulatedReward(uint256 _lastClaimDate, uint256 _baseRate, uint256 currentTime) internal pure returns (uint256) {
772         require(currentTime > _lastClaimDate, "Last claim date must be smaller than block timestamp");
773 
774         uint256 secondsElapsed = currentTime - _lastClaimDate;
775         uint256 accumulatedReward = secondsElapsed * _baseRate / 1 days;
776 
777         return accumulatedReward;
778     }
779     //checks contract and returns an array containing the tokenids owned by the specified address 
780     function TokensOfOwner(address _contractAddress, address address_) public view returns (uint[] memory) {
781         require(trustedContracts[_contractAddress], "Not a trusted contract"); 
782         uint _balance = iSkellies(_contractAddress).balanceOf(address_); // get balance of address
783         uint contractMaxToken = iSkellies(_contractAddress).totalSupply(); //total supply of contract
784         uint[] memory _tokens = new uint[](_balance); // initialize array 
785         uint _index;
786             for (uint id = 1; id <= contractMaxToken; id++) {
787                 if (address_ == iSkellies(_contractAddress).ownerOf(id)) { _tokens[_index] = id; _index++;}
788             }
789         return _tokens; 
790     }
791     
792 
793     function computeUnclaimedReward(address _contractAddress, uint256 _tokenId) internal view returns (uint256) {
794         require(trustedContracts[_contractAddress], "Not a trusted contract");
795         
796         // Will revert if tokenId does not exist
797         iSkellies(_contractAddress).ownerOf(_tokenId);
798 
799         // build the hash for lastClaim based on contractAddress and tokenId
800         bytes32 lastClaimKey = keccak256(abi.encode(_contractAddress, _tokenId));
801         uint256 lastClaimDate = lastClaim[lastClaimKey];
802         uint256 baseRate = contractSettings[_contractAddress].baseRate;
803 
804         // if there has been a lastClaim, compute the value since lastClaim
805         if (lastClaimDate != uint256(0)) {
806             return computeAccumulatedReward(lastClaimDate, baseRate, block.timestamp);
807         } 
808         else {
809             // if there has not been a lastClaim, add the initIssuance + computed value since contract startDate
810             uint256 totalReward = computeAccumulatedReward(contractSettings[_contractAddress].start, baseRate, block.timestamp) + contractSettings[_contractAddress].initIssuance;
811 
812             return totalReward;
813         }
814     }
815 }