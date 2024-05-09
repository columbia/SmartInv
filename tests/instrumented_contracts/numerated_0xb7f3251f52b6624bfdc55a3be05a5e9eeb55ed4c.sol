1 // Shiba Cookies (SHOOKIES) mmmmhhh 
2 
3 //CMC and CG application done. 
4 
5 //Marketing paid.
6 
7 //Limit Buy yes
8 
9 //Liqudity Locked
10 
11 //TG: https://t.me/shibacookies1
12 
13 //Website: TBA
14 
15 pragma solidity ^0.6.12;    
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
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
42      * Returns a boolean value indicating whether the operation succeeded.s
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
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
262         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
263         // for accounts without code, i.e. `keccak256('')`
264         bytes32 codehash;
265         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
266         // solhint-disable-next-line no-inline-assembly
267         assembly { codehash := extcodehash(account) }
268         return (codehash != accountHash && codehash != 0x0);
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
291         (bool success, ) = recipient.call{ value: amount }("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain`call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314       return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
324         return _functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
344      * with `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
349         require(address(this).balance >= value, "Address: insufficient balance for call");
350         return _functionCallWithValue(target, data, value, errorMessage);
351     }
352 
353     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
354         require(isContract(target), "Address: call to non-contract");
355 
356         // solhint-disable-next-line avoid-low-level-calls
357         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
358         if (success) {
359             return returndata;
360         } else {
361             // Look for revert reason and bubble it up if present
362             if (returndata.length > 0) {
363                 // The easiest way to bubble the revert reason is using memory via assembly
364 
365                 // solhint-disable-next-line no-inline-assembly
366                 assembly {
367                     let returndata_size := mload(returndata)
368                     revert(add(32, returndata), returndata_size)
369                 }
370             } else {
371                 revert(errorMessage);
372             }
373         }
374     }
375 }
376 
377 contract Ownable is Context {
378     address private _owner;
379 
380     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
381 
382     /**
383      * @dev Initializes the contract setting the deployer as the initial owner.
384      */
385     constructor () internal {
386         address msgSender = _msgSender();
387         _owner = msgSender;
388         emit OwnershipTransferred(address(0), msgSender);
389     }
390 
391     /**
392      * @dev Returns the address of the current owner.
393      */
394     function owner() public view returns (address) {
395         return _owner;
396     }
397 
398     /**
399      * @dev Throws if called by any account other than the owner.
400      */
401     modifier onlyOwner() {
402         require(_owner == _msgSender(), "Ownable: caller is not the owner");
403         _;
404     }
405 
406     /**
407      * @dev Leaves the contract without owner. It will not be possible to call
408      * `onlyOwner` functions anymore. Can only be called by the current owner.
409      *
410      * NOTE: Renouncing ownership will leave the contract without an owner,
411      * thereby removing any functionality that is only available to the owner.
412      */
413     function renounceOwnership() public virtual onlyOwner {
414         emit OwnershipTransferred(_owner, address(0));
415         _owner = address(0);
416     }
417 
418     /**
419      * @dev Transfers ownership of the contract to a new account (`newOwner`).
420      * Can only be called by the current owner.
421      */
422     function transferOwnership(address newOwner) public virtual onlyOwner {
423         require(newOwner != address(0), "Ownable: new owner is the zero address");
424         emit OwnershipTransferred(_owner, newOwner);
425         _owner = newOwner;
426     }
427 }
428 
429 
430 
431 contract ShibaCookies is Context, IERC20, Ownable {
432     using SafeMath for uint256;
433     using Address for address;
434 
435     mapping (address => uint256) private _rOwned;
436     mapping (address => uint256) private _tOwned;
437     mapping (address => mapping (address => uint256)) private _allowances;
438 
439     mapping (address => bool) private _isExcluded;
440     address[] private _excluded;
441    
442     uint256 private constant MAX = ~uint256(0);
443     uint256 private constant _tTotal = 10000000 * 10**5 * 10**9;
444     uint256 private _rTotal = (MAX - (MAX % _tTotal));
445     uint256 private _tFeeTotal;
446 
447     string private _name = 'Shiba Cookies';
448     string private _symbol = 'SHOOKIES 🍪';
449     uint8 private _decimals = 9;
450     
451     uint256 public _maxTxAmount = 10000000 * 10**5 * 10**9;
452 
453     constructor () public {
454         _rOwned[_msgSender()] = _rTotal;
455         emit Transfer(address(0), _msgSender(), _tTotal);
456     }
457 
458     function name() public view returns (string memory) {
459         return _name;
460     }
461 
462     function symbol() public view returns (string memory) {
463         return _symbol;
464     }
465 
466     function decimals() public view returns (uint8) {
467         return _decimals;
468     }
469 
470     function totalSupply() public view override returns (uint256) {
471         return _tTotal;
472     }
473 
474     function balanceOf(address account) public view override returns (uint256) {
475         if (_isExcluded[account]) return _tOwned[account];
476         return tokenFromReflection(_rOwned[account]);
477     }
478 
479     function transfer(address recipient, uint256 amount) public override returns (bool) {
480         _transfer(_msgSender(), recipient, amount);
481         return true;
482     }
483 
484     function allowance(address owner, address spender) public view override returns (uint256) {
485         return _allowances[owner][spender];
486     }
487 
488     function approve(address spender, uint256 amount) public override returns (bool) {
489         _approve(_msgSender(), spender, amount);
490         return true;
491     }
492 
493     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
494         _transfer(sender, recipient, amount);
495         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
496         return true;
497     }
498 
499     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
500         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
501         return true;
502     }
503 
504     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
505         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
506         return true;
507     }
508 
509     function isExcluded(address account) public view returns (bool) {
510         return _isExcluded[account];
511     }
512 
513     function totalFees() public view returns (uint256) {
514         return _tFeeTotal;
515     }
516     
517     
518     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
519         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
520             10**2
521         );
522     }
523 
524     function reflect(uint256 tAmount) public {
525         address sender = _msgSender();
526         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
527         (uint256 rAmount,,,,) = _getValues(tAmount);
528         _rOwned[sender] = _rOwned[sender].sub(rAmount);
529         _rTotal = _rTotal.sub(rAmount);
530         _tFeeTotal = _tFeeTotal.add(tAmount);
531     }
532 
533     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
534         require(tAmount <= _tTotal, "Amount must be less than supply");
535         if (!deductTransferFee) {
536             (uint256 rAmount,,,,) = _getValues(tAmount);
537             return rAmount;
538         } else {
539             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
540             return rTransferAmount;
541         }
542     }
543 
544     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
545         require(rAmount <= _rTotal, "Amount must be less than total reflections");
546         uint256 currentRate =  _getRate();
547         return rAmount.div(currentRate);
548     }
549 
550     function excludeAccount(address account) external onlyOwner() {
551         require(!_isExcluded[account], "Account is already excluded");
552         if(_rOwned[account] > 0) {
553             _tOwned[account] = tokenFromReflection(_rOwned[account]);
554         }
555         _isExcluded[account] = true;
556         _excluded.push(account);
557     }
558 
559     function includeAccount(address account) external onlyOwner() {
560         require(_isExcluded[account], "Account is already excluded");
561         for (uint256 i = 0; i < _excluded.length; i++) {
562             if (_excluded[i] == account) {
563                 _excluded[i] = _excluded[_excluded.length - 1];
564                 _tOwned[account] = 0;
565                 _isExcluded[account] = false;
566                 _excluded.pop();
567                 break;
568             }
569         }
570     }
571 
572     function _approve(address owner, address spender, uint256 amount) private {
573         require(owner != address(0), "ERC20: approve from the zero address");
574         require(spender != address(0), "ERC20: approve to the zero address");
575 
576         _allowances[owner][spender] = amount;
577         emit Approval(owner, spender, amount);
578     }
579 
580     function _transfer(address sender, address recipient, uint256 amount) private {
581         require(sender != address(0), "ERC20: transfer from the zero address");
582         require(recipient != address(0), "ERC20: transfer to the zero address");
583         require(amount > 0, "Transfer amount must be greater than zero");
584         if(sender != owner() && recipient != owner())
585           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
586             
587         if (_isExcluded[sender] && !_isExcluded[recipient]) {
588             _transferFromExcluded(sender, recipient, amount);
589         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
590             _transferToExcluded(sender, recipient, amount);
591         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
592             _transferStandard(sender, recipient, amount);
593         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
594             _transferBothExcluded(sender, recipient, amount);
595         } else {
596             _transferStandard(sender, recipient, amount);
597         }
598     }
599 
600     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
601         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
602         _rOwned[sender] = _rOwned[sender].sub(rAmount);
603         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
604         _reflectFee(rFee, tFee);
605         emit Transfer(sender, recipient, tTransferAmount);
606     }
607 
608     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
609         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
610         _rOwned[sender] = _rOwned[sender].sub(rAmount);
611         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
612         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
613         _reflectFee(rFee, tFee);
614         emit Transfer(sender, recipient, tTransferAmount);
615     }
616 
617     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
618         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
619         _tOwned[sender] = _tOwned[sender].sub(tAmount);
620         _rOwned[sender] = _rOwned[sender].sub(rAmount);
621         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
622         _reflectFee(rFee, tFee);
623         emit Transfer(sender, recipient, tTransferAmount);
624     }
625 
626     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
627         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
628         _tOwned[sender] = _tOwned[sender].sub(tAmount);
629         _rOwned[sender] = _rOwned[sender].sub(rAmount);
630         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
631         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
632         _reflectFee(rFee, tFee);
633         emit Transfer(sender, recipient, tTransferAmount);
634     }
635 
636     function _reflectFee(uint256 rFee, uint256 tFee) private {
637         _rTotal = _rTotal.sub(rFee);
638         _tFeeTotal = _tFeeTotal.add(tFee);
639     }
640 
641     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
642         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
643         uint256 currentRate =  _getRate();
644         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
645         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
646     }
647 
648     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
649         uint256 tFee = tAmount.div(100).mul(2);
650         uint256 tTransferAmount = tAmount.sub(tFee);
651         return (tTransferAmount, tFee);
652     }
653 
654     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
655         uint256 rAmount = tAmount.mul(currentRate);
656         uint256 rFee = tFee.mul(currentRate);
657         uint256 rTransferAmount = rAmount.sub(rFee);
658         return (rAmount, rTransferAmount, rFee);
659     }
660 
661     function _getRate() private view returns(uint256) {
662         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
663         return rSupply.div(tSupply);
664     }
665 
666     function _getCurrentSupply() private view returns(uint256, uint256) {
667         uint256 rSupply = _rTotal;
668         uint256 tSupply = _tTotal;      
669         for (uint256 i = 0; i < _excluded.length; i++) {
670             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
671             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
672             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
673         }
674         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
675         return (rSupply, tSupply);
676     }
677 }