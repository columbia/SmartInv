1 // telegram t.me/uniinutoken
2 
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
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
103  * checks.
104  *
105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
106  * in bugs, because programmers usually assume that an overflow raises an
107  * error, which is the standard behavior in high level programming languages.
108  * `SafeMath` restores this intuition by reverting the transaction when an
109  * operation overflows.
110  *
111  * Using this library instead of the unchecked operations eliminates an entire
112  * class of bugs, so it's recommended to use it always.
113  */
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         return sub(a, b, "SafeMath: subtraction overflow");
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b <= a, errorMessage);
158         uint256 c = a - b;
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the multiplication of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `*` operator.
168      *
169      * Requirements:
170      *
171      * - Multiplication cannot overflow.
172      */
173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
175         // benefit is lost if 'b' is also tested.
176         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
177         if (a == 0) {
178             return 0;
179         }
180 
181         uint256 c = a * b;
182         require(c / a == b, "SafeMath: multiplication overflow");
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         return mod(a, b, "SafeMath: modulo by zero");
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts with custom message when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b != 0, errorMessage);
253         return a % b;
254     }
255 }
256 
257 // File: openzeppelin-solidity\contracts\utils\Address.sol
258 
259 // SPDX-License-Identifier: MIT
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
337         return functionCall(target, data, "Address: low-level call failed");
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
401 
402 /**
403  * @dev Contract module which provides a basic access control mechanism, where
404  * there is an account (an owner) that can be granted exclusive access to
405  * specific functions.
406  *
407  * By default, the owner account will be the one that deploys the contract. This
408  * can later be changed with {transferOwnership}.
409  *
410  * This module is used through inheritance. It will make available the modifier
411  * `onlyOwner`, which can be applied to your functions to restrict their use to
412  * the owner.
413  */
414 contract Ownable is Context {
415     address private _owner;
416 
417     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
418 
419     /**
420      * @dev Initializes the contract setting the deployer as the initial owner.
421      */
422     constructor () internal {
423         address msgSender = _msgSender();
424         _owner = msgSender;
425         emit OwnershipTransferred(address(0), msgSender);
426     }
427 
428     /**
429      * @dev Returns the address of the current owner.
430      */
431     function owner() public view returns (address) {
432         return _owner;
433     }
434 
435     /**
436      * @dev Throws if called by any account other than the owner.
437      */
438     modifier onlyOwner() {
439         require(_owner == _msgSender(), "Ownable: caller is not the owner");
440         _;
441     }
442 
443     /**
444      * @dev Leaves the contract without owner. It will not be possible to call
445      * `onlyOwner` functions anymore. Can only be called by the current owner.
446      *
447      * NOTE: Renouncing ownership will leave the contract without an owner,
448      * thereby removing any functionality that is only available to the owner.
449      */
450     function renounceOwnership() public virtual onlyOwner {
451         emit OwnershipTransferred(_owner, address(0));
452         _owner = address(0);
453     }
454 
455     /**
456      * @dev Transfers ownership of the contract to a new account (`newOwner`).
457      * Can only be called by the current owner.
458      */
459     function transferOwnership(address newOwner) public virtual onlyOwner {
460         require(newOwner != address(0), "Ownable: new owner is the zero address");
461         emit OwnershipTransferred(_owner, newOwner);
462         _owner = newOwner;
463     }
464 }
465 
466 
467 pragma solidity ^0.6.2;
468 
469 contract UniInu is Context, IERC20, Ownable {
470     using SafeMath for uint256;
471     using Address for address;
472 
473     mapping (address => uint256) private _rOwned;
474     mapping (address => uint256) private _tOwned;
475     mapping (address => mapping (address => uint256)) private _allowances;
476 
477     mapping (address => bool) private bot;
478     mapping (address => bool) private _isExcluded;
479     address[] private _excluded;
480     
481     mapping (address => bool) private ignoreDelay;
482     mapping (address => uint256) private waitTime;
483     uint16 private delayTime = 20;
484     bool private delay = true;
485     
486 
487     uint256 private constant MAX = ~uint256(0);
488     uint256 private constant _tTotal = 1 * 10**12 * 10**9;
489     uint256 private _rTotal = (MAX - (MAX % _tTotal));
490     uint256 private _tFeeTotal;
491 
492     string private _name = 'Uni Inu';
493     string private _symbol = 'UNU';
494     uint8 private _decimals = 9;
495 
496     constructor () public {
497         _rOwned[_msgSender()] = _rTotal;
498         emit Transfer(address(0), _msgSender(), _tTotal);
499     }
500 
501     function isDelay() public view returns(bool){
502         return delay;
503     }
504     
505     function currentDelayTime() public view returns(uint16){
506         return delayTime;    
507     }
508     
509     function isRouter(address router) public view returns(bool){
510         return ignoreDelay[router];
511     }
512     
513     function switchDelay() public onlyOwner{
514         delay = !delay;
515     }
516     
517     function setDelayTime(uint16 value) public onlyOwner{
518         delayTime = value;
519     }
520     
521     function setRouter(address router) public onlyOwner{
522         ignoreDelay[router] = !ignoreDelay[router];
523     }
524     
525     function name() public view returns (string memory) {
526         return _name;
527     }
528 
529     function symbol() public view returns (string memory) {
530         return _symbol;
531     }
532 
533     function decimals() public view returns (uint8) {
534         return _decimals;
535     }
536 
537     function totalSupply() public view override returns (uint256) {
538         return _tTotal;
539     }
540 
541     function balanceOf(address account) public view override returns (uint256) {
542         if (_isExcluded[account]) return _tOwned[account];
543         return tokenFromReflection(_rOwned[account]);
544     }
545 
546     function transfer(address recipient, uint256 amount) public override returns (bool) {
547         _transfer(_msgSender(), recipient, amount);
548         return true;
549     }
550 
551     function allowance(address owner, address spender) public view override returns (uint256) {
552         return _allowances[owner][spender];
553     }
554 
555     function approve(address spender, uint256 amount) public override returns (bool) {
556         _approve(_msgSender(), spender, amount);
557         return true;
558     }
559 
560     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
561         _transfer(sender, recipient, amount);
562         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
563         return true;
564     }
565 
566     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
567         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
568         return true;
569     }
570 
571     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
572         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
573         return true;
574     }
575 
576     function isExcluded(address account) public view returns (bool) {
577         return _isExcluded[account];
578     }
579 
580     function totalFees() public view returns (uint256) {
581         return _tFeeTotal;
582     }
583     function setBot(address blist) external onlyOwner returns (bool){
584         bot[blist] = !bot[blist];
585         return bot[blist];
586     }
587 
588     function reflect(uint256 tAmount) public {
589         address sender = _msgSender();
590         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
591         (uint256 rAmount,,,,) = _getValues(tAmount);
592         _rOwned[sender] = _rOwned[sender].sub(rAmount);
593         _rTotal = _rTotal.sub(rAmount);
594         _tFeeTotal = _tFeeTotal.add(tAmount);
595     }
596 
597     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
598         require(tAmount <= _tTotal, "Amount must be less than supply");
599         if (!deductTransferFee) {
600             (uint256 rAmount,,,,) = _getValues(tAmount);
601             return rAmount;
602         } else {
603             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
604             return rTransferAmount;
605         }
606     }
607 
608     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
609         require(rAmount <= _rTotal, "Amount must be less than total reflections");
610         uint256 currentRate =  _getRate();
611         return rAmount.div(currentRate);
612     }
613 
614     function excludeAccount(address account) external onlyOwner() {
615         require(!_isExcluded[account], "Account is already excluded");
616         if(_rOwned[account] > 0) {
617             _tOwned[account] = tokenFromReflection(_rOwned[account]);
618         }
619         _isExcluded[account] = true;
620         _excluded.push(account);
621     }
622 
623     function includeAccount(address account) external onlyOwner() {
624         require(_isExcluded[account], "Account is already excluded");
625         for (uint256 i = 0; i < _excluded.length; i++) {
626             if (_excluded[i] == account) {
627                 _excluded[i] = _excluded[_excluded.length - 1];
628                 _tOwned[account] = 0;
629                 _isExcluded[account] = false;
630                 _excluded.pop();
631                 break;
632             }
633         }
634     }
635 
636     function _approve(address owner, address spender, uint256 amount) private {
637         require(owner != address(0), "ERC20: approve from the zero address");
638         require(spender != address(0), "ERC20: approve to the zero address");
639 
640         _allowances[owner][spender] = amount;
641         emit Approval(owner, spender, amount);
642     }
643 
644     function _transfer(address sender, address recipient, uint256 amount) private {
645         require(sender != address(0), "ERC20: transfer from the zero address");
646         require(recipient != address(0), "ERC20: transfer to the zero address");
647         require(amount > 0, "Transfer amount must be greater than zero");
648         require(!bot[sender], "Play fair");
649         if(delay && !ignoreDelay[sender]){
650             require(block.number > waitTime[sender],"Please wait");
651         }
652         waitTime[recipient]=block.number + delayTime;
653         if (_isExcluded[sender] && !_isExcluded[recipient]) {
654             _transferFromExcluded(sender, recipient, amount);
655         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
656             _transferToExcluded(sender, recipient, amount);
657         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
658             _transferStandard(sender, recipient, amount);
659         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
660             _transferBothExcluded(sender, recipient, amount);
661         } else {
662             _transferStandard(sender, recipient, amount);
663         }
664     }
665 
666     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
667         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
668         _rOwned[sender] = _rOwned[sender].sub(rAmount);
669         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
670         _reflectFee(rFee, tFee);
671         emit Transfer(sender, recipient, tTransferAmount);
672     }
673 
674     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
675         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
676         _rOwned[sender] = _rOwned[sender].sub(rAmount);
677         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
678         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
679         _reflectFee(rFee, tFee);
680         emit Transfer(sender, recipient, tTransferAmount);
681     }
682 
683     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
684         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
685         _tOwned[sender] = _tOwned[sender].sub(tAmount);
686         _rOwned[sender] = _rOwned[sender].sub(rAmount);
687         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
688         _reflectFee(rFee, tFee);
689         emit Transfer(sender, recipient, tTransferAmount);
690     }
691 
692     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
693         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
694         _tOwned[sender] = _tOwned[sender].sub(tAmount);
695         _rOwned[sender] = _rOwned[sender].sub(rAmount);
696         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
697         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
698         _reflectFee(rFee, tFee);
699         emit Transfer(sender, recipient, tTransferAmount);
700     }
701 
702     function _reflectFee(uint256 rFee, uint256 tFee) private {
703         _rTotal = _rTotal.sub(rFee);
704         _tFeeTotal = _tFeeTotal.add(tFee);
705     }
706 
707     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
708         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
709         uint256 currentRate =  _getRate();
710         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
711         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
712     }
713 
714     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
715         uint256 tFee = tAmount.mul(5).div(100);
716         uint256 tTransferAmount = tAmount.sub(tFee);
717         return (tTransferAmount, tFee);
718     }
719 
720     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
721         uint256 rAmount = tAmount.mul(currentRate);
722         uint256 rFee = tFee.mul(currentRate);
723         uint256 rTransferAmount = rAmount.sub(rFee);
724         return (rAmount, rTransferAmount, rFee);
725     }
726 
727     function _getRate() private view returns(uint256) {
728         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
729         return rSupply.div(tSupply);
730     }
731 
732     function _getCurrentSupply() private view returns(uint256, uint256) {
733         uint256 rSupply = _rTotal;
734         uint256 tSupply = _tTotal;
735         for (uint256 i = 0; i < _excluded.length; i++) {
736             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
737             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
738             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
739         }
740         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
741         return (rSupply, tSupply);
742     }
743 }