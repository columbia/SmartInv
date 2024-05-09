1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.1;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 
162 /**
163  * @dev Collection of functions related to the address type
164  */
165 library Address {
166     /**
167      * @dev Returns true if `account` is a contract.
168      *
169      * [IMPORTANT]
170      * ====
171      * It is unsafe to assume that an address for which this function returns
172      * false is an externally-owned account (EOA) and not a contract.
173      *
174      * Among others, `isContract` will return false for the following
175      * types of addresses:
176      *
177      *  - an externally-owned account
178      *  - a contract in construction
179      *  - an address where a contract will be created
180      *  - an address where a contract lived, but was destroyed
181      * ====
182      */
183     function isContract(address account) internal view returns (bool) {
184         // This method relies in extcodesize, which returns 0 for contracts in
185         // construction, since the code is only stored at the end of the
186         // constructor execution.
187 
188         uint256 size;
189         // solhint-disable-next-line no-inline-assembly
190         assembly { size := extcodesize(account) }
191         return size > 0;
192     }
193 
194     /**
195      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
196      * `recipient`, forwarding all available gas and reverting on errors.
197      *
198      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
199      * of certain opcodes, possibly making contracts go over the 2300 gas limit
200      * imposed by `transfer`, making them unable to receive funds via
201      * `transfer`. {sendValue} removes this limitation.
202      *
203      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
204      *
205      * IMPORTANT: because control is transferred to `recipient`, care must be
206      * taken to not create reentrancy vulnerabilities. Consider using
207      * {ReentrancyGuard} or the
208      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
209      */
210     function sendValue(address payable recipient, uint256 amount) internal {
211         require(address(this).balance >= amount, "Address: insufficient balance");
212 
213         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
214         (bool success, ) = recipient.call{ value: amount }("");
215         require(success, "Address: unable to send value, recipient may have reverted");
216     }
217 
218     /**
219      * @dev Performs a Solidity function call using a low level `call`. A
220      * plain`call` is an unsafe replacement for a function call: use this
221      * function instead.
222      *
223      * If `target` reverts with a revert reason, it is bubbled up by this
224      * function (like regular Solidity function calls).
225      *
226      * Returns the raw returned data. To convert to the expected return value,
227      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
228      *
229      * Requirements:
230      *
231      * - `target` must be a contract.
232      * - calling `target` with `data` must not revert.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
237       return functionCall(target, data, "Address: low-level call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
242      * `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
247         return _functionCallWithValue(target, data, 0, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but also transferring `value` wei to `target`.
253      *
254      * Requirements:
255      *
256      * - the calling contract must have an ETH balance of at least `value`.
257      * - the called Solidity function must be `payable`.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
262         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
267      * with `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
272         require(address(this).balance >= value, "Address: insufficient balance for call");
273         return _functionCallWithValue(target, data, value, errorMessage);
274     }
275 
276     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
277         require(isContract(target), "Address: call to non-contract");
278 
279         // solhint-disable-next-line avoid-low-level-calls
280         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
281         if (success) {
282             return returndata;
283         } else {
284             // Look for revert reason and bubble it up if present
285             if (returndata.length > 0) {
286                 // The easiest way to bubble the revert reason is using memory via assembly
287 
288                 // solhint-disable-next-line no-inline-assembly
289                 assembly {
290                     let returndata_size := mload(returndata)
291                     revert(add(32, returndata), returndata_size)
292                 }
293             } else {
294                 revert(errorMessage);
295             }
296         }
297     }
298 }
299 
300 
301 /**
302  * @dev Interface of the ERC20 standard as defined in the EIP.
303  */
304 interface IERC20 {
305     /**
306      * @dev Returns the amount of tokens in existence.
307      */
308     function totalSupply() external view returns (uint256);
309 
310     /**
311      * @dev Returns the amount of tokens owned by `account`.
312      */
313     function balanceOf(address account) external view returns (uint256);
314 
315     /**
316      * @dev Moves `amount` tokens from the caller's account to `recipient`.
317      *
318      * Returns a boolean value indicating whether the operation succeeded.
319      *
320      * Emits a {Transfer} event.
321      */
322     function transfer(address recipient, uint256 amount) external returns (bool);
323 
324     /**
325      * @dev Returns the remaining number of tokens that `spender` will be
326      * allowed to spend on behalf of `owner` through {transferFrom}. This is
327      * zero by default.
328      *
329      * This value changes when {approve} or {transferFrom} are called.
330      */
331     function allowance(address owner, address spender) external view returns (uint256);
332 
333     /**
334      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
335      *
336      * Returns a boolean value indicating whether the operation succeeded.
337      *
338      * IMPORTANT: Beware that changing an allowance with this method brings the risk
339      * that someone may use both the old and the new allowance by unfortunate
340      * transaction ordering. One possible solution to mitigate this race
341      * condition is to first reduce the spender's allowance to 0 and set the
342      * desired value afterwards:
343      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
344      *
345      * Emits an {Approval} event.
346      */
347     function approve(address spender, uint256 amount) external returns (bool);
348 
349     /**
350      * @dev Moves `amount` tokens from `sender` to `recipient` using the
351      * allowance mechanism. `amount` is then deducted from the caller's
352      * allowance.
353      *
354      * Returns a boolean value indicating whether the operation succeeded.
355      *
356      * Emits a {Transfer} event.
357      */
358     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
359 
360     /**
361      * @dev Emitted when `value` tokens are moved from one account (`from`) to
362      * another (`to`).
363      *
364      * Note that `value` may be zero.
365      */
366     event Transfer(address indexed from, address indexed to, uint256 value);
367 
368     /**
369      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
370      * a call to {approve}. `value` is the new allowance.
371      */
372     event Approval(address indexed owner, address indexed spender, uint256 value);
373 }
374 
375 /*
376  * @dev Provides information about the current execution context, including the
377  * sender of the transaction and its data. While these are generally available
378  * via msg.sender and msg.data, they should not be accessed in such a direct
379  * manner, since when dealing with GSN meta-transactions the account sending and
380  * paying for execution may not be the actual sender (as far as an application
381  * is concerned).
382  *
383  * This contract is only required for intermediate, library-like contracts.
384  */
385 abstract contract Context {
386     function _msgSender() internal view virtual returns (address payable) {
387         return msg.sender;
388     }
389 
390     function _msgData() internal view virtual returns (bytes memory) {
391         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
392         return msg.data;
393     }
394 }
395     
396  /* @dev Contract module which provides a basic access control mechanism, where
397  * there is an account (an owner) that can be granted exclusive access to
398  * specific functions.
399  *
400  * By default, the owner account will be the one that deploys the contract. This
401  * can later be changed with {transferOwnership}.
402  *
403  * This module is used through inheritance. It will make available the modifier
404  * `onlyOwner`, which can be applied to your functions to restrict their use to
405  * the owner.
406  */
407 contract Ownable is Context {
408     address private _owner;
409 
410     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
411 
412     /**
413      * @dev Initializes the contract setting the deployer as the initial owner.
414      */
415     constructor () {
416         address msgSender = _msgSender();
417         _owner = msgSender;
418         emit OwnershipTransferred(address(0), msgSender);
419     }
420 
421     /**
422      * @dev Returns the address of the current owner.
423      */
424     function owner() public view returns (address) {
425         return _owner;
426     }
427 
428     /**
429      * @dev Throws if called by any account other than the owner.
430      */
431     modifier onlyOwner() {
432         require(_owner == _msgSender(), "Ownable: caller is not the owner");
433         _;
434     }
435 
436     /**
437      * @dev Transfers ownership of the contract to a new account (`newOwner`).
438      * Can only be called by the current owner.
439      */
440     function transferOwnership(address newOwner) public virtual onlyOwner {
441         require(newOwner != address(0), "Ownable: new owner is the zero address");
442         emit OwnershipTransferred(_owner, newOwner);
443         _owner = newOwner;
444     }
445 }
446 
447 /**
448  * @dev Implementation of the {IERC20} interface.
449  *
450  * This implementation is agnostic to the way tokens are created. This means
451  * that a supply mechanism has to be added in a derived contract using {_mint}.
452  * For a generic mechanism see {ERC20PresetMinterPauser}.
453  *
454  * TIP: For a detailed writeup see our guide
455  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
456  * to implement supply mechanisms].
457  *
458  * We have followed general OpenZeppelin guidelines: functions revert instead
459  * of returning `false` on failure. This behavior is nonetheless conventional
460  * and does not conflict with the expectations of ERC20 applications.
461  *
462  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
463  * This allows applications to reconstruct the allowance for all accounts just
464  * by listening to said events. Other implementations of the EIP may not emit
465  * these events, as it isn't required by the specification.
466  *
467  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
468  * functions have been added to mitigate the well-known issues around setting
469  * allowances. See {IERC20-approve}.
470  */
471 contract YearnFinanceEcosystem is IERC20, Ownable {
472     using SafeMath for uint256;
473     using Address for address;
474     
475     mapping (address => uint256) private _balances;
476 
477     mapping (address => mapping (address => uint256)) private _allowances;
478 
479     uint256 private _totalSupply;
480 
481     string private _name;
482     string private _symbol;
483     uint8 private _decimals;
484 
485     /**
486      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
487      * a default value of 18.
488      */
489     constructor () {
490         _name = "Yearn Finance Ecosystem";
491         _symbol = "YFIEC";
492         _decimals = 8;
493         uint256 _maxSupply = 25000;
494         _mintOnce(msg.sender, _maxSupply.mul(10 ** _decimals));
495     }
496 
497     receive() external payable {
498         revert();
499     }
500 
501     /**
502      * @dev Returns the name of the token.
503      */
504     function name() public view returns (string memory) {
505         return _name;
506     }
507 
508     /**
509      * @dev Returns the symbol of the token, usually a shorter version of the
510      * name.
511      */
512     function symbol() public view returns (string memory) {
513         return _symbol;
514     }
515 
516     /**
517      * @dev Returns the number of decimals used to get its user representation.
518      * For example, if `decimals` equals `2`, a balance of `505` tokens should
519      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
520      *
521      * Tokens usually opt for a value of 18, imitating the relationship between
522      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
523      * called.
524      *
525      * NOTE: This information is only used for _display_ purposes: it in
526      * no way affects any of the arithmetic of the contract, including
527      * {IERC20-balanceOf} and {IERC20-transfer}.
528      */
529     function decimals() public view returns (uint8) {
530         return _decimals;
531     }
532 
533     /**
534      * @dev See {IERC20-totalSupply}.
535      */
536     function totalSupply() public view override returns (uint256) {
537         return _totalSupply;
538     }
539 
540     /**
541      * @dev See {IERC20-balanceOf}.
542      */
543     function balanceOf(address account) public view override returns (uint256) {
544         return _balances[account];
545     }
546 
547     /**
548      * @dev See {IERC20-transfer}.
549      *
550      * Requirements:
551      *
552      * - `recipient` cannot be the zero address.
553      * - the caller must have a balance of at least `amount`.
554      */
555     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
556         _transfer(_msgSender(), recipient, amount);
557         return true;
558     }
559 
560     /**
561      * @dev See {IERC20-allowance}.
562      */
563     function allowance(address owner, address spender) public view virtual override returns (uint256) {
564         return _allowances[owner][spender];
565     }
566 
567     /**
568      * @dev See {IERC20-approve}.
569      *
570      * Requirements:
571      *
572      * - `spender` cannot be the zero address.
573      */
574     function approve(address spender, uint256 amount) public virtual override returns (bool) {
575         _approve(_msgSender(), spender, amount);
576         return true;
577     }
578 
579     /**
580      * @dev See {IERC20-transferFrom}.
581      *
582      * Emits an {Approval} event indicating the updated allowance. This is not
583      * required by the EIP. See the note at the beginning of {ERC20};
584      *
585      * Requirements:
586      * - `sender` and `recipient` cannot be the zero address.
587      * - `sender` must have a balance of at least `amount`.
588      * - the caller must have allowance for ``sender``'s tokens of at least
589      * `amount`.
590      */
591     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
592         _transfer(sender, recipient, amount);
593         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
594         return true;
595     }
596 
597     /**
598      * @dev Atomically increases the allowance granted to `spender` by the caller.
599      *
600      * This is an alternative to {approve} that can be used as a mitigation for
601      * problems described in {IERC20-approve}.
602      *
603      * Emits an {Approval} event indicating the updated allowance.
604      *
605      * Requirements:
606      *
607      * - `spender` cannot be the zero address.
608      */
609     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
610         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
611         return true;
612     }
613 
614     /**
615      * @dev Atomically decreases the allowance granted to `spender` by the caller.
616      *
617      * This is an alternative to {approve} that can be used as a mitigation for
618      * problems described in {IERC20-approve}.
619      *
620      * Emits an {Approval} event indicating the updated allowance.
621      *
622      * Requirements:
623      *
624      * - `spender` cannot be the zero address.
625      * - `spender` must have allowance for the caller of at least
626      * `subtractedValue`.
627      */
628     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
629         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
630         return true;
631     }
632 
633     /**
634      * @dev Moves tokens `amount` from `sender` to `recipient`.
635      *
636      * This is internal function is equivalent to {transfer}, and can be used to
637      * e.g. implement automatic token fees, slashing mechanisms, etc.
638      *
639      * Emits a {Transfer} event.
640      *
641      * Requirements:
642      *
643      * - `sender` cannot be the zero address.
644      * - `recipient` cannot be the zero address.
645      * - `sender` must have a balance of at least `amount`.
646      */
647     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
648         require(sender != address(0), "ERC20: transfer from the zero address");
649         require(recipient != address(0), "ERC20: transfer to the zero address");
650 
651         _beforeTokenTransfer(sender, recipient, amount);
652 
653         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
654         _balances[recipient] = _balances[recipient].add(amount);
655         emit Transfer(sender, recipient, amount);
656     }
657 
658     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
659      * the total supply.
660      *
661      * Emits a {Transfer} event with `from` set to the zero address.
662      *
663      * Requirements
664      *
665      * - `to` cannot be the zero address.
666      */
667     function _mintOnce(address account, uint256 amount) internal virtual {
668         require(account != address(0), "ERC20: mint to the zero address");
669 
670         _beforeTokenTransfer(address(0), account, amount);
671 
672         _totalSupply = _totalSupply.add(amount);
673         _balances[account] = _balances[account].add(amount);
674         emit Transfer(address(0), account, amount);
675     }
676 
677     /**
678      * @dev Destroys `amount` tokens from `account`, reducing the
679      * total supply.
680      *
681      * Emits a {Transfer} event with `to` set to the zero address.
682      *
683      * Requirements
684      *
685      * - `account` cannot be the zero address.
686      * - `account` must have at least `amount` tokens.
687      */
688     function _burn(address account, uint256 amount) internal virtual {
689         require(account != address(0), "ERC20: burn from the zero address");
690 
691         _beforeTokenTransfer(account, address(0), amount);
692 
693         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
694         _totalSupply = _totalSupply.sub(amount);
695         emit Transfer(account, address(0), amount);
696     }
697 
698     /**
699      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
700      *
701      * This internal function is equivalent to `approve`, and can be used to
702      * e.g. set automatic allowances for certain subsystems, etc.
703      *
704      * Emits an {Approval} event.
705      *
706      * Requirements:
707      *
708      * - `owner` cannot be the zero address.
709      * - `spender` cannot be the zero address.
710      */
711     function _approve(address owner, address spender, uint256 amount) internal virtual {
712         require(owner != address(0), "ERC20: approve from the zero address");
713         require(spender != address(0), "ERC20: approve to the zero address");
714 
715         _allowances[owner][spender] = amount;
716         emit Approval(owner, spender, amount);
717     }
718 
719     /**
720      * @dev Sets {decimals} to a value other than the default one of 18.
721      *
722      * WARNING: This function should only be called from the constructor. Most
723      * applications that interact with token contracts will not expect
724      * {decimals} to ever change, and may work incorrectly if it does.
725      */
726     function _setupDecimals(uint8 decimals_) internal {
727         _decimals = decimals_;
728     }
729 
730     /**
731      * @dev Hook that is called before any transfer of tokens. This includes
732      * minting and burning.
733      *
734      * Calling conditions:
735      *
736      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
737      * will be to transferred to `to`.
738      * - when `from` is zero, `amount` tokens will be minted for `to`.
739      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
740      * - `from` and `to` are never both zero.
741      *
742      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
743      */
744     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
745 }