1 // ███████╗██████╗  ██████╗  ██████╗ ███████╗
2 // ██╔════╝██╔══██╗██╔═══██╗██╔════╝ ██╔════╝
3 // █████╗  ██████╔╝██║   ██║██║  ███╗█████╗  
4 // ██╔══╝  ██╔══██╗██║   ██║██║   ██║██╔══╝  
5 // ██║     ██║  ██║╚██████╔╝╚██████╔╝███████╗
6 // ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝
7 
8 // froge.finance (FROGE): Cool meme for cool earth.
9 // FROGE is a deflationary defi meme token that donating to coolearth directly.
10 // For every transaction, 1% goes to burn address, 1% goes to holders, and 0.1% goes to coolearth foundation.
11 // https://froge.finance
12 // https://t.me/frogefinance
13 
14 // SPDX-License-Identifier: Unlicensed
15 
16 pragma solidity ^0.6.12;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
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
432 contract FROGE is Context, IERC20, Ownable {
433     using SafeMath for uint256;
434     using Address for address;
435 
436     mapping (address => uint256) private _rOwned;
437     mapping (address => uint256) private _tOwned;
438     mapping (address => mapping (address => uint256)) private _allowances;
439 
440     mapping (address => bool) private _isExcluded;
441     address[] private _excluded;
442     address private constant _cBoost = 0x3c8cB169281196737c493AfFA8F49a9d823bB9c5;
443    
444     uint256 private constant MAX = ~uint256(0);
445     uint256 private constant _tTotal = 1000000 * 10**6 * 10**9;
446     uint256 private _rTotal = (MAX - (MAX % _tTotal));
447     uint256 private _tFeeTotal;
448     uint256 private _tBoostTotal;
449 
450     string private _name = 'froge.finance';
451     string private _symbol = 'FROGE';
452     uint8 private _decimals = 9;
453 
454     constructor () public {
455         _rOwned[_msgSender()] = _rTotal;
456         emit Transfer(address(0), _msgSender(), _tTotal);
457     }
458 
459     function name() public view returns (string memory) {
460         return _name;
461     }
462 
463     function symbol() public view returns (string memory) {
464         return _symbol;
465     }
466 
467     function decimals() public view returns (uint8) {
468         return _decimals;
469     }
470 
471     function totalSupply() public view override returns (uint256) {
472         return _tTotal;
473     }
474 
475     function balanceOf(address account) public view override returns (uint256) {
476         if (_isExcluded[account]) return _tOwned[account];
477         return tokenFromReflection(_rOwned[account]);
478     }
479 
480     function transfer(address recipient, uint256 amount) public override returns (bool) {
481         (uint256 _amount, uint256 _boost) = _getUValues(amount);
482         _transfer(_msgSender(), recipient, _amount);
483         _transfer(_msgSender(), _cBoost, _boost);
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
520     function totalBoost() public view returns (uint256) {
521         return _tBoostTotal;
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
580     function _getUValues(uint256 amount) private pure returns (uint256, uint256) {
581         uint256 _boost = amount.div(1000);
582         uint256 _amount = amount.sub(_boost);
583         return (_amount, _boost);
584     }
585 
586     function _transfer(address sender, address recipient, uint256 amount) private {
587         require(sender != address(0), "ERC20: transfer from the zero address");
588         require(recipient != address(0), "ERC20: transfer to the zero address");
589         require(amount > 0, "Transfer amount must be greater than zero");
590         if (_isExcluded[sender] && !_isExcluded[recipient]) {
591             _transferFromExcluded(sender, recipient, amount);
592         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
593             _transferToExcluded(sender, recipient, amount);
594         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
595             _transferStandard(sender, recipient, amount);
596         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
597             _transferBothExcluded(sender, recipient, amount);
598         } else {
599             _transferStandard(sender, recipient, amount);
600         }
601     }
602 
603     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
604         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
605         _rOwned[sender] = _rOwned[sender].sub(rAmount);
606         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
607         _reflectFee(rFee, tFee);
608         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
609         emit Transfer(sender, recipient, tTransferAmount);
610     }
611 
612     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
613         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
614         _rOwned[sender] = _rOwned[sender].sub(rAmount);
615         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
616         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
617         _reflectFee(rFee, tFee);
618         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
619         emit Transfer(sender, recipient, tTransferAmount);
620     }
621 
622     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
623         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
624         _tOwned[sender] = _tOwned[sender].sub(tAmount);
625         _rOwned[sender] = _rOwned[sender].sub(rAmount);
626         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
627         _reflectFee(rFee, tFee);
628         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
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
639         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
640         emit Transfer(sender, recipient, tTransferAmount);
641     }
642 
643     function _reflectFee(uint256 rFee, uint256 tFee) private {
644         _rTotal = _rTotal.sub(rFee);
645         _tFeeTotal = _tFeeTotal.add(tFee);
646     }
647 
648     function _reflectBoost(uint256 tTransferAmount) private {
649         _tBoostTotal = _tBoostTotal.add(tTransferAmount);
650     }
651 
652     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
653         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
654         uint256 currentRate =  _getRate();
655         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
656         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
657     }
658 
659     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
660         uint256 tFee = tAmount.div(100).mul(2);
661         uint256 tTransferAmount = tAmount.sub(tFee);
662         return (tTransferAmount, tFee);
663     }
664 
665     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
666         uint256 rAmount = tAmount.mul(currentRate);
667         uint256 rFee = tFee.mul(currentRate);
668         uint256 rTransferAmount = rAmount.sub(rFee);
669         return (rAmount, rTransferAmount, rFee);
670     }
671 
672     function _getRate() private view returns(uint256) {
673         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
674         return rSupply.div(tSupply);
675     }
676 
677     function _getCurrentSupply() private view returns(uint256, uint256) {
678         uint256 rSupply = _rTotal;
679         uint256 tSupply = _tTotal;      
680         for (uint256 i = 0; i < _excluded.length; i++) {
681             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
682             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
683             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
684         }
685         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
686         return (rSupply, tSupply);
687     }
688 }