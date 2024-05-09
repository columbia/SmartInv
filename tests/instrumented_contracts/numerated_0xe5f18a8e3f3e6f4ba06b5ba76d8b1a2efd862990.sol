1 //DOGE TREATS for your hungry doges 
2 //2% rewards to all, we love you <3 $TREATS
3 //t.me/dogetreatss
4 
5 pragma solidity ^0.6.12;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address payable) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes memory) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
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
89 library SafeMath {
90     /**
91      * @dev Returns the addition of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `+` operator.
95      *
96      * Requirements:
97      *
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a, "SafeMath: addition overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      *
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      *
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         require(b <= a, errorMessage);
133         uint256 c = a - b;
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the multiplication of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `*` operator.
143      *
144      * Requirements:
145      *
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         return div(a, b, "SafeMath: division by zero");
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b > 0, errorMessage);
192         uint256 c = a / b;
193         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
211         return mod(a, b, "SafeMath: modulo by zero");
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts with custom message when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b != 0, errorMessage);
228         return a % b;
229     }
230 }
231 
232 library Address {
233     /**
234      * @dev Returns true if `account` is a contract.
235      *
236      * [IMPORTANT]
237      * ====
238      * It is unsafe to assume that an address for which this function returns
239      * false is an externally-owned account (EOA) and not a contract.
240      *
241      * Among others, `isContract` will return false for the following
242      * types of addresses:
243      *
244      *  - an externally-owned account
245      *  - a contract in construction
246      *  - an address where a contract will be created
247      *  - an address where a contract lived, but was destroyed
248      * ====
249      */
250     function isContract(address account) internal view returns (bool) {
251         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
252         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
253         // for accounts without code, i.e. `keccak256('')`
254         bytes32 codehash;
255         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
256         // solhint-disable-next-line no-inline-assembly
257         assembly { codehash := extcodehash(account) }
258         return (codehash != accountHash && codehash != 0x0);
259     }
260 
261     /**
262      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
263      * `recipient`, forwarding all available gas and reverting on errors.
264      *
265      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
266      * of certain opcodes, possibly making contracts go over the 2300 gas limit
267      * imposed by `transfer`, making them unable to receive funds via
268      * `transfer`. {sendValue} removes this limitation.
269      *
270      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
271      *
272      * IMPORTANT: because control is transferred to `recipient`, care must be
273      * taken to not create reentrancy vulnerabilities. Consider using
274      * {ReentrancyGuard} or the
275      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
276      */
277     function sendValue(address payable recipient, uint256 amount) internal {
278         require(address(this).balance >= amount, "Address: insufficient balance");
279 
280         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
281         (bool success, ) = recipient.call{ value: amount }("");
282         require(success, "Address: unable to send value, recipient may have reverted");
283     }
284 
285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain`call` is an unsafe replacement for a function call: use this
288      * function instead.
289      *
290      * If `target` reverts with a revert reason, it is bubbled up by this
291      * function (like regular Solidity function calls).
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
304       return functionCall(target, data, "Address: low-level call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
309      * `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
314         return _functionCallWithValue(target, data, 0, errorMessage);
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
319      * but also transferring `value` wei to `target`.
320      *
321      * Requirements:
322      *
323      * - the calling contract must have an ETH balance of at least `value`.
324      * - the called Solidity function must be `payable`.
325      *
326      * _Available since v3.1._
327      */
328     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
334      * with `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
339         require(address(this).balance >= value, "Address: insufficient balance for call");
340         return _functionCallWithValue(target, data, value, errorMessage);
341     }
342 
343     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
344         require(isContract(target), "Address: call to non-contract");
345 
346         // solhint-disable-next-line avoid-low-level-calls
347         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
348         if (success) {
349             return returndata;
350         } else {
351             // Look for revert reason and bubble it up if present
352             if (returndata.length > 0) {
353                 // The easiest way to bubble the revert reason is using memory via assembly
354 
355                 // solhint-disable-next-line no-inline-assembly
356                 assembly {
357                     let returndata_size := mload(returndata)
358                     revert(add(32, returndata), returndata_size)
359                 }
360             } else {
361                 revert(errorMessage);
362             }
363         }
364     }
365 }
366 
367 contract Ownable is Context {
368     address private _owner;
369 
370     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
371 
372     /**
373      * @dev Initializes the contract setting the deployer as the initial owner.
374      */
375     constructor () internal {
376         address msgSender = _msgSender();
377         _owner = msgSender;
378         emit OwnershipTransferred(address(0), msgSender);
379     }
380 
381     /**
382      * @dev Returns the address of the current owner.
383      */
384     function owner() public view returns (address) {
385         return _owner;
386     }
387 
388     /**
389      * @dev Throws if called by any account other than the owner.
390      */
391     modifier onlyOwner() {
392         require(_owner == _msgSender(), "Ownable: caller is not the owner");
393         _;
394     }
395 
396     /**
397      * @dev Leaves the contract without owner. It will not be possible to call
398      * `onlyOwner` functions anymore. Can only be called by the current owner.
399      *
400      * NOTE: Renouncing ownership will leave the contract without an owner,
401      * thereby removing any functionality that is only available to the owner.
402      */
403     function renounceOwnership() public virtual onlyOwner {
404         emit OwnershipTransferred(_owner, address(0));
405         _owner = address(0);
406     }
407 
408     /**
409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
410      * Can only be called by the current owner.
411      */
412     function transferOwnership(address newOwner) public virtual onlyOwner {
413         require(newOwner != address(0), "Ownable: new owner is the zero address");
414         emit OwnershipTransferred(_owner, newOwner);
415         _owner = newOwner;
416     }
417 }
418 
419 
420 
421 contract DogeTreats is Context, IERC20, Ownable {
422     using SafeMath for uint256;
423     using Address for address;
424 
425     mapping (address => uint256) private _rOwned;
426     mapping (address => uint256) private _tOwned;
427     mapping (address => mapping (address => uint256)) private _allowances;
428 
429     mapping (address => bool) private _isExcluded;
430     address[] private _excluded;
431    
432     uint256 private constant MAX = ~uint256(0);
433     uint256 private constant _tTotal = 100000000000 * 10**6 * 10**9;
434     uint256 private _rTotal = (MAX - (MAX % _tTotal));
435     uint256 private _tFeeTotal;
436 
437     string private _name = 'Doge Treats';
438     string private _symbol = '🍖TREATS🦴';
439     uint8 private _decimals = 9;
440 
441     constructor () public {
442         _rOwned[_msgSender()] = _rTotal;
443         emit Transfer(address(0), _msgSender(), _tTotal);
444     }
445 
446     function name() public view returns (string memory) {
447         return _name;
448     }
449 
450     function symbol() public view returns (string memory) {
451         return _symbol;
452     }
453 
454     function decimals() public view returns (uint8) {
455         return _decimals;
456     }
457 
458     function totalSupply() public view override returns (uint256) {
459         return _tTotal;
460     }
461 
462     function balanceOf(address account) public view override returns (uint256) {
463         if (_isExcluded[account]) return _tOwned[account];
464         return tokenFromReflection(_rOwned[account]);
465     }
466 
467     function transfer(address recipient, uint256 amount) public override returns (bool) {
468         _transfer(_msgSender(), recipient, amount);
469         return true;
470     }
471 
472     function allowance(address owner, address spender) public view override returns (uint256) {
473         return _allowances[owner][spender];
474     }
475 
476     function approve(address spender, uint256 amount) public override returns (bool) {
477         _approve(_msgSender(), spender, amount);
478         return true;
479     }
480 
481     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
482         _transfer(sender, recipient, amount);
483         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
484         return true;
485     }
486 
487     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
488         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
489         return true;
490     }
491 
492     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
493         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
494         return true;
495     }
496 
497     function isExcluded(address account) public view returns (bool) {
498         return _isExcluded[account];
499     }
500 
501     function totalFees() public view returns (uint256) {
502         return _tFeeTotal;
503     }
504 
505     function reflect(uint256 tAmount) public {
506         address sender = _msgSender();
507         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
508         (uint256 rAmount,,,,) = _getValues(tAmount);
509         _rOwned[sender] = _rOwned[sender].sub(rAmount);
510         _rTotal = _rTotal.sub(rAmount);
511         _tFeeTotal = _tFeeTotal.add(tAmount);
512     }
513 
514     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
515         require(tAmount <= _tTotal, "Amount must be less than supply");
516         if (!deductTransferFee) {
517             (uint256 rAmount,,,,) = _getValues(tAmount);
518             return rAmount;
519         } else {
520             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
521             return rTransferAmount;
522         }
523     }
524 
525     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
526         require(rAmount <= _rTotal, "Amount must be less than total reflections");
527         uint256 currentRate =  _getRate();
528         return rAmount.div(currentRate);
529     }
530 
531     function excludeAccount(address account) external onlyOwner() {
532         require(!_isExcluded[account], "Account is already excluded");
533         if(_rOwned[account] > 0) {
534             _tOwned[account] = tokenFromReflection(_rOwned[account]);
535         }
536         _isExcluded[account] = true;
537         _excluded.push(account);
538     }
539 
540     function includeAccount(address account) external onlyOwner() {
541         require(_isExcluded[account], "Account is already excluded");
542         for (uint256 i = 0; i < _excluded.length; i++) {
543             if (_excluded[i] == account) {
544                 _excluded[i] = _excluded[_excluded.length - 1];
545                 _tOwned[account] = 0;
546                 _isExcluded[account] = false;
547                 _excluded.pop();
548                 break;
549             }
550         }
551     }
552 
553     function _approve(address owner, address spender, uint256 amount) private {
554         require(owner != address(0), "ERC20: approve from the zero address");
555         require(spender != address(0), "ERC20: approve to the zero address");
556 
557         _allowances[owner][spender] = amount;
558         emit Approval(owner, spender, amount);
559     }
560 
561     function _transfer(address sender, address recipient, uint256 amount) private {
562         require(sender != address(0), "ERC20: transfer from the zero address");
563         require(recipient != address(0), "ERC20: transfer to the zero address");
564         require(amount > 0, "Transfer amount must be greater than zero");
565         if (_isExcluded[sender] && !_isExcluded[recipient]) {
566             _transferFromExcluded(sender, recipient, amount);
567         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
568             _transferToExcluded(sender, recipient, amount);
569         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
570             _transferStandard(sender, recipient, amount);
571         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
572             _transferBothExcluded(sender, recipient, amount);
573         } else {
574             _transferStandard(sender, recipient, amount);
575         }
576     }
577 
578     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
579         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
580         _rOwned[sender] = _rOwned[sender].sub(rAmount);
581         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
582         _reflectFee(rFee, tFee);
583         emit Transfer(sender, recipient, tTransferAmount);
584     }
585 
586     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
587         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
588         _rOwned[sender] = _rOwned[sender].sub(rAmount);
589         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
590         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
591         _reflectFee(rFee, tFee);
592         emit Transfer(sender, recipient, tTransferAmount);
593     }
594 
595     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
596         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
597         _tOwned[sender] = _tOwned[sender].sub(tAmount);
598         _rOwned[sender] = _rOwned[sender].sub(rAmount);
599         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
600         _reflectFee(rFee, tFee);
601         emit Transfer(sender, recipient, tTransferAmount);
602     }
603 
604     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
605         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
606         _tOwned[sender] = _tOwned[sender].sub(tAmount);
607         _rOwned[sender] = _rOwned[sender].sub(rAmount);
608         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
609         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
610         _reflectFee(rFee, tFee);
611         emit Transfer(sender, recipient, tTransferAmount);
612     }
613 
614     function _reflectFee(uint256 rFee, uint256 tFee) private {
615         _rTotal = _rTotal.sub(rFee);
616         _tFeeTotal = _tFeeTotal.add(tFee);
617     }
618 
619     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
620         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
621         uint256 currentRate =  _getRate();
622         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
623         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
624     }
625 
626     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
627         uint256 tFee = tAmount.div(100).mul(2);
628         uint256 tTransferAmount = tAmount.sub(tFee);
629         return (tTransferAmount, tFee);
630     }
631 
632     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
633         uint256 rAmount = tAmount.mul(currentRate);
634         uint256 rFee = tFee.mul(currentRate);
635         uint256 rTransferAmount = rAmount.sub(rFee);
636         return (rAmount, rTransferAmount, rFee);
637     }
638 
639     function _getRate() private view returns(uint256) {
640         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
641         return rSupply.div(tSupply);
642     }
643 
644     function _getCurrentSupply() private view returns(uint256, uint256) {
645         uint256 rSupply = _rTotal;
646         uint256 tSupply = _tTotal;      
647         for (uint256 i = 0; i < _excluded.length; i++) {
648             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
649             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
650             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
651         }
652         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
653         return (rSupply, tSupply);
654     }
655 }