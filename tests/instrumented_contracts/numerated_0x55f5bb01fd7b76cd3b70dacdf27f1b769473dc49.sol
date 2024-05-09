1 /*
2   #ELONDUCK.FINANCE
3  
4   Website: https://www.elonduck.finance
5   Telegram: t.me/elonduck
6   #RFI + #SHIB fork, 3% fee auto distribution to all holders
7  
8    I created a black hole so #ELONDUCK token will deflate itself in supply with every transaction
9    50% Supply is burned at start.
10 */
11  
12 // SPDX-License-Identifier: Unlicensed
13  
14 pragma solidity ^0.6.12;
15  
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      *
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30  
31         return c;
32     }
33  
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      *
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47  
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      *
56      * - Subtraction cannot overflow.
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61  
62         return c;
63     }
64  
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      *
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82  
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85  
86         return c;
87     }
88  
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      *
99      * - The divisor cannot be zero.
100      */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104  
105     /**
106      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
107      * division by zero. The result is rounded towards zero.
108      *
109      * Counterpart to Solidity's `/` operator. Note: this function uses a
110      * `revert` opcode (which leaves remaining gas untouched) while Solidity
111      * uses an invalid opcode to revert (consuming all remaining gas).
112      *
113      * Requirements:
114      *
115      * - The divisor cannot be zero.
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121  
122         return c;
123     }
124  
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140  
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158  
159 abstract contract Context {
160     function _msgSender() internal view virtual returns (address payable) {
161         return msg.sender;
162     }
163  
164     function _msgData() internal view virtual returns (bytes memory) {
165         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
166         return msg.data;
167     }
168 }
169  
170 interface IERC20 {
171     /**
172      * @dev Returns the amount of tokens in existence.
173      */
174     function totalSupply() external view returns (uint256);
175  
176     /**
177      * @dev Returns the amount of tokens owned by `account`.
178      */
179     function balanceOf(address account) external view returns (uint256);
180  
181     /**
182      * @dev Moves `amount` tokens from the caller's account to `recipient`.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transfer(address recipient, uint256 amount) external returns (bool);
189  
190     /**
191      * @dev Returns the remaining number of tokens that `spender` will be
192      * allowed to spend on behalf of `owner` through {transferFrom}. This is
193      * zero by default.
194      *
195      * This value changes when {approve} or {transferFrom} are called.
196      */
197     function allowance(address owner, address spender) external view returns (uint256);
198  
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214  
215     /**
216      * @dev Moves `amount` tokens from `sender` to `recipient` using the
217      * allowance mechanism. `amount` is then deducted from the caller's
218      * allowance.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
225  
226     /**
227      * @dev Emitted when `value` tokens are moved from one account (`from`) to
228      * another (`to`).
229      *
230      * Note that `value` may be zero.
231      */
232     event Transfer(address indexed from, address indexed to, uint256 value);
233  
234     /**
235      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
236      * a call to {approve}. `value` is the new allowance.
237      */
238     event Approval(address indexed owner, address indexed spender, uint256 value);
239 }
240  
241  
242  
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
263         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
264         // for accounts without code, i.e. `keccak256('')`
265         bytes32 codehash;
266         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
267         // solhint-disable-next-line no-inline-assembly
268         assembly { codehash := extcodehash(account) }
269         return (codehash != accountHash && codehash != 0x0);
270     }
271  
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290  
291         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
292         (bool success, ) = recipient.call{ value: amount }("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295  
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain`call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315       return functionCall(target, data, "Address: low-level call failed");
316     }
317  
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
325         return _functionCallWithValue(target, data, 0, errorMessage);
326     }
327  
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but also transferring `value` wei to `target`.
331      *
332      * Requirements:
333      *
334      * - the calling contract must have an ETH balance of at least `value`.
335      * - the called Solidity function must be `payable`.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
341     }
342  
343     /**
344      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
345      * with `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
350         require(address(this).balance >= value, "Address: insufficient balance for call");
351         return _functionCallWithValue(target, data, value, errorMessage);
352     }
353  
354     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
355         require(isContract(target), "Address: call to non-contract");
356  
357         // solhint-disable-next-line avoid-low-level-calls
358         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
359         if (success) {
360             return returndata;
361         } else {
362             // Look for revert reason and bubble it up if present
363             if (returndata.length > 0) {
364                 // The easiest way to bubble the revert reason is using memory via assembly
365  
366                 // solhint-disable-next-line no-inline-assembly
367                 assembly {
368                     let returndata_size := mload(returndata)
369                     revert(add(32, returndata), returndata_size)
370                 }
371             } else {
372                 revert(errorMessage);
373             }
374         }
375     }
376 }
377  
378 contract Ownable is Context {
379     address private _owner;
380  
381     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
382  
383     /**
384      * @dev Initializes the contract setting the deployer as the initial owner.
385      */
386     constructor () internal {
387         address msgSender = _msgSender();
388         _owner = msgSender;
389         emit OwnershipTransferred(address(0), msgSender);
390     }
391  
392     /**
393      * @dev Returns the address of the current owner.
394      */
395     function owner() public view returns (address) {
396         return _owner;
397     }
398  
399     /**
400      * @dev Throws if called by any account other than the owner.
401      */
402     modifier onlyOwner() {
403         require(_owner == _msgSender(), "Ownable: caller is not the owner");
404         _;
405     }
406  
407     /**
408      * @dev Leaves the contract without owner. It will not be possible to call
409      * `onlyOwner` functions anymore. Can only be called by the current owner.
410      *
411      * NOTE: Renouncing ownership will leave the contract without an owner,
412      * thereby removing any functionality that is only available to the owner.
413      */
414     function renounceOwnership() public virtual onlyOwner {
415         emit OwnershipTransferred(_owner, address(0));
416         _owner = address(0);
417     }
418  
419     /**
420      * @dev Transfers ownership of the contract to a new account (`newOwner`).
421      * Can only be called by the current owner.
422      */
423     function transferOwnership(address newOwner) public virtual onlyOwner {
424         require(newOwner != address(0), "Ownable: new owner is the zero address");
425         emit OwnershipTransferred(_owner, newOwner);
426         _owner = newOwner;
427     }
428 }
429  
430  
431  
432 contract ElonDuck is Context, IERC20, Ownable {
433     using SafeMath for uint256;
434     using Address for address;
435  
436     mapping (address => uint256) private _rOwned;
437     mapping (address => uint256) private _tOwned;
438     mapping (address => mapping (address => uint256)) private _allowances;
439  
440     mapping (address => bool) private _isExcluded;
441     address[] private _excluded;
442  
443     uint256 private constant MAX = ~uint256(0);
444     uint256 private constant _tTotal = 1000000000 * 10**6 * 10**9;
445     uint256 private _rTotal = (MAX - (MAX % _tTotal));
446     uint256 private _tFeeTotal;
447  
448     string private _name = 'elonduck.finance';
449     string private _symbol = 'ELONDUCK';
450     uint8 private _decimals = 9;
451  
452     constructor () public {
453         _rOwned[_msgSender()] = _rTotal;
454         emit Transfer(address(0), _msgSender(), _tTotal);
455     }
456  
457     function name() public view returns (string memory) {
458         return _name;
459     }
460  
461     function symbol() public view returns (string memory) {
462         return _symbol;
463     }
464  
465     function decimals() public view returns (uint8) {
466         return _decimals;
467     }
468  
469     function totalSupply() public view override returns (uint256) {
470         return _tTotal;
471     }
472  
473     function balanceOf(address account) public view override returns (uint256) {
474         if (_isExcluded[account]) return _tOwned[account];
475         return tokenFromReflection(_rOwned[account]);
476     }
477  
478     function transfer(address recipient, uint256 amount) public override returns (bool) {
479         _transfer(_msgSender(), recipient, amount);
480         return true;
481     }
482  
483     function allowance(address owner, address spender) public view override returns (uint256) {
484         return _allowances[owner][spender];
485     }
486  
487     function approve(address spender, uint256 amount) public override returns (bool) {
488         _approve(_msgSender(), spender, amount);
489         return true;
490     }
491  
492     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
493         _transfer(sender, recipient, amount);
494         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
495         return true;
496     }
497  
498     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
499         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
500         return true;
501     }
502  
503     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
504         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
505         return true;
506     }
507  
508     function isExcluded(address account) public view returns (bool) {
509         return _isExcluded[account];
510     }
511  
512     function totalFees() public view returns (uint256) {
513         return _tFeeTotal;
514     }
515  
516     function reflect(uint256 tAmount) public {
517         address sender = _msgSender();
518         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
519         (uint256 rAmount,,,,) = _getValues(tAmount);
520         _rOwned[sender] = _rOwned[sender].sub(rAmount);
521         _rTotal = _rTotal.sub(rAmount);
522         _tFeeTotal = _tFeeTotal.add(tAmount);
523     }
524  
525     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
526         require(tAmount <= _tTotal, "Amount must be less than supply");
527         if (!deductTransferFee) {
528             (uint256 rAmount,,,,) = _getValues(tAmount);
529             return rAmount;
530         } else {
531             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
532             return rTransferAmount;
533         }
534     }
535  
536     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
537         require(rAmount <= _rTotal, "Amount must be less than total reflections");
538         uint256 currentRate =  _getRate();
539         return rAmount.div(currentRate);
540     }
541  
542     function excludeAccount(address account) external onlyOwner() {
543         require(!_isExcluded[account], "Account is already excluded");
544         if(_rOwned[account] > 0) {
545             _tOwned[account] = tokenFromReflection(_rOwned[account]);
546         }
547         _isExcluded[account] = true;
548         _excluded.push(account);
549     }
550  
551     function includeAccount(address account) external onlyOwner() {
552         require(_isExcluded[account], "Account is already excluded");
553         for (uint256 i = 0; i < _excluded.length; i++) {
554             if (_excluded[i] == account) {
555                 _excluded[i] = _excluded[_excluded.length - 1];
556                 _tOwned[account] = 0;
557                 _isExcluded[account] = false;
558                 _excluded.pop();
559                 break;
560             }
561         }
562     }
563  
564     function _approve(address owner, address spender, uint256 amount) private {
565         require(owner != address(0), "ERC20: approve from the zero address");
566         require(spender != address(0), "ERC20: approve to the zero address");
567  
568         _allowances[owner][spender] = amount;
569         emit Approval(owner, spender, amount);
570     }
571  
572     function _transfer(address sender, address recipient, uint256 amount) private {
573         require(sender != address(0), "ERC20: transfer from the zero address");
574         require(recipient != address(0), "ERC20: transfer to the zero address");
575         require(amount > 0, "Transfer amount must be greater than zero");
576         if (_isExcluded[sender] && !_isExcluded[recipient]) {
577             _transferFromExcluded(sender, recipient, amount);
578         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
579             _transferToExcluded(sender, recipient, amount);
580         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
581             _transferStandard(sender, recipient, amount);
582         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
583             _transferBothExcluded(sender, recipient, amount);
584         } else {
585             _transferStandard(sender, recipient, amount);
586         }
587     }
588  
589     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
590         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
591         _rOwned[sender] = _rOwned[sender].sub(rAmount);
592         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
593         _reflectFee(rFee, tFee);
594         emit Transfer(sender, recipient, tTransferAmount);
595     }
596  
597     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
598         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
599         _rOwned[sender] = _rOwned[sender].sub(rAmount);
600         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
601         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
602         _reflectFee(rFee, tFee);
603         emit Transfer(sender, recipient, tTransferAmount);
604     }
605  
606     function _getRate() private view returns(uint256) {
607         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
608         return rSupply.div(tSupply);
609     }
610  
611     function _getCurrentSupply() private view returns(uint256, uint256) {
612         uint256 rSupply = _rTotal;
613         uint256 tSupply = _tTotal;
614         for (uint256 i = 0; i < _excluded.length; i++) {
615             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
616             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
617             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
618         }
619         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
620         return (rSupply, tSupply);
621     }
622  
623     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
624         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
625         _tOwned[sender] = _tOwned[sender].sub(tAmount);
626         _rOwned[sender] = _rOwned[sender].sub(rAmount);
627         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
628         _reflectFee(rFee, tFee);
629         emit Transfer(sender, recipient, tTransferAmount);
630     }
631  
632     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
633         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
634         _tOwned[sender] = _tOwned[sender].sub(tAmount);
635         _rOwned[sender] = _rOwned[sender].sub(rAmount);
636         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
637         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
638         _reflectFee(rFee, tFee);
639         emit Transfer(sender, recipient, tTransferAmount);
640     }
641  
642     function _reflectFee(uint256 rFee, uint256 tFee) private {
643         _rTotal = _rTotal.sub(rFee);
644         _tFeeTotal = _tFeeTotal.add(tFee);
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
655         uint256 tFee = tAmount.div(100).mul(3);
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
666 }