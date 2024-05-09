1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-07
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-02-07
7 */
8 
9 // Nobu Inu (NOBU)
10 // Nobu is a deflationary meme token on the ethereum network
11 
12 
13 // SPDX-License-Identifier: Unlicensed
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
431 contract NobuInu is Context, IERC20, Ownable {
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
443     uint256 private constant _tTotal = 1000 * 10**6 * 10**9;
444     uint256 private _rTotal = (MAX - (MAX % _tTotal));
445     uint256 private _tFeeTotal;
446 
447     string private _name = 'Nobu Inu';
448     string private _symbol = 'NOBU';
449     uint8 private _decimals = 9;
450 
451     constructor () public {
452         _rOwned[_msgSender()] = _rTotal;
453         emit Transfer(address(0), _msgSender(), _tTotal);
454     }
455 
456     function name() public view returns (string memory) {
457         return _name;
458     }
459 
460     function symbol() public view returns (string memory) {
461         return _symbol;
462     }
463 
464     function decimals() public view returns (uint8) {
465         return _decimals;
466     }
467 
468     function totalSupply() public view override returns (uint256) {
469         return _tTotal;
470     }
471 
472     function balanceOf(address account) public view override returns (uint256) {
473         if (_isExcluded[account]) return _tOwned[account];
474         return tokenFromReflection(_rOwned[account]);
475     }
476 
477     function transfer(address recipient, uint256 amount) public override returns (bool) {
478         _transfer(_msgSender(), recipient, amount);
479         return true;
480     }
481 
482     function allowance(address owner, address spender) public view override returns (uint256) {
483         return _allowances[owner][spender];
484     }
485 
486     function approve(address spender, uint256 amount) public override returns (bool) {
487         _approve(_msgSender(), spender, amount);
488         return true;
489     }
490 
491     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
492         _transfer(sender, recipient, amount);
493         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
494         return true;
495     }
496 
497     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
498         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
499         return true;
500     }
501 
502     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
503         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
504         return true;
505     }
506 
507     function isExcluded(address account) public view returns (bool) {
508         return _isExcluded[account];
509     }
510 
511     function totalFees() public view returns (uint256) {
512         return _tFeeTotal;
513     }
514 
515     function reflect(uint256 tAmount) public {
516         address sender = _msgSender();
517         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
518         (uint256 rAmount,,,,) = _getValues(tAmount);
519         _rOwned[sender] = _rOwned[sender].sub(rAmount);
520         _rTotal = _rTotal.sub(rAmount);
521         _tFeeTotal = _tFeeTotal.add(tAmount);
522     }
523 
524     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
525         require(tAmount <= _tTotal, "Amount must be less than supply");
526         if (!deductTransferFee) {
527             (uint256 rAmount,,,,) = _getValues(tAmount);
528             return rAmount;
529         } else {
530             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
531             return rTransferAmount;
532         }
533     }
534 
535     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
536         require(rAmount <= _rTotal, "Amount must be less than total reflections");
537         uint256 currentRate =  _getRate();
538         return rAmount.div(currentRate);
539     }
540 
541     function excludeAccount(address account) external onlyOwner() {
542         require(!_isExcluded[account], "Account is already excluded");
543         if(_rOwned[account] > 0) {
544             _tOwned[account] = tokenFromReflection(_rOwned[account]);
545         }
546         _isExcluded[account] = true;
547         _excluded.push(account);
548     }
549 
550     function includeAccount(address account) external onlyOwner() {
551         require(_isExcluded[account], "Account is already excluded");
552         for (uint256 i = 0; i < _excluded.length; i++) {
553             if (_excluded[i] == account) {
554                 _excluded[i] = _excluded[_excluded.length - 1];
555                 _tOwned[account] = 0;
556                 _isExcluded[account] = false;
557                 _excluded.pop();
558                 break;
559             }
560         }
561     }
562 
563     function _approve(address owner, address spender, uint256 amount) private {
564         require(owner != address(0), "ERC20: approve from the zero address");
565         require(spender != address(0), "ERC20: approve to the zero address");
566 
567         _allowances[owner][spender] = amount;
568         emit Approval(owner, spender, amount);
569     }
570 
571     function _transfer(address sender, address recipient, uint256 amount) private {
572         require(sender != address(0), "ERC20: transfer from the zero address");
573         require(recipient != address(0), "ERC20: transfer to the zero address");
574         require(amount > 0, "Transfer amount must be greater than zero");
575         if (_isExcluded[sender] && !_isExcluded[recipient]) {
576             _transferFromExcluded(sender, recipient, amount);
577         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
578             _transferToExcluded(sender, recipient, amount);
579         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
580             _transferStandard(sender, recipient, amount);
581         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
582             _transferBothExcluded(sender, recipient, amount);
583         } else {
584             _transferStandard(sender, recipient, amount);
585         }
586     }
587 
588     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
589         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
590         _rOwned[sender] = _rOwned[sender].sub(rAmount);
591         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
592         _reflectFee(rFee, tFee);
593         emit Transfer(sender, recipient, tTransferAmount);
594     }
595 
596     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
597         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
598         _rOwned[sender] = _rOwned[sender].sub(rAmount);
599         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
600         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
601         _reflectFee(rFee, tFee);
602         emit Transfer(sender, recipient, tTransferAmount);
603     }
604 
605     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
606         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
607         _tOwned[sender] = _tOwned[sender].sub(tAmount);
608         _rOwned[sender] = _rOwned[sender].sub(rAmount);
609         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
610         _reflectFee(rFee, tFee);
611         emit Transfer(sender, recipient, tTransferAmount);
612     }
613 
614     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
615         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
616         _tOwned[sender] = _tOwned[sender].sub(tAmount);
617         _rOwned[sender] = _rOwned[sender].sub(rAmount);
618         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
619         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
620         _reflectFee(rFee, tFee);
621         emit Transfer(sender, recipient, tTransferAmount);
622     }
623 
624     function _reflectFee(uint256 rFee, uint256 tFee) private {
625         _rTotal = _rTotal.sub(rFee);
626         _tFeeTotal = _tFeeTotal.add(tFee);
627     }
628 
629     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
630         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
631         uint256 currentRate =  _getRate();
632         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
633         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
634     }
635 
636     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
637         uint256 tFee = tAmount.div(100).mul(4);
638         uint256 tTransferAmount = tAmount.sub(tFee);
639         return (tTransferAmount, tFee);
640     }
641 
642     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
643         uint256 rAmount = tAmount.mul(currentRate);
644         uint256 rFee = tFee.mul(currentRate);
645         uint256 rTransferAmount = rAmount.sub(rFee);
646         return (rAmount, rTransferAmount, rFee);
647     }
648 
649     function _getRate() private view returns(uint256) {
650         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
651         return rSupply.div(tSupply);
652     }
653 
654     function _getCurrentSupply() private view returns(uint256, uint256) {
655         uint256 rSupply = _rTotal;
656         uint256 tSupply = _tTotal;      
657         for (uint256 i = 0; i < _excluded.length; i++) {
658             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
659             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
660             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
661         }
662         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
663         return (rSupply, tSupply);
664     }
665 }