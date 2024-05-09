1 pragma solidity ^0.6.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 
78 
79 pragma solidity ^0.6.0;
80 
81 /**
82  * @dev Wrappers over Solidity's arithmetic operations with added overflow
83  * checks.
84  *
85  * Arithmetic operations in Solidity wrap on overflow. This can easily result
86  * in bugs, because programmers usually assume that an overflow raises an
87  * error, which is the standard behavior in high level programming languages.
88  * `SafeMath` restores this intuition by reverting the transaction when an
89  * operation overflows.
90  *
91  * Using this library instead of the unchecked operations eliminates an entire
92  * class of bugs, so it's recommended to use it always.
93  */
94 library SafeMath {
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      *
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      *
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         return sub(a, b, "SafeMath: subtraction overflow");
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `*` operator.
148      *
149      * Requirements:
150      *
151      * - Multiplication cannot overflow.
152      */
153     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
155         // benefit is lost if 'b' is also tested.
156         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
157         if (a == 0) {
158             return 0;
159         }
160 
161         uint256 c = a * b;
162         require(c / a == b, "SafeMath: multiplication overflow");
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the integer division of two unsigned integers. Reverts on
169      * division by zero. The result is rounded towards zero.
170      *
171      * Counterpart to Solidity's `/` operator. Note: this function uses a
172      * `revert` opcode (which leaves remaining gas untouched) while Solidity
173      * uses an invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function div(uint256 a, uint256 b) internal pure returns (uint256) {
180         return div(a, b, "SafeMath: division by zero");
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         require(b > 0, errorMessage);
197         uint256 c = a / b;
198         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * Reverts when dividing by zero.
206      *
207      * Counterpart to Solidity's `%` operator. This function uses a `revert`
208      * opcode (which leaves remaining gas untouched) while Solidity uses an
209      * invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216         return mod(a, b, "SafeMath: modulo by zero");
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts with custom message when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b != 0, errorMessage);
233         return a % b;
234     }
235 }
236 
237 
238 pragma solidity ^0.6.0;
239 
240 /*
241  * @dev Provides information about the current execution context, including the
242  * sender of the transaction and its data. While these are generally available
243  * via msg.sender and msg.data, they should not be accessed in such a direct
244  * manner, since when dealing with GSN meta-transactions the account sending and
245  * paying for execution may not be the actual sender (as far as an application
246  * is concerned).
247  *
248  * This contract is only required for intermediate, library-like contracts.
249  */
250 abstract contract Context {
251     function _msgSender() internal view virtual returns (address payable) {
252         return msg.sender;
253     }
254 
255     function _msgData() internal view virtual returns (bytes memory) {
256         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
257         return msg.data;
258     }
259 }
260 
261 
262 pragma solidity ^0.6.2;
263 
264 /**
265  * @dev Collection of functions related to the address type
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * [IMPORTANT]
272      * ====
273      * It is unsafe to assume that an address for which this function returns
274      * false is an externally-owned account (EOA) and not a contract.
275      *
276      * Among others, `isContract` will return false for the following
277      * types of addresses:
278      *
279      *  - an externally-owned account
280      *  - a contract in construction
281      *  - an address where a contract will be created
282      *  - an address where a contract lived, but was destroyed
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // This method relies in extcodesize, which returns 0 for contracts in
287         // construction, since the code is only stored at the end of the
288         // constructor execution.
289 
290         uint256 size;
291         // solhint-disable-next-line no-inline-assembly
292         assembly { size := extcodesize(account) }
293         return size > 0;
294     }
295 
296     /**
297      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
298      * `recipient`, forwarding all available gas and reverting on errors.
299      *
300      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
301      * of certain opcodes, possibly making contracts go over the 2300 gas limit
302      * imposed by `transfer`, making them unable to receive funds via
303      * `transfer`. {sendValue} removes this limitation.
304      *
305      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
306      *
307      * IMPORTANT: because control is transferred to `recipient`, care must be
308      * taken to not create reentrancy vulnerabilities. Consider using
309      * {ReentrancyGuard} or the
310      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
311      */
312     function sendValue(address payable recipient, uint256 amount) internal {
313         require(address(this).balance >= amount, "Address: insufficient balance");
314 
315         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
316         (bool success, ) = recipient.call{ value: amount }("");
317         require(success, "Address: unable to send value, recipient may have reverted");
318     }
319 
320     /**
321      * @dev Performs a Solidity function call using a low level `call`. A
322      * plain`call` is an unsafe replacement for a function call: use this
323      * function instead.
324      *
325      * If `target` reverts with a revert reason, it is bubbled up by this
326      * function (like regular Solidity function calls).
327      *
328      * Returns the raw returned data. To convert to the expected return value,
329      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
330      *
331      * Requirements:
332      *
333      * - `target` must be a contract.
334      * - calling `target` with `data` must not revert.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
339       return functionCall(target, data, "Address: low-level call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
344      * `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
349         return _functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
369      * with `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         return _functionCallWithValue(target, data, value, errorMessage);
376     }
377 
378     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
379         require(isContract(target), "Address: call to non-contract");
380 
381         // solhint-disable-next-line avoid-low-level-calls
382         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 // solhint-disable-next-line no-inline-assembly
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 
403 pragma solidity ^0.6.0;
404 
405 /**
406  * @dev Contract module which provides a basic access control mechanism, where
407  * there is an account (an owner) that can be granted exclusive access to
408  * specific functions.
409  *
410  * By default, the owner account will be the one that deploys the contract. This
411  * can later be changed with {transferOwnership}.
412  *
413  * This module is used through inheritance. It will make available the modifier
414  * `onlyOwner`, which can be applied to your functions to restrict their use to
415  * the owner.
416  */
417 contract Ownable is Context {
418     address private _owner;
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
470 pragma solidity ^0.6.0;
471 
472 
473 /**
474  * @dev Implementation of the {IERC20} interface.
475  *
476  * This implementation is agnostic to the way tokens are created. This means
477  * that a supply mechanism has to be added in a derived contract using {_mint}.
478  * For a generic mechanism see {ERC20PresetMinterPauser}.
479  *
480  * TIP: For a detailed writeup see our guide
481  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
482  * to implement supply mechanisms].
483  *
484  * We have followed general OpenZeppelin guidelines: functions revert instead
485  * of returning `false` on failure. This behavior is nonetheless conventional
486  * and does not conflict with the expectations of ERC20 applications.
487  *
488  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
489  * This allows applications to reconstruct the allowance for all accounts just
490  * by listening to said events. Other implementations of the EIP may not emit
491  * these events, as it isn't required by the specification.
492  *
493  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
494  * functions have been added to mitigate the well-known issues around setting
495  * allowances. See {IERC20-approve}.
496  */
497 contract ERC20 is Context, IERC20 {
498     using SafeMath for uint256;
499     using Address for address;
500 
501     mapping (address => uint256) private _balances;
502 
503     mapping (address => mapping (address => uint256)) private _allowances;
504 
505     uint256 private _totalSupply;
506 
507     string private _name;
508     string private _symbol;
509     uint8 private _decimals;
510 
511     /**
512      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
513      * a default value of 18.
514      *
515      * To select a different value for {decimals}, use {_setupDecimals}.
516      *
517      * All three of these values are immutable: they can only be set once during
518      * construction.
519      */
520     constructor (string memory name, string memory symbol) public {
521         _name = name;
522         _symbol = symbol;
523         _decimals = 18;
524     }
525 
526     /**
527      * @dev Returns the name of the token.
528      */
529     function name() public view returns (string memory) {
530         return _name;
531     }
532 
533     /**
534      * @dev Returns the symbol of the token, usually a shorter version of the
535      * name.
536      */
537     function symbol() public view returns (string memory) {
538         return _symbol;
539     }
540 
541     /**
542      * @dev Returns the number of decimals used to get its user representation.
543      * For example, if `decimals` equals `2`, a balance of `505` tokens should
544      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
545      *
546      * Tokens usually opt for a value of 18, imitating the relationship between
547      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
548      * called.
549      *
550      * NOTE: This information is only used for _display_ purposes: it in
551      * no way affects any of the arithmetic of the contract, including
552      * {IERC20-balanceOf} and {IERC20-transfer}.
553      */
554     function decimals() public view returns (uint8) {
555         return _decimals;
556     }
557 
558     /**
559      * @dev See {IERC20-totalSupply}.
560      */
561     function totalSupply() public view override returns (uint256) {
562         return _totalSupply;
563     }
564 
565     /**
566      * @dev See {IERC20-balanceOf}.
567      */
568     function balanceOf(address account) public view override returns (uint256) {
569         return _balances[account];
570     }
571 
572     /**
573      * @dev See {IERC20-transfer}.
574      *
575      * Requirements:
576      *
577      * - `recipient` cannot be the zero address.
578      * - the caller must have a balance of at least `amount`.
579      */
580     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
581         _transfer(_msgSender(), recipient, amount);
582         return true;
583     }
584 
585     /**
586      * @dev See {IERC20-allowance}.
587      */
588     function allowance(address owner, address spender) public view virtual override returns (uint256) {
589         return _allowances[owner][spender];
590     }
591 
592     /**
593      * @dev See {IERC20-approve}.
594      *
595      * Requirements:
596      *
597      * - `spender` cannot be the zero address.
598      */
599     function approve(address spender, uint256 amount) public virtual override returns (bool) {
600         _approve(_msgSender(), spender, amount);
601         return true;
602     }
603 
604     /**
605      * @dev See {IERC20-transferFrom}.
606      *
607      * Emits an {Approval} event indicating the updated allowance. This is not
608      * required by the EIP. See the note at the beginning of {ERC20};
609      *
610      * Requirements:
611      * - `sender` and `recipient` cannot be the zero address.
612      * - `sender` must have a balance of at least `amount`.
613      * - the caller must have allowance for ``sender``'s tokens of at least
614      * `amount`.
615      */
616     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
617         _transfer(sender, recipient, amount);
618         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
619         return true;
620     }
621 
622     /**
623      * @dev Atomically increases the allowance granted to `spender` by the caller.
624      *
625      * This is an alternative to {approve} that can be used as a mitigation for
626      * problems described in {IERC20-approve}.
627      *
628      * Emits an {Approval} event indicating the updated allowance.
629      *
630      * Requirements:
631      *
632      * - `spender` cannot be the zero address.
633      */
634     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
635         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
636         return true;
637     }
638 
639     /**
640      * @dev Atomically decreases the allowance granted to `spender` by the caller.
641      *
642      * This is an alternative to {approve} that can be used as a mitigation for
643      * problems described in {IERC20-approve}.
644      *
645      * Emits an {Approval} event indicating the updated allowance.
646      *
647      * Requirements:
648      *
649      * - `spender` cannot be the zero address.
650      * - `spender` must have allowance for the caller of at least
651      * `subtractedValue`.
652      */
653     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
654         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
655         return true;
656     }
657 
658     /**
659      * @dev Moves tokens `amount` from `sender` to `recipient`.
660      *
661      * This is internal function is equivalent to {transfer}, and can be used to
662      * e.g. implement automatic token fees, slashing mechanisms, etc.
663      *
664      * Emits a {Transfer} event.
665      *
666      * Requirements:
667      *
668      * - `sender` cannot be the zero address.
669      * - `recipient` cannot be the zero address.
670      * - `sender` must have a balance of at least `amount`.
671      */
672     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
673         require(sender != address(0), "ERC20: transfer from the zero address");
674         require(recipient != address(0), "ERC20: transfer to the zero address");
675 
676         _beforeTokenTransfer(sender, recipient, amount);
677 
678         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
679         _balances[recipient] = _balances[recipient].add(amount);
680         emit Transfer(sender, recipient, amount);
681     }
682 
683     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
684      * the total supply.
685      *
686      * Emits a {Transfer} event with `from` set to the zero address.
687      *
688      * Requirements
689      *
690      * - `to` cannot be the zero address.
691      */
692     function _mint(address account, uint256 amount) internal virtual {
693         require(account != address(0), "ERC20: mint to the zero address");
694 
695         _beforeTokenTransfer(address(0), account, amount);
696 
697         _totalSupply = _totalSupply.add(amount);
698         _balances[account] = _balances[account].add(amount);
699         emit Transfer(address(0), account, amount);
700     }
701 
702     /**
703      * @dev Destroys `amount` tokens from `account`, reducing the
704      * total supply.
705      *
706      * Emits a {Transfer} event with `to` set to the zero address.
707      *
708      * Requirements
709      *
710      * - `account` cannot be the zero address.
711      * - `account` must have at least `amount` tokens.
712      */
713     function _burn(address account, uint256 amount) internal virtual {
714         require(account != address(0), "ERC20: burn from the zero address");
715 
716         _beforeTokenTransfer(account, address(0), amount);
717 
718         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
719         _totalSupply = _totalSupply.sub(amount);
720         emit Transfer(account, address(0), amount);
721     }
722 
723     /**
724      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
725      *
726      * This internal function is equivalent to `approve`, and can be used to
727      * e.g. set automatic allowances for certain subsystems, etc.
728      *
729      * Emits an {Approval} event.
730      *
731      * Requirements:
732      *
733      * - `owner` cannot be the zero address.
734      * - `spender` cannot be the zero address.
735      */
736     function _approve(address owner, address spender, uint256 amount) internal virtual {
737         require(owner != address(0), "ERC20: approve from the zero address");
738         require(spender != address(0), "ERC20: approve to the zero address");
739 
740         _allowances[owner][spender] = amount;
741         emit Approval(owner, spender, amount);
742     }
743 
744     /**
745      * @dev Sets {decimals} to a value other than the default one of 18.
746      *
747      * WARNING: This function should only be called from the constructor. Most
748      * applications that interact with token contracts will not expect
749      * {decimals} to ever change, and may work incorrectly if it does.
750      */
751     function _setupDecimals(uint8 decimals_) internal {
752         _decimals = decimals_;
753     }
754 
755     /**
756      * @dev Hook that is called before any transfer of tokens. This includes
757      * minting and burning.
758      *
759      * Calling conditions:
760      *
761      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
762      * will be to transferred to `to`.
763      * - when `from` is zero, `amount` tokens will be minted for `to`.
764      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
765      * - `from` and `to` are never both zero.
766      *
767      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
768      */
769     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
770 }
771 
772 
773 contract Converter is ERC20, Ownable {
774     using SafeMath for uint256;
775  
776     uint256 public dollarFeeRatio   = 200;  // USDC/ESD fee ratio
777     uint256 public treasuryFeeRatio = 2000; // fee ratio of treasury
778     uint256 public baseFactor       = 10000;// ratio base
779 
780     address public treasuryAddr;
781 
782     IERC20  public dollar;
783     
784     uint256 public dollarDecimal;
785 
786     mapping (address => uint256) public depositAt; // in case of flashloan attacks
787 
788     constructor(address _dollar, address _treasuryAddr, uint256 _dollarDecimal) 
789         public  ERC20("Dynamic USDC Token","dUSDC")
790     {
791         dollar          = IERC20(_dollar);
792         treasuryAddr    = _treasuryAddr;
793         dollarDecimal   = _dollarDecimal;
794     }
795 
796     function reset( uint256 _dollarFeeRatio, uint256 _treasuryFeeRatio, 
797                     address _treasuryAddr)
798             external onlyOwner 
799     {
800         dollarFeeRatio = _dollarFeeRatio;
801         treasuryFeeRatio = _treasuryFeeRatio;
802         treasuryAddr = _treasuryAddr;
803     }
804 
805     /**
806      * @dev Calculates the amount of dTokens that will be minted when the given amount 
807      *      is deposited.
808      *      used in the deposit() function to calculate the amount of dTokens that
809      *      will be minted.
810      *
811      * @dev refer to keeperDao whose code is here: 
812             https://etherscan.io/address/0x53463cd0b074e5fdafc55dce7b1c82adf1a43b2e#code
813      *
814      *      mintAmount = amountDeposited * (1-fee) * kPool /(pool + amountDeposited * fee)
815      */
816     function calculateMintAmount(uint256 _depositAmount) internal view returns (uint256) {
817         // The total balance includes the deposit amount, which is removed here.        
818         uint256 initialBalance = dollar.balanceOf(address(this)).sub(_depositAmount);
819 
820         if (totalSupply() == 0) {
821             // if decimal is not 1e18, convert it.
822             uint256 value = _depositAmount.mul(uint256(1e18)).div(10**dollarDecimal);
823             return value;
824         }
825 
826         return  (applyFee(dollarFeeRatio, _depositAmount).mul(totalSupply())).div(
827                     initialBalance.add(
828                         calculateFee(dollarFeeRatio, _depositAmount)
829                 ));
830     }
831 
832     /// @dev it calculates (1 - fee) * amount
833     function applyFee(uint256 _feeInBips, uint256 _amount) internal view returns (uint256) {
834         return _amount.mul(baseFactor.sub(_feeInBips)).div(baseFactor); 
835     }
836 
837     /// @dev it calculates fee * amount
838     function calculateFee(uint256 _feeInBips, uint256 _amount) internal view returns (uint256) {
839         return _amount.mul(_feeInBips).div(baseFactor); 
840     }
841 
842     function convert(uint256 _amount) external {
843         require(_amount > 0, "need gt 0");
844 
845         depositAt[msg.sender] = block.number;
846 
847         // usdc/esd fee, portion of it to treasury
848         // the remaining will be rewarded to the former partners
849         dollar.transferFrom(msg.sender, address(this), _amount);
850 
851         // mint shares with total fee
852         uint256 value = calculateMintAmount(_amount);
853         _mint(msg.sender, value);
854 
855         // transfer the specified amount to treasury.
856         uint256 dollarFee = _amount.mul(dollarFeeRatio).div(baseFactor);
857         uint256 dollarFeeForTreasury = dollarFee.mul(treasuryFeeRatio).div(baseFactor);
858 
859         // transfer the specified dollarFee to treasury.
860         dollar.transfer(treasuryAddr, dollarFeeForTreasury);
861 
862 
863         // check if get into the hardCap, need check the stake balance
864         // if(dollar.balanceOf(address(this)) >= dollarHardCap) {
865         //     uint256 stakingBalance = staking.getStakedBalance();
866         //     require(stakingBalance >= dfiStakingNum, "staking power is not enough.");
867         // }
868 
869 
870         emit Mint(msg.sender, value);
871     }
872 
873     function redeem(uint256 _value) external {
874         require(balanceOf(msg.sender) >= _value && _value > 0, "not enough");
875 
876         require(depositAt[msg.sender] > 0, "No deposit history.");
877         require(depositAt[msg.sender] < block.number, "Reject");
878 
879         uint256 value = _value.mul(dollar.balanceOf(address(this))).div(totalSupply());
880         _burn(msg.sender, _value);
881         dollar.transfer(msg.sender, value);
882 
883         emit Burn(msg.sender, _value);
884     }
885 
886 
887     event Mint(address indexed sender, uint256 amount);
888     event Burn(address indexed sender, uint256 amount);
889    
890 }