1 pragma solidity ^0.6.0;
2 // SPDX-License-Identifier: UNLICENSED
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
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
25 
26 
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Emitted when `value` tokens are moved from one account (`from`) to
88      * another (`to`).
89      *
90      * Note that `value` may be zero.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /**
95      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96      * a call to {approve}. `value` is the new allowance.
97      */
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 // File: @openzeppelin/contracts/math/SafeMath.sol
102 
103 /**
104  * @dev Wrappers over Solidity's arithmetic operations with added overflow
105  * checks.
106  *
107  * Arithmetic operations in Solidity wrap on overflow. This can easily result
108  * in bugs, because programmers usually assume that an overflow raises an
109  * error, which is the standard behavior in high level programming languages.
110  * `SafeMath` restores this intuition by reverting the transaction when an
111  * operation overflows.
112  *
113  * Using this library instead of the unchecked operations eliminates an entire
114  * class of bugs, so it's recommended to use it always.
115  */
116 library SafeMath {
117     /**
118      * @dev Returns the addition of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `+` operator.
122      *
123      * Requirements:
124      *
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      *
173      * - Multiplication cannot overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b, "SafeMath: multiplication overflow");
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return div(a, b, "SafeMath: division by zero");
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return mod(a, b, "SafeMath: modulo by zero");
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts with custom message when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 // File: @openzeppelin/contracts/utils/Address.sol
260 
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { codehash := extcodehash(account) }
291         return (codehash != accountHash && codehash != 0x0);
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
314         (bool success, ) = recipient.call{ value: amount }("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain`call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337       return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
347         return _functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         return _functionCallWithValue(target, data, value, errorMessage);
374     }
375 
376     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
377         require(isContract(target), "Address: call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 // solhint-disable-next-line no-inline-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 
401 // File: @openzeppelin/contracts/access/Ownable.sol
402 
403 /**
404  * @dev Contract module which provides a basic access control mechanism, where
405  * there is an account (an owner) that can be granted exclusive access to
406  * specific functions.
407  *
408  * By default, the owner account will be the one that deploys the contract. This
409  * can later be changed with {transferOwnership}.
410  *
411  * This module is used through inheritance. It will make available the modifier
412  * `onlyOwner`, which can be applied to your functions to restrict their use to
413  * the owner.
414  */
415 contract Ownable is Context {
416     address private _owner;
417 	
418 	
419 	
420     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
421 
422     /**
423      * @dev Initializes the contract setting the deployer as the initial owner.
424      */
425     constructor () internal {
426         address msgSender = _msgSender();
427         _owner = msgSender;
428         emit OwnershipTransferred(address(0), msgSender);
429     }
430 
431     /**
432      * @dev Returns the address of the current owner.
433      */
434     function owner() public view returns (address) {
435         return _owner;
436     }
437 
438     /**
439      * @dev Throws if called by any account other than the owner.
440      */
441     modifier onlyOwner() {
442         require(_owner == _msgSender(), "Ownable: caller is not the owner");
443         _;
444     }
445 
446     /**
447      * @dev Leaves the contract without owner. It will not be possible to call
448      * `onlyOwner` functions anymore. Can only be called by the current owner.
449      *
450      * NOTE: Renouncing ownership will leave the contract without an owner,
451      * thereby removing any functionality that is only available to the owner.
452      */
453     function renounceOwnership() public virtual onlyOwner {
454         emit OwnershipTransferred(_owner, address(0));
455         _owner = address(0);
456     }
457 
458     /**
459      * @dev Transfers ownership of the contract to a new account (`newOwner`).
460      * Can only be called by the current owner.
461      */
462     function transferOwnership(address newOwner) public virtual onlyOwner {
463         require(newOwner != address(0), "Ownable: new owner is the zero address");
464         emit OwnershipTransferred(_owner, newOwner);
465         _owner = newOwner;
466     }
467 }
468 
469 
470 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
471 
472 
473 /**
474  * @dev Implementation of the {IERC20} interface.
475  *
476  * This implementation is agnostic to the way tokens are created. This means
477  * that a mint mechanism has to be added in a derived contract using {_mint}.
478  *
479  * TIP: For a detailed writeup see our guide
480  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
481  * to implement supply mechanisms].
482  *
483  * We have followed general OpenZeppelin guidelines: functions revert instead
484  * of returning `false` on failure. This behavior is nonetheless conventional
485  * and does not conflict with the expectations of ERC20 applications.
486  *
487  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
488  * This allows applications to reconstruct the allowance for all accounts just
489  * by listening to said events. Other implementations of the EIP may not emit
490  * these events, as it isn't required by the specification.
491  *
492  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
493  * functions have been added to mitigate the well-known issues around setting
494  * allowances. See {IERC20-approve}.
495  */
496 contract ERC20 is Context, IERC20, Ownable {
497     using SafeMath for uint256;
498     using Address for address;
499 	
500     mapping (address => uint256) private _balances;
501 
502     mapping (address => mapping (address => uint256)) private _allowances;
503 
504     uint256 private _totalSupply;
505     uint256 private _fisrtSupply = 1000 * 10**18;
506 	
507 	uint256 private _divRate = 10000;
508 	
509 	uint256 public DevRate = 0;
510 	uint256 public RewardRate = 0;
511 	
512 	address public DevAddres;
513 	address public RewardPool;
514 	
515     string private _name;
516     string private _symbol;
517     uint8 private _decimals;
518 	
519 	mapping(address => bool) public zeroFeeSender;
520     mapping(address => bool) public zeroFeeReciever;
521 	
522     /**
523      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
524      * a default value of 18.
525      *
526      * To select a different value for {decimals}, use {_setupDecimals}.
527      *
528      * All three of these values are immutable: they can only be set once during
529      * construction.
530      */
531     constructor (string memory name, string memory symbol, address _DevAddres, address _RewardPool) public {
532         _name = name;
533         _symbol = symbol;
534         _decimals = 18;
535 		
536 		DevAddres = _DevAddres;
537 		RewardPool = _RewardPool;
538 	
539 		_mint(msg.sender, _fisrtSupply);
540     }
541 
542     /**
543      * @dev Returns the name of the token.
544      */
545     function name() public view returns (string memory) {
546         return _name;
547     }
548 
549     /**
550      * @dev Returns the symbol of the token, usually a shorter version of the
551      * name.
552      */
553     function symbol() public view returns (string memory) {
554         return _symbol;
555     }
556 
557     /**
558      * @dev Returns the number of decimals used to get its user representation.
559      * For example, if `decimals` equals `2`, a balance of `505` tokens should
560      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
561      *
562      * Tokens usually opt for a value of 18, imitating the relationship between
563      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
564      * called.
565      *
566      * NOTE: This information is only used for _display_ purposes: it in
567      * no way affects any of the arithmetic of the contract, including
568      * {IERC20-balanceOf} and {IERC20-transfer}.
569      */
570     function decimals() public view returns (uint8) {
571         return _decimals;
572     }
573 
574     /**
575      * @dev See {IERC20-totalSupply}.
576      */
577     function totalSupply() public view override returns (uint256) {
578         return _totalSupply;
579     }
580 
581     /**
582      * @dev See {IERC20-balanceOf}.
583      */
584     function balanceOf(address account) public view override returns (uint256) {
585         return _balances[account];
586     }
587 
588     /**
589      * @dev See {IERC20-transfer}.
590      *
591      * Requirements:
592      *
593      * - `recipient` cannot be the zero address.
594      * - the caller must have a balance of at least `amount`.
595      */
596     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
597         _transfer(_msgSender(), recipient, amount);
598         return true;
599     }
600 
601     /**
602      * @dev See {IERC20-allowance}.
603      */
604     function allowance(address owner, address spender) public view virtual override returns (uint256) {
605         return _allowances[owner][spender];
606     }
607 
608     /**
609      * @dev See {IERC20-approve}.
610      *
611      * Requirements:
612      *
613      * - `spender` cannot be the zero address.
614      */
615     function approve(address spender, uint256 amount) public virtual override returns (bool) {
616         _approve(_msgSender(), spender, amount);
617         return true;
618     }
619 
620     /**
621      * @dev See {IERC20-transferFrom}.
622      *
623      * Emits an {Approval} event indicating the updated allowance. This is not
624      * required by the EIP. See the note at the beginning of {ERC20};
625      *
626      * Requirements:
627      * - `sender` and `recipient` cannot be the zero address.
628      * - `sender` must have a balance of at least `amount`.
629      * - the caller must have allowance for ``sender``'s tokens of at least
630      * `amount`.
631      */
632     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
633         _transfer(sender, recipient, amount);
634         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
635         return true;
636     }
637 
638     /**
639      * @dev Atomically increases the allowance granted to `spender` by the caller.
640      *
641      * This is an alternative to {approve} that can be used as a mitigation for
642      * problems described in {IERC20-approve}.
643      *
644      * Emits an {Approval} event indicating the updated allowance.
645      *
646      * Requirements:
647      *
648      * - `spender` cannot be the zero address.
649      */
650     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
651         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
652         return true;
653     }
654 
655     /**
656      * @dev Atomically decreases the allowance granted to `spender` by the caller.
657      *
658      * This is an alternative to {approve} that can be used as a mitigation for
659      * problems described in {IERC20-approve}.
660      *
661      * Emits an {Approval} event indicating the updated allowance.
662      *
663      * Requirements:
664      *
665      * - `spender` cannot be the zero address.
666      * - `spender` must have allowance for the caller of at least
667      * `subtractedValue`.
668      */
669     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
670         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
671         return true;
672     }
673 
674     /**
675      * @dev Moves tokens `amount` from `sender` to `recipient`.
676      *
677      * This is internal function is equivalent to {transfer}, and can be used to
678      * e.g. implement automatic token fees, slashing mechanisms, etc.
679      *
680      * Emits a {Transfer} event.
681      *
682      * Requirements:
683      *
684      * - `sender` cannot be the zero address.
685      * - `recipient` cannot be the zero address.
686      * - `sender` must have a balance of at least `amount`.
687      */
688     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
689         require(sender != address(0), "ERC20: transfer from the zero address");
690         require(recipient != address(0), "ERC20: transfer to the zero address");
691 
692         _beforeTokenTransfer(sender, recipient, amount);
693 			
694         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
695         
696 		uint256 devAmount = amount.mul(DevRate);
697         uint256 rewardAmount = amount.mul(RewardRate);
698 		
699 		if(DevRate > 0){
700 			devAmount = devAmount.div(_divRate);
701 		}
702         
703 		if(RewardRate > 0){
704 			rewardAmount = rewardAmount.div(_divRate);
705 		}
706         		
707 		if(zeroFeeSender[sender] || zeroFeeSender[recipient]){
708 			devAmount = 0;
709 			rewardAmount = 0;
710 		}
711 		
712 		uint256 receiptAmount = (amount.sub(devAmount)).sub(rewardAmount);
713 		
714 		_balances[recipient] = _balances[recipient].add(receiptAmount);
715         emit Transfer(sender, recipient, receiptAmount);
716 		
717 		if(devAmount > 0 && DevAddres != address(0)){
718             _balances[DevAddres] = _balances[DevAddres].add(devAmount);
719             emit Transfer(sender, DevAddres, devAmount);
720         }
721 		
722 		if(rewardAmount > 0 && RewardPool != address(0)){
723             _balances[RewardPool] = _balances[RewardPool].add(rewardAmount);
724             emit Transfer(sender, RewardPool, rewardAmount);
725         }
726 		
727     }
728 		
729     function _mint(address account, uint256 amount) internal virtual {
730         require(account != address(0), "ERC20: generate to the zero address");
731 
732         _beforeTokenTransfer(address(0), account, amount);
733 
734         _totalSupply = _totalSupply.add(amount);
735         _balances[account] = _balances[account].add(amount);
736         emit Transfer(address(0), account, amount);
737     }
738 
739     /**
740      * @dev Destroys `amount` tokens from `account`, reducing the
741      * total supply.
742      *
743      * Emits a {Transfer} event with `to` set to the zero address.
744      *
745      * Requirements
746      *
747      * - `account` cannot be the zero address.
748      * - `account` must have at least `amount` tokens.
749      */
750     function _burn(address account, uint256 amount) internal virtual {
751         require(account != address(0), "ERC20: burn from the zero address");
752 
753         _beforeTokenTransfer(account, address(0), amount);
754 
755         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
756         _totalSupply = _totalSupply.sub(amount);
757         emit Transfer(account, address(0), amount);
758     }
759 	
760     /**
761      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
762      *
763      * This is internal function is equivalent to `approve`, and can be used to
764      * e.g. set automatic allowances for certain subsystems, etc.
765      *
766      * Emits an {Approval} event.
767      *
768      * Requirements:
769      *
770      * - `owner` cannot be the zero address.
771      * - `spender` cannot be the zero address.
772      */
773     function _approve(address owner, address spender, uint256 amount) internal virtual {
774         require(owner != address(0), "ERC20: approve from the zero address");
775         require(spender != address(0), "ERC20: approve to the zero address");
776 
777         _allowances[owner][spender] = amount;
778         emit Approval(owner, spender, amount);
779     }
780 
781     /**
782      * @dev Sets {decimals} to a value other than the default one of 18.
783      *
784      * WARNING: This function should only be called from the constructor. Most
785      * applications that interact with token contracts will not expect
786      * {decimals} to ever change, and may work incorrectly if it does.
787      */
788     function _setupDecimals(uint8 decimals_) internal {
789         _decimals = decimals_;
790     }
791 	
792 	function _setTransferRate(uint256 _DevRate, uint256 _RewardRate) external onlyOwner {
793 		DevRate = _DevRate;
794 		RewardRate = _RewardRate;
795 	} 
796 	
797 	function setTransferAddress(address _DevAddres, address _RewardPool) external onlyOwner {
798 		DevAddres = _DevAddres;
799 		RewardPool = _RewardPool;
800 	} 
801 	
802     /**
803      * @dev Hook that is called before any transfer of tokens. This includes
804      * first supply and burning.
805      *
806      * Calling conditions:
807      *
808      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
809      * will be to transferred to `to`.
810      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
811      * - `from` and `to` are never both zero.
812      *
813      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
814      */
815     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
816 }
817 
818 contract YugiToken is ERC20 {
819 	
820 	constructor(address _DevAddress, address _RewardPool) public ERC20("YugiToken", "YGT", _DevAddress, _RewardPool) {	
821 
822 	}
823 	
824     function burn(uint256 amount) public {
825         _burn(msg.sender, amount);
826     }
827 	
828 	function setZeroFeeSender(address _sender, bool _zeroFee) public onlyOwner {
829 		zeroFeeSender[_sender] = _zeroFee;
830     }
831 
832     function setZeroFeeReciever(address _recipient, bool _zeroFee) public onlyOwner {
833         zeroFeeReciever[_recipient] = _zeroFee;
834     }
835 }