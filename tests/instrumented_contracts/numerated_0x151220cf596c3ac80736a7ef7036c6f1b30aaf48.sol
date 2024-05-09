1 pragma solidity >=0.6.2;
2 
3 
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 
17 
18 /**
19  * @dev Interface of the ERC20 standard as defined in the EIP.
20  */
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Emitted when `value` tokens are moved from one account (`from`) to
79      * another (`to`).
80      *
81      * Note that `value` may be zero.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     /**
86      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87      * a call to {approve}. `value` is the new allowance.
88      */
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 
93 
94 contract Ownable is Context {
95     address private _owner;
96     address private _previousOwner;
97     uint256 private _lockTime;
98 
99     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
100 
101     /**
102      * @dev Initializes the contract setting the deployer as the initial owner.
103      */
104     constructor () internal {
105         address msgSender = _msgSender();
106         _owner = msgSender;
107         emit OwnershipTransferred(address(0), msgSender);
108     }
109 
110     /**
111      * @dev Returns the address of the current owner.
112      */
113     function owner() public view returns (address) {
114         return _owner;
115     }
116 
117     /**
118      * @dev Throws if called by any account other than the owner.
119      */
120     modifier onlyOwner() {
121         require(_owner == _msgSender(), "Ownable: caller is not the owner");
122         _;
123     }
124 
125      /**
126      * @dev Leaves the contract without owner. It will not be possible to call
127      * `onlyOwner` functions anymore. Can only be called by the current owner.
128      *
129      * NOTE: Renouncing ownership will leave the contract without an owner,
130      * thereby removing any functionality that is only available to the owner.
131      */
132     function renounceOwnership() public virtual onlyOwner {
133         emit OwnershipTransferred(_owner, address(0));
134         _owner = address(0);
135     }
136 
137     /**
138      * @dev Transfers ownership of the contract to a new account (`newOwner`).
139      * Can only be called by the current owner.
140      */
141     function transferOwnership(address newOwner) public virtual onlyOwner {
142         require(newOwner != address(0), "Ownable: new owner is the zero address");
143         emit OwnershipTransferred(_owner, newOwner);
144         _owner = newOwner;
145     }
146 
147     function geUnlockTime() public view returns (uint256) {
148         return _lockTime;
149     }
150 
151     //Locks the contract for owner for the amount of time provided
152     function lock(uint256 time) public virtual onlyOwner {
153         _previousOwner = _owner;
154         _owner = address(0);
155         _lockTime = now + time;
156         emit OwnershipTransferred(_owner, address(0));
157     }
158     
159     //Unlocks the contract for owner when _lockTime is exceeds
160     function unlock() public virtual {
161         require(_previousOwner == msg.sender, "You don't have permission to unlock");
162         require(now > _lockTime , "Contract is locked until 7 days");
163         emit OwnershipTransferred(_owner, _previousOwner);
164         _owner = _previousOwner;
165     }
166 }
167 
168 
169 /**
170  * @dev Wrappers over Solidity's arithmetic operations with added overflow
171  * checks.
172  *
173  * Arithmetic operations in Solidity wrap on overflow. This can easily result
174  * in bugs, because programmers usually assume that an overflow raises an
175  * error, which is the standard behavior in high level programming languages.
176  * `SafeMath` restores this intuition by reverting the transaction when an
177  * operation overflows.
178  *
179  * Using this library instead of the unchecked operations eliminates an entire
180  * class of bugs, so it's recommended to use it always.
181  */
182 library SafeMath {
183     /**
184      * @dev Returns the addition of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `+` operator.
188      *
189      * Requirements:
190      *
191      * - Addition cannot overflow.
192      */
193     function add(uint256 a, uint256 b) internal pure returns (uint256) {
194         uint256 c = a + b;
195         require(c >= a, "SafeMath: addition overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         return sub(a, b, "SafeMath: subtraction overflow");
212     }
213 
214     /**
215      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
216      * overflow (when the result is negative).
217      *
218      * Counterpart to Solidity's `-` operator.
219      *
220      * Requirements:
221      *
222      * - Subtraction cannot overflow.
223      */
224     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b <= a, errorMessage);
226         uint256 c = a - b;
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the multiplication of two unsigned integers, reverting on
233      * overflow.
234      *
235      * Counterpart to Solidity's `*` operator.
236      *
237      * Requirements:
238      *
239      * - Multiplication cannot overflow.
240      */
241     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
242         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
243         // benefit is lost if 'b' is also tested.
244         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
245         if (a == 0) {
246             return 0;
247         }
248 
249         uint256 c = a * b;
250         require(c / a == b, "SafeMath: multiplication overflow");
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the integer division of two unsigned integers. Reverts on
257      * division by zero. The result is rounded towards zero.
258      *
259      * Counterpart to Solidity's `/` operator. Note: this function uses a
260      * `revert` opcode (which leaves remaining gas untouched) while Solidity
261      * uses an invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function div(uint256 a, uint256 b) internal pure returns (uint256) {
268         return div(a, b, "SafeMath: division by zero");
269     }
270 
271     /**
272      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
273      * division by zero. The result is rounded towards zero.
274      *
275      * Counterpart to Solidity's `/` operator. Note: this function uses a
276      * `revert` opcode (which leaves remaining gas untouched) while Solidity
277      * uses an invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         require(b > 0, errorMessage);
285         uint256 c = a / b;
286         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * Reverts when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
304         return mod(a, b, "SafeMath: modulo by zero");
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * Reverts with custom message when dividing by zero.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b != 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 
326 /**
327  * @dev Collection of functions related to the address type
328  */
329 library Address {
330     /**
331      * @dev Returns true if `account` is a contract.
332      *
333      * [IMPORTANT]
334      * ====
335      * It is unsafe to assume that an address for which this function returns
336      * false is an externally-owned account (EOA) and not a contract.
337      *
338      * Among others, `isContract` will return false for the following
339      * types of addresses:
340      *
341      *  - an externally-owned account
342      *  - a contract in construction
343      *  - an address where a contract will be created
344      *  - an address where a contract lived, but was destroyed
345      * ====
346      */
347     function isContract(address account) internal view returns (bool) {
348         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
349         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
350         // for accounts without code, i.e. `keccak256('')`
351         bytes32 codehash;
352         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
353         // solhint-disable-next-line no-inline-assembly
354         assembly { codehash := extcodehash(account) }
355         return (codehash != accountHash && codehash != 0x0);
356     }
357 
358     /**
359      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
360      * `recipient`, forwarding all available gas and reverting on errors.
361      *
362      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
363      * of certain opcodes, possibly making contracts go over the 2300 gas limit
364      * imposed by `transfer`, making them unable to receive funds via
365      * `transfer`. {sendValue} removes this limitation.
366      *
367      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
368      *
369      * IMPORTANT: because control is transferred to `recipient`, care must be
370      * taken to not create reentrancy vulnerabilities. Consider using
371      * {ReentrancyGuard} or the
372      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
373      */
374     function sendValue(address payable recipient, uint256 amount) internal {
375         require(address(this).balance >= amount, "Address: insufficient balance");
376 
377         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
378         (bool success, ) = recipient.call{ value: amount }("");
379         require(success, "Address: unable to send value, recipient may have reverted");
380     }
381 
382     /**
383      * @dev Performs a Solidity function call using a low level `call`. A
384      * plain`call` is an unsafe replacement for a function call: use this
385      * function instead.
386      *
387      * If `target` reverts with a revert reason, it is bubbled up by this
388      * function (like regular Solidity function calls).
389      *
390      * Returns the raw returned data. To convert to the expected return value,
391      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
392      *
393      * Requirements:
394      *
395      * - `target` must be a contract.
396      * - calling `target` with `data` must not revert.
397      *
398      * _Available since v3.1._
399      */
400     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
401       return functionCall(target, data, "Address: low-level call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
406      * `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
411         return _functionCallWithValue(target, data, 0, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but also transferring `value` wei to `target`.
417      *
418      * Requirements:
419      *
420      * - the calling contract must have an ETH balance of at least `value`.
421      * - the called Solidity function must be `payable`.
422      *
423      * _Available since v3.1._
424      */
425     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
426         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
431      * with `errorMessage` as a fallback revert reason when `target` reverts.
432      *
433      * _Available since v3.1._
434      */
435     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
436         require(address(this).balance >= value, "Address: insufficient balance for call");
437         return _functionCallWithValue(target, data, value, errorMessage);
438     }
439 
440     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
441         require(isContract(target), "Address: call to non-contract");
442 
443         // solhint-disable-next-line avoid-low-level-calls
444         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451 
452                 // solhint-disable-next-line no-inline-assembly
453                 assembly {
454                     let returndata_size := mload(returndata)
455                     revert(add(32, returndata), returndata_size)
456                 }
457             } else {
458                 revert(errorMessage);
459             }
460         }
461     }
462 }
463 
464 
465 contract CORGI is Context, IERC20, Ownable {
466     using SafeMath for uint256;
467     using Address for address;
468 
469     mapping (address => uint256) private _rOwned;
470     mapping (address => uint256) private _tOwned;
471     mapping (address => mapping (address => uint256)) private _allowances;
472 
473     mapping (address => bool) private _isExcluded;
474     address[] private _excluded;
475    
476     uint256 private constant MAX = ~uint256(0);
477     uint256 private _tTotal = 20000000000 * 10**9;
478     uint256 private _rTotal = (MAX - (MAX % _tTotal));
479     uint256 private _tFeeTotal;
480     uint256 private _tBurnTotal;
481 
482     string private _name = 'CORGI';
483     string private _symbol = 'CORGI';
484     uint8 private _decimals = 9;
485     
486     uint256 private _taxFee = 1;
487     uint256 private _burnFee = 1;
488     uint256 private _maxTxAmount = 20000000000e9;
489 
490     constructor () public {
491         _rOwned[_msgSender()] = _rTotal;
492         emit Transfer(address(0), _msgSender(), _tTotal);
493     }
494 
495     function name() public view returns (string memory) {
496         return _name;
497     }
498 
499     function symbol() public view returns (string memory) {
500         return _symbol;
501     }
502 
503     function decimals() public view returns (uint8) {
504         return _decimals;
505     }
506 
507     function totalSupply() public view override returns (uint256) {
508         return _tTotal;
509     }
510 
511     function balanceOf(address account) public view override returns (uint256) {
512         if (_isExcluded[account]) return _tOwned[account];
513         return tokenFromReflection(_rOwned[account]);
514     }
515 
516     function transfer(address recipient, uint256 amount) public override returns (bool) {
517         _transfer(_msgSender(), recipient, amount);
518         return true;
519     }
520 
521     function allowance(address owner, address spender) public view override returns (uint256) {
522         return _allowances[owner][spender];
523     }
524 
525     function approve(address spender, uint256 amount) public override returns (bool) {
526         _approve(_msgSender(), spender, amount);
527         return true;
528     }
529 
530     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
531         _transfer(sender, recipient, amount);
532         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
533         return true;
534     }
535 
536     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
537         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
538         return true;
539     }
540 
541     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
542         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
543         return true;
544     }
545 
546     function isExcluded(address account) public view returns (bool) {
547         return _isExcluded[account];
548     }
549 
550     function totalFees() public view returns (uint256) {
551         return _tFeeTotal;
552     }
553     
554     function totalBurn() public view returns (uint256) {
555         return _tBurnTotal;
556     }
557 
558     function deliver(uint256 tAmount) public {
559         address sender = _msgSender();
560         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
561         (uint256 rAmount,,,,,) = _getValues(tAmount);
562         _rOwned[sender] = _rOwned[sender].sub(rAmount);
563         _rTotal = _rTotal.sub(rAmount);
564         _tFeeTotal = _tFeeTotal.add(tAmount);
565     }
566 
567     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
568         require(tAmount <= _tTotal, "Amount must be less than supply");
569         if (!deductTransferFee) {
570             (uint256 rAmount,,,,,) = _getValues(tAmount);
571             return rAmount;
572         } else {
573             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
574             return rTransferAmount;
575         }
576     }
577 
578     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
579         require(rAmount <= _rTotal, "Amount must be less than total reflections");
580         uint256 currentRate =  _getRate();
581         return rAmount.div(currentRate);
582     }
583 
584     function excludeAccount(address account) external onlyOwner() {
585         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
586         require(!_isExcluded[account], "Account is already excluded");
587         if(_rOwned[account] > 0) {
588             _tOwned[account] = tokenFromReflection(_rOwned[account]);
589         }
590         _isExcluded[account] = true;
591         _excluded.push(account);
592     }
593 
594     function includeAccount(address account) external onlyOwner() {
595         require(_isExcluded[account], "Account is already excluded");
596         for (uint256 i = 0; i < _excluded.length; i++) {
597             if (_excluded[i] == account) {
598                 _excluded[i] = _excluded[_excluded.length - 1];
599                 _tOwned[account] = 0;
600                 _isExcluded[account] = false;
601                 _excluded.pop();
602                 break;
603             }
604         }
605     }
606 
607     function _approve(address owner, address spender, uint256 amount) private {
608         require(owner != address(0), "ERC20: approve from the zero address");
609         require(spender != address(0), "ERC20: approve to the zero address");
610 
611         _allowances[owner][spender] = amount;
612         emit Approval(owner, spender, amount);
613     }
614 
615     function _transfer(address sender, address recipient, uint256 amount) private {
616         require(sender != address(0), "ERC20: transfer from the zero address");
617         require(recipient != address(0), "ERC20: transfer to the zero address");
618         require(amount > 0, "Transfer amount must be greater than zero");
619         
620         if(sender != owner() && recipient != owner())
621             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
622         
623         if (_isExcluded[sender] && !_isExcluded[recipient]) {
624             _transferFromExcluded(sender, recipient, amount);
625         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
626             _transferToExcluded(sender, recipient, amount);
627         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
628             _transferStandard(sender, recipient, amount);
629         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
630             _transferBothExcluded(sender, recipient, amount);
631         } else {
632             _transferStandard(sender, recipient, amount);
633         }
634     }
635 
636     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
637         uint256 currentRate =  _getRate();
638         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
639         uint256 rBurn =  tBurn.mul(currentRate);
640         _rOwned[sender] = _rOwned[sender].sub(rAmount);
641         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
642         _reflectFee(rFee, rBurn, tFee, tBurn);
643         emit Transfer(sender, recipient, tTransferAmount);
644     }
645 
646     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
647         uint256 currentRate =  _getRate();
648         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
649         uint256 rBurn =  tBurn.mul(currentRate);
650         _rOwned[sender] = _rOwned[sender].sub(rAmount);
651         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
652         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
653         _reflectFee(rFee, rBurn, tFee, tBurn);
654         emit Transfer(sender, recipient, tTransferAmount);
655     }
656 
657     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
658         uint256 currentRate =  _getRate();
659         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
660         uint256 rBurn =  tBurn.mul(currentRate);
661         _tOwned[sender] = _tOwned[sender].sub(tAmount);
662         _rOwned[sender] = _rOwned[sender].sub(rAmount);
663         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
664         _reflectFee(rFee, rBurn, tFee, tBurn);
665         emit Transfer(sender, recipient, tTransferAmount);
666     }
667 
668     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
669         uint256 currentRate =  _getRate();
670         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
671         uint256 rBurn =  tBurn.mul(currentRate);
672         _tOwned[sender] = _tOwned[sender].sub(tAmount);
673         _rOwned[sender] = _rOwned[sender].sub(rAmount);
674         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
675         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
676         _reflectFee(rFee, rBurn, tFee, tBurn);
677         emit Transfer(sender, recipient, tTransferAmount);
678     }
679 
680     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
681         _rTotal = _rTotal.sub(rFee).sub(rBurn);
682         _tFeeTotal = _tFeeTotal.add(tFee);
683         _tBurnTotal = _tBurnTotal.add(tBurn);
684         _tTotal = _tTotal.sub(tBurn);
685     }
686 
687     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
688         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _taxFee, _burnFee);
689         uint256 currentRate =  _getRate();
690         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
691         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
692     }
693 
694     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
695         uint256 tFee = tAmount.mul(taxFee).div(100);
696         uint256 tBurn = tAmount.mul(burnFee).div(100);
697         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
698         return (tTransferAmount, tFee, tBurn);
699     }
700 
701     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
702         uint256 rAmount = tAmount.mul(currentRate);
703         uint256 rFee = tFee.mul(currentRate);
704         uint256 rBurn = tBurn.mul(currentRate);
705         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
706         return (rAmount, rTransferAmount, rFee);
707     }
708 
709     function _getRate() private view returns(uint256) {
710         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
711         return rSupply.div(tSupply);
712     }
713 
714     function _getCurrentSupply() private view returns(uint256, uint256) {
715         uint256 rSupply = _rTotal;
716         uint256 tSupply = _tTotal;      
717         for (uint256 i = 0; i < _excluded.length; i++) {
718             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
719             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
720             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
721         }
722         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
723         return (rSupply, tSupply);
724     }
725     
726     function _getTaxFee() private view returns(uint256) {
727         return _taxFee;
728     }
729 
730     function _getMaxTxAmount() private view returns(uint256) {
731         return _maxTxAmount;
732     }
733     
734     function _setTaxFee(uint256 taxFee) external onlyOwner() {
735         require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
736         _taxFee = taxFee;
737     }
738     
739     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
740         require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
741         _maxTxAmount = maxTxAmount;
742     }
743 }