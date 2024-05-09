1 pragma solidity ^0.6.0;
2 
3 interface IERC20 {
4     /**
5      * @dev Returns the amount of tokens in existence.
6      */
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the amount of tokens owned by `account`.
11      */
12     function balanceOf(address account) external view returns (uint256);
13 
14     /**
15      * @dev Moves `amount` tokens from the caller's account to `recipient`.
16      *
17      * Returns a boolean value indicating whether the operation succeeded.
18      *
19      * Emits a {Transfer} event.
20      */
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     /**
24      * @dev Returns the remaining number of tokens that `spender` will be
25      * allowed to spend on behalf of `owner` through {transferFrom}. This is
26      * zero by default.
27      *
28      * This value changes when {approve} or {transferFrom} are called.
29      */
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     /**
33      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * IMPORTANT: Beware that changing an allowance with this method brings the risk
38      * that someone may use both the old and the new allowance by unfortunate
39      * transaction ordering. One possible solution to mitigate this race
40      * condition is to first reduce the spender's allowance to 0 and set the
41      * desired value afterwards:
42      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
43      *
44      * Emits an {Approval} event.
45      */
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Moves `amount` tokens from `sender` to `recipient` using the
50      * allowance mechanism. `amount` is then deducted from the caller's
51      * allowance.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Emitted when `value` tokens are moved from one account (`from`) to
61      * another (`to`).
62      *
63      * Note that `value` may be zero.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     /**
68      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
69      * a call to {approve}. `value` is the new allowance.
70      */
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract Context {
75     // Empty internal constructor, to prevent people from mistakenly deploying
76     // an instance of this contract, which should be used via inheritance.
77     constructor () internal { }
78 
79     function _msgSender() internal view virtual returns (address payable) {
80         return msg.sender;
81     }
82 
83     function _msgData() internal view virtual returns (bytes memory) {
84         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
85         return msg.data;
86     }
87 }
88 
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      */
107     function isContract(address account) internal view returns (bool) {
108         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
109         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
110         // for accounts without code, i.e. `keccak256('')`
111         bytes32 codehash;
112         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
113         // solhint-disable-next-line no-inline-assembly
114         assembly { codehash := extcodehash(account) }
115         return (codehash != accountHash && codehash != 0x0);
116     }
117 
118     /**
119      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
120      * `recipient`, forwarding all available gas and reverting on errors.
121      *
122      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
123      * of certain opcodes, possibly making contracts go over the 2300 gas limit
124      * imposed by `transfer`, making them unable to receive funds via
125      * `transfer`. {sendValue} removes this limitation.
126      *
127      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
128      *
129      * IMPORTANT: because control is transferred to `recipient`, care must be
130      * taken to not create reentrancy vulnerabilities. Consider using
131      * {ReentrancyGuard} or the
132      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
133      */
134     function sendValue(address payable recipient, uint256 amount) internal {
135         require(address(this).balance >= amount, "Address: insufficient balance");
136 
137         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
138         (bool success, ) = recipient.call{ value: amount }("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 }
142 
143 contract ERC20 is Context, IERC20 {
144     using SafeMath for uint256;
145     using Address for address;
146 
147     mapping (address => uint256) private _balances;
148 
149     mapping (address => mapping (address => uint256)) private _allowances;
150 
151     uint256 private _totalSupply;
152 
153     string private _name;
154     string private _symbol;
155     uint8 private _decimals;
156 
157     /**
158      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
159      * a default value of 18.
160      *
161      * To select a different value for {decimals}, use {_setupDecimals}.
162      *
163      * All three of these values are immutable: they can only be set once during
164      * construction.
165      */
166     constructor (string memory name, string memory symbol) public {
167         _name = name;
168         _symbol = symbol;
169         _decimals = 18;
170     }
171 
172     /**
173      * @dev Returns the name of the token.
174      */
175     function name() public view returns (string memory) {
176         return _name;
177     }
178 
179     /**
180      * @dev Returns the symbol of the token, usually a shorter version of the
181      * name.
182      */
183     function symbol() public view returns (string memory) {
184         return _symbol;
185     }
186 
187     /**
188      * @dev Returns the number of decimals used to get its user representation.
189      * For example, if `decimals` equals `2`, a balance of `505` tokens should
190      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
191      *
192      * Tokens usually opt for a value of 18, imitating the relationship between
193      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
194      * called.
195      *
196      * NOTE: This information is only used for _display_ purposes: it in
197      * no way affects any of the arithmetic of the contract, including
198      * {IERC20-balanceOf} and {IERC20-transfer}.
199      */
200     function decimals() public view returns (uint8) {
201         return _decimals;
202     }
203 
204     /**
205      * @dev See {IERC20-totalSupply}.
206      */
207     function totalSupply() public view override returns (uint256) {
208         return _totalSupply;
209     }
210 
211     /**
212      * @dev See {IERC20-balanceOf}.
213      */
214     function balanceOf(address account) public view override returns (uint256) {
215         return _balances[account];
216     }
217 
218     /**
219      * @dev See {IERC20-transfer}.
220      *
221      * Requirements:
222      *
223      * - `recipient` cannot be the zero address.
224      * - the caller must have a balance of at least `amount`.
225      */
226     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
227         _transfer(_msgSender(), recipient, amount);
228         return true;
229     }
230 
231     /**
232      * @dev See {IERC20-allowance}.
233      */
234     function allowance(address owner, address spender) public view virtual override returns (uint256) {
235         return _allowances[owner][spender];
236     }
237 
238     /**
239      * @dev See {IERC20-approve}.
240      *
241      * Requirements:
242      *
243      * - `spender` cannot be the zero address.
244      */
245     function approve(address spender, uint256 amount) public virtual override returns (bool) {
246         _approve(_msgSender(), spender, amount);
247         return true;
248     }
249 
250     /**
251      * @dev See {IERC20-transferFrom}.
252      *
253      * Emits an {Approval} event indicating the updated allowance. This is not
254      * required by the EIP. See the note at the beginning of {ERC20};
255      *
256      * Requirements:
257      * - `sender` and `recipient` cannot be the zero address.
258      * - `sender` must have a balance of at least `amount`.
259      * - the caller must have allowance for ``sender``'s tokens of at least
260      * `amount`.
261      */
262     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
263         _transfer(sender, recipient, amount);
264         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
265         return true;
266     }
267 
268     /**
269      * @dev Atomically increases the allowance granted to `spender` by the caller.
270      *
271      * This is an alternative to {approve} that can be used as a mitigation for
272      * problems described in {IERC20-approve}.
273      *
274      * Emits an {Approval} event indicating the updated allowance.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      */
280     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
281         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
282         return true;
283     }
284 
285     /**
286      * @dev Atomically decreases the allowance granted to `spender` by the caller.
287      *
288      * This is an alternative to {approve} that can be used as a mitigation for
289      * problems described in {IERC20-approve}.
290      *
291      * Emits an {Approval} event indicating the updated allowance.
292      *
293      * Requirements:
294      *
295      * - `spender` cannot be the zero address.
296      * - `spender` must have allowance for the caller of at least
297      * `subtractedValue`.
298      */
299     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
300         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
301         return true;
302     }
303 
304     /**
305      * @dev Moves tokens `amount` from `sender` to `recipient`.
306      *
307      * This is internal function is equivalent to {transfer}, and can be used to
308      * e.g. implement automatic token fees, slashing mechanisms, etc.
309      *
310      * Emits a {Transfer} event.
311      *
312      * Requirements:
313      *
314      * - `sender` cannot be the zero address.
315      * - `recipient` cannot be the zero address.
316      * - `sender` must have a balance of at least `amount`.
317      */
318     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
319         require(sender != address(0), "ERC20: transfer from the zero address");
320         require(recipient != address(0), "ERC20: transfer to the zero address");
321 
322         _beforeTokenTransfer(sender, recipient, amount);
323 
324         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
325         _balances[recipient] = _balances[recipient].add(amount);
326         emit Transfer(sender, recipient, amount);
327     }
328 
329     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
330      * the total supply.
331      *
332      * Emits a {Transfer} event with `from` set to the zero address.
333      *
334      * Requirements
335      *
336      * - `to` cannot be the zero address.
337      */
338     function _mint(address account, uint256 amount) internal virtual {
339         require(account != address(0), "ERC20: mint to the zero address");
340 
341         _beforeTokenTransfer(address(0), account, amount);
342 
343         _totalSupply = _totalSupply.add(amount);
344         _balances[account] = _balances[account].add(amount);
345         emit Transfer(address(0), account, amount);
346     }
347 
348     /**
349      * @dev Destroys `amount` tokens from `account`, reducing the
350      * total supply.
351      *
352      * Emits a {Transfer} event with `to` set to the zero address.
353      *
354      * Requirements
355      *
356      * - `account` cannot be the zero address.
357      * - `account` must have at least `amount` tokens.
358      */
359     function _burn(address account, uint256 amount) internal virtual {
360         require(account != address(0), "ERC20: burn from the zero address");
361 
362         _beforeTokenTransfer(account, address(0), amount);
363 
364         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
365         _totalSupply = _totalSupply.sub(amount);
366         emit Transfer(account, address(0), amount);
367     }
368 
369     /**
370      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
371      *
372      * This is internal function is equivalent to `approve`, and can be used to
373      * e.g. set automatic allowances for certain subsystems, etc.
374      *
375      * Emits an {Approval} event.
376      *
377      * Requirements:
378      *
379      * - `owner` cannot be the zero address.
380      * - `spender` cannot be the zero address.
381      */
382     function _approve(address owner, address spender, uint256 amount) internal virtual {
383         require(owner != address(0), "ERC20: approve from the zero address");
384         require(spender != address(0), "ERC20: approve to the zero address");
385 
386         _allowances[owner][spender] = amount;
387         emit Approval(owner, spender, amount);
388     }
389 
390     /**
391      * @dev Sets {decimals} to a value other than the default one of 18.
392      *
393      * WARNING: This function should only be called from the constructor. Most
394      * applications that interact with token contracts will not expect
395      * {decimals} to ever change, and may work incorrectly if it does.
396      */
397     function _setupDecimals(uint8 decimals_) internal {
398         _decimals = decimals_;
399     }
400 
401     /**
402      * @dev Hook that is called before any transfer of tokens. This includes
403      * minting and burning.
404      *
405      * Calling conditions:
406      *
407      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
408      * will be to transferred to `to`.
409      * - when `from` is zero, `amount` tokens will be minted for `to`.
410      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
411      * - `from` and `to` are never both zero.
412      *
413      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
414      */
415     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
416 }
417 library SafeERC20 {
418     using SafeMath for uint256;
419     using Address for address;
420 
421     function safeTransfer(IERC20 token, address to, uint256 value) internal {
422         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
423     }
424 
425     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
426         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
427     }
428 
429     function safeApprove(IERC20 token, address spender, uint256 value) internal {
430         // safeApprove should only be called when setting an initial allowance,
431         // or when resetting it to zero. To increase and decrease it, use
432         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
433         // solhint-disable-next-line max-line-length
434         require((value == 0) || (token.allowance(address(this), spender) == 0),
435             "SafeERC20: approve from non-zero to non-zero allowance"
436         );
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
438     }
439 
440     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).add(value);
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
446         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
447         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
448     }
449 
450     /**
451      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
452      * on the return value: the return value is optional (but if data is returned, it must not be false).
453      * @param token The token targeted by the call.
454      * @param data The call data (encoded using abi.encode or one of its variants).
455      */
456     function _callOptionalReturn(IERC20 token, bytes memory data) private {
457         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
458         // we're implementing it ourselves.
459 
460         // A Solidity high level call has three parts:
461         //  1. The target address is checked to verify it contains contract code
462         //  2. The call itself is made, and success asserted
463         //  3. The return value is decoded, which in turn checks the size of the returned data.
464         // solhint-disable-next-line max-line-length
465         require(address(token).isContract(), "SafeERC20: call to non-contract");
466 
467         // solhint-disable-next-line avoid-low-level-calls
468         (bool success, bytes memory returndata) = address(token).call(data);
469         require(success, "SafeERC20: low-level call failed");
470 
471         if (returndata.length > 0) { // Return data is optional
472             // solhint-disable-next-line max-line-length
473             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
474         }
475     }
476 }
477 
478 library SafeMath {
479     /**
480      * @dev Returns the addition of two unsigned integers, reverting on
481      * overflow.
482      *
483      * Counterpart to Solidity's `+` operator.
484      *
485      * Requirements:
486      * - Addition cannot overflow.
487      */
488     function add(uint256 a, uint256 b) internal pure returns (uint256) {
489         uint256 c = a + b;
490         require(c >= a, "SafeMath: addition overflow");
491 
492         return c;
493     }
494 
495     /**
496      * @dev Returns the subtraction of two unsigned integers, reverting on
497      * overflow (when the result is negative).
498      *
499      * Counterpart to Solidity's `-` operator.
500      *
501      * Requirements:
502      * - Subtraction cannot overflow.
503      */
504     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
505         return sub(a, b, "SafeMath: subtraction overflow");
506     }
507 
508     /**
509      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
510      * overflow (when the result is negative).
511      *
512      * Counterpart to Solidity's `-` operator.
513      *
514      * Requirements:
515      * - Subtraction cannot overflow.
516      */
517     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
518         require(b <= a, errorMessage);
519         uint256 c = a - b;
520 
521         return c;
522     }
523 
524     /**
525      * @dev Returns the multiplication of two unsigned integers, reverting on
526      * overflow.
527      *
528      * Counterpart to Solidity's `*` operator.
529      *
530      * Requirements:
531      * - Multiplication cannot overflow.
532      */
533     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
534         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
535         // benefit is lost if 'b' is also tested.
536         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
537         if (a == 0) {
538             return 0;
539         }
540 
541         uint256 c = a * b;
542         require(c / a == b, "SafeMath: multiplication overflow");
543 
544         return c;
545     }
546 
547     /**
548      * @dev Returns the integer division of two unsigned integers. Reverts on
549      * division by zero. The result is rounded towards zero.
550      *
551      * Counterpart to Solidity's `/` operator. Note: this function uses a
552      * `revert` opcode (which leaves remaining gas untouched) while Solidity
553      * uses an invalid opcode to revert (consuming all remaining gas).
554      *
555      * Requirements:
556      * - The divisor cannot be zero.
557      */
558     function div(uint256 a, uint256 b) internal pure returns (uint256) {
559         return div(a, b, "SafeMath: division by zero");
560     }
561 
562     /**
563      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
564      * division by zero. The result is rounded towards zero.
565      *
566      * Counterpart to Solidity's `/` operator. Note: this function uses a
567      * `revert` opcode (which leaves remaining gas untouched) while Solidity
568      * uses an invalid opcode to revert (consuming all remaining gas).
569      *
570      * Requirements:
571      * - The divisor cannot be zero.
572      */
573     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
574         // Solidity only automatically asserts when dividing by 0
575         require(b > 0, errorMessage);
576         uint256 c = a / b;
577         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
578 
579         return c;
580     }
581 
582     /**
583      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
584      * Reverts when dividing by zero.
585      *
586      * Counterpart to Solidity's `%` operator. This function uses a `revert`
587      * opcode (which leaves remaining gas untouched) while Solidity uses an
588      * invalid opcode to revert (consuming all remaining gas).
589      *
590      * Requirements:
591      * - The divisor cannot be zero.
592      */
593     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
594         return mod(a, b, "SafeMath: modulo by zero");
595     }
596 
597     /**
598      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
599      * Reverts with custom message when dividing by zero.
600      *
601      * Counterpart to Solidity's `%` operator. This function uses a `revert`
602      * opcode (which leaves remaining gas untouched) while Solidity uses an
603      * invalid opcode to revert (consuming all remaining gas).
604      *
605      * Requirements:
606      * - The divisor cannot be zero.
607      */
608     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
609         require(b != 0, errorMessage);
610         return a % b;
611     }
612 }
613 
614 contract dCOCKv2 is ERC20 {
615     
616     struct stakeTracker {
617         uint256 lastBlockChecked;
618         uint256 rewards;
619         uint256 crumbsStaked;
620         
621         uint256 lastBlockCheckedLP;
622         uint256 rewardsLP;
623         uint256 crumbsStakedLP;
624     }
625 
626     address private owner;
627     
628     uint256 private rewardsVar;
629     uint256 private rewardsVarLP;
630     
631     using SafeERC20 for IERC20;
632     using SafeMath for uint256;
633  
634     address private crumbsAddress;
635     IERC20 private crumbsToken;
636     
637     //LP
638     address private crumbsAddressLP;
639     IERC20 private crumbsTokenLP;
640 
641     uint256 private _totalCrumbsStaked;
642     mapping(address => stakeTracker) private _stakedBalances;
643     
644     //LP
645     uint256 private _totalCrumbsStakedLP;
646     mapping(address => stakeTracker) private _stakedBalancesLP;
647     
648     constructor() public ERC20("dCOCK", "dCOCK") {
649         owner = msg.sender;
650         _mint(msg.sender, 1 * (10 ** 18));
651         rewardsVar = 100000000;
652         rewardsVarLP = 100000000; //changed to 100000000
653     }
654     
655     event Staked(address indexed user, uint256 amount, uint256 totalCrumbsStaked);
656     event Withdrawn(address indexed user, uint256 amount);
657     event Rewards(address indexed user, uint256 reward);
658     
659     event StakedLP(address indexed user, uint256 amount, uint256 totalCrumbsStakedLP);
660     event WithdrawnLP(address indexed user, uint256 amountLP);
661     event RewardsLP(address indexed user, uint256 rewardLP);
662     
663     modifier _onlyOwner() {
664         require(msg.sender == owner);
665         _;
666     }
667 
668     modifier updateStakingReward(address account) {
669         if (block.number > _stakedBalances[account].lastBlockChecked) {
670             uint256 rewardBlocks = block.number
671                                         .sub(_stakedBalances[account].lastBlockChecked);
672                                         
673                                         
674              
675             if (_stakedBalances[account].crumbsStaked > 0) {
676                 _stakedBalances[account].rewards = _stakedBalances[account].rewards
677                                                                             .add(
678                                                                             _stakedBalances[account].crumbsStaked
679                                                                             .mul(rewardBlocks)
680                                                                             / rewardsVar);
681             }
682                     
683             _stakedBalances[account].lastBlockChecked = block.number;
684             
685             emit Rewards(account, _stakedBalances[account].rewards);                                                     
686         }
687         _;
688     }
689     
690     modifier updateStakingRewardLP(address account) {
691         if (block.number > _stakedBalancesLP[account].lastBlockCheckedLP) {
692             uint256 rewardBlocksLP = block.number
693                                         .sub(_stakedBalancesLP[account].lastBlockCheckedLP);
694                                         
695                                         
696              
697             if (_stakedBalancesLP[account].crumbsStakedLP > 0) {
698                 _stakedBalancesLP[account].rewardsLP = _stakedBalancesLP[account].rewardsLP
699                                                                             .add(
700                                                                             _stakedBalancesLP[account].crumbsStakedLP
701                                                                             .mul(rewardBlocksLP)
702                                                                             / rewardsVarLP);
703             }
704                     
705             _stakedBalancesLP[account].lastBlockCheckedLP = block.number;
706             
707             emit RewardsLP(account, _stakedBalancesLP[account].rewardsLP);                                                     
708         }
709         _;
710     }
711 
712 
713     function setCrumbsAddress(address _crumbsAddress) public _onlyOwner returns(uint256) {
714         crumbsAddress = _crumbsAddress;
715         crumbsToken = IERC20(_crumbsAddress);
716     }
717     
718     function setCrumbsAddressLP(address _crumbsAddressLP) public _onlyOwner returns(uint256) {
719         crumbsAddressLP = _crumbsAddressLP;
720         crumbsTokenLP = IERC20(_crumbsAddressLP);
721     }
722     
723     function updatingStakingReward(address account) public returns(uint256) {
724         if (block.number > _stakedBalances[account].lastBlockChecked) {
725             uint256 rewardBlocks = block.number
726                                         .sub(_stakedBalances[account].lastBlockChecked);
727                                         
728                                         
729             if (_stakedBalances[account].crumbsStaked > 0) {
730                 _stakedBalances[account].rewards = _stakedBalances[account].rewards
731                                                                             .add(
732                                                                             _stakedBalances[account].crumbsStaked
733                                                                             .mul(rewardBlocks)
734                                                                             / rewardsVar);
735             }
736                                                 
737             _stakedBalances[account].lastBlockChecked = block.number;
738                                                 
739             emit Rewards(account, _stakedBalances[account].rewards);                                                     
740         
741         }
742         return(_stakedBalances[account].rewards);
743     }
744     
745     function updatingStakingRewardLP(address account) public returns(uint256) {
746         if (block.number > _stakedBalancesLP[account].lastBlockCheckedLP) {
747             uint256 rewardBlocksLP = block.number
748                                         .sub(_stakedBalancesLP[account].lastBlockCheckedLP);
749                                         
750                                         
751             if (_stakedBalancesLP[account].crumbsStakedLP > 0) {
752                 _stakedBalancesLP[account].rewardsLP = _stakedBalancesLP[account].rewardsLP
753                                                                             .add(
754                                                                             _stakedBalancesLP[account].crumbsStakedLP
755                                                                             .mul(rewardBlocksLP)
756                                                                             / rewardsVarLP);
757             }
758                                                 
759             _stakedBalancesLP[account].lastBlockCheckedLP = block.number;
760                                                 
761             emit RewardsLP(account, _stakedBalancesLP[account].rewardsLP);                                                     
762         
763         }
764         return(_stakedBalancesLP[account].rewardsLP);
765     }
766     
767     function getBlockNum() public view returns (uint256) {
768         return block.number;
769     }
770     
771     function getLastBlockCheckedNum(address _account) public view returns (uint256) {
772         return _stakedBalances[_account].lastBlockChecked;
773     }
774     
775     function getLastBlockCheckedNumLP(address _account) public view returns (uint256) {
776         return _stakedBalancesLP[_account].lastBlockCheckedLP;
777     }
778 
779     function getAddressStakeAmount(address _account) public view returns (uint256) {
780         return _stakedBalances[_account].crumbsStaked;
781     }
782     
783     function getAddressStakeAmountLP(address _account) public view returns (uint256) {
784         return _stakedBalancesLP[_account].crumbsStakedLP;
785     }
786     
787     function setRewardsVar(uint256 _amount) public _onlyOwner {
788         rewardsVar = _amount;
789     }
790     
791     function setRewardsVarLP(uint256 _amount) public _onlyOwner {
792         rewardsVarLP = _amount;
793     }
794     
795     function totalStakedSupply() public view returns (uint256) {
796         return _totalCrumbsStaked;
797     }
798     
799     function totalStakedSupplyLP() public view returns (uint256) {
800         return _totalCrumbsStakedLP;
801     }
802 
803     function myRewardsBalance(address account) public view returns (uint256) {
804         if (block.number > _stakedBalances[account].lastBlockChecked) {
805             uint256 rewardBlocks = block.number
806                                         .sub(_stakedBalances[account].lastBlockChecked);
807                                         
808                                         
809              
810             if (_stakedBalances[account].crumbsStaked > 0) {
811                 return _stakedBalances[account].rewards
812                                                 .add(
813                                                 _stakedBalances[account].crumbsStaked
814                                                 .mul(rewardBlocks)
815                                                 / rewardsVar);
816             }                                                  
817         }
818 
819     }
820     
821     function myRewardsBalanceLP(address account) public view returns (uint256) {
822         if (block.number > _stakedBalancesLP[account].lastBlockCheckedLP) {
823             uint256 rewardBlocksLP = block.number
824                                         .sub(_stakedBalancesLP[account].lastBlockCheckedLP);
825                                         
826                                         
827              
828             if (_stakedBalancesLP[account].crumbsStakedLP > 0) {
829                 return _stakedBalancesLP[account].rewardsLP
830                                                 .add(
831                                                 _stakedBalancesLP[account].crumbsStakedLP
832                                                 .mul(rewardBlocksLP)
833                                                 / rewardsVarLP);
834             }                                                  
835         }
836 
837     }
838 
839     function stake(uint256 amount) public updateStakingReward(msg.sender) {
840         _totalCrumbsStaked = _totalCrumbsStaked.add(amount);
841         _stakedBalances[msg.sender].crumbsStaked = _stakedBalances[msg.sender].crumbsStaked.add(amount);
842         crumbsToken.safeTransferFrom(msg.sender, address(this), amount);
843         emit Staked(msg.sender, amount, _totalCrumbsStaked);
844     }
845     
846     function stakeLP(uint256 amount) public updateStakingRewardLP(msg.sender) {
847         _totalCrumbsStakedLP = _totalCrumbsStakedLP.add(amount);
848         _stakedBalancesLP[msg.sender].crumbsStakedLP = _stakedBalancesLP[msg.sender].crumbsStakedLP.add(amount);
849         crumbsTokenLP.safeTransferFrom(msg.sender, address(this), amount);
850         emit StakedLP(msg.sender, amount, _totalCrumbsStakedLP);
851     }
852 
853     function withdraw(uint256 amount) public updateStakingReward(msg.sender) {
854         _totalCrumbsStaked = _totalCrumbsStaked.sub(amount);
855         _stakedBalances[msg.sender].crumbsStaked = _stakedBalances[msg.sender].crumbsStaked.sub(amount);
856         crumbsToken.safeTransfer(msg.sender, amount);
857         emit Withdrawn(msg.sender, amount);
858     }
859     
860     function withdrawLP(uint256 amount) public updateStakingRewardLP(msg.sender) {
861         _totalCrumbsStakedLP = _totalCrumbsStakedLP.sub(amount);
862         _stakedBalancesLP[msg.sender].crumbsStakedLP = _stakedBalancesLP[msg.sender].crumbsStakedLP.sub(amount);
863         crumbsTokenLP.safeTransfer(msg.sender, amount);
864         emit WithdrawnLP(msg.sender, amount);
865     }
866     
867    function getReward() public updateStakingReward(msg.sender) {
868        uint256 reward = _stakedBalances[msg.sender].rewards;
869        _stakedBalances[msg.sender].rewards = 0;
870        _mint(msg.sender, reward.mul(8) / 10);
871        uint256 fundingPoolReward = reward.mul(2) / 10;
872        _mint(crumbsAddress, fundingPoolReward);
873        emit Rewards(msg.sender, reward);
874    }
875    
876     function getRewardLP() public updateStakingRewardLP(msg.sender) {
877        uint256 rewardLP = _stakedBalancesLP[msg.sender].rewardsLP;
878        _stakedBalancesLP[msg.sender].rewardsLP = 0;
879        _mint(msg.sender, rewardLP.mul(8) / 10);
880        uint256 fundingPoolRewardLP = rewardLP.mul(2) / 10;
881        _mint(crumbsAddressLP, fundingPoolRewardLP);
882        emit RewardsLP(msg.sender, rewardLP);
883    }
884 
885     
886 }