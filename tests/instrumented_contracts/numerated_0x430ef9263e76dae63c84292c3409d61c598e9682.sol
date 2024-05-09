1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-18
3  */
4 
5 pragma solidity ^0.5.17;
6 
7 library Address {
8     /**
9      * @dev Returns true if `account` is a contract.
10      *
11      * [IMPORTANT]
12      * ====
13      * It is unsafe to assume that an address for which this function returns
14      * false is an externally-owned account (EOA) and not a contract.
15      *
16      * Among others, `isContract` will return false for the following
17      * types of addresses:
18      *
19      *  - an externally-owned account
20      *  - a contract in construction
21      *  - an address where a contract will be created
22      *  - an address where a contract lived, but was destroyed
23      * ====
24      */
25     function isContract(address account) internal view returns (bool) {
26         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
27         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
28         // for accounts without code, i.e. `keccak256('')`
29         bytes32 codehash;
30         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
31         // solhint-disable-next-line no-inline-assembly
32         assembly {
33             codehash := extcodehash(account)
34         }
35         return (codehash != accountHash && codehash != 0x0);
36     }
37 
38     /**
39      * @dev Converts an `address` into `address payable`. Note that this is
40      * simply a type cast: the actual underlying value is not changed.
41      *
42      * _Available since v2.4.0._
43      */
44     function toPayable(address account)
45         internal
46         pure
47         returns (address payable)
48     {
49         return address(uint160(account));
50     }
51 
52     /**
53      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
54      * `recipient`, forwarding all available gas and reverting on errors.
55      *
56      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
57      * of certain opcodes, possibly making contracts go over the 2300 gas limit
58      * imposed by `transfer`, making them unable to receive funds via
59      * `transfer`. {sendValue} removes this limitation.
60      *
61      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
62      *
63      * IMPORTANT: because control is transferred to `recipient`, care must be
64      * taken to not create reentrancy vulnerabilities. Consider using
65      * {ReentrancyGuard} or the
66      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
67      *
68      * _Available since v2.4.0._
69      */
70     function sendValue(address payable recipient, uint256 amount) internal {
71         require(
72             address(this).balance >= amount,
73             "Address: insufficient balance"
74         );
75 
76         // solhint-disable-next-line avoid-call-value
77         (bool success, ) = recipient.call.value(amount)("");
78         require(
79             success,
80             "Address: unable to send value, recipient may have reverted"
81         );
82     }
83 }
84 
85 /*
86  * @dev Provides information about the current execution context, including the
87  * sender of the transaction and its data. While these are generally available
88  * via msg.sender and msg.data, they should not be accessed in such a direct
89  * manner, since when dealing with GSN meta-transactions the account sending and
90  * paying for execution may not be the actual sender (as far as an application
91  * is concerned).
92  *
93  * This contract is only required for intermediate, library-like contracts.
94  */
95 contract Context {
96     // Empty internal constructor, to prevent people from mistakenly deploying
97     // an instance of this contract, which should be used via inheritance.
98     constructor() internal {}
99 
100     // solhint-disable-previous-line no-empty-blocks
101 
102     function _msgSender() internal view returns (address payable) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view returns (bytes memory) {
107         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
108         return msg.data;
109     }
110 }
111 
112 contract Ownable is Context {
113     address private _owner;
114 
115     event OwnershipTransferred(
116         address indexed previousOwner,
117         address indexed newOwner
118     );
119 
120     /**
121      * @dev Initializes the contract setting the deployer as the initial owner.
122      */
123     constructor() internal {
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
140         require(isOwner(), "Ownable: caller is not the owner");
141         _;
142     }
143 
144     /**
145      * @dev Returns true if the caller is the current owner.
146      */
147     function isOwner() public view returns (bool) {
148         return _msgSender() == _owner;
149     }
150 
151     /**
152      * @dev Leaves the contract without owner. It will not be possible to call
153      * `onlyOwner` functions anymore. Can only be called by the current owner.
154      *
155      * NOTE: Renouncing ownership will leave the contract without an owner,
156      * thereby removing any functionality that is only available to the owner.
157      */
158     function renounceOwnership() public onlyOwner {
159         emit OwnershipTransferred(_owner, address(0));
160         _owner = address(0);
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      * Can only be called by the current owner.
166      */
167     function transferOwnership(address newOwner) public onlyOwner {
168         _transferOwnership(newOwner);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      */
174     function _transferOwnership(address newOwner) internal {
175         require(
176             newOwner != address(0),
177             "Ownable: new owner is the zero address"
178         );
179         emit OwnershipTransferred(_owner, newOwner);
180         _owner = newOwner;
181     }
182 }
183 
184 /**
185  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
186  * the optional functions; to access them see {ERC20Detailed}.
187  */
188 interface IERC20 {
189     /**
190      * @dev Returns the amount of tokens in existence.
191      */
192     function totalSupply() external view returns (uint256);
193 
194     /**
195      * @dev Returns the amount of tokens owned by `account`.
196      */
197     function balanceOf(address account) external view returns (uint256);
198 
199     /**
200      * @dev Moves `amount` tokens from the caller's account to `recipient`.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * Emits a {Transfer} event.
205      */
206     function transfer(address recipient, uint256 amount)
207         external
208         returns (bool);
209 
210     /**
211      * @dev Returns the remaining number of tokens that `spender` will be
212      * allowed to spend on behalf of `owner` through {transferFrom}. This is
213      * zero by default.
214      *
215      * This value changes when {approve} or {transferFrom} are called.
216      */
217     function allowance(address owner, address spender)
218         external
219         view
220         returns (uint256);
221 
222     /**
223      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * IMPORTANT: Beware that changing an allowance with this method brings the risk
228      * that someone may use both the old and the new allowance by unfortunate
229      * transaction ordering. One possible solution to mitigate this race
230      * condition is to first reduce the spender's allowance to 0 and set the
231      * desired value afterwards:
232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233      *
234      * Emits an {Approval} event.
235      */
236     function approve(address spender, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Moves `amount` tokens from `sender` to `recipient` using the
240      * allowance mechanism. `amount` is then deducted from the caller's
241      * allowance.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transferFrom(
248         address sender,
249         address recipient,
250         uint256 amount
251     ) external returns (bool);
252 
253     /**
254      * @dev Emitted when `value` tokens are moved from one account (`from`) to
255      * another (`to`).
256      *
257      * Note that `value` may be zero.
258      */
259     event Transfer(address indexed from, address indexed to, uint256 value);
260 
261     /**
262      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
263      * a call to {approve}. `value` is the new allowance.
264      */
265     event Approval(
266         address indexed owner,
267         address indexed spender,
268         uint256 value
269     );
270 }
271 
272 /**
273  * @dev Wrappers over Solidity's arithmetic operations with added overflow
274  * checks.
275  *
276  * Arithmetic operations in Solidity wrap on overflow. This can easily result
277  * in bugs, because programmers usually assume that an overflow raises an
278  * error, which is the standard behavior in high level programming languages.
279  * `SafeMath` restores this intuition by reverting the transaction when an
280  * operation overflows.
281  *
282  * Using this library instead of the unchecked operations eliminates an entire
283  * class of bugs, so it's recommended to use it always.
284  */
285 library SafeMath {
286     /**
287      * @dev Returns the addition of two unsigned integers, reverting on
288      * overflow.
289      *
290      * Counterpart to Solidity's `+` operator.
291      *
292      * Requirements:
293      * - Addition cannot overflow.
294      */
295     function add(uint256 a, uint256 b) internal pure returns (uint256) {
296         uint256 c = a + b;
297         require(c >= a, "SafeMath: addition overflow");
298 
299         return c;
300     }
301 
302     /**
303      * @dev Returns the subtraction of two unsigned integers, reverting on
304      * overflow (when the result is negative).
305      *
306      * Counterpart to Solidity's `-` operator.
307      *
308      * Requirements:
309      * - Subtraction cannot overflow.
310      */
311     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
312         return sub(a, b, "SafeMath: subtraction overflow");
313     }
314 
315     /**
316      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
317      * overflow (when the result is negative).
318      *
319      * Counterpart to Solidity's `-` operator.
320      *
321      * Requirements:
322      * - Subtraction cannot overflow.
323      *
324      * _Available since v2.4.0._
325      */
326     function sub(
327         uint256 a,
328         uint256 b,
329         string memory errorMessage
330     ) internal pure returns (uint256) {
331         require(b <= a, errorMessage);
332         uint256 c = a - b;
333 
334         return c;
335     }
336 
337     /**
338      * @dev Returns the multiplication of two unsigned integers, reverting on
339      * overflow.
340      *
341      * Counterpart to Solidity's `*` operator.
342      *
343      * Requirements:
344      * - Multiplication cannot overflow.
345      */
346     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
347         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
348         // benefit is lost if 'b' is also tested.
349         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
350         if (a == 0) {
351             return 0;
352         }
353 
354         uint256 c = a * b;
355         require(c / a == b, "SafeMath: multiplication overflow");
356 
357         return c;
358     }
359 
360     /**
361      * @dev Returns the integer division of two unsigned integers. Reverts on
362      * division by zero. The result is rounded towards zero.
363      *
364      * Counterpart to Solidity's `/` operator. Note: this function uses a
365      * `revert` opcode (which leaves remaining gas untouched) while Solidity
366      * uses an invalid opcode to revert (consuming all remaining gas).
367      *
368      * Requirements:
369      * - The divisor cannot be zero.
370      */
371     function div(uint256 a, uint256 b) internal pure returns (uint256) {
372         return div(a, b, "SafeMath: division by zero");
373     }
374 
375     /**
376      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
377      * division by zero. The result is rounded towards zero.
378      *
379      * Counterpart to Solidity's `/` operator. Note: this function uses a
380      * `revert` opcode (which leaves remaining gas untouched) while Solidity
381      * uses an invalid opcode to revert (consuming all remaining gas).
382      *
383      * Requirements:
384      * - The divisor cannot be zero.
385      *
386      * _Available since v2.4.0._
387      */
388     function div(
389         uint256 a,
390         uint256 b,
391         string memory errorMessage
392     ) internal pure returns (uint256) {
393         // Solidity only automatically asserts when dividing by 0
394         require(b > 0, errorMessage);
395         uint256 c = a / b;
396         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
397 
398         return c;
399     }
400 
401     /**
402      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
403      * Reverts when dividing by zero.
404      *
405      * Counterpart to Solidity's `%` operator. This function uses a `revert`
406      * opcode (which leaves remaining gas untouched) while Solidity uses an
407      * invalid opcode to revert (consuming all remaining gas).
408      *
409      * Requirements:
410      * - The divisor cannot be zero.
411      */
412     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
413         return mod(a, b, "SafeMath: modulo by zero");
414     }
415 
416     /**
417      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
418      * Reverts with custom message when dividing by zero.
419      *
420      * Counterpart to Solidity's `%` operator. This function uses a `revert`
421      * opcode (which leaves remaining gas untouched) while Solidity uses an
422      * invalid opcode to revert (consuming all remaining gas).
423      *
424      * Requirements:
425      * - The divisor cannot be zero.
426      *
427      * _Available since v2.4.0._
428      */
429     function mod(
430         uint256 a,
431         uint256 b,
432         string memory errorMessage
433     ) internal pure returns (uint256) {
434         require(b != 0, errorMessage);
435         return a % b;
436     }
437 }
438 
439 /**
440  * @dev Implementation of the {IERC20} interface.
441  *
442  * This implementation is agnostic to the way tokens are created. This means
443  * that a supply mechanism has to be added in a derived contract using {_mint}.
444  * For a generic mechanism see {ERC20Mintable}.
445  *
446  * TIP: For a detailed writeup see our guide
447  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
448  * to implement supply mechanisms].
449  *
450  * We have followed general OpenZeppelin guidelines: functions revert instead
451  * of returning `false` on failure. This behavior is nonetheless conventional
452  * and does not conflict with the expectations of ERC20 applications.
453  *
454  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
455  * This allows applications to reconstruct the allowance for all accounts just
456  * by listening to said events. Other implementations of the EIP may not emit
457  * these events, as it isn't required by the specification.
458  *
459  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
460  * functions have been added to mitigate the well-known issues around setting
461  * allowances. See {IERC20-approve}.
462  */
463 contract ERC20 is Context, IERC20 {
464     using SafeMath for uint256;
465 
466     mapping(address => uint256) private _balances;
467 
468     mapping(address => mapping(address => uint256)) private _allowances;
469 
470     uint256 private _totalSupply;
471 
472     /**
473      * @dev See {IERC20-totalSupply}.
474      */
475     function totalSupply() public view returns (uint256) {
476         return _totalSupply;
477     }
478 
479     /**
480      * @dev See {IERC20-balanceOf}.
481      */
482     function balanceOf(address account) public view returns (uint256) {
483         return _balances[account];
484     }
485 
486     /**
487      * @dev See {IERC20-transfer}.
488      *
489      * Requirements:
490      *
491      * - `recipient` cannot be the zero address.
492      * - the caller must have a balance of at least `amount`.
493      */
494     function transfer(address recipient, uint256 amount) public returns (bool) {
495         _transfer(_msgSender(), recipient, amount);
496         return true;
497     }
498 
499     /**
500      * @dev See {IERC20-allowance}.
501      */
502     function allowance(address owner, address spender)
503         public
504         view
505         returns (uint256)
506     {
507         return _allowances[owner][spender];
508     }
509 
510     /**
511      * @dev See {IERC20-approve}.
512      *
513      * Requirements:
514      *
515      * - `spender` cannot be the zero address.
516      */
517     function approve(address spender, uint256 amount) public returns (bool) {
518         _approve(_msgSender(), spender, amount);
519         return true;
520     }
521 
522     /**
523      * @dev See {IERC20-transferFrom}.
524      *
525      * Emits an {Approval} event indicating the updated allowance. This is not
526      * required by the EIP. See the note at the beginning of {ERC20};
527      *
528      * Requirements:
529      * - `sender` and `recipient` cannot be the zero address.
530      * - `sender` must have a balance of at least `amount`.
531      * - the caller must have allowance for `sender`'s tokens of at least
532      * `amount`.
533      */
534     function transferFrom(
535         address sender,
536         address recipient,
537         uint256 amount
538     ) public returns (bool) {
539         _transfer(sender, recipient, amount);
540         _approve(
541             sender,
542             _msgSender(),
543             _allowances[sender][_msgSender()].sub(
544                 amount,
545                 "ERC20: transfer amount exceeds allowance"
546             )
547         );
548         return true;
549     }
550 
551     /**
552      * @dev Atomically increases the allowance granted to `spender` by the caller.
553      *
554      * This is an alternative to {approve} that can be used as a mitigation for
555      * problems described in {IERC20-approve}.
556      *
557      * Emits an {Approval} event indicating the updated allowance.
558      *
559      * Requirements:
560      *
561      * - `spender` cannot be the zero address.
562      */
563     function increaseAllowance(address spender, uint256 addedValue)
564         public
565         returns (bool)
566     {
567         _approve(
568             _msgSender(),
569             spender,
570             _allowances[_msgSender()][spender].add(addedValue)
571         );
572         return true;
573     }
574 
575     /**
576      * @dev Atomically decreases the allowance granted to `spender` by the caller.
577      *
578      * This is an alternative to {approve} that can be used as a mitigation for
579      * problems described in {IERC20-approve}.
580      *
581      * Emits an {Approval} event indicating the updated allowance.
582      *
583      * Requirements:
584      *
585      * - `spender` cannot be the zero address.
586      * - `spender` must have allowance for the caller of at least
587      * `subtractedValue`.
588      */
589     function decreaseAllowance(address spender, uint256 subtractedValue)
590         public
591         returns (bool)
592     {
593         _approve(
594             _msgSender(),
595             spender,
596             _allowances[_msgSender()][spender].sub(
597                 subtractedValue,
598                 "ERC20: decreased allowance below zero"
599             )
600         );
601         return true;
602     }
603 
604     /**
605      * @dev Moves tokens `amount` from `sender` to `recipient`.
606      *
607      * This is internal function is equivalent to {transfer}, and can be used to
608      * e.g. implement automatic token fees, slashing mechanisms, etc.
609      *
610      * Emits a {Transfer} event.
611      *
612      * Requirements:
613      *
614      * - `sender` cannot be the zero address.
615      * - `recipient` cannot be the zero address.
616      * - `sender` must have a balance of at least `amount`.
617      */
618     function _transfer(
619         address sender,
620         address recipient,
621         uint256 amount
622     ) internal {
623         require(sender != address(0), "ERC20: transfer from the zero address");
624         require(recipient != address(0), "ERC20: transfer to the zero address");
625 
626         _balances[sender] = _balances[sender].sub(
627             amount,
628             "ERC20: transfer amount exceeds balance"
629         );
630         _balances[recipient] = _balances[recipient].add(amount);
631         emit Transfer(sender, recipient, amount);
632     }
633 
634     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
635      * the total supply.
636      *
637      * Emits a {Transfer} event with `from` set to the zero address.
638      *
639      * Requirements
640      *
641      * - `to` cannot be the zero address.
642      */
643     function _mint(address account, uint256 amount) internal {
644         require(account != address(0), "ERC20: mint to the zero address");
645 
646         _totalSupply = _totalSupply.add(amount);
647         _balances[account] = _balances[account].add(amount);
648         emit Transfer(address(0), account, amount);
649     }
650 
651     /**
652      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
653      *
654      * This is internal function is equivalent to `approve`, and can be used to
655      * e.g. set automatic allowances for certain subsystems, etc.
656      *
657      * Emits an {Approval} event.
658      *
659      * Requirements:
660      *
661      * - `owner` cannot be the zero address.
662      * - `spender` cannot be the zero address.
663      */
664     function _approve(
665         address owner,
666         address spender,
667         uint256 amount
668     ) internal {
669         require(owner != address(0), "ERC20: approve from the zero address");
670         require(spender != address(0), "ERC20: approve to the zero address");
671 
672         _allowances[owner][spender] = amount;
673         emit Approval(owner, spender, amount);
674     }
675 }
676 
677 contract BlackListETH is Ownable {
678     mapping(address => bool) public blackListed;
679     event BlackListed(address indexed user, bool set);
680 
681     constructor(address _owner) public {
682         transferOwnership(_owner);
683     }
684 
685     /**
686      * Add or Remove addresses from the blacklist
687      */
688     function blackList(address _user, bool set) public onlyOwner {
689         if (set) {
690             require(!blackListed[_user], "already blackListed");
691         }
692         if (!set) {
693             require(blackListed[_user], "user not in blacklist");
694         }
695         blackListed[_user] = set;
696         emit BlackListed(_user, set);
697     }
698 
699     function batchBlackList(address[] memory _userAddresses, bool[] memory _set)
700         public
701         onlyOwner
702     {
703         require(_userAddresses.length == _set.length, "Incomplete info");
704         for (uint256 i = 0; i < _userAddresses.length; i++) {
705             blackList(_userAddresses[i], _set[i]);
706         }
707     }
708 
709     function checkBlackList(address _user) public view returns (bool) {
710         return blackListed[_user];
711     }
712 }
713 
714 contract PYRToken is ERC20, Ownable {
715     uint256 public totalTokensAmount = 50000000;
716     using Address for address;
717     BlackListETH public blacklist;
718 
719     string public name = "PYR Token";
720     string public symbol = "PYR";
721     uint8 public decimals = 18;
722 
723     constructor(address _owner, address _blacklistAddress) public {
724         require(
725             _blacklistAddress.isContract(),
726             "_tokenAddress must be a contract"
727         );
728         blacklist = BlackListETH(_blacklistAddress);
729         _mint(_owner, totalTokensAmount * (10**uint256(decimals)));
730         transferOwnership(_owner);
731     }
732 
733     function _transfer(
734         address sender,
735         address recipient,
736         uint256 amount
737     ) internal {
738         require(
739             !blacklist.checkBlackList(sender),
740             "Token transfer refused. Receiver is on blacklist"
741         );
742         require(
743             !blacklist.checkBlackList(recipient),
744             "Transfer to blacklisted account"
745         );
746         super._transfer(sender, recipient, amount);
747     }
748 }