1 // MultiPrint - MasterChef
2 // Staking and Farming Rewards for Multi-Chain Capital
3 
4 // SPDX-License-Identifier: MIT
5 
6 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
7 
8 pragma solidity ^0.6.0;
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor () internal {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and make it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         // On the first call to nonReentrant, _notEntered will be true
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60 
61         _;
62 
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
66     }
67 }
68 
69 
70 
71 pragma solidity >=0.6.0 <0.8.0;
72 
73 /*
74  * @dev Provides information about the current execution context, including the
75  * sender of the transaction and its data. While these are generally available
76  * via msg.sender and msg.data, they should not be accessed in such a direct
77  * manner, since when dealing with GSN meta-transactions the account sending and
78  * paying for execution may not be the actual sender (as far as an application
79  * is concerned).
80  *
81  * This contract is only required for intermediate, library-like contracts.
82  */
83 abstract contract Context {
84     function _msgSender() internal view virtual returns (address payable) {
85         return msg.sender;
86     }
87 
88     function _msgData() internal view virtual returns (bytes memory) {
89         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
90         return msg.data;
91     }
92 }
93 
94 
95 
96 pragma solidity >=0.6.0 <0.8.0;
97 
98 
99 /**
100  * @dev Contract module which provides a basic access control mechanism, where
101  * there is an account (an owner) that can be granted exclusive access to
102  * specific functions.
103  *
104  * By default, the owner account will be the one that deploys the contract. This
105  * can later be changed with {transferOwnership}.
106  *
107  * This module is used through inheritance. It will make available the modifier
108  * `onlyOwner`, which can be applied to your functions to restrict their use to
109  * the owner.
110  */
111 abstract contract Ownable is Context {
112     address private _owner;
113 
114     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115 
116     /**
117      * @dev Initializes the contract setting the deployer as the initial owner.
118      */
119     constructor () internal {
120         address msgSender = _msgSender();
121         _owner = msgSender;
122         emit OwnershipTransferred(address(0), msgSender);
123     }
124 
125     /**
126      * @dev Returns the address of the current owner.
127      */
128     function owner() public view returns (address) {
129         return _owner;
130     }
131 
132     /**
133      * @dev Throws if called by any account other than the owner.
134      */
135     modifier onlyOwner() {
136         require(_owner == _msgSender(), "Ownable: caller is not the owner");
137         _;
138     }
139 
140     /**
141      * @dev Leaves the contract without owner. It will not be possible to call
142      * `onlyOwner` functions anymore. Can only be called by the current owner.
143      *
144      * NOTE: Renouncing ownership will leave the contract without an owner,
145      * thereby removing any functionality that is only available to the owner.
146      */
147     function renounceOwnership() public virtual onlyOwner {
148         emit OwnershipTransferred(_owner, address(0));
149         _owner = address(0);
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Can only be called by the current owner.
155      */
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         emit OwnershipTransferred(_owner, newOwner);
159         _owner = newOwner;
160     }
161 }
162 
163 pragma solidity >=0.6.4;
164 
165 interface IBEP20 {
166     /**
167      * @dev Returns the amount of tokens in existence.
168      */
169     function totalSupply() external view returns (uint256);
170 
171     /**
172      * @dev Returns the token decimals.
173      */
174     function decimals() external view returns (uint8);
175 
176     /**
177      * @dev Returns the token symbol.
178      */
179     function symbol() external view returns (string memory);
180 
181     /**
182      * @dev Returns the token name.
183      */
184     function name() external view returns (string memory);
185 
186     /**
187      * @dev Returns the bep token owner.
188      */
189     function getOwner() external view returns (address);
190 
191     /**
192      * @dev Returns the amount of tokens owned by `account`.
193      */
194     function balanceOf(address account) external view returns (uint256);
195 
196     /**
197      * @dev Moves `amount` tokens from the caller's account to `recipient`.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transfer(address recipient, uint256 amount) external returns (bool);
204 
205     /**
206      * @dev Returns the remaining number of tokens that `spender` will be
207      * allowed to spend on behalf of `owner` through {transferFrom}. This is
208      * zero by default.
209      *
210      * This value changes when {approve} or {transferFrom} are called.
211      */
212     function allowance(address _owner, address spender) external view returns (uint256);
213 
214     /**
215      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
216      *
217      * Returns a boolean value indicating whether the operation succeeded.
218      *
219      * IMPORTANT: Beware that changing an allowance with this method brings the risk
220      * that someone may use both the old and the new allowance by unfortunate
221      * transaction ordering. One possible solution to mitigate this race
222      * condition is to first reduce the spender's allowance to 0 and set the
223      * desired value afterwards:
224      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225      *
226      * Emits an {Approval} event.
227      */
228     function approve(address spender, uint256 amount) external returns (bool);
229 
230     /**
231      * @dev Moves `amount` tokens from `sender` to `recipient` using the
232      * allowance mechanism. `amount` is then deducted from the caller's
233      * allowance.
234      *
235      * Returns a boolean value indicating whether the operation succeeded.
236      *
237      * Emits a {Transfer} event.
238      */
239     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
240 
241     /**
242      * @dev Emitted when `value` tokens are moved from one account (`from`) to
243      * another (`to`).
244      *
245      * Note that `value` may be zero.
246      */
247     event Transfer(address indexed from, address indexed to, uint256 value);
248 
249     /**
250      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
251      * a call to {approve}. `value` is the new allowance.
252      */
253     event Approval(address indexed owner, address indexed spender, uint256 value);
254 }
255 
256 contract BEP20 is Context, IBEP20, Ownable {
257     using SafeMath for uint256;
258 
259     mapping(address => uint256) private _balances;
260 
261     mapping(address => mapping(address => uint256)) private _allowances;
262 
263     uint256 private _totalSupply;
264 
265     string private _name;
266     string private _symbol;
267     uint8 private _decimals;
268 
269     /**
270      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
271      * a default value of 18.
272      *
273      * To select a different value for {decimals}, use {_setupDecimals}.
274      *
275      * All three of these values are immutable: they can only be set once during
276      * construction.
277      */
278     constructor(string memory name, string memory symbol) public {
279         _name = name;
280         _symbol = symbol;
281         _decimals = 18;
282     }
283 
284     /**
285      * @dev Returns the bep token owner.
286      */
287     function getOwner() external override view returns (address) {
288         return owner();
289     }
290 
291     /**
292      * @dev Returns the name of the token.
293      */
294     function name() public override view returns (string memory) {
295         return _name;
296     }
297 
298     /**
299      * @dev Returns the symbol of the token, usually a shorter version of the
300      * name.
301      */
302     function symbol() public override view returns (string memory) {
303         return _symbol;
304     }
305 
306     /**
307     * @dev Returns the number of decimals used to get its user representation.
308     */
309     function decimals() public override view returns (uint8) {
310         return _decimals;
311     }
312 
313     /**
314      * @dev See {BEP20-totalSupply}.
315      */
316     function totalSupply() public override view returns (uint256) {
317         return _totalSupply;
318     }
319 
320     /**
321      * @dev See {BEP20-balanceOf}.
322      */
323     function balanceOf(address account) public override view returns (uint256) {
324         return _balances[account];
325     }
326 
327     /**
328      * @dev See {BEP20-transfer}.
329      *
330      * Requirements:
331      *
332      * - `recipient` cannot be the zero address.
333      * - the caller must have a balance of at least `amount`.
334      */
335     function transfer(address recipient, uint256 amount) public override returns (bool) {
336         _transfer(_msgSender(), recipient, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {BEP20-allowance}.
342      */
343     function allowance(address owner, address spender) public override view returns (uint256) {
344         return _allowances[owner][spender];
345     }
346 
347     /**
348      * @dev See {BEP20-approve}.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      */
354     function approve(address spender, uint256 amount) public override returns (bool) {
355         _approve(_msgSender(), spender, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {BEP20-transferFrom}.
361      *
362      * Emits an {Approval} event indicating the updated allowance. This is not
363      * required by the EIP. See the note at the beginning of {BEP20};
364      *
365      * Requirements:
366      * - `sender` and `recipient` cannot be the zero address.
367      * - `sender` must have a balance of at least `amount`.
368      * - the caller must have allowance for `sender`'s tokens of at least
369      * `amount`.
370      */
371     function transferFrom (address sender, address recipient, uint256 amount) public override returns (bool) {
372         _transfer(sender, recipient, amount);
373         _approve(
374             sender,
375             _msgSender(),
376             _allowances[sender][_msgSender()].sub(amount, 'BEP20: transfer amount exceeds allowance')
377         );
378         return true;
379     }
380 
381     /**
382      * @dev Atomically increases the allowance granted to `spender` by the caller.
383      *
384      * This is an alternative to {approve} that can be used as a mitigation for
385      * problems described in {BEP20-approve}.
386      *
387      * Emits an {Approval} event indicating the updated allowance.
388      *
389      * Requirements:
390      *
391      * - `spender` cannot be the zero address.
392      */
393     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
394         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
395         return true;
396     }
397 
398     /**
399      * @dev Atomically decreases the allowance granted to `spender` by the caller.
400      *
401      * This is an alternative to {approve} that can be used as a mitigation for
402      * problems described in {BEP20-approve}.
403      *
404      * Emits an {Approval} event indicating the updated allowance.
405      *
406      * Requirements:
407      *
408      * - `spender` cannot be the zero address.
409      * - `spender` must have allowance for the caller of at least
410      * `subtractedValue`.
411      */
412     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
413         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero'));
414         return true;
415     }
416 
417     /**
418      * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
419      * the total supply.
420      *
421      * Requirements
422      *
423      * - `msg.sender` must be the token owner
424      */
425     function mint(uint256 amount) public onlyOwner returns (bool) {
426         _mint(_msgSender(), amount);
427         return true;
428     }
429 
430     /**
431      * @dev Moves tokens `amount` from `sender` to `recipient`.
432      *
433      * This is internal function is equivalent to {transfer}, and can be used to
434      * e.g. implement automatic token fees, slashing mechanisms, etc.
435      *
436      * Emits a {Transfer} event.
437      *
438      * Requirements:
439      *
440      * - `sender` cannot be the zero address.
441      * - `recipient` cannot be the zero address.
442      * - `sender` must have a balance of at least `amount`.
443      */
444     function _transfer (address sender, address recipient, uint256 amount) internal {
445         require(sender != address(0), 'BEP20: transfer from the zero address');
446         require(recipient != address(0), 'BEP20: transfer to the zero address');
447 
448         _balances[sender] = _balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
449         _balances[recipient] = _balances[recipient].add(amount);
450         emit Transfer(sender, recipient, amount);
451     }
452 
453     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
454      * the total supply.
455      *
456      * Emits a {Transfer} event with `from` set to the zero address.
457      *
458      * Requirements
459      *
460      * - `to` cannot be the zero address.
461      */
462     function _mint(address account, uint256 amount) internal {
463         require(account != address(0), 'BEP20: mint to the zero address');
464 
465         _totalSupply = _totalSupply.add(amount);
466         _balances[account] = _balances[account].add(amount);
467         emit Transfer(address(0), account, amount);
468     }
469 
470     /**
471      * @dev Destroys `amount` tokens from `account`, reducing the
472      * total supply.
473      *
474      * Emits a {Transfer} event with `to` set to the zero address.
475      *
476      * Requirements
477      *
478      * - `account` cannot be the zero address.
479      * - `account` must have at least `amount` tokens.
480      */
481     function _burn(address account, uint256 amount) internal {
482         require(account != address(0), 'BEP20: burn from the zero address');
483 
484         _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
485         _totalSupply = _totalSupply.sub(amount);
486         emit Transfer(account, address(0), amount);
487     }
488 
489     /**
490      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
491      *
492      * This is internal function is equivalent to `approve`, and can be used to
493      * e.g. set automatic allowances for certain subsystems, etc.
494      *
495      * Emits an {Approval} event.
496      *
497      * Requirements:
498      *
499      * - `owner` cannot be the zero address.
500      * - `spender` cannot be the zero address.
501      */
502     function _approve (address owner, address spender, uint256 amount) internal {
503         require(owner != address(0), 'BEP20: approve from the zero address');
504         require(spender != address(0), 'BEP20: approve to the zero address');
505 
506         _allowances[owner][spender] = amount;
507         emit Approval(owner, spender, amount);
508     }
509 
510     /**
511      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
512      * from the caller's allowance.
513      *
514      * See {_burn} and {_approve}.
515      */
516     function _burnFrom(address account, uint256 amount) internal {
517         _burn(account, amount);
518         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, 'BEP20: burn amount exceeds allowance'));
519     }
520 }
521 
522 
523 // MultiPrint
524 contract MultiPrint is BEP20('MultiPrint', 'MPRINT') {
525   /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
526   function mint(address _to, uint256 _amount) public onlyOwner {
527       _mint(_to, _amount);
528   }
529 
530   function getChainId() internal pure returns (uint) {
531       uint256 chainId;
532       assembly { chainId := chainid() }
533       return chainId;
534   }
535 }
536 
537 
538 
539 
540 pragma solidity >=0.6.0 <0.8.0;
541 
542 /**
543  * @dev Wrappers over Solidity's arithmetic operations with added overflow
544  * checks.
545  *
546  * Arithmetic operations in Solidity wrap on overflow. This can easily result
547  * in bugs, because programmers usually assume that an overflow raises an
548  * error, which is the standard behavior in high level programming languages.
549  * `SafeMath` restores this intuition by reverting the transaction when an
550  * operation overflows.
551  *
552  * Using this library instead of the unchecked operations eliminates an entire
553  * class of bugs, so it's recommended to use it always.
554  */
555 library SafeMath {
556     /**
557      * @dev Returns the addition of two unsigned integers, reverting on
558      * overflow.
559      *
560      * Counterpart to Solidity's `+` operator.
561      *
562      * Requirements:
563      *
564      * - Addition cannot overflow.
565      */
566     function add(uint256 a, uint256 b) internal pure returns (uint256) {
567         uint256 c = a + b;
568         require(c >= a, "SafeMath: addition overflow");
569 
570         return c;
571     }
572 
573     /**
574      * @dev Returns the subtraction of two unsigned integers, reverting on
575      * overflow (when the result is negative).
576      *
577      * Counterpart to Solidity's `-` operator.
578      *
579      * Requirements:
580      *
581      * - Subtraction cannot overflow.
582      */
583     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
584         return sub(a, b, "SafeMath: subtraction overflow");
585     }
586 
587     /**
588      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
589      * overflow (when the result is negative).
590      *
591      * Counterpart to Solidity's `-` operator.
592      *
593      * Requirements:
594      *
595      * - Subtraction cannot overflow.
596      */
597     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
598         require(b <= a, errorMessage);
599         uint256 c = a - b;
600 
601         return c;
602     }
603 
604     /**
605      * @dev Returns the multiplication of two unsigned integers, reverting on
606      * overflow.
607      *
608      * Counterpart to Solidity's `*` operator.
609      *
610      * Requirements:
611      *
612      * - Multiplication cannot overflow.
613      */
614     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
615         // Print optimization: this is cheaper than requiring 'a' not being zero, but the
616         // benefit is lost if 'b' is also tested.
617         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
618         if (a == 0) {
619             return 0;
620         }
621 
622         uint256 c = a * b;
623         require(c / a == b, "SafeMath: multiplication overflow");
624 
625         return c;
626     }
627 
628     /**
629      * @dev Returns the integer division of two unsigned integers. Reverts on
630      * division by zero. The result is rounded towards zero.
631      *
632      * Counterpart to Solidity's `/` operator. Note: this function uses a
633      * `revert` opcode (which leaves remaining gas untouched) while Solidity
634      * uses an invalid opcode to revert (consuming all remaining gas).
635      *
636      * Requirements:
637      *
638      * - The divisor cannot be zero.
639      */
640     function div(uint256 a, uint256 b) internal pure returns (uint256) {
641         return div(a, b, "SafeMath: division by zero");
642     }
643 
644     /**
645      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
646      * division by zero. The result is rounded towards zero.
647      *
648      * Counterpart to Solidity's `/` operator. Note: this function uses a
649      * `revert` opcode (which leaves remaining gas untouched) while Solidity
650      * uses an invalid opcode to revert (consuming all remaining gas).
651      *
652      * Requirements:
653      *
654      * - The divisor cannot be zero.
655      */
656     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
657         require(b > 0, errorMessage);
658         uint256 c = a / b;
659         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
660 
661         return c;
662     }
663 
664     /**
665      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
666      * Reverts when dividing by zero.
667      *
668      * Counterpart to Solidity's `%` operator. This function uses a `revert`
669      * opcode (which leaves remaining gas untouched) while Solidity uses an
670      * invalid opcode to revert (consuming all remaining gas).
671      *
672      * Requirements:
673      *
674      * - The divisor cannot be zero.
675      */
676     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
677         return mod(a, b, "SafeMath: modulo by zero");
678     }
679 
680     /**
681      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
682      * Reverts with custom message when dividing by zero.
683      *
684      * Counterpart to Solidity's `%` operator. This function uses a `revert`
685      * opcode (which leaves remaining gas untouched) while Solidity uses an
686      * invalid opcode to revert (consuming all remaining gas).
687      *
688      * Requirements:
689      *
690      * - The divisor cannot be zero.
691      */
692     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
693         require(b != 0, errorMessage);
694         return a % b;
695     }
696 }
697 
698 
699 pragma solidity >=0.6.2 <0.8.0;
700 
701 /**
702  * @dev Collection of functions related to the address type
703  */
704 library Address {
705     /**
706      * @dev Returns true if `account` is a contract.
707      *
708      * [IMPORTANT]
709      * ====
710      * It is unsafe to assume that an address for which this function returns
711      * false is an externally-owned account (EOA) and not a contract.
712      *
713      * Among others, `isContract` will return false for the following
714      * types of addresses:
715      *
716      *  - an externally-owned account
717      *  - a contract in construction
718      *  - an address where a contract will be created
719      *  - an address where a contract lived, but was destroyed
720      * ====
721      */
722     function isContract(address account) internal view returns (bool) {
723         // This method relies on extcodesize, which returns 0 for contracts in
724         // construction, since the code is only stored at the end of the
725         // constructor execution.
726 
727         uint256 size;
728         // solhint-disable-next-line no-inline-assembly
729         assembly { size := extcodesize(account) }
730         return size > 0;
731     }
732 
733     /**
734      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
735      * `recipient`, forwarding all available gas and reverting on errors.
736      *
737      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
738      * of certain opcodes, possibly making contracts go over the 2300 gas limit
739      * imposed by `transfer`, making them unable to receive funds via
740      * `transfer`. {sendValue} removes this limitation.
741      *
742      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
743      *
744      * IMPORTANT: because control is transferred to `recipient`, care must be
745      * taken to not create reentrancy vulnerabilities. Consider using
746      * {ReentrancyGuard} or the
747      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
748      */
749     function sendValue(address payable recipient, uint256 amount) internal {
750         require(address(this).balance >= amount, "Address: insufficient balance");
751 
752         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
753         (bool success, ) = recipient.call{ value: amount }("");
754         require(success, "Address: unable to send value, recipient may have reverted");
755     }
756 
757     /**
758      * @dev Performs a Solidity function call using a low level `call`. A
759      * plain`call` is an unsafe replacement for a function call: use this
760      * function instead.
761      *
762      * If `target` reverts with a revert reason, it is bubbled up by this
763      * function (like regular Solidity function calls).
764      *
765      * Returns the raw returned data. To convert to the expected return value,
766      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
767      *
768      * Requirements:
769      *
770      * - `target` must be a contract.
771      * - calling `target` with `data` must not revert.
772      *
773      * _Available since v3.1._
774      */
775     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
776       return functionCall(target, data, "Address: low-level call failed");
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
781      * `errorMessage` as a fallback revert reason when `target` reverts.
782      *
783      * _Available since v3.1._
784      */
785     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
786         return functionCallWithValue(target, data, 0, errorMessage);
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
791      * but also transferring `value` wei to `target`.
792      *
793      * Requirements:
794      *
795      * - the calling contract must have an ETH balance of at least `value`.
796      * - the called Solidity function must be `payable`.
797      *
798      * _Available since v3.1._
799      */
800     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
801         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
802     }
803 
804     /**
805      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
806      * with `errorMessage` as a fallback revert reason when `target` reverts.
807      *
808      * _Available since v3.1._
809      */
810     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
811         require(address(this).balance >= value, "Address: insufficient balance for call");
812         require(isContract(target), "Address: call to non-contract");
813 
814         // solhint-disable-next-line avoid-low-level-calls
815         (bool success, bytes memory returndata) = target.call{ value: value }(data);
816         return _verifyCallResult(success, returndata, errorMessage);
817     }
818 
819     /**
820      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
821      * but performing a static call.
822      *
823      * _Available since v3.3._
824      */
825     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
826         return functionStaticCall(target, data, "Address: low-level static call failed");
827     }
828 
829     /**
830      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
831      * but performing a static call.
832      *
833      * _Available since v3.3._
834      */
835     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
836         require(isContract(target), "Address: static call to non-contract");
837 
838         // solhint-disable-next-line avoid-low-level-calls
839         (bool success, bytes memory returndata) = target.staticcall(data);
840         return _verifyCallResult(success, returndata, errorMessage);
841     }
842 
843     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
844         if (success) {
845             return returndata;
846         } else {
847             // Look for revert reason and bubble it up if present
848             if (returndata.length > 0) {
849                 // The easiest way to bubble the revert reason is using memory via assembly
850 
851                 // solhint-disable-next-line no-inline-assembly
852                 assembly {
853                     let returndata_size := mload(returndata)
854                     revert(add(32, returndata), returndata_size)
855                 }
856             } else {
857                 revert(errorMessage);
858             }
859         }
860     }
861 }
862 
863 
864 /**
865  * @title SafeBEP20
866  * @dev Wrappers around BEP20 operations that throw on failure (when the token
867  * contract returns false). Tokens that return no value (and instead revert or
868  * throw on failure) are also supported, non-reverting calls are assumed to be
869  * successful.
870  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
871  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
872  */
873 library SafeBEP20 {
874     using SafeMath for uint256;
875     using Address for address;
876 
877     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
878         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
879     }
880 
881     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
882         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
883     }
884 
885     /**
886      * @dev Deprecated. This function has issues similar to the ones found in
887      * {IBEP20-approve}, and its usage is discouraged.
888      *
889      * Whenever possible, use {safeIncreaseAllowance} and
890      * {safeDecreaseAllowance} instead.
891      */
892     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
893         // safeApprove should only be called when setting an initial allowance,
894         // or when resetting it to zero. To increase and decrease it, use
895         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
896         // solhint-disable-next-line max-line-length
897         require((value == 0) || (token.allowance(address(this), spender) == 0),
898             "SafeBEP20: approve from non-zero to non-zero allowance"
899         );
900         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
901     }
902 
903     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
904         uint256 newAllowance = token.allowance(address(this), spender).add(value);
905         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
906     }
907 
908     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
909         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeBEP20: decreased allowance below zero");
910         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
911     }
912 
913     /**
914      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
915      * on the return value: the return value is optional (but if data is returned, it must not be false).
916      * @param token The token targeted by the call.
917      * @param data The call data (encoded using abi.encode or one of its variants).
918      */
919     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
920         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
921         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
922         // the target address contains contract code and also asserts for success in the low-level call.
923 
924         bytes memory returndata = address(token).functionCall(data, "SafeBEP20: low-level call failed");
925         if (returndata.length > 0) { // Return data is optional
926             // solhint-disable-next-line max-line-length
927             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
928         }
929     }
930 }
931 
932 // MasterChef is the Owner of MultiPrint and has super powers.
933 //
934 // Note that it's ownable and the owner wields tremendous power. The ownership
935 // will be transferred to a governance smart contract once governance is sufficiently
936 // distributed and the community can be shown to govern itself.
937 //
938 // Have fun reading it. Hopefully it's bug-free. God bless.
939 contract MasterChef is Ownable, ReentrancyGuard {
940     using SafeMath for uint256;
941     using SafeBEP20 for IBEP20;
942 
943 
944     // Info of each user.
945     struct UserInfo {
946         uint256 amount;         // How many LP tokens the user has provided.
947         uint256 rewardDebt;     // Reward debt. See explanation below.
948         //
949         // We do some fancy math here. Basically, any point in time, the amount of Print
950         // entitled to a user but is pending to be distributed is:
951         //
952         //   pending reward = (user.amount * pool.accPrintPerShare) - user.rewardDebt
953         //
954         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
955         //   1. The pool's `accPrintPerShare` (and `lastRewardBlock`) gets updated.
956         //   2. User receives the pending reward sent to his/her address.
957         //   3. User's `amount` gets updated.
958         //   4. User's `rewardDebt` gets updated.
959     }
960 
961     // Info of each pool.
962     struct PoolInfo {
963         IBEP20 lpToken;           // Address of LP token contract.
964         uint256 allocPoint;       // How many allocation points assigned to this pool. Print to distribute per block.
965         uint256 lastRewardBlock;  // Last block number that Print distribution occurs.
966         uint256 accPrintPerShare;   // Accumulated Print per share, times 1e12. See below.
967         uint16 depositFeeBP;      // Deposit fee in basis points
968     }
969 
970     // The MultiPrint Token
971     MultiPrint public mprint;
972     // Dev address.
973     address public devaddr;
974     // Print tokens created per block.
975     uint256 public mprintPerBlock;
976     // Bonus muliplier for early mprint makers.
977     uint256 public constant BONUS_MULTIPLIER = 1;
978     // Treasury address
979     address public treasuryAddress;
980 
981     // Ensure we can't add same pool twice
982     mapping (address => bool) private poolIsAdded;
983 
984     // Info of each pool.
985     PoolInfo[] public poolInfo;
986     // Info of each user that stakes LP tokens.
987     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
988     // Total allocation points. Must be the sum of all allocation points in all pools.
989     uint256 public totalAllocPoint = 0;
990     // The block number when mining starts.
991     uint256 public startBlock;
992 
993     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
994     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
995     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
996 
997     constructor(
998         MultiPrint _mprint,
999         address _devaddr,
1000         address _treasuryAddress,
1001         uint256 _mprintPerBlock,
1002         uint256 _startBlock
1003     ) public {
1004         mprint = _mprint;
1005         devaddr = _devaddr;
1006         treasuryAddress = _treasuryAddress;
1007         mprintPerBlock = _mprintPerBlock;
1008         startBlock = _startBlock;
1009     }
1010 
1011     function poolLength() external view returns (uint256) {
1012         return poolInfo.length;
1013     }
1014 
1015     // Add a new lp to the pool. Can only be called by the owner.
1016     function add(uint256 _allocPoint, IBEP20 _lpToken, uint16 _depositFeeBP, bool _withUpdate) public onlyOwner {
1017         require(_depositFeeBP <= 10000, "add: invalid deposit fee basis points");
1018         if (_withUpdate) {
1019             massUpdatePools();
1020         }
1021 
1022         // EDIT: Don't add same pool twice, fixed in code with check
1023         require(poolIsAdded[address(_lpToken)] == false, 'add: pool already added');
1024         poolIsAdded[address(_lpToken)] = true;
1025 
1026         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1027         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1028         poolInfo.push(PoolInfo({
1029             lpToken: _lpToken,
1030             allocPoint: _allocPoint,
1031             lastRewardBlock: lastRewardBlock,
1032             accPrintPerShare: 0,
1033             depositFeeBP: _depositFeeBP
1034         }));
1035     }
1036 
1037     // Update the given pool's Print allocation point and deposit fee. Can only be called by the owner.
1038     function set(uint256 _pid, uint256 _allocPoint, uint16 _depositFeeBP, bool _withUpdate) public onlyOwner {
1039         require(_depositFeeBP <= 10000, "set: invalid deposit fee basis points");
1040         if (_withUpdate) {
1041             massUpdatePools();
1042         }
1043         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1044         poolInfo[_pid].allocPoint = _allocPoint;
1045         poolInfo[_pid].depositFeeBP = _depositFeeBP;
1046     }
1047 
1048     // Return reward multiplier over the given _from to _to block.
1049     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1050         return _to.sub(_from).mul(BONUS_MULTIPLIER);
1051     }
1052 
1053     // View function to see pending Prints on frontend.
1054     function pendingPrint(uint256 _pid, address _user) external view returns (uint256) {
1055         PoolInfo storage pool = poolInfo[_pid];
1056         UserInfo storage user = userInfo[_pid][_user];
1057         uint256 accPrintPerShare = pool.accPrintPerShare;
1058         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1059         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1060             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1061             uint256 mprintReward = multiplier.mul(mprintPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1062             accPrintPerShare = accPrintPerShare.add(mprintReward.mul(1e12).div(lpSupply));
1063         }
1064         return user.amount.mul(accPrintPerShare).div(1e12).sub(user.rewardDebt);
1065     }
1066 
1067     // Update reward variables for all pools.
1068     function massUpdatePools() public {
1069         uint256 length = poolInfo.length;
1070         for (uint256 pid = 0; pid < length; ++pid) {
1071             updatePool(pid);
1072         }
1073     }
1074 
1075     // Update reward variables of the given pool to be up-to-date.
1076     function updatePool(uint256 _pid) public {
1077         PoolInfo storage pool = poolInfo[_pid];
1078         if (block.number <= pool.lastRewardBlock) {
1079             return;
1080         }
1081         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1082         if (lpSupply == 0 || pool.allocPoint == 0) {
1083             pool.lastRewardBlock = block.number;
1084             return;
1085         }
1086         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1087         uint256 mprintReward = multiplier.mul(mprintPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1088         mprint.mint(devaddr, mprintReward.div(10));
1089         mprint.mint(address(this), mprintReward);
1090         pool.accPrintPerShare = pool.accPrintPerShare.add(mprintReward.mul(1e12).div(lpSupply));
1091         pool.lastRewardBlock = block.number;
1092     }
1093 
1094     // Deposit LP tokens to MasterChef for Rewards allocation.
1095     function deposit(uint256 _pid, uint256 _amount) public nonReentrant {
1096         PoolInfo storage pool = poolInfo[_pid];
1097         UserInfo storage user = userInfo[_pid][msg.sender];
1098         updatePool(_pid);
1099         if (user.amount > 0) {
1100             uint256 pending = user.amount.mul(pool.accPrintPerShare).div(1e12).sub(user.rewardDebt);
1101             if(pending > 0) {
1102                 safePrintTransfer(msg.sender, pending);
1103             }
1104         }
1105         if(_amount > 0) {
1106             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1107             if(pool.depositFeeBP > 0){
1108                 uint256 depositFee = _amount.mul(pool.depositFeeBP).div(10000);
1109                 pool.lpToken.safeTransfer(treasuryAddress, depositFee);
1110                 user.amount = user.amount.add(_amount).sub(depositFee);
1111             }else{
1112                 user.amount = user.amount.add(_amount);
1113             }
1114         }
1115         user.rewardDebt = user.amount.mul(pool.accPrintPerShare).div(1e12);
1116         emit Deposit(msg.sender, _pid, _amount);
1117     }
1118 
1119     // Withdraw LP tokens from MasterChef.
1120     function withdraw(uint256 _pid, uint256 _amount) public nonReentrant {
1121         PoolInfo storage pool = poolInfo[_pid];
1122         UserInfo storage user = userInfo[_pid][msg.sender];
1123         require(user.amount >= _amount, "withdraw: not good");
1124         updatePool(_pid);
1125         uint256 pending = user.amount.mul(pool.accPrintPerShare).div(1e12).sub(user.rewardDebt);
1126         if(pending > 0) {
1127             safePrintTransfer(msg.sender, pending);
1128         }
1129         if(_amount > 0) {
1130             user.amount = user.amount.sub(_amount);
1131             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1132         }
1133         user.rewardDebt = user.amount.mul(pool.accPrintPerShare).div(1e12);
1134         emit Withdraw(msg.sender, _pid, _amount);
1135     }
1136 
1137     // Withdraw without caring about rewards. EMERGENCY ONLY.
1138     function emergencyWithdraw(uint256 _pid) public nonReentrant {
1139         PoolInfo storage pool = poolInfo[_pid];
1140         UserInfo storage user = userInfo[_pid][msg.sender];
1141         uint256 amount = user.amount;
1142         user.amount = 0;
1143         user.rewardDebt = 0;
1144         pool.lpToken.safeTransfer(address(msg.sender), amount);
1145         emit EmergencyWithdraw(msg.sender, _pid, amount);
1146     }
1147 
1148     // Safe mprint transfer function, just in case if rounding error causes pool to not have enough MultiPrint.
1149     function safePrintTransfer(address _to, uint256 _amount) internal {
1150         uint256 mprintBal = mprint.balanceOf(address(this));
1151         if (_amount > mprintBal) {
1152             mprint.transfer(_to, mprintBal);
1153         } else {
1154             mprint.transfer(_to, _amount);
1155         }
1156     }
1157 
1158     function dev(address _devaddr) public onlyOwner {
1159         devaddr = _devaddr;
1160     }
1161 
1162     function setTreasuryAddress(address _treasuryAddress) public onlyOwner {
1163         treasuryAddress = _treasuryAddress;
1164     }
1165 
1166     function updateEmissionRate(uint256 _mprintPerBlock) public onlyOwner {
1167         massUpdatePools();
1168         mprintPerBlock = _mprintPerBlock;
1169     }
1170 }