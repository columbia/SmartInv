1 pragma solidity ^0.6.0;
2 
3 
4 /**
5  * @dev Collection of functions related to the address type
6  */
7 library Address {
8     /**
9      * @dev Returns true if `account` is a contract.
10      *
11      * [IMPORTANT]
12      * ====
13      * It is unsafe to assume that an address for which this function returns
14      * false is an externally-owned account (EOA) and not a contract.
15      *
16      * Among others, `isContract` will return false for the following
17      * types of addresses:
18      *
19      *  - an externally-owned account
20      *  - a contract in construction
21      *  - an address where a contract will be created
22      *  - an address where a contract lived, but was destroyed
23      * ====
24      */
25     function isContract(address account) internal view returns (bool) {
26         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
27         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
28         // for accounts without code, i.e. `keccak256('')`
29         bytes32 codehash;
30         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
31         // solhint-disable-next-line no-inline-assembly
32         assembly { codehash := extcodehash(account) }
33         return (codehash != accountHash && codehash != 0x0);
34     }
35 
36     /**
37      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
38      * `recipient`, forwarding all available gas and reverting on errors.
39      *
40      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
41      * of certain opcodes, possibly making contracts go over the 2300 gas limit
42      * imposed by `transfer`, making them unable to receive funds via
43      * `transfer`. {sendValue} removes this limitation.
44      *
45      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
46      *
47      * IMPORTANT: because control is transferred to `recipient`, care must be
48      * taken to not create reentrancy vulnerabilities. Consider using
49      * {ReentrancyGuard} or the
50      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
51      */
52     function sendValue(address payable recipient, uint256 amount) internal {
53         require(address(this).balance >= amount, "Address: insufficient balance");
54 
55         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
56         (bool success, ) = recipient.call{ value: amount }("");
57         require(success, "Address: unable to send value, recipient may have reverted");
58     }
59 
60     /**
61      * @dev Performs a Solidity function call using a low level `call`. A
62      * plain`call` is an unsafe replacement for a function call: use this
63      * function instead.
64      *
65      * If `target` reverts with a revert reason, it is bubbled up by this
66      * function (like regular Solidity function calls).
67      *
68      * Returns the raw returned data. To convert to the expected return value,
69      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
70      *
71      * Requirements:
72      *
73      * - `target` must be a contract.
74      * - calling `target` with `data` must not revert.
75      *
76      * _Available since v3.1._
77      */
78     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
79         return functionCall(target, data, "Address: low-level call failed");
80     }
81 
82     /**
83      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
84      * `errorMessage` as a fallback revert reason when `target` reverts.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
89         return _functionCallWithValue(target, data, 0, errorMessage);
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
94      * but also transferring `value` wei to `target`.
95      *
96      * Requirements:
97      *
98      * - the calling contract must have an ETH balance of at least `value`.
99      * - the called Solidity function must be `payable`.
100      *
101      * _Available since v3.1._
102      */
103     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
109      * with `errorMessage` as a fallback revert reason when `target` reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
114         require(address(this).balance >= value, "Address: insufficient balance for call");
115         return _functionCallWithValue(target, data, value, errorMessage);
116     }
117 
118     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
119         require(isContract(target), "Address: call to non-contract");
120 
121         // solhint-disable-next-line avoid-low-level-calls
122         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
123         if (success) {
124             return returndata;
125         } else {
126             // Look for revert reason and bubble it up if present
127             if (returndata.length > 0) {
128                 // The easiest way to bubble the revert reason is using memory via assembly
129 
130                 // solhint-disable-next-line no-inline-assembly
131                 assembly {
132                     let returndata_size := mload(returndata)
133                     revert(add(32, returndata), returndata_size)
134                 }
135             } else {
136                 revert(errorMessage);
137             }
138         }
139     }
140 }
141 
142 /**
143  * @dev Wrappers over Solidity's arithmetic operations with added overflow
144  * checks.
145  *
146  * Arithmetic operations in Solidity wrap on overflow. This can easily result
147  * in bugs, because programmers usually assume that an overflow raises an
148  * error, which is the standard behavior in high level programming languages.
149  * `SafeMath` restores this intuition by reverting the transaction when an
150  * operation overflows.
151  *
152  * Using this library instead of the unchecked operations eliminates an entire
153  * class of bugs, so it's recommended to use it always.
154  */
155 library SafeMath {
156     /**
157      * @dev Returns the addition of two unsigned integers, reverting on
158      * overflow.
159      *
160      * Counterpart to Solidity's `+` operator.
161      *
162      * Requirements:
163      *
164      * - Addition cannot overflow.
165      */
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167         uint256 c = a + b;
168         require(c >= a, "SafeMath: addition overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      *
181      * - Subtraction cannot overflow.
182      */
183     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
184         return sub(a, b, "SafeMath: subtraction overflow");
185     }
186 
187     /**
188      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
189      * overflow (when the result is negative).
190      *
191      * Counterpart to Solidity's `-` operator.
192      *
193      * Requirements:
194      *
195      * - Subtraction cannot overflow.
196      */
197     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b <= a, errorMessage);
199         uint256 c = a - b;
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the multiplication of two unsigned integers, reverting on
206      * overflow.
207      *
208      * Counterpart to Solidity's `*` operator.
209      *
210      * Requirements:
211      *
212      * - Multiplication cannot overflow.
213      */
214     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
215         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
216         // benefit is lost if 'b' is also tested.
217         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
218         if (a == 0) {
219             return 0;
220         }
221 
222         uint256 c = a * b;
223         require(c / a == b, "SafeMath: multiplication overflow");
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the integer division of two unsigned integers. Reverts on
230      * division by zero. The result is rounded towards zero.
231      *
232      * Counterpart to Solidity's `/` operator. Note: this function uses a
233      * `revert` opcode (which leaves remaining gas untouched) while Solidity
234      * uses an invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function div(uint256 a, uint256 b) internal pure returns (uint256) {
241         return div(a, b, "SafeMath: division by zero");
242     }
243 
244     /**
245      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
246      * division by zero. The result is rounded towards zero.
247      *
248      * Counterpart to Solidity's `/` operator. Note: this function uses a
249      * `revert` opcode (which leaves remaining gas untouched) while Solidity
250      * uses an invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b > 0, errorMessage);
258         uint256 c = a / b;
259         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * Reverts when dividing by zero.
267      *
268      * Counterpart to Solidity's `%` operator. This function uses a `revert`
269      * opcode (which leaves remaining gas untouched) while Solidity uses an
270      * invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      *
274      * - The divisor cannot be zero.
275      */
276     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
277         return mod(a, b, "SafeMath: modulo by zero");
278     }
279 
280     /**
281      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
282      * Reverts with custom message when dividing by zero.
283      *
284      * Counterpart to Solidity's `%` operator. This function uses a `revert`
285      * opcode (which leaves remaining gas untouched) while Solidity uses an
286      * invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      *
290      * - The divisor cannot be zero.
291      */
292     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         require(b != 0, errorMessage);
294         return a % b;
295     }
296 }
297 
298 /**
299  * @title Ownable
300  * @dev The Ownable contract has an owner address, and provides basic authorization control
301  * functions, this simplifies the implementation of "user permissions".
302  */
303 contract Ownable {
304     address public owner;
305 
306 
307     /**
308      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
309      * account.
310      */
311     constructor() public {
312         owner = msg.sender;
313     }
314 
315     /**
316      * @dev Throws if called by any account other than the owner.
317      */
318     modifier onlyOwner() {
319         require(msg.sender == owner, "Only owner");
320         _;
321     }
322 
323     /**
324      * @dev Allows the current owner to transfer control of the contract to a newOwner.
325      * @param newOwner The address to transfer ownership to.
326      */
327     function transferOwnership(address newOwner) public onlyOwner {
328         require(newOwner != address(0), "Transfer to null address is not allowed");
329         emit OwnershipTransferred(owner, newOwner);
330         owner = newOwner;
331     }
332 
333     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
334 
335 }
336 
337 contract Beneficiary is Ownable {
338 
339     address payable public beneficiary;
340 
341     constructor() public  {
342         beneficiary = msg.sender;
343     }
344 
345     function setBeneficiary(address payable _beneficiary) public onlyOwner {
346         beneficiary = _beneficiary;
347     }
348 
349     function withdrawal(uint256 value) public onlyOwner {
350         if (value > address(this).balance) {
351             revert("Insufficient balance");
352         }
353 
354         beneficiaryPayout(value);
355     }
356 
357     function withdrawalAll() public onlyOwner {
358         beneficiaryPayout(address(this).balance);
359     }
360 
361     function beneficiaryPayout(uint256 value) internal {
362         beneficiary.transfer(value);
363         emit BeneficiaryPayout(value);
364     }
365 
366     event BeneficiaryPayout(uint256 value);
367 }
368 
369 
370 
371 contract Manageable is Beneficiary {
372 
373     mapping(address => bool) public managers;
374 
375     modifier onlyManager() {
376 
377         require(managers[msg.sender] || msg.sender == address(this), "Only managers allowed");
378         _;
379     }
380 
381 
382     constructor() public {
383         managers[msg.sender] = true;
384     }
385 
386     function setManager(address _manager) public onlyOwner {
387         managers[_manager] = true;
388     }
389 
390     function deleteManager(address _manager) public onlyOwner {
391         delete managers[_manager];
392     }
393 
394 }
395 
396 
397 
398 /**
399  * @dev Interface of the ERC20 standard as defined in the EIP.
400  */
401 interface IERC20 {
402     /**
403      * @dev Returns the amount of tokens in existence.
404      */
405     function totalSupply() external view returns (uint256);
406 
407     /**
408      * @dev Returns the amount of tokens owned by `account`.
409      */
410     function balanceOf(address account) external view returns (uint256);
411 
412     /**
413      * @dev Moves `amount` tokens from the caller's account to `recipient`.
414      *
415      * Returns a boolean value indicating whether the operation succeeded.
416      *
417      * Emits a {Transfer} event.
418      */
419     function transfer(address recipient, uint256 amount) external returns (bool);
420 
421     /**
422      * @dev Returns the remaining number of tokens that `spender` will be
423      * allowed to spend on behalf of `owner` through {transferFrom}. This is
424      * zero by default.
425      *
426      * This value changes when {approve} or {transferFrom} are called.
427      */
428     function allowance(address owner, address spender) external view returns (uint256);
429 
430     /**
431      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
432      *
433      * Returns a boolean value indicating whether the operation succeeded.
434      *
435      * IMPORTANT: Beware that changing an allowance with this method brings the risk
436      * that someone may use both the old and the new allowance by unfortunate
437      * transaction ordering. One possible solution to mitigate this race
438      * condition is to first reduce the spender's allowance to 0 and set the
439      * desired value afterwards:
440      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
441      *
442      * Emits an {Approval} event.
443      */
444     function approve(address spender, uint256 amount) external returns (bool);
445 
446     /**
447      * @dev Moves `amount` tokens from `sender` to `recipient` using the
448      * allowance mechanism. `amount` is then deducted from the caller's
449      * allowance.
450      *
451      * Returns a boolean value indicating whether the operation succeeded.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
456 
457     /**
458      * @dev Emitted when `value` tokens are moved from one account (`from`) to
459      * another (`to`).
460      *
461      * Note that `value` may be zero.
462      */
463     event Transfer(address indexed from, address indexed to, uint256 value);
464 
465     /**
466      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
467      * a call to {approve}. `value` is the new allowance.
468      */
469     event Approval(address indexed owner, address indexed spender, uint256 value);
470 }
471 
472 
473 abstract contract Context {
474     function _msgSender() internal view virtual returns (address payable) {
475         return msg.sender;
476     }
477 
478     function _msgData() internal view virtual returns (bytes memory) {
479         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
480         return msg.data;
481     }
482 }
483 
484 /**
485  * @dev Implementation of the {IERC20} interface.
486  *
487  * This implementation is agnostic to the way tokens are created. This means
488  * that a supply mechanism has to be added in a derived contract using {_mint}.
489  * For a generic mechanism see {ERC20PresetMinterPauser}.
490  *
491  * TIP: For a detailed writeup see our guide
492  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
493  * to implement supply mechanisms].
494  *
495  * We have followed general OpenZeppelin guidelines: functions revert instead
496  * of returning `false` on failure. This behavior is nonetheless conventional
497  * and does not conflict with the expectations of ERC20 applications.
498  *
499  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
500  * This allows applications to reconstruct the allowance for all accounts just
501  * by listening to said events. Other implementations of the EIP may not emit
502  * these events, as it isn't required by the specification.
503  *
504  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
505  * functions have been added to mitigate the well-known issues around setting
506  * allowances. See {IERC20-approve}.
507  */
508 contract ERC20 is Context, IERC20 {
509     using SafeMath for uint256;
510     using Address for address;
511 
512     mapping (address => uint256) private _balances;
513 
514     mapping (address => mapping (address => uint256)) private _allowances;
515 
516     uint256 private _totalSupply;
517 
518     string private _name;
519     string private _symbol;
520     uint8 private _decimals;
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
531     constructor (string memory name, string memory symbol) public {
532         _name = name;
533         _symbol = symbol;
534         _decimals = 18;
535     }
536 
537     /**
538      * @dev Returns the name of the token.
539      */
540     function name() public view returns (string memory) {
541         return _name;
542     }
543 
544     /**
545      * @dev Returns the symbol of the token, usually a shorter version of the
546      * name.
547      */
548     function symbol() public view returns (string memory) {
549         return _symbol;
550     }
551 
552     /**
553      * @dev Returns the number of decimals used to get its user representation.
554      * For example, if `decimals` equals `2`, a balance of `505` tokens should
555      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
556      *
557      * Tokens usually opt for a value of 18, imitating the relationship between
558      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
559      * called.
560      *
561      * NOTE: This information is only used for _display_ purposes: it in
562      * no way affects any of the arithmetic of the contract, including
563      * {IERC20-balanceOf} and {IERC20-transfer}.
564      */
565     function decimals() public view returns (uint8) {
566         return _decimals;
567     }
568 
569     /**
570      * @dev See {IERC20-totalSupply}.
571      */
572     function totalSupply() public view override returns (uint256) {
573         return _totalSupply;
574     }
575 
576     /**
577      * @dev See {IERC20-balanceOf}.
578      */
579     function balanceOf(address account) public view override returns (uint256) {
580         return _balances[account];
581     }
582 
583     /**
584      * @dev See {IERC20-transfer}.
585      *
586      * Requirements:
587      *
588      * - `recipient` cannot be the zero address.
589      * - the caller must have a balance of at least `amount`.
590      */
591     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
592         _transfer(_msgSender(), recipient, amount);
593         return true;
594     }
595 
596     /**
597      * @dev See {IERC20-allowance}.
598      */
599     function allowance(address owner, address spender) public view virtual override returns (uint256) {
600         return _allowances[owner][spender];
601     }
602 
603     /**
604      * @dev See {IERC20-approve}.
605      *
606      * Requirements:
607      *
608      * - `spender` cannot be the zero address.
609      */
610     function approve(address spender, uint256 amount) public virtual override returns (bool) {
611         _approve(_msgSender(), spender, amount);
612         return true;
613     }
614 
615     /**
616      * @dev See {IERC20-transferFrom}.
617      *
618      * Emits an {Approval} event indicating the updated allowance. This is not
619      * required by the EIP. See the note at the beginning of {ERC20};
620      *
621      * Requirements:
622      * - `sender` and `recipient` cannot be the zero address.
623      * - `sender` must have a balance of at least `amount`.
624      * - the caller must have allowance for ``sender``'s tokens of at least
625      * `amount`.
626      */
627     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
628         _transfer(sender, recipient, amount);
629         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
630         return true;
631     }
632 
633     /**
634      * @dev Atomically increases the allowance granted to `spender` by the caller.
635      *
636      * This is an alternative to {approve} that can be used as a mitigation for
637      * problems described in {IERC20-approve}.
638      *
639      * Emits an {Approval} event indicating the updated allowance.
640      *
641      * Requirements:
642      *
643      * - `spender` cannot be the zero address.
644      */
645     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
646         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
647         return true;
648     }
649 
650     /**
651      * @dev Atomically decreases the allowance granted to `spender` by the caller.
652      *
653      * This is an alternative to {approve} that can be used as a mitigation for
654      * problems described in {IERC20-approve}.
655      *
656      * Emits an {Approval} event indicating the updated allowance.
657      *
658      * Requirements:
659      *
660      * - `spender` cannot be the zero address.
661      * - `spender` must have allowance for the caller of at least
662      * `subtractedValue`.
663      */
664     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
665         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
666         return true;
667     }
668 
669     /**
670      * @dev Moves tokens `amount` from `sender` to `recipient`.
671      *
672      * This is internal function is equivalent to {transfer}, and can be used to
673      * e.g. implement automatic token fees, slashing mechanisms, etc.
674      *
675      * Emits a {Transfer} event.
676      *
677      * Requirements:
678      *
679      * - `sender` cannot be the zero address.
680      * - `recipient` cannot be the zero address.
681      * - `sender` must have a balance of at least `amount`.
682      */
683     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
684         require(sender != address(0), "ERC20: transfer from the zero address");
685         require(recipient != address(0), "ERC20: transfer to the zero address");
686 
687         _beforeTokenTransfer(sender, recipient, amount);
688 
689         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
690         _balances[recipient] = _balances[recipient].add(amount);
691         emit Transfer(sender, recipient, amount);
692     }
693 
694     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
695      * the total supply.
696      *
697      * Emits a {Transfer} event with `from` set to the zero address.
698      *
699      * Requirements
700      *
701      * - `to` cannot be the zero address.
702      */
703     function _mint(address account, uint256 amount) internal virtual {
704         require(account != address(0), "ERC20: mint to the zero address");
705 
706         _beforeTokenTransfer(address(0), account, amount);
707 
708         _totalSupply = _totalSupply.add(amount);
709         _balances[account] = _balances[account].add(amount);
710         emit Transfer(address(0), account, amount);
711     }
712 
713     /**
714      * @dev Destroys `amount` tokens from `account`, reducing the
715      * total supply.
716      *
717      * Emits a {Transfer} event with `to` set to the zero address.
718      *
719      * Requirements
720      *
721      * - `account` cannot be the zero address.
722      * - `account` must have at least `amount` tokens.
723      */
724     function _burn(address account, uint256 amount) internal virtual {
725         require(account != address(0), "ERC20: burn from the zero address");
726 
727         _beforeTokenTransfer(account, address(0), amount);
728 
729         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
730         _totalSupply = _totalSupply.sub(amount);
731         emit Transfer(account, address(0), amount);
732     }
733 
734     /**
735      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
736      *
737      * This is internal function is equivalent to `approve`, and can be used to
738      * e.g. set automatic allowances for certain subsystems, etc.
739      *
740      * Emits an {Approval} event.
741      *
742      * Requirements:
743      *
744      * - `owner` cannot be the zero address.
745      * - `spender` cannot be the zero address.
746      */
747     function _approve(address owner, address spender, uint256 amount) internal virtual {
748         require(owner != address(0), "ERC20: approve from the zero address");
749         require(spender != address(0), "ERC20: approve to the zero address");
750 
751         _allowances[owner][spender] = amount;
752         emit Approval(owner, spender, amount);
753     }
754 
755     /**
756      * @dev Sets {decimals} to a value other than the default one of 18.
757      *
758      * WARNING: This function should only be called from the constructor. Most
759      * applications that interact with token contracts will not expect
760      * {decimals} to ever change, and may work incorrectly if it does.
761      */
762     function _setupDecimals(uint8 decimals_) internal {
763         _decimals = decimals_;
764     }
765 
766     /**
767      * @dev Hook that is called before any transfer of tokens. This includes
768      * minting and burning.
769      *
770      * Calling conditions:
771      *
772      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
773      * will be to transferred to `to`.
774      * - when `from` is zero, `amount` tokens will be minted for `to`.
775      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
776      * - `from` and `to` are never both zero.
777      *
778      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
779      */
780     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
781 }
782 
783 
784 contract MBe is ERC20, Manageable {
785     uint public cap = 1_000_000 * 1e18;
786 
787     address payable operator = address(0);
788 
789     constructor() ERC20("MegaCryptoPolis $MEGA Token (MEGA)", "MEGA") public {
790         _mint(address(this), cap - 100_000 * 1e18);
791         _mint(address(0x333e3763085FC14854978f89261890339cB2F6a9), 100_000 * 1e18);
792     }
793 
794     function setOperator(address payable _operator) public onlyManager {
795         operator = _operator;
796         _approve(address(this), _operator, cap);
797     }
798 
799     function increaseOperatorAllowance() public onlyManager {
800         _approve(address(this), operator, allowance(address(this), operator) + cap);
801     }
802 
803     function decreaseOperatorAllowance() public onlyManager {
804         _approve(address(this), operator, 0);
805     }
806 }