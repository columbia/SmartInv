1 // Reflector Collector - ReflectorChef
2 // (Based on MasterChef)
3 //
4 // Additions:
5 // -Tracking of Token Balance Based on User Deposits
6 // -Harvesting of Additional Gained Reflections
7 
8 // SPDX-License-Identifier: MIT
9 
10 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
11 
12 pragma solidity ^0.6.0;
13 
14 /**
15  * @dev Contract module that helps prevent reentrant calls to a function.
16  *
17  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
18  * available, which can be applied to functions to make sure there are no nested
19  * (reentrant) calls to them.
20  *
21  * Note that because there is a single `nonReentrant` guard, functions marked as
22  * `nonReentrant` may not call one another. This can be worked around by making
23  * those functions `private`, and then adding `external` `nonReentrant` entry
24  * points to them.
25  *
26  * TIP: If you would like to learn more about reentrancy and alternative ways
27  * to protect against it, check out our blog post
28  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
29  */
30 abstract contract ReentrancyGuard {
31     // Booleans are more expensive than uint256 or any type that takes up a full
32     // word because each write operation emits an extra SLOAD to first read the
33     // slot's contents, replace the bits taken up by the boolean, and then write
34     // back. This is the compiler's defense against contract upgrades and
35     // pointer aliasing, and it cannot be disabled.
36 
37     // The values being non-zero value makes deployment a bit more expensive,
38     // but in exchange the refund on every call to nonReentrant will be lower in
39     // amount. Since refunds are capped to a percentage of the total
40     // transaction's gas, it is best to keep them low in cases like this one, to
41     // increase the likelihood of the full refund coming into effect.
42     uint256 private constant _NOT_ENTERED = 1;
43     uint256 private constant _ENTERED = 2;
44 
45     uint256 private _status;
46 
47     constructor () internal {
48         _status = _NOT_ENTERED;
49     }
50 
51     /**
52      * @dev Prevents a contract from calling itself, directly or indirectly.
53      * Calling a `nonReentrant` function from another `nonReentrant`
54      * function is not supported. It is possible to prevent this from happening
55      * by making the `nonReentrant` function external, and make it call a
56      * `private` function that does the actual work.
57      */
58     modifier nonReentrant() {
59         // On the first call to nonReentrant, _notEntered will be true
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64 
65         _;
66 
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 }
72 
73 
74 
75 pragma solidity >=0.6.0 <0.8.0;
76 
77 /*
78  * @dev Provides information about the current execution context, including the
79  * sender of the transaction and its data. While these are generally available
80  * via msg.sender and msg.data, they should not be accessed in such a direct
81  * manner, since when dealing with GSN meta-transactions the account sending and
82  * paying for execution may not be the actual sender (as far as an application
83  * is concerned).
84  *
85  * This contract is only required for intermediate, library-like contracts.
86  */
87 abstract contract Context {
88     function _msgSender() internal view virtual returns (address payable) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view virtual returns (bytes memory) {
93         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
94         return msg.data;
95     }
96 }
97 
98 
99 
100 pragma solidity >=0.6.0 <0.8.0;
101 
102 
103 /**
104  * @dev Contract module which provides a basic access control mechanism, where
105  * there is an account (an owner) that can be granted exclusive access to
106  * specific functions.
107  *
108  * By default, the owner account will be the one that deploys the contract. This
109  * can later be changed with {transferOwnership}.
110  *
111  * This module is used through inheritance. It will make available the modifier
112  * `onlyOwner`, which can be applied to your functions to restrict their use to
113  * the owner.
114  */
115 abstract contract Ownable is Context {
116     address private _owner;
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120     /**
121      * @dev Initializes the contract setting the deployer as the initial owner.
122      */
123     constructor () internal {
124         address msgSender = _msgSender();
125         _owner = msgSender;
126         emit OwnershipTransferred(address(0), msgSender);
127     }
128 
129     /**
130      * @dev Returns the address of the current owner.
131      */
132     function owner() public view returns (address) {
133         return _owner;
134     }
135 
136     /**
137      * @dev Throws if called by any account other than the owner.
138      */
139     modifier onlyOwner() {
140         require(_owner == _msgSender(), "Ownable: caller is not the owner");
141         _;
142     }
143 
144     /**
145      * @dev Leaves the contract without owner. It will not be possible to call
146      * `onlyOwner` functions anymore. Can only be called by the current owner.
147      *
148      * NOTE: Renouncing ownership will leave the contract without an owner,
149      * thereby removing any functionality that is only available to the owner.
150      */
151     function renounceOwnership() public virtual onlyOwner {
152         emit OwnershipTransferred(_owner, address(0));
153         _owner = address(0);
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         emit OwnershipTransferred(_owner, newOwner);
163         _owner = newOwner;
164     }
165 }
166 
167 pragma solidity >=0.6.4;
168 
169 interface IBEP20 {
170     /**
171      * @dev Returns the amount of tokens in existence.
172      */
173     function totalSupply() external view returns (uint256);
174 
175     /**
176      * @dev Returns the token decimals.
177      */
178     function decimals() external view returns (uint8);
179 
180     /**
181      * @dev Returns the token symbol.
182      */
183     function symbol() external view returns (string memory);
184 
185     /**
186      * @dev Returns the token name.
187      */
188     function name() external view returns (string memory);
189 
190     /**
191      * @dev Returns the bep token owner.
192      */
193     function getOwner() external view returns (address);
194 
195     /**
196      * @dev Returns the amount of tokens owned by `account`.
197      */
198     function balanceOf(address account) external view returns (uint256);
199 
200     /**
201      * @dev Moves `amount` tokens from the caller's account to `recipient`.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transfer(address recipient, uint256 amount) external returns (bool);
208 
209     /**
210      * @dev Returns the remaining number of tokens that `spender` will be
211      * allowed to spend on behalf of `owner` through {transferFrom}. This is
212      * zero by default.
213      *
214      * This value changes when {approve} or {transferFrom} are called.
215      */
216     function allowance(address _owner, address spender) external view returns (uint256);
217 
218     /**
219      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * IMPORTANT: Beware that changing an allowance with this method brings the risk
224      * that someone may use both the old and the new allowance by unfortunate
225      * transaction ordering. One possible solution to mitigate this race
226      * condition is to first reduce the spender's allowance to 0 and set the
227      * desired value afterwards:
228      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229      *
230      * Emits an {Approval} event.
231      */
232     function approve(address spender, uint256 amount) external returns (bool);
233 
234     /**
235      * @dev Moves `amount` tokens from `sender` to `recipient` using the
236      * allowance mechanism. `amount` is then deducted from the caller's
237      * allowance.
238      *
239      * Returns a boolean value indicating whether the operation succeeded.
240      *
241      * Emits a {Transfer} event.
242      */
243     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Emitted when `value` tokens are moved from one account (`from`) to
247      * another (`to`).
248      *
249      * Note that `value` may be zero.
250      */
251     event Transfer(address indexed from, address indexed to, uint256 value);
252 
253     /**
254      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
255      * a call to {approve}. `value` is the new allowance.
256      */
257     event Approval(address indexed owner, address indexed spender, uint256 value);
258 }
259 
260 contract BEP20 is Context, IBEP20, Ownable {
261     using SafeMath for uint256;
262 
263     mapping(address => uint256) private _balances;
264 
265     mapping(address => mapping(address => uint256)) private _allowances;
266 
267     uint256 private _totalSupply;
268 
269     string private _name;
270     string private _symbol;
271     uint8 private _decimals;
272 
273     /**
274      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
275      * a default value of 18.
276      *
277      * To select a different value for {decimals}, use {_setupDecimals}.
278      *
279      * All three of these values are immutable: they can only be set once during
280      * construction.
281      */
282     constructor(string memory name, string memory symbol) public {
283         _name = name;
284         _symbol = symbol;
285         _decimals = 18;
286     }
287 
288     /**
289      * @dev Returns the bep token owner.
290      */
291     function getOwner() external override view returns (address) {
292         return owner();
293     }
294 
295     /**
296      * @dev Returns the name of the token.
297      */
298     function name() public override view returns (string memory) {
299         return _name;
300     }
301 
302     /**
303      * @dev Returns the symbol of the token, usually a shorter version of the
304      * name.
305      */
306     function symbol() public override view returns (string memory) {
307         return _symbol;
308     }
309 
310     /**
311     * @dev Returns the number of decimals used to get its user representation.
312     */
313     function decimals() public override view returns (uint8) {
314         return _decimals;
315     }
316 
317     /**
318      * @dev See {BEP20-totalSupply}.
319      */
320     function totalSupply() public override view returns (uint256) {
321         return _totalSupply;
322     }
323 
324     /**
325      * @dev See {BEP20-balanceOf}.
326      */
327     function balanceOf(address account) public override view returns (uint256) {
328         return _balances[account];
329     }
330 
331     /**
332      * @dev See {BEP20-transfer}.
333      *
334      * Requirements:
335      *
336      * - `recipient` cannot be the zero address.
337      * - the caller must have a balance of at least `amount`.
338      */
339     function transfer(address recipient, uint256 amount) public override returns (bool) {
340         _transfer(_msgSender(), recipient, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {BEP20-allowance}.
346      */
347     function allowance(address owner, address spender) public override view returns (uint256) {
348         return _allowances[owner][spender];
349     }
350 
351     /**
352      * @dev See {BEP20-approve}.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      */
358     function approve(address spender, uint256 amount) public override returns (bool) {
359         _approve(_msgSender(), spender, amount);
360         return true;
361     }
362 
363     /**
364      * @dev See {BEP20-transferFrom}.
365      *
366      * Emits an {Approval} event indicating the updated allowance. This is not
367      * required by the EIP. See the note at the beginning of {BEP20};
368      *
369      * Requirements:
370      * - `sender` and `recipient` cannot be the zero address.
371      * - `sender` must have a balance of at least `amount`.
372      * - the caller must have allowance for `sender`'s tokens of at least
373      * `amount`.
374      */
375     function transferFrom (address sender, address recipient, uint256 amount) public override returns (bool) {
376         _transfer(sender, recipient, amount);
377         _approve(
378             sender,
379             _msgSender(),
380             _allowances[sender][_msgSender()].sub(amount, 'BEP20: transfer amount exceeds allowance')
381         );
382         return true;
383     }
384 
385     /**
386      * @dev Atomically increases the allowance granted to `spender` by the caller.
387      *
388      * This is an alternative to {approve} that can be used as a mitigation for
389      * problems described in {BEP20-approve}.
390      *
391      * Emits an {Approval} event indicating the updated allowance.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      */
397     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
398         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
399         return true;
400     }
401 
402     /**
403      * @dev Atomically decreases the allowance granted to `spender` by the caller.
404      *
405      * This is an alternative to {approve} that can be used as a mitigation for
406      * problems described in {BEP20-approve}.
407      *
408      * Emits an {Approval} event indicating the updated allowance.
409      *
410      * Requirements:
411      *
412      * - `spender` cannot be the zero address.
413      * - `spender` must have allowance for the caller of at least
414      * `subtractedValue`.
415      */
416     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
417         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero'));
418         return true;
419     }
420 
421     /**
422      * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
423      * the total supply.
424      *
425      * Requirements
426      *
427      * - `msg.sender` must be the token owner
428      */
429     function mint(uint256 amount) public onlyOwner returns (bool) {
430         _mint(_msgSender(), amount);
431         return true;
432     }
433 
434     /**
435      * @dev Moves tokens `amount` from `sender` to `recipient`.
436      *
437      * This is internal function is equivalent to {transfer}, and can be used to
438      * e.g. implement automatic token fees, slashing mechanisms, etc.
439      *
440      * Emits a {Transfer} event.
441      *
442      * Requirements:
443      *
444      * - `sender` cannot be the zero address.
445      * - `recipient` cannot be the zero address.
446      * - `sender` must have a balance of at least `amount`.
447      */
448     function _transfer (address sender, address recipient, uint256 amount) internal {
449         require(sender != address(0), 'BEP20: transfer from the zero address');
450         require(recipient != address(0), 'BEP20: transfer to the zero address');
451 
452         _balances[sender] = _balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
453         _balances[recipient] = _balances[recipient].add(amount);
454         emit Transfer(sender, recipient, amount);
455     }
456 
457     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
458      * the total supply.
459      *
460      * Emits a {Transfer} event with `from` set to the zero address.
461      *
462      * Requirements
463      *
464      * - `to` cannot be the zero address.
465      */
466     function _mint(address account, uint256 amount) internal {
467         require(account != address(0), 'BEP20: mint to the zero address');
468 
469         _totalSupply = _totalSupply.add(amount);
470         _balances[account] = _balances[account].add(amount);
471         emit Transfer(address(0), account, amount);
472     }
473 
474     /**
475      * @dev Destroys `amount` tokens from `account`, reducing the
476      * total supply.
477      *
478      * Emits a {Transfer} event with `to` set to the zero address.
479      *
480      * Requirements
481      *
482      * - `account` cannot be the zero address.
483      * - `account` must have at least `amount` tokens.
484      */
485     function _burn(address account, uint256 amount) internal {
486         require(account != address(0), 'BEP20: burn from the zero address');
487 
488         _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
489         _totalSupply = _totalSupply.sub(amount);
490         emit Transfer(account, address(0), amount);
491     }
492 
493     /**
494      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
495      *
496      * This is internal function is equivalent to `approve`, and can be used to
497      * e.g. set automatic allowances for certain subsystems, etc.
498      *
499      * Emits an {Approval} event.
500      *
501      * Requirements:
502      *
503      * - `owner` cannot be the zero address.
504      * - `spender` cannot be the zero address.
505      */
506     function _approve (address owner, address spender, uint256 amount) internal {
507         require(owner != address(0), 'BEP20: approve from the zero address');
508         require(spender != address(0), 'BEP20: approve to the zero address');
509 
510         _allowances[owner][spender] = amount;
511         emit Approval(owner, spender, amount);
512     }
513 
514     /**
515      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
516      * from the caller's allowance.
517      *
518      * See {_burn} and {_approve}.
519      */
520     function _burnFrom(address account, uint256 amount) internal {
521         _burn(account, amount);
522         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, 'BEP20: burn amount exceeds allowance'));
523     }
524 }
525 
526 
527 // ReflectorCollector 
528 contract ReflectorCollector is BEP20('ReflectorCollector', 'RC') {
529   /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
530   function mint(address _to, uint256 _amount) public onlyOwner {
531       _mint(_to, _amount);
532   }
533 
534   function getChainId() internal pure returns (uint) {
535       uint256 chainId;
536       assembly { chainId := chainid() }
537       return chainId;
538   }
539 }
540 
541 
542 
543 
544 pragma solidity >=0.6.0 <0.8.0;
545 
546 /**
547  * @dev Wrappers over Solidity's arithmetic operations with added overflow
548  * checks.
549  *
550  * Arithmetic operations in Solidity wrap on overflow. This can easily result
551  * in bugs, because programmers usually assume that an overflow raises an
552  * error, which is the standard behavior in high level programming languages.
553  * `SafeMath` restores this intuition by reverting the transaction when an
554  * operation overflows.
555  *
556  * Using this library instead of the unchecked operations eliminates an entire
557  * class of bugs, so it's recommended to use it always.
558  */
559 library SafeMath {
560     /**
561      * @dev Returns the addition of two unsigned integers, reverting on
562      * overflow.
563      *
564      * Counterpart to Solidity's `+` operator.
565      *
566      * Requirements:
567      *
568      * - Addition cannot overflow.
569      */
570     function add(uint256 a, uint256 b) internal pure returns (uint256) {
571         uint256 c = a + b;
572         require(c >= a, "SafeMath: addition overflow");
573 
574         return c;
575     }
576 
577     /**
578      * @dev Returns the subtraction of two unsigned integers, reverting on
579      * overflow (when the result is negative).
580      *
581      * Counterpart to Solidity's `-` operator.
582      *
583      * Requirements:
584      *
585      * - Subtraction cannot overflow.
586      */
587     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
588         return sub(a, b, "SafeMath: subtraction overflow");
589     }
590 
591     /**
592      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
593      * overflow (when the result is negative).
594      *
595      * Counterpart to Solidity's `-` operator.
596      *
597      * Requirements:
598      *
599      * - Subtraction cannot overflow.
600      */
601     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
602         require(b <= a, errorMessage);
603         uint256 c = a - b;
604 
605         return c;
606     }
607 
608     /**
609      * @dev Returns the multiplication of two unsigned integers, reverting on
610      * overflow.
611      *
612      * Counterpart to Solidity's `*` operator.
613      *
614      * Requirements:
615      *
616      * - Multiplication cannot overflow.
617      */
618     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
619         // Print optimization: this is cheaper than requiring 'a' not being zero, but the
620         // benefit is lost if 'b' is also tested.
621         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
622         if (a == 0) {
623             return 0;
624         }
625 
626         uint256 c = a * b;
627         require(c / a == b, "SafeMath: multiplication overflow");
628 
629         return c;
630     }
631 
632     /**
633      * @dev Returns the integer division of two unsigned integers. Reverts on
634      * division by zero. The result is rounded towards zero.
635      *
636      * Counterpart to Solidity's `/` operator. Note: this function uses a
637      * `revert` opcode (which leaves remaining gas untouched) while Solidity
638      * uses an invalid opcode to revert (consuming all remaining gas).
639      *
640      * Requirements:
641      *
642      * - The divisor cannot be zero.
643      */
644     function div(uint256 a, uint256 b) internal pure returns (uint256) {
645         return div(a, b, "SafeMath: division by zero");
646     }
647 
648     /**
649      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
650      * division by zero. The result is rounded towards zero.
651      *
652      * Counterpart to Solidity's `/` operator. Note: this function uses a
653      * `revert` opcode (which leaves remaining gas untouched) while Solidity
654      * uses an invalid opcode to revert (consuming all remaining gas).
655      *
656      * Requirements:
657      *
658      * - The divisor cannot be zero.
659      */
660     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
661         require(b > 0, errorMessage);
662         uint256 c = a / b;
663         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
664 
665         return c;
666     }
667 
668     /**
669      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
670      * Reverts when dividing by zero.
671      *
672      * Counterpart to Solidity's `%` operator. This function uses a `revert`
673      * opcode (which leaves remaining gas untouched) while Solidity uses an
674      * invalid opcode to revert (consuming all remaining gas).
675      *
676      * Requirements:
677      *
678      * - The divisor cannot be zero.
679      */
680     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
681         return mod(a, b, "SafeMath: modulo by zero");
682     }
683 
684     /**
685      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
686      * Reverts with custom message when dividing by zero.
687      *
688      * Counterpart to Solidity's `%` operator. This function uses a `revert`
689      * opcode (which leaves remaining gas untouched) while Solidity uses an
690      * invalid opcode to revert (consuming all remaining gas).
691      *
692      * Requirements:
693      *
694      * - The divisor cannot be zero.
695      */
696     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
697         require(b != 0, errorMessage);
698         return a % b;
699     }
700 }
701 
702 
703 pragma solidity >=0.6.2 <0.8.0;
704 
705 /**
706  * @dev Collection of functions related to the address type
707  */
708 library Address {
709     /**
710      * @dev Returns true if `account` is a contract.
711      *
712      * [IMPORTANT]
713      * ====
714      * It is unsafe to assume that an address for which this function returns
715      * false is an externally-owned account (EOA) and not a contract.
716      *
717      * Among others, `isContract` will return false for the following
718      * types of addresses:
719      *
720      *  - an externally-owned account
721      *  - a contract in construction
722      *  - an address where a contract will be created
723      *  - an address where a contract lived, but was destroyed
724      * ====
725      */
726     function isContract(address account) internal view returns (bool) {
727         // This method relies on extcodesize, which returns 0 for contracts in
728         // construction, since the code is only stored at the end of the
729         // constructor execution.
730 
731         uint256 size;
732         // solhint-disable-next-line no-inline-assembly
733         assembly { size := extcodesize(account) }
734         return size > 0;
735     }
736 
737     /**
738      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
739      * `recipient`, forwarding all available gas and reverting on errors.
740      *
741      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
742      * of certain opcodes, possibly making contracts go over the 2300 gas limit
743      * imposed by `transfer`, making them unable to receive funds via
744      * `transfer`. {sendValue} removes this limitation.
745      *
746      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
747      *
748      * IMPORTANT: because control is transferred to `recipient`, care must be
749      * taken to not create reentrancy vulnerabilities. Consider using
750      * {ReentrancyGuard} or the
751      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
752      */
753     function sendValue(address payable recipient, uint256 amount) internal {
754         require(address(this).balance >= amount, "Address: insufficient balance");
755 
756         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
757         (bool success, ) = recipient.call{ value: amount }("");
758         require(success, "Address: unable to send value, recipient may have reverted");
759     }
760 
761     /**
762      * @dev Performs a Solidity function call using a low level `call`. A
763      * plain`call` is an unsafe replacement for a function call: use this
764      * function instead.
765      *
766      * If `target` reverts with a revert reason, it is bubbled up by this
767      * function (like regular Solidity function calls).
768      *
769      * Returns the raw returned data. To convert to the expected return value,
770      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
771      *
772      * Requirements:
773      *
774      * - `target` must be a contract.
775      * - calling `target` with `data` must not revert.
776      *
777      * _Available since v3.1._
778      */
779     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
780       return functionCall(target, data, "Address: low-level call failed");
781     }
782 
783     /**
784      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
785      * `errorMessage` as a fallback revert reason when `target` reverts.
786      *
787      * _Available since v3.1._
788      */
789     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
790         return functionCallWithValue(target, data, 0, errorMessage);
791     }
792 
793     /**
794      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
795      * but also transferring `value` wei to `target`.
796      *
797      * Requirements:
798      *
799      * - the calling contract must have an ETH balance of at least `value`.
800      * - the called Solidity function must be `payable`.
801      *
802      * _Available since v3.1._
803      */
804     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
805         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
806     }
807 
808     /**
809      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
810      * with `errorMessage` as a fallback revert reason when `target` reverts.
811      *
812      * _Available since v3.1._
813      */
814     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
815         require(address(this).balance >= value, "Address: insufficient balance for call");
816         require(isContract(target), "Address: call to non-contract");
817 
818         // solhint-disable-next-line avoid-low-level-calls
819         (bool success, bytes memory returndata) = target.call{ value: value }(data);
820         return _verifyCallResult(success, returndata, errorMessage);
821     }
822 
823     /**
824      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
825      * but performing a static call.
826      *
827      * _Available since v3.3._
828      */
829     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
830         return functionStaticCall(target, data, "Address: low-level static call failed");
831     }
832 
833     /**
834      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
835      * but performing a static call.
836      *
837      * _Available since v3.3._
838      */
839     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
840         require(isContract(target), "Address: static call to non-contract");
841 
842         // solhint-disable-next-line avoid-low-level-calls
843         (bool success, bytes memory returndata) = target.staticcall(data);
844         return _verifyCallResult(success, returndata, errorMessage);
845     }
846 
847     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
848         if (success) {
849             return returndata;
850         } else {
851             // Look for revert reason and bubble it up if present
852             if (returndata.length > 0) {
853                 // The easiest way to bubble the revert reason is using memory via assembly
854 
855                 // solhint-disable-next-line no-inline-assembly
856                 assembly {
857                     let returndata_size := mload(returndata)
858                     revert(add(32, returndata), returndata_size)
859                 }
860             } else {
861                 revert(errorMessage);
862             }
863         }
864     }
865 }
866 
867 
868 /**
869  * @title SafeBEP20
870  * @dev Wrappers around BEP20 operations that throw on failure (when the token
871  * contract returns false). Tokens that return no value (and instead revert or
872  * throw on failure) are also supported, non-reverting calls are assumed to be
873  * successful.
874  * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
875  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
876  */
877 library SafeBEP20 {
878     using SafeMath for uint256;
879     using Address for address;
880 
881     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
882         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
883     }
884 
885     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
886         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
887     }
888 
889     /**
890      * @dev Deprecated. This function has issues similar to the ones found in
891      * {IBEP20-approve}, and its usage is discouraged.
892      *
893      * Whenever possible, use {safeIncreaseAllowance} and
894      * {safeDecreaseAllowance} instead.
895      */
896     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
897         // safeApprove should only be called when setting an initial allowance,
898         // or when resetting it to zero. To increase and decrease it, use
899         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
900         // solhint-disable-next-line max-line-length
901         require((value == 0) || (token.allowance(address(this), spender) == 0),
902             "SafeBEP20: approve from non-zero to non-zero allowance"
903         );
904         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
905     }
906 
907     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
908         uint256 newAllowance = token.allowance(address(this), spender).add(value);
909         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
910     }
911 
912     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
913         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeBEP20: decreased allowance below zero");
914         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
915     }
916 
917     /**
918      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
919      * on the return value: the return value is optional (but if data is returned, it must not be false).
920      * @param token The token targeted by the call.
921      * @param data The call data (encoded using abi.encode or one of its variants).
922      */
923     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
924         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
925         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
926         // the target address contains contract code and also asserts for success in the low-level call.
927 
928         bytes memory returndata = address(token).functionCall(data, "SafeBEP20: low-level call failed");
929         if (returndata.length > 0) { // Return data is optional
930             // solhint-disable-next-line max-line-length
931             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
932         }
933     }
934 }
935 
936 // ReflectorChef is the Owner of ReflectorCollector and has minting powers.
937 //
938 contract ReflectorChef is Ownable, ReentrancyGuard {
939     using SafeMath for uint256;
940     using SafeBEP20 for IBEP20;
941 
942 
943     // Info of each user.
944     struct UserInfo {
945         uint256 amount;         // How many LP tokens the user has provided.
946         uint256 rewardDebt;     // Reward debt. See explanation below.
947         //
948         // We do some fancy math here. Basically, any point in time, the amount of Print
949         // entitled to a user but is pending to be distributed is:
950         //
951         //   pending reward = (user.amount * pool.accRCollectorPerShare) - user.rewardDebt
952         //
953         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
954         //   1. The pool's `accRCollectorPerShare` (and `lastRewardBlock`) gets updated.
955         //   2. User receives the pending reward sent to his/her address.
956         //   3. User's `amount` gets updated.
957         //   4. User's `rewardDebt` gets updated.
958     }
959 
960     // Info of each pool.
961     struct PoolInfo {
962         IBEP20 lpToken;           // Address of LP token contract.
963         uint256 allocPoint;       // How many allocation points assigned to this pool. Print to distribute per block.
964         uint256 lastRewardBlock;  // Last block number that Print distribution occurs.
965         uint256 accRCollectorPerShare; // Accumulated Rcollector per share, times 1e12. See below.
966         uint256 totalBalance;     // Balance of User Deposits, Excluding Reflections
967         uint16 depositFeeBP;      // Deposit fee in basis points
968     }
969 
970     // The Reflector Collector Token
971     ReflectorCollector public rcollector;
972     // Dev address.
973     address public devaddr;
974     // Print tokens created per block.
975     uint256 public rcollectorPerBlock;
976     // Bonus muliplier for early rcollector makers.
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
998         ReflectorCollector _rcollector,
999         address _devaddr,
1000         address _treasuryAddress,
1001         uint256 _rcollectorPerBlock,
1002         uint256 _startBlock
1003     ) public {
1004         rcollector = _rcollector;
1005         devaddr = _devaddr;
1006         treasuryAddress = _treasuryAddress;
1007         rcollectorPerBlock = _rcollectorPerBlock;
1008         startBlock = _startBlock;
1009     }
1010 
1011     function poolLength() external view returns (uint256) {
1012         return poolInfo.length;
1013     }
1014 
1015     // View function to see Reflections on Frontend
1016     function pendingReflections(uint256 _pid) external view returns (uint256) {
1017         PoolInfo storage pool = poolInfo[_pid];
1018         uint256 lpSupply = pool.lpToken.balanceOf(address(this)); // Amount with Reflections
1019 
1020         return lpSupply.sub(pool.totalBalance); // Calculate Reflections Minus User Deposits
1021     }
1022 
1023     // Harvest a pools reflections that have been gathered. Can only be called by the owner.
1024     function harvestReflections(uint256 _pid) public onlyOwner {
1025         PoolInfo storage pool = poolInfo[_pid];
1026 
1027         uint256 lpSupply = pool.lpToken.balanceOf(address(this)); // Amount with Reflections
1028         uint256 addedReflections = lpSupply.sub(pool.totalBalance); // Calculate Reflections Minus User Deposits
1029         
1030         pool.lpToken.safeTransfer(address(treasuryAddress), addedReflections); // Harvest Reflections to Treasury
1031     }
1032 
1033     // Add a new lp to the pool. Can only be called by the owner.
1034     function add(uint256 _allocPoint, IBEP20 _lpToken, uint16 _depositFeeBP, bool _withUpdate) public onlyOwner {
1035         require(_depositFeeBP <= 10000, "add: invalid deposit fee basis points");
1036         if (_withUpdate) {
1037             massUpdatePools();
1038         }
1039 
1040         // EDIT: Don't add same pool twice, fixed in code with check
1041         require(poolIsAdded[address(_lpToken)] == false, 'add: pool already added');
1042         poolIsAdded[address(_lpToken)] = true;
1043 
1044         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1045         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1046         poolInfo.push(PoolInfo({
1047             lpToken: _lpToken,
1048             allocPoint: _allocPoint,
1049             lastRewardBlock: lastRewardBlock,
1050             accRCollectorPerShare: 0,
1051             totalBalance: 0,   // Balance of User Deposits, Excluding Reflections
1052             depositFeeBP: _depositFeeBP
1053         }));
1054     }
1055 
1056     // Update the given pool's Print allocation point and deposit fee. Can only be called by the owner.
1057     function set(uint256 _pid, uint256 _allocPoint, uint16 _depositFeeBP, bool _withUpdate) public onlyOwner {
1058         require(_depositFeeBP <= 10000, "set: invalid deposit fee basis points");
1059         if (_withUpdate) {
1060             massUpdatePools();
1061         }
1062         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1063         poolInfo[_pid].allocPoint = _allocPoint;
1064         poolInfo[_pid].depositFeeBP = _depositFeeBP;
1065     }
1066 
1067     // Return reward multiplier over the given _from to _to block.
1068     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1069         return _to.sub(_from).mul(BONUS_MULTIPLIER);
1070     }
1071 
1072 
1073     // View function to see pending Reflector Collector Rewards on frontend.
1074     function pendingRCollector(uint256 _pid, address _user) external view returns (uint256) {
1075         PoolInfo storage pool = poolInfo[_pid];
1076         UserInfo storage user = userInfo[_pid][_user];
1077         uint256 accRCollectorPerShare = pool.accRCollectorPerShare;
1078         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1079         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1080             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1081             uint256 rcollectorReward = multiplier.mul(rcollectorPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1082             accRCollectorPerShare = accRCollectorPerShare.add(rcollectorReward.mul(1e12).div(lpSupply));
1083         }
1084         return user.amount.mul(accRCollectorPerShare).div(1e12).sub(user.rewardDebt);
1085     }
1086 
1087     // Update reward variables for all pools.
1088     function massUpdatePools() public {
1089         uint256 length = poolInfo.length;
1090         for (uint256 pid = 0; pid < length; ++pid) {
1091             updatePool(pid);
1092         }
1093     }
1094 
1095     // Update reward variables of the given pool to be up-to-date.
1096     function updatePool(uint256 _pid) public {
1097         PoolInfo storage pool = poolInfo[_pid];
1098         if (block.number <= pool.lastRewardBlock) {
1099             return;
1100         }
1101         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1102         if (lpSupply == 0 || pool.allocPoint == 0) {
1103             pool.lastRewardBlock = block.number;
1104             return;
1105         }
1106         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1107         uint256 rcollectorReward = multiplier.mul(rcollectorPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1108         rcollector.mint(devaddr, rcollectorReward.div(10));
1109         rcollector.mint(address(this), rcollectorReward);
1110         pool.accRCollectorPerShare = pool.accRCollectorPerShare.add(rcollectorReward.mul(1e12).div(lpSupply));
1111         pool.lastRewardBlock = block.number;
1112     }
1113 
1114     // Deposit LP tokens to MasterChef for Rewards allocation.
1115     function deposit(uint256 _pid, uint256 _amount) public nonReentrant {
1116         PoolInfo storage pool = poolInfo[_pid];
1117         UserInfo storage user = userInfo[_pid][msg.sender];
1118         updatePool(_pid);
1119         if (user.amount > 0) {
1120             uint256 pending = user.amount.mul(pool.accRCollectorPerShare).div(1e12).sub(user.rewardDebt);
1121             if(pending > 0) {
1122                 safePrintTransfer(msg.sender, pending);
1123             }
1124         }
1125         if(_amount > 0) {
1126             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1127             pool.totalBalance = pool.totalBalance.add(_amount);  // Track Balance
1128             if(pool.depositFeeBP > 0){
1129                 uint256 depositFee = _amount.mul(pool.depositFeeBP).div(10000);
1130                 pool.lpToken.safeTransfer(treasuryAddress, depositFee);
1131                 user.amount = user.amount.add(_amount).sub(depositFee);
1132             }else{
1133                 user.amount = user.amount.add(_amount);
1134             }
1135         }
1136         user.rewardDebt = user.amount.mul(pool.accRCollectorPerShare).div(1e12);
1137         emit Deposit(msg.sender, _pid, _amount);
1138     }
1139 
1140     // Withdraw LP tokens from MasterChef.
1141     function withdraw(uint256 _pid, uint256 _amount) public nonReentrant {
1142         PoolInfo storage pool = poolInfo[_pid];
1143         UserInfo storage user = userInfo[_pid][msg.sender];
1144         require(user.amount >= _amount, "withdraw: not good");
1145         updatePool(_pid);
1146         uint256 pending = user.amount.mul(pool.accRCollectorPerShare).div(1e12).sub(user.rewardDebt);
1147         if(pending > 0) {
1148             safePrintTransfer(msg.sender, pending);
1149         }
1150         if(_amount > 0) {
1151             user.amount = user.amount.sub(_amount);
1152             pool.totalBalance = pool.totalBalance.sub(_amount);  // Track Balance
1153             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1154         }
1155         user.rewardDebt = user.amount.mul(pool.accRCollectorPerShare).div(1e12);
1156         emit Withdraw(msg.sender, _pid, _amount);
1157     }
1158 
1159     // Withdraw without caring about rewards. EMERGENCY ONLY.
1160     function emergencyWithdraw(uint256 _pid) public nonReentrant {
1161         PoolInfo storage pool = poolInfo[_pid];
1162         UserInfo storage user = userInfo[_pid][msg.sender];
1163         uint256 amount = user.amount;
1164         user.amount = 0;
1165         user.rewardDebt = 0;
1166         pool.totalBalance = pool.totalBalance.sub(amount);  // Track Balance
1167         pool.lpToken.safeTransfer(address(msg.sender), amount);
1168         emit EmergencyWithdraw(msg.sender, _pid, amount);
1169     }
1170 
1171     // Safe rcollector transfer function, just in case if rounding error causes pool to not have enough Reflector Collector.
1172     function safePrintTransfer(address _to, uint256 _amount) internal {
1173         uint256 rcollectorBal = rcollector.balanceOf(address(this));
1174         if (_amount > rcollectorBal) {
1175             rcollector.transfer(_to, rcollectorBal);
1176         } else {
1177             rcollector.transfer(_to, _amount);
1178         }
1179     }
1180 
1181     function dev(address _devaddr) public onlyOwner {
1182         devaddr = _devaddr;
1183     }
1184 
1185 
1186     function setTreasuryAddress(address _treasuryAddress) public onlyOwner {
1187         treasuryAddress = _treasuryAddress;
1188     }
1189 
1190     function updateEmissionRate(uint256 _rcollectorPerBlock) public onlyOwner {
1191         massUpdatePools();
1192         rcollectorPerBlock = _rcollectorPerBlock;
1193     }
1194 }