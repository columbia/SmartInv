1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      *
55      * _Available since v2.4.0._
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      *
113      * _Available since v2.4.0._
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      *
150      * _Available since v2.4.0._
151      */
152     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b != 0, errorMessage);
154         return a % b;
155     }
156 }
157 
158 
159 /**
160  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
161  * the optional functions; to access them see {ERC20Detailed}.
162  */
163 interface IERC20 {
164     /**
165      * @dev Returns the amount of tokens in existence.
166      */
167     function totalSupply() external view returns (uint256);
168 
169     /**
170      * @dev Returns the amount of tokens owned by `account`.
171      */
172     function balanceOf(address account) external view returns (uint256);
173 
174     /**
175      * @dev Moves `amount` tokens from the caller's account to `recipient`.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transfer(address recipient, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Returns the remaining number of tokens that `spender` will be
185      * allowed to spend on behalf of `owner` through {transferFrom}. This is
186      * zero by default.
187      *
188      * This value changes when {approve} or {transferFrom} are called.
189      */
190     function allowance(address owner, address spender) external view returns (uint256);
191 
192     /**
193      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * IMPORTANT: Beware that changing an allowance with this method brings the risk
198      * that someone may use both the old and the new allowance by unfortunate
199      * transaction ordering. One possible solution to mitigate this race
200      * condition is to first reduce the spender's allowance to 0 and set the
201      * desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      *
204      * Emits an {Approval} event.
205      */
206     function approve(address spender, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Moves `amount` tokens from `sender` to `recipient` using the
210      * allowance mechanism. `amount` is then deducted from the caller's
211      * allowance.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Emitted when `value` tokens are moved from one account (`from`) to
221      * another (`to`).
222      *
223      * Note that `value` may be zero.
224      */
225     event Transfer(address indexed from, address indexed to, uint256 value);
226 
227     /**
228      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
229      * a call to {approve}. `value` is the new allowance.
230      */
231     event Approval(address indexed owner, address indexed spender, uint256 value);
232 }
233 
234 
235 
236 
237 
238 
239 /*
240  * @dev Provides information about the current execution context, including the
241  * sender of the transaction and its data. While these are generally available
242  * via msg.sender and msg.data, they should not be accessed in such a direct
243  * manner, since when dealing with GSN meta-transactions the account sending and
244  * paying for execution may not be the actual sender (as far as an application
245  * is concerned).
246  *
247  * This contract is only required for intermediate, library-like contracts.
248  */
249 contract Context {
250     // Empty internal constructor, to prevent people from mistakenly deploying
251     // an instance of this contract, which should be used via inheritance.
252     constructor () internal { }
253     // solhint-disable-previous-line no-empty-blocks
254 
255     function _msgSender() internal view returns (address payable) {
256         return msg.sender;
257     }
258 
259     function _msgData() internal view returns (bytes memory) {
260         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
261         return msg.data;
262     }
263 }
264 
265 
266 
267 
268 /**
269  * @dev Implementation of the {IERC20} interface.
270  *
271  * This implementation is agnostic to the way tokens are created. This means
272  * that a supply mechanism has to be added in a derived contract using {_mint}.
273  * For a generic mechanism see {ERC20Mintable}.
274  *
275  * TIP: For a detailed writeup see our guide
276  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
277  * to implement supply mechanisms].
278  *
279  * We have followed general OpenZeppelin guidelines: functions revert instead
280  * of returning `false` on failure. This behavior is nonetheless conventional
281  * and does not conflict with the expectations of ERC20 applications.
282  *
283  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
284  * This allows applications to reconstruct the allowance for all accounts just
285  * by listening to said events. Other implementations of the EIP may not emit
286  * these events, as it isn't required by the specification.
287  *
288  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
289  * functions have been added to mitigate the well-known issues around setting
290  * allowances. See {IERC20-approve}.
291  */
292 contract ERC20 is Context, IERC20 {
293     using SafeMath for uint256;
294 
295     mapping (address => uint256) private _balances;
296 
297     mapping (address => mapping (address => uint256)) private _allowances;
298 
299     uint256 private _totalSupply;
300 
301     /**
302      * @dev See {IERC20-totalSupply}.
303      */
304     function totalSupply() public view returns (uint256) {
305         return _totalSupply;
306     }
307 
308     /**
309      * @dev See {IERC20-balanceOf}.
310      */
311     function balanceOf(address account) public view returns (uint256) {
312         return _balances[account];
313     }
314 
315     /**
316      * @dev See {IERC20-transfer}.
317      *
318      * Requirements:
319      *
320      * - `recipient` cannot be the zero address.
321      * - the caller must have a balance of at least `amount`.
322      */
323     function transfer(address recipient, uint256 amount) public returns (bool) {
324         _transfer(_msgSender(), recipient, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See {IERC20-allowance}.
330      */
331     function allowance(address owner, address spender) public view returns (uint256) {
332         return _allowances[owner][spender];
333     }
334 
335     /**
336      * @dev See {IERC20-approve}.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      */
342     function approve(address spender, uint256 amount) public returns (bool) {
343         _approve(_msgSender(), spender, amount);
344         return true;
345     }
346 
347     /**
348      * @dev See {IERC20-transferFrom}.
349      *
350      * Emits an {Approval} event indicating the updated allowance. This is not
351      * required by the EIP. See the note at the beginning of {ERC20};
352      *
353      * Requirements:
354      * - `sender` and `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      * - the caller must have allowance for `sender`'s tokens of at least
357      * `amount`.
358      */
359     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
360         _transfer(sender, recipient, amount);
361         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
362         return true;
363     }
364 
365     /**
366      * @dev Atomically increases the allowance granted to `spender` by the caller.
367      *
368      * This is an alternative to {approve} that can be used as a mitigation for
369      * problems described in {IERC20-approve}.
370      *
371      * Emits an {Approval} event indicating the updated allowance.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      */
377     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
378         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
379         return true;
380     }
381 
382     /**
383      * @dev Atomically decreases the allowance granted to `spender` by the caller.
384      *
385      * This is an alternative to {approve} that can be used as a mitigation for
386      * problems described in {IERC20-approve}.
387      *
388      * Emits an {Approval} event indicating the updated allowance.
389      *
390      * Requirements:
391      *
392      * - `spender` cannot be the zero address.
393      * - `spender` must have allowance for the caller of at least
394      * `subtractedValue`.
395      */
396     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
397         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
398         return true;
399     }
400 
401     /**
402      * @dev Moves tokens `amount` from `sender` to `recipient`.
403      *
404      * This is internal function is equivalent to {transfer}, and can be used to
405      * e.g. implement automatic token fees, slashing mechanisms, etc.
406      *
407      * Emits a {Transfer} event.
408      *
409      * Requirements:
410      *
411      * - `sender` cannot be the zero address.
412      * - `recipient` cannot be the zero address.
413      * - `sender` must have a balance of at least `amount`.
414      */
415     function _transfer(address sender, address recipient, uint256 amount) internal {
416         require(sender != address(0), "ERC20: transfer from the zero address");
417         require(recipient != address(0), "ERC20: transfer to the zero address");
418 
419         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
420         _balances[recipient] = _balances[recipient].add(amount);
421         emit Transfer(sender, recipient, amount);
422     }
423 
424     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
425      * the total supply.
426      *
427      * Emits a {Transfer} event with `from` set to the zero address.
428      *
429      * Requirements
430      *
431      * - `to` cannot be the zero address.
432      */
433     function _mint(address account, uint256 amount) internal {
434         require(account != address(0), "ERC20: mint to the zero address");
435 
436         _totalSupply = _totalSupply.add(amount);
437         _balances[account] = _balances[account].add(amount);
438         emit Transfer(address(0), account, amount);
439     }
440 
441     /**
442      * @dev Destroys `amount` tokens from `account`, reducing the
443      * total supply.
444      *
445      * Emits a {Transfer} event with `to` set to the zero address.
446      *
447      * Requirements
448      *
449      * - `account` cannot be the zero address.
450      * - `account` must have at least `amount` tokens.
451      */
452     function _burn(address account, uint256 amount) internal {
453         require(account != address(0), "ERC20: burn from the zero address");
454 
455         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
456         _totalSupply = _totalSupply.sub(amount);
457         emit Transfer(account, address(0), amount);
458     }
459 
460     /**
461      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
462      *
463      * This is internal function is equivalent to `approve`, and can be used to
464      * e.g. set automatic allowances for certain subsystems, etc.
465      *
466      * Emits an {Approval} event.
467      *
468      * Requirements:
469      *
470      * - `owner` cannot be the zero address.
471      * - `spender` cannot be the zero address.
472      */
473     function _approve(address owner, address spender, uint256 amount) internal {
474         require(owner != address(0), "ERC20: approve from the zero address");
475         require(spender != address(0), "ERC20: approve to the zero address");
476 
477         _allowances[owner][spender] = amount;
478         emit Approval(owner, spender, amount);
479     }
480 
481     /**
482      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
483      * from the caller's allowance.
484      *
485      * See {_burn} and {_approve}.
486      */
487     function _burnFrom(address account, uint256 amount) internal {
488         _burn(account, amount);
489         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
490     }
491 }
492 
493 
494 
495 
496 
497 
498 
499 
500 /**
501  * @dev Collection of functions related to the address type
502  */
503 library Address {
504     /**
505      * @dev Returns true if `account` is a contract.
506      *
507      * [IMPORTANT]
508      * ====
509      * It is unsafe to assume that an address for which this function returns
510      * false is an externally-owned account (EOA) and not a contract.
511      *
512      * Among others, `isContract` will return false for the following 
513      * types of addresses:
514      *
515      *  - an externally-owned account
516      *  - a contract in construction
517      *  - an address where a contract will be created
518      *  - an address where a contract lived, but was destroyed
519      * ====
520      */
521     function isContract(address account) internal view returns (bool) {
522         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
523         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
524         // for accounts without code, i.e. `keccak256('')`
525         bytes32 codehash;
526         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
527         // solhint-disable-next-line no-inline-assembly
528         assembly { codehash := extcodehash(account) }
529         return (codehash != accountHash && codehash != 0x0);
530     }
531 
532     /**
533      * @dev Converts an `address` into `address payable`. Note that this is
534      * simply a type cast: the actual underlying value is not changed.
535      *
536      * _Available since v2.4.0._
537      */
538     function toPayable(address account) internal pure returns (address payable) {
539         return address(uint160(account));
540     }
541 
542     /**
543      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
544      * `recipient`, forwarding all available gas and reverting on errors.
545      *
546      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
547      * of certain opcodes, possibly making contracts go over the 2300 gas limit
548      * imposed by `transfer`, making them unable to receive funds via
549      * `transfer`. {sendValue} removes this limitation.
550      *
551      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
552      *
553      * IMPORTANT: because control is transferred to `recipient`, care must be
554      * taken to not create reentrancy vulnerabilities. Consider using
555      * {ReentrancyGuard} or the
556      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
557      *
558      * _Available since v2.4.0._
559      */
560     function sendValue(address payable recipient, uint256 amount) internal {
561         require(address(this).balance >= amount, "Address: insufficient balance");
562 
563         // solhint-disable-next-line avoid-call-value
564         (bool success, ) = recipient.call.value(amount)("");
565         require(success, "Address: unable to send value, recipient may have reverted");
566     }
567 }
568 
569 
570 /**
571  * @title SafeERC20
572  * @dev Wrappers around ERC20 operations that throw on failure (when the token
573  * contract returns false). Tokens that return no value (and instead revert or
574  * throw on failure) are also supported, non-reverting calls are assumed to be
575  * successful.
576  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
577  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
578  */
579 library SafeERC20 {
580     using SafeMath for uint256;
581     using Address for address;
582 
583     function safeTransfer(IERC20 token, address to, uint256 value) internal {
584         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
585     }
586 
587     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
588         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
589     }
590 
591     function safeApprove(IERC20 token, address spender, uint256 value) internal {
592         // safeApprove should only be called when setting an initial allowance,
593         // or when resetting it to zero. To increase and decrease it, use
594         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
595         // solhint-disable-next-line max-line-length
596         require((value == 0) || (token.allowance(address(this), spender) == 0),
597             "SafeERC20: approve from non-zero to non-zero allowance"
598         );
599         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
600     }
601 
602     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
603         uint256 newAllowance = token.allowance(address(this), spender).add(value);
604         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
605     }
606 
607     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
608         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
609         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
610     }
611 
612     /**
613      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
614      * on the return value: the return value is optional (but if data is returned, it must not be false).
615      * @param token The token targeted by the call.
616      * @param data The call data (encoded using abi.encode or one of its variants).
617      */
618     function callOptionalReturn(IERC20 token, bytes memory data) private {
619         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
620         // we're implementing it ourselves.
621 
622         // A Solidity high level call has three parts:
623         //  1. The target address is checked to verify it contains contract code
624         //  2. The call itself is made, and success asserted
625         //  3. The return value is decoded, which in turn checks the size of the returned data.
626         // solhint-disable-next-line max-line-length
627         require(address(token).isContract(), "SafeERC20: call to non-contract");
628 
629         // solhint-disable-next-line avoid-low-level-calls
630         (bool success, bytes memory returndata) = address(token).call(data);
631         require(success, "SafeERC20: low-level call failed");
632 
633         if (returndata.length > 0) { // Return data is optional
634             // solhint-disable-next-line max-line-length
635             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
636         }
637     }
638 }
639 
640 
641 /**
642  * @title Configurable
643  * @dev Configurable varriables of the contract
644  **/
645 contract Configurable {
646     uint256 public constant cap = 2000000000 * 10**18;
647 }
648 
649 /**
650  * @title Ownable
651  * @dev The Ownable contract has an owner address, and provides basic authorization control
652  * functions, this simplifies the implementation of "user permissions".
653  */
654 contract Ownable {
655     address public owner;
656 
657     /**
658      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
659      * account.
660      */
661     constructor() public {
662         owner = msg.sender;
663     }
664 
665     /**
666      * @dev Throws if called by any account other than the owner.
667      */
668     modifier onlyOwner() {
669         require(msg.sender == owner);
670         _;
671     }
672 
673     /**
674      * @dev Allows the current owner to transfer control of the contract to a newOwner.
675      * @param newOwner The address to transfer ownership to.
676      */
677     function transferOwnership(address newOwner) public onlyOwner {
678         if (newOwner != address(0)) {
679             owner = newOwner;
680         }
681     }
682 }
683 
684 contract BlackList is Ownable {
685     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tokoin) ///////
686     function getBlackListStatus(address _maker) external view returns (bool) {
687         return isBlackListed[_maker];
688     }
689 
690     function getOwner() external view returns (address) {
691         return owner;
692     }
693 
694     mapping(address => bool) public isBlackListed;
695 
696     function addBlackList(address _evilUser) public onlyOwner {
697         isBlackListed[_evilUser] = true;
698         emit AddedBlackList(_evilUser);
699     }
700 
701     function removeBlackList(address _clearedUser) public onlyOwner {
702         isBlackListed[_clearedUser] = false;
703         emit RemovedBlackList(_clearedUser);
704     }
705 
706     event AddedBlackList(address _user);
707     event RemovedBlackList(address _user);
708 }
709 
710 /**
711  * @title Pausable
712  * @dev Base contract which allows children to implement an emergency stop mechanism.
713  */
714 contract Pausable is Ownable {
715     event Pause();
716     event Unpause();
717 
718     bool public paused = false;
719 
720     /**
721      * @dev Modifier to make a function callable only when the contract is not paused.
722      */
723     modifier whenNotPaused() {
724         require(!paused);
725         _;
726     }
727 
728     /**
729      * @dev Modifier to make a function callable only when the contract is paused.
730      */
731     modifier whenPaused() {
732         require(paused);
733         _;
734     }
735 
736     /**
737      * @dev called by the owner to pause, triggers stopped state
738      */
739     function pause() public onlyOwner whenNotPaused {
740         paused = true;
741         emit Pause();
742     }
743 
744     /**
745      * @dev called by the owner to unpause, returns to normal state
746      */
747     function unpause() public onlyOwner whenPaused {
748         paused = false;
749         emit Unpause();
750     }
751 }
752 
753 contract TokoinTokenV2 is ERC20, Configurable, Pausable, BlackList {
754     string public constant name = "Tokoin";
755     string public constant symbol = "TOKO";
756     uint32 public constant decimals = 18;
757 
758     using SafeERC20 for IERC20;
759 
760     // events to track onchain-offchain relationships
761     event __transferByAdmin(bytes32 offchain);
762     event __issue(bytes32 offchain);
763     event __redeem(bytes32 offchain);
764 
765     // called when hacker's balance is burnt
766     event DestroyedBlackFunds(address _blackListedUser, uint256 _balance);
767 
768     constructor() public {
769         owner = msg.sender;
770         _mint(owner, cap);
771     }
772 
773     modifier onlyOwner() {
774         require(msg.sender == owner);
775         _;
776     }
777 
778     /**
779      * @dev function to transfer TOKO
780      * @param from the address to transfer from
781      * @param to the address to transfer to
782      * @param value the amount to be transferred
783      */
784     function transferByAdmin(
785         address from,
786         address to,
787         uint256 value,
788         bytes32 offchain
789     ) public onlyOwner {
790         _transfer(from, to, value);
791         emit __transferByAdmin(offchain);
792     }
793 
794     /**
795      * @dev function to purchase new TOKO
796      * @param issuer the address that will receive the newly minted TOKO
797      * @param value the amount of TOKO to mint
798      */
799     function issue(
800         address issuer,
801         uint256 value,
802         bytes32 offchain
803     ) public onlyOwner {
804         require(
805             totalSupply() + value <= cap,
806             "minted value + total supply must be smaller or equal token cap"
807         );
808         _mint(issuer, value);
809         emit __issue(offchain);
810     }
811 
812     /**
813      * @dev function to burn TOKO of hacker
814      * @param _blackListedUser the account whose TOKO will be burnt
815      */
816     function destroyBlackFunds(address _blackListedUser) public onlyOwner {
817         require(
818             isBlackListed[_blackListedUser],
819             "the address is not in the blacklist"
820         );
821         uint256 dirtyFunds = balanceOf(_blackListedUser);
822         _burn(_blackListedUser, dirtyFunds);
823         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
824     }
825 
826     /**
827      * @dev function to burn TOKO
828      * @param redeemer the account whose TOKO will be burnt
829      * @param value the amount of TOKO to be burnt
830      */
831     function redeem(
832         address redeemer,
833         uint256 value,
834         bytes32 offchain
835     ) public onlyOwner {
836         _burn(redeemer, value);
837         emit __redeem(offchain);
838     }
839 
840     function transfer(address _to, uint256 _value)
841         public
842         whenNotPaused
843         returns (bool)
844     {
845         require(!isBlackListed[msg.sender]);
846         return super.transfer(_to, _value);
847     }
848 
849     function transferFrom(
850         address _from,
851         address _to,
852         uint256 _value
853     ) public whenNotPaused returns (bool) {
854         require(!isBlackListed[_from]);
855         return super.transferFrom(_from, _to, _value);
856     }
857 }