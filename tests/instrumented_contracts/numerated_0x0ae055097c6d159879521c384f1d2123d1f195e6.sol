1 pragma solidity 0.5.10;
2 
3 /**
4  * @dev Collection of functions related to the address type,
5  */
6 library Address {
7     /**
8      * @dev Returns true if `account` is a contract.
9      *
10      * This test is non-exhaustive, and there may be false-negatives: during the
11      * execution of a contract's constructor, its address will be reported as
12      * not containing a contract.
13      *
14      * > It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      */
17     function isContract(address account) internal view returns (bool) {
18         // This method relies in extcodesize, which returns 0 for contracts in
19         // construction, since the code is only stored at the end of the
20         // constructor execution.
21 
22         uint256 size;
23         // solhint-disable-next-line no-inline-assembly
24         assembly { size := extcodesize(account) }
25         return size > 0;
26     }
27 }
28 
29 
30 interface IDistribution {
31     function supply() external view returns(uint256);
32     function poolAddress(uint8) external view returns(address);
33 }
34 
35 
36 
37 contract Sacrifice {
38     constructor(address payable _recipient) public payable {
39         selfdestruct(_recipient);
40     }
41 }
42 
43 
44 interface IERC677MultiBridgeToken {
45     function transfer(address _to, uint256 _value) external returns (bool);
46     function transferDistribution(address _to, uint256 _value) external returns (bool);
47     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
48     function balanceOf(address _account) external view returns (uint256);
49 }
50 
51 
52 
53 
54 
55 
56 
57 /**
58  * @dev Contract module which provides a basic access control mechanism, where
59  * there is an account (an owner) that can be granted exclusive access to
60  * specific functions.
61  *
62  * This module is used through inheritance. It will make available the modifier
63  * `onlyOwner`, which can be aplied to your functions to restrict their use to
64  * the owner.
65  */
66 contract Ownable {
67     address private _owner;
68 
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     /**
72      * @dev Initializes the contract setting the deployer as the initial owner.
73      */
74     constructor () internal {
75         _owner = msg.sender;
76         emit OwnershipTransferred(address(0), _owner);
77     }
78 
79     /**
80      * @dev Returns the address of the current owner.
81      */
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(isOwner(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     /**
95      * @dev Returns true if the caller is the current owner.
96      */
97     function isOwner() public view returns (bool) {
98         return msg.sender == _owner;
99     }
100 
101     /**
102      * @dev Leaves the contract without owner. It will not be possible to call
103      * `onlyOwner` functions anymore. Can only be called by the current owner.
104      *
105      * > Note: Renouncing ownership will leave the contract without an owner,
106      * thereby removing any functionality that is only available to the owner.
107      */
108     function renounceOwnership() public onlyOwner {
109         emit OwnershipTransferred(_owner, address(0));
110         _owner = address(0);
111     }
112 
113     /**
114      * @dev Transfers ownership of the contract to a new account (`newOwner`).
115      * Can only be called by the current owner.
116      */
117     function transferOwnership(address newOwner) public onlyOwner {
118         _transferOwnership(newOwner);
119     }
120 
121     /**
122      * @dev Transfers ownership of the contract to a new account (`newOwner`).
123      */
124     function _transferOwnership(address newOwner) internal {
125         require(newOwner != address(0), "Ownable: new owner is the zero address");
126         emit OwnershipTransferred(_owner, newOwner);
127         _owner = newOwner;
128     }
129 }
130 
131 
132 
133 
134 
135 /**
136  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
137  * the optional functions; to access them see `ERC20Detailed`.
138  */
139 interface IERC20 {
140     /**
141      * @dev Returns the amount of tokens in existence.
142      */
143     function totalSupply() external view returns (uint256);
144 
145     /**
146      * @dev Returns the amount of tokens owned by `account`.
147      */
148     function balanceOf(address account) external view returns (uint256);
149 
150     /**
151      * @dev Moves `amount` tokens from the caller's account to `recipient`.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a `Transfer` event.
156      */
157     function transfer(address recipient, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Returns the remaining number of tokens that `spender` will be
161      * allowed to spend on behalf of `owner` through `transferFrom`. This is
162      * zero by default.
163      *
164      * This value changes when `approve` or `transferFrom` are called.
165      */
166     function allowance(address owner, address spender) external view returns (uint256);
167 
168     /**
169      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * > Beware that changing an allowance with this method brings the risk
174      * that someone may use both the old and the new allowance by unfortunate
175      * transaction ordering. One possible solution to mitigate this race
176      * condition is to first reduce the spender's allowance to 0 and set the
177      * desired value afterwards:
178      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179      *
180      * Emits an `Approval` event.
181      */
182     function approve(address spender, uint256 amount) external returns (bool);
183 
184     /**
185      * @dev Moves `amount` tokens from `sender` to `recipient` using the
186      * allowance mechanism. `amount` is then deducted from the caller's
187      * allowance.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a `Transfer` event.
192      */
193     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
194 
195     /**
196      * @dev Emitted when `value` tokens are moved from one account (`from`) to
197      * another (`to`).
198      *
199      * Note that `value` may be zero.
200      */
201     event Transfer(address indexed from, address indexed to, uint256 value);
202 
203     /**
204      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
205      * a call to `approve`. `value` is the new allowance.
206      */
207     event Approval(address indexed owner, address indexed spender, uint256 value);
208 }
209 
210 
211 
212 /**
213  * @dev Wrappers over Solidity's arithmetic operations with added overflow
214  * checks.
215  *
216  * Arithmetic operations in Solidity wrap on overflow. This can easily result
217  * in bugs, because programmers usually assume that an overflow raises an
218  * error, which is the standard behavior in high level programming languages.
219  * `SafeMath` restores this intuition by reverting the transaction when an
220  * operation overflows.
221  *
222  * Using this library instead of the unchecked operations eliminates an entire
223  * class of bugs, so it's recommended to use it always.
224  */
225 library SafeMath {
226     /**
227      * @dev Returns the addition of two unsigned integers, reverting on
228      * overflow.
229      *
230      * Counterpart to Solidity's `+` operator.
231      *
232      * Requirements:
233      * - Addition cannot overflow.
234      */
235     function add(uint256 a, uint256 b) internal pure returns (uint256) {
236         uint256 c = a + b;
237         require(c >= a, "SafeMath: addition overflow");
238 
239         return c;
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting on
244      * overflow (when the result is negative).
245      *
246      * Counterpart to Solidity's `-` operator.
247      *
248      * Requirements:
249      * - Subtraction cannot overflow.
250      */
251     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
252         require(b <= a, "SafeMath: subtraction overflow");
253         uint256 c = a - b;
254 
255         return c;
256     }
257 
258     /**
259      * @dev Returns the multiplication of two unsigned integers, reverting on
260      * overflow.
261      *
262      * Counterpart to Solidity's `*` operator.
263      *
264      * Requirements:
265      * - Multiplication cannot overflow.
266      */
267     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
268         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
269         // benefit is lost if 'b' is also tested.
270         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
271         if (a == 0) {
272             return 0;
273         }
274 
275         uint256 c = a * b;
276         require(c / a == b, "SafeMath: multiplication overflow");
277 
278         return c;
279     }
280 
281     /**
282      * @dev Returns the integer division of two unsigned integers. Reverts on
283      * division by zero. The result is rounded towards zero.
284      *
285      * Counterpart to Solidity's `/` operator. Note: this function uses a
286      * `revert` opcode (which leaves remaining gas untouched) while Solidity
287      * uses an invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      * - The divisor cannot be zero.
291      */
292     function div(uint256 a, uint256 b) internal pure returns (uint256) {
293         // Solidity only automatically asserts when dividing by 0
294         require(b > 0, "SafeMath: division by zero");
295         uint256 c = a / b;
296         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
297 
298         return c;
299     }
300 
301     /**
302      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
303      * Reverts when dividing by zero.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      * - The divisor cannot be zero.
311      */
312     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
313         require(b != 0, "SafeMath: modulo by zero");
314         return a % b;
315     }
316 }
317 
318 
319 
320 /**
321  * @title SafeERC20
322  * @dev Wrappers around ERC20 operations that throw on failure (when the token
323  * contract returns false). Tokens that return no value (and instead revert or
324  * throw on failure) are also supported, non-reverting calls are assumed to be
325  * successful.
326  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
327  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
328  */
329 library SafeERC20 {
330     using SafeMath for uint256;
331     using Address for address;
332 
333     function safeTransfer(IERC20 token, address to, uint256 value) internal {
334         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
335     }
336 
337     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
338         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
339     }
340 
341     function safeApprove(IERC20 token, address spender, uint256 value) internal {
342         // safeApprove should only be called when setting an initial allowance,
343         // or when resetting it to zero. To increase and decrease it, use
344         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
345         // solhint-disable-next-line max-line-length
346         require((value == 0) || (token.allowance(address(this), spender) == 0),
347             "SafeERC20: approve from non-zero to non-zero allowance"
348         );
349         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
350     }
351 
352     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
353         uint256 newAllowance = token.allowance(address(this), spender).add(value);
354         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
355     }
356 
357     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
358         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
359         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
360     }
361 
362     /**
363      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
364      * on the return value: the return value is optional (but if data is returned, it must not be false).
365      * @param token The token targeted by the call.
366      * @param data The call data (encoded using abi.encode or one of its variants).
367      */
368     function callOptionalReturn(IERC20 token, bytes memory data) private {
369         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
370         // we're implementing it ourselves.
371 
372         // A Solidity high level call has three parts:
373         //  1. The target address is checked to verify it contains contract code
374         //  2. The call itself is made, and success asserted
375         //  3. The return value is decoded, which in turn checks the size of the returned data.
376         // solhint-disable-next-line max-line-length
377         require(address(token).isContract(), "SafeERC20: call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = address(token).call(data);
381         require(success, "SafeERC20: low-level call failed");
382 
383         if (returndata.length > 0) { // Return data is optional
384             // solhint-disable-next-line max-line-length
385             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
386         }
387     }
388 }
389 
390 
391 
392 
393 
394 
395 
396 
397 /**
398  * @dev Implementation of the `IERC20` interface.
399  *
400  * This implementation was taken from
401  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.3.0/contracts/token/ERC20/ERC20.sol
402  * This differs from the original one only in the definition for the `_balances`
403  * mapping: we made it `internal` instead of `private` since we use the `_balances`
404  * in the `ERC677BridgeToken` child contract to be able to transfer tokens to address(0)
405  * (see its `_superTransfer` function). The original OpenZeppelin implementation
406  * doesn't allow transferring to address(0).
407  *
408  * This implementation is agnostic to the way tokens are created. This means
409  * that a supply mechanism has to be added in a derived contract using `_mint`.
410  * For a generic mechanism see `ERC20Mintable`.
411  *
412  * *For a detailed writeup see our guide [How to implement supply
413  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
414  *
415  * We have followed general OpenZeppelin guidelines: functions revert instead
416  * of returning `false` on failure. This behavior is nonetheless conventional
417  * and does not conflict with the expectations of ERC20 applications.
418  *
419  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
420  * This allows applications to reconstruct the allowance for all accounts just
421  * by listening to said events. Other implementations of the EIP may not emit
422  * these events, as it isn't required by the specification.
423  *
424  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
425  * functions have been added to mitigate the well-known issues around setting
426  * allowances. See `IERC20.approve`.
427  */
428 contract ERC20 is IERC20 {
429     using SafeMath for uint256;
430 
431     mapping (address => uint256) internal _balances; // CHANGED: not private to write a custom transfer method
432 
433     mapping (address => mapping (address => uint256)) private _allowances;
434 
435     uint256 private _totalSupply;
436 
437     /**
438      * @dev See `IERC20.totalSupply`.
439      */
440     function totalSupply() public view returns (uint256) {
441         return _totalSupply;
442     }
443 
444     /**
445      * @dev See `IERC20.balanceOf`.
446      */
447     function balanceOf(address account) public view returns (uint256) {
448         return _balances[account];
449     }
450 
451     /**
452      * @dev See `IERC20.transfer`.
453      *
454      * Requirements:
455      *
456      * - `recipient` cannot be the zero address.
457      * - the caller must have a balance of at least `amount`.
458      */
459     function transfer(address recipient, uint256 amount) public returns (bool) {
460         _transfer(msg.sender, recipient, amount);
461         return true;
462     }
463 
464     /**
465      * @dev See `IERC20.allowance`.
466      */
467     function allowance(address owner, address spender) public view returns (uint256) {
468         return _allowances[owner][spender];
469     }
470 
471     /**
472      * @dev See `IERC20.approve`.
473      *
474      * Requirements:
475      *
476      * - `spender` cannot be the zero address.
477      */
478     function approve(address spender, uint256 value) public returns (bool) {
479         _approve(msg.sender, spender, value);
480         return true;
481     }
482 
483     /**
484      * @dev See `IERC20.transferFrom`.
485      *
486      * Emits an `Approval` event indicating the updated allowance. This is not
487      * required by the EIP. See the note at the beginning of `ERC20`;
488      *
489      * Requirements:
490      * - `sender` and `recipient` cannot be the zero address.
491      * - `sender` must have a balance of at least `value`.
492      * - the caller must have allowance for `sender`'s tokens of at least
493      * `amount`.
494      */
495     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
496         _transfer(sender, recipient, amount);
497         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
498         return true;
499     }
500 
501     /**
502      * @dev Atomically increases the allowance granted to `spender` by the caller.
503      *
504      * This is an alternative to `approve` that can be used as a mitigation for
505      * problems described in `IERC20.approve`.
506      *
507      * Emits an `Approval` event indicating the updated allowance.
508      *
509      * Requirements:
510      *
511      * - `spender` cannot be the zero address.
512      */
513     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
514         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
515         return true;
516     }
517 
518     /**
519      * @dev Atomically decreases the allowance granted to `spender` by the caller.
520      *
521      * This is an alternative to `approve` that can be used as a mitigation for
522      * problems described in `IERC20.approve`.
523      *
524      * Emits an `Approval` event indicating the updated allowance.
525      *
526      * Requirements:
527      *
528      * - `spender` cannot be the zero address.
529      * - `spender` must have allowance for the caller of at least
530      * `subtractedValue`.
531      */
532     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
533         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
534         return true;
535     }
536 
537     /**
538      * @dev Moves tokens `amount` from `sender` to `recipient`.
539      *
540      * This is internal function is equivalent to `transfer`, and can be used to
541      * e.g. implement automatic token fees, slashing mechanisms, etc.
542      *
543      * Emits a `Transfer` event.
544      *
545      * Requirements:
546      *
547      * - `sender` cannot be the zero address.
548      * - `recipient` cannot be the zero address.
549      * - `sender` must have a balance of at least `amount`.
550      */
551     function _transfer(address sender, address recipient, uint256 amount) internal {
552         require(sender != address(0), "ERC20: transfer from the zero address");
553         require(recipient != address(0), "ERC20: transfer to the zero address");
554 
555         _balances[sender] = _balances[sender].sub(amount);
556         _balances[recipient] = _balances[recipient].add(amount);
557         emit Transfer(sender, recipient, amount);
558     }
559 
560     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
561      * the total supply.
562      *
563      * Emits a `Transfer` event with `from` set to the zero address.
564      *
565      * Requirements
566      *
567      * - `to` cannot be the zero address.
568      */
569     function _mint(address account, uint256 amount) internal {
570         require(account != address(0), "ERC20: mint to the zero address");
571 
572         _totalSupply = _totalSupply.add(amount);
573         _balances[account] = _balances[account].add(amount);
574         emit Transfer(address(0), account, amount);
575     }
576 
577      /**
578      * @dev Destoys `amount` tokens from `account`, reducing the
579      * total supply.
580      *
581      * Emits a `Transfer` event with `to` set to the zero address.
582      *
583      * Requirements
584      *
585      * - `account` cannot be the zero address.
586      * - `account` must have at least `amount` tokens.
587      */
588     function _burn(address account, uint256 value) internal {
589         require(account != address(0), "ERC20: burn from the zero address");
590 
591         _totalSupply = _totalSupply.sub(value);
592         _balances[account] = _balances[account].sub(value);
593         emit Transfer(account, address(0), value);
594     }
595 
596     /**
597      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
598      *
599      * This is internal function is equivalent to `approve`, and can be used to
600      * e.g. set automatic allowances for certain subsystems, etc.
601      *
602      * Emits an `Approval` event.
603      *
604      * Requirements:
605      *
606      * - `owner` cannot be the zero address.
607      * - `spender` cannot be the zero address.
608      */
609     function _approve(address owner, address spender, uint256 value) internal {
610         require(owner != address(0), "ERC20: approve from the zero address");
611         require(spender != address(0), "ERC20: approve to the zero address");
612 
613         _allowances[owner][spender] = value;
614         emit Approval(owner, spender, value);
615     }
616 
617     /**
618      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
619      * from the caller's allowance.
620      *
621      * See `_burn` and `_approve`.
622      */
623     function _burnFrom(address account, uint256 amount) internal {
624         _burn(account, amount);
625         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
626     }
627 }
628 
629 
630 
631 
632 
633 /**
634  * @dev Optional functions from the ERC20 standard.
635  */
636 contract ERC20Detailed is IERC20 {
637     string private _name;
638     string private _symbol;
639     uint8 private _decimals;
640 
641     /**
642      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
643      * these values are immutable: they can only be set once during
644      * construction.
645      */
646     constructor (string memory name, string memory symbol, uint8 decimals) public {
647         _name = name;
648         _symbol = symbol;
649         _decimals = decimals;
650     }
651 
652     /**
653      * @dev Returns the name of the token.
654      */
655     function name() public view returns (string memory) {
656         return _name;
657     }
658 
659     /**
660      * @dev Returns the symbol of the token, usually a shorter version of the
661      * name.
662      */
663     function symbol() public view returns (string memory) {
664         return _symbol;
665     }
666 
667     /**
668      * @dev Returns the number of decimals used to get its user representation.
669      * For example, if `decimals` equals `2`, a balance of `505` tokens should
670      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
671      *
672      * Tokens usually opt for a value of 18, imitating the relationship between
673      * Ether and Wei.
674      *
675      * > Note that this information is only used for _display_ purposes: it in
676      * no way affects any of the arithmetic of the contract, including
677      * `IERC20.balanceOf` and `IERC20.transfer`.
678      */
679     function decimals() public view returns (uint8) {
680         return _decimals;
681     }
682 }
683 
684 
685 
686 /**
687  * @title ERC20Permittable
688  * @dev This is ERC20 contract extended by the `permit` function (see EIP712).
689  */
690 contract ERC20Permittable is ERC20, ERC20Detailed {
691 
692     string public constant version = "1";
693 
694     // EIP712 niceties
695     bytes32 public DOMAIN_SEPARATOR;
696     // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)");
697     bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
698 
699     mapping(address => uint256) public nonces;
700     mapping(address => mapping(address => uint256)) public expirations;
701 
702     constructor(
703         string memory _name,
704         string memory _symbol,
705         uint8 _decimals
706     ) ERC20Detailed(_name, _symbol, _decimals) public {
707         DOMAIN_SEPARATOR = keccak256(abi.encode(
708             keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
709             keccak256(bytes(_name)),
710             keccak256(bytes(version)),
711             1, // Chain ID for Ethereum Mainnet
712             address(this)
713         ));
714     }
715 
716     /// @dev transferFrom in this contract works in a slightly different form than the generic
717     /// transferFrom function. This contract allows for "unlimited approval".
718     /// Should the user approve an address for the maximum uint256 value,
719     /// then that address will have unlimited approval until told otherwise.
720     /// @param _sender The address of the sender.
721     /// @param _recipient The address of the recipient.
722     /// @param _amount The value to transfer.
723     /// @return Success status.
724     function transferFrom(address _sender, address _recipient, uint256 _amount) public returns (bool) {
725         _transfer(_sender, _recipient, _amount);
726 
727         if (_sender != msg.sender) {
728             uint256 allowedAmount = allowance(_sender, msg.sender);
729 
730             if (allowedAmount != uint256(-1)) {
731                 // If allowance is limited, adjust it.
732                 // In this case `transferFrom` works like the generic
733                 _approve(_sender, msg.sender, allowedAmount.sub(_amount));
734             } else {
735                 // If allowance is unlimited by `permit`, `approve`, or `increaseAllowance`
736                 // function, don't adjust it. But the expiration date must be empty or in the future
737                 require(
738                     expirations[_sender][msg.sender] == 0 || expirations[_sender][msg.sender] >= _now(),
739                     "expiry is in the past"
740                 );
741             }
742         } else {
743             // If `_sender` is `msg.sender`,
744             // the function works just like `transfer()`
745         }
746 
747         return true;
748     }
749 
750     /// @dev An alias for `transfer` function.
751     /// @param _to The address of the recipient.
752     /// @param _amount The value to transfer.
753     function push(address _to, uint256 _amount) public {
754         transferFrom(msg.sender, _to, _amount);
755     }
756 
757     /// @dev Makes a request to transfer the specified amount
758     /// from the specified address to the caller's address.
759     /// @param _from The address of the holder.
760     /// @param _amount The value to transfer.
761     function pull(address _from, uint256 _amount) public {
762         transferFrom(_from, msg.sender, _amount);
763     }
764 
765     /// @dev An alias for `transferFrom` function.
766     /// @param _from The address of the sender.
767     /// @param _to The address of the recipient.
768     /// @param _amount The value to transfer.
769     function move(address _from, address _to, uint256 _amount) public {
770         transferFrom(_from, _to, _amount);
771     }
772 
773     /// @dev Allows to spend holder's unlimited amount by the specified spender.
774     /// The function can be called by anyone, but requires having allowance parameters
775     /// signed by the holder according to EIP712.
776     /// @param _holder The holder's address.
777     /// @param _spender The spender's address.
778     /// @param _nonce The nonce taken from `nonces(_holder)` public getter.
779     /// @param _expiry The allowance expiration date (unix timestamp in UTC).
780     /// Can be zero for no expiration. Forced to zero if `_allowed` is `false`.
781     /// @param _allowed True to enable unlimited allowance for the spender by the holder. False to disable.
782     /// @param _v A final byte of signature (ECDSA component).
783     /// @param _r The first 32 bytes of signature (ECDSA component).
784     /// @param _s The second 32 bytes of signature (ECDSA component).
785     function permit(
786         address _holder,
787         address _spender,
788         uint256 _nonce,
789         uint256 _expiry,
790         bool _allowed,
791         uint8 _v,
792         bytes32 _r,
793         bytes32 _s
794     ) external {
795         require(_expiry == 0 || _now() <= _expiry, "invalid expiry");
796 
797         bytes32 digest = keccak256(abi.encodePacked(
798             "\x19\x01",
799             DOMAIN_SEPARATOR,
800             keccak256(abi.encode(
801                 PERMIT_TYPEHASH,
802                 _holder,
803                 _spender,
804                 _nonce,
805                 _expiry,
806                 _allowed
807             ))
808         ));
809 
810         require(_holder == ecrecover(digest, _v, _r, _s), "invalid signature or parameters");
811         require(_nonce == nonces[_holder]++, "invalid nonce");
812 
813         uint256 amount = _allowed ? uint256(-1) : 0;
814         _approve(_holder, _spender, amount);
815 
816         expirations[_holder][_spender] = _allowed ? _expiry : 0;
817     }
818 
819     function _now() internal view returns(uint256) {
820         return now;
821     }
822 
823 }
824 
825 
826 
827 
828 
829 // This is a base staking token ERC677 contract for Ethereum Mainnet side
830 // which is derived by the child ERC677MultiBridgeToken contract.
831 contract ERC677BridgeToken is Ownable, ERC20Permittable {
832     using SafeERC20 for ERC20;
833     using Address for address;
834 
835     ///  @dev Distribution contract address.
836     address public distributionAddress;
837     ///  @dev The PrivateOffering contract address.
838     address public privateOfferingDistributionAddress;
839     ///  @dev The AdvisorsReward contract address.
840     address public advisorsRewardDistributionAddress;
841 
842     /// @dev Mint event.
843     /// @param to To address.
844     /// @param amount Minted value.
845     event Mint(address indexed to, uint256 amount);
846 
847     /// @dev Modified Transfer event with custom data.
848     /// @param from From address.
849     /// @param to To address.
850     /// @param value Transferred value.
851     /// @param data Custom data to call after transfer.
852     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
853 
854     /// @dev Emits if custom call after transfer fails.
855     /// @param from From address.
856     /// @param to To address.
857     /// @param value Transferred value.
858     event ContractFallbackCallFailed(address from, address to, uint256 value);
859 
860     /// @dev Checks that the recipient address is valid.
861     /// @param _recipient Recipient address.
862     modifier validRecipient(address _recipient) {
863         require(_recipient != address(0) && _recipient != address(this), "not a valid recipient");
864         _;
865     }
866 
867     /// @dev Reverts if called by any account other than the bridge.
868     modifier onlyBridge() {
869         require(isBridge(msg.sender), "caller is not the bridge");
870         _;
871     }
872 
873     /// @dev Creates a token and mints the whole supply for the Distribution contract.
874     /// @param _name Token name.
875     /// @param _symbol Token symbol.
876     /// @param _distributionAddress The address of the deployed Distribution contract.
877     /// @param _privateOfferingDistributionAddress The address of the PrivateOffering contract.
878     /// @param _advisorsRewardDistributionAddress The address of the AdvisorsReward contract.
879     constructor(
880         string memory _name,
881         string memory _symbol,
882         address _distributionAddress,
883         address _privateOfferingDistributionAddress,
884         address _advisorsRewardDistributionAddress
885     ) ERC20Permittable(_name, _symbol, 18) public {
886         require(
887             _distributionAddress.isContract() &&
888             _privateOfferingDistributionAddress.isContract() &&
889             _advisorsRewardDistributionAddress.isContract(),
890             "not a contract address"
891         );
892         uint256 supply = IDistribution(_distributionAddress).supply();
893         require(supply > 0, "the supply must be more than 0");
894         _mint(_distributionAddress, supply);
895         distributionAddress = _distributionAddress;
896         privateOfferingDistributionAddress = _privateOfferingDistributionAddress;
897         advisorsRewardDistributionAddress = _advisorsRewardDistributionAddress;
898         emit Mint(_distributionAddress, supply);
899     }
900 
901     /// @dev Checks if given address is included into bridge contracts list.
902     /// Implemented by a child contract.
903     /// @param _address Bridge contract address.
904     /// @return bool true, if given address is a known bridge contract.
905     function isBridge(address _address) public view returns (bool);
906 
907     /// @dev Extends transfer method with callback.
908     /// @param _to The address of the recipient.
909     /// @param _value The value to transfer.
910     /// @param _data Custom data.
911     /// @return Success status.
912     function transferAndCall(
913         address _to,
914         uint256 _value,
915         bytes calldata _data
916     ) external validRecipient(_to) returns (bool) {
917         _superTransfer(_to, _value);
918         emit Transfer(msg.sender, _to, _value, _data);
919 
920         if (_to.isContract()) {
921             require(_contractFallback(msg.sender, _to, _value, _data), "contract call failed");
922         }
923         return true;
924     }
925 
926     /// @dev Extends transfer method with event when the callback failed.
927     /// @param _to The address of the recipient.
928     /// @param _value The value to transfer.
929     /// @return Success status.
930     function transfer(address _to, uint256 _value) public returns (bool) {
931         _superTransfer(_to, _value);
932         _callAfterTransfer(msg.sender, _to, _value);
933         return true;
934     }
935 
936     /// @dev This is a copy of `transfer` function which can only be called by distribution contracts.
937     /// Made to get rid of `onTokenTransfer` calling to save gas when distributing tokens.
938     /// @param _to The address of the recipient.
939     /// @param _value The value to transfer.
940     /// @return Success status.
941     function transferDistribution(address _to, uint256 _value) public returns (bool) {
942         require(
943             msg.sender == distributionAddress ||
944             msg.sender == privateOfferingDistributionAddress ||
945             msg.sender == advisorsRewardDistributionAddress,
946             "wrong sender"
947         );
948         _superTransfer(_to, _value);
949         return true;
950     }
951 
952     /// @dev Extends transferFrom method with event when the callback failed.
953     /// @param _from The address of the sender.
954     /// @param _to The address of the recipient.
955     /// @param _value The value to transfer.
956     /// @return Success status.
957     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
958         _superTransferFrom(_from, _to, _value);
959         _callAfterTransfer(_from, _to, _value);
960         return true;
961     }
962 
963     /// @dev If someone sent eth/tokens to the contract mistakenly then the owner can send them back.
964     /// @param _token The token address to transfer.
965     /// @param _to The address of the recipient.
966     function claimTokens(address _token, address payable _to) public onlyOwner validRecipient(_to) {
967         if (_token == address(0)) {
968             uint256 value = address(this).balance;
969             if (!_to.send(value)) { // solium-disable-line security/no-send
970                 // We use the `Sacrifice` trick to be sure the coins can be 100% sent to the receiver.
971                 // Otherwise, if the receiver is a contract which has a revert in its fallback function,
972                 // the sending will fail.
973                 (new Sacrifice).value(value)(_to);
974             }
975         } else {
976             ERC20 token = ERC20(_token);
977             uint256 balance = token.balanceOf(address(this));
978             token.safeTransfer(_to, balance);
979         }
980     }
981 
982     /// @dev Creates `amount` tokens and assigns them to `account`, increasing
983     /// the total supply. Emits a `Transfer` event with `from` set to the zero address.
984     /// Can only be called by a bridge contract which address is set with `addBridge`.
985     /// @param _account The address to mint tokens for. Cannot be zero address.
986     /// @param _amount The amount of tokens to mint.
987     function mint(address _account, uint256 _amount) external onlyBridge returns(bool) {
988         _mint(_account, _amount);
989         emit Mint(_account, _amount);
990         return true;
991     }
992 
993     /// @dev The removed implementation of the ownership renouncing.
994     function renounceOwnership() public onlyOwner {
995         revert("not implemented");
996     }
997 
998     /// @dev Calls transfer method and reverts if it fails.
999     /// @param _to The address of the recipient.
1000     /// @param _value The value to transfer.
1001     function _superTransfer(address _to, uint256 _value) internal {
1002         bool success;
1003         if (
1004             msg.sender == distributionAddress ||
1005             msg.sender == privateOfferingDistributionAddress ||
1006             msg.sender == advisorsRewardDistributionAddress
1007         ) {
1008             // Allow sending tokens to `address(0)` by
1009             // Distribution, PrivateOffering, or AdvisorsReward contract
1010             _balances[msg.sender] = _balances[msg.sender].sub(_value);
1011             _balances[_to] = _balances[_to].add(_value);
1012             emit Transfer(msg.sender, _to, _value);
1013             success = true;
1014         } else {
1015             success = super.transfer(_to, _value);
1016         }
1017         require(success, "transfer failed");
1018     }
1019 
1020     /// @dev Calls transferFrom method and reverts if it fails.
1021     /// @param _from The address of the sender.
1022     /// @param _to The address of the recipient.
1023     /// @param _value The value to transfer.
1024     function _superTransferFrom(address _from, address _to, uint256 _value) internal {
1025         bool success = super.transferFrom(_from, _to, _value);
1026         require(success, "transfer failed");
1027     }
1028 
1029     /// @dev Emits an event when the callback failed.
1030     /// @param _from The address of the sender.
1031     /// @param _to The address of the recipient.
1032     /// @param _value The transferred value.
1033     function _callAfterTransfer(address _from, address _to, uint256 _value) internal {
1034         if (_to.isContract() && !_contractFallback(_from, _to, _value, new bytes(0))) {
1035             require(!isBridge(_to), "you can't transfer to bridge contract");
1036             require(_to != distributionAddress, "you can't transfer to Distribution contract");
1037             require(_to != privateOfferingDistributionAddress, "you can't transfer to PrivateOffering contract");
1038             require(_to != advisorsRewardDistributionAddress, "you can't transfer to AdvisorsReward contract");
1039             emit ContractFallbackCallFailed(_from, _to, _value);
1040         }
1041     }
1042 
1043     /// @dev Makes a callback after the transfer of tokens.
1044     /// @param _from The address of the sender.
1045     /// @param _to The address of the recipient.
1046     /// @param _value The transferred value.
1047     /// @param _data Custom data.
1048     /// @return Success status.
1049     function _contractFallback(
1050         address _from,
1051         address _to,
1052         uint256 _value,
1053         bytes memory _data
1054     ) private returns (bool) {
1055         string memory signature = "onTokenTransfer(address,uint256,bytes)";
1056         // solium-disable-next-line security/no-low-level-calls
1057         (bool success, ) = _to.call(abi.encodeWithSignature(signature, _from, _value, _data));
1058         return success;
1059     }
1060 }
1061 
1062 
1063 
1064 
1065 /**
1066  * @title ERC677MultiBridgeToken
1067  * @dev This contract extends ERC677BridgeToken to support several bridges simultaneously.
1068  */
1069 contract ERC677MultiBridgeToken is IERC677MultiBridgeToken, ERC677BridgeToken {
1070     address public constant F_ADDR = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
1071     uint256 internal constant MAX_BRIDGES = 50;
1072     mapping(address => address) public bridgePointers;
1073     uint256 public bridgeCount;
1074 
1075     event BridgeAdded(address indexed bridge);
1076     event BridgeRemoved(address indexed bridge);
1077 
1078     constructor(
1079         string memory _name,
1080         string memory _symbol,
1081         address _distributionAddress,
1082         address _privateOfferingDistributionAddress,
1083         address _advisorsRewardDistributionAddress
1084     ) public ERC677BridgeToken(
1085         _name,
1086         _symbol,
1087         _distributionAddress,
1088         _privateOfferingDistributionAddress,
1089         _advisorsRewardDistributionAddress
1090     ) {
1091         bridgePointers[F_ADDR] = F_ADDR; // empty bridge contracts list
1092     }
1093 
1094     /// @dev Adds one more bridge contract into the list.
1095     /// @param _bridge Bridge contract address.
1096     function addBridge(address _bridge) external onlyOwner {
1097         require(bridgeCount < MAX_BRIDGES, "can't add one more bridge due to a limit");
1098         require(_bridge.isContract(), "not a contract address");
1099         require(!isBridge(_bridge), "bridge already exists");
1100 
1101         address firstBridge = bridgePointers[F_ADDR];
1102         require(firstBridge != address(0), "first bridge is zero address");
1103         bridgePointers[F_ADDR] = _bridge;
1104         bridgePointers[_bridge] = firstBridge;
1105         bridgeCount = bridgeCount.add(1);
1106 
1107         emit BridgeAdded(_bridge);
1108     }
1109 
1110     /// @dev Removes one existing bridge contract from the list.
1111     /// @param _bridge Bridge contract address.
1112     function removeBridge(address _bridge) external onlyOwner {
1113         require(isBridge(_bridge), "bridge isn't existed");
1114 
1115         address nextBridge = bridgePointers[_bridge];
1116         address index = F_ADDR;
1117         address next = bridgePointers[index];
1118         require(next != address(0), "zero address found");
1119 
1120         while (next != _bridge) {
1121             index = next;
1122             next = bridgePointers[index];
1123 
1124             require(next != F_ADDR && next != address(0), "invalid address found");
1125         }
1126 
1127         bridgePointers[index] = nextBridge;
1128         delete bridgePointers[_bridge];
1129         bridgeCount = bridgeCount.sub(1);
1130 
1131         emit BridgeRemoved(_bridge);
1132     }
1133 
1134     /// @dev Returns all recorded bridge contract addresses.
1135     /// @return address[] Bridge contract addresses.
1136     function bridgeList() external view returns (address[] memory) {
1137         address[] memory list = new address[](bridgeCount);
1138         uint256 counter = 0;
1139         address nextBridge = bridgePointers[F_ADDR];
1140         require(nextBridge != address(0), "zero address found");
1141 
1142         while (nextBridge != F_ADDR) {
1143             list[counter] = nextBridge;
1144             nextBridge = bridgePointers[nextBridge];
1145             counter++;
1146 
1147             require(nextBridge != address(0), "zero address found");
1148         }
1149 
1150         return list;
1151     }
1152 
1153     /// @dev Checks if given address is included into bridge contracts list.
1154     /// @param _address Bridge contract address.
1155     /// @return bool true, if given address is a known bridge contract.
1156     function isBridge(address _address) public view returns (bool) {
1157         return _address != F_ADDR && bridgePointers[_address] != address(0);
1158     }
1159 }