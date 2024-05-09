1 /*
2  * Copyright 2021 POGE. ALL RIGHTS RESERVED.
3  */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity ^0.6.12;
8 
9 
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with GSN meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 contract Context {
22     // Empty internal constructor, to prevent people from mistakenly deploying
23     // an instance of this contract, which should be used via inheritance.
24     constructor () internal { }
25 
26     function _msgSender() internal view virtual returns (address payable) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 
37 
38 /**
39  * @dev Interface of the ERC20 standard as defined in the EIP.
40  */
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b <= a, errorMessage);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the multiplication of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return div(a, b, "SafeMath: division by zero");
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         // Solidity only automatically asserts when dividing by 0
224         require(b > 0, errorMessage);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b != 0, errorMessage);
259         return a % b;
260     }
261 }
262 
263 
264 
265 /**
266  * @dev Collection of functions related to the address type
267  */
268 library Address {
269     /**
270      * @dev Returns true if `account` is a contract.
271      *
272      * [IMPORTANT]
273      * ====
274      * It is unsafe to assume that an address for which this function returns
275      * false is an externally-owned account (EOA) and not a contract.
276      *
277      * Among others, `isContract` will return false for the following
278      * types of addresses:
279      *
280      *  - an externally-owned account
281      *  - a contract in construction
282      *  - an address where a contract will be created
283      *  - an address where a contract lived, but was destroyed
284      * ====
285      */
286     function isContract(address account) internal view returns (bool) {
287         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
288         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
289         // for accounts without code, i.e. `keccak256('')`
290         bytes32 codehash;
291         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
292         // solhint-disable-next-line no-inline-assembly
293         assembly { codehash := extcodehash(account) }
294         return (codehash != accountHash && codehash != 0x0);
295     }
296 
297     /**
298      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
299      * `recipient`, forwarding all available gas and reverting on errors.
300      *
301      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
302      * of certain opcodes, possibly making contracts go over the 2300 gas limit
303      * imposed by `transfer`, making them unable to receive funds via
304      * `transfer`. {sendValue} removes this limitation.
305      *
306      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
307      *
308      * IMPORTANT: because control is transferred to `recipient`, care must be
309      * taken to not create reentrancy vulnerabilities. Consider using
310      * {ReentrancyGuard} or the
311      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
312      */
313     function sendValue(address payable recipient, uint256 amount) internal {
314         require(address(this).balance >= amount, "Address: insufficient balance");
315 
316         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
317         (bool success, ) = recipient.call{ value: amount }("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 }
321 
322 
323 
324 
325 /**
326  * @dev Contract module which provides a basic access control mechanism, where
327  * there is an account (an owner) that can be granted exclusive access to
328  * specific functions.
329  *
330  * By default, the owner account will be the one that deploys the contract. This
331  * can later be changed with {transferOwnership}.
332  *
333  * This module is used through inheritance. It will make available the modifier
334  * `onlyOwner`, which can be applied to your functions to restrict their use to
335  * the owner.
336  */
337 contract Ownable is Context {
338     address private _owner;
339 
340     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
341 
342     /**
343      * @dev Initializes the contract setting the deployer as the initial owner.
344      */
345     constructor () internal {
346         address msgSender = _msgSender();
347         _owner = msgSender;
348         emit OwnershipTransferred(address(0), msgSender);
349     }
350 
351     /**
352      * @dev Returns the address of the current owner.
353      */
354     function owner() public view returns (address) {
355         return _owner;
356     }
357 
358     /**
359      * @dev Throws if called by any account other than the owner.
360      */
361     modifier onlyOwner() {
362         require(_owner == _msgSender(), "Ownable: caller is not the owner");
363         _;
364     }
365 
366     /**
367      * @dev Leaves the contract without owner. It will not be possible to call
368      * `onlyOwner` functions anymore. Can only be called by the current owner.
369      *
370      * NOTE: Renouncing ownership will leave the contract without an owner,
371      * thereby removing any functionality that is only available to the owner.
372      */
373     function renounceOwnership() public virtual onlyOwner {
374         emit OwnershipTransferred(_owner, address(0));
375         _owner = address(0);
376     }
377 
378     /**
379      * @dev Transfers ownership of the contract to a new account (`newOwner`).
380      * Can only be called by the current owner.
381      */
382     function transferOwnership(address newOwner) public virtual onlyOwner {
383         require(newOwner != address(0), "Ownable: new owner is the zero address");
384         emit OwnershipTransferred(_owner, newOwner);
385         _owner = newOwner;
386     }
387 }
388 
389 
390 contract POGE is Context, IERC20, Ownable {
391     using SafeMath for uint256;
392     using Address for address;
393 
394     mapping (address => uint256) private _rOwned;
395     mapping (address => uint256) private _tOwned;
396     mapping (address => mapping (address => uint256)) private _allowances;
397 
398     mapping (address => bool) private _isExcluded;
399     address[] private _excluded;
400 
401     uint256 private constant MAX = ~uint256(0);
402     uint256 private constant _tTotal = 1000000000 * 10**6 * 10**9;
403     uint256 private _rTotal = (MAX - (MAX % _tTotal));
404     uint256 private _tFeeTotal;
405 
406     string private _name = 'Pomeranian Inu';
407     string private _symbol = 'POGE';
408     uint8 private _decimals = 9;
409 
410     uint256 public _maxTxAmount = 10000000 * 10**6 * 10**9;
411 
412     constructor () public {
413         _rOwned[_msgSender()] = _rTotal;
414         emit Transfer(address(0), _msgSender(), _tTotal);
415     }
416 
417     function name() public view returns (string memory) {
418         return _name;
419     }
420 
421     function symbol() public view returns (string memory) {
422         return _symbol;
423     }
424 
425     function decimals() public view returns (uint8) {
426         return _decimals;
427     }
428 
429     function totalSupply() public view override returns (uint256) {
430         return _tTotal;
431     }
432 
433     function balanceOf(address account) public view override returns (uint256) {
434         if (_isExcluded[account]) return _tOwned[account];
435         return tokenFromReflection(_rOwned[account]);
436     }
437 
438     function transfer(address recipient, uint256 amount) public override returns (bool) {
439         _transfer(_msgSender(), recipient, amount);
440         return true;
441     }
442 
443     function allowance(address owner, address spender) public view override returns (uint256) {
444         return _allowances[owner][spender];
445     }
446 
447     function approve(address spender, uint256 amount) public override returns (bool) {
448         _approve(_msgSender(), spender, amount);
449         return true;
450     }
451 
452     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
453         _transfer(sender, recipient, amount);
454         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
455         return true;
456     }
457 
458     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
459         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
460         return true;
461     }
462 
463     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
464         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
465         return true;
466     }
467 
468     function isExcluded(address account) public view returns (bool) {
469         return _isExcluded[account];
470     }
471 
472     function totalFees() public view returns (uint256) {
473         return _tFeeTotal;
474     }
475 
476 
477     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
478         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
479             10**2
480         );
481     }
482 
483     function reflect(uint256 tAmount) public {
484         address sender = _msgSender();
485         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
486         (uint256 rAmount,,,,) = _getValues(tAmount);
487         _rOwned[sender] = _rOwned[sender].sub(rAmount);
488         _rTotal = _rTotal.sub(rAmount);
489         _tFeeTotal = _tFeeTotal.add(tAmount);
490     }
491 
492     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
493         require(tAmount <= _tTotal, "Amount must be less than supply");
494         if (!deductTransferFee) {
495             (uint256 rAmount,,,,) = _getValues(tAmount);
496             return rAmount;
497         } else {
498             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
499             return rTransferAmount;
500         }
501     }
502 
503     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
504         require(rAmount <= _rTotal, "Amount must be less than total reflections");
505         uint256 currentRate =  _getRate();
506         return rAmount.div(currentRate);
507     }
508 
509     function excludeAccount(address account) external onlyOwner() {
510         require(!_isExcluded[account], "Account is already excluded");
511         if(_rOwned[account] > 0) {
512             _tOwned[account] = tokenFromReflection(_rOwned[account]);
513         }
514         _isExcluded[account] = true;
515         _excluded.push(account);
516     }
517 
518     function includeAccount(address account) external onlyOwner() {
519         require(_isExcluded[account], "Account is already excluded");
520         for (uint256 i = 0; i < _excluded.length; i++) {
521             if (_excluded[i] == account) {
522                 _excluded[i] = _excluded[_excluded.length - 1];
523                 _tOwned[account] = 0;
524                 _isExcluded[account] = false;
525                 _excluded.pop();
526                 break;
527             }
528         }
529     }
530 
531     function _approve(address owner, address spender, uint256 amount) private {
532         require(owner != address(0), "ERC20: approve from the zero address");
533         require(spender != address(0), "ERC20: approve to the zero address");
534 
535         _allowances[owner][spender] = amount;
536         emit Approval(owner, spender, amount);
537     }
538 
539     function _transfer(address sender, address recipient, uint256 amount) private {
540         require(sender != address(0), "ERC20: transfer from the zero address");
541         require(recipient != address(0), "ERC20: transfer to the zero address");
542         require(amount > 0, "Transfer amount must be greater than zero");
543         if(sender != owner() && recipient != owner())
544           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
545 
546         if (_isExcluded[sender] && !_isExcluded[recipient]) {
547             _transferFromExcluded(sender, recipient, amount);
548         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
549             _transferToExcluded(sender, recipient, amount);
550         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
551             _transferStandard(sender, recipient, amount);
552         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
553             _transferBothExcluded(sender, recipient, amount);
554         } else {
555             _transferStandard(sender, recipient, amount);
556         }
557     }
558 
559     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
560         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
561         _rOwned[sender] = _rOwned[sender].sub(rAmount);
562         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
563         _reflectFee(rFee, tFee);
564         emit Transfer(sender, recipient, tTransferAmount);
565     }
566 
567     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
568         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
569         _rOwned[sender] = _rOwned[sender].sub(rAmount);
570         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
571         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
572         _reflectFee(rFee, tFee);
573         emit Transfer(sender, recipient, tTransferAmount);
574     }
575 
576     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
577         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
578         _tOwned[sender] = _tOwned[sender].sub(tAmount);
579         _rOwned[sender] = _rOwned[sender].sub(rAmount);
580         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
581         _reflectFee(rFee, tFee);
582         emit Transfer(sender, recipient, tTransferAmount);
583     }
584 
585     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
586         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
587         _tOwned[sender] = _tOwned[sender].sub(tAmount);
588         _rOwned[sender] = _rOwned[sender].sub(rAmount);
589         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
590         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
591         _reflectFee(rFee, tFee);
592         emit Transfer(sender, recipient, tTransferAmount);
593     }
594 
595     function _reflectFee(uint256 rFee, uint256 tFee) private {
596         _rTotal = _rTotal.sub(rFee);
597         _tFeeTotal = _tFeeTotal.add(tFee);
598     }
599 
600     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
601         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
602         uint256 currentRate =  _getRate();
603         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
604         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
605     }
606 
607     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
608         uint256 tFee = tAmount.div(100).mul(0);
609         uint256 tTransferAmount = tAmount.sub(tFee);
610         return (tTransferAmount, tFee);
611     }
612 
613     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
614         uint256 rAmount = tAmount.mul(currentRate);
615         uint256 rFee = tFee.mul(currentRate);
616         uint256 rTransferAmount = rAmount.sub(rFee);
617         return (rAmount, rTransferAmount, rFee);
618     }
619 
620     function _getRate() private view returns(uint256) {
621         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
622         return rSupply.div(tSupply);
623     }
624 
625     function _getCurrentSupply() private view returns(uint256, uint256) {
626         uint256 rSupply = _rTotal;
627         uint256 tSupply = _tTotal;
628         for (uint256 i = 0; i < _excluded.length; i++) {
629             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
630             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
631             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
632         }
633         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
634         return (rSupply, tSupply);
635     }
636 }