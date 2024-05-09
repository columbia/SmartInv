1 pragma solidity ^0.5.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 pragma solidity ^0.5.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor () internal {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(isOwner(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Returns true if the caller is the current owner.
72      */
73     function isOwner() public view returns (bool) {
74         return _msgSender() == _owner;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public onlyOwner {
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      */
100     function _transferOwnership(address newOwner) internal {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         emit OwnershipTransferred(_owner, newOwner);
103         _owner = newOwner;
104     }
105 }
106 
107 pragma solidity ^0.5.0;
108 
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
111  * the optional functions; to access them see {ERC20Detailed}.
112  */
113 interface IERC20 {
114     /**
115      * @dev Returns the amount of tokens in existence.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     /**
120      * @dev Returns the amount of tokens owned by `account`.
121      */
122     function balanceOf(address account) external view returns (uint256);
123 
124     /**
125      * @dev Moves `amount` tokens from the caller's account to `recipient`.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transfer(address recipient, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Returns the remaining number of tokens that `spender` will be
135      * allowed to spend on behalf of `owner` through {transferFrom}. This is
136      * zero by default.
137      *
138      * This value changes when {approve} or {transferFrom} are called.
139      */
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * IMPORTANT: Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an {Approval} event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `sender` to `recipient` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
171      * another (`to`).
172      *
173      * Note that `value` may be zero.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     /**
178      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
179      * a call to {approve}. `value` is the new allowance.
180      */
181     event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 
185 pragma solidity ^0.5.0;
186 
187 /**
188  * @dev Wrappers over Solidity's arithmetic operations with added overflow
189  * checks.
190  *
191  * Arithmetic operations in Solidity wrap on overflow. This can easily result
192  * in bugs, because programmers usually assume that an overflow raises an
193  * error, which is the standard behavior in high level programming languages.
194  * `SafeMath` restores this intuition by reverting the transaction when an
195  * operation overflows.
196  *
197  * Using this library instead of the unchecked operations eliminates an entire
198  * class of bugs, so it's recommended to use it always.
199  */
200 library SafeMath {
201     /**
202      * @dev Returns the addition of two unsigned integers, reverting on
203      * overflow.
204      *
205      * Counterpart to Solidity's `+` operator.
206      *
207      * Requirements:
208      * - Addition cannot overflow.
209      */
210     function add(uint256 a, uint256 b) internal pure returns (uint256) {
211         uint256 c = a + b;
212         require(c >= a, "SafeMath: addition overflow");
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the subtraction of two unsigned integers, reverting on
219      * overflow (when the result is negative).
220      *
221      * Counterpart to Solidity's `-` operator.
222      *
223      * Requirements:
224      * - Subtraction cannot overflow.
225      */
226     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
227         return sub(a, b, "SafeMath: subtraction overflow");
228     }
229 
230     /**
231      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
232      * overflow (when the result is negative).
233      *
234      * Counterpart to Solidity's `-` operator.
235      *
236      * Requirements:
237      * - Subtraction cannot overflow.
238      *
239      * _Available since v2.4.0._
240      */
241     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
242         require(b <= a, errorMessage);
243         uint256 c = a - b;
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the multiplication of two unsigned integers, reverting on
250      * overflow.
251      *
252      * Counterpart to Solidity's `*` operator.
253      *
254      * Requirements:
255      * - Multiplication cannot overflow.
256      */
257     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
258         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
259         // benefit is lost if 'b' is also tested.
260         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
261         if (a == 0) {
262             return 0;
263         }
264 
265         uint256 c = a * b;
266         require(c / a == b, "SafeMath: multiplication overflow");
267 
268         return c;
269     }
270 
271     /**
272      * @dev Returns the integer division of two unsigned integers. Reverts on
273      * division by zero. The result is rounded towards zero.
274      *
275      * Counterpart to Solidity's `/` operator. Note: this function uses a
276      * `revert` opcode (which leaves remaining gas untouched) while Solidity
277      * uses an invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      * - The divisor cannot be zero.
281      */
282     function div(uint256 a, uint256 b) internal pure returns (uint256) {
283         return div(a, b, "SafeMath: division by zero");
284     }
285 
286     /**
287      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
288      * division by zero. The result is rounded towards zero.
289      *
290      * Counterpart to Solidity's `/` operator. Note: this function uses a
291      * `revert` opcode (which leaves remaining gas untouched) while Solidity
292      * uses an invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      * - The divisor cannot be zero.
296      *
297      * _Available since v2.4.0._
298      */
299     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         // Solidity only automatically asserts when dividing by 0
301         require(b > 0, errorMessage);
302         uint256 c = a / b;
303         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
304 
305         return c;
306     }
307 
308     /**
309      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
310      * Reverts when dividing by zero.
311      *
312      * Counterpart to Solidity's `%` operator. This function uses a `revert`
313      * opcode (which leaves remaining gas untouched) while Solidity uses an
314      * invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
320         return mod(a, b, "SafeMath: modulo by zero");
321     }
322 
323     /**
324      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
325      * Reverts with custom message when dividing by zero.
326      *
327      * Counterpart to Solidity's `%` operator. This function uses a `revert`
328      * opcode (which leaves remaining gas untouched) while Solidity uses an
329      * invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      * - The divisor cannot be zero.
333      *
334      * _Available since v2.4.0._
335      */
336     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
337         require(b != 0, errorMessage);
338         return a % b;
339     }
340 }
341 
342 
343 pragma solidity ^0.5.0;
344 
345 /**
346  * @dev Implementation of the {IERC20} interface.
347  *
348  * This implementation is agnostic to the way tokens are created. This means
349  * that a supply mechanism has to be added in a derived contract using {_mint}.
350  * For a generic mechanism see {ERC20Mintable}.
351  *
352  * TIP: For a detailed writeup see our guide
353  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
354  * to implement supply mechanisms].
355  *
356  * We have followed general OpenZeppelin guidelines: functions revert instead
357  * of returning `false` on failure. This behavior is nonetheless conventional
358  * and does not conflict with the expectations of ERC20 applications.
359  *
360  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
361  * This allows applications to reconstruct the allowance for all accounts just
362  * by listening to said events. Other implementations of the EIP may not emit
363  * these events, as it isn't required by the specification.
364  *
365  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
366  * functions have been added to mitigate the well-known issues around setting
367  * allowances. See {IERC20-approve}.
368  */
369 contract ERC20 is Context, IERC20 {
370     using SafeMath for uint256;
371 
372     mapping (address => uint256) private _balances;
373 
374     mapping (address => mapping (address => uint256)) private _allowances;
375 
376     uint256 private _totalSupply;
377 
378     /**
379      * @dev See {IERC20-totalSupply}.
380      */
381     function totalSupply() public view returns (uint256) {
382         return _totalSupply;
383     }
384 
385     /**
386      * @dev See {IERC20-balanceOf}.
387      */
388     function balanceOf(address account) public view returns (uint256) {
389         return _balances[account];
390     }
391 
392     /**
393      * @dev See {IERC20-transfer}.
394      *
395      * Requirements:
396      *
397      * - `recipient` cannot be the zero address.
398      * - the caller must have a balance of at least `amount`.
399      */
400     function transfer(address recipient, uint256 amount) public returns (bool) {
401         _transfer(_msgSender(), recipient, amount);
402         return true;
403     }
404 
405     /**
406      * @dev See {IERC20-allowance}.
407      */
408     function allowance(address owner, address spender) public view returns (uint256) {
409         return _allowances[owner][spender];
410     }
411 
412     /**
413      * @dev See {IERC20-approve}.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      */
419     function approve(address spender, uint256 amount) public returns (bool) {
420         _approve(_msgSender(), spender, amount);
421         return true;
422     }
423 
424     /**
425      * @dev See {IERC20-transferFrom}.
426      *
427      * Emits an {Approval} event indicating the updated allowance. This is not
428      * required by the EIP. See the note at the beginning of {ERC20};
429      *
430      * Requirements:
431      * - `sender` and `recipient` cannot be the zero address.
432      * - `sender` must have a balance of at least `amount`.
433      * - the caller must have allowance for `sender`'s tokens of at least
434      * `amount`.
435      */
436     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
437         _transfer(sender, recipient, amount);
438         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
439         return true;
440     }
441 
442     /**
443      * @dev Atomically increases the allowance granted to `spender` by the caller.
444      *
445      * This is an alternative to {approve} that can be used as a mitigation for
446      * problems described in {IERC20-approve}.
447      *
448      * Emits an {Approval} event indicating the updated allowance.
449      *
450      * Requirements:
451      *
452      * - `spender` cannot be the zero address.
453      */
454     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
455         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
456         return true;
457     }
458 
459     /**
460      * @dev Atomically decreases the allowance granted to `spender` by the caller.
461      *
462      * This is an alternative to {approve} that can be used as a mitigation for
463      * problems described in {IERC20-approve}.
464      *
465      * Emits an {Approval} event indicating the updated allowance.
466      *
467      * Requirements:
468      *
469      * - `spender` cannot be the zero address.
470      * - `spender` must have allowance for the caller of at least
471      * `subtractedValue`.
472      */
473     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
474         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
475         return true;
476     }
477 
478     /**
479      * @dev Moves tokens `amount` from `sender` to `recipient`.
480      *
481      * This is internal function is equivalent to {transfer}, and can be used to
482      * e.g. implement automatic token fees, slashing mechanisms, etc.
483      *
484      * Emits a {Transfer} event.
485      *
486      * Requirements:
487      *
488      * - `sender` cannot be the zero address.
489      * - `recipient` cannot be the zero address.
490      * - `sender` must have a balance of at least `amount`.
491      */
492     function _transfer(address sender, address recipient, uint256 amount) internal {
493         require(sender != address(0), "ERC20: transfer from the zero address");
494         require(recipient != address(0), "ERC20: transfer to the zero address");
495 
496         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
497         _balances[recipient] = _balances[recipient].add(amount);
498         emit Transfer(sender, recipient, amount);
499     }
500 
501     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
502      * the total supply.
503      *
504      * Emits a {Transfer} event with `from` set to the zero address.
505      *
506      * Requirements
507      *
508      * - `to` cannot be the zero address.
509      */
510     function _mint(address account, uint256 amount) internal {
511         require(account != address(0), "ERC20: mint to the zero address");
512 
513         _totalSupply = _totalSupply.add(amount);
514         _balances[account] = _balances[account].add(amount);
515         emit Transfer(address(0), account, amount);
516     }
517 
518     /**
519      * @dev Destroys `amount` tokens from `account`, reducing the
520      * total supply.
521      *
522      * Emits a {Transfer} event with `to` set to the zero address.
523      *
524      * Requirements
525      *
526      * - `account` cannot be the zero address.
527      * - `account` must have at least `amount` tokens.
528      */
529     function _burn(address account, uint256 amount) internal {
530         require(account != address(0), "ERC20: burn from the zero address");
531 
532         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
533         _totalSupply = _totalSupply.sub(amount);
534         emit Transfer(account, address(0), amount);
535     }
536 
537     /**
538      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
539      *
540      * This is internal function is equivalent to `approve`, and can be used to
541      * e.g. set automatic allowances for certain subsystems, etc.
542      *
543      * Emits an {Approval} event.
544      *
545      * Requirements:
546      *
547      * - `owner` cannot be the zero address.
548      * - `spender` cannot be the zero address.
549      */
550     function _approve(address owner, address spender, uint256 amount) internal {
551         require(owner != address(0), "ERC20: approve from the zero address");
552         require(spender != address(0), "ERC20: approve to the zero address");
553 
554         _allowances[owner][spender] = amount;
555         emit Approval(owner, spender, amount);
556     }
557 
558     /**
559      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
560      * from the caller's allowance.
561      *
562      * See {_burn} and {_approve}.
563      */
564     function _burnFrom(address account, uint256 amount) internal {
565         _burn(account, amount);
566         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
567     }
568 }
569 
570 
571 pragma solidity ^0.5.0;
572 
573 /**
574  * @dev Base interface for a contract that will be called via the GSN from {IRelayHub}.
575  *
576  * TIP: You don't need to write an implementation yourself! Inherit from {GSNRecipient} instead.
577  */
578 interface IRelayRecipient {
579     /**
580      * @dev Returns the address of the {IRelayHub} instance this recipient interacts with.
581      */
582     function getHubAddr() external view returns (address);
583 
584     /**
585      * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the
586      * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).
587      *
588      * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call
589      * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,
590      * and the transaction executed with a gas price of at least `gasPrice`. `relay`'s fee is `transactionFee`, and the
591      * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for
592      * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold a signature
593      * over all or some of the previous values.
594      *
595      * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,
596      * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.
597      *
598      * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered
599      * rejected. A regular revert will also trigger a rejection.
600      */
601     function acceptRelayedCall(
602         address relay,
603         address from,
604         bytes calldata encodedFunction,
605         uint256 transactionFee,
606         uint256 gasPrice,
607         uint256 gasLimit,
608         uint256 nonce,
609         bytes calldata approvalData,
610         uint256 maxPossibleCharge
611     )
612         external
613         view
614         returns (uint256, bytes memory);
615 
616     /**
617      * @dev Called by {IRelayHub} on approved relay call requests, before the relayed call is executed. This allows to e.g.
618      * pre-charge the sender of the transaction.
619      *
620      * `context` is the second value returned in the tuple by {acceptRelayedCall}.
621      *
622      * Returns a value to be passed to {postRelayedCall}.
623      *
624      * {preRelayedCall} is called with 100k gas: if it runs out during exection or otherwise reverts, the relayed call
625      * will not be executed, but the recipient will still be charged for the transaction's cost.
626      */
627     function preRelayedCall(bytes calldata context) external returns (bytes32);
628 
629     /**
630      * @dev Called by {IRelayHub} on approved relay call requests, after the relayed call is executed. This allows to e.g.
631      * charge the user for the relayed call costs, return any overcharges from {preRelayedCall}, or perform
632      * contract-specific bookkeeping.
633      *
634      * `context` is the second value returned in the tuple by {acceptRelayedCall}. `success` is the execution status of
635      * the relayed call. `actualCharge` is an estimate of how much the recipient will be charged for the transaction,
636      * not including any gas used by {postRelayedCall} itself. `preRetVal` is {preRelayedCall}'s return value.
637      *
638      *
639      * {postRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call
640      * and the call to {preRelayedCall} will be reverted retroactively, but the recipient will still be charged for the
641      * transaction's cost.
642      */
643     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
644 }
645 
646 pragma solidity ^0.5.0;
647 
648 /**
649  * @dev Interface for `RelayHub`, the core contract of the GSN. Users should not need to interact with this contract
650  * directly.
651  *
652  * See the https://github.com/OpenZeppelin/openzeppelin-gsn-helpers[OpenZeppelin GSN helpers] for more information on
653  * how to deploy an instance of `RelayHub` on your local test network.
654  */
655 interface IRelayHub {
656     // Relay management
657 
658     /**
659      * @dev Adds stake to a relay and sets its `unstakeDelay`. If the relay does not exist, it is created, and the caller
660      * of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
661      * cannot be its own owner.
662      *
663      * All Ether in this function call will be added to the relay's stake.
664      * Its unstake delay will be assigned to `unstakeDelay`, but the new value must be greater or equal to the current one.
665      *
666      * Emits a {Staked} event.
667      */
668     function stake(address relayaddr, uint256 unstakeDelay) external payable;
669 
670     /**
671      * @dev Emitted when a relay's stake or unstakeDelay are increased
672      */
673     event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);
674 
675     /**
676      * @dev Registers the caller as a relay.
677      * The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
678      *
679      * This function can be called multiple times, emitting new {RelayAdded} events. Note that the received
680      * `transactionFee` is not enforced by {relayCall}.
681      *
682      * Emits a {RelayAdded} event.
683      */
684     function registerRelay(uint256 transactionFee, string calldata url) external;
685 
686     /**
687      * @dev Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out
688      * {RelayRemoved} events) lets a client discover the list of available relays.
689      */
690     event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);
691 
692     /**
693      * @dev Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed.
694      *
695      * Can only be called by the owner of the relay. After the relay's `unstakeDelay` has elapsed, {unstake} will be
696      * callable.
697      *
698      * Emits a {RelayRemoved} event.
699      */
700     function removeRelayByOwner(address relay) external;
701 
702     /**
703      * @dev Emitted when a relay is removed (deregistered). `unstakeTime` is the time when unstake will be callable.
704      */
705     event RelayRemoved(address indexed relay, uint256 unstakeTime);
706 
707     /** Deletes the relay from the system, and gives back its stake to the owner.
708      *
709      * Can only be called by the relay owner, after `unstakeDelay` has elapsed since {removeRelayByOwner} was called.
710      *
711      * Emits an {Unstaked} event.
712      */
713     function unstake(address relay) external;
714 
715     /**
716      * @dev Emitted when a relay is unstaked for, including the returned stake.
717      */
718     event Unstaked(address indexed relay, uint256 stake);
719 
720     // States a relay can be in
721     enum RelayState {
722         Unknown, // The relay is unknown to the system: it has never been staked for
723         Staked, // The relay has been staked for, but it is not yet active
724         Registered, // The relay has registered itself, and is active (can relay calls)
725         Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
726     }
727 
728     /**
729      * @dev Returns a relay's status. Note that relays can be deleted when unstaked or penalized, causing this function
730      * to return an empty entry.
731      */
732     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);
733 
734     // Balance management
735 
736     /**
737      * @dev Deposits Ether for a contract, so that it can receive (and pay for) relayed transactions.
738      *
739      * Unused balance can only be withdrawn by the contract itself, by calling {withdraw}.
740      *
741      * Emits a {Deposited} event.
742      */
743     function depositFor(address target) external payable;
744 
745     /**
746      * @dev Emitted when {depositFor} is called, including the amount and account that was funded.
747      */
748     event Deposited(address indexed recipient, address indexed from, uint256 amount);
749 
750     /**
751      * @dev Returns an account's deposits. These can be either a contracts's funds, or a relay owner's revenue.
752      */
753     function balanceOf(address target) external view returns (uint256);
754 
755     /**
756      * Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
757      * contracts can use it to reduce their funding.
758      *
759      * Emits a {Withdrawn} event.
760      */
761     function withdraw(uint256 amount, address payable dest) external;
762 
763     /**
764      * @dev Emitted when an account withdraws funds from `RelayHub`.
765      */
766     event Withdrawn(address indexed account, address indexed dest, uint256 amount);
767 
768     // Relaying
769 
770     /**
771      * @dev Checks if the `RelayHub` will accept a relayed operation.
772      * Multiple things must be true for this to happen:
773      *  - all arguments must be signed for by the sender (`from`)
774      *  - the sender's nonce must be the current one
775      *  - the recipient must accept this transaction (via {acceptRelayedCall})
776      *
777      * Returns a `PreconditionCheck` value (`OK` when the transaction can be relayed), or a recipient-specific error
778      * code if it returns one in {acceptRelayedCall}.
779      */
780     function canRelay(
781         address relay,
782         address from,
783         address to,
784         bytes calldata encodedFunction,
785         uint256 transactionFee,
786         uint256 gasPrice,
787         uint256 gasLimit,
788         uint256 nonce,
789         bytes calldata signature,
790         bytes calldata approvalData
791     ) external view returns (uint256 status, bytes memory recipientContext);
792 
793     // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
794     enum PreconditionCheck {
795         OK,                         // All checks passed, the call can be relayed
796         WrongSignature,             // The transaction to relay is not signed by requested sender
797         WrongNonce,                 // The provided nonce has already been used by the sender
798         AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
799         InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
800     }
801 
802     /**
803      * @dev Relays a transaction.
804      *
805      * For this to succeed, multiple conditions must be met:
806      *  - {canRelay} must `return PreconditionCheck.OK`
807      *  - the sender must be a registered relay
808      *  - the transaction's gas price must be larger or equal to the one that was requested by the sender
809      *  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
810      * recipient) use all gas available to them
811      *  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
812      * spent)
813      *
814      * If all conditions are met, the call will be relayed and the recipient charged. {preRelayedCall}, the encoded
815      * function and {postRelayedCall} will be called in that order.
816      *
817      * Parameters:
818      *  - `from`: the client originating the request
819      *  - `to`: the target {IRelayRecipient} contract
820      *  - `encodedFunction`: the function call to relay, including data
821      *  - `transactionFee`: fee (%) the relay takes over actual gas cost
822      *  - `gasPrice`: gas price the client is willing to pay
823      *  - `gasLimit`: gas to forward when calling the encoded function
824      *  - `nonce`: client's nonce
825      *  - `signature`: client's signature over all previous params, plus the relay and RelayHub addresses
826      *  - `approvalData`: dapp-specific data forwared to {acceptRelayedCall}. This value is *not* verified by the
827      * `RelayHub`, but it still can be used for e.g. a signature.
828      *
829      * Emits a {TransactionRelayed} event.
830      */
831     function relayCall(
832         address from,
833         address to,
834         bytes calldata encodedFunction,
835         uint256 transactionFee,
836         uint256 gasPrice,
837         uint256 gasLimit,
838         uint256 nonce,
839         bytes calldata signature,
840         bytes calldata approvalData
841     ) external;
842 
843     /**
844      * @dev Emitted when an attempt to relay a call failed.
845      *
846      * This can happen due to incorrect {relayCall} arguments, or the recipient not accepting the relayed call. The
847      * actual relayed call was not executed, and the recipient not charged.
848      *
849      * The `reason` parameter contains an error code: values 1-10 correspond to `PreconditionCheck` entries, and values
850      * over 10 are custom recipient error codes returned from {acceptRelayedCall}.
851      */
852     event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);
853 
854     /**
855      * @dev Emitted when a transaction is relayed. 
856      * Useful when monitoring a relay's operation and relayed calls to a contract
857      *
858      * Note that the actual encoded function might be reverted: this is indicated in the `status` parameter.
859      *
860      * `charge` is the Ether value deducted from the recipient's balance, paid to the relay's owner.
861      */
862     event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);
863 
864     // Reason error codes for the TransactionRelayed event
865     enum RelayCallStatus {
866         OK,                      // The transaction was successfully relayed and execution successful - never included in the event
867         RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
868         PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
869         PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
870         RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
871     }
872 
873     /**
874      * @dev Returns how much gas should be forwarded to a call to {relayCall}, in order to relay a transaction that will
875      * spend up to `relayedCallStipend` gas.
876      */
877     function requiredGas(uint256 relayedCallStipend) external view returns (uint256);
878 
879     /**
880      * @dev Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
881      */
882     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) external view returns (uint256);
883 
884      // Relay penalization. 
885      // Any account can penalize relays, removing them from the system immediately, and rewarding the
886     // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
887     // still loses half of its stake.
888 
889     /**
890      * @dev Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
891      * different data (gas price, gas limit, etc. may be different).
892      *
893      * The (unsigned) transaction data and signature for both transactions must be provided.
894      */
895     function penalizeRepeatedNonce(bytes calldata unsignedTx1, bytes calldata signature1, bytes calldata unsignedTx2, bytes calldata signature2) external;
896 
897     /**
898      * @dev Penalize a relay that sent a transaction that didn't target `RelayHub`'s {registerRelay} or {relayCall}.
899      */
900     function penalizeIllegalTransaction(bytes calldata unsignedTx, bytes calldata signature) external;
901 
902     /**
903      * @dev Emitted when a relay is penalized.
904      */
905     event Penalized(address indexed relay, address sender, uint256 amount);
906 
907     /**
908      * @dev Returns an account's nonce in `RelayHub`.
909      */
910     function getNonce(address from) external view returns (uint256);
911 }
912 
913 
914 pragma solidity ^0.5.0;
915 
916 /**
917  * @dev Base GSN recipient contract: includes the {IRelayRecipient} interface
918  * and enables GSN support on all contracts in the inheritance tree.
919  *
920  * TIP: This contract is abstract. The functions {IRelayRecipient-acceptRelayedCall},
921  *  {_preRelayedCall}, and {_postRelayedCall} are not implemented and must be
922  * provided by derived contracts. See the
923  * xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategies] for more
924  * information on how to use the pre-built {GSNRecipientSignature} and
925  * {GSNRecipientERC20Fee}, or how to write your own.
926  */
927 contract GSNRecipient is IRelayRecipient, Context {
928     // Default RelayHub address, deployed on mainnet and all testnets at the same address
929     address private _relayHub = 0xD216153c06E857cD7f72665E0aF1d7D82172F494;
930 
931     uint256 constant private RELAYED_CALL_ACCEPTED = 0;
932     uint256 constant private RELAYED_CALL_REJECTED = 11;
933 
934     // How much gas is forwarded to postRelayedCall
935     uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;
936 
937     /**
938      * @dev Emitted when a contract changes its {IRelayHub} contract to a new one.
939      */
940     event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);
941 
942     /**
943      * @dev Returns the address of the {IRelayHub} contract for this recipient.
944      */
945     function getHubAddr() public view returns (address) {
946         return _relayHub;
947     }
948 
949     /**
950      * @dev Switches to a new {IRelayHub} instance. This method is added for future-proofing: there's no reason to not
951      * use the default instance.
952      *
953      * IMPORTANT: After upgrading, the {GSNRecipient} will no longer be able to receive relayed calls from the old
954      * {IRelayHub} instance. Additionally, all funds should be previously withdrawn via {_withdrawDeposits}.
955      */
956     function _upgradeRelayHub(address newRelayHub) internal {
957         address currentRelayHub = _relayHub;
958         require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
959         require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");
960 
961         emit RelayHubChanged(currentRelayHub, newRelayHub);
962 
963         _relayHub = newRelayHub;
964     }
965 
966     /**
967      * @dev Returns the version string of the {IRelayHub} for which this recipient implementation was built. If
968      * {_upgradeRelayHub} is used, the new {IRelayHub} instance should be compatible with this version.
969      */
970     // This function is view for future-proofing, it may require reading from
971     // storage in the future.
972     function relayHubVersion() public view returns (string memory) {
973         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
974         return "1.0.0";
975     }
976 
977     /**
978      * @dev Withdraws the recipient's deposits in `RelayHub`.
979      *
980      * Derived contracts should expose this in an external interface with proper access control.
981      */
982     function _withdrawDeposits(uint256 amount, address payable payee) internal {
983         IRelayHub(_relayHub).withdraw(amount, payee);
984     }
985 
986     // Overrides for Context's functions: when called from RelayHub, sender and
987     // data require some pre-processing: the actual sender is stored at the end
988     // of the call data, which in turns means it needs to be removed from it
989     // when handling said data.
990 
991     /**
992      * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
993      * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
994      *
995      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
996      */
997     function _msgSender() internal view returns (address payable) {
998         if (msg.sender != _relayHub) {
999             return msg.sender;
1000         } else {
1001             return _getRelayedCallSender();
1002         }
1003     }
1004 
1005     /**
1006      * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
1007      * and a reduced version for GSN relayed calls (where msg.data contains additional information).
1008      *
1009      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
1010      */
1011     function _msgData() internal view returns (bytes memory) {
1012         if (msg.sender != _relayHub) {
1013             return msg.data;
1014         } else {
1015             return _getRelayedCallData();
1016         }
1017     }
1018 
1019     // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the
1020     // internal hook.
1021 
1022     /**
1023      * @dev See `IRelayRecipient.preRelayedCall`.
1024      *
1025      * This function should not be overriden directly, use `_preRelayedCall` instead.
1026      *
1027      * * Requirements:
1028      *
1029      * - the caller must be the `RelayHub` contract.
1030      */
1031     function preRelayedCall(bytes calldata context) external returns (bytes32) {
1032         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1033         return _preRelayedCall(context);
1034     }
1035 
1036     /**
1037      * @dev See `IRelayRecipient.preRelayedCall`.
1038      *
1039      * Called by `GSNRecipient.preRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1040      * must implement this function with any relayed-call preprocessing they may wish to do.
1041      *
1042      */
1043     function _preRelayedCall(bytes memory context) internal returns (bytes32);
1044 
1045     /**
1046      * @dev See `IRelayRecipient.postRelayedCall`.
1047      *
1048      * This function should not be overriden directly, use `_postRelayedCall` instead.
1049      *
1050      * * Requirements:
1051      *
1052      * - the caller must be the `RelayHub` contract.
1053      */
1054     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {
1055         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1056         _postRelayedCall(context, success, actualCharge, preRetVal);
1057     }
1058 
1059     /**
1060      * @dev See `IRelayRecipient.postRelayedCall`.
1061      *
1062      * Called by `GSNRecipient.postRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1063      * must implement this function with any relayed-call postprocessing they may wish to do.
1064      *
1065      */
1066     function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal;
1067 
1068     /**
1069      * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract
1070      * will be charged a fee by RelayHub
1071      */
1072     function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
1073         return _approveRelayedCall("");
1074     }
1075 
1076     /**
1077      * @dev See `GSNRecipient._approveRelayedCall`.
1078      *
1079      * This overload forwards `context` to _preRelayedCall and _postRelayedCall.
1080      */
1081     function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
1082         return (RELAYED_CALL_ACCEPTED, context);
1083     }
1084 
1085     /**
1086      * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.
1087      */
1088     function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
1089         return (RELAYED_CALL_REJECTED + errorCode, "");
1090     }
1091 
1092     /*
1093      * @dev Calculates how much RelayHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's
1094      * `serviceFee`.
1095      */
1096     function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
1097         // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
1098         // charged for 1.4 times the spent amount.
1099         return (gas * gasPrice * (100 + serviceFee)) / 100;
1100     }
1101 
1102     function _getRelayedCallSender() private pure returns (address payable result) {
1103         // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
1104         // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
1105         // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
1106         // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
1107         // bytes. This can always be done due to the 32-byte prefix.
1108 
1109         // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
1110         // easiest/most-efficient way to perform this operation.
1111 
1112         // These fields are not accessible from assembly
1113         bytes memory array = msg.data;
1114         uint256 index = msg.data.length;
1115 
1116         // solhint-disable-next-line no-inline-assembly
1117         assembly {
1118             // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1119             result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
1120         }
1121         return result;
1122     }
1123 
1124     function _getRelayedCallData() private pure returns (bytes memory) {
1125         // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
1126         // we must strip the last 20 bytes (length of an address type) from it.
1127 
1128         uint256 actualDataLength = msg.data.length - 20;
1129         bytes memory actualData = new bytes(actualDataLength);
1130 
1131         for (uint256 i = 0; i < actualDataLength; ++i) {
1132             actualData[i] = msg.data[i];
1133         }
1134 
1135         return actualData;
1136     }
1137 }
1138 
1139 
1140 pragma solidity = 0.5.16;
1141 
1142 contract SimpleSale is Ownable, GSNRecipient {
1143     using SafeMath for uint256;
1144 
1145     enum ErrorCodes {
1146         RESTRICTED_METHOD,
1147         INSUFFICIENT_BALANCE
1148     }
1149 
1150     struct Price {
1151         uint256 ethPrice;
1152         uint256 erc20Price;
1153     }
1154 
1155     event Purchased(
1156         string purchaseId,
1157         address paymentToken,
1158         uint256 price,
1159         uint256 quantity,
1160         address destination,
1161         address operator
1162     );
1163 
1164     event PriceUpdated(
1165         string purchaseId,
1166         uint256 ethPrice,
1167         uint256 erc20Price
1168     );
1169 
1170     address public ETH_ADDRESS = address(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
1171 
1172     address public _erc20Token;
1173     address payable public _payoutWallet;
1174 
1175     mapping(string => Price) public _prices; //  purchaseId => price in tokens
1176 
1177     constructor(address payable payoutWallet, address erc20Token) public {
1178         setPayoutWallet(payoutWallet);
1179         _erc20Token = erc20Token;
1180     }
1181 
1182     function setPayoutWallet(address payable payoutWallet) public onlyOwner {
1183         require(payoutWallet != address(0));
1184         require(payoutWallet != address(this));
1185         _payoutWallet = payoutWallet;
1186     }
1187 
1188     function setErc20Token(address erc20Token) public onlyOwner {
1189         _erc20Token = erc20Token;
1190     }
1191     
1192     function setPrice(string memory purchaseId, uint256 ethPrice, uint256 erc20TokenPrice) public onlyOwner {
1193         _prices[purchaseId] = Price(ethPrice, erc20TokenPrice);
1194         emit PriceUpdated(purchaseId, ethPrice, erc20TokenPrice);
1195     }
1196 
1197     function purchaseFor(
1198         address destination,
1199         string memory purchaseId,
1200         uint256 quantity,
1201         address paymentToken
1202     ) public payable {
1203         require(quantity > 0, "Quantity can't be 0");
1204         require(paymentToken == ETH_ADDRESS || paymentToken == _erc20Token, "Unsupported payment token");
1205 
1206         address payable sender = _msgSender();
1207 
1208         Price memory price = _prices[purchaseId];
1209 
1210         if (paymentToken == ETH_ADDRESS) {
1211             require(price.ethPrice != 0, "purchaseId not found");
1212             uint totalPrice = price.ethPrice.mul(quantity);
1213             require(msg.value >= totalPrice, "Insufficient ETH");
1214             _payoutWallet.transfer(totalPrice);
1215 
1216             uint256 change = msg.value.sub(totalPrice);
1217             if (change > 0) {
1218                 sender.transfer(change);
1219             }
1220             emit Purchased(purchaseId, paymentToken, price.ethPrice, quantity, destination, sender);
1221         } else {
1222             require(_erc20Token != address(0), "ERC20 payment not supported");
1223             require(price.erc20Price != 0, "Price not found");
1224             uint totalPrice = price.erc20Price.mul(quantity);
1225             require(ERC20(_erc20Token).transferFrom(sender, _payoutWallet, totalPrice));
1226             emit Purchased(purchaseId, paymentToken, price.erc20Price, quantity, destination, sender);
1227         }
1228     }
1229 
1230     /////////////////////////////////////////// GSNRecipient implementation ///////////////////////////////////
1231     /**
1232      * @dev Ensures that only users with enough gas payment token balance can have transactions relayed through the GSN.
1233      */
1234     function acceptRelayedCall(
1235         address /*relay*/,
1236         address /*from*/,
1237         bytes calldata encodedFunction,
1238         uint256 /*transactionFee*/,
1239         uint256 /*gasPrice*/,
1240         uint256 /*gasLimit*/,
1241         uint256 /*nonce*/,
1242         bytes calldata /*approvalData*/,
1243         uint256 /*maxPossibleCharge*/
1244     )
1245         external
1246         view
1247         returns (uint256, bytes memory mem)
1248     {
1249         // restrict to burn function only
1250         // load methodId stored in first 4 bytes https://solidity.readthedocs.io/en/v0.5.16/abi-spec.html#function-selector-and-argument-encoding
1251         // load amount stored in the next 32 bytes https://solidity.readthedocs.io/en/v0.5.16/abi-spec.html#function-selector-and-argument-encoding
1252         // 32 bytes offset is required to skip array length
1253         bytes4 methodId;
1254         address recipient;
1255         string memory purchaseId;
1256         uint256 quantity;
1257         address paymentToken;
1258         mem = encodedFunction;
1259         assembly {
1260             let dest := add(mem, 32)
1261             methodId := mload(dest)
1262             dest := add(dest, 4)
1263             recipient := mload(dest)
1264             dest := add(dest, 32)
1265             purchaseId := mload(dest)
1266             dest := add(dest, 32)
1267             quantity := mload(dest)
1268             dest := add(dest, 32)
1269             paymentToken := mload(dest)
1270         }
1271 
1272         // bytes4(keccak256("purchaseFor(address,string,uint256,address)")) == 0xwwwwww
1273         // if (methodId != 0xwwwwww) {
1274             // return _rejectRelayedCall(uint256(ErrorCodes.RESTRICTED_METHOD));
1275         // }
1276 
1277         // Check that user has enough balance
1278         // if (balanceOf(from) < amountParam) {
1279         //     return _rejectRelayedCall(uint256(ErrorCodes.INSUFFICIENT_BALANCE));
1280         // }
1281 
1282         //TODO restrict to purchaseFor() and add validation checks
1283 
1284         return _approveRelayedCall();
1285     }
1286 
1287     function _preRelayedCall(bytes memory) internal returns (bytes32) {
1288         // solhint-disable-previous-line no-empty-blocks
1289     }
1290 
1291     function _postRelayedCall(bytes memory, bool, uint256, bytes32) internal {
1292         // solhint-disable-previous-line no-empty-blocks
1293     }
1294 
1295     /**
1296      * @dev Withdraws the recipient's deposits in `RelayHub`.
1297      */
1298     function withdrawDeposits(uint256 amount, address payable payee) external onlyOwner {
1299         _withdrawDeposits(amount, payee);
1300     }
1301 }