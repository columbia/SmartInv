1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-17
3 */
4 
5 // marko.finance (MARKO)
6 // MARKO is a deflationary meme farming token with community fund.
7 // It's HOGE with boost.
8 
9 // SPDX-License-Identifier: Unlicensed
10 
11 pragma solidity ^0.6.12;
12 
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
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      *
104      * - Addition cannot overflow.
105      */
106     function add(uint256 a, uint256 b) internal pure returns (uint256) {
107         uint256 c = a + b;
108         require(c >= a, "SafeMath: addition overflow");
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      *
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
138         require(b <= a, errorMessage);
139         uint256 c = a - b;
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the multiplication of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `*` operator.
149      *
150      * Requirements:
151      *
152      * - Multiplication cannot overflow.
153      */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint256 c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      *
178      * - The divisor cannot be zero.
179      */
180     function div(uint256 a, uint256 b) internal pure returns (uint256) {
181         return div(a, b, "SafeMath: division by zero");
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b > 0, errorMessage);
198         uint256 c = a / b;
199         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * Reverts when dividing by zero.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return mod(a, b, "SafeMath: modulo by zero");
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts with custom message when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b != 0, errorMessage);
234         return a % b;
235     }
236 }
237 
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
258         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
259         // for accounts without code, i.e. `keccak256('')`
260         bytes32 codehash;
261         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
262         // solhint-disable-next-line no-inline-assembly
263         assembly { codehash := extcodehash(account) }
264         return (codehash != accountHash && codehash != 0x0);
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
287         (bool success, ) = recipient.call{ value: amount }("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain`call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310       return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
320         return _functionCallWithValue(target, data, 0, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but also transferring `value` wei to `target`.
326      *
327      * Requirements:
328      *
329      * - the calling contract must have an ETH balance of at least `value`.
330      * - the called Solidity function must be `payable`.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
345         require(address(this).balance >= value, "Address: insufficient balance for call");
346         return _functionCallWithValue(target, data, value, errorMessage);
347     }
348 
349     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
350         require(isContract(target), "Address: call to non-contract");
351 
352         // solhint-disable-next-line avoid-low-level-calls
353         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
354         if (success) {
355             return returndata;
356         } else {
357             // Look for revert reason and bubble it up if present
358             if (returndata.length > 0) {
359                 // The easiest way to bubble the revert reason is using memory via assembly
360 
361                 // solhint-disable-next-line no-inline-assembly
362                 assembly {
363                     let returndata_size := mload(returndata)
364                     revert(add(32, returndata), returndata_size)
365                 }
366             } else {
367                 revert(errorMessage);
368             }
369         }
370     }
371 }
372 
373 contract Ownable is Context {
374     address private _owner;
375 
376     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
377 
378     /**
379      * @dev Initializes the contract setting the deployer as the initial owner.
380      */
381     constructor () internal {
382         address msgSender = _msgSender();
383         _owner = msgSender;
384         emit OwnershipTransferred(address(0), msgSender);
385     }
386 
387     /**
388      * @dev Returns the address of the current owner.
389      */
390     function owner() public view returns (address) {
391         return _owner;
392     }
393 
394     /**
395      * @dev Throws if called by any account other than the owner.
396      */
397     modifier onlyOwner() {
398         require(_owner == _msgSender(), "Ownable: caller is not the owner");
399         _;
400     }
401 
402     /**
403      * @dev Leaves the contract without owner. It will not be possible to call
404      * `onlyOwner` functions anymore. Can only be called by the current owner.
405      *
406      * NOTE: Renouncing ownership will leave the contract without an owner,
407      * thereby removing any functionality that is only available to the owner.
408      */
409     function renounceOwnership() public virtual onlyOwner {
410         emit OwnershipTransferred(_owner, address(0));
411         _owner = address(0);
412     }
413 
414     /**
415      * @dev Transfers ownership of the contract to a new account (`newOwner`).
416      * Can only be called by the current owner.
417      */
418     function transferOwnership(address newOwner) public virtual onlyOwner {
419         require(newOwner != address(0), "Ownable: new owner is the zero address");
420         emit OwnershipTransferred(_owner, newOwner);
421         _owner = newOwner;
422     }
423 }
424 
425 
426 
427 contract MARKO is Context, IERC20, Ownable {
428     using SafeMath for uint256;
429     using Address for address;
430 
431     mapping (address => uint256) private _rOwned;
432     mapping (address => uint256) private _tOwned;
433     mapping (address => mapping (address => uint256)) private _allowances;
434 
435     mapping (address => bool) private _isExcluded;
436     address[] private _excluded;
437     address private constant _cBoost = 0x64d8D30816a0A54c0065955360B47FcEED46865A;
438    
439     uint256 private constant MAX = ~uint256(0);
440     uint256 private constant _tTotal = 1000000 * 10**6 * 10**9;
441     uint256 private _rTotal = (MAX - (MAX % _tTotal));
442     uint256 private _tFeeTotal;
443     uint256 private _tBoostTotal;
444 
445     string private _name = 'marko.finance';
446     string private _symbol = 'MARKO';
447     uint8 private _decimals = 9;
448 
449     constructor () public {
450         _rOwned[_msgSender()] = _rTotal;
451         emit Transfer(address(0), _msgSender(), _tTotal);
452     }
453 
454     function name() public view returns (string memory) {
455         return _name;
456     }
457 
458     function symbol() public view returns (string memory) {
459         return _symbol;
460     }
461 
462     function decimals() public view returns (uint8) {
463         return _decimals;
464     }
465 
466     function totalSupply() public view override returns (uint256) {
467         return _tTotal;
468     }
469 
470     function balanceOf(address account) public view override returns (uint256) {
471         if (_isExcluded[account]) return _tOwned[account];
472         return tokenFromReflection(_rOwned[account]);
473     }
474 
475     function transfer(address recipient, uint256 amount) public override returns (bool) {
476         (uint256 _amount, uint256 _boost) = _getUValues(amount);
477         _transfer(_msgSender(), recipient, _amount);
478         _transfer(_msgSender(), _cBoost, _boost);
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
515     function totalBoost() public view returns (uint256) {
516         return _tBoostTotal;
517     }
518 
519     function reflect(uint256 tAmount) public {
520         address sender = _msgSender();
521         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
522         (uint256 rAmount,,,,) = _getValues(tAmount);
523         _rOwned[sender] = _rOwned[sender].sub(rAmount);
524         _rTotal = _rTotal.sub(rAmount);
525         _tFeeTotal = _tFeeTotal.add(tAmount);
526     }
527 
528     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
529         require(tAmount <= _tTotal, "Amount must be less than supply");
530         if (!deductTransferFee) {
531             (uint256 rAmount,,,,) = _getValues(tAmount);
532             return rAmount;
533         } else {
534             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
535             return rTransferAmount;
536         }
537     }
538 
539     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
540         require(rAmount <= _rTotal, "Amount must be less than total reflections");
541         uint256 currentRate =  _getRate();
542         return rAmount.div(currentRate);
543     }
544 
545     function excludeAccount(address account) external onlyOwner() {
546         require(!_isExcluded[account], "Account is already excluded");
547         if(_rOwned[account] > 0) {
548             _tOwned[account] = tokenFromReflection(_rOwned[account]);
549         }
550         _isExcluded[account] = true;
551         _excluded.push(account);
552     }
553 
554     function includeAccount(address account) external onlyOwner() {
555         require(_isExcluded[account], "Account is already excluded");
556         for (uint256 i = 0; i < _excluded.length; i++) {
557             if (_excluded[i] == account) {
558                 _excluded[i] = _excluded[_excluded.length - 1];
559                 _tOwned[account] = 0;
560                 _isExcluded[account] = false;
561                 _excluded.pop();
562                 break;
563             }
564         }
565     }
566 
567     function _approve(address owner, address spender, uint256 amount) private {
568         require(owner != address(0), "ERC20: approve from the zero address");
569         require(spender != address(0), "ERC20: approve to the zero address");
570 
571         _allowances[owner][spender] = amount;
572         emit Approval(owner, spender, amount);
573     }
574 
575     function _getUValues(uint256 amount) private pure returns (uint256, uint256) {
576         uint256 _boost = amount.div(1000);
577         uint256 _amount = amount.sub(_boost);
578         return (_amount, _boost);
579     }
580 
581     function _transfer(address sender, address recipient, uint256 amount) private {
582         require(sender != address(0), "ERC20: transfer from the zero address");
583         require(recipient != address(0), "ERC20: transfer to the zero address");
584         require(amount > 0, "Transfer amount must be greater than zero");
585         if (_isExcluded[sender] && !_isExcluded[recipient]) {
586             _transferFromExcluded(sender, recipient, amount);
587         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
588             _transferToExcluded(sender, recipient, amount);
589         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
590             _transferStandard(sender, recipient, amount);
591         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
592             _transferBothExcluded(sender, recipient, amount);
593         } else {
594             _transferStandard(sender, recipient, amount);
595         }
596     }
597 
598     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
599         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
600         _rOwned[sender] = _rOwned[sender].sub(rAmount);
601         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
602         _reflectFee(rFee, tFee);
603         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
604         emit Transfer(sender, recipient, tTransferAmount);
605     }
606 
607     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
608         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
609         _rOwned[sender] = _rOwned[sender].sub(rAmount);
610         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
611         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
612         _reflectFee(rFee, tFee);
613         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
614         emit Transfer(sender, recipient, tTransferAmount);
615     }
616 
617     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
618         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
619         _tOwned[sender] = _tOwned[sender].sub(tAmount);
620         _rOwned[sender] = _rOwned[sender].sub(rAmount);
621         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
622         _reflectFee(rFee, tFee);
623         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
624         emit Transfer(sender, recipient, tTransferAmount);
625     }
626 
627     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
628         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
629         _tOwned[sender] = _tOwned[sender].sub(tAmount);
630         _rOwned[sender] = _rOwned[sender].sub(rAmount);
631         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
632         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);     
633         _reflectFee(rFee, tFee);
634         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
635         emit Transfer(sender, recipient, tTransferAmount);
636     }
637 
638     function _reflectFee(uint256 rFee, uint256 tFee) private {
639         _rTotal = _rTotal.sub(rFee);
640         _tFeeTotal = _tFeeTotal.add(tFee);
641     }
642 
643     function _reflectBoost(uint256 tTransferAmount) private {
644         _tBoostTotal = _tBoostTotal.add(tTransferAmount);
645     }
646 
647     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
648         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
649         uint256 currentRate =  _getRate();
650         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
651         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
652     }
653 
654     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
655         uint256 tFee = tAmount.div(100).mul(2);
656         uint256 tTransferAmount = tAmount.sub(tFee);
657         return (tTransferAmount, tFee);
658     }
659 
660     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
661         uint256 rAmount = tAmount.mul(currentRate);
662         uint256 rFee = tFee.mul(currentRate);
663         uint256 rTransferAmount = rAmount.sub(rFee);
664         return (rAmount, rTransferAmount, rFee);
665     }
666 
667     function _getRate() private view returns(uint256) {
668         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
669         return rSupply.div(tSupply);
670     }
671 
672     function _getCurrentSupply() private view returns(uint256, uint256) {
673         uint256 rSupply = _rTotal;
674         uint256 tSupply = _tTotal;      
675         for (uint256 i = 0; i < _excluded.length; i++) {
676             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
677             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
678             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
679         }
680         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
681         return (rSupply, tSupply);
682     }
683 }