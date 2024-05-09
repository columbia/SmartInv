1 pragma solidity ^0.7.0;
2 
3 library Math {
4     /**
5      * @dev Returns the largest of two numbers.
6      */
7     function max(uint256 a, uint256 b) internal pure returns (uint256) {
8         return a >= b ? a : b;
9     }
10 
11     /**
12      * @dev Returns the smallest of two numbers.
13      */
14     function min(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a < b ? a : b;
16     }
17 
18     /**
19      * @dev Returns the average of two numbers. The result is rounded towards
20      * zero.
21      */
22     function average(uint256 a, uint256 b) internal pure returns (uint256) {
23         // (a + b) / 2 can overflow, so we distribute
24         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
25     }
26 }
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address payable) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes memory) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38 
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
110 
111 library SafeMath {
112     /**
113      * @dev Returns the addition of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `+` operator.
117      *
118      * Requirements:
119      *
120      * - Addition cannot overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a, "SafeMath: addition overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return sub(a, b, "SafeMath: subtraction overflow");
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b <= a, errorMessage);
155         uint256 c = a - b;
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the multiplication of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `*` operator.
165      *
166      * Requirements:
167      *
168      * - Multiplication cannot overflow.
169      */
170     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
171         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
172         // benefit is lost if 'b' is also tested.
173         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
174         if (a == 0) {
175             return 0;
176         }
177 
178         uint256 c = a * b;
179         require(c / a == b, "SafeMath: multiplication overflow");
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b) internal pure returns (uint256) {
197         return div(a, b, "SafeMath: division by zero");
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
212     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         uint256 c = a / b;
215         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216 
217         return c;
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233         return mod(a, b, "SafeMath: modulo by zero");
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts with custom message when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         require(b != 0, errorMessage);
250         return a % b;
251     }
252 }
253 
254 library Address {
255     /**
256      * @dev Returns true if `account` is a contract.
257      *
258      * [IMPORTANT]
259      * ====
260      * It is unsafe to assume that an address for which this function returns
261      * false is an externally-owned account (EOA) and not a contract.
262      *
263      * Among others, `isContract` will return false for the following
264      * types of addresses:
265      *
266      *  - an externally-owned account
267      *  - a contract in construction
268      *  - an address where a contract will be created
269      *  - an address where a contract lived, but was destroyed
270      * ====
271      */
272     function isContract(address account) internal view returns (bool) {
273         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
274         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
275         // for accounts without code, i.e. `keccak256('')`
276         bytes32 codehash;
277         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
278         // solhint-disable-next-line no-inline-assembly
279         assembly { codehash := extcodehash(account) }
280         return (codehash != accountHash && codehash != 0x0);
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
303         (bool success, ) = recipient.call{ value: amount }("");
304         require(success, "Address: unable to send value, recipient may have reverted");
305     }
306 
307     /**
308      * @dev Performs a Solidity function call using a low level `call`. A
309      * plain`call` is an unsafe replacement for a function call: use this
310      * function instead.
311      *
312      * If `target` reverts with a revert reason, it is bubbled up by this
313      * function (like regular Solidity function calls).
314      *
315      * Returns the raw returned data. To convert to the expected return value,
316      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
317      *
318      * Requirements:
319      *
320      * - `target` must be a contract.
321      * - calling `target` with `data` must not revert.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
326         return functionCall(target, data, "Address: low-level call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
331      * `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
336         return _functionCallWithValue(target, data, 0, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but also transferring `value` wei to `target`.
342      *
343      * Requirements:
344      *
345      * - the calling contract must have an ETH balance of at least `value`.
346      * - the called Solidity function must be `payable`.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
356      * with `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         return _functionCallWithValue(target, data, value, errorMessage);
363     }
364 
365     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
366         require(isContract(target), "Address: call to non-contract");
367 
368         // solhint-disable-next-line avoid-low-level-calls
369         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
370         if (success) {
371             return returndata;
372         } else {
373             // Look for revert reason and bubble it up if present
374             if (returndata.length > 0) {
375                 // The easiest way to bubble the revert reason is using memory via assembly
376 
377                 // solhint-disable-next-line no-inline-assembly
378                 assembly {
379                     let returndata_size := mload(returndata)
380                     revert(add(32, returndata), returndata_size)
381                 }
382             } else {
383                 revert(errorMessage);
384             }
385         }
386     }
387 }
388 
389 contract ERC20 is Context, IERC20 {
390     using SafeMath for uint256;
391     using Address for address;
392 
393     mapping (address => uint256) private _balances;
394 
395     mapping (address => mapping (address => uint256)) private _allowances;
396 
397     uint256 private _totalSupply;
398 
399     string private _name;
400     string private _symbol;
401     uint8 private _decimals;
402 
403     /**
404      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
405      * a default value of 18.
406      *
407      * To select a different value for {decimals}, use {_setupDecimals}.
408      *
409      * All three of these values are immutable: they can only be set once during
410      * construction.
411      */
412     constructor (string memory name, string memory symbol) {
413         _name = name;
414         _symbol = symbol;
415         _decimals = 18;
416     }
417 
418     /**
419      * @dev Returns the name of the token.
420      */
421     function name() public view returns (string memory) {
422         return _name;
423     }
424 
425     /**
426      * @dev Returns the symbol of the token, usually a shorter version of the
427      * name.
428      */
429     function symbol() public view returns (string memory) {
430         return _symbol;
431     }
432 
433     /**
434      * @dev Returns the number of decimals used to get its user representation.
435      * For example, if `decimals` equals `2`, a balance of `505` tokens should
436      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
437      *
438      * Tokens usually opt for a value of 18, imitating the relationship between
439      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
440      * called.
441      *
442      * NOTE: This information is only used for _display_ purposes: it in
443      * no way affects any of the arithmetic of the contract, including
444      * {IERC20-balanceOf} and {IERC20-transfer}.
445      */
446     function decimals() public view returns (uint8) {
447         return _decimals;
448     }
449 
450     /**
451      * @dev See {IERC20-totalSupply}.
452      */
453     function totalSupply() public view override returns (uint256) {
454         return _totalSupply;
455     }
456 
457     /**
458      * @dev See {IERC20-balanceOf}.
459      */
460     function balanceOf(address account) public view override returns (uint256) {
461         return _balances[account];
462     }
463 
464     /**
465      * @dev See {IERC20-transfer}.
466      *
467      * Requirements:
468      *
469      * - `recipient` cannot be the zero address.
470      * - the caller must have a balance of at least `amount`.
471      */
472     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
473         _transfer(_msgSender(), recipient, amount);
474         return true;
475     }
476 
477     /**
478      * @dev See {IERC20-allowance}.
479      */
480     function allowance(address owner, address spender) public view virtual override returns (uint256) {
481         return _allowances[owner][spender];
482     }
483 
484     /**
485      * @dev See {IERC20-approve}.
486      *
487      * Requirements:
488      *
489      * - `spender` cannot be the zero address.
490      */
491     function approve(address spender, uint256 amount) public virtual override returns (bool) {
492         _approve(_msgSender(), spender, amount);
493         return true;
494     }
495 
496     /**
497      * @dev See {IERC20-transferFrom}.
498      *
499      * Emits an {Approval} event indicating the updated allowance. This is not
500      * required by the EIP. See the note at the beginning of {ERC20};
501      *
502      * Requirements:
503      * - `sender` and `recipient` cannot be the zero address.
504      * - `sender` must have a balance of at least `amount`.
505      * - the caller must have allowance for ``sender``'s tokens of at least
506      * `amount`.
507      */
508     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
509         _transfer(sender, recipient, amount);
510         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
511         return true;
512     }
513 
514     /**
515      * @dev Atomically increases the allowance granted to `spender` by the caller.
516      *
517      * This is an alternative to {approve} that can be used as a mitigation for
518      * problems described in {IERC20-approve}.
519      *
520      * Emits an {Approval} event indicating the updated allowance.
521      *
522      * Requirements:
523      *
524      * - `spender` cannot be the zero address.
525      */
526     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
527         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
528         return true;
529     }
530 
531     /**
532      * @dev Atomically decreases the allowance granted to `spender` by the caller.
533      *
534      * This is an alternative to {approve} that can be used as a mitigation for
535      * problems described in {IERC20-approve}.
536      *
537      * Emits an {Approval} event indicating the updated allowance.
538      *
539      * Requirements:
540      *
541      * - `spender` cannot be the zero address.
542      * - `spender` must have allowance for the caller of at least
543      * `subtractedValue`.
544      */
545     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
546         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
547         return true;
548     }
549 
550     /**
551      * @dev Moves tokens `amount` from `sender` to `recipient`.
552      *
553      * This is internal function is equivalent to {transfer}, and can be used to
554      * e.g. implement automatic token fees, slashing mechanisms, etc.
555      *
556      * Emits a {Transfer} event.
557      *
558      * Requirements:
559      *
560      * - `sender` cannot be the zero address.
561      * - `recipient` cannot be the zero address.
562      * - `sender` must have a balance of at least `amount`.
563      */
564     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
565         require(sender != address(0), "ERC20: transfer from the zero address");
566         require(recipient != address(0), "ERC20: transfer to the zero address");
567 
568         _beforeTokenTransfer(sender, recipient, amount);
569 
570         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
571         _balances[recipient] = _balances[recipient].add(amount);
572         emit Transfer(sender, recipient, amount);
573     }
574 
575     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
576      * the total supply.
577      *
578      * Emits a {Transfer} event with `from` set to the zero address.
579      *
580      * Requirements
581      *
582      * - `to` cannot be the zero address.
583      */
584     function _mint(address account, uint256 amount) internal virtual {
585         require(account != address(0), "ERC20: mint to the zero address");
586 
587         _beforeTokenTransfer(address(0), account, amount);
588 
589         _totalSupply = _totalSupply.add(amount);
590         _balances[account] = _balances[account].add(amount);
591         emit Transfer(address(0), account, amount);
592     }
593 
594     /**
595      * @dev Destroys `amount` tokens from `account`, reducing the
596      * total supply.
597      *
598      * Emits a {Transfer} event with `to` set to the zero address.
599      *
600      * Requirements
601      *
602      * - `account` cannot be the zero address.
603      * - `account` must have at least `amount` tokens.
604      */
605     function _burn(address account, uint256 amount) internal virtual {
606         require(account != address(0), "ERC20: burn from the zero address");
607 
608         _beforeTokenTransfer(account, address(0), amount);
609 
610         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
611         _totalSupply = _totalSupply.sub(amount);
612         emit Transfer(account, address(0), amount);
613     }
614 
615     /**
616      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
617      *
618      * This is internal function is equivalent to `approve`, and can be used to
619      * e.g. set automatic allowances for certain subsystems, etc.
620      *
621      * Emits an {Approval} event.
622      *
623      * Requirements:
624      *
625      * - `owner` cannot be the zero address.
626      * - `spender` cannot be the zero address.
627      */
628     function _approve(address owner, address spender, uint256 amount) internal virtual {
629         require(owner != address(0), "ERC20: approve from the zero address");
630         require(spender != address(0), "ERC20: approve to the zero address");
631 
632         _allowances[owner][spender] = amount;
633         emit Approval(owner, spender, amount);
634     }
635 
636     /**
637      * @dev Sets {decimals} to a value other than the default one of 18.
638      *
639      * WARNING: This function should only be called from the constructor. Most
640      * applications that interact with token contracts will not expect
641      * {decimals} to ever change, and may work incorrectly if it does.
642      */
643     function _setupDecimals(uint8 decimals_) internal {
644         _decimals = decimals_;
645     }
646 
647     /**
648      * @dev Hook that is called before any transfer of tokens. This includes
649      * minting and burning.
650      *
651      * Calling conditions:
652      *
653      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
654      * will be to transferred to `to`.
655      * - when `from` is zero, `amount` tokens will be minted for `to`.
656      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
657      * - `from` and `to` are never both zero.
658      *
659      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
660      */
661     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
662 }
663 
664 
665 contract Ownable is Context {
666     address private _owner;
667 
668     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
669 
670     /**
671      * @dev Initializes the contract setting the deployer as the initial owner.
672      */
673     constructor () {
674         address msgSender = _msgSender();
675         _owner = msgSender;
676         emit OwnershipTransferred(address(0), msgSender);
677     }
678 
679     /**
680      * @dev Returns the address of the current owner.
681      */
682     function owner() public view returns (address) {
683         return _owner;
684     }
685 
686     /**
687      * @dev Throws if called by any account other than the owner.
688      */
689     modifier onlyOwner() {
690         require(_owner == _msgSender(), "Ownable: caller is not the owner");
691         _;
692     }
693 
694     /**
695      * @dev Leaves the contract without owner. It will not be possible to call
696      * `onlyOwner` functions anymore. Can only be called by the current owner.
697      *
698      * NOTE: Renouncing ownership will leave the contract without an owner,
699      * thereby removing any functionality that is only available to the owner.
700      */
701     function renounceOwnership() public virtual onlyOwner {
702         emit OwnershipTransferred(_owner, address(0));
703         _owner = address(0);
704     }
705 
706     /**
707      * @dev Transfers ownership of the contract to a new account (`newOwner`).
708      * Can only be called by the current owner.
709      */
710     function transferOwnership(address newOwner) public virtual onlyOwner {
711         require(newOwner != address(0), "Ownable: new owner is the zero address");
712         emit OwnershipTransferred(_owner, newOwner);
713         _owner = newOwner;
714     }
715 }
716 
717 
718 contract AzukiToken is ERC20("DokiDokiAzuki", "AZUKI"), Ownable {
719     using SafeMath for uint256;
720     using Address for address;
721 
722     mapping(string => uint) public operationLockTime;
723     mapping(string => bool) public operationTimelockEnabled;
724     string private MINT = "mint";
725     string private TRANSFER = "transfer";
726     string private ADDMINTER = "add_minter";
727     string private BURNRATE = "burn_rate";
728     uint public unlockDuration = 2 days;
729 
730     // mint for Owner
731     address public mintTo = address(0);
732     uint public mintAmount = 0;
733     // add mint for Owner
734     address public newMinter = address(0);
735     uint public newBurnRate = 0;
736 
737     mapping(address => bool) public minters;
738 
739     // transfer burn
740     uint public burnRate = 5;
741     mapping(address => bool) public transferBlacklist;
742     mapping(address => bool) public transferFromBlacklist;
743 
744     event GonnaMint(address to, uint amount, uint releaseTime);
745     event GonnaAddMinter(address newMinter, uint releaseTime);
746     event GonnaLockTransfer(uint releaseTime);
747     event GonnaChangeBurnRate(uint burnRate);
748 
749     modifier onlyMinter() {
750         require(minters[msg.sender], "Restricted to minters.");
751         _;
752     }
753 
754     function mint(address to, uint amount) public onlyMinter {
755         if (operationTimelockEnabled[MINT]) {
756             require(msg.sender != owner(), "Sorry, this function has been locked for Owner.");
757         }
758         _mint(to, amount);
759     }
760 
761     function burn(uint amount) public {
762         require(amount > 0);
763         require(balanceOf(msg.sender) >= amount);
764         _burn(msg.sender, amount);
765     }
766 
767     function addMinter(address account) public onlyOwner {
768         require(!operationTimelockEnabled[ADDMINTER], "Sorry, this function has been locked for Owner.");
769         minters[account] = true;
770     }
771 
772     function removeMinter(address account) public onlyOwner {
773         minters[account] = false;
774     }
775 
776     function gonnaMint(address to, uint amount) public onlyOwner {
777         mintTo = to;
778         mintAmount = amount;
779         operationLockTime[MINT] = block.timestamp + unlockDuration;
780 
781         emit GonnaMint(to, amount, operationLockTime[MINT]);
782     }
783 
784     function releaseMint() public onlyOwner {
785         require(mintAmount != 0, "mint amount can not be 0.");
786         require(block.timestamp >= operationLockTime[MINT], "Mint operation is pending.");
787         _mint(mintTo, mintAmount);
788         mintTo = address(0);
789         mintAmount = 0;
790     }
791 
792     function gonnaAddMinter(address account) public onlyOwner {
793         newMinter = account;
794         operationLockTime[ADDMINTER] = block.timestamp + unlockDuration;
795 
796         emit GonnaAddMinter(account, operationLockTime[ADDMINTER]);
797     }
798 
799     function releaseNewMinter() public onlyOwner {
800         require(newMinter != address(0), "New minter can not be 0x000.");
801         require(block.timestamp >= operationLockTime[ADDMINTER], "Add minter operation is pending.");
802         minters[newMinter] = true;
803         newMinter = address(0);
804     }
805 
806     function gonnaLockTransfer() public onlyOwner {
807         operationLockTime[TRANSFER] = block.timestamp + unlockDuration;
808 
809         emit GonnaLockTransfer(operationLockTime[TRANSFER]);
810     }
811 
812     function releaseTransferLock() public onlyOwner {
813         require(!operationTimelockEnabled[TRANSFER], "Transfer is being locked.");
814         require(block.timestamp >= operationLockTime[TRANSFER], "Transfer lock operation is pending.");
815         operationTimelockEnabled[TRANSFER] = true;
816     }
817 
818     function unlockTransfer() public onlyOwner {
819         operationTimelockEnabled[TRANSFER] = false;
820     }
821 
822     function gonnaChangeBurnRate(uint newRate) public onlyOwner {
823         newBurnRate = newRate;
824         operationLockTime[BURNRATE] = block.timestamp + unlockDuration;
825         emit GonnaChangeBurnRate(newRate);
826     }
827 
828     function releaseNewBurnRate() public onlyOwner {
829         require(block.timestamp >= operationLockTime[BURNRATE], "Changing to new burning rate is pending.");
830         burnRate = newBurnRate;
831     }
832 
833     function changeTimelockDuration(uint duration) public onlyOwner {
834         require(duration >= 1 days, "Duration must be greater than 1 day.");
835         unlockDuration = duration;
836     }
837 
838     function lockMint() public onlyOwner {
839         operationTimelockEnabled[MINT] = true;
840     }
841 
842     function lockAddMinter() public onlyOwner {
843         operationTimelockEnabled[ADDMINTER] = true;
844     }
845 
846     function addToTransferBlacklist(address account) public onlyOwner {
847         transferBlacklist[account] = true;
848     }
849 
850     function removeFromTransferBlacklist(address account) public onlyOwner {
851         transferBlacklist[account] = false;
852     }
853 
854     function addToTransferFromBlacklist(address account) public onlyOwner {
855         transferFromBlacklist[account] = true;
856     }
857 
858     function removeFromTransferFromBlacklist(address account) public onlyOwner {
859         transferFromBlacklist[account] = false;
860     }
861 
862     function transfer(address recipient, uint256 amount) public override returns (bool) {
863         require(msg.sender == owner() || !operationTimelockEnabled[TRANSFER], "Transfer is being locked.");
864         uint256 burnAmount = 0;
865         if (transferBlacklist[msg.sender]) {
866             burnAmount = amount.mul(burnRate).div(100);
867         }
868         uint256 transferAmount = amount.sub(burnAmount);
869         require(balanceOf(msg.sender) >= amount, "insufficient balance.");
870         super.transfer(recipient, transferAmount);
871         if (burnAmount != 0) {
872             _burn(msg.sender, burnAmount);
873         }
874         return true;
875     }
876 
877     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
878         require(sender == owner() || !operationTimelockEnabled[TRANSFER], "TransferFrom is being locked.");
879         uint256 burnAmount = 0;
880         if (transferFromBlacklist[recipient]) {
881             burnAmount = amount.mul(burnRate).div(100);
882         }
883         uint256 transferAmount = amount.sub(burnAmount);
884         require(balanceOf(sender) >= amount, "insufficient balance.");
885         super.transferFrom(sender, recipient, transferAmount);
886         if (burnAmount != 0) {
887             _burn(sender, burnAmount);
888         }
889         return true;
890     }
891 }
892 
893 
894 library SafeERC20 {
895     using SafeMath for uint256;
896     using Address for address;
897 
898     function safeTransfer(IERC20 token, address to, uint256 value) internal {
899         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
900     }
901 
902     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
903         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
904     }
905 
906     /**
907      * @dev Deprecated. This function has issues similar to the ones found in
908      * {IERC20-approve}, and its usage is discouraged.
909      *
910      * Whenever possible, use {safeIncreaseAllowance} and
911      * {safeDecreaseAllowance} instead.
912      */
913     function safeApprove(IERC20 token, address spender, uint256 value) internal {
914         // safeApprove should only be called when setting an initial allowance,
915         // or when resetting it to zero. To increase and decrease it, use
916         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
917         // solhint-disable-next-line max-line-length
918         require((value == 0) || (token.allowance(address(this), spender) == 0),
919             "SafeERC20: approve from non-zero to non-zero allowance"
920         );
921         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
922     }
923 
924     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
925         uint256 newAllowance = token.allowance(address(this), spender).add(value);
926         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
927     }
928 
929     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
930         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
931         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
932     }
933 
934     /**
935      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
936      * on the return value: the return value is optional (but if data is returned, it must not be false).
937      * @param token The token targeted by the call.
938      * @param data The call data (encoded using abi.encode or one of its variants).
939      */
940     function _callOptionalReturn(IERC20 token, bytes memory data) private {
941         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
942         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
943         // the target address contains contract code and also asserts for success in the low-level call.
944 
945         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
946         if (returndata.length > 0) { // Return data is optional
947             // solhint-disable-next-line max-line-length
948             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
949         }
950     }
951 }
952 
953 
954 contract Pool2 is Ownable {
955     using SafeMath for uint256;
956     using SafeERC20 for AzukiToken;
957     using SafeERC20 for IERC20;
958     using Address for address;
959 
960     AzukiToken private azuki;
961     IERC20 private lpToken;
962 
963     //LP token balances
964     mapping(address => uint256) private _lpBalances;
965     uint private _lpTotalSupply;
966 
967     // decreasing period time
968     uint256 public constant DURATION = 2 weeks;
969     // initial amount of AZUKI
970     uint256 public initReward = 240000 * 1e18;
971     bool public haveStarted = false;
972     // next time of decreasing
973     uint256 public halvingTime = 0;
974     uint256 public lastUpdateTime = 0;
975     // distribution of per second
976     uint256 public rewardRate = 0;
977     uint256 public rewardPerLPToken = 0;
978     mapping(address => uint256) private rewards;
979     mapping(address => uint256) private userRewardPerTokenPaid;
980 
981 
982     // Something about dev.
983     address public devAddr;
984     uint256 public devDistributeRate = 0;
985     uint256 public lastDistributeTime = 0;
986     uint256 public devFinishTime = 0;
987     uint256 public devFundAmount = 236000 * 1e18;
988     uint256 public devDistributeDuration = 365 days;
989 
990     event Stake(address indexed from, uint amount);
991     event Withdraw(address indexed to, uint amount);
992     event Claim(address indexed to, uint amount);
993     event Decreasing(uint amount);
994     event Start(uint amount);
995 
996     constructor(address _azuki, address _lpToken) {
997         azuki = AzukiToken(_azuki);
998         lpToken = IERC20(_lpToken);
999         devAddr = owner();
1000     }
1001 
1002     function totalSupply() public view returns(uint256) {
1003         return _lpTotalSupply;
1004     }
1005 
1006     function balanceOf(address account) public view returns(uint256) {
1007         return _lpBalances[account];
1008     }
1009 
1010     function stake(uint amount) public shouldStarted {
1011         updateRewards(msg.sender);
1012         checkDecreasing();
1013         require(!address(msg.sender).isContract(), "Please use your individual account.");
1014         _lpTotalSupply = _lpTotalSupply.add(amount);
1015         _lpBalances[msg.sender] = _lpBalances[msg.sender].add(amount);
1016         lpToken.safeTransferFrom(msg.sender, address(this), amount);
1017         distributeDevFund();
1018         emit Stake(msg.sender, amount);
1019     }
1020 
1021     function withdraw(uint amount) public shouldStarted {
1022         updateRewards(msg.sender);
1023         checkDecreasing();
1024         require(amount <= _lpBalances[msg.sender] && _lpBalances[msg.sender] > 0, "Bad withdraw.");
1025         _lpTotalSupply = _lpTotalSupply.sub(amount);
1026         _lpBalances[msg.sender] = _lpBalances[msg.sender].sub(amount);
1027         lpToken.safeTransfer(msg.sender, amount);
1028         distributeDevFund();
1029         emit Withdraw(msg.sender, amount);
1030     }
1031 
1032     function claim(uint amount) public shouldStarted {
1033         updateRewards(msg.sender);
1034         checkDecreasing();
1035         require(amount <= rewards[msg.sender] && rewards[msg.sender] > 0, "Bad claim.");
1036         rewards[msg.sender] = rewards[msg.sender].sub(amount);
1037         azuki.safeTransfer(msg.sender, amount);
1038         distributeDevFund();
1039         emit Claim(msg.sender, amount);
1040     }
1041 
1042     function checkDecreasing() internal {
1043         if (block.timestamp >= halvingTime) {
1044             initReward = initReward.mul(94).div(100);
1045             azuki.mint(address(this), initReward);
1046 
1047             rewardRate = initReward.div(DURATION);
1048             halvingTime = halvingTime.add(DURATION);
1049 
1050             updateRewards(msg.sender);
1051             emit Decreasing(initReward);
1052         }
1053     }
1054 
1055     modifier shouldStarted() {
1056         require(haveStarted == true, "Have not started.");
1057         _;
1058     }
1059 
1060     function getRewardsAmount(address account) public view returns(uint256) {
1061         return balanceOf(account).mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
1062                 .div(1e18)
1063                 .add(rewards[account]);
1064     }
1065 
1066     function rewardPerToken() public view returns (uint256) {
1067         if (_lpTotalSupply == 0) {
1068             return rewardPerLPToken;
1069         }
1070         return rewardPerLPToken
1071             .add(Math.min(block.timestamp, halvingTime)
1072                     .sub(lastUpdateTime)
1073                     .mul(rewardRate)
1074                     .mul(1e18)
1075                     .div(_lpTotalSupply)
1076             );
1077     }
1078 
1079     function updateRewards(address account) internal {
1080         rewardPerLPToken = rewardPerToken();
1081         lastUpdateTime = lastRewardTime();
1082         if (account != address(0)) {
1083             rewards[account] = getRewardsAmount(account);
1084             userRewardPerTokenPaid[account] = rewardPerLPToken;
1085         }
1086     }
1087 
1088     function lastRewardTime() public view returns (uint256) {
1089         return Math.min(block.timestamp, halvingTime);
1090     }
1091 
1092     function startFarming() external onlyOwner {
1093         updateRewards(address(0));
1094         rewardRate = initReward.div(DURATION);
1095 
1096         uint256 mintAmount = initReward.add(devFundAmount);
1097         azuki.mint(address(this), mintAmount);
1098         devDistributeRate = devFundAmount.div(devDistributeDuration);
1099         devFinishTime = block.timestamp.add(devDistributeDuration);
1100 
1101         lastUpdateTime = block.timestamp;
1102         lastDistributeTime = block.timestamp;
1103         halvingTime = block.timestamp.add(DURATION);
1104 
1105         haveStarted = true;
1106         emit Start(mintAmount);
1107     }
1108 
1109     function transferDevAddr(address newAddr) public onlyDev {
1110         require(newAddr != address(0), "zero addr");
1111         devAddr = newAddr;
1112     }
1113 
1114     function distributeDevFund() internal {
1115         uint256 nowTime = Math.min(block.timestamp, devFinishTime);
1116         uint256 fundAmount = nowTime.sub(lastDistributeTime).mul(devDistributeRate);
1117         azuki.safeTransfer(devAddr, fundAmount);
1118         lastDistributeTime = nowTime;
1119     }
1120 
1121     modifier onlyDev() {
1122         require(msg.sender == devAddr, "This is only for dev.");
1123         _;
1124     }
1125 
1126     function lpTokenAddress() view public returns(address) {
1127         return address(lpToken);
1128     }
1129 
1130     function azukiAddress() view public returns(address) {
1131         return address(azuki);
1132     }
1133 
1134     function testMint() public onlyOwner {
1135         azuki.mint(address(this), 1);
1136     }
1137 }