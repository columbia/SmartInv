1 // Ethereum APEX (eAPEX)
2 // Telegram t.me/ethereumapex
3 // Website: www.ethereumapex.com
4 // Twitter: www.twitter.com/ApexEthereum
5 // 
6 //────────────────────────────────────────────────────────────────────────────────
7 //─██████████████─██████████████─██████████████─██████████████─████████──████████─
8 //─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░██──██░░░░██─
9 //─██░░██████████─██░░██████░░██─██░░██████░░██─██░░██████████─████░░██──██░░████─
10 //─██░░██─────────██░░██──██░░██─██░░██──██░░██─██░░██───────────██░░░░██░░░░██───
11 //─██░░██████████─██░░██████░░██─██░░██████░░██─██░░██████████───████░░░░░░████───
12 //─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─────██░░░░░░██─────
13 //─██░░██████████─██░░██████░░██─██░░██████████─██░░██████████───████░░░░░░████───
14 //─██░░██─────────██░░██──██░░██─██░░██─────────██░░██───────────██░░░░██░░░░██───
15 //─██░░██████████─██░░██──██░░██─██░░██─────────██░░██████████─████░░██──██░░████─
16 //─██░░░░░░░░░░██─██░░██──██░░██─██░░██─────────██░░░░░░░░░░██─██░░░░██──██░░░░██─
17 //─██████████████─██████──██████─██████─────────██████████████─████████──████████─
18 //────────────────────────────────────────────────────────────────────────────────
19 
20 /*
21  * @dev Provides information about the current execution context, including the
22  * sender of the transaction and its data. While these are generally available
23  * via msg.sender and msg.data, they should not be accessed in such a direct
24  * manner, since when dealing with GSN meta-transactions the account sending and
25  * paying for execution may not be the actual sender (as far as an application
26  * is concerned).
27  *
28  * This contract is only required for intermediate, library-like contracts.
29  */
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address payable) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes memory) {
36         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
37         return msg.data;
38     }
39 }
40 
41 
42 /**
43  * @dev Interface of the ERC20 standard as defined in the EIP.
44  */
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     /**
75      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * IMPORTANT: Beware that changing an allowance with this method brings the risk
80      * that someone may use both the old and the new allowance by unfortunate
81      * transaction ordering. One possible solution to mitigate this race
82      * condition is to first reduce the spender's allowance to 0 and set the
83      * desired value afterwards:
84      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85      *
86      * Emits an {Approval} event.
87      */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      *
140      * - Addition cannot overflow.
141      */
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return sub(a, b, "SafeMath: subtraction overflow");
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b <= a, errorMessage);
175         uint256 c = a - b;
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      *
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192         // benefit is lost if 'b' is also tested.
193         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
194         if (a == 0) {
195             return 0;
196         }
197 
198         uint256 c = a * b;
199         require(c / a == b, "SafeMath: multiplication overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         return div(a, b, "SafeMath: division by zero");
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b > 0, errorMessage);
234         uint256 c = a / b;
235         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236 
237         return c;
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
253         return mod(a, b, "SafeMath: modulo by zero");
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * Reverts with custom message when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b != 0, errorMessage);
270         return a % b;
271     }
272 }
273 
274 // File: openzeppelin-solidity\contracts\utils\Address.sol
275 
276 // SPDX-License-Identifier: MIT
277 
278 
279 /**
280  * @dev Collection of functions related to the address type
281  */
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * [IMPORTANT]
287      * ====
288      * It is unsafe to assume that an address for which this function returns
289      * false is an externally-owned account (EOA) and not a contract.
290      *
291      * Among others, `isContract` will return false for the following
292      * types of addresses:
293      *
294      *  - an externally-owned account
295      *  - a contract in construction
296      *  - an address where a contract will be created
297      *  - an address where a contract lived, but was destroyed
298      * ====
299      */
300     function isContract(address account) internal view returns (bool) {
301         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
302         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
303         // for accounts without code, i.e. `keccak256('')`
304         bytes32 codehash;
305         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
306         // solhint-disable-next-line no-inline-assembly
307         assembly { codehash := extcodehash(account) }
308         return (codehash != accountHash && codehash != 0x0);
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * IMPORTANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      */
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(address(this).balance >= amount, "Address: insufficient balance");
329 
330         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
331         (bool success, ) = recipient.call{ value: amount }("");
332         require(success, "Address: unable to send value, recipient may have reverted");
333     }
334 
335     /**
336      * @dev Performs a Solidity function call using a low level `call`. A
337      * plain`call` is an unsafe replacement for a function call: use this
338      * function instead.
339      *
340      * If `target` reverts with a revert reason, it is bubbled up by this
341      * function (like regular Solidity function calls).
342      *
343      * Returns the raw returned data. To convert to the expected return value,
344      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
345      *
346      * Requirements:
347      *
348      * - `target` must be a contract.
349      * - calling `target` with `data` must not revert.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
354         return functionCall(target, data, "Address: low-level call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
359      * `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
364         return _functionCallWithValue(target, data, 0, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but also transferring `value` wei to `target`.
370      *
371      * Requirements:
372      *
373      * - the calling contract must have an ETH balance of at least `value`.
374      * - the called Solidity function must be `payable`.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
384      * with `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         return _functionCallWithValue(target, data, value, errorMessage);
391     }
392 
393     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
394         require(isContract(target), "Address: call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 // solhint-disable-next-line no-inline-assembly
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 
418 
419 /**
420  * @dev Contract module which provides a basic access control mechanism, where
421  * there is an account (an owner) that can be granted exclusive access to
422  * specific functions.
423  *
424  * By default, the owner account will be the one that deploys the contract. This
425  * can later be changed with {transferOwnership}.
426  *
427  * This module is used through inheritance. It will make available the modifier
428  * `onlyOwner`, which can be applied to your functions to restrict their use to
429  * the owner.
430  */
431 contract Ownable is Context {
432     address private _owner;
433 
434     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
435 
436     /**
437      * @dev Initializes the contract setting the deployer as the initial owner.
438      */
439     constructor () internal {
440         address msgSender = _msgSender();
441         _owner = msgSender;
442         emit OwnershipTransferred(address(0), msgSender);
443     }
444 
445     /**
446      * @dev Returns the address of the current owner.
447      */
448     function owner() public view returns (address) {
449         return _owner;
450     }
451 
452     /**
453      * @dev Throws if called by any account other than the owner.
454      */
455     modifier onlyOwner() {
456         require(_owner == _msgSender(), "Ownable: caller is not the owner");
457         _;
458     }
459 
460     /**
461      * @dev Leaves the contract without owner. It will not be possible to call
462      * `onlyOwner` functions anymore. Can only be called by the current owner.
463      *
464      * NOTE: Renouncing ownership will leave the contract without an owner,
465      * thereby removing any functionality that is only available to the owner.
466      */
467     function renounceOwnership() public virtual onlyOwner {
468         emit OwnershipTransferred(_owner, address(0));
469         _owner = address(0);
470     }
471 
472     /**
473      * @dev Transfers ownership of the contract to a new account (`newOwner`).
474      * Can only be called by the current owner.
475      */
476     function transferOwnership(address newOwner) public virtual onlyOwner {
477         require(newOwner != address(0), "Ownable: new owner is the zero address");
478         emit OwnershipTransferred(_owner, newOwner);
479         _owner = newOwner;
480     }
481 }
482 
483 
484 pragma solidity ^0.6.2;
485 
486 contract eAPEX is Context, IERC20, Ownable {
487     using SafeMath for uint256;
488     using Address for address;
489 
490     mapping (address => uint256) private _rOwned;
491     mapping (address => uint256) private _tOwned;
492     mapping (address => mapping (address => uint256)) private _allowances;
493 
494     mapping (address => bool) private bot;
495     mapping (address => bool) private _isExcluded;
496     address[] private _excluded;
497     
498     mapping (address => bool) private ignoreDelay;
499     mapping (address => uint256) private waitTime;
500     uint16 private delayTime = 20;
501     bool private delay = true;
502     
503 
504     uint256 private constant MAX = ~uint256(0);
505     uint256 private constant _tTotal = 1 * 10**12 * 10**9;
506     uint256 private _rTotal = (MAX - (MAX % _tTotal));
507     uint256 private _tFeeTotal;
508 
509     string private _name = 'Ethereum APEX';
510     string private _symbol = 'eAPEX';
511     uint8 private _decimals = 9;
512 
513     constructor () public {
514         _rOwned[_msgSender()] = _rTotal;
515         emit Transfer(address(0), _msgSender(), _tTotal);
516     }
517 
518     function isDelay() public view returns(bool){
519         return delay;
520     }
521     
522     function currentDelayTime() public view returns(uint16){
523         return delayTime;    
524     }
525     
526     function isRouter(address router) public view returns(bool){
527         return ignoreDelay[router];
528     }
529     
530     function switchDelay() public onlyOwner{
531         delay = !delay;
532     }
533     
534     function setDelayTime(uint16 value) public onlyOwner{
535         delayTime = value;
536     }
537     
538     function setRouter(address router) public onlyOwner{
539         ignoreDelay[router] = !ignoreDelay[router];
540     }
541     
542     function name() public view returns (string memory) {
543         return _name;
544     }
545 
546     function symbol() public view returns (string memory) {
547         return _symbol;
548     }
549 
550     function decimals() public view returns (uint8) {
551         return _decimals;
552     }
553 
554     function totalSupply() public view override returns (uint256) {
555         return _tTotal;
556     }
557 
558     function balanceOf(address account) public view override returns (uint256) {
559         if (_isExcluded[account]) return _tOwned[account];
560         return tokenFromReflection(_rOwned[account]);
561     }
562 
563     function transfer(address recipient, uint256 amount) public override returns (bool) {
564         _transfer(_msgSender(), recipient, amount);
565         return true;
566     }
567 
568     function allowance(address owner, address spender) public view override returns (uint256) {
569         return _allowances[owner][spender];
570     }
571 
572     function approve(address spender, uint256 amount) public override returns (bool) {
573         _approve(_msgSender(), spender, amount);
574         return true;
575     }
576 
577     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
578         _transfer(sender, recipient, amount);
579         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
580         return true;
581     }
582 
583     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
584         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
585         return true;
586     }
587 
588     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
589         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
590         return true;
591     }
592 
593     function isExcluded(address account) public view returns (bool) {
594         return _isExcluded[account];
595     }
596 
597     function totalFees() public view returns (uint256) {
598         return _tFeeTotal;
599     }
600     function setBot(address blist) external onlyOwner returns (bool){
601         bot[blist] = !bot[blist];
602         return bot[blist];
603     }
604 
605     function reflect(uint256 tAmount) public {
606         address sender = _msgSender();
607         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
608         (uint256 rAmount,,,,) = _getValues(tAmount);
609         _rOwned[sender] = _rOwned[sender].sub(rAmount);
610         _rTotal = _rTotal.sub(rAmount);
611         _tFeeTotal = _tFeeTotal.add(tAmount);
612     }
613 
614     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
615         require(tAmount <= _tTotal, "Amount must be less than supply");
616         if (!deductTransferFee) {
617             (uint256 rAmount,,,,) = _getValues(tAmount);
618             return rAmount;
619         } else {
620             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
621             return rTransferAmount;
622         }
623     }
624 
625     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
626         require(rAmount <= _rTotal, "Amount must be less than total reflections");
627         uint256 currentRate =  _getRate();
628         return rAmount.div(currentRate);
629     }
630 
631     function excludeAccount(address account) external onlyOwner() {
632         require(!_isExcluded[account], "Account is already excluded");
633         if(_rOwned[account] > 0) {
634             _tOwned[account] = tokenFromReflection(_rOwned[account]);
635         }
636         _isExcluded[account] = true;
637         _excluded.push(account);
638     }
639 
640     function includeAccount(address account) external onlyOwner() {
641         require(_isExcluded[account], "Account is already excluded");
642         for (uint256 i = 0; i < _excluded.length; i++) {
643             if (_excluded[i] == account) {
644                 _excluded[i] = _excluded[_excluded.length - 1];
645                 _tOwned[account] = 0;
646                 _isExcluded[account] = false;
647                 _excluded.pop();
648                 break;
649             }
650         }
651     }
652 
653     function _approve(address owner, address spender, uint256 amount) private {
654         require(owner != address(0), "ERC20: approve from the zero address");
655         require(spender != address(0), "ERC20: approve to the zero address");
656 
657         _allowances[owner][spender] = amount;
658         emit Approval(owner, spender, amount);
659     }
660 
661     function _transfer(address sender, address recipient, uint256 amount) private {
662         require(sender != address(0), "ERC20: transfer from the zero address");
663         require(recipient != address(0), "ERC20: transfer to the zero address");
664         require(amount > 0, "Transfer amount must be greater than zero");
665         require(!bot[sender], "Play fair");
666         if(delay && !ignoreDelay[sender]){
667             require(block.number > waitTime[sender],"Please wait");
668         }
669         waitTime[recipient]=block.number + delayTime;
670         if (_isExcluded[sender] && !_isExcluded[recipient]) {
671             _transferFromExcluded(sender, recipient, amount);
672         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
673             _transferToExcluded(sender, recipient, amount);
674         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
675             _transferStandard(sender, recipient, amount);
676         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
677             _transferBothExcluded(sender, recipient, amount);
678         } else {
679             _transferStandard(sender, recipient, amount);
680         }
681     }
682 
683     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
684         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
685         _rOwned[sender] = _rOwned[sender].sub(rAmount);
686         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
687         _reflectFee(rFee, tFee);
688         emit Transfer(sender, recipient, tTransferAmount);
689     }
690 
691     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
692         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
693         _rOwned[sender] = _rOwned[sender].sub(rAmount);
694         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
695         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
696         _reflectFee(rFee, tFee);
697         emit Transfer(sender, recipient, tTransferAmount);
698     }
699 
700     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
701         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
702         _tOwned[sender] = _tOwned[sender].sub(tAmount);
703         _rOwned[sender] = _rOwned[sender].sub(rAmount);
704         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
705         _reflectFee(rFee, tFee);
706         emit Transfer(sender, recipient, tTransferAmount);
707     }
708 
709     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
710         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
711         _tOwned[sender] = _tOwned[sender].sub(tAmount);
712         _rOwned[sender] = _rOwned[sender].sub(rAmount);
713         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
714         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
715         _reflectFee(rFee, tFee);
716         emit Transfer(sender, recipient, tTransferAmount);
717     }
718 
719     function _reflectFee(uint256 rFee, uint256 tFee) private {
720         _rTotal = _rTotal.sub(rFee);
721         _tFeeTotal = _tFeeTotal.add(tFee);
722     }
723 
724     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
725         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
726         uint256 currentRate =  _getRate();
727         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
728         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
729     }
730 
731     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
732         uint256 tFee = tAmount.mul(30).div(100);
733         uint256 tTransferAmount = tAmount.sub(tFee);
734         return (tTransferAmount, tFee);
735     }
736 
737     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
738         uint256 rAmount = tAmount.mul(currentRate);
739         uint256 rFee = tFee.mul(currentRate);
740         uint256 rTransferAmount = rAmount.sub(rFee);
741         return (rAmount, rTransferAmount, rFee);
742     }
743 
744     function _getRate() private view returns(uint256) {
745         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
746         return rSupply.div(tSupply);
747     }
748 
749     function _getCurrentSupply() private view returns(uint256, uint256) {
750         uint256 rSupply = _rTotal;
751         uint256 tSupply = _tTotal;
752         for (uint256 i = 0; i < _excluded.length; i++) {
753             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
754             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
755             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
756         }
757         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
758         return (rSupply, tSupply);
759     }
760 }