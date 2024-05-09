1 /**
2  * Tenup Nation 
3     TOTAL 1% tax:
4     0.4% Auto add to Liquidity Pool .
5     0.4% Auto added to Staking contract.
6     0.2% Auto Send to team wallet address.
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.6.0;
12 
13 
14 // 
15 /*
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with GSN meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address payable) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 // 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 // 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      *
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b <= a, errorMessage);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the multiplication of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `*` operator.
179      *
180      * Requirements:
181      *
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         return div(a, b, "SafeMath: division by zero");
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b > 0, errorMessage);
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b != 0, errorMessage);
264         return a % b;
265     }
266 }
267 
268 // 
269 /**
270  * @dev Collection of functions related to the address type
271  */
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [IMPORTANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // This method relies in extcodesize, which returns 0 for contracts in
292         // construction, since the code is only stored at the end of the
293         // constructor execution.
294 
295         uint256 size;
296         // solhint-disable-next-line no-inline-assembly
297         assembly { size := extcodesize(account) }
298         return size > 0;
299     }
300 
301     /**
302      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
303      * `recipient`, forwarding all available gas and reverting on errors.
304      *
305      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
306      * of certain opcodes, possibly making contracts go over the 2300 gas limit
307      * imposed by `transfer`, making them unable to receive funds via
308      * `transfer`. {sendValue} removes this limitation.
309      *
310      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
311      *
312      * IMPORTANT: because control is transferred to `recipient`, care must be
313      * taken to not create reentrancy vulnerabilities. Consider using
314      * {ReentrancyGuard} or the
315      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
316      */
317     function sendValue(address payable recipient, uint256 amount) internal {
318         require(address(this).balance >= amount, "Address: insufficient balance");
319 
320         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
321         (bool success, ) = recipient.call{ value: amount }("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain`call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344       return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
354         return _functionCallWithValue(target, data, 0, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but also transferring `value` wei to `target`.
360      *
361      * Requirements:
362      *
363      * - the calling contract must have an ETH balance of at least `value`.
364      * - the called Solidity function must be `payable`.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
379         require(address(this).balance >= value, "Address: insufficient balance for call");
380         return _functionCallWithValue(target, data, value, errorMessage);
381     }
382 
383     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
384         require(isContract(target), "Address: call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 // solhint-disable-next-line no-inline-assembly
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 // 
408 /**
409  * @dev Implementation of the {IERC20} interface.
410  *
411  * This implementation is agnostic to the way tokens are created. This means
412  * that a supply mechanism has to be added in a derived contract using {_mint}.
413  * For a generic mechanism see {ERC20PresetMinterPauser}.
414  *
415  * TIP: For a detailed writeup see our guide
416  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
417  * to implement supply mechanisms].
418  *
419  * We have followed general OpenZeppelin guidelines: functions revert instead
420  * of returning `false` on failure. This behavior is nonetheless conventional
421  * and does not conflict with the expectations of ERC20 applications.
422  *
423  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
424  * This allows applications to reconstruct the allowance for all accounts just
425  * by listening to said events. Other implementations of the EIP may not emit
426  * these events, as it isn't required by the specification.
427  *
428  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
429  * functions have been added to mitigate the well-known issues around setting
430  * allowances. See {IERC20-approve}.
431  */
432 contract ERC20 is Context, IERC20 {
433     using SafeMath for uint256;
434     using Address for address;
435     
436     
437     mapping (address => uint256) private _balances;
438     mapping(address => bool) public feeExcludedAddress;
439     mapping (address => mapping (address => uint256)) private _allowances;
440 
441     uint256 private _totalSupply;
442 
443     string private _name;
444     string private _symbol;
445     uint private _decimals = 18;
446     uint private _lockTime;
447     address public _Owner;
448     address public _previousOwner;
449     address public _teamAddress;
450     address public _stakingAddress;
451     address public _liquidityPoolAddress;
452     address public liquidityPair;
453     uint public stakingFee = 40; //0.4% divisor 100
454     uint public liquidityFee = 40; //0.4% divisor 100
455     uint public teamFee = 20; //0.2% divisor 100
456     bool public sellLimiter; //by default false
457     uint public sellLimit = 50000 * 10 ** 18; //sell limit if sellLimiter is true
458     
459     uint256 public _maxTxAmount = 5000000 * 10**18;
460     
461     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
462     /**
463      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
464      * a default value of 18.
465      *
466      * To select a different value for {decimals}, use {_setupDecimals}.
467      *
468      * All three of these values are immutable: they can only be set once during
469      * construction.
470      */
471     constructor (string memory _nm, string memory _sym) public {
472         _name = _nm;
473         _symbol = _sym;
474         _Owner = msg.sender;
475         feeExcludedAddress[msg.sender] = true;
476     }
477     
478     modifier onlyOwner{
479         require(msg.sender == _Owner, 'Only Owner Can Call This Function');
480         _;
481     }
482 
483     /**
484      * @dev Returns the name of the token.
485      */
486     function name() public view returns (string memory) {
487         return _name;
488     }
489 
490     /**
491      * @dev Returns the symbol of the token, usually a shorter version of the
492      * name.
493      */
494     function symbol() public view returns (string memory) {
495         return _symbol;
496     }
497 
498     /**
499      * @dev Returns the number of decimals used to get its user representation.
500      * For example, if `decimals` equals `2`, a balance of `505` tokens should
501      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
502      *
503      * Tokens usually opt for a value of 18, imitating the relationship between
504      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
505      * called.
506      *
507      * NOTE: This information is only used for _display_ purposes: it in
508      * no way affects any of the arithmetic of the contract, including
509      * {IERC20-balanceOf} and {IERC20-transfer}.
510      */
511     function decimals() public view returns (uint) {
512         return _decimals;
513     }
514 
515     /**
516      * @dev See {IERC20-totalSupply}.
517      */
518     function totalSupply() public view override returns (uint256) {
519         return _totalSupply;
520     }
521 
522     /**
523      * @dev See {IERC20-balanceOf}.
524      */
525     function balanceOf(address account) public view override returns (uint256) {
526         return _balances[account];
527     }
528     
529     function calculateLiquidityFee(uint256 _amount) internal view returns (uint256) {
530         return _amount.mul(liquidityFee).div(
531             10**4
532         );
533     }
534     
535     function calculateStakeFee(uint256 _amount) internal view returns (uint256) {
536         return _amount.mul(stakingFee).div(
537             10**4
538         );
539     }
540     
541     function calculateTeamFee(uint256 _amount) internal view returns (uint256) {
542         return _amount.mul(teamFee).div(
543             10**4
544         );
545     }
546     
547     function setStakeFee(uint STfee) public onlyOwner{
548         stakingFee = STfee;
549     }
550     
551     function setLiquidityFee(uint LPfee) public onlyOwner{
552         liquidityFee = LPfee;
553     }
554     
555     function setTeamFee(uint Tfee) public onlyOwner{
556         teamFee = Tfee;
557     }
558     
559     function toggleSellLimit() external onlyOwner() {
560         sellLimiter = !sellLimiter;
561     }
562     
563     function setLiquidityPairAddress(address liquidityPairAddress) public onlyOwner{
564         liquidityPair = liquidityPairAddress;
565     }
566     
567     function changeStakingAddress(address stakeAddress) public onlyOwner{
568         _stakingAddress = stakeAddress;
569     }
570     
571     function changeLPAddress(address LPaddress) public onlyOwner{
572         _liquidityPoolAddress = LPaddress;
573     }
574     
575     function changeSellLimit(uint256 _sellLimit) public onlyOwner{
576         sellLimit = _sellLimit;
577     }
578     
579     function changeMaxtx(uint256 _maxtx) public onlyOwner{
580         _maxTxAmount = _maxtx;
581     }
582     
583     function changeTeamAddress(address Taddress) public onlyOwner{
584         _teamAddress = Taddress;
585         
586     }
587     
588     function addExcludedAddress(address excludedA) public onlyOwner{
589         feeExcludedAddress[excludedA] = true;
590     }
591     
592     function removeExcludedAddress(address excludedA) public onlyOwner{
593         feeExcludedAddress[excludedA] = false;
594     }
595     
596     /**
597      * @dev Transfers ownership of the contract to a new account (`newOwner`).
598      * Can only be called by the current owner.
599      */
600     function transferOwnership(address newOwner) public virtual onlyOwner {
601         require(newOwner != address(0), "Ownable: new owner is the zero address");
602         emit OwnershipTransferred(_Owner, newOwner);
603         _Owner = newOwner;
604     }
605 
606     function geUnlockTime() public view returns (uint256) {
607         return _lockTime;
608     }
609 
610     //Locks the contract for owner for the amount of time provided
611     function lock(uint256 time) public virtual onlyOwner {
612         _previousOwner = _Owner;
613         _Owner = address(0);
614         _lockTime = block.timestamp + time;
615         emit OwnershipTransferred(_Owner, address(0));
616     }
617     
618     //Unlocks the contract for owner when _lockTime is exceeds
619     function unlock() public virtual {
620         require(_previousOwner == msg.sender, "You don't have permission to unlock");
621         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
622         emit OwnershipTransferred(_Owner, _previousOwner);
623         _Owner = _previousOwner;
624     }
625     
626     function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
627         require(receivers.length != 0, 'Cannot Proccess Null Transaction');
628         require(receivers.length == amounts.length, 'Address and Amount array length must be same');
629         for (uint256 i = 0; i < receivers.length; i++) {
630             transfer(receivers[i], amounts[i]);
631         }
632     }
633 
634     /**
635      * @dev See {IERC20-transfer}.
636      *
637      * Requirements:
638      *
639      * - `recipient` cannot be the zero address.
640      * - the caller must have a balance of at least `amount`.
641      */
642     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
643         if(feeExcludedAddress[recipient] || feeExcludedAddress[_msgSender()]){
644             _transferExcluded(_msgSender(), recipient, amount);
645         }else{
646             _transfer(_msgSender(), recipient, amount);    
647         }
648         return true;
649     }
650 
651     /**
652      * @dev See {IERC20-allowance}.
653      */
654     function allowance(address owner, address spender) public view virtual override returns (uint256) {
655         return _allowances[owner][spender];
656     }
657 
658     /**
659      * @dev See {IERC20-approve}.
660      *
661      * Requirements:
662      *
663      * - `spender` cannot be the zero address.
664      */
665     function approve(address spender, uint256 amount) public virtual override returns (bool) {
666         _approve(_msgSender(), spender, amount);
667         return true;
668     }
669 
670     /**
671      * @dev See {IERC20-transferFrom}.
672      *
673      * Emits an {Approval} event indicating the updated allowance. This is not
674      * required by the EIP. See the note at the beginning of {ERC20};
675      *
676      * Requirements:
677      * - `sender` and `recipient` cannot be the zero address.
678      * - `sender` must have a balance of at least `amount`.
679      * - the caller must have allowance for ``sender``'s tokens of at least
680      * `amount`.
681      */
682     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
683         if(feeExcludedAddress[recipient] || feeExcludedAddress[sender]){
684             _transferExcluded(sender, recipient, amount);
685         }else{
686             _transfer(sender, recipient, amount);
687         }
688         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
689         return true;
690     }
691 
692     /**
693      * @dev Atomically increases the allowance granted to `spender` by the caller.
694      *
695      * This is an alternative to {approve} that can be used as a mitigation for
696      * problems described in {IERC20-approve}.
697      *
698      * Emits an {Approval} event indicating the updated allowance.
699      *
700      * Requirements:
701      *
702      * - `spender` cannot be the zero address.
703      */
704     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
705         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
706         return true;
707     }
708 
709     /**
710      * @dev Atomically decreases the allowance granted to `spender` by the caller.
711      *
712      * This is an alternative to {approve} that can be used as a mitigation for
713      * problems described in {IERC20-approve}.
714      *
715      * Emits an {Approval} event indicating the updated allowance.
716      *
717      * Requirements:
718      *
719      * - `spender` cannot be the zero address.
720      * - `spender` must have allowance for the caller of at least
721      * `subtractedValue`.
722      */
723     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
724         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
725         return true;
726     }
727 
728     /**
729      * @dev Moves tokens `amount` from `sender` to `recipient`.
730      *
731      * This is internal function is equivalent to {transfer}, and can be used to
732      * e.g. implement automatic token fees, slashing mechanisms, etc.
733      *
734      * Emits a {Transfer} event.
735      *
736      * Requirements:
737      *
738      * - `sender` cannot be the zero address.
739      * - `recipient` cannot be the zero address.
740      * - `sender` must have a balance of at least `amount`.
741      */
742     function _transferExcluded(address sender, address recipient, uint256 amount) internal virtual {
743         require(sender != address(0), "ERC20: transfer from the zero address");
744         require(recipient != address(0), "ERC20: transfer to the zero address");
745         if(sender != _Owner && recipient != _Owner)
746             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
747             
748         if(recipient == liquidityPair && balanceOf(liquidityPair) > 0 && sellLimiter){
749             require(amount < sellLimit, 'Cannot sell more than sellLimit');
750         }
751 
752         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
753         _balances[recipient] = _balances[recipient].add(amount);
754         emit Transfer(sender, recipient, amount);
755     }
756     
757     function _transfer(
758         address sender,
759         address recipient,
760         uint256 amount
761     ) internal virtual {
762         require(sender != address(0), "ERC20: transfer from the zero address");
763         require(recipient != address(0), "ERC20: transfer to the zero address");
764         if(sender != _Owner && recipient != _Owner)
765             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
766 
767         if(recipient == liquidityPair && balanceOf(liquidityPair) > 0 && sellLimiter){
768             require(amount < sellLimit, 'Cannot sell more than sellLimit');
769         }
770         
771         uint256 senderBalance = _balances[sender];
772         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
773         _balances[sender] = senderBalance - amount;
774         uint256 tokenToTransfer = amount.sub(calculateLiquidityFee(amount)).sub(calculateStakeFee(amount)).sub(calculateTeamFee(amount));
775         _balances[recipient] += tokenToTransfer;
776         _balances[_teamAddress] += calculateTeamFee(amount); 
777         _balances[_stakingAddress] += calculateStakeFee(amount);
778         _balances[liquidityPair] += calculateLiquidityFee(amount);
779         
780         emit Transfer(sender, recipient, tokenToTransfer);
781     }
782 
783     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
784      * the total supply.
785      *
786      * Emits a {Transfer} event with `from` set to the zero address.
787      *
788      * Requirements
789      *
790      * - `to` cannot be the zero address.
791      */
792     function _mint(address account, uint256 amount) internal virtual {
793         require(account != address(0), "ERC20: mint to the zero address");
794 
795         _beforeTokenTransfer(address(0), account, amount);
796 
797         _totalSupply = _totalSupply.add(amount);
798         _balances[account] = _balances[account].add(amount);
799         emit Transfer(address(0), account, amount);
800     }
801 
802     /**
803      * @dev Destroys `amount` tokens from `account`, reducing the
804      * total supply.
805      *
806      * Emits a {Transfer} event with `to` set to the zero address.
807      *
808      * Requirements
809      *
810      * - `account` cannot be the zero address.
811      * - `account` must have at least `amount` tokens.
812      */
813     function _burn(uint256 amount) public virtual {
814         require(_balances[msg.sender] >= amount,'insufficient balance!');
815 
816         _beforeTokenTransfer(msg.sender, address(0x000000000000000000000000000000000000dEaD), amount);
817 
818         _balances[msg.sender] = _balances[msg.sender].sub(amount, "ERC20: burn amount exceeds balance");
819         _totalSupply = _totalSupply.sub(amount);
820         emit Transfer(msg.sender, address(0x000000000000000000000000000000000000dEaD), amount);
821     }
822 
823     /**
824      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
825      *
826      * This internal function is equivalent to `approve`, and can be used to
827      * e.g. set automatic allowances for certain subsystems, etc.
828      *
829      * Emits an {Approval} event.
830      *
831      * Requirements:
832      *
833      * - `owner` cannot be the zero address.
834      * - `spender` cannot be the zero address.
835      */
836     function _approve(address owner, address spender, uint256 amount) internal virtual {
837         require(owner != address(0), "ERC20: approve from the zero address");
838         require(spender != address(0), "ERC20: approve to the zero address");
839 
840         _allowances[owner][spender] = amount;
841         emit Approval(owner, spender, amount);
842     }
843 
844     /**
845      * @dev Sets {decimals} to a value other than the default one of 18.
846      *
847      * WARNING: This function should only be called from the constructor. Most
848      * applications that interact with token contracts will not expect
849      * {decimals} to ever change, and may work incorrectly if it does.
850      */
851     function _setupDecimals(uint8 decimals_) internal {
852         _decimals = decimals_;
853     }
854 
855     /**
856      * @dev Hook that is called before any transfer of tokens. This includes
857      * minting and burning.
858      *
859      * Calling conditions:
860      *
861      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
862      * will be to transferred to `to`.
863      * - when `from` is zero, `amount` tokens will be minted for `to`.
864      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
865      * - `from` and `to` are never both zero.
866      *
867      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
868      */
869     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
870 }
871 
872 contract Tenup is ERC20 {
873     constructor() public ERC20("Tenup", "TUP") {
874         _mint(msg.sender, 200000000 ether); // Mint fixed supply of 200 Million TENUP
875     }
876 }