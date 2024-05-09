1 // @AmpelforthOrg + @BalancerLabs => Elastic smart pool  
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 // File: configurable-rights-pool/contracts/IBFactory.sol
7 
8 interface IBPool {
9     function rebind(address token, uint balance, uint denorm) external;
10     function setSwapFee(uint swapFee) external;
11     function setPublicSwap(bool publicSwap) external;
12     function bind(address token, uint balance, uint denorm) external;
13     function unbind(address token) external;
14     function gulp(address token) external;
15     function isBound(address token) external view returns(bool);
16     function getBalance(address token) external view returns (uint);
17     function totalSupply() external view returns (uint);
18     function getSwapFee() external view returns (uint);
19     function isPublicSwap() external view returns (bool);
20     function getDenormalizedWeight(address token) external view returns (uint);
21     function getTotalDenormalizedWeight() external view returns (uint);
22     // solhint-disable-next-line func-name-mixedcase
23     function EXIT_FEE() external view returns (uint);
24 
25     function calcPoolOutGivenSingleIn(
26         uint tokenBalanceIn,
27         uint tokenWeightIn,
28         uint poolSupply,
29         uint totalWeight,
30         uint tokenAmountIn,
31         uint swapFee
32     )
33         external pure
34         returns (uint poolAmountOut);
35 
36     function calcSingleInGivenPoolOut(
37         uint tokenBalanceIn,
38         uint tokenWeightIn,
39         uint poolSupply,
40         uint totalWeight,
41         uint poolAmountOut,
42         uint swapFee
43     )
44         external pure
45         returns (uint tokenAmountIn);
46 
47     function calcSingleOutGivenPoolIn(
48         uint tokenBalanceOut,
49         uint tokenWeightOut,
50         uint poolSupply,
51         uint totalWeight,
52         uint poolAmountIn,
53         uint swapFee
54     )
55         external pure
56         returns (uint tokenAmountOut);
57 
58     function calcPoolInGivenSingleOut(
59         uint tokenBalanceOut,
60         uint tokenWeightOut,
61         uint poolSupply,
62         uint totalWeight,
63         uint tokenAmountOut,
64         uint swapFee
65     )
66         external pure
67         returns (uint poolAmountIn);
68 
69     function getCurrentTokens()
70         external view
71         returns (address[] memory tokens);
72 }
73 
74 interface IBFactory {
75     function newBPool() external returns (IBPool);
76     function setBLabs(address b) external;
77     function collect(IBPool pool) external;
78     function isBPool(address b) external view returns (bool);
79     function getBLabs() external view returns (address);
80 }
81 
82 // File: configurable-rights-pool/libraries/BalancerConstants.sol
83 
84 
85 
86 /**
87  * @author Balancer Labs
88  * @title Put all the constants in one place
89  */
90 
91 library BalancerConstants {
92     // State variables (must be constant in a library)
93 
94     // B "ONE" - all math is in the "realm" of 10 ** 18;
95     // where numeric 1 = 10 ** 18
96     uint public constant BONE = 10**18;
97     uint public constant MIN_WEIGHT = BONE;
98     uint public constant MAX_WEIGHT = BONE * 50;
99     uint public constant MAX_TOTAL_WEIGHT = BONE * 50;
100     uint public constant MIN_BALANCE = BONE / 10**6;
101     uint public constant MAX_BALANCE = BONE * 10**12;
102     uint public constant MIN_POOL_SUPPLY = BONE * 100;
103     uint public constant MAX_POOL_SUPPLY = BONE * 10**9;
104     uint public constant MIN_FEE = BONE / 10**6;
105     uint public constant MAX_FEE = BONE / 10;
106     // EXIT_FEE must always be zero, or ConfigurableRightsPool._pushUnderlying will fail
107     uint public constant EXIT_FEE = 0;
108     uint public constant MAX_IN_RATIO = BONE / 2;
109     uint public constant MAX_OUT_RATIO = (BONE / 3) + 1 wei;
110     // Must match BConst.MIN_BOUND_TOKENS and BConst.MAX_BOUND_TOKENS
111     uint public constant MIN_ASSET_LIMIT = 2;
112     uint public constant MAX_ASSET_LIMIT = 8;
113     uint public constant MAX_UINT = uint(-1);
114 }
115 
116 // File: configurable-rights-pool/libraries/BalancerSafeMath.sol
117 
118 
119 
120 
121 // Imports
122 
123 
124 /**
125  * @author Balancer Labs
126  * @title SafeMath - wrap Solidity operators to prevent underflow/overflow
127  * @dev badd and bsub are basically identical to OpenZeppelin SafeMath; mul/div have extra checks
128  */
129 library BalancerSafeMath {
130     /**
131      * @notice Safe addition
132      * @param a - first operand
133      * @param b - second operand
134      * @dev if we are adding b to a, the resulting sum must be greater than a
135      * @return - sum of operands; throws if overflow
136      */
137     function badd(uint a, uint b) internal pure returns (uint) {
138         uint c = a + b;
139         require(c >= a, "ERR_ADD_OVERFLOW");
140         return c;
141     }
142 
143     /**
144      * @notice Safe unsigned subtraction
145      * @param a - first operand
146      * @param b - second operand
147      * @dev Do a signed subtraction, and check that it produces a positive value
148      *      (i.e., a - b is valid if b <= a)
149      * @return - a - b; throws if underflow
150      */
151     function bsub(uint a, uint b) internal pure returns (uint) {
152         (uint c, bool negativeResult) = bsubSign(a, b);
153         require(!negativeResult, "ERR_SUB_UNDERFLOW");
154         return c;
155     }
156 
157     /**
158      * @notice Safe signed subtraction
159      * @param a - first operand
160      * @param b - second operand
161      * @dev Do a signed subtraction
162      * @return - difference between a and b, and a flag indicating a negative result
163      *           (i.e., a - b if a is greater than or equal to b; otherwise b - a)
164      */
165     function bsubSign(uint a, uint b) internal pure returns (uint, bool) {
166         if (b <= a) {
167             return (a - b, false);
168         } else {
169             return (b - a, true);
170         }
171     }
172 
173     /**
174      * @notice Safe multiplication
175      * @param a - first operand
176      * @param b - second operand
177      * @dev Multiply safely (and efficiently), rounding down
178      * @return - product of operands; throws if overflow or rounding error
179      */
180     function bmul(uint a, uint b) internal pure returns (uint) {
181         // Gas optimization (see github.com/OpenZeppelin/openzeppelin-contracts/pull/522)
182         if (a == 0) {
183             return 0;
184         }
185 
186         // Standard overflow check: a/a*b=b
187         uint c0 = a * b;
188         require(c0 / a == b, "ERR_MUL_OVERFLOW");
189 
190         // Round to 0 if x*y < BONE/2?
191         uint c1 = c0 + (BalancerConstants.BONE / 2);
192         require(c1 >= c0, "ERR_MUL_OVERFLOW");
193         uint c2 = c1 / BalancerConstants.BONE;
194         return c2;
195     }
196 
197     /**
198      * @notice Safe division
199      * @param dividend - first operand
200      * @param divisor - second operand
201      * @dev Divide safely (and efficiently), rounding down
202      * @return - quotient; throws if overflow or rounding error
203      */
204     function bdiv(uint dividend, uint divisor) internal pure returns (uint) {
205         require(divisor != 0, "ERR_DIV_ZERO");
206 
207         // Gas optimization
208         if (dividend == 0){
209             return 0;
210         }
211 
212         uint c0 = dividend * BalancerConstants.BONE;
213         require(c0 / dividend == BalancerConstants.BONE, "ERR_DIV_INTERNAL"); // bmul overflow
214 
215         uint c1 = c0 + (divisor / 2);
216         require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require
217 
218         uint c2 = c1 / divisor;
219         return c2;
220     }
221 
222     /**
223      * @notice Safe unsigned integer modulo
224      * @dev Returns the remainder of dividing two unsigned integers.
225      *      Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * @param dividend - first operand
232      * @param divisor - second operand -- cannot be zero
233      * @return - quotient; throws if overflow or rounding error
234      */
235     function bmod(uint dividend, uint divisor) internal pure returns (uint) {
236         require(divisor != 0, "ERR_MODULO_BY_ZERO");
237 
238         return dividend % divisor;
239     }
240 
241     /**
242      * @notice Safe unsigned integer max
243      * @dev Returns the greater of the two input values
244      *
245      * @param a - first operand
246      * @param b - second operand
247      * @return - the maximum of a and b
248      */
249     function bmax(uint a, uint b) internal pure returns (uint) {
250         return a >= b ? a : b;
251     }
252 
253     /**
254      * @notice Safe unsigned integer min
255      * @dev returns b, if b < a; otherwise returns a
256      *
257      * @param a - first operand
258      * @param b - second operand
259      * @return - the lesser of the two input values
260      */
261     function bmin(uint a, uint b) internal pure returns (uint) {
262         return a < b ? a : b;
263     }
264 
265     /**
266      * @notice Safe unsigned integer average
267      * @dev Guard against (a+b) overflow by dividing each operand separately
268      *
269      * @param a - first operand
270      * @param b - second operand
271      * @return - the average of the two values
272      */
273     function baverage(uint a, uint b) internal pure returns (uint) {
274         // (a + b) / 2 can overflow, so we distribute
275         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
276     }
277 
278     /**
279      * @notice Babylonian square root implementation
280      * @dev (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
281      * @param y - operand
282      * @return z - the square root result
283      */
284     function sqrt(uint y) internal pure returns (uint z) {
285         if (y > 3) {
286             z = y;
287             uint x = y / 2 + 1;
288             while (x < z) {
289                 z = x;
290                 x = (y / x + x) / 2;
291             }
292         }
293         else if (y != 0) {
294             z = 1;
295         }
296     }
297 }
298 
299 // File: configurable-rights-pool/interfaces/IERC20.sol
300 
301 
302 
303 // Interface declarations
304 
305 /* solhint-disable func-order */
306 
307 interface IERC20 {
308     // Emitted when the allowance of a spender for an owner is set by a call to approve.
309     // Value is the new allowance
310     event Approval(address indexed owner, address indexed spender, uint value);
311 
312     // Emitted when value tokens are moved from one account (from) to another (to).
313     // Note that value may be zero
314     event Transfer(address indexed from, address indexed to, uint value);
315 
316     // Returns the amount of tokens in existence
317     function totalSupply() external view returns (uint);
318 
319     // Returns the amount of tokens owned by account
320     function balanceOf(address account) external view returns (uint);
321 
322     // Returns the remaining number of tokens that spender will be allowed to spend on behalf of owner
323     // through transferFrom. This is zero by default
324     // This value changes when approve or transferFrom are called
325     function allowance(address owner, address spender) external view returns (uint);
326 
327     // Sets amount as the allowance of spender over the caller’s tokens
328     // Returns a boolean value indicating whether the operation succeeded
329     // Emits an Approval event.
330     function approve(address spender, uint amount) external returns (bool);
331 
332     // Moves amount tokens from the caller’s account to recipient
333     // Returns a boolean value indicating whether the operation succeeded
334     // Emits a Transfer event.
335     function transfer(address recipient, uint amount) external returns (bool);
336 
337     // Moves amount tokens from sender to recipient using the allowance mechanism
338     // Amount is then deducted from the caller’s allowance
339     // Returns a boolean value indicating whether the operation succeeded
340     // Emits a Transfer event
341     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
342 }
343 
344 // File: configurable-rights-pool/contracts/PCToken.sol
345 
346 
347 
348 // Imports
349 
350 
351 
352 // Contracts
353 
354 /* solhint-disable func-order */
355 
356 /**
357  * @author Balancer Labs
358  * @title Highly opinionated token implementation
359 */
360 contract PCToken is IERC20 {
361     using BalancerSafeMath for uint;
362 
363     // State variables
364     string public constant NAME = "Balancer Smart Pool";
365     uint8 public constant DECIMALS = 18;
366 
367     // No leading underscore per naming convention (non-private)
368     // Cannot call totalSupply (name conflict)
369     // solhint-disable-next-line private-vars-leading-underscore
370     uint internal varTotalSupply;
371 
372     mapping(address => uint) private _balance;
373     mapping(address => mapping(address => uint)) private _allowance;
374 
375     string private _symbol;
376     string private _name;
377 
378     // Event declarations
379 
380     // See definitions above; must be redeclared to be emitted from this contract
381     event Approval(address indexed owner, address indexed spender, uint value);
382     event Transfer(address indexed from, address indexed to, uint value);
383 
384     // Function declarations
385 
386     /**
387      * @notice Base token constructor
388      * @param tokenSymbol - the token symbol
389      */
390     constructor (string memory tokenSymbol, string memory tokenName) public {
391         _symbol = tokenSymbol;
392         _name = tokenName;
393     }
394 
395     // External functions
396 
397     /**
398      * @notice Getter for allowance: amount spender will be allowed to spend on behalf of owner
399      * @param owner - owner of the tokens
400      * @param spender - entity allowed to spend the tokens
401      * @return uint - remaining amount spender is allowed to transfer
402      */
403     function allowance(address owner, address spender) external view override returns (uint) {
404         return _allowance[owner][spender];
405     }
406 
407     /**
408      * @notice Getter for current account balance
409      * @param account - address we're checking the balance of
410      * @return uint - token balance in the account
411      */
412     function balanceOf(address account) external view override returns (uint) {
413         return _balance[account];
414     }
415 
416     /**
417      * @notice Approve owner (sender) to spend a certain amount
418      * @dev emits an Approval event
419      * @param spender - entity the owner (sender) is approving to spend his tokens
420      * @param amount - number of tokens being approved
421      * @return bool - result of the approval (will always be true if it doesn't revert)
422      */
423     function approve(address spender, uint amount) external override returns (bool) {
424         /* In addition to the increase/decreaseApproval functions, could
425            avoid the "approval race condition" by only allowing calls to approve
426            when the current approval amount is 0
427 
428            require(_allowance[msg.sender][spender] == 0, "ERR_RACE_CONDITION");
429 
430            Some token contracts (e.g., KNC), already revert if you call approve
431            on a non-zero allocation. To deal with these, we use the SafeApprove library
432            and safeApprove function when adding tokens to the pool.
433         */
434 
435         _allowance[msg.sender][spender] = amount;
436 
437         emit Approval(msg.sender, spender, amount);
438 
439         return true;
440     }
441 
442     /**
443      * @notice Increase the amount the spender is allowed to spend on behalf of the owner (sender)
444      * @dev emits an Approval event
445      * @param spender - entity the owner (sender) is approving to spend his tokens
446      * @param amount - number of tokens being approved
447      * @return bool - result of the approval (will always be true if it doesn't revert)
448      */
449     function increaseApproval(address spender, uint amount) external returns (bool) {
450         _allowance[msg.sender][spender] = BalancerSafeMath.badd(_allowance[msg.sender][spender], amount);
451 
452         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
453 
454         return true;
455     }
456 
457     /**
458      * @notice Decrease the amount the spender is allowed to spend on behalf of the owner (sender)
459      * @dev emits an Approval event
460      * @dev If you try to decrease it below the current limit, it's just set to zero (not an error)
461      * @param spender - entity the owner (sender) is approving to spend his tokens
462      * @param amount - number of tokens being approved
463      * @return bool - result of the approval (will always be true if it doesn't revert)
464      */
465     function decreaseApproval(address spender, uint amount) external returns (bool) {
466         uint oldValue = _allowance[msg.sender][spender];
467         // Gas optimization - if amount == oldValue (or is larger), set to zero immediately
468         if (amount >= oldValue) {
469             _allowance[msg.sender][spender] = 0;
470         } else {
471             _allowance[msg.sender][spender] = BalancerSafeMath.bsub(oldValue, amount);
472         }
473 
474         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
475 
476         return true;
477     }
478 
479     /**
480      * @notice Transfer the given amount from sender (caller) to recipient
481      * @dev _move emits a Transfer event if successful
482      * @param recipient - entity receiving the tokens
483      * @param amount - number of tokens being transferred
484      * @return bool - result of the transfer (will always be true if it doesn't revert)
485      */
486     function transfer(address recipient, uint amount) external override returns (bool) {
487         require(recipient != address(0), "ERR_ZERO_ADDRESS");
488 
489         _move(msg.sender, recipient, amount);
490 
491         return true;
492     }
493 
494     /**
495      * @notice Transfer the given amount from sender to recipient
496      * @dev _move emits a Transfer event if successful; may also emit an Approval event
497      * @param sender - entity sending the tokens (must be caller or allowed to spend on behalf of caller)
498      * @param recipient - recipient of the tokens
499      * @param amount - number of tokens being transferred
500      * @return bool - result of the transfer (will always be true if it doesn't revert)
501      */
502     function transferFrom(address sender, address recipient, uint amount) external override returns (bool) {
503         require(recipient != address(0), "ERR_ZERO_ADDRESS");
504         require(msg.sender == sender || amount <= _allowance[sender][msg.sender], "ERR_PCTOKEN_BAD_CALLER");
505 
506         _move(sender, recipient, amount);
507 
508         // memoize for gas optimization
509         uint oldAllowance = _allowance[sender][msg.sender];
510 
511         // If the sender is not the caller, adjust the allowance by the amount transferred
512         if (msg.sender != sender && oldAllowance != uint(-1)) {
513             _allowance[sender][msg.sender] = BalancerSafeMath.bsub(oldAllowance, amount);
514 
515             emit Approval(msg.sender, recipient, _allowance[sender][msg.sender]);
516         }
517 
518         return true;
519     }
520 
521     // public functions
522 
523     /**
524      * @notice Getter for the total supply
525      * @dev declared external for gas optimization
526      * @return uint - total number of tokens in existence
527      */
528     function totalSupply() external view override returns (uint) {
529         return varTotalSupply;
530     }
531 
532     // Public functions
533 
534     /**
535      * @dev Returns the name of the token.
536      *      We allow the user to set this name (as well as the symbol).
537      *      Alternatives are 1) A fixed string (original design)
538      *                       2) A fixed string plus the user-defined symbol
539      *                          return string(abi.encodePacked(NAME, "-", _symbol));
540      */
541     function name() external view returns (string memory) {
542         return _name;
543     }
544 
545     /**
546      * @dev Returns the symbol of the token, usually a shorter version of the
547      * name.
548      */
549     function symbol() external view returns (string memory) {
550         return _symbol;
551     }
552 
553     /**
554      * @dev Returns the number of decimals used to get its user representation.
555      * For example, if `decimals` equals `2`, a balance of `505` tokens should
556      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
557      *
558      * Tokens usually opt for a value of 18, imitating the relationship between
559      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
560      * called.
561      *
562      * NOTE: This information is only used for _display_ purposes: it in
563      * no way affects any of the arithmetic of the contract, including
564      * {IERC20-balanceOf} and {IERC20-transfer}.
565      */
566     function decimals() external pure returns (uint8) {
567         return DECIMALS;
568     }
569 
570     // internal functions
571 
572     // Mint an amount of new tokens, and add them to the balance (and total supply)
573     // Emit a transfer amount from the null address to this contract
574     function _mint(uint amount) internal virtual {
575         _balance[address(this)] = BalancerSafeMath.badd(_balance[address(this)], amount);
576         varTotalSupply = BalancerSafeMath.badd(varTotalSupply, amount);
577 
578         emit Transfer(address(0), address(this), amount);
579     }
580 
581     // Burn an amount of new tokens, and subtract them from the balance (and total supply)
582     // Emit a transfer amount from this contract to the null address
583     function _burn(uint amount) internal virtual {
584         // Can't burn more than we have
585         // Remove require for gas optimization - bsub will revert on underflow
586         // require(_balance[address(this)] >= amount, "ERR_INSUFFICIENT_BAL");
587 
588         _balance[address(this)] = BalancerSafeMath.bsub(_balance[address(this)], amount);
589         varTotalSupply = BalancerSafeMath.bsub(varTotalSupply, amount);
590 
591         emit Transfer(address(this), address(0), amount);
592     }
593 
594     // Transfer tokens from sender to recipient
595     // Adjust balances, and emit a Transfer event
596     function _move(address sender, address recipient, uint amount) internal virtual {
597         // Can't send more than sender has
598         // Remove require for gas optimization - bsub will revert on underflow
599         // require(_balance[sender] >= amount, "ERR_INSUFFICIENT_BAL");
600 
601         _balance[sender] = BalancerSafeMath.bsub(_balance[sender], amount);
602         _balance[recipient] = BalancerSafeMath.badd(_balance[recipient], amount);
603 
604         emit Transfer(sender, recipient, amount);
605     }
606 
607     // Transfer from this contract to recipient
608     // Emits a transfer event if successful
609     function _push(address recipient, uint amount) internal {
610         _move(address(this), recipient, amount);
611     }
612 
613     // Transfer from recipient to this contract
614     // Emits a transfer event if successful
615     function _pull(address sender, uint amount) internal {
616         _move(sender, address(this), amount);
617     }
618 }
619 
620 // File: configurable-rights-pool/contracts/utils/BalancerReentrancyGuard.sol
621 
622 
623 
624 /**
625  * @author Balancer Labs (and OpenZeppelin)
626  * @title Protect against reentrant calls (and also selectively protect view functions)
627  * @dev Contract module that helps prevent reentrant calls to a function.
628  *
629  * Inheriting from `ReentrancyGuard` will make the {_lock_} modifier
630  * available, which can be applied to functions to make sure there are no nested
631  * (reentrant) calls to them.
632  *
633  * Note that because there is a single `_lock_` guard, functions marked as
634  * `_lock_` may not call one another. This can be worked around by making
635  * those functions `private`, and then adding `external` `_lock_` entry
636  * points to them.
637  *
638  * Also adds a _lockview_ modifier, which doesn't create a lock, but fails
639  *   if another _lock_ call is in progress
640  */
641 contract BalancerReentrancyGuard {
642     // Booleans are more expensive than uint256 or any type that takes up a full
643     // word because each write operation emits an extra SLOAD to first read the
644     // slot's contents, replace the bits taken up by the boolean, and then write
645     // back. This is the compiler's defense against contract upgrades and
646     // pointer aliasing, and it cannot be disabled.
647 
648     // The values being non-zero value makes deployment a bit more expensive,
649     // but in exchange the refund on every call to nonReentrant will be lower in
650     // amount. Since refunds are capped to a percentage of the total
651     // transaction's gas, it is best to keep them low in cases like this one, to
652     // increase the likelihood of the full refund coming into effect.
653     uint private constant _NOT_ENTERED = 1;
654     uint private constant _ENTERED = 2;
655 
656     uint private _status;
657 
658     constructor () internal {
659         _status = _NOT_ENTERED;
660     }
661 
662     /**
663      * @dev Prevents a contract from calling itself, directly or indirectly.
664      * Calling a `_lock_` function from another `_lock_`
665      * function is not supported. It is possible to prevent this from happening
666      * by making the `_lock_` function external, and make it call a
667      * `private` function that does the actual work.
668      */
669     modifier lock() {
670         // On the first call to _lock_, _notEntered will be true
671         require(_status != _ENTERED, "ERR_REENTRY");
672 
673         // Any calls to _lock_ after this point will fail
674         _status = _ENTERED;
675         _;
676         // By storing the original value once again, a refund is triggered (see
677         // https://eips.ethereum.org/EIPS/eip-2200)
678         _status = _NOT_ENTERED;
679     }
680 
681     /**
682      * @dev Also add a modifier that doesn't create a lock, but protects functions that
683      *      should not be called while a _lock_ function is running
684      */
685      modifier viewlock() {
686         require(_status != _ENTERED, "ERR_REENTRY_VIEW");
687         _;
688      }
689 }
690 
691 // File: configurable-rights-pool/contracts/utils/BalancerOwnable.sol
692 
693 
694 
695 /**
696  * @dev Contract module which provides a basic access control mechanism, where
697  * there is an account (an owner) that can be granted exclusive access to
698  * specific functions.
699  *
700  * By default, the owner account will be the one that deploys the contract. This
701  * can later be changed with {transferOwnership}.
702  *
703  * This module is used through inheritance. It will make available the modifier
704  * `onlyOwner`, which can be applied to your functions to restrict their use to
705  * the owner.
706  */
707 contract BalancerOwnable {
708     // State variables
709 
710     address private _owner;
711 
712     // Event declarations
713 
714     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
715 
716     // Modifiers
717 
718     /**
719      * @dev Throws if called by any account other than the owner.
720      */
721     modifier onlyOwner() {
722         require(_owner == msg.sender, "ERR_NOT_CONTROLLER");
723         _;
724     }
725 
726     // Function declarations
727 
728     /**
729      * @dev Initializes the contract setting the deployer as the initial owner.
730      */
731     constructor () internal {
732         _owner = msg.sender;
733     }
734 
735     /**
736      * @notice Transfers ownership of the contract to a new account (`newOwner`).
737      *         Can only be called by the current owner
738      * @dev external for gas optimization
739      * @param newOwner - address of new owner
740      */
741     function setController(address newOwner) external onlyOwner {
742         require(newOwner != address(0), "ERR_ZERO_ADDRESS");
743 
744         emit OwnershipTransferred(_owner, newOwner);
745 
746         _owner = newOwner;
747     }
748 
749     /**
750      * @notice Returns the address of the current owner
751      * @dev external for gas optimization
752      * @return address - of the owner (AKA controller)
753      */
754     function getController() external view returns (address) {
755         return _owner;
756     }
757 }
758 
759 // File: configurable-rights-pool/libraries/RightsManager.sol
760 
761 
762 
763 // Needed to handle structures externally
764 
765 /**
766  * @author Balancer Labs
767  * @title Manage Configurable Rights for the smart pool
768  *      canPauseSwapping - can setPublicSwap back to false after turning it on
769  *                         by default, it is off on initialization and can only be turned on
770  *      canChangeSwapFee - can setSwapFee after initialization (by default, it is fixed at create time)
771  *      canChangeWeights - can bind new token weights (allowed by default in base pool)
772  *      canAddRemoveTokens - can bind/unbind tokens (allowed by default in base pool)
773  *      canWhitelistLPs - can limit liquidity providers to a given set of addresses
774  *      canChangeCap - can change the BSP cap (max # of pool tokens)
775  */
776 library RightsManager {
777 
778     // Type declarations
779 
780     enum Permissions { PAUSE_SWAPPING,
781                        CHANGE_SWAP_FEE,
782                        CHANGE_WEIGHTS,
783                        ADD_REMOVE_TOKENS,
784                        WHITELIST_LPS,
785                        CHANGE_CAP }
786 
787     struct Rights {
788         bool canPauseSwapping;
789         bool canChangeSwapFee;
790         bool canChangeWeights;
791         bool canAddRemoveTokens;
792         bool canWhitelistLPs;
793         bool canChangeCap;
794     }
795 
796     // State variables (can only be constants in a library)
797     bool public constant DEFAULT_CAN_PAUSE_SWAPPING = false;
798     bool public constant DEFAULT_CAN_CHANGE_SWAP_FEE = true;
799     bool public constant DEFAULT_CAN_CHANGE_WEIGHTS = true;
800     bool public constant DEFAULT_CAN_ADD_REMOVE_TOKENS = false;
801     bool public constant DEFAULT_CAN_WHITELIST_LPS = false;
802     bool public constant DEFAULT_CAN_CHANGE_CAP = false;
803 
804     // Functions
805 
806     /**
807      * @notice create a struct from an array (or return defaults)
808      * @dev If you pass an empty array, it will construct it using the defaults
809      * @param a - array input
810      * @return Rights struct
811      */
812     function constructRights(bool[] calldata a) external pure returns (Rights memory) {
813         if (a.length == 0) {
814             return Rights(DEFAULT_CAN_PAUSE_SWAPPING,
815                           DEFAULT_CAN_CHANGE_SWAP_FEE,
816                           DEFAULT_CAN_CHANGE_WEIGHTS,
817                           DEFAULT_CAN_ADD_REMOVE_TOKENS,
818                           DEFAULT_CAN_WHITELIST_LPS,
819                           DEFAULT_CAN_CHANGE_CAP);
820         }
821         else {
822             return Rights(a[0], a[1], a[2], a[3], a[4], a[5]);
823         }
824     }
825 
826     /**
827      * @notice Convert rights struct to an array (e.g., for events, GUI)
828      * @dev avoids multiple calls to hasPermission
829      * @param rights - the rights struct to convert
830      * @return boolean array containing the rights settings
831      */
832     function convertRights(Rights calldata rights) external pure returns (bool[] memory) {
833         bool[] memory result = new bool[](6);
834 
835         result[0] = rights.canPauseSwapping;
836         result[1] = rights.canChangeSwapFee;
837         result[2] = rights.canChangeWeights;
838         result[3] = rights.canAddRemoveTokens;
839         result[4] = rights.canWhitelistLPs;
840         result[5] = rights.canChangeCap;
841 
842         return result;
843     }
844 
845     // Though it is actually simple, the number of branches triggers code-complexity
846     /* solhint-disable code-complexity */
847 
848     /**
849      * @notice Externally check permissions using the Enum
850      * @param self - Rights struct containing the permissions
851      * @param permission - The permission to check
852      * @return Boolean true if it has the permission
853      */
854     function hasPermission(Rights calldata self, Permissions permission) external pure returns (bool) {
855         if (Permissions.PAUSE_SWAPPING == permission) {
856             return self.canPauseSwapping;
857         }
858         else if (Permissions.CHANGE_SWAP_FEE == permission) {
859             return self.canChangeSwapFee;
860         }
861         else if (Permissions.CHANGE_WEIGHTS == permission) {
862             return self.canChangeWeights;
863         }
864         else if (Permissions.ADD_REMOVE_TOKENS == permission) {
865             return self.canAddRemoveTokens;
866         }
867         else if (Permissions.WHITELIST_LPS == permission) {
868             return self.canWhitelistLPs;
869         }
870         else if (Permissions.CHANGE_CAP == permission) {
871             return self.canChangeCap;
872         }
873     }
874 
875     /* solhint-enable code-complexity */
876 }
877 
878 // File: configurable-rights-pool/interfaces/IConfigurableRightsPool.sol
879 
880 
881 
882 // Interface declarations
883 
884 // Introduce to avoid circularity (otherwise, the CRP and SmartPoolManager include each other)
885 // Removing circularity allows flattener tools to work, which enables Etherscan verification
886 interface IConfigurableRightsPool {
887     function mintPoolShareFromLib(uint amount) external;
888     function pushPoolShareFromLib(address to, uint amount) external;
889     function pullPoolShareFromLib(address from, uint amount) external;
890     function burnPoolShareFromLib(uint amount) external;
891     function totalSupply() external view returns (uint);
892     function getController() external view returns (address);
893 }
894 
895 // File: configurable-rights-pool/libraries/SafeApprove.sol
896 
897 
898 
899 // Imports
900 
901 
902 // Libraries
903 
904 /**
905  * @author PieDAO (ported to Balancer Labs)
906  * @title SafeApprove - set approval for tokens that require 0 prior approval
907  * @dev Perhaps to address the known ERC20 race condition issue
908  *      See https://github.com/crytic/not-so-smart-contracts/tree/master/race_condition
909  *      Some tokens - notably KNC - only allow approvals to be increased from 0
910  */
911 library SafeApprove {
912     /**
913      * @notice handle approvals of tokens that require approving from a base of 0
914      * @param token - the token we're approving
915      * @param spender - entity the owner (sender) is approving to spend his tokens
916      * @param amount - number of tokens being approved
917      */
918     function safeApprove(IERC20 token, address spender, uint amount) internal returns (bool) {
919         uint currentAllowance = token.allowance(address(this), spender);
920 
921         // Do nothing if allowance is already set to this value
922         if(currentAllowance == amount) {
923             return true;
924         }
925 
926         // If approval is not zero reset it to zero first
927         if(currentAllowance != 0) {
928             return token.approve(spender, 0);
929         }
930 
931         // do the actual approval
932         return token.approve(spender, amount);
933     }
934 }
935 
936 // File: configurable-rights-pool/libraries/SmartPoolManager.sol
937 
938 
939 
940 // Needed to pass in structs
941 
942 // Imports
943 
944 
945 
946 
947 
948 
949 
950 /**
951  * @author Balancer Labs
952  * @title Factor out the weight updates
953  */
954 library SmartPoolManager {
955     // Type declarations
956 
957     struct NewTokenParams {
958         address addr;
959         bool isCommitted;
960         uint commitBlock;
961         uint denorm;
962         uint balance;
963     }
964 
965     // For blockwise, automated weight updates
966     // Move weights linearly from startWeights to endWeights,
967     // between startBlock and endBlock
968     struct GradualUpdateParams {
969         uint startBlock;
970         uint endBlock;
971         uint[] startWeights;
972         uint[] endWeights;
973     }
974 
975     // updateWeight and pokeWeights are unavoidably long
976     /* solhint-disable function-max-lines */
977 
978     /**
979      * @notice Update the weight of an existing token
980      * @dev Refactored to library to make CRPFactory deployable
981      * @param self - ConfigurableRightsPool instance calling the library
982      * @param bPool - Core BPool the CRP is wrapping
983      * @param token - token to be reweighted
984      * @param newWeight - new weight of the token
985     */
986     function updateWeight(
987         IConfigurableRightsPool self,
988         IBPool bPool,
989         address token,
990         uint newWeight
991     )
992         external
993     {
994         require(newWeight >= BalancerConstants.MIN_WEIGHT, "ERR_MIN_WEIGHT");
995         require(newWeight <= BalancerConstants.MAX_WEIGHT, "ERR_MAX_WEIGHT");
996 
997         uint currentWeight = bPool.getDenormalizedWeight(token);
998         // Save gas; return immediately on NOOP
999         if (currentWeight == newWeight) {
1000              return;
1001         }
1002 
1003         uint currentBalance = bPool.getBalance(token);
1004         uint totalSupply = self.totalSupply();
1005         uint totalWeight = bPool.getTotalDenormalizedWeight();
1006         uint poolShares;
1007         uint deltaBalance;
1008         uint deltaWeight;
1009         uint newBalance;
1010 
1011         if (newWeight < currentWeight) {
1012             // This means the controller will withdraw tokens to keep price
1013             // So they need to redeem PCTokens
1014             deltaWeight = BalancerSafeMath.bsub(currentWeight, newWeight);
1015 
1016             // poolShares = totalSupply * (deltaWeight / totalWeight)
1017             poolShares = BalancerSafeMath.bmul(totalSupply,
1018                                                BalancerSafeMath.bdiv(deltaWeight, totalWeight));
1019 
1020             // deltaBalance = currentBalance * (deltaWeight / currentWeight)
1021             deltaBalance = BalancerSafeMath.bmul(currentBalance,
1022                                                  BalancerSafeMath.bdiv(deltaWeight, currentWeight));
1023 
1024             // New balance cannot be lower than MIN_BALANCE
1025             newBalance = BalancerSafeMath.bsub(currentBalance, deltaBalance);
1026 
1027             require(newBalance >= BalancerConstants.MIN_BALANCE, "ERR_MIN_BALANCE");
1028 
1029             // First get the tokens from this contract (Pool Controller) to msg.sender
1030             bPool.rebind(token, newBalance, newWeight);
1031 
1032             // Now with the tokens this contract can send them to msg.sender
1033             bool xfer = IERC20(token).transfer(msg.sender, deltaBalance);
1034             require(xfer, "ERR_ERC20_FALSE");
1035 
1036             self.pullPoolShareFromLib(msg.sender, poolShares);
1037             self.burnPoolShareFromLib(poolShares);
1038         }
1039         else {
1040             // This means the controller will deposit tokens to keep the price.
1041             // They will be minted and given PCTokens
1042             deltaWeight = BalancerSafeMath.bsub(newWeight, currentWeight);
1043 
1044             require(BalancerSafeMath.badd(totalWeight, deltaWeight) <= BalancerConstants.MAX_TOTAL_WEIGHT,
1045                     "ERR_MAX_TOTAL_WEIGHT");
1046 
1047             // poolShares = totalSupply * (deltaWeight / totalWeight)
1048             poolShares = BalancerSafeMath.bmul(totalSupply,
1049                                                BalancerSafeMath.bdiv(deltaWeight, totalWeight));
1050             // deltaBalance = currentBalance * (deltaWeight / currentWeight)
1051             deltaBalance = BalancerSafeMath.bmul(currentBalance,
1052                                                  BalancerSafeMath.bdiv(deltaWeight, currentWeight));
1053 
1054             // First gets the tokens from msg.sender to this contract (Pool Controller)
1055             bool xfer = IERC20(token).transferFrom(msg.sender, address(this), deltaBalance);
1056             require(xfer, "ERR_ERC20_FALSE");
1057 
1058             // Now with the tokens this contract can bind them to the pool it controls
1059             bPool.rebind(token, BalancerSafeMath.badd(currentBalance, deltaBalance), newWeight);
1060 
1061             self.mintPoolShareFromLib(poolShares);
1062             self.pushPoolShareFromLib(msg.sender, poolShares);
1063         }
1064     }
1065 
1066     /**
1067      * @notice External function called to make the contract update weights according to plan
1068      * @param bPool - Core BPool the CRP is wrapping
1069      * @param gradualUpdate - gradual update parameters from the CRP
1070     */
1071     function pokeWeights(
1072         IBPool bPool,
1073         GradualUpdateParams storage gradualUpdate
1074     )
1075         external
1076     {
1077         // Do nothing if we call this when there is no update plan
1078         if (gradualUpdate.startBlock == 0) {
1079             return;
1080         }
1081 
1082         // Error to call it before the start of the plan
1083         require(block.number >= gradualUpdate.startBlock, "ERR_CANT_POKE_YET");
1084         // Proposed error message improvement
1085         // require(block.number >= startBlock, "ERR_NO_HOKEY_POKEY");
1086 
1087         // This allows for pokes after endBlock that get weights to endWeights
1088         // Get the current block (or the endBlock, if we're already past the end)
1089         uint currentBlock;
1090         if (block.number > gradualUpdate.endBlock) {
1091             currentBlock = gradualUpdate.endBlock;
1092         }
1093         else {
1094             currentBlock = block.number;
1095         }
1096 
1097         uint blockPeriod = BalancerSafeMath.bsub(gradualUpdate.endBlock, gradualUpdate.startBlock);
1098         uint blocksElapsed = BalancerSafeMath.bsub(currentBlock, gradualUpdate.startBlock);
1099         uint weightDelta;
1100         uint deltaPerBlock;
1101         uint newWeight;
1102 
1103         address[] memory tokens = bPool.getCurrentTokens();
1104 
1105         // This loop contains external calls
1106         // External calls are to math libraries or the underlying pool, so low risk
1107         for (uint i = 0; i < tokens.length; i++) {
1108             // Make sure it does nothing if the new and old weights are the same (saves gas)
1109             // It's a degenerate case if they're *all* the same, but you certainly could have
1110             // a plan where you only change some of the weights in the set
1111             if (gradualUpdate.startWeights[i] != gradualUpdate.endWeights[i]) {
1112                 if (gradualUpdate.endWeights[i] < gradualUpdate.startWeights[i]) {
1113                     // We are decreasing the weight
1114 
1115                     // First get the total weight delta
1116                     weightDelta = BalancerSafeMath.bsub(gradualUpdate.startWeights[i],
1117                                                         gradualUpdate.endWeights[i]);
1118                     // And the amount it should change per block = total change/number of blocks in the period
1119                     deltaPerBlock = BalancerSafeMath.bdiv(weightDelta, blockPeriod);
1120                     //deltaPerBlock = bdivx(weightDelta, blockPeriod);
1121 
1122                      // newWeight = startWeight - (blocksElapsed * deltaPerBlock)
1123                     newWeight = BalancerSafeMath.bsub(gradualUpdate.startWeights[i],
1124                                                       BalancerSafeMath.bmul(blocksElapsed, deltaPerBlock));
1125                 }
1126                 else {
1127                     // We are increasing the weight
1128 
1129                     // First get the total weight delta
1130                     weightDelta = BalancerSafeMath.bsub(gradualUpdate.endWeights[i],
1131                                                         gradualUpdate.startWeights[i]);
1132                     // And the amount it should change per block = total change/number of blocks in the period
1133                     deltaPerBlock = BalancerSafeMath.bdiv(weightDelta, blockPeriod);
1134                     //deltaPerBlock = bdivx(weightDelta, blockPeriod);
1135 
1136                      // newWeight = startWeight + (blocksElapsed * deltaPerBlock)
1137                     newWeight = BalancerSafeMath.badd(gradualUpdate.startWeights[i],
1138                                                       BalancerSafeMath.bmul(blocksElapsed, deltaPerBlock));
1139                 }
1140 
1141                 uint bal = bPool.getBalance(tokens[i]);
1142 
1143                 bPool.rebind(tokens[i], bal, newWeight);
1144             }
1145         }
1146 
1147         // Reset to allow add/remove tokens, or manual weight updates
1148         if (block.number >= gradualUpdate.endBlock) {
1149             gradualUpdate.startBlock = 0;
1150         }
1151     }
1152 
1153     /* solhint-enable function-max-lines */
1154 
1155     /**
1156      * @notice Schedule (commit) a token to be added; must call applyAddToken after a fixed
1157      *         number of blocks to actually add the token
1158      * @param bPool - Core BPool the CRP is wrapping
1159      * @param token - the token to be added
1160      * @param balance - how much to be added
1161      * @param denormalizedWeight - the desired token weight
1162      * @param newToken - NewTokenParams struct used to hold the token data (in CRP storage)
1163      */
1164     function commitAddToken(
1165         IBPool bPool,
1166         address token,
1167         uint balance,
1168         uint denormalizedWeight,
1169         NewTokenParams storage newToken
1170     )
1171         external
1172     {
1173         require(!bPool.isBound(token), "ERR_IS_BOUND");
1174 
1175         require(denormalizedWeight <= BalancerConstants.MAX_WEIGHT, "ERR_WEIGHT_ABOVE_MAX");
1176         require(denormalizedWeight >= BalancerConstants.MIN_WEIGHT, "ERR_WEIGHT_BELOW_MIN");
1177         require(BalancerSafeMath.badd(bPool.getTotalDenormalizedWeight(),
1178                                       denormalizedWeight) <= BalancerConstants.MAX_TOTAL_WEIGHT,
1179                 "ERR_MAX_TOTAL_WEIGHT");
1180         require(balance >= BalancerConstants.MIN_BALANCE, "ERR_BALANCE_BELOW_MIN");
1181 
1182         newToken.addr = token;
1183         newToken.balance = balance;
1184         newToken.denorm = denormalizedWeight;
1185         newToken.commitBlock = block.number;
1186         newToken.isCommitted = true;
1187     }
1188 
1189     /**
1190      * @notice Add the token previously committed (in commitAddToken) to the pool
1191      * @param self - ConfigurableRightsPool instance calling the library
1192      * @param bPool - Core BPool the CRP is wrapping
1193      * @param addTokenTimeLockInBlocks -  Wait time between committing and applying a new token
1194      * @param newToken - NewTokenParams struct used to hold the token data (in CRP storage)
1195      */
1196     function applyAddToken(
1197         IConfigurableRightsPool self,
1198         IBPool bPool,
1199         uint addTokenTimeLockInBlocks,
1200         NewTokenParams storage newToken
1201     )
1202         external
1203     {
1204         require(newToken.isCommitted, "ERR_NO_TOKEN_COMMIT");
1205         require(BalancerSafeMath.bsub(block.number, newToken.commitBlock) >= addTokenTimeLockInBlocks,
1206                                       "ERR_TIMELOCK_STILL_COUNTING");
1207 
1208         uint totalSupply = self.totalSupply();
1209 
1210         // poolShares = totalSupply * newTokenWeight / totalWeight
1211         uint poolShares = BalancerSafeMath.bdiv(BalancerSafeMath.bmul(totalSupply, newToken.denorm),
1212                                                 bPool.getTotalDenormalizedWeight());
1213 
1214         // Clear this to allow adding more tokens
1215         newToken.isCommitted = false;
1216 
1217         // First gets the tokens from msg.sender to this contract (Pool Controller)
1218         bool returnValue = IERC20(newToken.addr).transferFrom(self.getController(), address(self), newToken.balance);
1219         require(returnValue, "ERR_ERC20_FALSE");
1220 
1221         // Now with the tokens this contract can bind them to the pool it controls
1222         // Approves bPool to pull from this controller
1223         // Approve unlimited, same as when creating the pool, so they can join pools later
1224         returnValue = SafeApprove.safeApprove(IERC20(newToken.addr), address(bPool), BalancerConstants.MAX_UINT);
1225         require(returnValue, "ERR_ERC20_FALSE");
1226 
1227         bPool.bind(newToken.addr, newToken.balance, newToken.denorm);
1228 
1229         self.mintPoolShareFromLib(poolShares);
1230         self.pushPoolShareFromLib(msg.sender, poolShares);
1231     }
1232 
1233      /**
1234      * @notice Remove a token from the pool
1235      * @dev Logic in the CRP controls when ths can be called. There are two related permissions:
1236      *      AddRemoveTokens - which allows removing down to the underlying BPool limit of two
1237      *      RemoveAllTokens - which allows completely draining the pool by removing all tokens
1238      *                        This can result in a non-viable pool with 0 or 1 tokens (by design),
1239      *                        meaning all swapping or binding operations would fail in this state
1240      * @param self - ConfigurableRightsPool instance calling the library
1241      * @param bPool - Core BPool the CRP is wrapping
1242      * @param token - token to remove
1243      */
1244     function removeToken(
1245         IConfigurableRightsPool self,
1246         IBPool bPool,
1247         address token
1248     )
1249         external
1250     {
1251         uint totalSupply = self.totalSupply();
1252 
1253         // poolShares = totalSupply * tokenWeight / totalWeight
1254         uint poolShares = BalancerSafeMath.bdiv(BalancerSafeMath.bmul(totalSupply,
1255                                                                       bPool.getDenormalizedWeight(token)),
1256                                                 bPool.getTotalDenormalizedWeight());
1257 
1258         // this is what will be unbound from the pool
1259         // Have to get it before unbinding
1260         uint balance = bPool.getBalance(token);
1261 
1262         // Unbind and get the tokens out of balancer pool
1263         bPool.unbind(token);
1264 
1265         // Now with the tokens this contract can send them to msg.sender
1266         bool xfer = IERC20(token).transfer(self.getController(), balance);
1267         require(xfer, "ERR_ERC20_FALSE");
1268 
1269         self.pullPoolShareFromLib(self.getController(), poolShares);
1270         self.burnPoolShareFromLib(poolShares);
1271     }
1272 
1273     /**
1274      * @notice Non ERC20-conforming tokens are problematic; don't allow them in pools
1275      * @dev Will revert if invalid
1276      * @param token - The prospective token to verify
1277      */
1278     function verifyTokenCompliance(address token) external {
1279         verifyTokenComplianceInternal(token);
1280     }
1281 
1282     /**
1283      * @notice Non ERC20-conforming tokens are problematic; don't allow them in pools
1284      * @dev Will revert if invalid - overloaded to save space in the main contract
1285      * @param tokens - The prospective tokens to verify
1286      */
1287     function verifyTokenCompliance(address[] calldata tokens) external {
1288         for (uint i = 0; i < tokens.length; i++) {
1289             verifyTokenComplianceInternal(tokens[i]);
1290          }
1291     }
1292 
1293     /**
1294      * @notice Update weights in a predetermined way, between startBlock and endBlock,
1295      *         through external cals to pokeWeights
1296      * @param bPool - Core BPool the CRP is wrapping
1297      * @param newWeights - final weights we want to get to
1298      * @param startBlock - when weights should start to change
1299      * @param endBlock - when weights will be at their final values
1300      * @param minimumWeightChangeBlockPeriod - needed to validate the block period
1301     */
1302     function updateWeightsGradually(
1303         IBPool bPool,
1304         GradualUpdateParams storage gradualUpdate,
1305         uint[] calldata newWeights,
1306         uint startBlock,
1307         uint endBlock,
1308         uint minimumWeightChangeBlockPeriod
1309     )
1310         external
1311     {
1312         // Enforce a minimum time over which to make the changes
1313         // The also prevents endBlock <= startBlock
1314         require(BalancerSafeMath.bsub(endBlock, startBlock) >= minimumWeightChangeBlockPeriod,
1315                 "ERR_WEIGHT_CHANGE_TIME_BELOW_MIN");
1316         require(block.number < endBlock, "ERR_GRADUAL_UPDATE_TIME_TRAVEL");
1317 
1318         address[] memory tokens = bPool.getCurrentTokens();
1319 
1320         // Must specify weights for all tokens
1321         require(newWeights.length == tokens.length, "ERR_START_WEIGHTS_MISMATCH");
1322 
1323         uint weightsSum = 0;
1324         gradualUpdate.startWeights = new uint[](tokens.length);
1325 
1326         // Check that endWeights are valid now to avoid reverting in a future pokeWeights call
1327         //
1328         // This loop contains external calls
1329         // External calls are to math libraries or the underlying pool, so low risk
1330         for (uint i = 0; i < tokens.length; i++) {
1331             require(newWeights[i] <= BalancerConstants.MAX_WEIGHT, "ERR_WEIGHT_ABOVE_MAX");
1332             require(newWeights[i] >= BalancerConstants.MIN_WEIGHT, "ERR_WEIGHT_BELOW_MIN");
1333 
1334             weightsSum = BalancerSafeMath.badd(weightsSum, newWeights[i]);
1335             gradualUpdate.startWeights[i] = bPool.getDenormalizedWeight(tokens[i]);
1336         }
1337         require(weightsSum <= BalancerConstants.MAX_TOTAL_WEIGHT, "ERR_MAX_TOTAL_WEIGHT");
1338 
1339         if (block.number > startBlock && block.number < endBlock) {
1340             // This means the weight update should start ASAP
1341             // Moving the start block up prevents a big jump/discontinuity in the weights
1342             //
1343             // Only valid within the startBlock - endBlock period!
1344             // Should not happen, but defensively check that we aren't
1345             // setting the start point past the end point
1346             gradualUpdate.startBlock = block.number;
1347         }
1348         else{
1349             gradualUpdate.startBlock = startBlock;
1350         }
1351 
1352         gradualUpdate.endBlock = endBlock;
1353         gradualUpdate.endWeights = newWeights;
1354     }
1355 
1356     /**
1357      * @notice Join a pool
1358      * @param self - ConfigurableRightsPool instance calling the library
1359      * @param bPool - Core BPool the CRP is wrapping
1360      * @param poolAmountOut - number of pool tokens to receive
1361      * @param maxAmountsIn - Max amount of asset tokens to spend
1362      * @return actualAmountsIn - calculated values of the tokens to pull in
1363      */
1364     function joinPool(
1365         IConfigurableRightsPool self,
1366         IBPool bPool,
1367         uint poolAmountOut,
1368         uint[] calldata maxAmountsIn
1369     )
1370          external
1371          view
1372          returns (uint[] memory actualAmountsIn)
1373     {
1374         address[] memory tokens = bPool.getCurrentTokens();
1375 
1376         require(maxAmountsIn.length == tokens.length, "ERR_AMOUNTS_MISMATCH");
1377 
1378         uint poolTotal = self.totalSupply();
1379         // Subtract  1 to ensure any rounding errors favor the pool
1380         uint ratio = BalancerSafeMath.bdiv(poolAmountOut,
1381                                            BalancerSafeMath.bsub(poolTotal, 1));
1382 
1383         require(ratio != 0, "ERR_MATH_APPROX");
1384 
1385         // We know the length of the array; initialize it, and fill it below
1386         // Cannot do "push" in memory
1387         actualAmountsIn = new uint[](tokens.length);
1388 
1389         // This loop contains external calls
1390         // External calls are to math libraries or the underlying pool, so low risk
1391         for (uint i = 0; i < tokens.length; i++) {
1392             address t = tokens[i];
1393             uint bal = bPool.getBalance(t);
1394             // Add 1 to ensure any rounding errors favor the pool
1395             uint tokenAmountIn = BalancerSafeMath.bmul(ratio,
1396                                                        BalancerSafeMath.badd(bal, 1));
1397 
1398             require(tokenAmountIn != 0, "ERR_MATH_APPROX");
1399             require(tokenAmountIn <= maxAmountsIn[i], "ERR_LIMIT_IN");
1400 
1401             actualAmountsIn[i] = tokenAmountIn;
1402         }
1403     }
1404 
1405     /**
1406      * @notice Exit a pool - redeem pool tokens for underlying assets
1407      * @param self - ConfigurableRightsPool instance calling the library
1408      * @param bPool - Core BPool the CRP is wrapping
1409      * @param poolAmountIn - amount of pool tokens to redeem
1410      * @param minAmountsOut - minimum amount of asset tokens to receive
1411      * @return exitFee - calculated exit fee
1412      * @return pAiAfterExitFee - final amount in (after accounting for exit fee)
1413      * @return actualAmountsOut - calculated amounts of each token to pull
1414      */
1415     function exitPool(
1416         IConfigurableRightsPool self,
1417         IBPool bPool,
1418         uint poolAmountIn,
1419         uint[] calldata minAmountsOut
1420     )
1421         external
1422         view
1423         returns (uint exitFee, uint pAiAfterExitFee, uint[] memory actualAmountsOut)
1424     {
1425         address[] memory tokens = bPool.getCurrentTokens();
1426 
1427         require(minAmountsOut.length == tokens.length, "ERR_AMOUNTS_MISMATCH");
1428 
1429         uint poolTotal = self.totalSupply();
1430 
1431         // Calculate exit fee and the final amount in
1432         exitFee = BalancerSafeMath.bmul(poolAmountIn, BalancerConstants.EXIT_FEE);
1433         pAiAfterExitFee = BalancerSafeMath.bsub(poolAmountIn, exitFee);
1434 
1435         uint ratio = BalancerSafeMath.bdiv(pAiAfterExitFee,
1436                                            BalancerSafeMath.badd(poolTotal, 1));
1437 
1438         require(ratio != 0, "ERR_MATH_APPROX");
1439 
1440         actualAmountsOut = new uint[](tokens.length);
1441 
1442         // This loop contains external calls
1443         // External calls are to math libraries or the underlying pool, so low risk
1444         for (uint i = 0; i < tokens.length; i++) {
1445             address t = tokens[i];
1446             uint bal = bPool.getBalance(t);
1447             // Subtract 1 to ensure any rounding errors favor the pool
1448             uint tokenAmountOut = BalancerSafeMath.bmul(ratio,
1449                                                         BalancerSafeMath.bsub(bal, 1));
1450 
1451             require(tokenAmountOut != 0, "ERR_MATH_APPROX");
1452             require(tokenAmountOut >= minAmountsOut[i], "ERR_LIMIT_OUT");
1453 
1454             actualAmountsOut[i] = tokenAmountOut;
1455         }
1456     }
1457 
1458     /**
1459      * @notice Join by swapping a fixed amount of an external token in (must be present in the pool)
1460      *         System calculates the pool token amount
1461      * @param self - ConfigurableRightsPool instance calling the library
1462      * @param bPool - Core BPool the CRP is wrapping
1463      * @param tokenIn - which token we're transferring in
1464      * @param tokenAmountIn - amount of deposit
1465      * @param minPoolAmountOut - minimum of pool tokens to receive
1466      * @return poolAmountOut - amount of pool tokens minted and transferred
1467      */
1468     function joinswapExternAmountIn(
1469         IConfigurableRightsPool self,
1470         IBPool bPool,
1471         address tokenIn,
1472         uint tokenAmountIn,
1473         uint minPoolAmountOut
1474     )
1475         external
1476         view
1477         returns (uint poolAmountOut)
1478     {
1479         require(bPool.isBound(tokenIn), "ERR_NOT_BOUND");
1480         require(tokenAmountIn <= BalancerSafeMath.bmul(bPool.getBalance(tokenIn),
1481                                                        BalancerConstants.MAX_IN_RATIO),
1482                                                        "ERR_MAX_IN_RATIO");
1483 
1484         poolAmountOut = bPool.calcPoolOutGivenSingleIn(
1485                             bPool.getBalance(tokenIn),
1486                             bPool.getDenormalizedWeight(tokenIn),
1487                             self.totalSupply(),
1488                             bPool.getTotalDenormalizedWeight(),
1489                             tokenAmountIn,
1490                             bPool.getSwapFee()
1491                         );
1492 
1493         require(poolAmountOut >= minPoolAmountOut, "ERR_LIMIT_OUT");
1494     }
1495 
1496     /**
1497      * @notice Join by swapping an external token in (must be present in the pool)
1498      *         To receive an exact amount of pool tokens out. System calculates the deposit amount
1499      * @param self - ConfigurableRightsPool instance calling the library
1500      * @param bPool - Core BPool the CRP is wrapping
1501      * @param tokenIn - which token we're transferring in (system calculates amount required)
1502      * @param poolAmountOut - amount of pool tokens to be received
1503      * @param maxAmountIn - Maximum asset tokens that can be pulled to pay for the pool tokens
1504      * @return tokenAmountIn - amount of asset tokens transferred in to purchase the pool tokens
1505      */
1506     function joinswapPoolAmountOut(
1507         IConfigurableRightsPool self,
1508         IBPool bPool,
1509         address tokenIn,
1510         uint poolAmountOut,
1511         uint maxAmountIn
1512     )
1513         external
1514         view
1515         returns (uint tokenAmountIn)
1516     {
1517         require(bPool.isBound(tokenIn), "ERR_NOT_BOUND");
1518 
1519         tokenAmountIn = bPool.calcSingleInGivenPoolOut(
1520                             bPool.getBalance(tokenIn),
1521                             bPool.getDenormalizedWeight(tokenIn),
1522                             self.totalSupply(),
1523                             bPool.getTotalDenormalizedWeight(),
1524                             poolAmountOut,
1525                             bPool.getSwapFee()
1526                         );
1527 
1528         require(tokenAmountIn != 0, "ERR_MATH_APPROX");
1529         require(tokenAmountIn <= maxAmountIn, "ERR_LIMIT_IN");
1530 
1531         require(tokenAmountIn <= BalancerSafeMath.bmul(bPool.getBalance(tokenIn),
1532                                                        BalancerConstants.MAX_IN_RATIO),
1533                                                        "ERR_MAX_IN_RATIO");
1534     }
1535 
1536     /**
1537      * @notice Exit a pool - redeem a specific number of pool tokens for an underlying asset
1538      *         Asset must be present in the pool, and will incur an EXIT_FEE (if set to non-zero)
1539      * @param self - ConfigurableRightsPool instance calling the library
1540      * @param bPool - Core BPool the CRP is wrapping
1541      * @param tokenOut - which token the caller wants to receive
1542      * @param poolAmountIn - amount of pool tokens to redeem
1543      * @param minAmountOut - minimum asset tokens to receive
1544      * @return exitFee - calculated exit fee
1545      * @return tokenAmountOut - amount of asset tokens returned
1546      */
1547     function exitswapPoolAmountIn(
1548         IConfigurableRightsPool self,
1549         IBPool bPool,
1550         address tokenOut,
1551         uint poolAmountIn,
1552         uint minAmountOut
1553     )
1554         external
1555         view
1556         returns (uint exitFee, uint tokenAmountOut)
1557     {
1558         require(bPool.isBound(tokenOut), "ERR_NOT_BOUND");
1559 
1560         tokenAmountOut = bPool.calcSingleOutGivenPoolIn(
1561                             bPool.getBalance(tokenOut),
1562                             bPool.getDenormalizedWeight(tokenOut),
1563                             self.totalSupply(),
1564                             bPool.getTotalDenormalizedWeight(),
1565                             poolAmountIn,
1566                             bPool.getSwapFee()
1567                         );
1568 
1569         require(tokenAmountOut >= minAmountOut, "ERR_LIMIT_OUT");
1570         require(tokenAmountOut <= BalancerSafeMath.bmul(bPool.getBalance(tokenOut),
1571                                                         BalancerConstants.MAX_OUT_RATIO),
1572                                                         "ERR_MAX_OUT_RATIO");
1573 
1574         exitFee = BalancerSafeMath.bmul(poolAmountIn, BalancerConstants.EXIT_FEE);
1575     }
1576 
1577     /**
1578      * @notice Exit a pool - redeem pool tokens for a specific amount of underlying assets
1579      *         Asset must be present in the pool
1580      * @param self - ConfigurableRightsPool instance calling the library
1581      * @param bPool - Core BPool the CRP is wrapping
1582      * @param tokenOut - which token the caller wants to receive
1583      * @param tokenAmountOut - amount of underlying asset tokens to receive
1584      * @param maxPoolAmountIn - maximum pool tokens to be redeemed
1585      * @return exitFee - calculated exit fee
1586      * @return poolAmountIn - amount of pool tokens redeemed
1587      */
1588     function exitswapExternAmountOut(
1589         IConfigurableRightsPool self,
1590         IBPool bPool,
1591         address tokenOut,
1592         uint tokenAmountOut,
1593         uint maxPoolAmountIn
1594     )
1595         external
1596         view
1597         returns (uint exitFee, uint poolAmountIn)
1598     {
1599         require(bPool.isBound(tokenOut), "ERR_NOT_BOUND");
1600         require(tokenAmountOut <= BalancerSafeMath.bmul(bPool.getBalance(tokenOut),
1601                                                         BalancerConstants.MAX_OUT_RATIO),
1602                                                         "ERR_MAX_OUT_RATIO");
1603         poolAmountIn = bPool.calcPoolInGivenSingleOut(
1604                             bPool.getBalance(tokenOut),
1605                             bPool.getDenormalizedWeight(tokenOut),
1606                             self.totalSupply(),
1607                             bPool.getTotalDenormalizedWeight(),
1608                             tokenAmountOut,
1609                             bPool.getSwapFee()
1610                         );
1611 
1612         require(poolAmountIn != 0, "ERR_MATH_APPROX");
1613         require(poolAmountIn <= maxPoolAmountIn, "ERR_LIMIT_IN");
1614 
1615         exitFee = BalancerSafeMath.bmul(poolAmountIn, BalancerConstants.EXIT_FEE);
1616     }
1617 
1618     // Internal functions
1619 
1620     // Check for zero transfer, and make sure it returns true to returnValue
1621     function verifyTokenComplianceInternal(address token) internal {
1622         bool returnValue = IERC20(token).transfer(msg.sender, 0);
1623         require(returnValue, "ERR_NONCONFORMING_TOKEN");
1624     }
1625 }
1626 
1627 // File: configurable-rights-pool/contracts/ConfigurableRightsPool.sol
1628 
1629 
1630 
1631 // Needed to handle structures externally
1632 
1633 // Imports
1634 
1635 
1636 
1637 
1638 
1639 // Interfaces
1640 
1641 // Libraries
1642 
1643 
1644 
1645 
1646 // Contracts
1647 
1648 /**
1649  * @author Balancer Labs
1650  * @title Smart Pool with customizable features
1651  * @notice PCToken is the "Balancer Smart Pool" token (transferred upon finalization)
1652  * @dev Rights are defined as follows (index values into the array)
1653  *      0: canPauseSwapping - can setPublicSwap back to false after turning it on
1654  *                            by default, it is off on initialization and can only be turned on
1655  *      1: canChangeSwapFee - can setSwapFee after initialization (by default, it is fixed at create time)
1656  *      2: canChangeWeights - can bind new token weights (allowed by default in base pool)
1657  *      3: canAddRemoveTokens - can bind/unbind tokens (allowed by default in base pool)
1658  *      4: canWhitelistLPs - can restrict LPs to a whitelist
1659  *      5: canChangeCap - can change the BSP cap (max # of pool tokens)
1660  *
1661  * Note that functions called on bPool and bFactory may look like internal calls,
1662  *   but since they are contracts accessed through an interface, they are really external.
1663  * To make this explicit, we could write "IBPool(address(bPool)).function()" everywhere,
1664  *   instead of "bPool.function()".
1665  */
1666 contract ConfigurableRightsPool is PCToken, BalancerOwnable, BalancerReentrancyGuard {
1667     using BalancerSafeMath for uint;
1668     using SafeApprove for IERC20;
1669 
1670     // Type declarations
1671 
1672     struct PoolParams {
1673         // Balancer Pool Token (representing shares of the pool)
1674         string poolTokenSymbol;
1675         string poolTokenName;
1676         // Tokens inside the Pool
1677         address[] constituentTokens;
1678         uint[] tokenBalances;
1679         uint[] tokenWeights;
1680         uint swapFee;
1681     }
1682 
1683     // State variables
1684 
1685     IBFactory public bFactory;
1686     IBPool public bPool;
1687 
1688     // Struct holding the rights configuration
1689     RightsManager.Rights public rights;
1690 
1691     // Hold the parameters used in updateWeightsGradually
1692     SmartPoolManager.GradualUpdateParams public gradualUpdate;
1693 
1694     // This is for adding a new (currently unbound) token to the pool
1695     // It's a two-step process: commitAddToken(), then applyAddToken()
1696     SmartPoolManager.NewTokenParams public newToken;
1697 
1698     // Fee is initialized on creation, and can be changed if permission is set
1699     // Only needed for temporary storage between construction and createPool
1700     // Thereafter, the swap fee should always be read from the underlying pool
1701     uint private _initialSwapFee;
1702 
1703     // Store the list of tokens in the pool, and balances
1704     // NOTE that the token list is *only* used to store the pool tokens between
1705     //   construction and createPool - thereafter, use the underlying BPool's list
1706     //   (avoids synchronization issues)
1707     address[] private _initialTokens;
1708     uint[] private _initialBalances;
1709 
1710     // Enforce a minimum time between the start and end blocks
1711     uint public minimumWeightChangeBlockPeriod;
1712     // Enforce a mandatory wait time between updates
1713     // This is also the wait time between committing and applying a new token
1714     uint public addTokenTimeLockInBlocks;
1715 
1716     // Whitelist of LPs (if configured)
1717     mapping(address => bool) private _liquidityProviderWhitelist;
1718 
1719     // Cap on the pool size (i.e., # of tokens minted when joining)
1720     // Limits the risk of experimental pools; failsafe/backup for fixed-size pools
1721     uint public bspCap;
1722 
1723     // Event declarations
1724 
1725     // Anonymous logger event - can only be filtered by contract address
1726 
1727     event LogCall(
1728         bytes4  indexed sig,
1729         address indexed caller,
1730         bytes data
1731     ) anonymous;
1732 
1733     event LogJoin(
1734         address indexed caller,
1735         address indexed tokenIn,
1736         uint tokenAmountIn
1737     );
1738 
1739     event LogExit(
1740         address indexed caller,
1741         address indexed tokenOut,
1742         uint tokenAmountOut
1743     );
1744 
1745     event CapChanged(
1746         address indexed caller,
1747         uint oldCap,
1748         uint newCap
1749     );
1750 
1751     event NewTokenCommitted(
1752         address indexed token,
1753         address indexed pool,
1754         address indexed caller
1755     );
1756 
1757     // Modifiers
1758 
1759     modifier logs() {
1760         emit LogCall(msg.sig, msg.sender, msg.data);
1761         _;
1762     }
1763 
1764     // Mark functions that require delegation to the underlying Pool
1765     modifier needsBPool() {
1766         require(address(bPool) != address(0), "ERR_NOT_CREATED");
1767         _;
1768     }
1769 
1770     modifier lockUnderlyingPool() {
1771         // Turn off swapping on the underlying pool during joins
1772         // Otherwise tokens with callbacks would enable attacks involving simultaneous swaps and joins
1773         bool origSwapState = bPool.isPublicSwap();
1774         bPool.setPublicSwap(false);
1775         _;
1776         bPool.setPublicSwap(origSwapState);
1777     }
1778 
1779     // Default values for these variables (used only in updateWeightsGradually), set in the constructor
1780     // Pools without permission to update weights cannot use them anyway, and should call
1781     //   the default createPool() function.
1782     // To override these defaults, pass them into the overloaded createPool()
1783     // Period is in blocks; 500 blocks ~ 2 hours; 90,000 blocks ~ 2 weeks
1784     uint public constant DEFAULT_MIN_WEIGHT_CHANGE_BLOCK_PERIOD = 90000;
1785     uint public constant DEFAULT_ADD_TOKEN_TIME_LOCK_IN_BLOCKS = 500;
1786 
1787     // Function declarations
1788 
1789     /**
1790      * @notice Construct a new Configurable Rights Pool (wrapper around BPool)
1791      * @dev _initialTokens and _swapFee are only used for temporary storage between construction
1792      *      and create pool, and should not be used thereafter! _initialTokens is destroyed in
1793      *      createPool to prevent this, and _swapFee is kept in sync (defensively), but
1794      *      should never be used except in this constructor and createPool()
1795      * @param factoryAddress - the BPoolFactory used to create the underlying pool
1796      * @param poolParams - struct containing pool parameters
1797      * @param rightsStruct - Set of permissions we are assigning to this smart pool
1798      */
1799     constructor(
1800         address factoryAddress,
1801         PoolParams memory poolParams,
1802         RightsManager.Rights memory rightsStruct
1803     )
1804         public
1805         PCToken(poolParams.poolTokenSymbol, poolParams.poolTokenName)
1806     {
1807         // We don't have a pool yet; check now or it will fail later (in order of likelihood to fail)
1808         // (and be unrecoverable if they don't have permission set to change it)
1809         // Most likely to fail, so check first
1810         require(poolParams.swapFee >= BalancerConstants.MIN_FEE, "ERR_INVALID_SWAP_FEE");
1811         require(poolParams.swapFee <= BalancerConstants.MAX_FEE, "ERR_INVALID_SWAP_FEE");
1812 
1813         // Arrays must be parallel
1814         require(poolParams.tokenBalances.length == poolParams.constituentTokens.length, "ERR_START_BALANCES_MISMATCH");
1815         require(poolParams.tokenWeights.length == poolParams.constituentTokens.length, "ERR_START_WEIGHTS_MISMATCH");
1816         // Cannot have too many or too few - technically redundant, since BPool.bind() would fail later
1817         // But if we don't check now, we could have a useless contract with no way to create a pool
1818 
1819         require(poolParams.constituentTokens.length >= BalancerConstants.MIN_ASSET_LIMIT, "ERR_TOO_FEW_TOKENS");
1820         require(poolParams.constituentTokens.length <= BalancerConstants.MAX_ASSET_LIMIT, "ERR_TOO_MANY_TOKENS");
1821         // There are further possible checks (e.g., if they use the same token twice), but
1822         // we can let bind() catch things like that (i.e., not things that might reasonably work)
1823 
1824         SmartPoolManager.verifyTokenCompliance(poolParams.constituentTokens);
1825 
1826         bFactory = IBFactory(factoryAddress);
1827         rights = rightsStruct;
1828         _initialTokens = poolParams.constituentTokens;
1829         _initialBalances = poolParams.tokenBalances;
1830         _initialSwapFee = poolParams.swapFee;
1831 
1832         // These default block time parameters can be overridden in createPool
1833         minimumWeightChangeBlockPeriod = DEFAULT_MIN_WEIGHT_CHANGE_BLOCK_PERIOD;
1834         addTokenTimeLockInBlocks = DEFAULT_ADD_TOKEN_TIME_LOCK_IN_BLOCKS;
1835 
1836         gradualUpdate.startWeights = poolParams.tokenWeights;
1837         // Initializing (unnecessarily) for documentation - 0 means no gradual weight change has been initiated
1838         gradualUpdate.startBlock = 0;
1839         // By default, there is no cap (unlimited pool token minting)
1840         bspCap = BalancerConstants.MAX_UINT;
1841     }
1842 
1843     // External functions
1844 
1845     /**
1846      * @notice Set the swap fee on the underlying pool
1847      * @dev Keep the local version and core in sync (see below)
1848      *      bPool is a contract interface; function calls on it are external
1849      * @param swapFee in Wei
1850      */
1851     function setSwapFee(uint swapFee)
1852         external
1853         logs
1854         lock
1855         onlyOwner
1856         needsBPool
1857         virtual
1858     {
1859         require(rights.canChangeSwapFee, "ERR_NOT_CONFIGURABLE_SWAP_FEE");
1860 
1861         // Underlying pool will check against min/max fee
1862         bPool.setSwapFee(swapFee);
1863     }
1864 
1865     /**
1866      * @notice Getter for the publicSwap field on the underlying pool
1867      * @dev viewLock, because setPublicSwap is lock
1868      *      bPool is a contract interface; function calls on it are external
1869      * @return Current value of isPublicSwap
1870      */
1871     function isPublicSwap()
1872         external
1873         view
1874         viewlock
1875         needsBPool
1876         virtual
1877         returns (bool)
1878     {
1879         return bPool.isPublicSwap();
1880     }
1881 
1882     /**
1883      * @notice Set the cap (max # of pool tokens)
1884      * @dev _bspCap defaults in the constructor to unlimited
1885      *      Can set to 0 (or anywhere below the current supply), to halt new investment
1886      *      Prevent setting it before creating a pool, since createPool sets to intialSupply
1887      *      (it does this to avoid an unlimited cap window between construction and createPool)
1888      *      Therefore setting it before then has no effect, so should not be allowed
1889      * @param newCap - new value of the cap
1890      */
1891     function setCap(uint newCap)
1892         external
1893         logs
1894         lock
1895         needsBPool
1896         onlyOwner
1897     {
1898         require(rights.canChangeCap, "ERR_CANNOT_CHANGE_CAP");
1899 
1900         emit CapChanged(msg.sender, bspCap, newCap);
1901 
1902         bspCap = newCap;
1903     }
1904 
1905     /**
1906      * @notice Set the public swap flag on the underlying pool
1907      * @dev If this smart pool has canPauseSwapping enabled, we can turn publicSwap off if it's already on
1908      *      Note that if they turn swapping off - but then finalize the pool - finalizing will turn the
1909      *      swapping back on. They're not supposed to finalize the underlying pool... would defeat the
1910      *      smart pool functions. (Only the owner can finalize the pool - which is this contract -
1911      *      so there is no risk from outside.)
1912      *
1913      *      bPool is a contract interface; function calls on it are external
1914      * @param publicSwap new value of the swap
1915      */
1916     function setPublicSwap(bool publicSwap)
1917         external
1918         logs
1919         lock
1920         onlyOwner
1921         needsBPool
1922         virtual
1923     {
1924         require(rights.canPauseSwapping, "ERR_NOT_PAUSABLE_SWAP");
1925 
1926         bPool.setPublicSwap(publicSwap);
1927     }
1928 
1929     /**
1930      * @notice Create a new Smart Pool - and set the block period time parameters
1931      * @dev Initialize the swap fee to the value provided in the CRP constructor
1932      *      Can be changed if the canChangeSwapFee permission is enabled
1933      *      Time parameters will be fixed at these values
1934      *
1935      *      If this contract doesn't have canChangeWeights permission - or you want to use the default
1936      *      values, the block time arguments are not needed, and you can just call the single-argument
1937      *      createPool()
1938      * @param initialSupply - Starting token balance
1939      * @param minimumWeightChangeBlockPeriodParam - Enforce a minimum time between the start and end blocks
1940      * @param addTokenTimeLockInBlocksParam - Enforce a mandatory wait time between updates
1941      *                                   This is also the wait time between committing and applying a new token
1942      */
1943     function createPool(
1944         uint initialSupply,
1945         uint minimumWeightChangeBlockPeriodParam,
1946         uint addTokenTimeLockInBlocksParam
1947     )
1948         external
1949         onlyOwner
1950         logs
1951         lock
1952         virtual
1953     {
1954         require (minimumWeightChangeBlockPeriodParam >= addTokenTimeLockInBlocksParam,
1955                 "ERR_INCONSISTENT_TOKEN_TIME_LOCK");
1956 
1957         minimumWeightChangeBlockPeriod = minimumWeightChangeBlockPeriodParam;
1958         addTokenTimeLockInBlocks = addTokenTimeLockInBlocksParam;
1959 
1960         createPoolInternal(initialSupply);
1961     }
1962 
1963     /**
1964      * @notice Create a new Smart Pool
1965      * @dev Delegates to internal function
1966      * @param initialSupply starting token balance
1967      */
1968     function createPool(uint initialSupply)
1969         external
1970         onlyOwner
1971         logs
1972         lock
1973         virtual
1974     {
1975         createPoolInternal(initialSupply);
1976     }
1977 
1978     /**
1979      * @notice Update the weight of an existing token
1980      * @dev Notice Balance is not an input (like with rebind on BPool) since we will require prices not to change
1981      *      This is achieved by forcing balances to change proportionally to weights, so that prices don't change
1982      *      If prices could be changed, this would allow the controller to drain the pool by arbing price changes
1983      * @param token - token to be reweighted
1984      * @param newWeight - new weight of the token
1985     */
1986     function updateWeight(address token, uint newWeight)
1987         external
1988         logs
1989         lock
1990         onlyOwner
1991         needsBPool
1992         virtual
1993     {
1994         require(rights.canChangeWeights, "ERR_NOT_CONFIGURABLE_WEIGHTS");
1995 
1996         // We don't want people to set weights manually if there's a block-based update in progress
1997         require(gradualUpdate.startBlock == 0, "ERR_NO_UPDATE_DURING_GRADUAL");
1998 
1999         // Delegate to library to save space
2000         SmartPoolManager.updateWeight(IConfigurableRightsPool(address(this)), bPool, token, newWeight);
2001     }
2002 
2003     /**
2004      * @notice Update weights in a predetermined way, between startBlock and endBlock,
2005      *         through external calls to pokeWeights
2006      * @dev Must call pokeWeights at least once past the end for it to do the final update
2007      *      and enable calling this again.
2008      *      It is possible to call updateWeightsGradually during an update in some use cases
2009      *      For instance, setting newWeights to currentWeights to stop the update where it is
2010      * @param newWeights - final weights we want to get to. Note that the ORDER (and number) of
2011      *                     tokens can change if you have added or removed tokens from the pool
2012      *                     It ensures the counts are correct, but can't help you with the order!
2013      *                     You can get the underlying BPool (it's public), and call
2014      *                     getCurrentTokens() to see the current ordering, if you're not sure
2015      * @param startBlock - when weights should start to change
2016      * @param endBlock - when weights will be at their final values
2017     */
2018     function updateWeightsGradually(
2019         uint[] calldata newWeights,
2020         uint startBlock,
2021         uint endBlock
2022     )
2023         external
2024         logs
2025         lock
2026         onlyOwner
2027         needsBPool
2028         virtual
2029     {
2030         require(rights.canChangeWeights, "ERR_NOT_CONFIGURABLE_WEIGHTS");
2031          // Don't start this when we're in the middle of adding a new token
2032         require(!newToken.isCommitted, "ERR_PENDING_TOKEN_ADD");
2033 
2034         // Library computes the startBlock, computes startWeights as the current
2035         // denormalized weights of the core pool tokens.
2036         SmartPoolManager.updateWeightsGradually(
2037             bPool,
2038             gradualUpdate,
2039             newWeights,
2040             startBlock,
2041             endBlock,
2042             minimumWeightChangeBlockPeriod
2043         );
2044     }
2045 
2046     /**
2047      * @notice External function called to make the contract update weights according to plan
2048      * @dev Still works if we poke after the end of the period; also works if the weights don't change
2049      *      Resets if we are poking beyond the end, so that we can do it again
2050     */
2051     function pokeWeights()
2052         external
2053         logs
2054         lock
2055         needsBPool
2056         virtual
2057     {
2058         require(rights.canChangeWeights, "ERR_NOT_CONFIGURABLE_WEIGHTS");
2059 
2060         // Delegate to library to save space
2061         SmartPoolManager.pokeWeights(bPool, gradualUpdate);
2062     }
2063 
2064     /**
2065      * @notice Schedule (commit) a token to be added; must call applyAddToken after a fixed
2066      *         number of blocks to actually add the token
2067      *
2068      * @dev The purpose of this two-stage commit is to give warning of a potentially dangerous
2069      *      operation. A malicious pool operator could add a large amount of a low-value token,
2070      *      then drain the pool through price manipulation. Of course, there are many
2071      *      legitimate purposes, such as adding additional collateral tokens.
2072      *
2073      * @param token - the token to be added
2074      * @param balance - how much to be added
2075      * @param denormalizedWeight - the desired token weight
2076      */
2077     function commitAddToken(
2078         address token,
2079         uint balance,
2080         uint denormalizedWeight
2081     )
2082         external
2083         logs
2084         lock
2085         onlyOwner
2086         needsBPool
2087         virtual
2088     {
2089         require(rights.canAddRemoveTokens, "ERR_CANNOT_ADD_REMOVE_TOKENS");
2090 
2091         // Can't do this while a progressive update is happening
2092         require(gradualUpdate.startBlock == 0, "ERR_NO_UPDATE_DURING_GRADUAL");
2093 
2094         SmartPoolManager.verifyTokenCompliance(token);
2095 
2096         emit NewTokenCommitted(token, address(this), msg.sender);
2097 
2098         // Delegate to library to save space
2099         SmartPoolManager.commitAddToken(
2100             bPool,
2101             token,
2102             balance,
2103             denormalizedWeight,
2104             newToken
2105         );
2106     }
2107 
2108     /**
2109      * @notice Add the token previously committed (in commitAddToken) to the pool
2110      */
2111     function applyAddToken()
2112         external
2113         logs
2114         lock
2115         onlyOwner
2116         needsBPool
2117         virtual
2118     {
2119         require(rights.canAddRemoveTokens, "ERR_CANNOT_ADD_REMOVE_TOKENS");
2120 
2121         // Delegate to library to save space
2122         SmartPoolManager.applyAddToken(
2123             IConfigurableRightsPool(address(this)),
2124             bPool,
2125             addTokenTimeLockInBlocks,
2126             newToken
2127         );
2128     }
2129 
2130      /**
2131      * @notice Remove a token from the pool
2132      * @dev bPool is a contract interface; function calls on it are external
2133      * @param token - token to remove
2134      */
2135     function removeToken(address token)
2136         external
2137         logs
2138         lock
2139         onlyOwner
2140         needsBPool
2141     {
2142         // It's possible to have remove rights without having add rights
2143         require(rights.canAddRemoveTokens,"ERR_CANNOT_ADD_REMOVE_TOKENS");
2144         // After createPool, token list is maintained in the underlying BPool
2145         require(!newToken.isCommitted, "ERR_REMOVE_WITH_ADD_PENDING");
2146 
2147         // Delegate to library to save space
2148         SmartPoolManager.removeToken(IConfigurableRightsPool(address(this)), bPool, token);
2149     }
2150 
2151     /**
2152      * @notice Join a pool
2153      * @dev Emits a LogJoin event (for each token)
2154      *      bPool is a contract interface; function calls on it are external
2155      * @param poolAmountOut - number of pool tokens to receive
2156      * @param maxAmountsIn - Max amount of asset tokens to spend
2157      */
2158     function joinPool(uint poolAmountOut, uint[] calldata maxAmountsIn)
2159         external
2160         logs
2161         lock
2162         needsBPool
2163         lockUnderlyingPool
2164     {
2165         require(!rights.canWhitelistLPs || _liquidityProviderWhitelist[msg.sender],
2166                 "ERR_NOT_ON_WHITELIST");
2167 
2168         // Delegate to library to save space
2169 
2170         // Library computes actualAmountsIn, and does many validations
2171         // Cannot call the push/pull/min from an external library for
2172         // any of these pool functions. Since msg.sender can be anybody,
2173         // they must be internal
2174         uint[] memory actualAmountsIn = SmartPoolManager.joinPool(
2175                                             IConfigurableRightsPool(address(this)),
2176                                             bPool,
2177                                             poolAmountOut,
2178                                             maxAmountsIn
2179                                         );
2180 
2181         // After createPool, token list is maintained in the underlying BPool
2182         address[] memory poolTokens = bPool.getCurrentTokens();
2183 
2184         for (uint i = 0; i < poolTokens.length; i++) {
2185             address t = poolTokens[i];
2186             uint tokenAmountIn = actualAmountsIn[i];
2187 
2188             emit LogJoin(msg.sender, t, tokenAmountIn);
2189 
2190             _pullUnderlying(t, msg.sender, tokenAmountIn);
2191         }
2192 
2193         _mintPoolShare(poolAmountOut);
2194         _pushPoolShare(msg.sender, poolAmountOut);
2195     }
2196 
2197     /**
2198      * @notice Exit a pool - redeem pool tokens for underlying assets
2199      * @dev Emits a LogExit event for each token
2200      *      bPool is a contract interface; function calls on it are external
2201      * @param poolAmountIn - amount of pool tokens to redeem
2202      * @param minAmountsOut - minimum amount of asset tokens to receive
2203      */
2204     function exitPool(uint poolAmountIn, uint[] calldata minAmountsOut)
2205         external
2206         logs
2207         lock
2208         needsBPool
2209         lockUnderlyingPool
2210     {
2211         // Delegate to library to save space
2212 
2213         // Library computes actualAmountsOut, and does many validations
2214         // Also computes the exitFee and pAiAfterExitFee
2215         (uint exitFee,
2216          uint pAiAfterExitFee,
2217          uint[] memory actualAmountsOut) = SmartPoolManager.exitPool(
2218                                                IConfigurableRightsPool(address(this)),
2219                                                bPool,
2220                                                poolAmountIn,
2221                                                minAmountsOut
2222                                            );
2223 
2224         _pullPoolShare(msg.sender, poolAmountIn);
2225         _pushPoolShare(address(bFactory), exitFee);
2226         _burnPoolShare(pAiAfterExitFee);
2227 
2228         // After createPool, token list is maintained in the underlying BPool
2229         address[] memory poolTokens = bPool.getCurrentTokens();
2230 
2231         for (uint i = 0; i < poolTokens.length; i++) {
2232             address t = poolTokens[i];
2233             uint tokenAmountOut = actualAmountsOut[i];
2234 
2235             emit LogExit(msg.sender, t, tokenAmountOut);
2236 
2237             _pushUnderlying(t, msg.sender, tokenAmountOut);
2238         }
2239     }
2240 
2241     /**
2242      * @notice Join by swapping a fixed amount of an external token in (must be present in the pool)
2243      *         System calculates the pool token amount
2244      * @dev emits a LogJoin event
2245      * @param tokenIn - which token we're transferring in
2246      * @param tokenAmountIn - amount of deposit
2247      * @param minPoolAmountOut - minimum of pool tokens to receive
2248      * @return poolAmountOut - amount of pool tokens minted and transferred
2249      */
2250     function joinswapExternAmountIn(
2251         address tokenIn,
2252         uint tokenAmountIn,
2253         uint minPoolAmountOut
2254     )
2255         external
2256         logs
2257         lock
2258         needsBPool
2259         returns (uint poolAmountOut)
2260     {
2261         require(!rights.canWhitelistLPs || _liquidityProviderWhitelist[msg.sender],
2262                 "ERR_NOT_ON_WHITELIST");
2263 
2264         // Delegate to library to save space
2265         poolAmountOut = SmartPoolManager.joinswapExternAmountIn(
2266                             IConfigurableRightsPool(address(this)),
2267                             bPool,
2268                             tokenIn,
2269                             tokenAmountIn,
2270                             minPoolAmountOut
2271                         );
2272 
2273         emit LogJoin(msg.sender, tokenIn, tokenAmountIn);
2274 
2275         _mintPoolShare(poolAmountOut);
2276         _pushPoolShare(msg.sender, poolAmountOut);
2277         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
2278 
2279         return poolAmountOut;
2280     }
2281 
2282     /**
2283      * @notice Join by swapping an external token in (must be present in the pool)
2284      *         To receive an exact amount of pool tokens out. System calculates the deposit amount
2285      * @dev emits a LogJoin event
2286      * @param tokenIn - which token we're transferring in (system calculates amount required)
2287      * @param poolAmountOut - amount of pool tokens to be received
2288      * @param maxAmountIn - Maximum asset tokens that can be pulled to pay for the pool tokens
2289      * @return tokenAmountIn - amount of asset tokens transferred in to purchase the pool tokens
2290      */
2291     function joinswapPoolAmountOut(
2292         address tokenIn,
2293         uint poolAmountOut,
2294         uint maxAmountIn
2295     )
2296         external
2297         logs
2298         lock
2299         needsBPool
2300         returns (uint tokenAmountIn)
2301     {
2302         require(!rights.canWhitelistLPs || _liquidityProviderWhitelist[msg.sender],
2303                 "ERR_NOT_ON_WHITELIST");
2304 
2305         // Delegate to library to save space
2306         tokenAmountIn = SmartPoolManager.joinswapPoolAmountOut(
2307                             IConfigurableRightsPool(address(this)),
2308                             bPool,
2309                             tokenIn,
2310                             poolAmountOut,
2311                             maxAmountIn
2312                         );
2313 
2314         emit LogJoin(msg.sender, tokenIn, tokenAmountIn);
2315 
2316         _mintPoolShare(poolAmountOut);
2317         _pushPoolShare(msg.sender, poolAmountOut);
2318         _pullUnderlying(tokenIn, msg.sender, tokenAmountIn);
2319 
2320         return tokenAmountIn;
2321     }
2322 
2323     /**
2324      * @notice Exit a pool - redeem a specific number of pool tokens for an underlying asset
2325      *         Asset must be present in the pool, and will incur an EXIT_FEE (if set to non-zero)
2326      * @dev Emits a LogExit event for the token
2327      * @param tokenOut - which token the caller wants to receive
2328      * @param poolAmountIn - amount of pool tokens to redeem
2329      * @param minAmountOut - minimum asset tokens to receive
2330      * @return tokenAmountOut - amount of asset tokens returned
2331      */
2332     function exitswapPoolAmountIn(
2333         address tokenOut,
2334         uint poolAmountIn,
2335         uint minAmountOut
2336     )
2337         external
2338         logs
2339         lock
2340         needsBPool
2341         returns (uint tokenAmountOut)
2342     {
2343         // Delegate to library to save space
2344 
2345         // Calculates final amountOut, and the fee and final amount in
2346         (uint exitFee,
2347          uint amountOut) = SmartPoolManager.exitswapPoolAmountIn(
2348                                IConfigurableRightsPool(address(this)),
2349                                bPool,
2350                                tokenOut,
2351                                poolAmountIn,
2352                                minAmountOut
2353                            );
2354 
2355         tokenAmountOut = amountOut;
2356         uint pAiAfterExitFee = BalancerSafeMath.bsub(poolAmountIn, exitFee);
2357 
2358         emit LogExit(msg.sender, tokenOut, tokenAmountOut);
2359 
2360         _pullPoolShare(msg.sender, poolAmountIn);
2361         _burnPoolShare(pAiAfterExitFee);
2362         _pushPoolShare(address(bFactory), exitFee);
2363         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
2364 
2365         return tokenAmountOut;
2366     }
2367 
2368     /**
2369      * @notice Exit a pool - redeem pool tokens for a specific amount of underlying assets
2370      *         Asset must be present in the pool
2371      * @dev Emits a LogExit event for the token
2372      * @param tokenOut - which token the caller wants to receive
2373      * @param tokenAmountOut - amount of underlying asset tokens to receive
2374      * @param maxPoolAmountIn - maximum pool tokens to be redeemed
2375      * @return poolAmountIn - amount of pool tokens redeemed
2376      */
2377     function exitswapExternAmountOut(
2378         address tokenOut,
2379         uint tokenAmountOut,
2380         uint maxPoolAmountIn
2381     )
2382         external
2383         logs
2384         lock
2385         needsBPool
2386         returns (uint poolAmountIn)
2387     {
2388         // Delegate to library to save space
2389 
2390         // Calculates final amounts in, accounting for the exit fee
2391         (uint exitFee,
2392          uint amountIn) = SmartPoolManager.exitswapExternAmountOut(
2393                               IConfigurableRightsPool(address(this)),
2394                               bPool,
2395                               tokenOut,
2396                               tokenAmountOut,
2397                               maxPoolAmountIn
2398                           );
2399 
2400         poolAmountIn = amountIn;
2401         uint pAiAfterExitFee = BalancerSafeMath.bsub(poolAmountIn, exitFee);
2402 
2403         emit LogExit(msg.sender, tokenOut, tokenAmountOut);
2404 
2405         _pullPoolShare(msg.sender, poolAmountIn);
2406         _burnPoolShare(pAiAfterExitFee);
2407         _pushPoolShare(address(bFactory), exitFee);
2408         _pushUnderlying(tokenOut, msg.sender, tokenAmountOut);
2409 
2410         return poolAmountIn;
2411     }
2412 
2413     /**
2414      * @notice Add to the whitelist of liquidity providers (if enabled)
2415      * @param provider - address of the liquidity provider
2416      */
2417     function whitelistLiquidityProvider(address provider)
2418         external
2419         onlyOwner
2420         lock
2421         logs
2422     {
2423         require(rights.canWhitelistLPs, "ERR_CANNOT_WHITELIST_LPS");
2424         require(provider != address(0), "ERR_INVALID_ADDRESS");
2425 
2426         _liquidityProviderWhitelist[provider] = true;
2427     }
2428 
2429     /**
2430      * @notice Remove from the whitelist of liquidity providers (if enabled)
2431      * @param provider - address of the liquidity provider
2432      */
2433     function removeWhitelistedLiquidityProvider(address provider)
2434         external
2435         onlyOwner
2436         lock
2437         logs
2438     {
2439         require(rights.canWhitelistLPs, "ERR_CANNOT_WHITELIST_LPS");
2440         require(_liquidityProviderWhitelist[provider], "ERR_LP_NOT_WHITELISTED");
2441         require(provider != address(0), "ERR_INVALID_ADDRESS");
2442 
2443         _liquidityProviderWhitelist[provider] = false;
2444     }
2445 
2446     /**
2447      * @notice Check if an address is a liquidity provider
2448      * @dev If the whitelist feature is not enabled, anyone can provide liquidity (assuming finalized)
2449      * @return boolean value indicating whether the address can join a pool
2450      */
2451     function canProvideLiquidity(address provider)
2452         external
2453         view
2454         returns(bool)
2455     {
2456         if (rights.canWhitelistLPs) {
2457             return _liquidityProviderWhitelist[provider];
2458         }
2459         else {
2460             // Probably don't strictly need this (could just return true)
2461             // But the null address can't provide funds
2462             return provider != address(0);
2463         }
2464     }
2465 
2466     /**
2467      * @notice Getter for specific permissions
2468      * @dev value of the enum is just the 0-based index in the enumeration
2469      *      For instance canPauseSwapping is 0; canChangeWeights is 2
2470      * @return token boolean true if we have the given permission
2471     */
2472     function hasPermission(RightsManager.Permissions permission)
2473         external
2474         view
2475         virtual
2476         returns(bool)
2477     {
2478         return RightsManager.hasPermission(rights, permission);
2479     }
2480 
2481     /**
2482      * @notice Get the denormalized weight of a token
2483      * @dev viewlock to prevent calling if it's being updated
2484      * @return token weight
2485      */
2486     function getDenormalizedWeight(address token)
2487         external
2488         view
2489         viewlock
2490         needsBPool
2491         returns (uint)
2492     {
2493         return bPool.getDenormalizedWeight(token);
2494     }
2495 
2496     /**
2497      * @notice Getter for the RightsManager contract
2498      * @dev Convenience function to get the address of the RightsManager library (so clients can check version)
2499      * @return address of the RightsManager library
2500     */
2501     function getRightsManagerVersion() external pure returns (address) {
2502         return address(RightsManager);
2503     }
2504 
2505     /**
2506      * @notice Getter for the BalancerSafeMath contract
2507      * @dev Convenience function to get the address of the BalancerSafeMath library (so clients can check version)
2508      * @return address of the BalancerSafeMath library
2509     */
2510     function getBalancerSafeMathVersion() external pure returns (address) {
2511         return address(BalancerSafeMath);
2512     }
2513 
2514     /**
2515      * @notice Getter for the SmartPoolManager contract
2516      * @dev Convenience function to get the address of the SmartPoolManager library (so clients can check version)
2517      * @return address of the SmartPoolManager library
2518     */
2519     function getSmartPoolManagerVersion() external pure returns (address) {
2520         return address(SmartPoolManager);
2521     }
2522 
2523     // Public functions
2524 
2525     // "Public" versions that can safely be called from SmartPoolManager
2526     // Allows only the contract itself to call them (not the controller or any external account)
2527 
2528     function mintPoolShareFromLib(uint amount) public {
2529         require (msg.sender == address(this), "ERR_NOT_CONTROLLER");
2530 
2531         _mint(amount);
2532     }
2533 
2534     function pushPoolShareFromLib(address to, uint amount) public {
2535         require (msg.sender == address(this), "ERR_NOT_CONTROLLER");
2536 
2537         _push(to, amount);
2538     }
2539 
2540     function pullPoolShareFromLib(address from, uint amount) public  {
2541         require (msg.sender == address(this), "ERR_NOT_CONTROLLER");
2542 
2543         _pull(from, amount);
2544     }
2545 
2546     function burnPoolShareFromLib(uint amount) public  {
2547         require (msg.sender == address(this), "ERR_NOT_CONTROLLER");
2548 
2549         _burn(amount);
2550     }
2551 
2552     // Internal functions
2553 
2554     // Lint wants the function to have a leading underscore too
2555     /* solhint-disable private-vars-leading-underscore */
2556 
2557     /**
2558      * @notice Create a new Smart Pool
2559      * @dev Initialize the swap fee to the value provided in the CRP constructor
2560      *      Can be changed if the canChangeSwapFee permission is enabled
2561      * @param initialSupply starting token balance
2562      */
2563     function createPoolInternal(uint initialSupply) internal {
2564         require(address(bPool) == address(0), "ERR_IS_CREATED");
2565         require(initialSupply >= BalancerConstants.MIN_POOL_SUPPLY, "ERR_INIT_SUPPLY_MIN");
2566         require(initialSupply <= BalancerConstants.MAX_POOL_SUPPLY, "ERR_INIT_SUPPLY_MAX");
2567 
2568         // If the controller can change the cap, initialize it to the initial supply
2569         // Defensive programming, so that there is no gap between creating the pool
2570         // (initialized to unlimited in the constructor), and setting the cap,
2571         // which they will presumably do if they have this right.
2572         if (rights.canChangeCap) {
2573             bspCap = initialSupply;
2574         }
2575 
2576         // There is technically reentrancy here, since we're making external calls and
2577         // then transferring tokens. However, the external calls are all to the underlying BPool
2578 
2579         // To the extent possible, modify state variables before calling functions
2580         _mintPoolShare(initialSupply);
2581         _pushPoolShare(msg.sender, initialSupply);
2582 
2583         // Deploy new BPool (bFactory and bPool are interfaces; all calls are external)
2584         bPool = bFactory.newBPool();
2585 
2586         // EXIT_FEE must always be zero, or ConfigurableRightsPool._pushUnderlying will fail
2587         require(bPool.EXIT_FEE() == 0, "ERR_NONZERO_EXIT_FEE");
2588         require(BalancerConstants.EXIT_FEE == 0, "ERR_NONZERO_EXIT_FEE");
2589 
2590         for (uint i = 0; i < _initialTokens.length; i++) {
2591             address t = _initialTokens[i];
2592             uint bal = _initialBalances[i];
2593             uint denorm = gradualUpdate.startWeights[i];
2594 
2595             bool returnValue = IERC20(t).transferFrom(msg.sender, address(this), bal);
2596             require(returnValue, "ERR_ERC20_FALSE");
2597 
2598             returnValue = IERC20(t).safeApprove(address(bPool), BalancerConstants.MAX_UINT);
2599             require(returnValue, "ERR_ERC20_FALSE");
2600 
2601             bPool.bind(t, bal, denorm);
2602         }
2603 
2604         while (_initialTokens.length > 0) {
2605             // Modifying state variable after external calls here,
2606             // but not essential, so not dangerous
2607             _initialTokens.pop();
2608         }
2609 
2610         // Set fee to the initial value set in the constructor
2611         // Hereafter, read the swapFee from the underlying pool, not the local state variable
2612         bPool.setSwapFee(_initialSwapFee);
2613         bPool.setPublicSwap(true);
2614 
2615         // "destroy" the temporary swap fee (like _initialTokens above) in case a subclass tries to use it
2616         _initialSwapFee = 0;
2617     }
2618 
2619     /* solhint-enable private-vars-leading-underscore */
2620 
2621     // Rebind BPool and pull tokens from address
2622     // bPool is a contract interface; function calls on it are external
2623     function _pullUnderlying(address erc20, address from, uint amount) internal needsBPool {
2624         // Gets current Balance of token i, Bi, and weight of token i, Wi, from BPool.
2625         uint tokenBalance = bPool.getBalance(erc20);
2626         uint tokenWeight = bPool.getDenormalizedWeight(erc20);
2627 
2628         bool xfer = IERC20(erc20).transferFrom(from, address(this), amount);
2629         require(xfer, "ERR_ERC20_FALSE");
2630         bPool.rebind(erc20, BalancerSafeMath.badd(tokenBalance, amount), tokenWeight);
2631     }
2632 
2633     // Rebind BPool and push tokens to address
2634     // bPool is a contract interface; function calls on it are external
2635     function _pushUnderlying(address erc20, address to, uint amount) internal needsBPool {
2636         // Gets current Balance of token i, Bi, and weight of token i, Wi, from BPool.
2637         uint tokenBalance = bPool.getBalance(erc20);
2638         uint tokenWeight = bPool.getDenormalizedWeight(erc20);
2639         bPool.rebind(erc20, BalancerSafeMath.bsub(tokenBalance, amount), tokenWeight);
2640 
2641         bool xfer = IERC20(erc20).transfer(to, amount);
2642         require(xfer, "ERR_ERC20_FALSE");
2643     }
2644 
2645     // Wrappers around corresponding core functions
2646 
2647     //
2648     function _mint(uint amount) internal override {
2649         super._mint(amount);
2650         require(varTotalSupply <= bspCap, "ERR_CAP_LIMIT_REACHED");
2651     }
2652 
2653     function _mintPoolShare(uint amount) internal {
2654         _mint(amount);
2655     }
2656 
2657     function _pushPoolShare(address to, uint amount) internal {
2658         _push(to, amount);
2659     }
2660 
2661     function _pullPoolShare(address from, uint amount) internal  {
2662         _pull(from, amount);
2663     }
2664 
2665     function _burnPoolShare(uint amount) internal  {
2666         _burn(amount);
2667     }
2668 }
2669 
2670 // File: contracts/AmplElasticCRP.sol
2671 
2672 
2673 
2674 
2675 // Needed to handle structures externally
2676 
2677 // Imports
2678 
2679 
2680 /**
2681  * @author Ampleforth engineering team & Balancer Labs
2682  *
2683  * Reference:
2684  * https://github.com/balancer-labs/configurable-rights-pool/blob/master/contracts/templates/ElasticSupplyPool.sol
2685  *
2686  * @title Ampl Elastic Configurable Rights Pool.
2687  *
2688  * @dev   Extension of Balancer labs' configurable rights pool (smart-pool).
2689  *        Amples are a dynamic supply tokens, supply and individual balances change daily by a Rebase operation.
2690  *        In constant-function markets, Ampleforth's supply adjustments result in Impermanent Loss (IL)
2691  *        to liquidity providers. The AmplElasticCRP is an extension of Balancer Lab's
2692  *        ConfigurableRightsPool which mitigates IL induced by supply adjustments.
2693  *
2694  *        It accomplishes this by doing the following mechanism:
2695  *        The `resyncWeight` method will be invoked atomically after rebase through Ampleforth's orchestrator.
2696  *
2697  *        When rebase changes supply, ampl weight is updated to the geometric mean of
2698  *        the current ampl weight and the target. Every other token's weight is updated
2699  *        proportionally such that relative ratios are same.
2700  *
2701  *        Weights: {w_ampl, w_t1 ... w_tn}
2702  *
2703  *        Rebase_change: x% (Ample's supply changes by x%, can be positive or negative)
2704  *
2705  *        Ample target weight: w_ampl_target = (100+x)/100 * w_ampl
2706  *
2707  *        w_ampl_new = sqrt(w_ampl * w_ampl_target)  // geometric mean
2708  *        for i in tn:
2709  *           w_ti_new = (w_ampl_new * w_ti) / w_ampl_target
2710  *
2711  */
2712 contract AmplElasticCRP is ConfigurableRightsPool {
2713     constructor(
2714         address factoryAddress,
2715         PoolParams memory poolParams,
2716         RightsManager.Rights memory rightsStruct
2717     )
2718     public
2719     ConfigurableRightsPool(factoryAddress, poolParams, rightsStruct) {
2720 
2721         require(rights.canChangeWeights, "ERR_NOT_CONFIGURABLE_WEIGHTS");
2722 
2723     }
2724 
2725     function updateWeight(address token, uint newWeight)
2726         external
2727         logs
2728         onlyOwner
2729         needsBPool
2730         override
2731     {
2732         revert("ERR_UNSUPPORTED_OPERATION");
2733     }
2734 
2735     function updateWeightsGradually(
2736         uint[] calldata newWeights,
2737         uint startBlock,
2738         uint endBlock
2739     )
2740         external
2741         logs
2742         onlyOwner
2743         needsBPool
2744         override
2745     {
2746         revert("ERR_UNSUPPORTED_OPERATION");
2747     }
2748 
2749     function pokeWeights()
2750         external
2751         logs
2752         needsBPool
2753         override
2754     {
2755        revert("ERR_UNSUPPORTED_OPERATION");
2756     }
2757 
2758     /*
2759      * @param token The address of the token in the underlying BPool to be weight adjusted.
2760      * @dev Checks if the token's current pool balance has deviated from cached balance,
2761      *      if so it adjusts the token's weights proportional to the deviation.
2762      *      The underlying BPool enforces bounds on MIN_WEIGHTS=1e18, MAX_WEIGHT=50e18 and TOTAL_WEIGHT=50e18.
2763      *      NOTE: The BPool.rebind function CAN REVERT if the updated weights go beyond the enforced bounds.
2764      */
2765     function resyncWeight(address token)
2766         external
2767         logs
2768         lock
2769         needsBPool
2770     {
2771 
2772         // NOTE: Skipping gradual update check
2773         // Pool will never go into gradual update state as `updateWeightsGradually` is disabled
2774         // require(
2775         //     ConfigurableRightsPool.gradualUpdate.startBlock == 0,
2776         //     "ERR_NO_UPDATE_DURING_GRADUAL");
2777 
2778         require(
2779             IBPool(address(bPool)).isBound(token),
2780             "ERR_NOT_BOUND");
2781 
2782         // get cached balance
2783         uint tokenBalanceBefore = IBPool(address(bPool)).getBalance(token);
2784 
2785         // sync balance
2786         IBPool(address(bPool)).gulp(token);
2787 
2788         // get new balance
2789         uint tokenBalanceAfter = IBPool(address(bPool)).getBalance(token);
2790 
2791         // No-Op
2792         if(tokenBalanceBefore == tokenBalanceAfter) {
2793             return;
2794         }
2795 
2796         // current token weight
2797         uint tokenWeightBefore = IBPool(address(bPool)).getDenormalizedWeight(token);
2798 
2799         // target token weight = RebaseRatio * previous token weight
2800         uint tokenWeightTarget = BalancerSafeMath.bdiv(
2801             BalancerSafeMath.bmul(tokenWeightBefore, tokenBalanceAfter),
2802             tokenBalanceBefore
2803         );
2804 
2805         // new token weight = sqrt(current token weight * target token weight)
2806         uint tokenWeightAfter = BalancerSafeMath.sqrt(
2807             BalancerSafeMath.bdiv(
2808                 BalancerSafeMath.bmul(tokenWeightBefore, tokenWeightTarget),
2809                 1
2810             )
2811         );
2812 
2813 
2814         address[] memory tokens = IBPool(address(bPool)).getCurrentTokens();
2815         for(uint i=0; i<tokens.length; i++){
2816             if(tokens[i] == token) {
2817 
2818                 // adjust weight
2819                 IBPool(address(bPool)).rebind(token, tokenBalanceAfter, tokenWeightAfter);
2820 
2821             } else {
2822 
2823                 uint otherWeightBefore = IBPool(address(bPool)).getDenormalizedWeight(tokens[i]);
2824                 uint otherBalance = bPool.getBalance(tokens[i]);
2825 
2826                 // other token weight = (new token weight * other token weight before) / target token weight
2827                 uint otherWeightAfter = BalancerSafeMath.bdiv(
2828                     BalancerSafeMath.bmul(tokenWeightAfter, otherWeightBefore),
2829                     tokenWeightTarget
2830                 );
2831 
2832                 // adjust weight
2833                 IBPool(address(bPool)).rebind(tokens[i], otherBalance, otherWeightAfter);
2834             }
2835         }
2836     }
2837 }