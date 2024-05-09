1 pragma solidity ^0.5.0;
2 
3 library Address {
4     /**
5      * @dev Returns true if `account` is a contract.
6      *
7      * This test is non-exhaustive, and there may be false-negatives: during the
8      * execution of a contract's constructor, its address will be reported as
9      * not containing a contract.
10      *
11      * IMPORTANT: It is unsafe to assume that an address for which this
12      * function returns false is an externally-owned account (EOA) and not a
13      * contract.
14      */
15     function isContract(address account) internal view returns (bool) {
16         // This method relies in extcodesize, which returns 0 for contracts in
17         // construction, since the code is only stored at the end of the
18         // constructor execution.
19         
20         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
21         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
22         // for accounts without code, i.e. `keccak256('')`
23         bytes32 codehash;
24         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
25         // solhint-disable-next-line no-inline-assembly
26         assembly { codehash := extcodehash(account) }
27         return (codehash != 0x0 && codehash != accountHash);
28     }
29 
30     /**
31      * @dev Converts an `address` into `address payable`. Note that this is
32      * simply a type cast: the actual underlying value is not changed.
33      *
34      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
35      * @dev Get it via `npm install @openzeppelin/contracts@next`.
36      */
37     function toPayable(address account) internal pure returns (address payable) {
38         return address(uint160(account));
39     }
40 }
41 
42 library SafeMath {
43     /**
44      * @dev Returns the addition of two unsigned integers, reverting on
45      * overflow.
46      *
47      * Counterpart to Solidity's `+` operator.
48      *
49      * Requirements:
50      * - Addition cannot overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the subtraction of two unsigned integers, reverting on
61      * overflow (when the result is negative).
62      *
63      * Counterpart to Solidity's `-` operator.
64      *
65      * Requirements:
66      * - Subtraction cannot overflow.
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         return sub(a, b, "SafeMath: subtraction overflow");
70     }
71 
72     /**
73      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
74      * overflow (when the result is negative).
75      *
76      * Counterpart to Solidity's `-` operator.
77      *
78      * Requirements:
79      * - Subtraction cannot overflow.
80      *
81      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
82      * @dev Get it via `npm install @openzeppelin/contracts@next`.
83      */
84     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b <= a, errorMessage);
86         uint256 c = a - b;
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the multiplication of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `*` operator.
96      *
97      * Requirements:
98      * - Multiplication cannot overflow.
99      */
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
102         // benefit is lost if 'b' is also tested.
103         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
104         if (a == 0) {
105             return 0;
106         }
107 
108         uint256 c = a * b;
109         require(c / a == b, "SafeMath: multiplication overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers. Reverts on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator. Note: this function uses a
119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
120      * uses an invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      * - The divisor cannot be zero.
124      */
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return div(a, b, "SafeMath: division by zero");
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator. Note: this function uses a
134      * `revert` opcode (which leaves remaining gas untouched) while Solidity
135      * uses an invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      * - The divisor cannot be zero.
139 
140      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
141      * @dev Get it via `npm install @openzeppelin/contracts@next`.
142      */
143     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         // Solidity only automatically asserts when dividing by 0
145         require(b > 0, errorMessage);
146         uint256 c = a / b;
147         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
154      * Reverts when dividing by zero.
155      *
156      * Counterpart to Solidity's `%` operator. This function uses a `revert`
157      * opcode (which leaves remaining gas untouched) while Solidity uses an
158      * invalid opcode to revert (consuming all remaining gas).
159      *
160      * Requirements:
161      * - The divisor cannot be zero.
162      */
163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
164         return mod(a, b, "SafeMath: modulo by zero");
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * Reverts with custom message when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      * - The divisor cannot be zero.
177      *
178      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
179      * @dev Get it via `npm install @openzeppelin/contracts@next`.
180      */
181     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b != 0, errorMessage);
183         return a % b;
184     }
185 }
186 
187 
188 contract Context {
189     // Empty internal constructor, to prevent people from mistakenly deploying
190     // an instance of this contract, with should be used via inheritance.
191     constructor () internal { }
192     // solhint-disable-previous-line no-empty-blocks
193 
194     function _msgSender() internal view returns (address) {
195         return msg.sender;
196     }
197 
198     function _msgData() internal view returns (bytes memory) {
199         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
200         return msg.data;
201     }
202 }
203 
204 contract Ownable is Context {
205     address private _owner;
206 
207     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
208 
209     /**
210      * @dev Initializes the contract setting the deployer as the initial owner.
211      */
212     constructor () internal {
213         _owner = _msgSender();
214         emit OwnershipTransferred(address(0), _owner);
215     }
216 
217     /**
218      * @dev Returns the address of the current owner.
219      */
220     function owner() public view returns (address) {
221         return _owner;
222     }
223 
224     /**
225      * @dev Throws if called by any account other than the owner.
226      */
227     modifier onlyOwner() {
228         require(isOwner(), "Ownable: caller is not the owner");
229         _;
230     }
231 
232     /**
233      * @dev Returns true if the caller is the current owner.
234      */
235     function isOwner() public view returns (bool) {
236         return _msgSender() == _owner;
237     }
238 
239     /**
240      * @dev Leaves the contract without owner. It will not be possible to call
241      * `onlyOwner` functions anymore. Can only be called by the current owner.
242      *
243      * NOTE: Renouncing ownership will leave the contract without an owner,
244      * thereby removing any functionality that is only available to the owner.
245      */
246     function renounceOwnership() public onlyOwner {
247         emit OwnershipTransferred(_owner, address(0));
248         _owner = address(0);
249     }
250 
251     /**
252      * @dev Transfers ownership of the contract to a new account (`newOwner`).
253      * Can only be called by the current owner.
254      */
255     function transferOwnership(address newOwner) public onlyOwner {
256         _transferOwnership(newOwner);
257     }
258 
259     /**
260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
261      */
262     function _transferOwnership(address newOwner) internal {
263         require(newOwner != address(0), "Ownable: new owner is the zero address");
264         emit OwnershipTransferred(_owner, newOwner);
265         _owner = newOwner;
266     }
267 }
268 
269 
270 /**
271  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
272  * the optional functions; to access them see {ERC20Detailed}.
273  */
274 interface IERC20 {
275     /**
276      * @dev Returns the amount of tokens in existence.
277      */
278     function totalSupply() external view returns (uint256);
279 
280     /**
281      * @dev Returns the amount of tokens owned by `account`.
282      */
283     function balanceOf(address account) external view returns (uint256);
284 
285     /**
286      * @dev Moves `amount` tokens from the caller's account to `recipient`.
287      *
288      * Returns a boolean value indicating whether the operation succeeded.
289      *
290      * Emits a {Transfer} event.
291      */
292     function transfer(address recipient, uint256 amount) external returns (bool);
293 
294     /**
295      * @dev Returns the remaining number of tokens that `spender` will be
296      * allowed to spend on behalf of `owner` through {transferFrom}. This is
297      * zero by default.
298      *
299      * This value changes when {approve} or {transferFrom} are called.
300      */
301     function allowance(address owner, address spender) external view returns (uint256);
302 
303     /**
304      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
305      *
306      * Returns a boolean value indicating whether the operation succeeded.
307      *
308      * IMPORTANT: Beware that changing an allowance with this method brings the risk
309      * that someone may use both the old and the new allowance by unfortunate
310      * transaction ordering. One possible solution to mitigate this race
311      * condition is to first reduce the spender's allowance to 0 and set the
312      * desired value afterwards:
313      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
314      *
315      * Emits an {Approval} event.
316      */
317     function approve(address spender, uint256 amount) external returns (bool);
318 
319     /**
320      * @dev Moves `amount` tokens from `sender` to `recipient` using the
321      * allowance mechanism. `amount` is then deducted from the caller's
322      * allowance.
323      *
324      * Returns a boolean value indicating whether the operation succeeded.
325      *
326      * Emits a {Transfer} event.
327      */
328     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
329 
330     /**
331      * @dev Emitted when `value` tokens are moved from one account (`from`) to
332      * another (`to`).
333      *
334      * Note that `value` may be zero.
335      */
336     event Transfer(address indexed from, address indexed to, uint256 value);
337 
338     /**
339      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
340      * a call to {approve}. `value` is the new allowance.
341      */
342     event Approval(address indexed owner, address indexed spender, uint256 value);
343 }
344 
345 
346 /**
347  * @dev Optional functions from the ERC20 standard.
348  */
349 contract ERC20Detailed is IERC20 {
350     string private _name;
351     string private _symbol;
352     uint8 private _decimals;
353 
354     /**
355      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
356      * these values are immutable: they can only be set once during
357      * construction.
358      */
359     constructor (string memory name, string memory symbol, uint8 decimals) public {
360         _name = name;
361         _symbol = symbol;
362         _decimals = decimals;
363     }
364 
365     /**
366      * @dev Returns the name of the token.
367      */
368     function name() public view returns (string memory) {
369         return _name;
370     }
371 
372     /**
373      * @dev Returns the symbol of the token, usually a shorter version of the
374      * name.
375      */
376     function symbol() public view returns (string memory) {
377         return _symbol;
378     }
379 
380     /**
381      * @dev Returns the number of decimals used to get its user representation.
382      * For example, if `decimals` equals `2`, a balance of `505` tokens should
383      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
384      *
385      * Tokens usually opt for a value of 18, imitating the relationship between
386      * Ether and Wei.
387      *
388      * NOTE: This information is only used for _display_ purposes: it in
389      * no way affects any of the arithmetic of the contract, including
390      * {IERC20-balanceOf} and {IERC20-transfer}.
391      */
392     function decimals() public view returns (uint8) {
393         return _decimals;
394     }
395 }
396 
397 /**
398  * @title SafeERC20
399  * @dev Wrappers around ERC20 operations that throw on failure (when the token
400  * contract returns false). Tokens that return no value (and instead revert or
401  * throw on failure) are also supported, non-reverting calls are assumed to be
402  * successful.
403  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
404  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
405  */
406 library SafeERC20 {
407     using SafeMath for uint256;
408     using Address for address;
409 
410     function safeTransfer(IERC20 token, address to, uint256 value) internal {
411         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
412     }
413 
414     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
415         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
416     }
417 
418     function safeApprove(IERC20 token, address spender, uint256 value) internal {
419         // safeApprove should only be called when setting an initial allowance,
420         // or when resetting it to zero. To increase and decrease it, use
421         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
422         // solhint-disable-next-line max-line-length
423         require((value == 0) || (token.allowance(address(this), spender) == 0),
424             "SafeERC20: approve from non-zero to non-zero allowance"
425         );
426         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
427     }
428 
429     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
430         uint256 newAllowance = token.allowance(address(this), spender).add(value);
431         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
432     }
433 
434     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
435         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
436         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
437     }
438 
439     /**
440      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
441      * on the return value: the return value is optional (but if data is returned, it must not be false).
442      * @param token The token targeted by the call.
443      * @param data The call data (encoded using abi.encode or one of its variants).
444      */
445     function callOptionalReturn(IERC20 token, bytes memory data) private {
446         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
447         // we're implementing it ourselves.
448 
449         // A Solidity high level call has three parts:
450         //  1. The target address is checked to verify it contains contract code
451         //  2. The call itself is made, and success asserted
452         //  3. The return value is decoded, which in turn checks the size of the returned data.
453         // solhint-disable-next-line max-line-length
454         require(address(token).isContract(), "SafeERC20: call to non-contract");
455 
456         // solhint-disable-next-line avoid-low-level-calls
457         (bool success, bytes memory returndata) = address(token).call(data);
458         require(success, "SafeERC20: low-level call failed");
459 
460         if (returndata.length > 0) { // Return data is optional
461             // solhint-disable-next-line max-line-length
462             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
463         }
464     }
465 }
466 
467 
468 contract ERC20 is Context, IERC20 {
469     using SafeMath for uint256;
470 
471     mapping (address => uint256) private _balances;
472 
473     mapping (address => mapping (address => uint256)) private _allowances;
474 
475     uint256 private _totalSupply;
476 
477     /**
478      * @dev See {IERC20-totalSupply}.
479      */
480     function totalSupply() public view returns (uint256) {
481         return _totalSupply;
482     }
483 
484     /**
485      * @dev See {IERC20-balanceOf}.
486      */
487     function balanceOf(address account) public view returns (uint256) {
488         return _balances[account];
489     }
490 
491     /**
492      * @dev See {IERC20-transfer}.
493      *
494      * Requirements:
495      *
496      * - `recipient` cannot be the zero address.
497      * - the caller must have a balance of at least `amount`.
498      */
499     function transfer(address recipient, uint256 amount) public returns (bool) {
500         _transfer(_msgSender(), recipient, amount);
501         return true;
502     }
503 
504     /**
505      * @dev See {IERC20-allowance}.
506      */
507     function allowance(address owner, address spender) public view returns (uint256) {
508         return _allowances[owner][spender];
509     }
510 
511     /**
512      * @dev See {IERC20-approve}.
513      *
514      * Requirements:
515      *
516      * - `spender` cannot be the zero address.
517      */
518     function approve(address spender, uint256 value) public returns (bool) {
519         _approve(_msgSender(), spender, value);
520         return true;
521     }
522 
523     /**
524      * @dev See {IERC20-transferFrom}.
525      *
526      * Emits an {Approval} event indicating the updated allowance. This is not
527      * required by the EIP. See the note at the beginning of {ERC20};
528      *
529      * Requirements:
530      * - `sender` and `recipient` cannot be the zero address.
531      * - `sender` must have a balance of at least `value`.
532      * - the caller must have allowance for `sender`'s tokens of at least
533      * `amount`.
534      */
535     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
536         _transfer(sender, recipient, amount);
537         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
538         return true;
539     }
540 
541     /**
542      * @dev Atomically increases the allowance granted to `spender` by the caller.
543      *
544      * This is an alternative to {approve} that can be used as a mitigation for
545      * problems described in {IERC20-approve}.
546      *
547      * Emits an {Approval} event indicating the updated allowance.
548      *
549      * Requirements:
550      *
551      * - `spender` cannot be the zero address.
552      */
553     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
554         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
555         return true;
556     }
557 
558     /**
559      * @dev Atomically decreases the allowance granted to `spender` by the caller.
560      *
561      * This is an alternative to {approve} that can be used as a mitigation for
562      * problems described in {IERC20-approve}.
563      *
564      * Emits an {Approval} event indicating the updated allowance.
565      *
566      * Requirements:
567      *
568      * - `spender` cannot be the zero address.
569      * - `spender` must have allowance for the caller of at least
570      * `subtractedValue`.
571      */
572     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
573         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
574         return true;
575     }
576 
577     /**
578      * @dev Moves tokens `amount` from `sender` to `recipient`.
579      *
580      * This is internal function is equivalent to {transfer}, and can be used to
581      * e.g. implement automatic token fees, slashing mechanisms, etc.
582      *
583      * Emits a {Transfer} event.
584      *
585      * Requirements:
586      *
587      * - `sender` cannot be the zero address.
588      * - `recipient` cannot be the zero address.
589      * - `sender` must have a balance of at least `amount`.
590      */
591     function _transfer(address sender, address recipient, uint256 amount) internal {
592         require(sender != address(0), "ERC20: transfer from the zero address");
593         require(recipient != address(0), "ERC20: transfer to the zero address");
594 
595         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
596         _balances[recipient] = _balances[recipient].add(amount);
597         emit Transfer(sender, recipient, amount);
598     }
599 
600     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
601      * the total supply.
602      *
603      * Emits a {Transfer} event with `from` set to the zero address.
604      *
605      * Requirements
606      *
607      * - `to` cannot be the zero address.
608      */
609     function _mint(address account, uint256 amount) internal {
610         require(account != address(0), "ERC20: mint to the zero address");
611 
612         _totalSupply = _totalSupply.add(amount);
613         _balances[account] = _balances[account].add(amount);
614         emit Transfer(address(0), account, amount);
615     }
616 
617      /**
618      * @dev Destroys `amount` tokens from `account`, reducing the
619      * total supply.
620      *
621      * Emits a {Transfer} event with `to` set to the zero address.
622      *
623      * Requirements
624      *
625      * - `account` cannot be the zero address.
626      * - `account` must have at least `amount` tokens.
627      */
628     function _burn(address account, uint256 value) internal {
629         require(account != address(0), "ERC20: burn from the zero address");
630 
631         _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
632         _totalSupply = _totalSupply.sub(value);
633         emit Transfer(account, address(0), value);
634     }
635 
636     /**
637      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
638      *
639      * This is internal function is equivalent to `approve`, and can be used to
640      * e.g. set automatic allowances for certain subsystems, etc.
641      *
642      * Emits an {Approval} event.
643      *
644      * Requirements:
645      *
646      * - `owner` cannot be the zero address.
647      * - `spender` cannot be the zero address.
648      */
649     function _approve(address owner, address spender, uint256 value) internal {
650         require(owner != address(0), "ERC20: approve from the zero address");
651         require(spender != address(0), "ERC20: approve to the zero address");
652 
653         _allowances[owner][spender] = value;
654         emit Approval(owner, spender, value);
655     }
656 
657     /**
658      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
659      * from the caller's allowance.
660      *
661      * See {_burn} and {_approve}.
662      */
663     function _burnFrom(address account, uint256 amount) internal {
664         _burn(account, amount);
665         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
666     }
667 }
668 
669 // main 1000000000000000000
670 contract AIXToken is Context, ERC20Detailed, ERC20, Ownable {
671 
672     // metadata
673     string public constant tokenName = "AIX Token";
674     string public constant tokenSymbol = "AIX";
675     uint8 public constant decimalUnits = 18;
676     uint256 public constant initialSupply = 5000000000;
677 
678     constructor () 
679         public 
680         ERC20Detailed(tokenName, tokenSymbol, decimalUnits)
681         Ownable()
682         ERC20() {
683         _mint(_msgSender(), initialSupply * (10 ** uint256(decimals())));
684     }
685     
686     function mint(uint256 amount) public onlyOwner {
687         _mint(_msgSender(), amount * (10 ** uint256(decimals())));
688     }
689     
690     function burn(address account, uint256 value) public onlyOwner {
691         _burn(account, value);
692     }
693     
694     function burnFrom(address account, uint256 value) public onlyOwner {
695         _burnFrom(account, value);
696     }
697     
698     // can accept ether
699 	function() external payable {
700     }
701 }