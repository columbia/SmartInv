1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity >=0.6.2;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP.
17  */
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * IMPORTANT: Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an {Approval} event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `sender` to `recipient` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * @dev Wrappers over Solidity's arithmetic operations with added overflow
91  * checks.
92  *
93  * Arithmetic operations in Solidity wrap on overflow. This can easily result
94  * in bugs, because programmers usually assume that an overflow raises an
95  * error, which is the standard behavior in high level programming languages.
96  * `SafeMath` restores this intuition by reverting the transaction when an
97  * operation overflows.
98  *
99  * Using this library instead of the unchecked operations eliminates an entire
100  * class of bugs, so it's recommended to use it always.
101  */
102 library SafeMath {
103     /**
104      * @dev Returns the addition of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `+` operator.
108      *
109      * Requirements:
110      *
111      * - Addition cannot overflow.
112      */
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         require(c >= a, "SafeMath: addition overflow");
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         return sub(a, b, "SafeMath: subtraction overflow");
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145         require(b <= a, errorMessage);
146         uint256 c = a - b;
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `*` operator.
156      *
157      * Requirements:
158      *
159      * - Multiplication cannot overflow.
160      */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
163         // benefit is lost if 'b' is also ested.
164         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
165         if (a == 0) {
166             return 0;
167         }
168 
169         uint256 c = a * b;
170         require(c / a == b, "SafeMath: multiplication overflow");
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      *
185      * - The divisor cannot be zero.
186      */
187     function div(uint256 a, uint256 b) internal pure returns (uint256) {
188         return div(a, b, "SafeMath: division by zero");
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204         require(b > 0, errorMessage);
205         uint256 c = a / b;
206         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * Reverts when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
224         return mod(a, b, "SafeMath: modulo by zero");
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts with custom message when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b != 0, errorMessage);
241         return a % b;
242     }
243 }
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
268         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
269         // for accounts without code, i.e. `keccak256('')`
270         bytes32 codehash;
271         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { codehash := extcodehash(account) }
274         return (codehash != accountHash && codehash != 0x0);
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain`call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320       return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return _functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         return _functionCallWithValue(target, data, value, errorMessage);
357     }
358 
359     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 // solhint-disable-next-line no-inline-assembly
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 contract Ownable is Context {
384     address private _owner;
385     address private _previousOwner;
386     uint256 private _lockTime;
387 
388     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
389 
390     /**
391      * @dev Initializes the contract setting the deployer as the initial owner.
392      */
393     constructor () internal {
394         address msgSender = _msgSender();
395         _owner = msgSender;
396         emit OwnershipTransferred(address(0), msgSender);
397     }
398 
399     /**
400      * @dev Returns the address of the current owner.
401      */
402     function owner() public view returns (address) {
403         return _owner;
404     }
405 
406     /**
407      * @dev Throws if called by any account other than the owner.
408      */
409     modifier onlyOwner() {
410         require(_owner == _msgSender(), "Ownable: caller is not the owner");
411         _;
412     }
413 
414      /**
415      * @dev Leaves the contract without owner. It will not be possible to call
416      * `onlyOwner` functions anymore. Can only be called by the current owner.
417      *
418      * NOTE: Renouncing ownership will leave the contract without an owner,
419      * thereby removing any functionality that is only available to the owner.
420      */
421     function renounceOwnership() public virtual onlyOwner {
422         emit OwnershipTransferred(_owner, address(0));
423         _owner = address(0);
424     }
425 
426     /**
427      * @dev Transfers ownership of the contract to a new account (`newOwner`).
428      * Can only be called by the current owner.
429      */
430     function transferOwnership(address newOwner) public virtual onlyOwner {
431         require(newOwner != address(0), "Ownable: new owner is the zero address");
432         emit OwnershipTransferred(_owner, newOwner);
433         _owner = newOwner;
434     }
435 
436     function geUnlockTime() public view returns (uint256) {
437         return _lockTime;
438     }
439 
440     //Locks the contract for owner for the amount of time provided
441     function lock(uint256 time) public virtual onlyOwner {
442         _previousOwner = _owner;
443         _owner = address(0);
444         _lockTime = now + time;
445         emit OwnershipTransferred(_owner, address(0));
446     }
447     
448     //Unlocks the contract for owner when _lockTime is exceeds
449     function unlock() public virtual {
450         require(_previousOwner == msg.sender, "You don't have permission to unlock");
451         require(now > _lockTime , "Contract is locked until 7 days");
452         emit OwnershipTransferred(_owner, _previousOwner);
453         _owner = _previousOwner;
454     }
455 }
456 
457 contract EthereumFlamingo is Context, IERC20, Ownable {
458     using SafeMath for uint256;
459     using Address for address;
460 
461     mapping (address => uint256) private _rOwned;
462     mapping (address => uint256) private _tOwned;
463     mapping (address => mapping (address => uint256)) private _allowances;
464 
465     mapping (address => bool) private _isExcluded;
466     address[] private _excluded;
467 
468     mapping (address => bool) private _isBlackListedBot;
469     address[] private _blackListedBots;
470 
471    
472     uint256 private constant MAX = ~uint256(0);
473     uint256 private _tTotal = 1000000000000 * 10**9;
474     uint256 private _rTotal = (MAX - (MAX % _tTotal));
475     uint256 private _tFeeTotal;
476     uint256 private _tBurnTotal;
477 
478     string private _name = 'Ethereum Flamingo'; 
479     string private _symbol = 'EFLAM';
480     uint8 private _decimals = 9;
481     
482     uint256 private _taxFee = 0;
483     uint256 private _burnFee = 2;
484     uint256 private _maxTxAmount = 1000000000e9;
485 
486     constructor () public {
487         _rOwned[_msgSender()] = _rTotal;
488         emit Transfer(address(0), _msgSender(), _tTotal);
489     }
490 
491     function name() public view returns (string memory) {
492         return _name;
493     }
494 
495     function symbol() public view returns (string memory) {
496         return _symbol;
497     }
498 
499     function decimals() public view returns (uint8) {
500         return _decimals;
501     }
502 
503     function totalSupply() public view override returns (uint256) {
504         return _tTotal;
505     }
506 
507     function balanceOf(address account) public view override returns (uint256) {
508         if (_isExcluded[account]) return _tOwned[account];
509         return tokenFromReflection(_rOwned[account]);
510     }
511 
512     function transfer(address recipient, uint256 amount) public override returns (bool) {
513         _transfer(_msgSender(), recipient, amount);
514         return true;
515     }
516 
517     function allowance(address owner, address spender) public view override returns (uint256) {
518         return _allowances[owner][spender];
519     }
520 
521     function approve(address spender, uint256 amount) public override returns (bool) {
522         _approve(_msgSender(), spender, amount);
523         return true;
524     }
525 
526     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
527         _transfer(sender, recipient, amount);
528         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
529         return true;
530     }
531 
532     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
533         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
534         return true;
535     }
536 
537     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
538         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
539         return true;
540     }
541 
542     function isExcluded(address account) public view returns (bool) {
543         return _isExcluded[account];
544     }
545 
546     function totalFees() public view returns (uint256) {
547         return _tFeeTotal;
548     }
549     
550     function totalBurn() public view returns (uint256) {
551         return _tBurnTotal;
552     }
553 
554     function deliver(uint256 tAmount) public {
555         address sender = _msgSender();
556         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
557         (uint256 rAmount,,,,,) = _getValues(tAmount);
558         _rOwned[sender] = _rOwned[sender].sub(rAmount);
559         _rTotal = _rTotal.sub(rAmount);
560         _tFeeTotal = _tFeeTotal.add(tAmount);
561     }
562 
563     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
564         require(tAmount <= _tTotal, "Amount must be less than supply");
565         if (!deductTransferFee) {
566             (uint256 rAmount,,,,,) = _getValues(tAmount);
567             return rAmount;
568         } else {
569             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
570             return rTransferAmount;
571         }
572     }
573 
574     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
575         require(rAmount <= _rTotal, "Amount must be less than total reflections");
576         uint256 currentRate =  _getRate();
577         return rAmount.div(currentRate);
578     }
579 
580     function excludeAccount(address account) external onlyOwner() {
581         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
582         require(!_isExcluded[account], "Account is already excluded");
583         if(_rOwned[account] > 0) {
584             _tOwned[account] = tokenFromReflection(_rOwned[account]);
585         }
586         _isExcluded[account] = true;
587         _excluded.push(account);
588     }
589 
590     function includeAccount(address account) external onlyOwner() {
591         require(_isExcluded[account], "Account is already excluded");
592         for (uint256 i = 0; i < _excluded.length; i++) {
593             if (_excluded[i] == account) {
594                 _excluded[i] = _excluded[_excluded.length - 1];
595                 _tOwned[account] = 0;
596                 _isExcluded[account] = false;
597                 _excluded.pop();
598                 break;
599             }
600         }
601     }
602 
603         function addBotToBlackList(address account) external onlyOwner() {
604         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
605         require(!_isBlackListedBot[account], "Account is already blacklisted");
606         _isBlackListedBot[account] = true;
607         _blackListedBots.push(account);
608     }
609 
610     function removeBotFromBlackList(address account) external onlyOwner() {
611         require(_isBlackListedBot[account], "Account is not blacklisted");
612         for (uint256 i = 0; i < _blackListedBots.length; i++) {
613             if (_blackListedBots[i] == account) {
614                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
615                 _isBlackListedBot[account] = false;
616                 _blackListedBots.pop();
617                 break;
618             }
619         }
620     }
621 
622     function _approve(address owner, address spender, uint256 amount) private {
623         require(owner != address(0), "ERC20: approve from the zero address");
624         require(spender != address(0), "ERC20: approve to the zero address");
625 
626         _allowances[owner][spender] = amount;
627         emit Approval(owner, spender, amount);
628     }
629 
630     function _transfer(address sender, address recipient, uint256 amount) private {
631         require(sender != address(0), "ERC20: transfer from the zero address");
632         require(recipient != address(0), "ERC20: transfer to the zero address");
633         require(amount > 0, "Transfer amount must be greater than zero");
634 
635         require(!_isBlackListedBot[recipient], "You have no power here!");
636         require(!_isBlackListedBot[msg.sender], "You have no power here!");
637         require(!_isBlackListedBot[sender], "You have no power here!");
638         
639         if(sender != owner() && recipient != owner())
640             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
641         
642         if (_isExcluded[sender] && !_isExcluded[recipient]) {
643             _transferFromExcluded(sender, recipient, amount);
644         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
645             _transferToExcluded(sender, recipient, amount);
646         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
647             _transferStandard(sender, recipient, amount);
648         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
649             _transferBothExcluded(sender, recipient, amount);
650         } else {
651             _transferStandard(sender, recipient, amount);
652         }
653     }
654 
655     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
656         uint256 currentRate =  _getRate();
657         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
658         uint256 rBurn =  tBurn.mul(currentRate);
659         _rOwned[sender] = _rOwned[sender].sub(rAmount);
660         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
661         _reflectFee(rFee, rBurn, tFee, tBurn);
662         emit Transfer(sender, recipient, tTransferAmount);
663     }
664 
665     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
666         uint256 currentRate =  _getRate();
667         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
668         uint256 rBurn =  tBurn.mul(currentRate);
669         _rOwned[sender] = _rOwned[sender].sub(rAmount);
670         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
671         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
672         _reflectFee(rFee, rBurn, tFee, tBurn);
673         emit Transfer(sender, recipient, tTransferAmount);
674     }
675 
676     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
677         uint256 currentRate =  _getRate();
678         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
679         uint256 rBurn =  tBurn.mul(currentRate);
680         _tOwned[sender] = _tOwned[sender].sub(tAmount);
681         _rOwned[sender] = _rOwned[sender].sub(rAmount);
682         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
683         _reflectFee(rFee, rBurn, tFee, tBurn);
684         emit Transfer(sender, recipient, tTransferAmount);
685     }
686 
687     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
688         uint256 currentRate =  _getRate();
689         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
690         uint256 rBurn =  tBurn.mul(currentRate);
691         _tOwned[sender] = _tOwned[sender].sub(tAmount);
692         _rOwned[sender] = _rOwned[sender].sub(rAmount);
693         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
694         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
695         _reflectFee(rFee, rBurn, tFee, tBurn);
696         emit Transfer(sender, recipient, tTransferAmount);
697     }
698 
699     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
700         _rTotal = _rTotal.sub(rFee).sub(rBurn);
701         _tFeeTotal = _tFeeTotal.add(tFee);
702         _tBurnTotal = _tBurnTotal.add(tBurn);
703         _tTotal = _tTotal.sub(tBurn);
704     }
705 
706     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
707         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _taxFee, _burnFee);
708         uint256 currentRate =  _getRate();
709         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
710         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
711     }
712 
713     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
714         uint256 tFee = tAmount.mul(taxFee).div(100);
715         uint256 tBurn = tAmount.mul(burnFee).div(100);
716         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
717         return (tTransferAmount, tFee, tBurn);
718     }
719 
720     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
721         uint256 rAmount = tAmount.mul(currentRate);
722         uint256 rFee = tFee.mul(currentRate);
723         uint256 rBurn = tBurn.mul(currentRate);
724         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
725         return (rAmount, rTransferAmount, rFee);
726     }
727 
728     function _getRate() private view returns(uint256) {
729         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
730         return rSupply.div(tSupply);
731     }
732 
733     function _getCurrentSupply() private view returns(uint256, uint256) {
734         uint256 rSupply = _rTotal;
735         uint256 tSupply = _tTotal;      
736         for (uint256 i = 0; i < _excluded.length; i++) {
737             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
738             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
739             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
740         }
741         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
742         return (rSupply, tSupply);
743     }
744     
745     function _getTaxFee() private view returns(uint256) {
746         return _taxFee;
747     }
748 
749     function _getMaxTxAmount() private view returns(uint256) {
750         return _maxTxAmount;
751     }
752     
753     function _setTaxFee(uint256 taxFee) external onlyOwner() {
754         require(taxFee >= _taxFee && taxFee <= 10, 'taxFee can only be increased and max is 10');
755         _taxFee = taxFee;
756     }
757     
758     function _setBurnFee(uint256 burnFee) external onlyOwner() {
759         require(burnFee >= _burnFee && burnFee <= 10, 'burnFee can only be increased and max is 10');
760         _burnFee = burnFee;
761     }
762     
763     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
764         require(maxTxAmount >= 1000000000e9 , 'maxTxAmount should be greater than 1000000000e9');
765         _maxTxAmount = maxTxAmount;
766     }
767 }