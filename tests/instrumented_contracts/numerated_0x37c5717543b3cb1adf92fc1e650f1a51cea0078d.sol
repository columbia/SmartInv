1 /*   
2    _____            __                 _________.__    ._____.           
3   /  _  \   _______/  |________  ____ /   _____/|  |__ |__\_ |__ _____   
4  /  /_\  \ /  ___/\   __\_  __ \/  _ \\_____  \ |  |  \|  || __ \\__  \  
5 /    |    \\___ \  |  |  |  | \(  <_> )        \|   Y  \  || \_\ \/ __ \_
6 \____|__  /____  > |__|  |__|   \____/_______  /|___|  /__||___  (____  /
7         \/     \/                            \/      \/        \/     \/ 
8 */
9 
10 
11 //Website: https://astroshiba.space/
12 //Twitter: https://twitter.com/AstroShiba1
13 //Telegram: https://t.me/astroshibatoken
14 
15 
16 // SPDX-License-Identifier: Unlicensed
17 
18 pragma solidity ^0.6.12;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
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
163         // benefit is lost if 'b' is also tested.
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
245 library Address {
246     /**
247      * @dev Returns true if `account` is a contract.
248      *
249      * [IMPORTANT]
250      * ====
251      * It is unsafe to assume that an address for which this function returns
252      * false is an externally-owned account (EOA) and not a contract.
253      *
254      * Among others, `isContract` will return false for the following
255      * types of addresses:
256      *
257      *  - an externally-owned account
258      *  - a contract in construction
259      *  - an address where a contract will be created
260      *  - an address where a contract lived, but was destroyed
261      * ====
262      */
263     function isContract(address account) internal view returns (bool) {
264         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
265         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
266         // for accounts without code, i.e. `keccak256('')`
267         bytes32 codehash;
268         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
269         // solhint-disable-next-line no-inline-assembly
270         assembly { codehash := extcodehash(account) }
271         return (codehash != accountHash && codehash != 0x0);
272     }
273 
274     /**
275      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
276      * `recipient`, forwarding all available gas and reverting on errors.
277      *
278      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
279      * of certain opcodes, possibly making contracts go over the 2300 gas limit
280      * imposed by `transfer`, making them unable to receive funds via
281      * `transfer`. {sendValue} removes this limitation.
282      *
283      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
284      *
285      * IMPORTANT: because control is transferred to `recipient`, care must be
286      * taken to not create reentrancy vulnerabilities. Consider using
287      * {ReentrancyGuard} or the
288      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
289      */
290     function sendValue(address payable recipient, uint256 amount) internal {
291         require(address(this).balance >= amount, "Address: insufficient balance");
292 
293         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
294         (bool success, ) = recipient.call{ value: amount }("");
295         require(success, "Address: unable to send value, recipient may have reverted");
296     }
297 
298     /**
299      * @dev Performs a Solidity function call using a low level `call`. A
300      * plain`call` is an unsafe replacement for a function call: use this
301      * function instead.
302      *
303      * If `target` reverts with a revert reason, it is bubbled up by this
304      * function (like regular Solidity function calls).
305      *
306      * Returns the raw returned data. To convert to the expected return value,
307      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
308      *
309      * Requirements:
310      *
311      * - `target` must be a contract.
312      * - calling `target` with `data` must not revert.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
317       return functionCall(target, data, "Address: low-level call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
322      * `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
327         return _functionCallWithValue(target, data, 0, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but also transferring `value` wei to `target`.
333      *
334      * Requirements:
335      *
336      * - the calling contract must have an ETH balance of at least `value`.
337      * - the called Solidity function must be `payable`.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347      * with `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         return _functionCallWithValue(target, data, value, errorMessage);
354     }
355 
356     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
357         require(isContract(target), "Address: call to non-contract");
358 
359         // solhint-disable-next-line avoid-low-level-calls
360         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
361         if (success) {
362             return returndata;
363         } else {
364             // Look for revert reason and bubble it up if present
365             if (returndata.length > 0) {
366                 // The easiest way to bubble the revert reason is using memory via assembly
367 
368                 // solhint-disable-next-line no-inline-assembly
369                 assembly {
370                     let returndata_size := mload(returndata)
371                     revert(add(32, returndata), returndata_size)
372                 }
373             } else {
374                 revert(errorMessage);
375             }
376         }
377     }
378 }
379 
380 contract Ownable is Context {
381     address private _owner;
382 
383     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
384 
385     /**
386      * @dev Initializes the contract setting the deployer as the initial owner.
387      */
388     constructor () internal {
389         address msgSender = _msgSender();
390         _owner = msgSender;
391         emit OwnershipTransferred(address(0), msgSender);
392     }
393 
394     /**
395      * @dev Returns the address of the current owner.
396      */
397     function owner() public view returns (address) {
398         return _owner;
399     }
400 
401     /**
402      * @dev Throws if called by any account other than the owner.
403      */
404     modifier onlyOwner() {
405         require(_owner == _msgSender(), "Ownable: caller is not the owner");
406         _;
407     }
408 
409     /**
410      * @dev Leaves the contract without owner. It will not be possible to call
411      * `onlyOwner` functions anymore. Can only be called by the current owner.
412      *
413      * NOTE: Renouncing ownership will leave the contract without an owner,
414      * thereby removing any functionality that is only available to the owner.
415      */
416     function renounceOwnership() public virtual onlyOwner {
417         emit OwnershipTransferred(_owner, address(0));
418         _owner = address(0);
419     }
420 
421     /**
422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
423      * Can only be called by the current owner.
424      */
425     function transferOwnership(address newOwner) public virtual onlyOwner {
426         require(newOwner != address(0), "Ownable: new owner is the zero address");
427         emit OwnershipTransferred(_owner, newOwner);
428         _owner = newOwner;
429     }
430 }
431 
432 
433 
434 contract AstroShiba is Context, IERC20, Ownable {
435     using SafeMath for uint256;
436     using Address for address;
437 
438     mapping (address => uint256) private _rOwned;
439     mapping (address => uint256) private _tOwned;
440     mapping (address => mapping (address => uint256)) private _allowances;
441 
442     mapping (address => bool) private _isExcluded;
443     address[] private _excluded;
444    
445     uint256 private constant MAX = ~uint256(0);
446     uint256 private constant _tTotal = 1000000000000 * 10**9;
447     uint256 private _rTotal = (MAX - (MAX % _tTotal));
448     uint256 private _tFeeTotal;
449 
450     string private _name = 'AstroShiba';
451     string private _symbol = 'ASHIB';
452     uint8 private _decimals = 9;
453     
454     uint256 public _maxTxAmount = 20000000000 * 10**9;
455 
456     constructor () public {
457         _rOwned[_msgSender()] = _rTotal;
458         emit Transfer(address(0), _msgSender(), _tTotal);
459     }
460 
461     function name() public view returns (string memory) {
462         return _name;
463     }
464 
465     function symbol() public view returns (string memory) {
466         return _symbol;
467     }
468 
469     function decimals() public view returns (uint8) {
470         return _decimals;
471     }
472 
473     function totalSupply() public view override returns (uint256) {
474         return _tTotal;
475     }
476 
477     function balanceOf(address account) public view override returns (uint256) {
478         if (_isExcluded[account]) return _tOwned[account];
479         return tokenFromReflection(_rOwned[account]);
480     }
481 
482     function transfer(address recipient, uint256 amount) public override returns (bool) {
483         _transfer(_msgSender(), recipient, amount);
484         return true;
485     }
486 
487     function allowance(address owner, address spender) public view override returns (uint256) {
488         return _allowances[owner][spender];
489     }
490 
491     function approve(address spender, uint256 amount) public override returns (bool) {
492         _approve(_msgSender(), spender, amount);
493         return true;
494     }
495 
496     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
497         _transfer(sender, recipient, amount);
498         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
499         return true;
500     }
501 
502     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
503         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
504         return true;
505     }
506 
507     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
508         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
509         return true;
510     }
511 
512     function isExcluded(address account) public view returns (bool) {
513         return _isExcluded[account];
514     }
515 
516     function totalFees() public view returns (uint256) {
517         return _tFeeTotal;
518     }
519     
520     function reflect(uint256 tAmount) public {
521         address sender = _msgSender();
522         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
523         (uint256 rAmount,,,,) = _getValues(tAmount);
524         _rOwned[sender] = _rOwned[sender].sub(rAmount);
525         _rTotal = _rTotal.sub(rAmount);
526         _tFeeTotal = _tFeeTotal.add(tAmount);
527     }
528 
529     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
530         require(tAmount <= _tTotal, "Amount must be less than supply");
531         if (!deductTransferFee) {
532             (uint256 rAmount,,,,) = _getValues(tAmount);
533             return rAmount;
534         } else {
535             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
536             return rTransferAmount;
537         }
538     }
539 
540     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
541         require(rAmount <= _rTotal, "Amount must be less than total reflections");
542         uint256 currentRate =  _getRate();
543         return rAmount.div(currentRate);
544     }
545 
546     function _approve(address owner, address spender, uint256 amount) private {
547         require(owner != address(0), "ERC20: approve from the zero address");
548         require(spender != address(0), "ERC20: approve to the zero address");
549 
550         _allowances[owner][spender] = amount;
551         emit Approval(owner, spender, amount);
552     }
553 
554     function _transfer(address sender, address recipient, uint256 amount) private {
555         require(sender != address(0), "ERC20: transfer from the zero address");
556         require(recipient != address(0), "ERC20: transfer to the zero address");
557         require(amount > 0, "Transfer amount must be greater than zero");
558         if(sender != owner() && recipient != owner())
559           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
560             
561         if (_isExcluded[sender] && !_isExcluded[recipient]) {
562             _transferFromExcluded(sender, recipient, amount);
563         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
564             _transferToExcluded(sender, recipient, amount);
565         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
566             _transferStandard(sender, recipient, amount);
567         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
568             _transferBothExcluded(sender, recipient, amount);
569         } else {
570             _transferStandard(sender, recipient, amount);
571         }
572     }
573 
574     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
575         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
576         _rOwned[sender] = _rOwned[sender].sub(rAmount);
577         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
578         _reflectFee(rFee, tFee);
579         emit Transfer(sender, recipient, tTransferAmount);
580     }
581 
582     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
583         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
584         _rOwned[sender] = _rOwned[sender].sub(rAmount);
585         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
586         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
587         _reflectFee(rFee, tFee);
588         emit Transfer(sender, recipient, tTransferAmount);
589     }
590 
591     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
592         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
593         _tOwned[sender] = _tOwned[sender].sub(tAmount);
594         _rOwned[sender] = _rOwned[sender].sub(rAmount);
595         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
596         _reflectFee(rFee, tFee);
597         emit Transfer(sender, recipient, tTransferAmount);
598     }
599 
600     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
601         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
602         _tOwned[sender] = _tOwned[sender].sub(tAmount);
603         _rOwned[sender] = _rOwned[sender].sub(rAmount);
604         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
605         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
606         _reflectFee(rFee, tFee);
607         emit Transfer(sender, recipient, tTransferAmount);
608     }
609 
610     function _reflectFee(uint256 rFee, uint256 tFee) private {
611         _rTotal = _rTotal.sub(rFee);
612         _tFeeTotal = _tFeeTotal.add(tFee);
613     }
614 
615     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
616         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
617         uint256 currentRate =  _getRate();
618         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
619         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
620     }
621 
622     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
623         uint256 tFee = tAmount.div(100).mul(2);
624         uint256 tTransferAmount = tAmount.sub(tFee);
625         return (tTransferAmount, tFee);
626     }
627 
628     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
629         uint256 rAmount = tAmount.mul(currentRate);
630         uint256 rFee = tFee.mul(currentRate);
631         uint256 rTransferAmount = rAmount.sub(rFee);
632         return (rAmount, rTransferAmount, rFee);
633     }
634 
635     function _getRate() private view returns(uint256) {
636         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
637         return rSupply.div(tSupply);
638     }
639 
640     function _getCurrentSupply() private view returns(uint256, uint256) {
641         uint256 rSupply = _rTotal;
642         uint256 tSupply = _tTotal;      
643         for (uint256 i = 0; i < _excluded.length; i++) {
644             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
645             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
646             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
647         }
648         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
649         return (rSupply, tSupply);
650     }
651 }