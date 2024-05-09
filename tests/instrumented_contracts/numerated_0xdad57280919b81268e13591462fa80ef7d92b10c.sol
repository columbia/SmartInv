1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-26
3 */
4 
5 	// Grumpee cat
6 	// https://grumpee.finance
7 	
8     // SPDX-License-Identifier: Unlicensed
9 
10     pragma solidity ^0.6.12;
11 
12     abstract contract Context {
13         function _msgSender() internal view virtual returns (address payable) {
14             return msg.sender;
15         }
16 
17         function _msgData() internal view virtual returns (bytes memory) {
18             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19             return msg.data;
20         }
21     }
22 
23     interface IERC20 {
24         /**
25         * @dev Returns the amount of tokens in existence.
26         */
27         function totalSupply() external view returns (uint256);
28 
29         /**
30         * @dev Returns the amount of tokens owned by `account`.
31         */
32         function balanceOf(address account) external view returns (uint256);
33 
34         /**
35         * @dev Moves `amount` tokens from the caller's account to `recipient`.
36         *
37         * Returns a boolean value indicating whether the operation succeeded.
38         *
39         * Emits a {Transfer} event.
40         */
41         function transfer(address recipient, uint256 amount) external returns (bool);
42 
43         /**
44         * @dev Returns the remaining number of tokens that `spender` will be
45         * allowed to spend on behalf of `owner` through {transferFrom}. This is
46         * zero by default.
47         *
48         * This value changes when {approve} or {transferFrom} are called.
49         */
50         function allowance(address owner, address spender) external view returns (uint256);
51 
52         /**
53         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54         *
55         * Returns a boolean value indicating whether the operation succeeded.
56         *
57         * IMPORTANT: Beware that changing an allowance with this method brings the risk
58         * that someone may use both the old and the new allowance by unfortunate
59         * transaction ordering. One possible solution to mitigate this race
60         * condition is to first reduce the spender's allowance to 0 and set the
61         * desired value afterwards:
62         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63         *
64         * Emits an {Approval} event.
65         */
66         function approve(address spender, uint256 amount) external returns (bool);
67 
68         /**
69         * @dev Moves `amount` tokens from `sender` to `recipient` using the
70         * allowance mechanism. `amount` is then deducted from the caller's
71         * allowance.
72         *
73         * Returns a boolean value indicating whether the operation succeeded.
74         *
75         * Emits a {Transfer} event.
76         */
77         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79         /**
80         * @dev Emitted when `value` tokens are moved from one account (`from`) to
81         * another (`to`).
82         *
83         * Note that `value` may be zero.
84         */
85         event Transfer(address indexed from, address indexed to, uint256 value);
86 
87         /**
88         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89         * a call to {approve}. `value` is the new allowance.
90         */
91         event Approval(address indexed owner, address indexed spender, uint256 value);
92     }
93 
94     library SafeMath {
95         /**
96         * @dev Returns the addition of two unsigned integers, reverting on
97         * overflow.
98         *
99         * Counterpart to Solidity's `+` operator.
100         *
101         * Requirements:
102         *
103         * - Addition cannot overflow.
104         */
105         function add(uint256 a, uint256 b) internal pure returns (uint256) {
106             uint256 c = a + b;
107             require(c >= a, "SafeMath: addition overflow");
108 
109             return c;
110         }
111 
112         /**
113         * @dev Returns the subtraction of two unsigned integers, reverting on
114         * overflow (when the result is negative).
115         *
116         * Counterpart to Solidity's `-` operator.
117         *
118         * Requirements:
119         *
120         * - Subtraction cannot overflow.
121         */
122         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123             return sub(a, b, "SafeMath: subtraction overflow");
124         }
125 
126         /**
127         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
128         * overflow (when the result is negative).
129         *
130         * Counterpart to Solidity's `-` operator.
131         *
132         * Requirements:
133         *
134         * - Subtraction cannot overflow.
135         */
136         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137             require(b <= a, errorMessage);
138             uint256 c = a - b;
139 
140             return c;
141         }
142 
143         /**
144         * @dev Returns the multiplication of two unsigned integers, reverting on
145         * overflow.
146         *
147         * Counterpart to Solidity's `*` operator.
148         *
149         * Requirements:
150         *
151         * - Multiplication cannot overflow.
152         */
153         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
155             // benefit is lost if 'b' is also tested.
156             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
157             if (a == 0) {
158                 return 0;
159             }
160 
161             uint256 c = a * b;
162             require(c / a == b, "SafeMath: multiplication overflow");
163 
164             return c;
165         }
166 
167         /**
168         * @dev Returns the integer division of two unsigned integers. Reverts on
169         * division by zero. The result is rounded towards zero.
170         *
171         * Counterpart to Solidity's `/` operator. Note: this function uses a
172         * `revert` opcode (which leaves remaining gas untouched) while Solidity
173         * uses an invalid opcode to revert (consuming all remaining gas).
174         *
175         * Requirements:
176         *
177         * - The divisor cannot be zero.
178         */
179         function div(uint256 a, uint256 b) internal pure returns (uint256) {
180             return div(a, b, "SafeMath: division by zero");
181         }
182 
183         /**
184         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185         * division by zero. The result is rounded towards zero.
186         *
187         * Counterpart to Solidity's `/` operator. Note: this function uses a
188         * `revert` opcode (which leaves remaining gas untouched) while Solidity
189         * uses an invalid opcode to revert (consuming all remaining gas).
190         *
191         * Requirements:
192         *
193         * - The divisor cannot be zero.
194         */
195         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196             require(b > 0, errorMessage);
197             uint256 c = a / b;
198             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199 
200             return c;
201         }
202 
203         /**
204         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205         * Reverts when dividing by zero.
206         *
207         * Counterpart to Solidity's `%` operator. This function uses a `revert`
208         * opcode (which leaves remaining gas untouched) while Solidity uses an
209         * invalid opcode to revert (consuming all remaining gas).
210         *
211         * Requirements:
212         *
213         * - The divisor cannot be zero.
214         */
215         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216             return mod(a, b, "SafeMath: modulo by zero");
217         }
218 
219         /**
220         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221         * Reverts with custom message when dividing by zero.
222         *
223         * Counterpart to Solidity's `%` operator. This function uses a `revert`
224         * opcode (which leaves remaining gas untouched) while Solidity uses an
225         * invalid opcode to revert (consuming all remaining gas).
226         *
227         * Requirements:
228         *
229         * - The divisor cannot be zero.
230         */
231         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232             require(b != 0, errorMessage);
233             return a % b;
234         }
235     }
236 
237     library Address {
238         /**
239         * @dev Returns true if `account` is a contract.
240         *
241         * [IMPORTANT]
242         * ====
243         * It is unsafe to assume that an address for which this function returns
244         * false is an externally-owned account (EOA) and not a contract.
245         *
246         * Among others, `isContract` will return false for the following
247         * types of addresses:
248         *
249         *  - an externally-owned account
250         *  - a contract in construction
251         *  - an address where a contract will be created
252         *  - an address where a contract lived, but was destroyed
253         * ====
254         */
255         function isContract(address account) internal view returns (bool) {
256             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
257             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
258             // for accounts without code, i.e. `keccak256('')`
259             bytes32 codehash;
260             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
261             // solhint-disable-next-line no-inline-assembly
262             assembly { codehash := extcodehash(account) }
263             return (codehash != accountHash && codehash != 0x0);
264         }
265 
266         /**
267         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
268         * `recipient`, forwarding all available gas and reverting on errors.
269         *
270         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
271         * of certain opcodes, possibly making contracts go over the 2300 gas limit
272         * imposed by `transfer`, making them unable to receive funds via
273         * `transfer`. {sendValue} removes this limitation.
274         *
275         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
276         *
277         * IMPORTANT: because control is transferred to `recipient`, care must be
278         * taken to not create reentrancy vulnerabilities. Consider using
279         * {ReentrancyGuard} or the
280         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
281         */
282         function sendValue(address payable recipient, uint256 amount) internal {
283             require(address(this).balance >= amount, "Address: insufficient balance");
284 
285             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
286             (bool success, ) = recipient.call{ value: amount }("");
287             require(success, "Address: unable to send value, recipient may have reverted");
288         }
289 
290         /**
291         * @dev Performs a Solidity function call using a low level `call`. A
292         * plain`call` is an unsafe replacement for a function call: use this
293         * function instead.
294         *
295         * If `target` reverts with a revert reason, it is bubbled up by this
296         * function (like regular Solidity function calls).
297         *
298         * Returns the raw returned data. To convert to the expected return value,
299         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300         *
301         * Requirements:
302         *
303         * - `target` must be a contract.
304         * - calling `target` with `data` must not revert.
305         *
306         * _Available since v3.1._
307         */
308         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionCall(target, data, "Address: low-level call failed");
310         }
311 
312         /**
313         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314         * `errorMessage` as a fallback revert reason when `target` reverts.
315         *
316         * _Available since v3.1._
317         */
318         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
319             return _functionCallWithValue(target, data, 0, errorMessage);
320         }
321 
322         /**
323         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324         * but also transferring `value` wei to `target`.
325         *
326         * Requirements:
327         *
328         * - the calling contract must have an ETH balance of at least `value`.
329         * - the called Solidity function must be `payable`.
330         *
331         * _Available since v3.1._
332         */
333         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
334             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
335         }
336 
337         /**
338         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
339         * with `errorMessage` as a fallback revert reason when `target` reverts.
340         *
341         * _Available since v3.1._
342         */
343         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
344             require(address(this).balance >= value, "Address: insufficient balance for call");
345             return _functionCallWithValue(target, data, value, errorMessage);
346         }
347 
348         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
349             require(isContract(target), "Address: call to non-contract");
350 
351             // solhint-disable-next-line avoid-low-level-calls
352             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
353             if (success) {
354                 return returndata;
355             } else {
356                 // Look for revert reason and bubble it up if present
357                 if (returndata.length > 0) {
358                     // The easiest way to bubble the revert reason is using memory via assembly
359 
360                     // solhint-disable-next-line no-inline-assembly
361                     assembly {
362                         let returndata_size := mload(returndata)
363                         revert(add(32, returndata), returndata_size)
364                     }
365                 } else {
366                     revert(errorMessage);
367                 }
368             }
369         }
370     }
371 
372     contract Ownable is Context {
373         address private _owner;
374 
375         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
376 
377         /**
378         * @dev Initializes the contract setting the deployer as the initial owner.
379         */
380         constructor () internal {
381             address msgSender = _msgSender();
382             _owner = msgSender;
383             emit OwnershipTransferred(address(0), msgSender);
384         }
385 
386         /**
387         * @dev Returns the address of the current owner.
388         */
389         function owner() public view returns (address) {
390             return _owner;
391         }
392 
393         /**
394         * @dev Throws if called by any account other than the owner.
395         */
396         modifier onlyOwner() {
397             require(_owner == _msgSender(), "Ownable: caller is not the owner");
398             _;
399         }
400 
401         /**
402         * @dev Leaves the contract without owner. It will not be possible to call
403         * `onlyOwner` functions anymore. Can only be called by the current owner.
404         *
405         * NOTE: Renouncing ownership will leave the contract without an owner,
406         * thereby removing any functionality that is only available to the owner.
407         */
408         function renounceOwnership() public virtual onlyOwner {
409             emit OwnershipTransferred(_owner, address(0));
410             _owner = address(0);
411         }
412 
413         /**
414         * @dev Transfers ownership of the contract to a new account (`newOwner`).
415         * Can only be called by the current owner.
416         */
417         function transferOwnership(address newOwner) public virtual onlyOwner {
418             require(newOwner != address(0), "Ownable: new owner is the zero address");
419             emit OwnershipTransferred(_owner, newOwner);
420             _owner = newOwner;
421         }
422     }
423 
424 
425 
426     contract Grumpee is Context, IERC20, Ownable {
427         using SafeMath for uint256;
428         using Address for address;
429 
430         mapping (address => uint256) private _rOwned;
431         mapping (address => uint256) private _tOwned;
432         mapping (address => mapping (address => uint256)) private _allowances;
433 
434         mapping (address => bool) private _isExcluded;
435         address[] private _excluded;
436         address private constant _cancerDonation = 0xC07E4FC91caD97aa4F362f42C2DdF8Aa662cf507;
437     
438         uint256 private constant MAX = ~uint256(0);
439         uint256 private constant _tTotal = 100000000 * 10**6 * 10**9; 
440         uint256 private _rTotal = (MAX - (MAX % _tTotal));
441         uint256 private _tFeeTotal;
442         uint256 private _tCancerDonationTotal;
443 
444         string private _name = 'grumpee.finance';
445         string private _symbol = 'GRUMPEE';
446         uint8 private _decimals = 9;
447 
448         constructor () public {
449             _rOwned[_msgSender()] = _rTotal;
450             emit Transfer(address(0), _msgSender(), _tTotal);
451         }
452 
453         function name() public view returns (string memory) {
454             return _name;
455         }
456 
457         function symbol() public view returns (string memory) {
458             return _symbol;
459         }
460 
461         function decimals() public view returns (uint8) {
462             return _decimals;
463         }
464 
465         function totalSupply() public view override returns (uint256) {
466             return _tTotal;
467         }
468 
469         function balanceOf(address account) public view override returns (uint256) {
470             if (_isExcluded[account]) return _tOwned[account];
471             return tokenFromReflection(_rOwned[account]);
472         }
473 
474         function transfer(address recipient, uint256 amount) public override returns (bool) {
475             (uint256 _amount, uint256 _donation) = _getUValues(amount);
476             _transfer(_msgSender(), recipient, _amount);
477             _transfer(_msgSender(), _cancerDonation, _donation);
478             return true;
479         }
480 
481         function allowance(address owner, address spender) public view override returns (uint256) {
482             return _allowances[owner][spender];
483         }
484 
485         function approve(address spender, uint256 amount) public override returns (bool) {
486             _approve(_msgSender(), spender, amount);
487             return true;
488         }
489 
490         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
491             _transfer(sender, recipient, amount);
492             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
493             return true;
494         }
495 
496         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
497             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
498             return true;
499         }
500 
501         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
502             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
503             return true;
504         }
505 
506         function isExcluded(address account) public view returns (bool) {
507             return _isExcluded[account];
508         }
509 
510         function totalFees() public view returns (uint256) {
511             return _tFeeTotal;
512         }
513 
514         function totalCancerDonation() public view returns (uint256) {
515             return _tCancerDonationTotal;
516         }
517 
518         function reflect(uint256 tAmount) public {
519             address sender = _msgSender();
520             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
521             (uint256 rAmount,,,,) = _getValues(tAmount);
522             _rOwned[sender] = _rOwned[sender].sub(rAmount);
523             _rTotal = _rTotal.sub(rAmount);
524             _tFeeTotal = _tFeeTotal.add(tAmount);
525         }
526 
527         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
528             require(tAmount <= _tTotal, "Amount must be less than supply");
529             if (!deductTransferFee) {
530                 (uint256 rAmount,,,,) = _getValues(tAmount);
531                 return rAmount;
532             } else {
533                 (,uint256 rTransferAmount,,,) = _getValues(tAmount);
534                 return rTransferAmount;
535             }
536         }
537 
538         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
539             require(rAmount <= _rTotal, "Amount must be less than total reflections");
540             uint256 currentRate =  _getRate();
541             return rAmount.div(currentRate);
542         }
543 
544         function excludeAccount(address account) external onlyOwner() {
545             require(!_isExcluded[account], "Account is already excluded");
546             if(_rOwned[account] > 0) {
547                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
548             }
549             _isExcluded[account] = true;
550             _excluded.push(account);
551         }
552 
553         function includeAccount(address account) external onlyOwner() {
554             require(_isExcluded[account], "Account is already excluded");
555             for (uint256 i = 0; i < _excluded.length; i++) {
556                 if (_excluded[i] == account) {
557                     _excluded[i] = _excluded[_excluded.length - 1];
558                     _tOwned[account] = 0;
559                     _isExcluded[account] = false;
560                     _excluded.pop();
561                     break;
562                 }
563             }
564         }
565 
566         function _approve(address owner, address spender, uint256 amount) private {
567             require(owner != address(0), "ERC20: approve from the zero address");
568             require(spender != address(0), "ERC20: approve to the zero address");
569 
570             _allowances[owner][spender] = amount;
571             emit Approval(owner, spender, amount);
572         }
573 
574         function _getUValues(uint256 amount) private pure returns (uint256, uint256) {
575             uint256 _donation = amount.div(1000).mul(3);
576             uint256 _amount = amount.sub(_donation);
577             return (_amount, _donation);
578         }
579 
580         function _transfer(address sender, address recipient, uint256 amount) private {
581             require(sender != address(0), "ERC20: transfer from the zero address");
582             require(recipient != address(0), "ERC20: transfer to the zero address");
583             require(amount > 0, "Transfer amount must be greater than zero");
584             if (_isExcluded[sender] && !_isExcluded[recipient]) {
585                 _transferFromExcluded(sender, recipient, amount);
586             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
587                 _transferToExcluded(sender, recipient, amount);
588             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
589                 _transferStandard(sender, recipient, amount);
590             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
591                 _transferBothExcluded(sender, recipient, amount);
592             } else {
593                 _transferStandard(sender, recipient, amount);
594             }
595         }
596 
597 
598         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
599             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
600             _rOwned[sender] = _rOwned[sender].sub(rAmount);
601             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
602             _reflectFee(rFee, tFee);
603             if (recipient == _cancerDonation) _reflectCancerDonation(tTransferAmount);
604             emit Transfer(sender, recipient, tTransferAmount);
605         }
606 
607         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
608             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
609             _rOwned[sender] = _rOwned[sender].sub(rAmount);
610             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
611             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
612             _reflectFee(rFee, tFee);
613             if (recipient == _cancerDonation) _reflectCancerDonation(tTransferAmount);
614             emit Transfer(sender, recipient, tTransferAmount);
615         }
616 
617         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
618             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
619             _tOwned[sender] = _tOwned[sender].sub(tAmount);
620             _rOwned[sender] = _rOwned[sender].sub(rAmount);
621             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
622             _reflectFee(rFee, tFee);
623             if (recipient == _cancerDonation) _reflectCancerDonation(tTransferAmount);
624             emit Transfer(sender, recipient, tTransferAmount);
625         }
626 
627         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
628             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
629             _tOwned[sender] = _tOwned[sender].sub(tAmount);
630             _rOwned[sender] = _rOwned[sender].sub(rAmount);
631             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
632             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
633             _reflectFee(rFee, tFee);
634             if (recipient == _cancerDonation) _reflectCancerDonation(tTransferAmount);
635             emit Transfer(sender, recipient, tTransferAmount);
636         }
637 
638         function _reflectFee(uint256 rFee, uint256 tFee) private {
639             _rTotal = _rTotal.sub(rFee);
640             _tFeeTotal = _tFeeTotal.add(tFee);
641         }
642 
643         function _reflectCancerDonation(uint256 tTransferAmount) private {
644             _tCancerDonationTotal = _tCancerDonationTotal.add(tTransferAmount);
645         }
646 
647         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
648             (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
649             uint256 currentRate =  _getRate();
650             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
651             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
652         }
653 
654         function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
655             uint256 tFee = tAmount.div(100);
656             uint256 tTransferAmount = tAmount.sub(tFee);
657             return (tTransferAmount, tFee);
658         }
659 
660         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
661             uint256 rAmount = tAmount.mul(currentRate);
662             uint256 rFee = tFee.mul(currentRate);
663             uint256 rTransferAmount = rAmount.sub(rFee);
664             return (rAmount, rTransferAmount, rFee);
665         }
666 
667         function _getRate() private view returns(uint256) {
668             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
669             return rSupply.div(tSupply);
670         }
671 
672         function _getCurrentSupply() private view returns(uint256, uint256) {
673             uint256 rSupply = _rTotal;
674             uint256 tSupply = _tTotal;      
675             for (uint256 i = 0; i < _excluded.length; i++) {
676                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
677                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
678                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
679             }
680             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
681             return (rSupply, tSupply);
682         }
683     }