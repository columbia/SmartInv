1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-11
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.9;
7 
8 /** Tokenomics **
9 *
10 * - Total Supply
11 *   100,000,000,000 (== 10 ** 11)
12 * - Total Decimal
13 *   10 ** 18
14 * - Token Name & Symbol
15 *   "AXL INU", "AXL"
16 *
17 * - Token distribution
18 *   25%     Pre Sale
19 *   30%     Staking Rewards
20 *   20%     CEX Reserved
21 *   2.5%    Team Locked For 3 Years
22 *   15%     DEX Liquidity 
23 *   6.5%    Locked Incentives
24 *   1%      Airdrop
25 *
26 *   Top@copyright
27 */
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 
104 
105 /**
106  * @dev Interface for the optional metadata functions from the ERC20 standard.
107  *
108  * _Available since v4.1._
109  */
110 interface IERC20Metadata is IERC20 {
111     /**
112      * @dev Returns the name of the token.
113      */
114     function name() external view returns (string memory);
115 
116     /**
117      * @dev Returns the symbol of the token.
118      */
119     function symbol() external view returns (string memory);
120 
121     /**
122      * @dev Returns the decimals places of the token.
123      */
124     function decimals() external view returns (uint8);
125 }
126 
127 
128 
129 /*
130  * @dev Provides information about the current execution context, including the
131  * sender of the transaction and its data. While these are generally available
132  * via msg.sender and msg.data, they should not be accessed in such a direct
133  * manner, since when dealing with meta-transactions the account sending and
134  * paying for execution may not be the actual sender (as far as an application
135  * is concerned).
136  *
137  * This contract is only required for intermediate, library-like contracts.
138  */
139 abstract contract Context {
140     function _msgSender() internal view virtual returns (address) {
141         return msg.sender;
142     }
143 
144     function _msgData() internal view virtual returns (bytes calldata) {
145         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
146         return msg.data;
147     }
148 }
149 
150 /**
151  * @dev Wrappers over Solidity's arithmetic operations with added overflow
152  * checks.
153  *
154  * Arithmetic operations in Solidity wrap on overflow. This can easily result
155  * in bugs, because programmers usually assume that an overflow raises an
156  * error, which is the standard behavior in high level programming languages.
157  * `SafeMath` restores this intuition by reverting the transaction when an
158  * operation overflows.
159  *
160  * Using this library instead of the unchecked operations eliminates an entire
161  * class of bugs, so it's recommended to use it always.
162  */
163  
164 library SafeMath {
165     /**
166      * @dev Returns the addition of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `+` operator.
170      *
171      * Requirements:
172      *
173      * - Addition cannot overflow.
174      */
175     function add(uint256 a, uint256 b) internal pure returns (uint256) {
176         uint256 c = a + b;
177         require(c >= a, "SafeMath: addition overflow");
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the subtraction of two unsigned integers, reverting on
184      * overflow (when the result is negative).
185      *
186      * Counterpart to Solidity's `-` operator.
187      *
188      * Requirements:
189      *
190      * - Subtraction cannot overflow.
191      */
192     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
193         return sub(a, b, "SafeMath: subtraction overflow");
194     }
195 
196     /**
197      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
198      * overflow (when the result is negative).
199      *
200      * Counterpart to Solidity's `-` operator.
201      *
202      * Requirements:
203      *
204      * - Subtraction cannot overflow.
205      */
206     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b <= a, errorMessage);
208         uint256 c = a - b;
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the multiplication of two unsigned integers, reverting on
215      * overflow.
216      *
217      * Counterpart to Solidity's `*` operator.
218      *
219      * Requirements:
220      *
221      * - Multiplication cannot overflow.
222      */
223     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
225         // benefit is lost if 'b' is also tested.
226         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
227         if (a == 0) {
228             return 0;
229         }
230 
231         uint256 c = a * b;
232         require(c / a == b, "SafeMath: multiplication overflow");
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the integer division of two unsigned integers. Reverts on
239      * division by zero. The result is rounded towards zero.
240      *
241      * Counterpart to Solidity's `/` operator. Note: this function uses a
242      * `revert` opcode (which leaves remaining gas untouched) while Solidity
243      * uses an invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function div(uint256 a, uint256 b) internal pure returns (uint256) {
250         return div(a, b, "SafeMath: division by zero");
251     }
252 
253     /**
254      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
255      * division by zero. The result is rounded towards zero.
256      *
257      * Counterpart to Solidity's `/` operator. Note: this function uses a
258      * `revert` opcode (which leaves remaining gas untouched) while Solidity
259      * uses an invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b > 0, errorMessage);
267         uint256 c = a / b;
268         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
269 
270         return c;
271     }
272 
273     /**
274      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
275      * Reverts when dividing by zero.
276      *
277      * Counterpart to Solidity's `%` operator. This function uses a `revert`
278      * opcode (which leaves remaining gas untouched) while Solidity uses an
279      * invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
286         return mod(a, b, "SafeMath: modulo by zero");
287     }
288 
289     /**
290      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
291      * Reverts with custom message when dividing by zero.
292      *
293      * Counterpart to Solidity's `%` operator. This function uses a `revert`
294      * opcode (which leaves remaining gas untouched) while Solidity uses an
295      * invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b != 0, errorMessage);
303         return a % b;
304     }
305 }
306 
307 
308 /**
309  * @dev Contract module which provides a basic access control mechanism, where
310  * there is an account (an owner) that can be granted exclusive access to
311  * specific functions.
312  *
313  * By default, the owner account will be the one that deploys the contract. This
314  * can later be changed with {transferOwnership}.
315  *
316  * This module is used through inheritance. It will make available the modifier
317  * `onlyOwner`, which can be applied to your functions to restrict their use to
318  * the owner.
319  */
320 contract Ownable is Context {
321     address private _owner;
322     address private _previousOwner;
323     uint256 private _lockTime;
324 
325     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
326 
327     /**
328      * @dev Initializes the contract setting the deployer as the initial owner.
329      */
330     constructor () {
331         address msgSender = _msgSender();
332         _owner = msgSender;
333         emit OwnershipTransferred(address(0), msgSender);
334     }
335 
336     /**
337      * @dev Returns the address of the current owner.
338      */
339     function owner() public view returns (address) {
340         return _owner;
341     }
342 
343     /**
344      * @dev Throws if called by any account other than the owner.
345      */
346     modifier onlyOwner() {
347         require(_owner == _msgSender(), "Ownable: caller is not the owner");
348         _;
349     }
350 
351      /**
352      * @dev Leaves the contract without owner. It will not be possible to call
353      * `onlyOwner` functions anymore. Can only be called by the current owner.
354      *
355      * NOTE: Renouncing ownership will leave the contract without an owner,
356      * thereby removing any functionality that is only available to the owner.
357      */
358     function renounceOwnership() public virtual onlyOwner {
359         emit OwnershipTransferred(_owner, address(0));
360         _owner = address(0);
361     }
362 
363     /**
364      * @dev Transfers ownership of the contract to a new account (`newOwner`).
365      * Can only be called by the current owner.
366      */
367     function transferOwnership(address newOwner) public virtual onlyOwner {
368         require(newOwner != address(0), "Ownable: new owner is the zero address");
369         emit OwnershipTransferred(_owner, newOwner);
370         _owner = newOwner;
371     }
372 
373     function geUnlockTime() public view returns (uint256) {
374         return _lockTime;
375     }
376 
377     //Locks the contract for owner for the amount of time provided
378     function lock(uint256 time) public virtual onlyOwner {
379         _previousOwner = _owner;
380         _owner = address(0);
381         _lockTime = block.timestamp + time;
382         emit OwnershipTransferred(_owner, address(0));
383     }
384     
385     //Unlocks the contract for owner when _lockTime is exceeds
386     function unlock() public virtual {
387         require(_previousOwner == msg.sender, "You don't have permission to unlock");
388         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
389         emit OwnershipTransferred(_owner, _previousOwner);
390         _owner = _previousOwner;
391     }
392 }
393  
394 contract AXLToken is Context, IERC20, IERC20Metadata, Ownable {
395     mapping (address => uint256) private _balances;
396 
397     mapping (address => mapping (address => uint256)) private _allowances;
398 
399     uint256 private _totalSupply;
400     bool public mintingFinishedPermanent = false;
401     string private _name;
402     string private _symbol;
403     uint8 private _decimals;
404     address public _creator;
405     
406     uint256 _mintTimeStamp = block.timestamp;
407     
408     uint256 _deadlineTeamTimeStamp = block.timestamp + 3 * 3600 * 24 * 365;
409     
410     // Token distribution amount
411     uint256 public _presaleAmount;
412     uint256 public _stakingAmount;
413     uint256 public _cexReseveredAmount;
414     uint256 public _teamAmount;
415     uint256 public _incentiveAmount;
416     uint256 public _dexAmount;
417     uint256 public _airdropAmount;
418     
419     // Token distribution address
420     address presaleAddress;
421     address stakingAddress;
422     address cexReservedAddress;
423     address teamAddress;
424     address incentiveAddress;
425     address dexAddress;
426     address airdropAddress;
427     /**
428      * @dev Sets the values for {name}, {symbol} and {decimals}.
429      *
430      *
431      * All two of these values are immutable: they can only be set once during
432      * construction.
433      */
434     constructor () {
435         _name = "AXL INU";
436         _symbol = "AXL";
437         _decimals = 18;
438         _totalSupply = 1 * 10**11 * 10**18;
439         
440         _presaleAmount = 25 * 10**9 * 10**18;
441         _stakingAmount = 30 * 10**9 * 10**18;
442         _cexReseveredAmount = 20 * 10**9 * 10**18;
443         _teamAmount = 25 * 10**8 * 10**18;
444         _incentiveAmount = 65 * 10**8 * 10**18;
445         _dexAmount = 15 * 10**9 * 10**18;
446         _airdropAmount = 1 * 10**9 * 10**18;
447         
448         // Test address
449         // presaleAddress = 0xaC83aa6Dc293f488035Ee15B0364548D3DD3C0c4;
450         // stakingAddress = 0xaC83aa6Dc293f488035Ee15B0364548D3DD3C0c4;
451         // cexReservedAddress = 0xaC83aa6Dc293f488035Ee15B0364548D3DD3C0c4;
452         // teamAddress = 0xaC83aa6Dc293f488035Ee15B0364548D3DD3C0c4;
453         // incentiveAddress = 0xaC83aa6Dc293f488035Ee15B0364548D3DD3C0c4;
454         // dexAddress = 0xaC83aa6Dc293f488035Ee15B0364548D3DD3C0c4;
455         // airdropAddress = 0xaC83aa6Dc293f488035Ee15B0364548D3DD3C0c4;
456 
457         // Real address
458         presaleAddress = 0xa4fDeBC21F0d5b1549bEbC1D3aa298dA15571080;
459         stakingAddress = 0x367E4d1048dc5762E0bec77f4eDfe5048C298d5d;
460         cexReservedAddress = 0x6d2fffad1C836e751f4bAD1aA1dc161dA7Fc3ccE;
461         teamAddress = 0x0CBF05E9a2eAB636c3729520014C154e6a01fe1c;
462         incentiveAddress = 0x2b7bd5E543E2F4cc9068CCFeB9972554AA591b87;
463         dexAddress = 0x35351159Ea0af524f181716AD68635F68BB6B7e6;
464         airdropAddress = 0x6467e7ebeE4d234288dF15461f5F9c6Ed3eA0fdE; 
465 
466         require(_totalSupply == _presaleAmount + _stakingAmount + _cexReseveredAmount + _teamAmount + _incentiveAmount + _dexAmount + _airdropAmount, "BALCN");
467         
468         _mint(_msgSender(), _totalSupply);
469         mintingFinishedPermanent = true;
470         
471         // Initial Send tokens
472         transfer(presaleAddress, _presaleAmount);
473         transfer(stakingAddress, _stakingAmount);
474         transfer(cexReservedAddress, _cexReseveredAmount);
475         transfer(dexAddress, _dexAmount);
476         transfer(incentiveAddress, _incentiveAmount);
477         transfer(airdropAddress, _airdropAmount);
478     }
479 
480     /**
481      * @dev Returns the name of the token.
482      */
483     function name() public view virtual override returns (string memory) {
484         return _name;
485     }
486 
487     /**
488      * @dev Returns the symbol of the token, usually a shorter version of the
489      * name.
490      */
491     function symbol() public view virtual override returns (string memory) {
492         return _symbol;
493     }
494 
495     /**
496      * @dev Returns the number of decimals used to get its user representation.
497      * For example, if `decimals` equals `2`, a balance of `505` tokens should
498      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
499      *
500      * Tokens usually opt for a value of 18, imitating the relationship between
501      * Ether and Wei. This is the value {ERC20} uses, unless this function is
502      * overridden;
503      *
504      * NOTE: This information is only used for _display_ purposes: it in
505      * no way affects any of the arithmetic of the contract, including
506      * {IERC20-balanceOf} and {IERC20-transfer}.
507      */
508     function decimals() public view virtual override returns (uint8) {
509         return _decimals;
510     }
511 
512     /**
513      * @dev See {IERC20-totalSupply}.
514      */
515     function totalSupply() public view virtual override returns (uint256) {
516         return _totalSupply;
517     }
518 
519     /**
520      * @dev See {IERC20-balanceOf}.
521      */
522     function balanceOf(address account) public view virtual override returns (uint256) {
523         return _balances[account];
524     }
525 
526     /**
527      * @dev See {IERC20-transfer}.
528      *
529      * Requirements:
530      *
531      * - `recipient` cannot be the zero address.
532      * - the caller must have a balance of at least `amount`.
533      */
534     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
535         _transfer(_msgSender(), recipient, amount);
536         return true;
537     }
538 
539     /**
540      * @dev See {IERC20-allowance}.
541      */
542     function allowance(address owner, address spender) public view virtual override returns (uint256) {
543         return _allowances[owner][spender];
544     }
545 
546     /**
547      * @dev See {IERC20-approve}.
548      *
549      * Requirements:
550      *
551      * - `spender` cannot be the zero address.
552      */
553     function approve(address spender, uint256 amount) public virtual override returns (bool) {
554         _approve(_msgSender(), spender, amount);
555         return true;
556     }
557  
558     function transferToTeam() public onlyOwner()
559     {
560         require(_deadlineTeamTimeStamp <= block.timestamp, "Token for team is locked for 3 years.");
561         transfer(teamAddress, _teamAmount);
562     }
563 
564     /**
565      * @dev See {IERC20-transferFrom}.
566      *
567      * Emits an {Approval} event indicating the updated allowance. This is not
568      * required by the EIP. See the note at the beginning of {ERC20}.
569      *
570      * Requirements:
571      *
572      * - `sender` and `recipient` cannot be the zero address.
573      * - `sender` must have a balance of at least `amount`.
574      * - the caller must have allowance for ``sender``'s tokens of at least
575      * `amount`.
576      */
577     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
578         _transfer(sender, recipient, amount);
579 
580         uint256 currentAllowance = _allowances[sender][_msgSender()];
581         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
582         _approve(sender, _msgSender(), currentAllowance - amount);
583 
584         return true;
585     }
586 
587     /**
588      * @dev Atomically increases the allowance granted to `spender` by the caller.
589      *
590      * This is an alternative to {approve} that can be used as a mitigation for
591      * problems described in {IERC20-approve}.
592      *
593      * Emits an {Approval} event indicating the updated allowance.
594      *
595      * Requirements:
596      *
597      * - `spender` cannot be the zero address.
598      */
599     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
600         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
601         return true;
602     }
603 
604     /**
605      * @dev Atomically decreases the allowance granted to `spender` by the caller.
606      *
607      * This is an alternative to {approve} that can be used as a mitigation for
608      * problems described in {IERC20-approve}.
609      *
610      * Emits an {Approval} event indicating the updated allowance.
611      *
612      * Requirements:
613      *
614      * - `spender` cannot be the zero address.
615      * - `spender` must have allowance for the caller of at least
616      * `subtractedValue`.
617      */
618     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
619         uint256 currentAllowance = _allowances[_msgSender()][spender];
620         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
621         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
622 
623         return true;
624     }
625 
626     /**
627      * @dev Moves tokens `amount` from `sender` to `recipient`.
628      *
629      * This is internal function is equivalent to {transfer}, and can be used to
630      * e.g. implement automatic token fees, slashing mechanisms, etc.
631      *
632      * Emits a {Transfer} event.
633      *
634      * Requirements:
635      *
636      * - `sender` cannot be the zero address.
637      * - `recipient` cannot be the zero address.
638      * - `sender` must have a balance of at least `amount`.
639      */
640     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
641         require(sender != address(0), "ERC20: transfer from the zero address");
642         require(recipient != address(0), "ERC20: transfer to the zero address");
643 
644         _beforeTokenTransfer(sender, recipient, amount);
645 
646         uint256 senderBalance = _balances[sender];
647         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
648         _balances[sender] = senderBalance - amount;
649         _balances[recipient] += amount;
650 
651         emit Transfer(sender, recipient, amount);
652     }
653 
654     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
655      * the total supply.
656      *
657      * Emits a {Transfer} event with `from` set to the zero address.
658      *
659      * Requirements:
660      *
661      * - `account` cannot be the zero address.
662      */
663     function _mint(address account, uint256 amount) internal virtual {
664         require(!mintingFinishedPermanent,"cant be minted anymore!");
665         require(account != address(0), "ERC20: mint to the zero address");
666 
667         _beforeTokenTransfer(address(0), account, amount);
668 
669         //_totalSupply += amount;
670         _balances[account] += amount;
671         emit Transfer(address(0), account, amount);
672     } 
673 
674     /**
675      * @dev Destroys `amount` tokens from `account`, reducing the
676      * total supply.
677      *
678      * Emits a {Transfer} event with `to` set to the zero address.
679      *
680      * Requirements:
681      *
682      * - `account` cannot be the zero address.
683      * - `account` must have at least `amount` tokens.
684      */
685     function _burn(address account, uint256 amount) internal virtual {
686         require(account != address(0), "ERC20: burn from the zero address");
687 
688         _beforeTokenTransfer(account, address(0), amount);
689 
690         uint256 accountBalance = _balances[account];
691         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
692         _balances[account] = accountBalance - amount;
693         _totalSupply -= amount;
694 
695         emit Transfer(account, address(0), amount);
696     }
697 
698     /**
699      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
700      *
701      * This internal function is equivalent to `approve`, and can be used to
702      * e.g. set automatic allowances for certain subsystems, etc.
703      *
704      * Emits an {Approval} event.
705      *
706      * Requirements:
707      *
708      * - `owner` cannot be the zero address.
709      * - `spender` cannot be the zero address.
710      */
711     function _approve(address owner, address spender, uint256 amount) internal virtual {
712         require(owner != address(0), "ERC20: approve from the zero address");
713         require(spender != address(0), "ERC20: approve to the zero address");
714 
715         _allowances[owner][spender] = amount;
716         emit Approval(owner, spender, amount);
717     }
718 
719     /**
720      * @dev Hook that is called before any transfer of tokens. This includes
721      * minting and burning.
722      *
723      * Calling conditions:
724      *
725      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
726      * will be to transferred to `to`.
727      * - when `from` is zero, `amount` tokens will be minted for `to`.
728      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
729      * - `from` and `to` are never both zero.
730      *
731      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
732      */
733     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
734 }