1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
81 
82 pragma solidity ^0.5.0;
83 
84 
85 /**
86  * @dev Optional functions from the ERC20 standard.
87  */
88 contract ERC20Detailed is IERC20 {
89     string private _name;
90     string private _symbol;
91     uint8 private _decimals;
92 
93     /**
94      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
95      * these values are immutable: they can only be set once during
96      * construction.
97      */
98     constructor (string memory name, string memory symbol, uint8 decimals) public {
99         _name = name;
100         _symbol = symbol;
101         _decimals = decimals;
102     }
103 
104     /**
105      * @dev Returns the name of the token.
106      */
107     function name() public view returns (string memory) {
108         return _name;
109     }
110 
111     /**
112      * @dev Returns the symbol of the token, usually a shorter version of the
113      * name.
114      */
115     function symbol() public view returns (string memory) {
116         return _symbol;
117     }
118 
119     /**
120      * @dev Returns the number of decimals used to get its user representation.
121      * For example, if `decimals` equals `2`, a balance of `505` tokens should
122      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
123      *
124      * Tokens usually opt for a value of 18, imitating the relationship between
125      * Ether and Wei.
126      *
127      * NOTE: This information is only used for _display_ purposes: it in
128      * no way affects any of the arithmetic of the contract, including
129      * {IERC20-balanceOf} and {IERC20-transfer}.
130      */
131     function decimals() public view returns (uint8) {
132         return _decimals;
133     }
134 }
135 
136 // File: @openzeppelin/contracts/GSN/Context.sol
137 
138 pragma solidity ^0.5.0;
139 
140 /*
141  * @dev Provides information about the current execution context, including the
142  * sender of the transaction and its data. While these are generally available
143  * via msg.sender and msg.data, they should not be accessed in such a direct
144  * manner, since when dealing with GSN meta-transactions the account sending and
145  * paying for execution may not be the actual sender (as far as an application
146  * is concerned).
147  *
148  * This contract is only required for intermediate, library-like contracts.
149  */
150 contract Context {
151     // Empty internal constructor, to prevent people from mistakenly deploying
152     // an instance of this contract, which should be used via inheritance.
153     constructor () internal { }
154     // solhint-disable-previous-line no-empty-blocks
155 
156     function _msgSender() internal view returns (address payable) {
157         return msg.sender;
158     }
159 
160     function _msgData() internal view returns (bytes memory) {
161         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
162         return msg.data;
163     }
164 }
165 
166 // File: @openzeppelin/contracts/math/SafeMath.sol
167 
168 pragma solidity ^0.5.0;
169 
170 /**
171  * @dev Wrappers over Solidity's arithmetic operations with added overflow
172  * checks.
173  *
174  * Arithmetic operations in Solidity wrap on overflow. This can easily result
175  * in bugs, because programmers usually assume that an overflow raises an
176  * error, which is the standard behavior in high level programming languages.
177  * `SafeMath` restores this intuition by reverting the transaction when an
178  * operation overflows.
179  *
180  * Using this library instead of the unchecked operations eliminates an entire
181  * class of bugs, so it's recommended to use it always.
182  */
183 library SafeMath {
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      * - Addition cannot overflow.
192      */
193     function add(uint256 a, uint256 b) internal pure returns (uint256) {
194         uint256 c = a + b;
195         require(c >= a, "SafeMath: addition overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      * - Subtraction cannot overflow.
208      */
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210         return sub(a, b, "SafeMath: subtraction overflow");
211     }
212 
213     /**
214      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
215      * overflow (when the result is negative).
216      *
217      * Counterpart to Solidity's `-` operator.
218      *
219      * Requirements:
220      * - Subtraction cannot overflow.
221      *
222      * _Available since v2.4.0._
223      */
224     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b <= a, errorMessage);
226         uint256 c = a - b;
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the multiplication of two unsigned integers, reverting on
233      * overflow.
234      *
235      * Counterpart to Solidity's `*` operator.
236      *
237      * Requirements:
238      * - Multiplication cannot overflow.
239      */
240     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
241         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
242         // benefit is lost if 'b' is also tested.
243         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
244         if (a == 0) {
245             return 0;
246         }
247 
248         uint256 c = a * b;
249         require(c / a == b, "SafeMath: multiplication overflow");
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the integer division of two unsigned integers. Reverts on
256      * division by zero. The result is rounded towards zero.
257      *
258      * Counterpart to Solidity's `/` operator. Note: this function uses a
259      * `revert` opcode (which leaves remaining gas untouched) while Solidity
260      * uses an invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      * - The divisor cannot be zero.
264      */
265     function div(uint256 a, uint256 b) internal pure returns (uint256) {
266         return div(a, b, "SafeMath: division by zero");
267     }
268 
269     /**
270      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
271      * division by zero. The result is rounded towards zero.
272      *
273      * Counterpart to Solidity's `/` operator. Note: this function uses a
274      * `revert` opcode (which leaves remaining gas untouched) while Solidity
275      * uses an invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      * - The divisor cannot be zero.
279      *
280      * _Available since v2.4.0._
281      */
282     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         // Solidity only automatically asserts when dividing by 0
284         require(b > 0, errorMessage);
285         uint256 c = a / b;
286         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * Reverts when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      * - The divisor cannot be zero.
301      */
302     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
303         return mod(a, b, "SafeMath: modulo by zero");
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * Reverts with custom message when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      * - The divisor cannot be zero.
316      *
317      * _Available since v2.4.0._
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b != 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
326 
327 pragma solidity ^0.5.0;
328 
329 
330 
331 
332 /**
333  * @dev Implementation of the {IERC20} interface.
334  *
335  * This implementation is agnostic to the way tokens are created. This means
336  * that a supply mechanism has to be added in a derived contract using {_mint}.
337  * For a generic mechanism see {ERC20Mintable}.
338  *
339  * TIP: For a detailed writeup see our guide
340  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
341  * to implement supply mechanisms].
342  *
343  * We have followed general OpenZeppelin guidelines: functions revert instead
344  * of returning `false` on failure. This behavior is nonetheless conventional
345  * and does not conflict with the expectations of ERC20 applications.
346  *
347  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
348  * This allows applications to reconstruct the allowance for all accounts just
349  * by listening to said events. Other implementations of the EIP may not emit
350  * these events, as it isn't required by the specification.
351  *
352  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
353  * functions have been added to mitigate the well-known issues around setting
354  * allowances. See {IERC20-approve}.
355  */
356 contract ERC20 is Context, IERC20 {
357     using SafeMath for uint256;
358 
359     mapping (address => uint256) private _balances;
360 
361     mapping (address => mapping (address => uint256)) private _allowances;
362 
363     uint256 private _totalSupply;
364 
365     /**
366      * @dev See {IERC20-totalSupply}.
367      */
368     function totalSupply() public view returns (uint256) {
369         return _totalSupply;
370     }
371 
372     /**
373      * @dev See {IERC20-balanceOf}.
374      */
375     function balanceOf(address account) public view returns (uint256) {
376         return _balances[account];
377     }
378 
379     /**
380      * @dev See {IERC20-transfer}.
381      *
382      * Requirements:
383      *
384      * - `recipient` cannot be the zero address.
385      * - the caller must have a balance of at least `amount`.
386      */
387     function transfer(address recipient, uint256 amount) public returns (bool) {
388         _transfer(_msgSender(), recipient, amount);
389         return true;
390     }
391 
392     /**
393      * @dev See {IERC20-allowance}.
394      */
395     function allowance(address owner, address spender) public view returns (uint256) {
396         return _allowances[owner][spender];
397     }
398 
399     /**
400      * @dev See {IERC20-approve}.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      */
406     function approve(address spender, uint256 amount) public returns (bool) {
407         _approve(_msgSender(), spender, amount);
408         return true;
409     }
410 
411     /**
412      * @dev See {IERC20-transferFrom}.
413      *
414      * Emits an {Approval} event indicating the updated allowance. This is not
415      * required by the EIP. See the note at the beginning of {ERC20};
416      *
417      * Requirements:
418      * - `sender` and `recipient` cannot be the zero address.
419      * - `sender` must have a balance of at least `amount`.
420      * - the caller must have allowance for `sender`'s tokens of at least
421      * `amount`.
422      */
423     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
424         _transfer(sender, recipient, amount);
425         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
426         return true;
427     }
428 
429     /**
430      * @dev Atomically increases the allowance granted to `spender` by the caller.
431      *
432      * This is an alternative to {approve} that can be used as a mitigation for
433      * problems described in {IERC20-approve}.
434      *
435      * Emits an {Approval} event indicating the updated allowance.
436      *
437      * Requirements:
438      *
439      * - `spender` cannot be the zero address.
440      */
441     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
442         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
443         return true;
444     }
445 
446     /**
447      * @dev Atomically decreases the allowance granted to `spender` by the caller.
448      *
449      * This is an alternative to {approve} that can be used as a mitigation for
450      * problems described in {IERC20-approve}.
451      *
452      * Emits an {Approval} event indicating the updated allowance.
453      *
454      * Requirements:
455      *
456      * - `spender` cannot be the zero address.
457      * - `spender` must have allowance for the caller of at least
458      * `subtractedValue`.
459      */
460     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
461         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
462         return true;
463     }
464 
465     /**
466      * @dev Moves tokens `amount` from `sender` to `recipient`.
467      *
468      * This is internal function is equivalent to {transfer}, and can be used to
469      * e.g. implement automatic token fees, slashing mechanisms, etc.
470      *
471      * Emits a {Transfer} event.
472      *
473      * Requirements:
474      *
475      * - `sender` cannot be the zero address.
476      * - `recipient` cannot be the zero address.
477      * - `sender` must have a balance of at least `amount`.
478      */
479     function _transfer(address sender, address recipient, uint256 amount) internal {
480         require(sender != address(0), "ERC20: transfer from the zero address");
481         require(recipient != address(0), "ERC20: transfer to the zero address");
482 
483         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
484         _balances[recipient] = _balances[recipient].add(amount);
485         emit Transfer(sender, recipient, amount);
486     }
487 
488     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
489      * the total supply.
490      *
491      * Emits a {Transfer} event with `from` set to the zero address.
492      *
493      * Requirements
494      *
495      * - `to` cannot be the zero address.
496      */
497     function _mint(address account, uint256 amount) internal {
498         require(account != address(0), "ERC20: mint to the zero address");
499 
500         _totalSupply = _totalSupply.add(amount);
501         _balances[account] = _balances[account].add(amount);
502         emit Transfer(address(0), account, amount);
503     }
504 
505     /**
506      * @dev Destroys `amount` tokens from `account`, reducing the
507      * total supply.
508      *
509      * Emits a {Transfer} event with `to` set to the zero address.
510      *
511      * Requirements
512      *
513      * - `account` cannot be the zero address.
514      * - `account` must have at least `amount` tokens.
515      */
516     function _burn(address account, uint256 amount) internal {
517         require(account != address(0), "ERC20: burn from the zero address");
518 
519         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
520         _totalSupply = _totalSupply.sub(amount);
521         emit Transfer(account, address(0), amount);
522     }
523 
524     /**
525      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
526      *
527      * This is internal function is equivalent to `approve`, and can be used to
528      * e.g. set automatic allowances for certain subsystems, etc.
529      *
530      * Emits an {Approval} event.
531      *
532      * Requirements:
533      *
534      * - `owner` cannot be the zero address.
535      * - `spender` cannot be the zero address.
536      */
537     function _approve(address owner, address spender, uint256 amount) internal {
538         require(owner != address(0), "ERC20: approve from the zero address");
539         require(spender != address(0), "ERC20: approve to the zero address");
540 
541         _allowances[owner][spender] = amount;
542         emit Approval(owner, spender, amount);
543     }
544 
545     /**
546      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
547      * from the caller's allowance.
548      *
549      * See {_burn} and {_approve}.
550      */
551     function _burnFrom(address account, uint256 amount) internal {
552         _burn(account, amount);
553         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
554     }
555 }
556 
557 // File: @openzeppelin/contracts/GSN/IRelayRecipient.sol
558 
559 pragma solidity ^0.5.0;
560 
561 /**
562  * @dev Base interface for a contract that will be called via the GSN from {IRelayHub}.
563  *
564  * TIP: You don't need to write an implementation yourself! Inherit from {GSNRecipient} instead.
565  */
566 interface IRelayRecipient {
567     /**
568      * @dev Returns the address of the {IRelayHub} instance this recipient interacts with.
569      */
570     function getHubAddr() external view returns (address);
571 
572     /**
573      * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the
574      * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).
575      *
576      * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call
577      * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,
578      * and the transaction executed with a gas price of at least `gasPrice`. `relay`'s fee is `transactionFee`, and the
579      * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for
580      * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold a signature
581      * over all or some of the previous values.
582      *
583      * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,
584      * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.
585      *
586      * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered
587      * rejected. A regular revert will also trigger a rejection.
588      */
589     function acceptRelayedCall(
590         address relay,
591         address from,
592         bytes calldata encodedFunction,
593         uint256 transactionFee,
594         uint256 gasPrice,
595         uint256 gasLimit,
596         uint256 nonce,
597         bytes calldata approvalData,
598         uint256 maxPossibleCharge
599     )
600         external
601         view
602         returns (uint256, bytes memory);
603 
604     /**
605      * @dev Called by {IRelayHub} on approved relay call requests, before the relayed call is executed. This allows to e.g.
606      * pre-charge the sender of the transaction.
607      *
608      * `context` is the second value returned in the tuple by {acceptRelayedCall}.
609      *
610      * Returns a value to be passed to {postRelayedCall}.
611      *
612      * {preRelayedCall} is called with 100k gas: if it runs out during exection or otherwise reverts, the relayed call
613      * will not be executed, but the recipient will still be charged for the transaction's cost.
614      */
615     function preRelayedCall(bytes calldata context) external returns (bytes32);
616 
617     /**
618      * @dev Called by {IRelayHub} on approved relay call requests, after the relayed call is executed. This allows to e.g.
619      * charge the user for the relayed call costs, return any overcharges from {preRelayedCall}, or perform
620      * contract-specific bookkeeping.
621      *
622      * `context` is the second value returned in the tuple by {acceptRelayedCall}. `success` is the execution status of
623      * the relayed call. `actualCharge` is an estimate of how much the recipient will be charged for the transaction,
624      * not including any gas used by {postRelayedCall} itself. `preRetVal` is {preRelayedCall}'s return value.
625      *
626      *
627      * {postRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call
628      * and the call to {preRelayedCall} will be reverted retroactively, but the recipient will still be charged for the
629      * transaction's cost.
630      */
631     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
632 }
633 
634 // File: @openzeppelin/contracts/GSN/IRelayHub.sol
635 
636 pragma solidity ^0.5.0;
637 
638 /**
639  * @dev Interface for `RelayHub`, the core contract of the GSN. Users should not need to interact with this contract
640  * directly.
641  *
642  * See the https://github.com/OpenZeppelin/openzeppelin-gsn-helpers[OpenZeppelin GSN helpers] for more information on
643  * how to deploy an instance of `RelayHub` on your local test network.
644  */
645 interface IRelayHub {
646     // Relay management
647 
648     /**
649      * @dev Adds stake to a relay and sets its `unstakeDelay`. If the relay does not exist, it is created, and the caller
650      * of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
651      * cannot be its own owner.
652      *
653      * All Ether in this function call will be added to the relay's stake.
654      * Its unstake delay will be assigned to `unstakeDelay`, but the new value must be greater or equal to the current one.
655      *
656      * Emits a {Staked} event.
657      */
658     function stake(address relayaddr, uint256 unstakeDelay) external payable;
659 
660     /**
661      * @dev Emitted when a relay's stake or unstakeDelay are increased
662      */
663     event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);
664 
665     /**
666      * @dev Registers the caller as a relay.
667      * The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
668      *
669      * This function can be called multiple times, emitting new {RelayAdded} events. Note that the received
670      * `transactionFee` is not enforced by {relayCall}.
671      *
672      * Emits a {RelayAdded} event.
673      */
674     function registerRelay(uint256 transactionFee, string calldata url) external;
675 
676     /**
677      * @dev Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out
678      * {RelayRemoved} events) lets a client discover the list of available relays.
679      */
680     event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);
681 
682     /**
683      * @dev Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed.
684      *
685      * Can only be called by the owner of the relay. After the relay's `unstakeDelay` has elapsed, {unstake} will be
686      * callable.
687      *
688      * Emits a {RelayRemoved} event.
689      */
690     function removeRelayByOwner(address relay) external;
691 
692     /**
693      * @dev Emitted when a relay is removed (deregistered). `unstakeTime` is the time when unstake will be callable.
694      */
695     event RelayRemoved(address indexed relay, uint256 unstakeTime);
696 
697     /** Deletes the relay from the system, and gives back its stake to the owner.
698      *
699      * Can only be called by the relay owner, after `unstakeDelay` has elapsed since {removeRelayByOwner} was called.
700      *
701      * Emits an {Unstaked} event.
702      */
703     function unstake(address relay) external;
704 
705     /**
706      * @dev Emitted when a relay is unstaked for, including the returned stake.
707      */
708     event Unstaked(address indexed relay, uint256 stake);
709 
710     // States a relay can be in
711     enum RelayState {
712         Unknown, // The relay is unknown to the system: it has never been staked for
713         Staked, // The relay has been staked for, but it is not yet active
714         Registered, // The relay has registered itself, and is active (can relay calls)
715         Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
716     }
717 
718     /**
719      * @dev Returns a relay's status. Note that relays can be deleted when unstaked or penalized, causing this function
720      * to return an empty entry.
721      */
722     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);
723 
724     // Balance management
725 
726     /**
727      * @dev Deposits Ether for a contract, so that it can receive (and pay for) relayed transactions.
728      *
729      * Unused balance can only be withdrawn by the contract itself, by calling {withdraw}.
730      *
731      * Emits a {Deposited} event.
732      */
733     function depositFor(address target) external payable;
734 
735     /**
736      * @dev Emitted when {depositFor} is called, including the amount and account that was funded.
737      */
738     event Deposited(address indexed recipient, address indexed from, uint256 amount);
739 
740     /**
741      * @dev Returns an account's deposits. These can be either a contracts's funds, or a relay owner's revenue.
742      */
743     function balanceOf(address target) external view returns (uint256);
744 
745     /**
746      * Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
747      * contracts can use it to reduce their funding.
748      *
749      * Emits a {Withdrawn} event.
750      */
751     function withdraw(uint256 amount, address payable dest) external;
752 
753     /**
754      * @dev Emitted when an account withdraws funds from `RelayHub`.
755      */
756     event Withdrawn(address indexed account, address indexed dest, uint256 amount);
757 
758     // Relaying
759 
760     /**
761      * @dev Checks if the `RelayHub` will accept a relayed operation.
762      * Multiple things must be true for this to happen:
763      *  - all arguments must be signed for by the sender (`from`)
764      *  - the sender's nonce must be the current one
765      *  - the recipient must accept this transaction (via {acceptRelayedCall})
766      *
767      * Returns a `PreconditionCheck` value (`OK` when the transaction can be relayed), or a recipient-specific error
768      * code if it returns one in {acceptRelayedCall}.
769      */
770     function canRelay(
771         address relay,
772         address from,
773         address to,
774         bytes calldata encodedFunction,
775         uint256 transactionFee,
776         uint256 gasPrice,
777         uint256 gasLimit,
778         uint256 nonce,
779         bytes calldata signature,
780         bytes calldata approvalData
781     ) external view returns (uint256 status, bytes memory recipientContext);
782 
783     // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
784     enum PreconditionCheck {
785         OK,                         // All checks passed, the call can be relayed
786         WrongSignature,             // The transaction to relay is not signed by requested sender
787         WrongNonce,                 // The provided nonce has already been used by the sender
788         AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
789         InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
790     }
791 
792     /**
793      * @dev Relays a transaction.
794      *
795      * For this to succeed, multiple conditions must be met:
796      *  - {canRelay} must `return PreconditionCheck.OK`
797      *  - the sender must be a registered relay
798      *  - the transaction's gas price must be larger or equal to the one that was requested by the sender
799      *  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
800      * recipient) use all gas available to them
801      *  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
802      * spent)
803      *
804      * If all conditions are met, the call will be relayed and the recipient charged. {preRelayedCall}, the encoded
805      * function and {postRelayedCall} will be called in that order.
806      *
807      * Parameters:
808      *  - `from`: the client originating the request
809      *  - `to`: the target {IRelayRecipient} contract
810      *  - `encodedFunction`: the function call to relay, including data
811      *  - `transactionFee`: fee (%) the relay takes over actual gas cost
812      *  - `gasPrice`: gas price the client is willing to pay
813      *  - `gasLimit`: gas to forward when calling the encoded function
814      *  - `nonce`: client's nonce
815      *  - `signature`: client's signature over all previous params, plus the relay and RelayHub addresses
816      *  - `approvalData`: dapp-specific data forwared to {acceptRelayedCall}. This value is *not* verified by the
817      * `RelayHub`, but it still can be used for e.g. a signature.
818      *
819      * Emits a {TransactionRelayed} event.
820      */
821     function relayCall(
822         address from,
823         address to,
824         bytes calldata encodedFunction,
825         uint256 transactionFee,
826         uint256 gasPrice,
827         uint256 gasLimit,
828         uint256 nonce,
829         bytes calldata signature,
830         bytes calldata approvalData
831     ) external;
832 
833     /**
834      * @dev Emitted when an attempt to relay a call failed.
835      *
836      * This can happen due to incorrect {relayCall} arguments, or the recipient not accepting the relayed call. The
837      * actual relayed call was not executed, and the recipient not charged.
838      *
839      * The `reason` parameter contains an error code: values 1-10 correspond to `PreconditionCheck` entries, and values
840      * over 10 are custom recipient error codes returned from {acceptRelayedCall}.
841      */
842     event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);
843 
844     /**
845      * @dev Emitted when a transaction is relayed. 
846      * Useful when monitoring a relay's operation and relayed calls to a contract
847      *
848      * Note that the actual encoded function might be reverted: this is indicated in the `status` parameter.
849      *
850      * `charge` is the Ether value deducted from the recipient's balance, paid to the relay's owner.
851      */
852     event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);
853 
854     // Reason error codes for the TransactionRelayed event
855     enum RelayCallStatus {
856         OK,                      // The transaction was successfully relayed and execution successful - never included in the event
857         RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
858         PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
859         PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
860         RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
861     }
862 
863     /**
864      * @dev Returns how much gas should be forwarded to a call to {relayCall}, in order to relay a transaction that will
865      * spend up to `relayedCallStipend` gas.
866      */
867     function requiredGas(uint256 relayedCallStipend) external view returns (uint256);
868 
869     /**
870      * @dev Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
871      */
872     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) external view returns (uint256);
873 
874      // Relay penalization. 
875      // Any account can penalize relays, removing them from the system immediately, and rewarding the
876     // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
877     // still loses half of its stake.
878 
879     /**
880      * @dev Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
881      * different data (gas price, gas limit, etc. may be different).
882      *
883      * The (unsigned) transaction data and signature for both transactions must be provided.
884      */
885     function penalizeRepeatedNonce(bytes calldata unsignedTx1, bytes calldata signature1, bytes calldata unsignedTx2, bytes calldata signature2) external;
886 
887     /**
888      * @dev Penalize a relay that sent a transaction that didn't target `RelayHub`'s {registerRelay} or {relayCall}.
889      */
890     function penalizeIllegalTransaction(bytes calldata unsignedTx, bytes calldata signature) external;
891 
892     /**
893      * @dev Emitted when a relay is penalized.
894      */
895     event Penalized(address indexed relay, address sender, uint256 amount);
896 
897     /**
898      * @dev Returns an account's nonce in `RelayHub`.
899      */
900     function getNonce(address from) external view returns (uint256);
901 }
902 
903 // File: @openzeppelin/contracts/GSN/GSNRecipient.sol
904 
905 pragma solidity ^0.5.0;
906 
907 
908 
909 
910 /**
911  * @dev Base GSN recipient contract: includes the {IRelayRecipient} interface
912  * and enables GSN support on all contracts in the inheritance tree.
913  *
914  * TIP: This contract is abstract. The functions {IRelayRecipient-acceptRelayedCall},
915  *  {_preRelayedCall}, and {_postRelayedCall} are not implemented and must be
916  * provided by derived contracts. See the
917  * xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategies] for more
918  * information on how to use the pre-built {GSNRecipientSignature} and
919  * {GSNRecipientERC20Fee}, or how to write your own.
920  */
921 contract GSNRecipient is IRelayRecipient, Context {
922     // Default RelayHub address, deployed on mainnet and all testnets at the same address
923     address private _relayHub = 0xD216153c06E857cD7f72665E0aF1d7D82172F494;
924 
925     uint256 constant private RELAYED_CALL_ACCEPTED = 0;
926     uint256 constant private RELAYED_CALL_REJECTED = 11;
927 
928     // How much gas is forwarded to postRelayedCall
929     uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;
930 
931     /**
932      * @dev Emitted when a contract changes its {IRelayHub} contract to a new one.
933      */
934     event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);
935 
936     /**
937      * @dev Returns the address of the {IRelayHub} contract for this recipient.
938      */
939     function getHubAddr() public view returns (address) {
940         return _relayHub;
941     }
942 
943     /**
944      * @dev Switches to a new {IRelayHub} instance. This method is added for future-proofing: there's no reason to not
945      * use the default instance.
946      *
947      * IMPORTANT: After upgrading, the {GSNRecipient} will no longer be able to receive relayed calls from the old
948      * {IRelayHub} instance. Additionally, all funds should be previously withdrawn via {_withdrawDeposits}.
949      */
950     function _upgradeRelayHub(address newRelayHub) internal {
951         address currentRelayHub = _relayHub;
952         require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
953         require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");
954 
955         emit RelayHubChanged(currentRelayHub, newRelayHub);
956 
957         _relayHub = newRelayHub;
958     }
959 
960     /**
961      * @dev Returns the version string of the {IRelayHub} for which this recipient implementation was built. If
962      * {_upgradeRelayHub} is used, the new {IRelayHub} instance should be compatible with this version.
963      */
964     // This function is view for future-proofing, it may require reading from
965     // storage in the future.
966     function relayHubVersion() public view returns (string memory) {
967         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
968         return "1.0.0";
969     }
970 
971     /**
972      * @dev Withdraws the recipient's deposits in `RelayHub`.
973      *
974      * Derived contracts should expose this in an external interface with proper access control.
975      */
976     function _withdrawDeposits(uint256 amount, address payable payee) internal {
977         IRelayHub(_relayHub).withdraw(amount, payee);
978     }
979 
980     // Overrides for Context's functions: when called from RelayHub, sender and
981     // data require some pre-processing: the actual sender is stored at the end
982     // of the call data, which in turns means it needs to be removed from it
983     // when handling said data.
984 
985     /**
986      * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
987      * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
988      *
989      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
990      */
991     function _msgSender() internal view returns (address payable) {
992         if (msg.sender != _relayHub) {
993             return msg.sender;
994         } else {
995             return _getRelayedCallSender();
996         }
997     }
998 
999     /**
1000      * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
1001      * and a reduced version for GSN relayed calls (where msg.data contains additional information).
1002      *
1003      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
1004      */
1005     function _msgData() internal view returns (bytes memory) {
1006         if (msg.sender != _relayHub) {
1007             return msg.data;
1008         } else {
1009             return _getRelayedCallData();
1010         }
1011     }
1012 
1013     // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the
1014     // internal hook.
1015 
1016     /**
1017      * @dev See `IRelayRecipient.preRelayedCall`.
1018      *
1019      * This function should not be overriden directly, use `_preRelayedCall` instead.
1020      *
1021      * * Requirements:
1022      *
1023      * - the caller must be the `RelayHub` contract.
1024      */
1025     function preRelayedCall(bytes calldata context) external returns (bytes32) {
1026         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1027         return _preRelayedCall(context);
1028     }
1029 
1030     /**
1031      * @dev See `IRelayRecipient.preRelayedCall`.
1032      *
1033      * Called by `GSNRecipient.preRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1034      * must implement this function with any relayed-call preprocessing they may wish to do.
1035      *
1036      */
1037     function _preRelayedCall(bytes memory context) internal returns (bytes32);
1038 
1039     /**
1040      * @dev See `IRelayRecipient.postRelayedCall`.
1041      *
1042      * This function should not be overriden directly, use `_postRelayedCall` instead.
1043      *
1044      * * Requirements:
1045      *
1046      * - the caller must be the `RelayHub` contract.
1047      */
1048     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {
1049         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1050         _postRelayedCall(context, success, actualCharge, preRetVal);
1051     }
1052 
1053     /**
1054      * @dev See `IRelayRecipient.postRelayedCall`.
1055      *
1056      * Called by `GSNRecipient.postRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1057      * must implement this function with any relayed-call postprocessing they may wish to do.
1058      *
1059      */
1060     function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal;
1061 
1062     /**
1063      * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract
1064      * will be charged a fee by RelayHub
1065      */
1066     function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
1067         return _approveRelayedCall("");
1068     }
1069 
1070     /**
1071      * @dev See `GSNRecipient._approveRelayedCall`.
1072      *
1073      * This overload forwards `context` to _preRelayedCall and _postRelayedCall.
1074      */
1075     function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
1076         return (RELAYED_CALL_ACCEPTED, context);
1077     }
1078 
1079     /**
1080      * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.
1081      */
1082     function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
1083         return (RELAYED_CALL_REJECTED + errorCode, "");
1084     }
1085 
1086     /*
1087      * @dev Calculates how much RelayHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's
1088      * `serviceFee`.
1089      */
1090     function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
1091         // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
1092         // charged for 1.4 times the spent amount.
1093         return (gas * gasPrice * (100 + serviceFee)) / 100;
1094     }
1095 
1096     function _getRelayedCallSender() private pure returns (address payable result) {
1097         // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
1098         // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
1099         // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
1100         // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
1101         // bytes. This can always be done due to the 32-byte prefix.
1102 
1103         // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
1104         // easiest/most-efficient way to perform this operation.
1105 
1106         // These fields are not accessible from assembly
1107         bytes memory array = msg.data;
1108         uint256 index = msg.data.length;
1109 
1110         // solhint-disable-next-line no-inline-assembly
1111         assembly {
1112             // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1113             result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
1114         }
1115         return result;
1116     }
1117 
1118     function _getRelayedCallData() private pure returns (bytes memory) {
1119         // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
1120         // we must strip the last 20 bytes (length of an address type) from it.
1121 
1122         uint256 actualDataLength = msg.data.length - 20;
1123         bytes memory actualData = new bytes(actualDataLength);
1124 
1125         for (uint256 i = 0; i < actualDataLength; ++i) {
1126             actualData[i] = msg.data[i];
1127         }
1128 
1129         return actualData;
1130     }
1131 }
1132 
1133 // File: @openzeppelin/contracts/ownership/Ownable.sol
1134 
1135 pragma solidity ^0.5.0;
1136 
1137 /**
1138  * @dev Contract module which provides a basic access control mechanism, where
1139  * there is an account (an owner) that can be granted exclusive access to
1140  * specific functions.
1141  *
1142  * This module is used through inheritance. It will make available the modifier
1143  * `onlyOwner`, which can be applied to your functions to restrict their use to
1144  * the owner.
1145  */
1146 contract Ownable is Context {
1147     address private _owner;
1148 
1149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1150 
1151     /**
1152      * @dev Initializes the contract setting the deployer as the initial owner.
1153      */
1154     constructor () internal {
1155         address msgSender = _msgSender();
1156         _owner = msgSender;
1157         emit OwnershipTransferred(address(0), msgSender);
1158     }
1159 
1160     /**
1161      * @dev Returns the address of the current owner.
1162      */
1163     function owner() public view returns (address) {
1164         return _owner;
1165     }
1166 
1167     /**
1168      * @dev Throws if called by any account other than the owner.
1169      */
1170     modifier onlyOwner() {
1171         require(isOwner(), "Ownable: caller is not the owner");
1172         _;
1173     }
1174 
1175     /**
1176      * @dev Returns true if the caller is the current owner.
1177      */
1178     function isOwner() public view returns (bool) {
1179         return _msgSender() == _owner;
1180     }
1181 
1182     /**
1183      * @dev Leaves the contract without owner. It will not be possible to call
1184      * `onlyOwner` functions anymore. Can only be called by the current owner.
1185      *
1186      * NOTE: Renouncing ownership will leave the contract without an owner,
1187      * thereby removing any functionality that is only available to the owner.
1188      */
1189     function renounceOwnership() public onlyOwner {
1190         emit OwnershipTransferred(_owner, address(0));
1191         _owner = address(0);
1192     }
1193 
1194     /**
1195      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1196      * Can only be called by the current owner.
1197      */
1198     function transferOwnership(address newOwner) public onlyOwner {
1199         _transferOwnership(newOwner);
1200     }
1201 
1202     /**
1203      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1204      */
1205     function _transferOwnership(address newOwner) internal {
1206         require(newOwner != address(0), "Ownable: new owner is the zero address");
1207         emit OwnershipTransferred(_owner, newOwner);
1208         _owner = newOwner;
1209     }
1210 }
1211 
1212 // File: interface/IStormXToken.sol
1213 
1214 pragma solidity 0.5.16;
1215 
1216 
1217 contract IStormXToken is ERC20 {
1218   function unlockedBalanceOf(address account) public view returns (uint256);
1219 }
1220 
1221 // File: contracts/StormXGSNRecipient.sol
1222 
1223 pragma solidity 0.5.16;
1224 
1225 
1226 
1227 
1228 
1229 
1230 contract StormXGSNRecipient is GSNRecipient, Ownable {
1231 
1232   using SafeMath for uint256;
1233 
1234   // Variables and constants for supporting GSN
1235   uint256 constant INSUFFICIENT_BALANCE = 11;
1236   uint256 public chargeFee;
1237   address public stormXReserve;
1238 
1239   // importing ``StormXToken.sol`` results in infinite loop
1240   // using only an interface
1241   IStormXToken public token;
1242   
1243   event StormXReserveSet(address newAddress);
1244   event ChargeFeeSet(uint256 newFee);
1245 
1246   /**
1247    * @param tokenAddress address of `StormXToken.sol`
1248    * @param reserve address that receives GSN charge fee
1249    */
1250   constructor(address tokenAddress, address reserve) public {
1251     require(tokenAddress != address(0), "Invalid token address");
1252     require(reserve != address(0), "Invalid reserve address");
1253 
1254     token = IStormXToken(tokenAddress);
1255     stormXReserve = reserve;
1256     // decimals of StormXToken is 18
1257     chargeFee = 10 * (10 ** 18);
1258   }
1259 
1260   /**
1261    * Note: the documentation is copied from
1262    * `openzeppelin-contracts/contracts/GSN/IRelayRecipient.sol`
1263    * @dev Called by {IRelayHub} to validate
1264    * if this recipient accepts being charged for a relayed call.
1265    * Note that the recipient will be charged regardless of the execution result of the relayed call
1266    * (i.e. if it reverts or not).
1267    *
1268    * The relay request was originated by `from` and will be served by `relay`.
1269    * `encodedFunction` is the relayed call calldata,
1270    * so its first four bytes are the function selector.
1271    * The relayed call will be forwarded `gasLimit` gas,
1272    * and the transaction executed with a gas price of at least `gasPrice`.
1273    * `relay`'s fee is `transactionFee`,
1274    * and the recipient will be charged at most `maxPossibleCharge` (in wei).
1275    * `nonce` is the sender's (`from`) nonce for replay attack protection in {IRelayHub},
1276    * and `approvalData` is a optional parameter that can be used to hold a signature
1277    * over all or some of the previous values.
1278    *
1279    * Returns a tuple, where the first value is used to indicate approval (0)
1280    * or rejection (custom non-zero error code, values 1 to 10 are reserved)
1281    * and the second one is data to be passed to the other {IRelayRecipient} functions.
1282    *
1283    * {acceptRelayedCall} is called with 50k gas: if it runs out during execution,
1284    * the request will be considered
1285    * rejected. A regular revert will also trigger a rejection.
1286    */
1287   function acceptRelayedCall(
1288     address relay,
1289     address from,
1290     bytes calldata encodedFunction,
1291     uint256 transactionFee,
1292     uint256 gasPrice,
1293     uint256 gasLimit,
1294     uint256 nonce,
1295     bytes calldata approvalData,
1296     uint256 maxPossibleCharge
1297   )
1298     external
1299     view
1300     returns (uint256, bytes memory) {
1301       (bool accept, bool chargeBefore) = _acceptRelayedCall(from, encodedFunction);
1302       if (accept) {
1303         return  _approveRelayedCall(abi.encode(from, chargeBefore));
1304       } else {
1305         return _rejectRelayedCall(INSUFFICIENT_BALANCE);
1306       }
1307     }
1308 
1309   /**
1310    * @dev Sets the address of StormX's reserve
1311    * @param newReserve the new address of StormX's reserve
1312    * @return success status of the setting
1313    */
1314   function setStormXReserve(address newReserve) public onlyOwner returns (bool) {
1315     require(newReserve != address(0), "Invalid reserve address");
1316     stormXReserve = newReserve;
1317     emit StormXReserveSet(newReserve);
1318     return true;
1319   }
1320 
1321  /**
1322    * @dev Sets the charge fee for GSN calls
1323    * @param newFee the new charge fee
1324    * @return success status of the setting
1325    */
1326   function setChargeFee(uint256 newFee) public onlyOwner returns (bool) {
1327     chargeFee = newFee;
1328     emit ChargeFeeSet(newFee);
1329     return true;
1330   }
1331 
1332   /**
1333    * @dev Checks whether to accept a GSN relayed call
1334    * @param from the user originating the GSN relayed call
1335    * @param encodedFunction the function call to relay, including data
1336    * @return ``accept`` indicates whether to accept the relayed call
1337    *         ``chargeBefore`` indicates whether to charge before executing encoded function
1338    */
1339   function _acceptRelayedCall(
1340     address from,
1341     bytes memory encodedFunction
1342   ) internal view returns (bool accept, bool chargeBefore);
1343 
1344   function _preRelayedCall(bytes memory context) internal returns (bytes32) {
1345     (address user, bool chargeBefore) = abi.decode(context, (address, bool));
1346     // charge the user with specified amount of fee
1347     // if the user is not calling ``convert()``
1348     if (chargeBefore) {
1349       require(
1350         token.transferFrom(user, stormXReserve, chargeFee),
1351         "Charging fails before executing the function"
1352       );
1353     }
1354     return "";
1355   }
1356 
1357   function _postRelayedCall(
1358     bytes memory context,
1359     bool success,
1360     uint256 actualCharge,
1361     bytes32 preRetVal
1362   ) internal {
1363     (address user, bool chargeBefore) = abi.decode(context, (address, bool));
1364     if (!chargeBefore) {
1365       require(
1366         token.transferFrom(user, stormXReserve, chargeFee),
1367         "Charging fails after executing the function"
1368       );
1369     }
1370   }
1371 
1372   /**
1373    * @dev Reads a bytes4 value from a position in a byte array.
1374    * Note: for reference, see source code
1375    * https://etherscan.io/address/0xD216153c06E857cD7f72665E0aF1d7D82172F494#code
1376    * @param b Byte array containing a bytes4 value.
1377    * @param index Index in byte array of bytes4 value.
1378    * @return bytes4 value from byte array.
1379    */
1380   function readBytes4(
1381     bytes memory b,
1382     uint256 index
1383   ) internal
1384     pure
1385     returns (bytes4 result)
1386   {
1387     require(
1388       b.length >= index + 4,
1389       "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
1390     );
1391 
1392     // Arrays are prefixed by a 32 byte length field
1393     index += 32;
1394 
1395     // Read the bytes4 from array memory
1396     assembly {
1397       result := mload(add(b, index))
1398       // Solidity does not require us to clean the trailing bytes.
1399       // We do it anyway
1400       result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
1401     }
1402     return result;
1403   }
1404 
1405   /**
1406    * @dev Reads a bytes32 value from a position in a byte array.
1407    * Note: for reference, see source code
1408    * https://etherscan.io/address/0xD216153c06E857cD7f72665E0aF1d7D82172F494#code
1409    * @param b Byte array containing a bytes32 value.
1410    * @param index Index in byte array of bytes32 value.
1411    * @return bytes32 value from byte array.
1412    */
1413   function readBytes32(
1414     bytes memory b,
1415     uint256 index
1416   )
1417     internal
1418     pure
1419     returns (bytes32 result)
1420   {
1421     require(
1422       b.length >= index + 32,
1423       "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
1424     );
1425 
1426     // Arrays are prefixed by a 256 bit length parameter
1427     index += 32;
1428 
1429     // Read the bytes32 from array memory
1430     assembly {
1431       result := mload(add(b, index))
1432     }
1433     return result;
1434   }
1435   
1436   /**
1437    * @dev Reads a uint256 value from a position in a byte array.
1438    * Note: for reference, see source code
1439    * https://etherscan.io/address/0xD216153c06E857cD7f72665E0aF1d7D82172F494#code
1440    * @param b Byte array containing a uint256 value.
1441    * @param index Index in byte array of uint256 value.
1442    * @return uint256 value from byte array.
1443    */
1444   function readUint256(
1445     bytes memory b,
1446     uint256 index
1447   ) internal
1448     pure
1449     returns (uint256 result)
1450   {
1451     result = uint256(readBytes32(b, index));
1452     return result;
1453   }
1454 
1455  /**
1456   * @dev extract parameter from encoded-function block.
1457   * Note: for reference, see source code
1458   * https://etherscan.io/address/0xD216153c06E857cD7f72665E0aF1d7D82172F494#code
1459   * https://solidity.readthedocs.io/en/develop/abi-spec.html#formal-specification-of-the-encoding
1460   * note that the type of the parameter must be static.
1461   * the return value should be casted to the right type.
1462   * @param msgData encoded calldata
1463   * @param index in byte array of bytes memory
1464   * @return the parameter extracted from call data
1465   */
1466   function getParam(bytes memory msgData, uint index) internal pure returns (uint256) {
1467     return readUint256(msgData, 4 + index * 32);
1468   }
1469 }
1470 
1471 // File: contracts/StormXToken.sol
1472 
1473 pragma solidity 0.5.16;
1474 
1475 
1476 
1477 
1478 
1479 
1480 contract StormXToken is
1481   StormXGSNRecipient,
1482   ERC20,
1483   ERC20Detailed("StormX", "STMX", 18) {
1484 
1485   using SafeMath for uint256;
1486 
1487   bool public transfersEnabled;
1488   mapping(address => bool) public autoStakingDisabled;
1489   bool public initialized = false;
1490   address public swap;
1491   address public rewardRole;
1492 
1493   // Variables for staking feature
1494   mapping(address => uint256) public lockedBalanceOf;
1495 
1496   event TokenLocked(address indexed account, uint256 amount);
1497   event TokenUnlocked(address indexed account, uint256 amount);
1498   event TransfersEnabled(bool newStatus);
1499   event SwapAddressAdded(address swap);
1500   event RewardRoleAssigned(address rewardRole);
1501   event AutoStakingSet(address indexed account, bool status);
1502 
1503   modifier transfersAllowed {
1504     require(transfersEnabled, "Transfers not available");
1505     _;
1506   }
1507 
1508   modifier onlyAuthorized {
1509     require(_msgSender() == owner() || _msgSender() == rewardRole, "Not authorized");
1510     _;
1511   }
1512 
1513   /**
1514    * @param reserve address of the StormX's reserve that receives GSN charge fee
1515    * GSN charged fees and remaining tokens
1516    * after the token migration is closed
1517    */
1518   constructor(address reserve)
1519     // solhint-disable-next-line visibility-modifier-order
1520     StormXGSNRecipient(address(this), reserve) public {
1521     }
1522 
1523   /**
1524    * @param account address of the user this function queries unlocked balance for
1525    * @return the amount of unlocked tokens of the given address
1526    *         i.e. the amount of manipulable tokens of the given address
1527    */
1528   function unlockedBalanceOf(address account) public view returns (uint256) {
1529     return balanceOf(account).sub(lockedBalanceOf[account]);
1530   }
1531 
1532   /**
1533    * @dev Locks specified amount of tokens for the user
1534    *      Locked tokens are not manipulable until being unlocked
1535    *      Locked tokens are still reported as owned by the user
1536    *      when ``balanceOf()`` is called
1537    * @param amount specified amount of tokens to be locked
1538    * @return success status of the locking
1539    */
1540   function lock(uint256 amount) public returns (bool) {
1541     address account = _msgSender();
1542     require(unlockedBalanceOf(account) >= amount, "Not enough unlocked tokens");
1543     lockedBalanceOf[account] = lockedBalanceOf[account].add(amount);
1544     emit TokenLocked(account, amount);
1545     return true;
1546   }
1547 
1548   /**
1549    * @dev Unlocks specified amount of tokens for the user
1550    *      Unlocked tokens are manipulable until being locked
1551    * @param amount specified amount of tokens to be unlocked
1552    * @return success status of the unlocking
1553    */
1554   function unlock(uint256 amount) public returns (bool) {
1555     address account = _msgSender();
1556     require(lockedBalanceOf[account] >= amount, "Not enough locked tokens");
1557     lockedBalanceOf[account] = lockedBalanceOf[account].sub(amount);
1558     emit TokenUnlocked(account, amount);
1559     return true;
1560   }
1561 
1562   /**
1563    * @dev The only difference from standard ERC20 ``transferFrom()`` is that
1564    *     it only succeeds if the sender has enough unlocked tokens
1565    *     Note: this function is also used by every StormXGSNRecipient
1566    *           when charging.
1567    * @param sender address of the sender
1568    * @param recipient address of the recipient
1569    * @param amount specified amount of tokens to be transferred
1570    * @return success status of the transferring
1571    */
1572   function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1573     require(unlockedBalanceOf(sender) >= amount, "Not enough unlocked token balance of sender");
1574     // if the msg.sender is charging ``sender`` for a GSN fee
1575     // allowance does not apply
1576     // so that no user approval is required for GSN calls
1577     if (_msgSender() == address(this) || _msgSender() == swap) {
1578       _transfer(sender, recipient, amount);
1579       return true;
1580     } else {
1581       return super.transferFrom(sender, recipient, amount);
1582     }
1583   }
1584 
1585   /**
1586    * @dev The only difference from standard ERC20 ``transfer()`` is that
1587    *     it only succeeds if the user has enough unlocked tokens
1588    * @param recipient address of the recipient
1589    * @param amount specified amount of tokens to be transferred
1590    * @return success status of the transferring
1591    */
1592   function transfer(address recipient, uint256 amount) public returns (bool) {
1593     require(unlockedBalanceOf(_msgSender()) >= amount, "Not enough unlocked token balance");
1594     return super.transfer(recipient, amount);
1595   }
1596 
1597   /**
1598    * @dev Transfers tokens in batch
1599    * @param recipients an array of recipient addresses
1600    * @param values an array of specified amount of tokens to be transferred
1601    * @return success status of the batch transferring
1602    */
1603   function transfers(
1604     address[] memory recipients,
1605     uint256[] memory values
1606   ) public transfersAllowed returns (bool) {
1607     require(recipients.length == values.length, "Input lengths do not match");
1608 
1609     for (uint256 i = 0; i < recipients.length; i++) {
1610       transfer(recipients[i], values[i]);
1611     }
1612     return true;
1613   }
1614 
1615   /**
1616    * @dev Enables the method ``transfers()`` if ``enable=true``,
1617    * and disables ``transfers()`` otherwise
1618    * @param enable the expected new availability of the method ``transfers()``
1619    */
1620   function enableTransfers(bool enable) public onlyOwner returns (bool) {
1621     transfersEnabled = enable;
1622     emit TransfersEnabled(enable);
1623     return true;
1624   }
1625 
1626   function mint(address account, uint256 amount) public {
1627     require(initialized, "The contract is not initialized yet");
1628     require(_msgSender() == swap, "not authorized to mint");
1629     _mint(account, amount);
1630   }
1631 
1632   /**
1633    * @dev Initializes this contract
1634    *      Sets address ``swap`` as the only valid minter for this token
1635    *      Note: must be called before token migration opens in ``Swap.sol``
1636    * @param _swap address of the deployed contract ``Swap.sol``
1637    */
1638   function initialize(address _swap) public onlyOwner {
1639     require(!initialized, "cannot initialize twice");
1640     require(_swap != address(0), "invalid swap address");
1641     swap = _swap;
1642     transfersEnabled = true;
1643     emit TransfersEnabled(true);
1644     initialized = true;
1645     emit SwapAddressAdded(_swap);
1646   }
1647 
1648   /**
1649    * @dev Assigns `rewardRole` to the specified address
1650    * @param account address to be assigned as the `rewardRole`
1651    */
1652   function assignRewardRole(address account) public onlyOwner {
1653     rewardRole = account;
1654     emit RewardRoleAssigned(account);
1655   }
1656 
1657   /**
1658    * @dev Transfers tokens to users as rewards
1659    * @param recipient address that receives the rewarded tokens
1660    * @param amount amount of rewarded tokens
1661    */
1662   function reward(address recipient, uint256 amount) public onlyAuthorized {
1663     require(recipient != address(0), "Invalid recipient address provided");
1664 
1665     require(transfer(recipient, amount), "Transfer fails when rewarding a user");
1666     // If `autoStakingDisabled[user] == false`,
1667     // auto staking is enabled for current user
1668     if (!autoStakingDisabled[recipient]) {
1669       lockedBalanceOf[recipient] = lockedBalanceOf[recipient].add(amount);
1670       emit TokenLocked(recipient, amount);
1671     }
1672   }
1673 
1674   /**
1675    * @dev Rewards users in batch
1676    * @param recipients an array of recipient address
1677    * @param values an array of specified amount of tokens to be rewarded
1678    */
1679   function rewards(address[] memory recipients, uint256[] memory values) public onlyAuthorized {
1680     require(recipients.length == values.length, "Input lengths do not match");
1681 
1682     for (uint256 i = 0; i < recipients.length; i++) {
1683       reward(recipients[i], values[i]);
1684     }
1685   }
1686 
1687   /**
1688    * @dev Sets auto-staking feature status for users
1689    * If `enabled = true`, rewarded tokens will be automatically staked for the message sender
1690    * Else, rewarded tokens will not be automatically staked for the message sender.
1691    * @param enabled expected status of the user's auto-staking feature status
1692    */
1693   function setAutoStaking(bool enabled) public {
1694     // If `enabled == false`, set `autoStakingDisabled[user] = true`
1695     autoStakingDisabled[_msgSender()] = !enabled;
1696     emit AutoStakingSet(_msgSender(), enabled);
1697   }
1698 
1699   /**
1700    * @dev Checks whether to accept a GSN relayed call
1701    * @param from the user originating the GSN relayed call
1702    * @param encodedFunction the function call to relay, including data
1703    * @return ``accept`` indicates whether to accept the relayed call
1704    *         ``chargeBefore`` indicates whether to charge before executing encoded function
1705    */
1706   function _acceptRelayedCall(
1707     address from,
1708     bytes memory encodedFunction
1709   ) internal view returns (bool accept, bool chargeBefore) {
1710     bool chargeBefore = true;
1711     uint256 unlockedBalance = unlockedBalanceOf(from);
1712     if (unlockedBalance < chargeFee) {
1713       // charge users after executing the encoded function
1714       chargeBefore = false;
1715       bytes4 selector = readBytes4(encodedFunction, 0);
1716       if (selector == bytes4(keccak256("unlock(uint256)"))) {
1717         // unlocked token balance for the user if transaction succeeds
1718         uint256 amount = uint256(getParam(encodedFunction, 0)).add(unlockedBalance);
1719         return (amount >= chargeFee, chargeBefore);
1720       } else if (selector == bytes4(keccak256("transferFrom(address,address,uint256)"))) {
1721         address sender = address(getParam(encodedFunction, 0));
1722         address recipient = address(getParam(encodedFunction, 1));
1723         uint256 amount = getParam(encodedFunction, 2);
1724 
1725         bool accept = recipient == from &&
1726           // no real effect of `transferfrom()` if `sender == recipient`
1727           sender != recipient &&
1728           // `from` can have enough unlocked token balance after the transaction
1729           amount.add(unlockedBalance) >= chargeFee &&
1730           // check `transferFrom()` can be executed successfully
1731           unlockedBalanceOf(sender) >= amount &&
1732           allowance(sender, from) >= amount;
1733         return (accept, chargeBefore);
1734       } else {
1735         // if rejects the call, the value of chargeBefore does not matter
1736         return (false, chargeBefore);
1737       }
1738     } else {
1739       return (true, chargeBefore);
1740     }
1741   }
1742 }