1 // File: openzeppelin-solidity/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
270 
271 pragma solidity ^0.5.0;
272 
273 
274 
275 
276 /**
277  * @dev Implementation of the {IERC20} interface.
278  *
279  * This implementation is agnostic to the way tokens are created. This means
280  * that a supply mechanism has to be added in a derived contract using {_mint}.
281  * For a generic mechanism see {ERC20Mintable}.
282  *
283  * TIP: For a detailed writeup see our guide
284  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
285  * to implement supply mechanisms].
286  *
287  * We have followed general OpenZeppelin guidelines: functions revert instead
288  * of returning `false` on failure. This behavior is nonetheless conventional
289  * and does not conflict with the expectations of ERC20 applications.
290  *
291  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
292  * This allows applications to reconstruct the allowance for all accounts just
293  * by listening to said events. Other implementations of the EIP may not emit
294  * these events, as it isn't required by the specification.
295  *
296  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
297  * functions have been added to mitigate the well-known issues around setting
298  * allowances. See {IERC20-approve}.
299  */
300 contract ERC20 is Context, IERC20 {
301     using SafeMath for uint256;
302 
303     mapping (address => uint256) private _balances;
304 
305     mapping (address => mapping (address => uint256)) private _allowances;
306 
307     uint256 private _totalSupply;
308 
309     /**
310      * @dev See {IERC20-totalSupply}.
311      */
312     function totalSupply() public view returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See {IERC20-balanceOf}.
318      */
319     function balanceOf(address account) public view returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See {IERC20-transfer}.
325      *
326      * Requirements:
327      *
328      * - `recipient` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address recipient, uint256 amount) public returns (bool) {
332         _transfer(_msgSender(), recipient, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-allowance}.
338      */
339     function allowance(address owner, address spender) public view returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See {IERC20-approve}.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 amount) public returns (bool) {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20};
360      *
361      * Requirements:
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      * - the caller must have allowance for `sender`'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
368         _transfer(sender, recipient, amount);
369         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
406         return true;
407     }
408 
409     /**
410      * @dev Moves tokens `amount` from `sender` to `recipient`.
411      *
412      * This is internal function is equivalent to {transfer}, and can be used to
413      * e.g. implement automatic token fees, slashing mechanisms, etc.
414      *
415      * Emits a {Transfer} event.
416      *
417      * Requirements:
418      *
419      * - `sender` cannot be the zero address.
420      * - `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      */
423     function _transfer(address sender, address recipient, uint256 amount) internal {
424         require(sender != address(0), "ERC20: transfer from the zero address");
425         require(recipient != address(0), "ERC20: transfer to the zero address");
426 
427         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
428         _balances[recipient] = _balances[recipient].add(amount);
429         emit Transfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements
438      *
439      * - `to` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _totalSupply = _totalSupply.add(amount);
445         _balances[account] = _balances[account].add(amount);
446         emit Transfer(address(0), account, amount);
447     }
448 
449     /**
450      * @dev Destroys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a {Transfer} event with `to` set to the zero address.
454      *
455      * Requirements
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 amount) internal {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
464         _totalSupply = _totalSupply.sub(amount);
465         emit Transfer(account, address(0), amount);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
470      *
471      * This is internal function is equivalent to `approve`, and can be used to
472      * e.g. set automatic allowances for certain subsystems, etc.
473      *
474      * Emits an {Approval} event.
475      *
476      * Requirements:
477      *
478      * - `owner` cannot be the zero address.
479      * - `spender` cannot be the zero address.
480      */
481     function _approve(address owner, address spender, uint256 amount) internal {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
491      * from the caller's allowance.
492      *
493      * See {_burn} and {_approve}.
494      */
495     function _burnFrom(address account, uint256 amount) internal {
496         _burn(account, amount);
497         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
498     }
499 }
500 
501 // File: contracts/PurchaseListener.sol
502 
503 pragma solidity ^0.5.16;
504 
505 interface PurchaseListener {
506     // TODO: find out about how to best detect who implements an interface
507     //   see at least https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
508     // function isPurchaseListener() external returns (bool);
509 
510     /**
511      * Similarly to ETH transfer, returning false will decline the transaction
512      *   (declining should probably cause revert, but that's up to the caller)
513      * IMPORTANT: include onlyMarketplace modifier to your implementations!
514      */
515     function onPurchase(bytes32 productId, address subscriber, uint endTimestamp, uint priceDatacoin, uint feeDatacoin)
516         external returns (bool accepted);
517 }
518 
519 // File: contracts/Ownable.sol
520 
521 pragma solidity ^0.5.16;
522 
523 /**
524  * @title Ownable
525  * @dev The Ownable contract has an owner address, and provides basic authorization control
526  * functions, this simplifies the implementation of "user permissions".
527  */
528 contract Ownable {
529     address public owner;
530     address public pendingOwner;
531 
532     event OwnershipTransferred(
533         address indexed previousOwner,
534         address indexed newOwner
535     );
536 
537     /**
538      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
539      * account.
540      */
541     constructor() public {
542         owner = msg.sender;
543     }
544 
545     /**
546      * @dev Throws if called by any account other than the owner.
547      */
548     modifier onlyOwner() {
549         require(msg.sender == owner, "onlyOwner");
550         _;
551     }
552 
553     /**
554      * @dev Allows the current owner to set the pendingOwner address.
555      * @param newOwner The address to transfer ownership to.
556      */
557     function transferOwnership(address newOwner) public onlyOwner {
558         pendingOwner = newOwner;
559     }
560 
561     /**
562      * @dev Allows the pendingOwner address to finalize the transfer.
563      */
564     function claimOwnership() public {
565         require(msg.sender == pendingOwner, "onlyPendingOwner");
566         emit OwnershipTransferred(owner, pendingOwner);
567         owner = pendingOwner;
568         pendingOwner = address(0);
569     }
570 }
571 
572 // File: contracts/Marketplace.sol
573 
574 // solhint-disable not-rely-on-time
575 pragma solidity ^0.5.16;
576 
577 
578 
579 
580 
581 
582 contract IMarketplace {
583     enum ProductState {
584         NotDeployed,                // non-existent or deleted
585         Deployed                    // created or redeployed
586     }
587 
588     enum Currency {
589         DATA,                       // "token wei" (10^-18 DATA)
590         USD                         // attodollars (10^-18 USD)
591     }
592 
593     enum WhitelistState{
594         None,
595         Pending,
596         Approved,
597         Rejected
598     }
599     function getSubscription(bytes32 productId, address subscriber) public view returns (bool isValid, uint endTimestamp) {}
600     function getPriceInData(uint subscriptionSeconds, uint price, Currency unit) public view returns (uint datacoinAmount) {}
601 }
602 contract IMarketplace1 is IMarketplace{
603     function getProduct(bytes32 id) public view returns (string memory name, address owner, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, ProductState state) {}
604 }
605 contract IMarketplace2 is IMarketplace{
606     function getProduct(bytes32 id) public view returns (string memory name, address owner, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, ProductState state, bool requiresWhitelist) {}
607     function buyFor(bytes32 productId, uint subscriptionSeconds, address recipient) public {}
608 }
609 /**
610  * @title Streamr Marketplace
611  * @dev note about numbers:
612  *   All prices and exchange rates are in "decimal fixed-point", that is, scaled by 10^18, like ETH vs wei.
613  *  Seconds are integers as usual.
614  *
615  * Next version TODO:
616  *  - EIP-165 inferface definition; PurchaseListener
617  */
618 contract Marketplace is Ownable, IMarketplace2 {
619     using SafeMath for uint256;
620 
621     // product events
622     event ProductCreated(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
623     event ProductUpdated(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
624     event ProductDeleted(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
625     event ProductImported(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
626     event ProductRedeployed(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
627     event ProductOwnershipOffered(address indexed owner, bytes32 indexed id, address indexed to);
628     event ProductOwnershipChanged(address indexed newOwner, bytes32 indexed id, address indexed oldOwner);
629 
630     // subscription events
631     event Subscribed(bytes32 indexed productId, address indexed subscriber, uint endTimestamp);
632     event NewSubscription(bytes32 indexed productId, address indexed subscriber, uint endTimestamp);
633     event SubscriptionExtended(bytes32 indexed productId, address indexed subscriber, uint endTimestamp);
634     event SubscriptionImported(bytes32 indexed productId, address indexed subscriber, uint endTimestamp);
635     event SubscriptionTransferred(bytes32 indexed productId, address indexed from, address indexed to, uint secondsTransferred);
636 
637     // currency events
638     event ExchangeRatesUpdated(uint timestamp, uint dataInUsd);
639 
640     // whitelist events
641     event WhitelistRequested(bytes32 indexed productId, address indexed subscriber);
642     event WhitelistApproved(bytes32 indexed productId, address indexed subscriber);
643     event WhitelistRejected(bytes32 indexed productId, address indexed subscriber);
644     event WhitelistEnabled(bytes32 indexed productId);
645     event WhitelistDisabled(bytes32 indexed productId);
646 
647     //txFee events
648     event TxFeeChanged(uint256 indexed newTxFee);
649 
650 
651     struct Product {
652         bytes32 id;
653         string name;
654         address owner;
655         address beneficiary;        // account where revenue is directed to
656         uint pricePerSecond;
657         Currency priceCurrency;
658         uint minimumSubscriptionSeconds;
659         ProductState state;
660         address newOwnerCandidate;  // Two phase hand-over to minimize the chance that the product ownership is lost to a non-existent address.
661         bool requiresWhitelist;
662         mapping(address => TimeBasedSubscription) subscriptions;
663         mapping(address => WhitelistState) whitelist;
664     }
665 
666     struct TimeBasedSubscription {
667         uint endTimestamp;
668     }
669 
670     /////////////// Marketplace lifecycle /////////////////
671 
672     ERC20 public datacoin;
673 
674     address public currencyUpdateAgent;
675     IMarketplace1 prev_marketplace;
676     uint256 public txFee;
677 
678     constructor(address datacoinAddress, address currencyUpdateAgentAddress, address prev_marketplace_address) Ownable() public {
679         _initialize(datacoinAddress, currencyUpdateAgentAddress, prev_marketplace_address);
680     }
681 
682     function _initialize(address datacoinAddress, address currencyUpdateAgentAddress, address prev_marketplace_address) internal {
683         currencyUpdateAgent = currencyUpdateAgentAddress;
684         datacoin = ERC20(datacoinAddress);
685         prev_marketplace = IMarketplace1(prev_marketplace_address);
686     }
687 
688     ////////////////// Product management /////////////////
689 
690     mapping (bytes32 => Product) public products;
691     /*
692         checks this marketplace first, then the previous
693     */
694     function getProduct(bytes32 id) public view returns (string memory name, address owner, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, ProductState state, bool requiresWhitelist) {
695         (name, owner, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds, state, requiresWhitelist) = _getProductLocal(id);
696         if (owner != address(0))
697             return (name, owner, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds, state, requiresWhitelist);
698         (name, owner, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds, state) = prev_marketplace.getProduct(id);
699         return (name, owner, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds, state, false);
700     }
701 
702     /**
703     checks only this marketplace, not the previous marketplace
704      */
705 
706     function _getProductLocal(bytes32 id) internal view returns (string memory name, address owner, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, ProductState state, bool requiresWhitelist) {
707         Product memory p = products[id];
708         return (
709             p.name,
710             p.owner,
711             p.beneficiary,
712             p.pricePerSecond,
713             p.priceCurrency,
714             p.minimumSubscriptionSeconds,
715             p.state,
716             p.requiresWhitelist
717         );
718     }
719 
720     // also checks that p exists: p.owner == 0 for non-existent products
721     modifier onlyProductOwner(bytes32 productId) {
722         (,address _owner,,,,,,) = getProduct(productId);
723         require(_owner != address(0), "error_notFound");
724         require(_owner == msg.sender || owner == msg.sender, "error_productOwnersOnly");
725         _;
726     }
727 
728     /**
729      * Imports product details (but NOT subscription details) from previous marketplace
730      */
731     function _importProductIfNeeded(bytes32 productId) internal returns (bool imported){
732         Product storage p = products[productId];
733         if(p.id != 0x0)
734             return false;
735         (string memory _name, address _owner, address _beneficiary, uint _pricePerSecond, IMarketplace1.Currency _priceCurrency, uint _minimumSubscriptionSeconds, IMarketplace1.ProductState _state) = prev_marketplace.getProduct(productId);
736         if(_owner == address(0))
737             return false;
738         p.id = productId;
739         p.name = _name;
740         p.owner = _owner;
741         p.beneficiary = _beneficiary;
742         p.pricePerSecond = _pricePerSecond;
743         p.priceCurrency = _priceCurrency;
744         p.minimumSubscriptionSeconds = _minimumSubscriptionSeconds;
745         p.state = _state;
746         emit ProductImported(p.owner, p.id, p.name, p.beneficiary, p.pricePerSecond, p.priceCurrency, p.minimumSubscriptionSeconds);
747         return true;
748     }
749 
750     function _importSubscriptionIfNeeded(bytes32 productId, address subscriber) internal returns (bool imported) {
751         bool _productImported = _importProductIfNeeded(productId);
752 
753         // check that subscription didn't already exist in current marketplace
754         (Product storage product, TimeBasedSubscription storage sub) = _getSubscriptionLocal(productId, subscriber);
755         if (sub.endTimestamp != 0x0) { return false; }
756 
757         // check that subscription exists in the previous marketplace(s)
758         // only call prev_marketplace.getSubscription() if product exists there
759         // consider e.g. product created in current marketplace but subscription still doesn't exist
760         // if _productImported, it must have existed in previous marketplace so no need to perform check
761         if(!_productImported){
762             (,address _owner_prev,,,,,) = prev_marketplace.getProduct(productId);
763             if (_owner_prev == address(0)) { return false; }
764         }
765         (, uint _endTimestamp) = prev_marketplace.getSubscription(productId, subscriber);
766         if (_endTimestamp == 0x0) { return false; }
767         product.subscriptions[subscriber] = TimeBasedSubscription(_endTimestamp);
768         emit SubscriptionImported(productId, subscriber, _endTimestamp);
769         return true;
770     }
771     function createProduct(bytes32 id, string memory name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds) public whenNotHalted {
772         _createProduct(id, name, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds, false);
773     }
774 
775     function createProductWithWhitelist(bytes32 id, string memory name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds) public whenNotHalted {
776         _createProduct(id, name, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds, true);
777         emit WhitelistEnabled(id);
778     }
779 
780 
781     function _createProduct(bytes32 id, string memory name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, bool requiresWhitelist) internal {
782         require(id != 0x0, "error_nullProductId");
783         require(pricePerSecond > 0, "error_freeProductsNotSupported");
784         (,address _owner,,,,,,) = getProduct(id);
785         require(_owner == address(0), "error_alreadyExists");
786         products[id] = Product({id: id, name: name, owner: msg.sender, beneficiary: beneficiary, pricePerSecond: pricePerSecond,
787             priceCurrency: currency, minimumSubscriptionSeconds: minimumSubscriptionSeconds, state: ProductState.Deployed, newOwnerCandidate: address(0), requiresWhitelist: requiresWhitelist});
788         emit ProductCreated(msg.sender, id, name, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds);
789     }
790 
791     /**
792     * Stop offering the product
793     */
794     function deleteProduct(bytes32 productId) public onlyProductOwner(productId) {
795         _importProductIfNeeded(productId);
796         Product storage p = products[productId];
797         require(p.state == ProductState.Deployed, "error_notDeployed");
798         p.state = ProductState.NotDeployed;
799         emit ProductDeleted(p.owner, productId, p.name, p.beneficiary, p.pricePerSecond, p.priceCurrency, p.minimumSubscriptionSeconds);
800     }
801 
802     /**
803     * Return product to market
804     */
805     function redeployProduct(bytes32 productId) public onlyProductOwner(productId) {
806         _importProductIfNeeded(productId);
807         Product storage p = products[productId];
808         require(p.state == ProductState.NotDeployed, "error_mustBeNotDeployed");
809         p.state = ProductState.Deployed;
810         emit ProductRedeployed(p.owner, productId, p.name, p.beneficiary, p.pricePerSecond, p.priceCurrency, p.minimumSubscriptionSeconds);
811     }
812 
813     function updateProduct(bytes32 productId, string memory name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, bool redeploy) public onlyProductOwner(productId) {
814         require(pricePerSecond > 0, "error_freeProductsNotSupported");
815         _importProductIfNeeded(productId);
816         Product storage p = products[productId];
817         p.name = name;
818         p.beneficiary = beneficiary;
819         p.pricePerSecond = pricePerSecond;
820         p.priceCurrency = currency;
821         p.minimumSubscriptionSeconds = minimumSubscriptionSeconds;
822         emit ProductUpdated(p.owner, p.id, name, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds);
823         if(redeploy)
824             redeployProduct(productId);
825     }
826 
827     /**
828     * Changes ownership of the product. Two phase hand-over minimizes the chance that the product ownership is lost to a non-existent address.
829     */
830     function offerProductOwnership(bytes32 productId, address newOwnerCandidate) public onlyProductOwner(productId) {
831         _importProductIfNeeded(productId);
832         // that productId exists is already checked in onlyProductOwner
833         products[productId].newOwnerCandidate = newOwnerCandidate;
834         emit ProductOwnershipOffered(products[productId].owner, productId, newOwnerCandidate);
835     }
836 
837     /**
838     * Changes ownership of the product. Two phase hand-over minimizes the chance that the product ownership is lost to a non-existent address.
839     */
840     function claimProductOwnership(bytes32 productId) public whenNotHalted {
841         _importProductIfNeeded(productId);
842         // also checks that productId exists (newOwnerCandidate is zero for non-existent)
843         Product storage p = products[productId];
844         require(msg.sender == p.newOwnerCandidate, "error_notPermitted");
845         emit ProductOwnershipChanged(msg.sender, productId, p.owner);
846         p.owner = msg.sender;
847         p.newOwnerCandidate = address(0);
848     }
849 
850     /////////////// Whitelist management ///////////////
851 
852     function setRequiresWhitelist(bytes32 productId, bool _requiresWhitelist) public onlyProductOwner(productId) {
853         _importProductIfNeeded(productId);
854         Product storage p = products[productId];
855         require(p.id != 0x0, "error_notFound");
856         p.requiresWhitelist = _requiresWhitelist;
857         if(_requiresWhitelist)
858             emit WhitelistEnabled(productId);
859         else
860             emit WhitelistDisabled(productId);
861     }
862 
863     function whitelistApprove(bytes32 productId, address subscriber) public onlyProductOwner(productId) {
864         _importProductIfNeeded(productId);
865         Product storage p = products[productId];
866         require(p.id != 0x0, "error_notFound");
867         require(p.requiresWhitelist, "error_whitelistNotEnabled");
868         p.whitelist[subscriber] = WhitelistState.Approved;
869         emit WhitelistApproved(productId, subscriber);
870     }
871 
872     function whitelistReject(bytes32 productId, address subscriber) public onlyProductOwner(productId) {
873         _importProductIfNeeded(productId);
874         Product storage p = products[productId];
875         require(p.id != 0x0, "error_notFound");
876         require(p.requiresWhitelist, "error_whitelistNotEnabled");
877         p.whitelist[subscriber] = WhitelistState.Rejected;
878         emit WhitelistRejected(productId, subscriber);
879     }
880 
881     function whitelistRequest(bytes32 productId) public {
882         _importProductIfNeeded(productId);
883         Product storage p = products[productId];
884         require(p.id != 0x0, "error_notFound");
885         require(p.requiresWhitelist, "error_whitelistNotEnabled");
886         require(p.whitelist[msg.sender] == WhitelistState.None, "error_whitelistRequestAlreadySubmitted");
887         p.whitelist[msg.sender] = WhitelistState.Pending;
888         emit WhitelistRequested(productId, msg.sender);
889     }
890 
891     function getWhitelistState(bytes32 productId, address subscriber) public view returns (WhitelistState wlstate) {
892         (, address _owner,,,,,,) = getProduct(productId);
893         require(_owner != address(0), "error_notFound");
894         //if it's not local this will return 0, which is WhitelistState.None
895         Product storage p = products[productId];
896         return p.whitelist[subscriber];
897     }
898 
899     /////////////// Subscription management ///////////////
900 
901     function getSubscription(bytes32 productId, address subscriber) public view returns (bool isValid, uint endTimestamp) {
902         (,address _owner,,,,,,) = _getProductLocal(productId);
903         if (_owner == address(0)) {
904             return prev_marketplace.getSubscription(productId,subscriber);
905         }
906 
907         (, TimeBasedSubscription storage sub) = _getSubscriptionLocal(productId, subscriber);
908         if (sub.endTimestamp == 0x0) {
909             // only call prev_marketplace.getSubscription() if product exists in previous marketplace too
910             (,address _owner_prev,,,,,) = prev_marketplace.getProduct(productId);
911             if (_owner_prev != address(0)) {
912                 return prev_marketplace.getSubscription(productId,subscriber);
913             }
914         }
915         return (_isValid(sub), sub.endTimestamp);
916     }
917 
918     function getSubscriptionTo(bytes32 productId) public view returns (bool isValid, uint endTimestamp) {
919         return getSubscription(productId, msg.sender);
920     }
921 
922     /**
923      * Checks if the given address currently has a valid subscription
924      * @param productId to check
925      * @param subscriber to check
926      */
927     function hasValidSubscription(bytes32 productId, address subscriber) public view returns (bool isValid) {
928         (isValid,) = getSubscription(productId, subscriber);
929     }
930 
931     /**
932      * Enforces payment rules, triggers PurchaseListener event
933      */
934     function _subscribe(bytes32 productId, uint addSeconds, address subscriber, bool requirePayment) internal {
935         _importSubscriptionIfNeeded(productId, subscriber);
936         (Product storage p, TimeBasedSubscription storage oldSub) = _getSubscriptionLocal(productId, subscriber);
937         require(p.state == ProductState.Deployed, "error_notDeployed");
938         require(!p.requiresWhitelist || p.whitelist[subscriber] == WhitelistState.Approved, "error_whitelistNotAllowed");
939         uint endTimestamp;
940 
941         if (oldSub.endTimestamp > block.timestamp) {
942             require(addSeconds > 0, "error_topUpTooSmall");
943             endTimestamp = oldSub.endTimestamp.add(addSeconds);
944             oldSub.endTimestamp = endTimestamp;
945             emit SubscriptionExtended(p.id, subscriber, endTimestamp);
946         } else {
947             require(addSeconds >= p.minimumSubscriptionSeconds, "error_newSubscriptionTooSmall");
948             endTimestamp = block.timestamp.add(addSeconds);
949             TimeBasedSubscription memory newSub = TimeBasedSubscription(endTimestamp);
950             p.subscriptions[subscriber] = newSub;
951             emit NewSubscription(p.id, subscriber, endTimestamp);
952         }
953         emit Subscribed(p.id, subscriber, endTimestamp);
954 
955         uint256 price = 0;
956         uint256 fee = 0;
957         address recipient = p.beneficiary;
958         if (requirePayment) {
959             price = getPriceInData(addSeconds, p.pricePerSecond, p.priceCurrency);
960             fee = txFee.mul(price).div(1 ether);
961             require(datacoin.transferFrom(msg.sender, recipient, price.sub(fee)), "error_paymentFailed");
962             if (fee > 0) {
963                 require(datacoin.transferFrom(msg.sender, owner, fee), "error_paymentFailed");
964             }
965         }
966 
967         uint256 codeSize;
968         assembly { codeSize := extcodesize(recipient) }  // solium-disable-line security/no-inline-assembly
969         if (codeSize > 0) {
970             // solium-disable-next-line security/no-low-level-calls
971             (bool success, bytes memory returnData) = recipient.call(
972                 abi.encodeWithSignature("onPurchase(bytes32,address,uint256,uint256,uint256)",
973                 productId, subscriber, oldSub.endTimestamp, price, fee)
974             );
975 
976             if (success) {
977                 (bool accepted) = abi.decode(returnData, (bool));
978                 require(accepted, "error_rejectedBySeller");
979             }
980         }
981     }
982 
983     function grantSubscription(bytes32 productId, uint subscriptionSeconds, address recipient) public whenNotHalted onlyProductOwner(productId){
984         return _subscribe(productId, subscriptionSeconds, recipient, false);
985     }
986 
987 
988     function buyFor(bytes32 productId, uint subscriptionSeconds, address recipient) public whenNotHalted {
989         return _subscribe(productId, subscriptionSeconds, recipient, true);
990     }
991 
992 
993     /**
994      * Purchases access to this stream for msg.sender.
995      * If the address already has a valid subscription, extends the subscription by the given period.
996      * @dev since v4.0: Notify the seller if the seller implements PurchaseListener interface
997      */
998     function buy(bytes32 productId, uint subscriptionSeconds) public whenNotHalted {
999         buyFor(productId,subscriptionSeconds, msg.sender);
1000     }
1001 
1002 
1003     /** Gets subscriptions info from the subscriptions stored in this contract */
1004     function _getSubscriptionLocal(bytes32 productId, address subscriber) internal view returns (Product storage p, TimeBasedSubscription storage s) {
1005         p = products[productId];
1006         require(p.id != 0x0, "error_notFound");
1007         s = p.subscriptions[subscriber];
1008     }
1009 
1010     function _isValid(TimeBasedSubscription storage s) internal view returns (bool) {
1011         return s.endTimestamp >= block.timestamp;   // solium-disable-line security/no-block-members
1012     }
1013 
1014     // TODO: transfer allowance to another Marketplace contract
1015     // Mechanism basically is that this Marketplace draws from the allowance and credits
1016     //   the account on another Marketplace; OR that there is a central credit pool (say, an ERC20 token)
1017     // Creating another ERC20 token for this could be a simple fix: it would need the ability to transfer allowances
1018 
1019     /////////////// Currency management ///////////////
1020 
1021     // Exchange rates are formatted as "decimal fixed-point", that is, scaled by 10^18, like ether.
1022     //        Exponent: 10^18 15 12  9  6  3  0
1023     //                      |  |  |  |  |  |  |
1024     uint public dataPerUsd = 100000000000000000;   // ~= 0.1 DATA/USD
1025 
1026     /**
1027     * Update currency exchange rates; all purchases are still billed in DATAcoin
1028     * @param timestamp in seconds when the exchange rates were last updated
1029     * @param dataUsd how many data atoms (10^-18 DATA) equal one USD dollar
1030     */
1031     function updateExchangeRates(uint timestamp, uint dataUsd) public {
1032         require(msg.sender == currencyUpdateAgent, "error_notPermitted");
1033         require(dataUsd > 0, "error_invalidRate");
1034         dataPerUsd = dataUsd;
1035         emit ExchangeRatesUpdated(timestamp, dataUsd);
1036     }
1037 
1038     /**
1039     * Helper function to calculate (hypothetical) subscription cost for given seconds and price, using current exchange rates.
1040     * @param subscriptionSeconds length of hypothetical subscription, as a non-scaled integer
1041     * @param price nominal price scaled by 10^18 ("token wei" or "attodollars")
1042     * @param unit unit of the number price
1043     */
1044     function getPriceInData(uint subscriptionSeconds, uint price, Currency unit) public view returns (uint datacoinAmount) {
1045         if (unit == Currency.DATA) {
1046             return price.mul(subscriptionSeconds);
1047         }
1048         return price.mul(dataPerUsd).div(10**18).mul(subscriptionSeconds);
1049     }
1050 
1051     /////////////// Admin functionality ///////////////
1052 
1053     event Halted();
1054     event Resumed();
1055     bool public halted = false;
1056 
1057     modifier whenNotHalted() {
1058         require(!halted || owner == msg.sender, "error_halted");
1059         _;
1060     }
1061     function halt() public onlyOwner {
1062         halted = true;
1063         emit Halted();
1064     }
1065     function resume() public onlyOwner {
1066         halted = false;
1067         emit Resumed();
1068     }
1069 
1070     function reInitialize(address datacoinAddress, address currencyUpdateAgentAddress, address prev_marketplace_address) public onlyOwner {
1071         _initialize(datacoinAddress, currencyUpdateAgentAddress, prev_marketplace_address);
1072     }
1073 
1074     function setTxFee(uint256 newTxFee) public onlyOwner {
1075         require(newTxFee <= 1 ether, "error_invalidTxFee");
1076         txFee = newTxFee;
1077         emit TxFeeChanged(txFee);
1078     }
1079 }