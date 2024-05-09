1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
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
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Context.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
95 
96 
97 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 /**
102  * @dev Interface of the ERC20 standard as defined in the EIP.
103  */
104 interface IERC20 {
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
118 
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `to`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address to, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Moves `amount` tokens from `from` to `to` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(
173         address from,
174         address to,
175         uint256 amount
176     ) external returns (bool);
177 }
178 
179 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
180 
181 
182 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 
187 /**
188  * @dev Interface for the optional metadata functions from the ERC20 standard.
189  *
190  * _Available since v4.1._
191  */
192 interface IERC20Metadata is IERC20 {
193     /**
194      * @dev Returns the name of the token.
195      */
196     function name() external view returns (string memory);
197 
198     /**
199      * @dev Returns the symbol of the token.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the decimals places of the token.
205      */
206     function decimals() external view returns (uint8);
207 }
208 
209 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
210 
211 
212 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
213 
214 pragma solidity ^0.8.0;
215 
216 
217 
218 
219 /**
220  * @dev Implementation of the {IERC20} interface.
221  *
222  * This implementation is agnostic to the way tokens are created. This means
223  * that a supply mechanism has to be added in a derived contract using {_mint}.
224  * For a generic mechanism see {ERC20PresetMinterPauser}.
225  *
226  * TIP: For a detailed writeup see our guide
227  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
228  * to implement supply mechanisms].
229  *
230  * We have followed general OpenZeppelin Contracts guidelines: functions revert
231  * instead returning `false` on failure. This behavior is nonetheless
232  * conventional and does not conflict with the expectations of ERC20
233  * applications.
234  *
235  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
236  * This allows applications to reconstruct the allowance for all accounts just
237  * by listening to said events. Other implementations of the EIP may not emit
238  * these events, as it isn't required by the specification.
239  *
240  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
241  * functions have been added to mitigate the well-known issues around setting
242  * allowances. See {IERC20-approve}.
243  */
244 contract ERC20 is Context, IERC20, IERC20Metadata {
245     mapping(address => uint256) private _balances;
246 
247     mapping(address => mapping(address => uint256)) private _allowances;
248 
249     uint256 private _totalSupply;
250 
251     string private _name;
252     string private _symbol;
253 
254     /**
255      * @dev Sets the values for {name} and {symbol}.
256      *
257      * The default value of {decimals} is 18. To select a different value for
258      * {decimals} you should overload it.
259      *
260      * All two of these values are immutable: they can only be set once during
261      * construction.
262      */
263     constructor(string memory name_, string memory symbol_) {
264         _name = name_;
265         _symbol = symbol_;
266     }
267 
268     /**
269      * @dev Returns the name of the token.
270      */
271     function name() public view virtual override returns (string memory) {
272         return _name;
273     }
274 
275     /**
276      * @dev Returns the symbol of the token, usually a shorter version of the
277      * name.
278      */
279     function symbol() public view virtual override returns (string memory) {
280         return _symbol;
281     }
282 
283     /**
284      * @dev Returns the number of decimals used to get its user representation.
285      * For example, if `decimals` equals `2`, a balance of `505` tokens should
286      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
287      *
288      * Tokens usually opt for a value of 18, imitating the relationship between
289      * Ether and Wei. This is the value {ERC20} uses, unless this function is
290      * overridden;
291      *
292      * NOTE: This information is only used for _display_ purposes: it in
293      * no way affects any of the arithmetic of the contract, including
294      * {IERC20-balanceOf} and {IERC20-transfer}.
295      */
296     function decimals() public view virtual override returns (uint8) {
297         return 18;
298     }
299 
300     /**
301      * @dev See {IERC20-totalSupply}.
302      */
303     function totalSupply() public view virtual override returns (uint256) {
304         return _totalSupply;
305     }
306 
307     /**
308      * @dev See {IERC20-balanceOf}.
309      */
310     function balanceOf(address account) public view virtual override returns (uint256) {
311         return _balances[account];
312     }
313 
314     /**
315      * @dev See {IERC20-transfer}.
316      *
317      * Requirements:
318      *
319      * - `to` cannot be the zero address.
320      * - the caller must have a balance of at least `amount`.
321      */
322     function transfer(address to, uint256 amount) public virtual override returns (bool) {
323         address owner = _msgSender();
324         _transfer(owner, to, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See {IERC20-allowance}.
330      */
331     function allowance(address owner, address spender) public view virtual override returns (uint256) {
332         return _allowances[owner][spender];
333     }
334 
335     /**
336      * @dev See {IERC20-approve}.
337      *
338      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
339      * `transferFrom`. This is semantically equivalent to an infinite approval.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      */
345     function approve(address spender, uint256 amount) public virtual override returns (bool) {
346         address owner = _msgSender();
347         _approve(owner, spender, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-transferFrom}.
353      *
354      * Emits an {Approval} event indicating the updated allowance. This is not
355      * required by the EIP. See the note at the beginning of {ERC20}.
356      *
357      * NOTE: Does not update the allowance if the current allowance
358      * is the maximum `uint256`.
359      *
360      * Requirements:
361      *
362      * - `from` and `to` cannot be the zero address.
363      * - `from` must have a balance of at least `amount`.
364      * - the caller must have allowance for ``from``'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(
368         address from,
369         address to,
370         uint256 amount
371     ) public virtual override returns (bool) {
372         address spender = _msgSender();
373         _spendAllowance(from, spender, amount);
374         _transfer(from, to, amount);
375         return true;
376     }
377 
378     /**
379      * @dev Atomically increases the allowance granted to `spender` by the caller.
380      *
381      * This is an alternative to {approve} that can be used as a mitigation for
382      * problems described in {IERC20-approve}.
383      *
384      * Emits an {Approval} event indicating the updated allowance.
385      *
386      * Requirements:
387      *
388      * - `spender` cannot be the zero address.
389      */
390     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
391         address owner = _msgSender();
392         _approve(owner, spender, allowance(owner, spender) + addedValue);
393         return true;
394     }
395 
396     /**
397      * @dev Atomically decreases the allowance granted to `spender` by the caller.
398      *
399      * This is an alternative to {approve} that can be used as a mitigation for
400      * problems described in {IERC20-approve}.
401      *
402      * Emits an {Approval} event indicating the updated allowance.
403      *
404      * Requirements:
405      *
406      * - `spender` cannot be the zero address.
407      * - `spender` must have allowance for the caller of at least
408      * `subtractedValue`.
409      */
410     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
411         address owner = _msgSender();
412         uint256 currentAllowance = allowance(owner, spender);
413         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
414         unchecked {
415             _approve(owner, spender, currentAllowance - subtractedValue);
416         }
417 
418         return true;
419     }
420 
421     /**
422      * @dev Moves `amount` of tokens from `sender` to `recipient`.
423      *
424      * This internal function is equivalent to {transfer}, and can be used to
425      * e.g. implement automatic token fees, slashing mechanisms, etc.
426      *
427      * Emits a {Transfer} event.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `from` must have a balance of at least `amount`.
434      */
435     function _transfer(
436         address from,
437         address to,
438         uint256 amount
439     ) internal virtual {
440         require(from != address(0), "ERC20: transfer from the zero address");
441         require(to != address(0), "ERC20: transfer to the zero address");
442 
443         _beforeTokenTransfer(from, to, amount);
444 
445         uint256 fromBalance = _balances[from];
446         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
447         unchecked {
448             _balances[from] = fromBalance - amount;
449         }
450         _balances[to] += amount;
451 
452         emit Transfer(from, to, amount);
453 
454         _afterTokenTransfer(from, to, amount);
455     }
456 
457     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
458      * the total supply.
459      *
460      * Emits a {Transfer} event with `from` set to the zero address.
461      *
462      * Requirements:
463      *
464      * - `account` cannot be the zero address.
465      */
466     function _mint(address account, uint256 amount) internal virtual {
467         require(account != address(0), "ERC20: mint to the zero address");
468 
469         _beforeTokenTransfer(address(0), account, amount);
470 
471         _totalSupply += amount;
472         _balances[account] += amount;
473         emit Transfer(address(0), account, amount);
474 
475         _afterTokenTransfer(address(0), account, amount);
476     }
477 
478     /**
479      * @dev Destroys `amount` tokens from `account`, reducing the
480      * total supply.
481      *
482      * Emits a {Transfer} event with `to` set to the zero address.
483      *
484      * Requirements:
485      *
486      * - `account` cannot be the zero address.
487      * - `account` must have at least `amount` tokens.
488      */
489     function _burn(address account, uint256 amount) internal virtual {
490         require(account != address(0), "ERC20: burn from the zero address");
491 
492         _beforeTokenTransfer(account, address(0), amount);
493 
494         uint256 accountBalance = _balances[account];
495         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
496         unchecked {
497             _balances[account] = accountBalance - amount;
498         }
499         _totalSupply -= amount;
500 
501         emit Transfer(account, address(0), amount);
502 
503         _afterTokenTransfer(account, address(0), amount);
504     }
505 
506     /**
507      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
508      *
509      * This internal function is equivalent to `approve`, and can be used to
510      * e.g. set automatic allowances for certain subsystems, etc.
511      *
512      * Emits an {Approval} event.
513      *
514      * Requirements:
515      *
516      * - `owner` cannot be the zero address.
517      * - `spender` cannot be the zero address.
518      */
519     function _approve(
520         address owner,
521         address spender,
522         uint256 amount
523     ) internal virtual {
524         require(owner != address(0), "ERC20: approve from the zero address");
525         require(spender != address(0), "ERC20: approve to the zero address");
526 
527         _allowances[owner][spender] = amount;
528         emit Approval(owner, spender, amount);
529     }
530 
531     /**
532      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
533      *
534      * Does not update the allowance amount in case of infinite allowance.
535      * Revert if not enough allowance is available.
536      *
537      * Might emit an {Approval} event.
538      */
539     function _spendAllowance(
540         address owner,
541         address spender,
542         uint256 amount
543     ) internal virtual {
544         uint256 currentAllowance = allowance(owner, spender);
545         if (currentAllowance != type(uint256).max) {
546             require(currentAllowance >= amount, "ERC20: insufficient allowance");
547             unchecked {
548                 _approve(owner, spender, currentAllowance - amount);
549             }
550         }
551     }
552 
553     /**
554      * @dev Hook that is called before any transfer of tokens. This includes
555      * minting and burning.
556      *
557      * Calling conditions:
558      *
559      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
560      * will be transferred to `to`.
561      * - when `from` is zero, `amount` tokens will be minted for `to`.
562      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
563      * - `from` and `to` are never both zero.
564      *
565      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
566      */
567     function _beforeTokenTransfer(
568         address from,
569         address to,
570         uint256 amount
571     ) internal virtual {}
572 
573     /**
574      * @dev Hook that is called after any transfer of tokens. This includes
575      * minting and burning.
576      *
577      * Calling conditions:
578      *
579      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
580      * has been transferred to `to`.
581      * - when `from` is zero, `amount` tokens have been minted for `to`.
582      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
583      * - `from` and `to` are never both zero.
584      *
585      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
586      */
587     function _afterTokenTransfer(
588         address from,
589         address to,
590         uint256 amount
591     ) internal virtual {}
592 }
593 
594 // File: XenDAOfinal.sol
595 
596 //SPDX-License-Identifier: NONE
597 pragma solidity ^0.8.10;
598 
599 
600 
601 interface IXEN {
602     function claimRank(uint256 term) external;
603     function claimMintReward() external;
604     function transfer(address to, uint256 amount) external returns (bool);
605     function balanceOf(address account) external view returns (uint256);
606     function userMints(address) external view returns (address, uint256, uint256, uint256, uint256, uint256);
607     function transferFrom(
608         address from,
609         address to,
610         uint256 amount
611     ) external returns (bool);
612 }
613 
614 contract XENDAO is ERC20("XEN DAO", "XD"), ReentrancyGuard {
615 	struct UserInfo {
616         uint256 amount;         // tokens burned from user
617         uint256 rewardDebt;     // Reward debt
618     }
619 	
620     uint256 public constant INITIALARTIFICIALBURN = 10000; //for first deposit
621 	address public immutable XEN = 0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8;
622     uint256 public immutable MAXFEE; 
623 	
624 	address public immutable implementation;
625 
626 	mapping (address => UserInfo) public userInfo;
627 	
628 	uint256 public accEthPerShare;
629 	uint256 public latestBalance; //latest Fee balance
630 	
631 	// can transfer minting right to new contracts(in case there is optimization of the minting process)
632 	// rug-pull proof (5-day delay)
633 	address public canMint;
634     address public registerMinter; // for time lock
635     uint256 public daysDelay = 3; // 3 day time lock (can be extended)
636     uint256 public timeWithDelay; //  "time lock"
637     bool public canAssignNewMinter = true; // can be renounced
638 	
639     //initial rewards
640 	uint256 public reward = 1e24; //1 million xenDao per mint 
641 	uint256 public rewardWbonus = 125 * 1e22; // +25% bonus if referred
642 	uint256 public refbonus = 250 * 1e21; // 250K tokens referral bonus
643 	uint256 public sendReward = 750 * 1e21; //750K reward
644 	uint256 public sendRewardBonus = 850 * 1e21; //850K reward
645 	uint256 public sendRewardRef = 200 * 1e21; //200K reward
646 	
647     uint256 public fee;
648 	uint256 public claimAgainFee; 
649     uint256 public sendFee;
650 
651 	uint256 public lastRewardUpdate;
652 	uint256 public dayCount = 1;
653 
654 	uint256 public totalBurned = 10000; //amount staked
655 	
656 	uint256 public alreadyMinted = 0;
657 	address public noExpectationAddress = 0xf16d68c08a05Cd824FC026FeC1191A3ee261c70A;
658 	
659     mapping(address => uint256 []) public userQuantities;
660 	
661 	constructor(uint256 _fee, uint256 _maxFee, address _implementation) {
662 		lastRewardUpdate = block.timestamp + 13 * 24 * 3600; //steady for first 14 days
663         fee = _fee;
664         claimAgainFee = _fee;
665         sendFee = _fee;
666         MAXFEE = _maxFee;
667 		implementation = _implementation;
668 	}
669 
670     // Function to receive Ether. msg.data must be empty
671     receive() external payable {}
672 
673     // Fallback function is called when msg.data is not empty
674     fallback() external payable {}
675 
676     function createContract (bytes memory data, uint256 quantity, bytes calldata _salt) external payable {
677 		require(msg.value == fee*quantity, "ETH sent is incorrect");
678 		address _clone;
679         bytes32 salt;
680         for(uint i=0; i<quantity; i++) {
681             salt = keccak256(abi.encodePacked(_salt,i,msg.sender));
682 			_clone = cloneDeterministic(implementation, salt);
683 			Implementation(_clone).a(data);
684         }
685         userQuantities[msg.sender].push(quantity);
686 		_mint(msg.sender, quantity * reward);
687     }
688 	
689     function createContractRef (bytes memory data, uint256 quantity, bytes calldata _salt, address referral) external payable {
690         require(msg.value == fee*quantity, "ETH sent is incorrect");
691 		address _clone;
692         bytes32 salt;
693         for(uint i=0; i<quantity; i++) {
694             salt = keccak256(abi.encodePacked(_salt,i,msg.sender));
695             _clone = cloneDeterministic(implementation, salt);
696 			Implementation(_clone).a(data);
697         }
698         userQuantities[msg.sender].push(quantity);
699 		_mint(msg.sender, quantity * rewardWbonus);
700 		if(referral != msg.sender) { _mint(referral, quantity * refbonus); }
701     }
702 	
703 	function stake(uint256 _amount) external nonReentrant {
704 		uint256 _tokenChange = address(this).balance - latestBalance;
705 		accEthPerShare = accEthPerShare + _tokenChange * 1e12 / totalBurned;
706 		
707 		_burn(msg.sender, _amount);
708 		totalBurned+= _amount;
709 		
710 		if(userInfo[msg.sender].amount == 0) { //no previous balance
711 			userInfo[msg.sender].amount = _amount;
712             userInfo[msg.sender].rewardDebt = userInfo[msg.sender].amount * accEthPerShare / 1e12; 
713 		} else {
714 			uint256 _pending = userInfo[msg.sender].amount * accEthPerShare / 1e12 - userInfo[msg.sender].rewardDebt;
715 			userInfo[msg.sender].amount+= _amount;
716             userInfo[msg.sender].rewardDebt = userInfo[msg.sender].amount * accEthPerShare / 1e12 - _pending; 
717 		}
718 		latestBalance = address(this).balance;
719 	}
720 
721 	function harvest() public nonReentrant {
722 		uint256 _tokenChange = address(this).balance - latestBalance;
723 		accEthPerShare = accEthPerShare + _tokenChange * 1e12 / totalBurned;
724 		uint256 _pending = userInfo[msg.sender].amount * accEthPerShare / 1e12 - userInfo[msg.sender].rewardDebt;
725 		
726 		userInfo[msg.sender].rewardDebt = userInfo[msg.sender].amount * accEthPerShare / 1e12; // reset 
727 		payable(msg.sender).transfer(_pending);
728 		latestBalance = address(this).balance;
729 	}
730 	
731 	function withdraw() external nonReentrant {
732 		uint256 _tokenChange = address(this).balance - latestBalance;
733 		accEthPerShare = accEthPerShare + _tokenChange * 1e12 / totalBurned;
734 		
735 		uint256 _pending = userInfo[msg.sender].amount * accEthPerShare / 1e12 - userInfo[msg.sender].rewardDebt;
736 		
737 		uint256 _tokensStaked = userInfo[msg.sender].amount;
738 		
739 		userInfo[msg.sender].amount = 0;
740 		userInfo[msg.sender].rewardDebt = 0;
741 		
742 		payable(msg.sender).transfer(_pending);
743 		latestBalance = address(this).balance;
744 		
745 		_mint(msg.sender, _tokensStaked);
746 		totalBurned-= _tokensStaked;
747 	}
748 
749     // if better-optimized contract is launched, minting privileges can be transferred
750     function mint(address _to, uint256 _amount) external {
751         require(msg.sender == canMint);
752         _mint(_to, _amount);
753     }
754 	
755 	function aMassSend(address[] calldata _address, uint256 _amount) external payable nonReentrant {
756 		uint256 _quantity = _address.length;
757         require(msg.value == _quantity * sendFee + _quantity * _amount, "fee insufficient!");
758 		
759 		for(uint i=0; i < _quantity; i++) {
760             payable(_address[i]).transfer(_amount);
761         }
762 	
763 		_mint(msg.sender, _quantity * sendReward);
764 	}
765 
766     function vmassSendRef(address[] calldata _address, uint256 _amount, address _referral) external payable nonReentrant {
767 		uint256 _quantity = _address.length;
768         require(msg.value == _quantity * sendFee + _quantity * _amount, "total send + fee insufficient!");
769         require(msg.sender != _referral, "not allowed");
770 		
771 		for(uint i=0; i < _quantity; i++) {
772             payable(_address[i]).transfer(_amount);
773         }
774         
775 		_mint(msg.sender, _quantity * sendRewardBonus);
776         _mint(_referral, _quantity * sendRewardRef);
777 	}
778 	
779     // used for minting & claiming again
780     function multiCall(address[] calldata _contracts, bytes memory data) external {
781         for(uint256 i=0; i < _contracts.length; i++) {
782             Implementation(_contracts[i]).a(data);
783         }
784     }
785 
786     function claimAgainWithFee(address[] calldata _contracts, address _referral, bytes memory data) external payable {
787         uint256 _quantity = _contracts.length;
788         uint256 _tAmount = claimAgainFee * _quantity;
789         require(msg.value == _tAmount, "ETH sent is incorrect");
790 
791         for(uint256 i=0; i < _contracts.length; i++) {
792             Implementation(_contracts[i]).a(data);
793         }
794         
795         if(_referral != msg.sender) {
796             _mint(msg.sender, _quantity * sendRewardBonus);
797             _mint(_referral, _quantity * sendRewardRef);
798         } else {
799             _mint(msg.sender, _quantity * sendReward);
800         }
801     }
802 
803     //returns earnings, amount staked and total Staked
804 	function userStakeEarnings(address _user) external view returns (uint256, uint256, uint256) {
805 		uint256 _tokenChange = address(this).balance - latestBalance;
806 		uint256 _tempAccEthPerShare = accEthPerShare + _tokenChange * 1e12 / totalBurned;
807 		
808 		uint256 _pending = userInfo[_user].amount * _tempAccEthPerShare / 1e12 - userInfo[_user].rewardDebt;
809 		
810 		return (_pending, userInfo[_user].amount, totalBurned);
811 	}
812 	
813     function userMints(address _user) external view returns(uint256) {
814         return userQuantities[_user].length; 
815     }
816 
817     function contractAddress(bytes calldata _salt, uint256 _mintNr, address _user) public view returns (address) {
818         return predictDeterministicAddress(implementation, keccak256(abi.encodePacked(_salt,_mintNr,_user)), address(this));
819     }
820 
821     function contractAddressWithHash(bytes32 _salt) public view returns (address) {
822         return predictDeterministicAddress(implementation, _salt, address(this));
823     }
824 	
825     function multiData(address _user, uint256 _id, address _contractAddress) external view returns (uint256, uint256) {
826         return (userQuantities[_user][_id], getMaturationDate(_contractAddress));
827     }
828 
829     function getMaturationDate(address _contract) public view returns (uint256) {
830         (, , uint256 maturation, , , ) = IXEN(XEN).userMints(_contract);
831         return maturation;
832     }
833 
834     function getClaimCallData(uint256 term) external pure returns (bytes memory) {
835         return abi.encodeWithSignature("claimRank(uint256)", term);
836     }
837 
838      function getMintCallData() external pure returns (bytes memory) {
839         return abi.encodeWithSignature("mint()");
840     }
841 	
842 	function getTransferCallData(address _to, uint256 _amount) external pure returns (bytes memory) {
843         return abi.encodeWithSignature("transfer(address,uint256)", _to, _amount);
844     }
845 
846     function transferAllCallData(address _contract, address _to) external view returns (bytes memory) {
847         return abi.encodeWithSignature("transfer(address,uint256)", _to, IXEN(XEN).balanceOf(_contract));
848     }
849 
850     function getSalt(bytes calldata _salt, uint256 _mintNr, address _user) public pure returns (bytes32) {
851         return keccak256(abi.encodePacked(_salt,_mintNr,_user));
852     }
853 	
854 	function totalSupply() public view virtual override returns (uint256) {
855         return super.totalSupply() + totalBurned - INITIALARTIFICIALBURN;
856     }
857 
858     function getBatchAddresses(bytes32[] calldata _salt, uint256 _claimId, address _user) external view returns (address[] memory) {
859         uint256 _batchLength = userQuantities[_user][_claimId];
860         address[] memory _addresses;
861         for(uint i=0; i<_batchLength; i++) {
862             _addresses[i] = predictDeterministicAddress(implementation, _salt[i], address(this));     
863         }
864         return _addresses;
865     }
866 	
867 	// inflationary only for the first 3-4 months
868 	function decreaseRewards() external {
869 		require(block.timestamp - lastRewardUpdate > 86400, "Decrease not yet eligible. Must wait 1 day between calls");
870 		reward = reward * (100 - dayCount) / 100;
871 		rewardWbonus = rewardWbonus * (100 - dayCount) / 100;
872 		refbonus = refbonus * (100 - dayCount) / 100;
873 
874         sendReward = sendReward * (100 - dayCount) / 100;
875 		sendRewardBonus = sendRewardBonus * (100 - dayCount) / 100;
876 		sendRewardRef = sendRewardRef * (100 - dayCount) / 100;
877 		
878 		dayCount++;
879 	}
880 	
881 	function stopInflation() external {
882 		require(block.timestamp > 1673740800, "Must wait until 15th Jan 2023");
883 		reward = 0;
884 		rewardWbonus = 0;
885 		refbonus = 0;
886 
887         sendReward = 0;
888         sendRewardBonus = 0;
889         sendRewardRef = 0;
890 	}
891 	
892 	function mintNoExpectation() external nonReentrant {
893         require(msg.sender == noExpectationAddress, "not allowed");
894 		uint256 _totalAllowed = totalSupply() / 10;
895 		uint256 _toMint = _totalAllowed - alreadyMinted;
896 		alreadyMinted+= _toMint;
897 		_mint(noExpectationAddress, _toMint);
898 	}
899 
900     function setFee(uint256 _newFee, uint256 _againFee, uint256 _sendFee) external {
901         require(_newFee <= MAXFEE && _againFee <= MAXFEE && _sendFee <= MAXFEE, "over limit");
902         require(msg.sender == noExpectationAddress);
903         fee = _newFee;
904         claimAgainFee = _againFee;
905         sendFee = _sendFee; 
906     }
907 	
908 	//set mint reward for mass send
909 	function setSendingReward(uint256 _new) external {
910 		require(msg.sender == noExpectationAddress);
911 		require(_new <= reward, "can't be bigger than reward");
912 		sendReward = _new;
913 		sendRewardBonus = _new * 125 / 100;
914 		sendRewardRef = _new * 25 / 100;
915 	}
916 	
917 	function wchangeAddress(address _noExpect) external {
918 		require(msg.sender == noExpectationAddress);
919 		noExpectationAddress = _noExpect;
920 	}
921 	
922     function wdaysDelay(uint256 _newDelay) external {
923 		require(msg.sender == noExpectationAddress);
924         require(_newDelay > daysDelay, "can only increase");
925 		daysDelay = _newDelay;
926 	}
927 
928    function wassignNewMinter(address _new) external {
929         require(canAssignNewMinter, "renounced");
930         require(msg.sender == noExpectationAddress);
931         registerMinter = _new;
932         timeWithDelay = block.timestamp + daysDelay * 24 * 3600;
933     }
934 
935     function wfinalizeMinterAfterDelay() external {
936         require(canAssignNewMinter);
937         require(registerMinter != address(0));
938         require(block.timestamp > timeWithDelay);
939         canMint = registerMinter;
940     }
941 
942     function wrenounceNewMinters() external {
943         require(msg.sender == noExpectationAddress, "not allowed");
944         canAssignNewMinter = false;
945     }
946 	
947     //source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/proxy/Clones.sol
948     /**
949      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
950      */
951 
952     function cloneDeterministic(address _implementation, bytes32 salt) internal returns (address instance) {
953         /// @solidity memory-safe-assembly
954         assembly {
955             // Cleans the upper 96 bits of the `implementation` word, then packs the first 3 bytes
956             // of the `implementation` address with the bytecode before the address.
957             mstore(0x00, or(shr(0xe8, shl(0x60, _implementation)), 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000))
958             // Packs the remaining 17 bytes of `implementation` with the bytecode after the address.
959             mstore(0x20, or(shl(0x78, _implementation), 0x5af43d82803e903d91602b57fd5bf3))
960             instance := create2(0, 0x09, 0x37, salt)
961         }
962         require(instance != address(0), "ERC1167: create2 failed");
963     }
964 
965     function predictDeterministicAddress(
966         address _implementation,
967         bytes32 salt,
968         address deployer
969     ) internal pure returns (address predicted) {
970         /// @solidity memory-safe-assembly
971         assembly {
972             let ptr := mload(0x40)
973             mstore(add(ptr, 0x38), deployer)
974             mstore(add(ptr, 0x24), 0x5af43d82803e903d91602b57fd5bf3ff)
975             mstore(add(ptr, 0x14), _implementation)
976             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73)
977             mstore(add(ptr, 0x58), salt)
978             mstore(add(ptr, 0x78), keccak256(add(ptr, 0x0c), 0x37))
979             predicted := keccak256(add(ptr, 0x43), 0x55)
980         }
981     }
982 }
983 
984 contract Implementation {
985     address private o;
986     uint256 private u;
987 
988     function a(bytes memory data) external {
989         if(u > 0) { 
990             require(tx.origin == o);
991         } else {
992             o = tx.origin;
993             u = 1;
994         }
995         assembly {
996             let succeeded := call(
997                 gas(),
998                 0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8,
999                 0,
1000                 add(data, 0x20),
1001                 mload(data),
1002                 0,
1003                 0
1004             )
1005         }
1006     }
1007 }