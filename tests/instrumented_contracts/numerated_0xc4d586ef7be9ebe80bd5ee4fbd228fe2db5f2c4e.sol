1 //From the developers of Baby Shiba
2 
3 //Papa Shiba (PHIBA), father of Baby Shiba, is here to almost complete the trifecta of Shibas.
4 
5 //CMC and CG listing application in place. 
6 
7 //Marketing budget in place
8 
9 //Limit Buy to remove bots : on
10 
11 //Liqudity Locked
12 
13 //TG: https://t.me/Papashiba
14 
15 //Website: https://papashiba.finance/
16 
17 // SPDX-License-Identifier: Unlicensed
18 
19 pragma solidity ^0.6.12;    
20 
21 abstract contract Context {
22     
23     function _msgSender() internal view virtual returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.s
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 library SafeMath {
105     /**
106      * @dev Returns the addition of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `+` operator.
110      *
111      * Requirements:
112      *
113      * - Addition cannot overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a, "SafeMath: addition overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      *
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133         return sub(a, b, "SafeMath: subtraction overflow");
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b <= a, errorMessage);
148         uint256 c = a - b;
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `*` operator.
158      *
159      * Requirements:
160      *
161      * - Multiplication cannot overflow.
162      */
163     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165         // benefit is lost if 'b' is also tested.
166         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
167         if (a == 0) {
168             return 0;
169         }
170 
171         uint256 c = a * b;
172         require(c / a == b, "SafeMath: multiplication overflow");
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         return div(a, b, "SafeMath: division by zero");
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b > 0, errorMessage);
207         uint256 c = a / b;
208         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
226         return mod(a, b, "SafeMath: modulo by zero");
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts with custom message when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
242         require(b != 0, errorMessage);
243         return a % b;
244     }
245 }
246 
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
267         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
268         // for accounts without code, i.e. `keccak256('')`
269         bytes32 codehash;
270         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
271         // solhint-disable-next-line no-inline-assembly
272         assembly { codehash := extcodehash(account) }
273         return (codehash != accountHash && codehash != 0x0);
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
296         (bool success, ) = recipient.call{ value: amount }("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain`call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319       return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
329         return _functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
354         require(address(this).balance >= value, "Address: insufficient balance for call");
355         return _functionCallWithValue(target, data, value, errorMessage);
356     }
357 
358     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
359         require(isContract(target), "Address: call to non-contract");
360 
361         // solhint-disable-next-line avoid-low-level-calls
362         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
363         if (success) {
364             return returndata;
365         } else {
366             // Look for revert reason and bubble it up if present
367             if (returndata.length > 0) {
368                 // The easiest way to bubble the revert reason is using memory via assembly
369 
370                 // solhint-disable-next-line no-inline-assembly
371                 assembly {
372                     let returndata_size := mload(returndata)
373                     revert(add(32, returndata), returndata_size)
374                 }
375             } else {
376                 revert(errorMessage);
377             }
378         }
379     }
380 }
381 
382 contract Ownable is Context {
383     address private _owner;
384 
385     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
386 
387     /**
388      * @dev Initializes the contract setting the deployer as the initial owner.
389      */
390     constructor () internal {
391         address msgSender = _msgSender();
392         _owner = msgSender;
393         emit OwnershipTransferred(address(0), msgSender);
394     }
395 
396     /**
397      * @dev Returns the address of the current owner.
398      */
399     function owner() public view returns (address) {
400         return _owner;
401     }
402 
403     /**
404      * @dev Throws if called by any account other than the owner.
405      */
406     modifier onlyOwner() {
407         require(_owner == _msgSender(), "Ownable: caller is not the owner");
408         _;
409     }
410 
411     /**
412      * @dev Leaves the contract without owner. It will not be possible to call
413      * `onlyOwner` functions anymore. Can only be called by the current owner.
414      *
415      * NOTE: Renouncing ownership will leave the contract without an owner,
416      * thereby removing any functionality that is only available to the owner.
417      */
418     function renounceOwnership() public virtual onlyOwner {
419         emit OwnershipTransferred(_owner, address(0));
420         _owner = address(0);
421     }
422 
423     /**
424      * @dev Transfers ownership of the contract to a new account (`newOwner`).
425      * Can only be called by the current owner.
426      */
427     function transferOwnership(address newOwner) public virtual onlyOwner {
428         require(newOwner != address(0), "Ownable: new owner is the zero address");
429         emit OwnershipTransferred(_owner, newOwner);
430         _owner = newOwner;
431     }
432 }
433 
434 
435 
436 contract PapaShiba is Context, IERC20, Ownable {
437     using SafeMath for uint256;
438     using Address for address;
439 
440     mapping (address => uint256) private _rOwned;
441     mapping (address => uint256) private _tOwned;
442     mapping (address => mapping (address => uint256)) private _allowances;
443 
444     mapping (address => bool) private _isExcluded;
445     address[] private _excluded;
446    
447     uint256 private constant MAX = ~uint256(0);
448     uint256 private constant _tTotal = 10000000 * 10**5 * 10**9;
449     uint256 private _rTotal = (MAX - (MAX % _tTotal));
450     uint256 private _tFeeTotal;
451 
452     string private _name = 'Papa Shiba';
453     string private _symbol = 'PHIBA';
454     uint8 private _decimals = 9;
455     
456     uint256 public _maxTxAmount = 10000000 * 10**5 * 10**9;
457 
458     constructor () public {
459         _rOwned[_msgSender()] = _rTotal;
460         emit Transfer(address(0), _msgSender(), _tTotal);
461     }
462 
463     function name() public view returns (string memory) {
464         return _name;
465     }
466 
467     function symbol() public view returns (string memory) {
468         return _symbol;
469     }
470 
471     function decimals() public view returns (uint8) {
472         return _decimals;
473     }
474 
475     function totalSupply() public view override returns (uint256) {
476         return _tTotal;
477     }
478 
479     function balanceOf(address account) public view override returns (uint256) {
480         if (_isExcluded[account]) return _tOwned[account];
481         return tokenFromReflection(_rOwned[account]);
482     }
483 
484     function transfer(address recipient, uint256 amount) public override returns (bool) {
485         _transfer(_msgSender(), recipient, amount);
486         return true;
487     }
488 
489     function allowance(address owner, address spender) public view override returns (uint256) {
490         return _allowances[owner][spender];
491     }
492 
493     function approve(address spender, uint256 amount) public override returns (bool) {
494         _approve(_msgSender(), spender, amount);
495         return true;
496     }
497 
498     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
499         _transfer(sender, recipient, amount);
500         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
501         return true;
502     }
503 
504     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
505         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
506         return true;
507     }
508 
509     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
510         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
511         return true;
512     }
513 
514     function isExcluded(address account) public view returns (bool) {
515         return _isExcluded[account];
516     }
517 
518     function totalFees() public view returns (uint256) {
519         return _tFeeTotal;
520     }
521     
522     
523     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
524         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
525             10**2
526         );
527     }
528 
529     function reflect(uint256 tAmount) public {
530         address sender = _msgSender();
531         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
532         (uint256 rAmount,,,,) = _getValues(tAmount);
533         _rOwned[sender] = _rOwned[sender].sub(rAmount);
534         _rTotal = _rTotal.sub(rAmount);
535         _tFeeTotal = _tFeeTotal.add(tAmount);
536     }
537 
538     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
539         require(tAmount <= _tTotal, "Amount must be less than supply");
540         if (!deductTransferFee) {
541             (uint256 rAmount,,,,) = _getValues(tAmount);
542             return rAmount;
543         } else {
544             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
545             return rTransferAmount;
546         }
547     }
548 
549     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
550         require(rAmount <= _rTotal, "Amount must be less than total reflections");
551         uint256 currentRate =  _getRate();
552         return rAmount.div(currentRate);
553     }
554 
555     function excludeAccount(address account) external onlyOwner() {
556         require(!_isExcluded[account], "Account is already excluded");
557         if(_rOwned[account] > 0) {
558             _tOwned[account] = tokenFromReflection(_rOwned[account]);
559         }
560         _isExcluded[account] = true;
561         _excluded.push(account);
562     }
563 
564     function includeAccount(address account) external onlyOwner() {
565         require(_isExcluded[account], "Account is already excluded");
566         for (uint256 i = 0; i < _excluded.length; i++) {
567             if (_excluded[i] == account) {
568                 _excluded[i] = _excluded[_excluded.length - 1];
569                 _tOwned[account] = 0;
570                 _isExcluded[account] = false;
571                 _excluded.pop();
572                 break;
573             }
574         }
575     }
576 
577     function _approve(address owner, address spender, uint256 amount) private {
578         require(owner != address(0), "ERC20: approve from the zero address");
579         require(spender != address(0), "ERC20: approve to the zero address");
580 
581         _allowances[owner][spender] = amount;
582         emit Approval(owner, spender, amount);
583     }
584 
585     function _transfer(address sender, address recipient, uint256 amount) private {
586         require(sender != address(0), "ERC20: transfer from the zero address");
587         require(recipient != address(0), "ERC20: transfer to the zero address");
588         require(amount > 0, "Transfer amount must be greater than zero");
589         if(sender != owner() && recipient != owner())
590           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
591             
592         if (_isExcluded[sender] && !_isExcluded[recipient]) {
593             _transferFromExcluded(sender, recipient, amount);
594         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
595             _transferToExcluded(sender, recipient, amount);
596         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
597             _transferStandard(sender, recipient, amount);
598         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
599             _transferBothExcluded(sender, recipient, amount);
600         } else {
601             _transferStandard(sender, recipient, amount);
602         }
603     }
604 
605     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
606         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
607         _rOwned[sender] = _rOwned[sender].sub(rAmount);
608         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
609         _reflectFee(rFee, tFee);
610         emit Transfer(sender, recipient, tTransferAmount);
611     }
612 
613     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
614         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
615         _rOwned[sender] = _rOwned[sender].sub(rAmount);
616         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
617         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
618         _reflectFee(rFee, tFee);
619         emit Transfer(sender, recipient, tTransferAmount);
620     }
621 
622     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
623         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
624         _tOwned[sender] = _tOwned[sender].sub(tAmount);
625         _rOwned[sender] = _rOwned[sender].sub(rAmount);
626         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
627         _reflectFee(rFee, tFee);
628         emit Transfer(sender, recipient, tTransferAmount);
629     }
630 
631     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
632         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
633         _tOwned[sender] = _tOwned[sender].sub(tAmount);
634         _rOwned[sender] = _rOwned[sender].sub(rAmount);
635         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
636         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
637         _reflectFee(rFee, tFee);
638         emit Transfer(sender, recipient, tTransferAmount);
639     }
640 
641     function _reflectFee(uint256 rFee, uint256 tFee) private {
642         _rTotal = _rTotal.sub(rFee);
643         _tFeeTotal = _tFeeTotal.add(tFee);
644     }
645 
646     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
647         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
648         uint256 currentRate =  _getRate();
649         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
650         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
651     }
652 
653     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
654         uint256 tFee = tAmount.div(100).mul(2);
655         uint256 tTransferAmount = tAmount.sub(tFee);
656         return (tTransferAmount, tFee);
657     }
658 
659     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
660         uint256 rAmount = tAmount.mul(currentRate);
661         uint256 rFee = tFee.mul(currentRate);
662         uint256 rTransferAmount = rAmount.sub(rFee);
663         return (rAmount, rTransferAmount, rFee);
664     }
665 
666     function _getRate() private view returns(uint256) {
667         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
668         return rSupply.div(tSupply);
669     }
670 
671     function _getCurrentSupply() private view returns(uint256, uint256) {
672         uint256 rSupply = _rTotal;
673         uint256 tSupply = _tTotal;      
674         for (uint256 i = 0; i < _excluded.length; i++) {
675             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
676             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
677             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
678         }
679         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
680         return (rSupply, tSupply);
681     }
682 }