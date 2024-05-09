1 // File: openzeppelin-solidity/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
109 
110 // SPDX-License-Identifier: MIT
111 
112 pragma solidity >=0.6.0 <0.8.0;
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
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return div(a, b, "SafeMath: division by zero");
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
271 
272 // SPDX-License-Identifier: MIT
273 
274 pragma solidity >=0.6.0 <0.8.0;
275 
276 
277 
278 
279 /**
280  * @dev Implementation of the {IERC20} interface.
281  *
282  * This implementation is agnostic to the way tokens are created. This means
283  * that a supply mechanism has to be added in a derived contract using {_mint}.
284  * For a generic mechanism see {ERC20PresetMinterPauser}.
285  *
286  * TIP: For a detailed writeup see our guide
287  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
288  * to implement supply mechanisms].
289  *
290  * We have followed general OpenZeppelin guidelines: functions revert instead
291  * of returning `false` on failure. This behavior is nonetheless conventional
292  * and does not conflict with the expectations of ERC20 applications.
293  *
294  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
295  * This allows applications to reconstruct the allowance for all accounts just
296  * by listening to said events. Other implementations of the EIP may not emit
297  * these events, as it isn't required by the specification.
298  *
299  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
300  * functions have been added to mitigate the well-known issues around setting
301  * allowances. See {IERC20-approve}.
302  */
303 contract ERC20 is Context, IERC20 {
304     using SafeMath for uint256;
305 
306     mapping (address => uint256) private _balances;
307 
308     mapping (address => mapping (address => uint256)) private _allowances;
309 
310     uint256 private _totalSupply;
311 
312     string private _name;
313     string private _symbol;
314     uint8 private _decimals;
315 
316     /**
317      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
318      * a default value of 18.
319      *
320      * To select a different value for {decimals}, use {_setupDecimals}.
321      *
322      * All three of these values are immutable: they can only be set once during
323      * construction.
324      */
325     constructor (string memory name_, string memory symbol_) public {
326         _name = name_;
327         _symbol = symbol_;
328         _decimals = 18;
329     }
330 
331     /**
332      * @dev Returns the name of the token.
333      */
334     function name() public view returns (string memory) {
335         return _name;
336     }
337 
338     /**
339      * @dev Returns the symbol of the token, usually a shorter version of the
340      * name.
341      */
342     function symbol() public view returns (string memory) {
343         return _symbol;
344     }
345 
346     /**
347      * @dev Returns the number of decimals used to get its user representation.
348      * For example, if `decimals` equals `2`, a balance of `505` tokens should
349      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
350      *
351      * Tokens usually opt for a value of 18, imitating the relationship between
352      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
353      * called.
354      *
355      * NOTE: This information is only used for _display_ purposes: it in
356      * no way affects any of the arithmetic of the contract, including
357      * {IERC20-balanceOf} and {IERC20-transfer}.
358      */
359     function decimals() public view returns (uint8) {
360         return _decimals;
361     }
362 
363     /**
364      * @dev See {IERC20-totalSupply}.
365      */
366     function totalSupply() public view override returns (uint256) {
367         return _totalSupply;
368     }
369 
370     /**
371      * @dev See {IERC20-balanceOf}.
372      */
373     function balanceOf(address account) public view override returns (uint256) {
374         return _balances[account];
375     }
376 
377     /**
378      * @dev See {IERC20-transfer}.
379      *
380      * Requirements:
381      *
382      * - `recipient` cannot be the zero address.
383      * - the caller must have a balance of at least `amount`.
384      */
385     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
386         _transfer(_msgSender(), recipient, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-allowance}.
392      */
393     function allowance(address owner, address spender) public view virtual override returns (uint256) {
394         return _allowances[owner][spender];
395     }
396 
397     /**
398      * @dev See {IERC20-approve}.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      */
404     function approve(address spender, uint256 amount) public virtual override returns (bool) {
405         _approve(_msgSender(), spender, amount);
406         return true;
407     }
408 
409     /**
410      * @dev See {IERC20-transferFrom}.
411      *
412      * Emits an {Approval} event indicating the updated allowance. This is not
413      * required by the EIP. See the note at the beginning of {ERC20}.
414      *
415      * Requirements:
416      *
417      * - `sender` and `recipient` cannot be the zero address.
418      * - `sender` must have a balance of at least `amount`.
419      * - the caller must have allowance for ``sender``'s tokens of at least
420      * `amount`.
421      */
422     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
423         _transfer(sender, recipient, amount);
424         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
425         return true;
426     }
427 
428     /**
429      * @dev Atomically increases the allowance granted to `spender` by the caller.
430      *
431      * This is an alternative to {approve} that can be used as a mitigation for
432      * problems described in {IERC20-approve}.
433      *
434      * Emits an {Approval} event indicating the updated allowance.
435      *
436      * Requirements:
437      *
438      * - `spender` cannot be the zero address.
439      */
440     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
441         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
442         return true;
443     }
444 
445     /**
446      * @dev Atomically decreases the allowance granted to `spender` by the caller.
447      *
448      * This is an alternative to {approve} that can be used as a mitigation for
449      * problems described in {IERC20-approve}.
450      *
451      * Emits an {Approval} event indicating the updated allowance.
452      *
453      * Requirements:
454      *
455      * - `spender` cannot be the zero address.
456      * - `spender` must have allowance for the caller of at least
457      * `subtractedValue`.
458      */
459     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
460         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
461         return true;
462     }
463 
464     /**
465      * @dev Moves tokens `amount` from `sender` to `recipient`.
466      *
467      * This is internal function is equivalent to {transfer}, and can be used to
468      * e.g. implement automatic token fees, slashing mechanisms, etc.
469      *
470      * Emits a {Transfer} event.
471      *
472      * Requirements:
473      *
474      * - `sender` cannot be the zero address.
475      * - `recipient` cannot be the zero address.
476      * - `sender` must have a balance of at least `amount`.
477      */
478     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
479         require(sender != address(0), "ERC20: transfer from the zero address");
480         require(recipient != address(0), "ERC20: transfer to the zero address");
481 
482         _beforeTokenTransfer(sender, recipient, amount);
483 
484         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
485         _balances[recipient] = _balances[recipient].add(amount);
486         emit Transfer(sender, recipient, amount);
487     }
488 
489     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
490      * the total supply.
491      *
492      * Emits a {Transfer} event with `from` set to the zero address.
493      *
494      * Requirements:
495      *
496      * - `to` cannot be the zero address.
497      */
498     function _mint(address account, uint256 amount) internal virtual {
499         require(account != address(0), "ERC20: mint to the zero address");
500 
501         _beforeTokenTransfer(address(0), account, amount);
502 
503         _totalSupply = _totalSupply.add(amount);
504         _balances[account] = _balances[account].add(amount);
505         emit Transfer(address(0), account, amount);
506     }
507 
508     /**
509      * @dev Destroys `amount` tokens from `account`, reducing the
510      * total supply.
511      *
512      * Emits a {Transfer} event with `to` set to the zero address.
513      *
514      * Requirements:
515      *
516      * - `account` cannot be the zero address.
517      * - `account` must have at least `amount` tokens.
518      */
519     function _burn(address account, uint256 amount) internal virtual {
520         require(account != address(0), "ERC20: burn from the zero address");
521 
522         _beforeTokenTransfer(account, address(0), amount);
523 
524         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
525         _totalSupply = _totalSupply.sub(amount);
526         emit Transfer(account, address(0), amount);
527     }
528 
529     /**
530      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
531      *
532      * This internal function is equivalent to `approve`, and can be used to
533      * e.g. set automatic allowances for certain subsystems, etc.
534      *
535      * Emits an {Approval} event.
536      *
537      * Requirements:
538      *
539      * - `owner` cannot be the zero address.
540      * - `spender` cannot be the zero address.
541      */
542     function _approve(address owner, address spender, uint256 amount) internal virtual {
543         require(owner != address(0), "ERC20: approve from the zero address");
544         require(spender != address(0), "ERC20: approve to the zero address");
545 
546         _allowances[owner][spender] = amount;
547         emit Approval(owner, spender, amount);
548     }
549 
550     /**
551      * @dev Sets {decimals} to a value other than the default one of 18.
552      *
553      * WARNING: This function should only be called from the constructor. Most
554      * applications that interact with token contracts will not expect
555      * {decimals} to ever change, and may work incorrectly if it does.
556      */
557     function _setupDecimals(uint8 decimals_) internal {
558         _decimals = decimals_;
559     }
560 
561     /**
562      * @dev Hook that is called before any transfer of tokens. This includes
563      * minting and burning.
564      *
565      * Calling conditions:
566      *
567      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
568      * will be to transferred to `to`.
569      * - when `from` is zero, `amount` tokens will be minted for `to`.
570      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
571      * - `from` and `to` are never both zero.
572      *
573      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
574      */
575     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
576 }
577 
578 // File: contracts/PurchaseListener.sol
579 
580 pragma solidity ^0.6.6;
581 
582 interface PurchaseListener {
583     // TODO: find out about how to best detect who implements an interface
584     //   see at least https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
585     // function isPurchaseListener() external returns (bool);
586 
587     /**
588      * Similarly to ETH transfer, returning false will decline the transaction
589      *   (declining should probably cause revert, but that's up to the caller)
590      * IMPORTANT: include onlyMarketplace modifier to your implementations!
591      */
592     function onPurchase(bytes32 productId, address subscriber, uint endTimestamp, uint priceDatacoin, uint feeDatacoin)
593         external returns (bool accepted);
594 }
595 
596 // File: contracts/Ownable.sol
597 
598 pragma solidity ^0.6.6;
599 
600 /**
601  * @title Ownable
602  * @dev The Ownable contract has an owner address, and provides basic authorization control
603  * functions, this simplifies the implementation of "user permissions".
604  */
605 contract Ownable {
606     address public owner;
607     address public pendingOwner;
608 
609     event OwnershipTransferred(
610         address indexed previousOwner,
611         address indexed newOwner
612     );
613 
614     /**
615      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
616      * account.
617      */
618     constructor() public {
619         owner = msg.sender;
620     }
621 
622     /**
623      * @dev Throws if called by any account other than the owner.
624      */
625     modifier onlyOwner() {
626         require(msg.sender == owner, "onlyOwner");
627         _;
628     }
629 
630     /**
631      * @dev Allows the current owner to set the pendingOwner address.
632      * @param newOwner The address to transfer ownership to.
633      */
634     function transferOwnership(address newOwner) public onlyOwner {
635         pendingOwner = newOwner;
636     }
637 
638     /**
639      * @dev Allows the pendingOwner address to finalize the transfer.
640      */
641     function claimOwnership() public {
642         require(msg.sender == pendingOwner, "onlyPendingOwner");
643         emit OwnershipTransferred(owner, pendingOwner);
644         owner = pendingOwner;
645         pendingOwner = address(0);
646     }
647 }
648 
649 // File: contracts/Marketplace.sol
650 
651 // solhint-disable not-rely-on-time
652 pragma solidity ^0.6.6;
653 
654 
655 
656 
657 
658 
659 interface IMarketplace {
660     enum ProductState {
661         NotDeployed,                // non-existent or deleted
662         Deployed                    // created or redeployed
663     }
664 
665     enum Currency {
666         DATA,                       // "token wei" (10^-18 DATA)
667         USD                         // attodollars (10^-18 USD)
668     }
669 
670     enum WhitelistState{
671         None,
672         Pending,
673         Approved,
674         Rejected
675     }
676     function getSubscription(bytes32 productId, address subscriber) external view returns (bool isValid, uint endTimestamp);
677     function getPriceInData(uint subscriptionSeconds, uint price, Currency unit) external view returns (uint datacoinAmount);
678 }
679 interface IMarketplace1 is IMarketplace{
680     function getProduct(bytes32 id) external view returns (string memory name, address owner, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, ProductState state);
681 }
682 interface IMarketplace2 is IMarketplace{
683     function getProduct(bytes32 id) external view returns (string memory name, address owner, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, ProductState state, bool requiresWhitelist);
684     function buyFor(bytes32 productId, uint subscriptionSeconds, address recipient) external;
685 }
686 /**
687  * @title Streamr Marketplace
688  * @dev note about numbers:
689  *   All prices and exchange rates are in "decimal fixed-point", that is, scaled by 10^18, like ETH vs wei.
690  *  Seconds are integers as usual.
691  *
692  * Next version TODO:
693  *  - EIP-165 inferface definition; PurchaseListener
694  */
695 contract Marketplace is Ownable, IMarketplace2 {
696     using SafeMath for uint256;
697 
698     // product events
699     event ProductCreated(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
700     event ProductUpdated(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
701     event ProductDeleted(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
702     event ProductImported(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
703     event ProductRedeployed(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
704     event ProductOwnershipOffered(address indexed owner, bytes32 indexed id, address indexed to);
705     event ProductOwnershipChanged(address indexed newOwner, bytes32 indexed id, address indexed oldOwner);
706 
707     // subscription events
708     event Subscribed(bytes32 indexed productId, address indexed subscriber, uint endTimestamp);
709     event NewSubscription(bytes32 indexed productId, address indexed subscriber, uint endTimestamp);
710     event SubscriptionExtended(bytes32 indexed productId, address indexed subscriber, uint endTimestamp);
711     event SubscriptionImported(bytes32 indexed productId, address indexed subscriber, uint endTimestamp);
712     event SubscriptionTransferred(bytes32 indexed productId, address indexed from, address indexed to, uint secondsTransferred);
713 
714     // currency events
715     event ExchangeRatesUpdated(uint timestamp, uint dataInUsd);
716 
717     // whitelist events
718     event WhitelistRequested(bytes32 indexed productId, address indexed subscriber);
719     event WhitelistApproved(bytes32 indexed productId, address indexed subscriber);
720     event WhitelistRejected(bytes32 indexed productId, address indexed subscriber);
721     event WhitelistEnabled(bytes32 indexed productId);
722     event WhitelistDisabled(bytes32 indexed productId);
723 
724     //txFee events
725     event TxFeeChanged(uint256 indexed newTxFee);
726 
727 
728     struct Product {
729         bytes32 id;
730         string name;
731         address owner;
732         address beneficiary;        // account where revenue is directed to
733         uint pricePerSecond;
734         Currency priceCurrency;
735         uint minimumSubscriptionSeconds;
736         ProductState state;
737         address newOwnerCandidate;  // Two phase hand-over to minimize the chance that the product ownership is lost to a non-existent address.
738         bool requiresWhitelist;
739         mapping(address => TimeBasedSubscription) subscriptions;
740         mapping(address => WhitelistState) whitelist;
741     }
742 
743     struct TimeBasedSubscription {
744         uint endTimestamp;
745     }
746 
747     /////////////// Marketplace lifecycle /////////////////
748 
749     ERC20 public datacoin;
750 
751     address public currencyUpdateAgent;
752     IMarketplace1 prev_marketplace;
753     uint256 public txFee;
754 
755     constructor(address datacoinAddress, address currencyUpdateAgentAddress, address prev_marketplace_address) Ownable() public {
756         _initialize(datacoinAddress, currencyUpdateAgentAddress, prev_marketplace_address);
757     }
758 
759     function _initialize(address datacoinAddress, address currencyUpdateAgentAddress, address prev_marketplace_address) internal {
760         currencyUpdateAgent = currencyUpdateAgentAddress;
761         datacoin = ERC20(datacoinAddress);
762         prev_marketplace = IMarketplace1(prev_marketplace_address);
763     }
764 
765     ////////////////// Product management /////////////////
766 
767     mapping (bytes32 => Product) public products;
768     /*
769         checks this marketplace first, then the previous
770     */
771     function getProduct(bytes32 id) public override view returns (string memory name, address owner, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, ProductState state, bool requiresWhitelist) {
772         (name, owner, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds, state, requiresWhitelist) = _getProductLocal(id);
773         if (owner != address(0))
774             return (name, owner, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds, state, requiresWhitelist);
775         (name, owner, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds, state) = prev_marketplace.getProduct(id);
776         return (name, owner, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds, state, false);
777     }
778 
779     /**
780     checks only this marketplace, not the previous marketplace
781      */
782 
783     function _getProductLocal(bytes32 id) internal view returns (string memory name, address owner, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, ProductState state, bool requiresWhitelist) {
784         Product memory p = products[id];
785         return (
786             p.name,
787             p.owner,
788             p.beneficiary,
789             p.pricePerSecond,
790             p.priceCurrency,
791             p.minimumSubscriptionSeconds,
792             p.state,
793             p.requiresWhitelist
794         );
795     }
796 
797     // also checks that p exists: p.owner == 0 for non-existent products
798     modifier onlyProductOwner(bytes32 productId) {
799         (,address _owner,,,,,,) = getProduct(productId);
800         require(_owner != address(0), "error_notFound");
801         require(_owner == msg.sender || owner == msg.sender, "error_productOwnersOnly");
802         _;
803     }
804 
805     /**
806      * Imports product details (but NOT subscription details) from previous marketplace
807      */
808     function _importProductIfNeeded(bytes32 productId) internal returns (bool imported){
809         Product storage p = products[productId];
810         if (p.id != 0x0) { return false; }
811         (string memory _name, address _owner, address _beneficiary, uint _pricePerSecond, IMarketplace1.Currency _priceCurrency, uint _minimumSubscriptionSeconds, IMarketplace1.ProductState _state) = prev_marketplace.getProduct(productId);
812         if (_owner == address(0)) { return false; }
813         p.id = productId;
814         p.name = _name;
815         p.owner = _owner;
816         p.beneficiary = _beneficiary;
817         p.pricePerSecond = _pricePerSecond;
818         p.priceCurrency = _priceCurrency;
819         p.minimumSubscriptionSeconds = _minimumSubscriptionSeconds;
820         p.state = _state;
821         emit ProductImported(p.owner, p.id, p.name, p.beneficiary, p.pricePerSecond, p.priceCurrency, p.minimumSubscriptionSeconds);
822         return true;
823     }
824 
825     function _importSubscriptionIfNeeded(bytes32 productId, address subscriber) internal returns (bool imported) {
826         bool _productImported = _importProductIfNeeded(productId);
827 
828         // check that subscription didn't already exist in current marketplace
829         (Product storage product, TimeBasedSubscription storage sub) = _getSubscriptionLocal(productId, subscriber);
830         if (sub.endTimestamp != 0x0) { return false; }
831 
832         // check that subscription exists in the previous marketplace(s)
833         // only call prev_marketplace.getSubscription() if product exists there
834         // consider e.g. product created in current marketplace but subscription still doesn't exist
835         // if _productImported, it must have existed in previous marketplace so no need to perform check
836         if (!_productImported) {
837             (,address _owner_prev,,,,,) = prev_marketplace.getProduct(productId);
838             if (_owner_prev == address(0)) { return false; }
839         }
840         (, uint _endTimestamp) = prev_marketplace.getSubscription(productId, subscriber);
841         if (_endTimestamp == 0x0) { return false; }
842         product.subscriptions[subscriber] = TimeBasedSubscription(_endTimestamp);
843         emit SubscriptionImported(productId, subscriber, _endTimestamp);
844         return true;
845     }
846     function createProduct(bytes32 id, string memory name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds) public whenNotHalted {
847         _createProduct(id, name, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds, false);
848     }
849 
850     function createProductWithWhitelist(bytes32 id, string memory name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds) public whenNotHalted {
851         _createProduct(id, name, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds, true);
852         emit WhitelistEnabled(id);
853     }
854 
855 
856     function _createProduct(bytes32 id, string memory name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, bool requiresWhitelist) internal {
857         require(id != 0x0, "error_nullProductId");
858         require(pricePerSecond > 0, "error_freeProductsNotSupported");
859         (,address _owner,,,,,,) = getProduct(id);
860         require(_owner == address(0), "error_alreadyExists");
861         products[id] = Product({id: id, name: name, owner: msg.sender, beneficiary: beneficiary, pricePerSecond: pricePerSecond,
862             priceCurrency: currency, minimumSubscriptionSeconds: minimumSubscriptionSeconds, state: ProductState.Deployed, newOwnerCandidate: address(0), requiresWhitelist: requiresWhitelist});
863         emit ProductCreated(msg.sender, id, name, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds);
864     }
865 
866     /**
867     * Stop offering the product
868     */
869     function deleteProduct(bytes32 productId) public onlyProductOwner(productId) {
870         _importProductIfNeeded(productId);
871         Product storage p = products[productId];
872         require(p.state == ProductState.Deployed, "error_notDeployed");
873         p.state = ProductState.NotDeployed;
874         emit ProductDeleted(p.owner, productId, p.name, p.beneficiary, p.pricePerSecond, p.priceCurrency, p.minimumSubscriptionSeconds);
875     }
876 
877     /**
878     * Return product to market
879     */
880     function redeployProduct(bytes32 productId) public onlyProductOwner(productId) {
881         _importProductIfNeeded(productId);
882         Product storage p = products[productId];
883         require(p.state == ProductState.NotDeployed, "error_mustBeNotDeployed");
884         p.state = ProductState.Deployed;
885         emit ProductRedeployed(p.owner, productId, p.name, p.beneficiary, p.pricePerSecond, p.priceCurrency, p.minimumSubscriptionSeconds);
886     }
887 
888     function updateProduct(bytes32 productId, string memory name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, bool redeploy) public onlyProductOwner(productId) {
889         require(pricePerSecond > 0, "error_freeProductsNotSupported");
890         _importProductIfNeeded(productId);
891         Product storage p = products[productId];
892         p.name = name;
893         p.beneficiary = beneficiary;
894         p.pricePerSecond = pricePerSecond;
895         p.priceCurrency = currency;
896         p.minimumSubscriptionSeconds = minimumSubscriptionSeconds;
897         emit ProductUpdated(p.owner, p.id, name, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds);
898         if (redeploy) {
899             redeployProduct(productId);
900         }
901     }
902 
903     /**
904     * Changes ownership of the product. Two phase hand-over minimizes the chance that the product ownership is lost to a non-existent address.
905     */
906     function offerProductOwnership(bytes32 productId, address newOwnerCandidate) public onlyProductOwner(productId) {
907         _importProductIfNeeded(productId);
908         // that productId exists is already checked in onlyProductOwner
909         products[productId].newOwnerCandidate = newOwnerCandidate;
910         emit ProductOwnershipOffered(products[productId].owner, productId, newOwnerCandidate);
911     }
912 
913     /**
914     * Changes ownership of the product. Two phase hand-over minimizes the chance that the product ownership is lost to a non-existent address.
915     */
916     function claimProductOwnership(bytes32 productId) public whenNotHalted {
917         _importProductIfNeeded(productId);
918         // also checks that productId exists (newOwnerCandidate is zero for non-existent)
919         Product storage p = products[productId];
920         require(msg.sender == p.newOwnerCandidate, "error_notPermitted");
921         emit ProductOwnershipChanged(msg.sender, productId, p.owner);
922         p.owner = msg.sender;
923         p.newOwnerCandidate = address(0);
924     }
925 
926     /////////////// Whitelist management ///////////////
927 
928     function setRequiresWhitelist(bytes32 productId, bool _requiresWhitelist) public onlyProductOwner(productId) {
929         _importProductIfNeeded(productId);
930         Product storage p = products[productId];
931         require(p.id != 0x0, "error_notFound");
932         p.requiresWhitelist = _requiresWhitelist;
933         if (_requiresWhitelist) {
934             emit WhitelistEnabled(productId);
935         } else {
936             emit WhitelistDisabled(productId);
937         }
938     }
939 
940     function whitelistApprove(bytes32 productId, address subscriber) public onlyProductOwner(productId) {
941         _importProductIfNeeded(productId);
942         Product storage p = products[productId];
943         require(p.id != 0x0, "error_notFound");
944         require(p.requiresWhitelist, "error_whitelistNotEnabled");
945         p.whitelist[subscriber] = WhitelistState.Approved;
946         emit WhitelistApproved(productId, subscriber);
947     }
948 
949     function whitelistReject(bytes32 productId, address subscriber) public onlyProductOwner(productId) {
950         _importProductIfNeeded(productId);
951         Product storage p = products[productId];
952         require(p.id != 0x0, "error_notFound");
953         require(p.requiresWhitelist, "error_whitelistNotEnabled");
954         p.whitelist[subscriber] = WhitelistState.Rejected;
955         emit WhitelistRejected(productId, subscriber);
956     }
957 
958     function whitelistRequest(bytes32 productId) public {
959         _importProductIfNeeded(productId);
960         Product storage p = products[productId];
961         require(p.id != 0x0, "error_notFound");
962         require(p.requiresWhitelist, "error_whitelistNotEnabled");
963         require(p.whitelist[msg.sender] == WhitelistState.None, "error_whitelistRequestAlreadySubmitted");
964         p.whitelist[msg.sender] = WhitelistState.Pending;
965         emit WhitelistRequested(productId, msg.sender);
966     }
967 
968     function getWhitelistState(bytes32 productId, address subscriber) public view returns (WhitelistState wlstate) {
969         (, address _owner,,,,,,) = getProduct(productId);
970         require(_owner != address(0), "error_notFound");
971         // if product is not local (maybe in old marketplace) this will return 0 (WhitelistState.None)
972         Product storage p = products[productId];
973         return p.whitelist[subscriber];
974     }
975 
976     /////////////// Subscription management ///////////////
977 
978     function getSubscription(bytes32 productId, address subscriber) public override view returns (bool isValid, uint endTimestamp) {
979         (,address _owner,,,,,,) = _getProductLocal(productId);
980         if (_owner == address(0)) {
981             return prev_marketplace.getSubscription(productId,subscriber);
982         }
983 
984         (, TimeBasedSubscription storage sub) = _getSubscriptionLocal(productId, subscriber);
985         if (sub.endTimestamp == 0x0) {
986             // only call prev_marketplace.getSubscription() if product exists in previous marketplace too
987             (,address _owner_prev,,,,,) = prev_marketplace.getProduct(productId);
988             if (_owner_prev != address(0)) {
989                 return prev_marketplace.getSubscription(productId,subscriber);
990             }
991         }
992         return (_isValid(sub), sub.endTimestamp);
993     }
994 
995     function getSubscriptionTo(bytes32 productId) public view returns (bool isValid, uint endTimestamp) {
996         return getSubscription(productId, msg.sender);
997     }
998 
999     /**
1000      * Checks if the given address currently has a valid subscription
1001      * @param productId to check
1002      * @param subscriber to check
1003      */
1004     function hasValidSubscription(bytes32 productId, address subscriber) public view returns (bool isValid) {
1005         (isValid,) = getSubscription(productId, subscriber);
1006     }
1007 
1008     /**
1009      * Enforces payment rules, triggers PurchaseListener event
1010      */
1011     function _subscribe(bytes32 productId, uint addSeconds, address subscriber, bool requirePayment) internal {
1012         _importSubscriptionIfNeeded(productId, subscriber);
1013         (Product storage p, TimeBasedSubscription storage oldSub) = _getSubscriptionLocal(productId, subscriber);
1014         require(p.state == ProductState.Deployed, "error_notDeployed");
1015         require(!p.requiresWhitelist || p.whitelist[subscriber] == WhitelistState.Approved, "error_whitelistNotAllowed");
1016         uint endTimestamp;
1017 
1018         if (oldSub.endTimestamp > block.timestamp) {
1019             require(addSeconds > 0, "error_topUpTooSmall");
1020             endTimestamp = oldSub.endTimestamp.add(addSeconds);
1021             oldSub.endTimestamp = endTimestamp;
1022             emit SubscriptionExtended(p.id, subscriber, endTimestamp);
1023         } else {
1024             require(addSeconds >= p.minimumSubscriptionSeconds, "error_newSubscriptionTooSmall");
1025             endTimestamp = block.timestamp.add(addSeconds);
1026             TimeBasedSubscription memory newSub = TimeBasedSubscription(endTimestamp);
1027             p.subscriptions[subscriber] = newSub;
1028             emit NewSubscription(p.id, subscriber, endTimestamp);
1029         }
1030         emit Subscribed(p.id, subscriber, endTimestamp);
1031 
1032         uint256 price = 0;
1033         uint256 fee = 0;
1034         address recipient = p.beneficiary;
1035         if (requirePayment) {
1036             price = getPriceInData(addSeconds, p.pricePerSecond, p.priceCurrency);
1037             fee = txFee.mul(price).div(1 ether);
1038             require(datacoin.transferFrom(msg.sender, recipient, price.sub(fee)), "error_paymentFailed");
1039             if (fee > 0) {
1040                 require(datacoin.transferFrom(msg.sender, owner, fee), "error_paymentFailed");
1041             }
1042         }
1043 
1044         uint256 codeSize;
1045         assembly { codeSize := extcodesize(recipient) }  // solhint-disable-line no-inline-assembly
1046         if (codeSize > 0) {
1047             // solhint-disable-next-line avoid-low-level-calls
1048             (bool success, bytes memory returnData) = recipient.call(
1049                 abi.encodeWithSignature("onPurchase(bytes32,address,uint256,uint256,uint256)",
1050                 productId, subscriber, oldSub.endTimestamp, price, fee)
1051             );
1052 
1053             if (success) {
1054                 (bool accepted) = abi.decode(returnData, (bool));
1055                 require(accepted, "error_rejectedBySeller");
1056             }
1057         }
1058     }
1059 
1060     function grantSubscription(bytes32 productId, uint subscriptionSeconds, address recipient) public whenNotHalted onlyProductOwner(productId){
1061         return _subscribe(productId, subscriptionSeconds, recipient, false);
1062     }
1063 
1064 
1065     function buyFor(bytes32 productId, uint subscriptionSeconds, address recipient) public override whenNotHalted {
1066         return _subscribe(productId, subscriptionSeconds, recipient, true);
1067     }
1068 
1069 
1070     /**
1071      * Purchases access to this stream for msg.sender.
1072      * If the address already has a valid subscription, extends the subscription by the given period.
1073      * @dev since v4.0: Notify the seller if the seller implements PurchaseListener interface
1074      */
1075     function buy(bytes32 productId, uint subscriptionSeconds) public whenNotHalted {
1076         buyFor(productId,subscriptionSeconds, msg.sender);
1077     }
1078 
1079 
1080     /** Gets subscriptions info from the subscriptions stored in this contract */
1081     function _getSubscriptionLocal(bytes32 productId, address subscriber) internal view returns (Product storage p, TimeBasedSubscription storage s) {
1082         p = products[productId];
1083         require(p.id != 0x0, "error_notFound");
1084         s = p.subscriptions[subscriber];
1085     }
1086 
1087     function _isValid(TimeBasedSubscription storage s) internal view returns (bool) {
1088         return s.endTimestamp >= block.timestamp;  // solhint-disable-line not-rely-on-time
1089     }
1090 
1091     // TODO: transfer allowance to another Marketplace contract
1092     // Mechanism basically is that this Marketplace draws from the allowance and credits
1093     //   the account on another Marketplace; OR that there is a central credit pool (say, an ERC20 token)
1094     // Creating another ERC20 token for this could be a simple fix: it would need the ability to transfer allowances
1095 
1096     /////////////// Currency management ///////////////
1097 
1098     // Exchange rates are formatted as "decimal fixed-point", that is, scaled by 10^18, like ether.
1099     //        Exponent: 10^18 15 12  9  6  3  0
1100     //                      |  |  |  |  |  |  |
1101     uint public dataPerUsd = 100000000000000000;   // ~= 0.1 DATA/USD
1102 
1103     /**
1104     * Update currency exchange rates; all purchases are still billed in DATAcoin
1105     * @param timestamp in seconds when the exchange rates were last updated
1106     * @param dataUsd how many data atoms (10^-18 DATA) equal one USD dollar
1107     */
1108     function updateExchangeRates(uint timestamp, uint dataUsd) public {
1109         require(msg.sender == currencyUpdateAgent, "error_notPermitted");
1110         require(dataUsd > 0, "error_invalidRate");
1111         dataPerUsd = dataUsd;
1112         emit ExchangeRatesUpdated(timestamp, dataUsd);
1113     }
1114 
1115     /**
1116     * Helper function to calculate (hypothetical) subscription cost for given seconds and price, using current exchange rates.
1117     * @param subscriptionSeconds length of hypothetical subscription, as a non-scaled integer
1118     * @param price nominal price scaled by 10^18 ("token wei" or "attodollars")
1119     * @param unit unit of the number price
1120     */
1121     function getPriceInData(uint subscriptionSeconds, uint price, Currency unit) public override view returns (uint datacoinAmount) {
1122         if (unit == Currency.DATA) {
1123             return price.mul(subscriptionSeconds);
1124         }
1125         return price.mul(dataPerUsd).mul(subscriptionSeconds).div(10**18);
1126     }
1127 
1128     /////////////// Admin functionality ///////////////
1129 
1130     event Halted();
1131     event Resumed();
1132     bool public halted = false;
1133 
1134     modifier whenNotHalted() {
1135         require(!halted || owner == msg.sender, "error_halted");
1136         _;
1137     }
1138     function halt() public onlyOwner {
1139         halted = true;
1140         emit Halted();
1141     }
1142     function resume() public onlyOwner {
1143         halted = false;
1144         emit Resumed();
1145     }
1146 
1147     function reInitialize(address datacoinAddress, address currencyUpdateAgentAddress, address prev_marketplace_address) public onlyOwner {
1148         _initialize(datacoinAddress, currencyUpdateAgentAddress, prev_marketplace_address);
1149     }
1150 
1151     function setTxFee(uint256 newTxFee) public onlyOwner {
1152         require(newTxFee <= 1 ether, "error_invalidTxFee");
1153         txFee = newTxFee;
1154         emit TxFeeChanged(txFee);
1155     }
1156 }