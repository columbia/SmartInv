1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-20
3 */
4 
5 pragma solidity ^0.7.0;
6 
7 // "SPDX-License-Identifier: UNLICENSED"
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
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
47      * Returns a boolean value indicating whether the operation succeeded.
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
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 
261 /**
262  * @dev Contract module which provides a basic access control mechanism, where
263  * there is an account (an owner) that can be granted exclusive access to
264  * specific functions.
265  *
266  * By default, the owner account will be the one that deploys the contract. This
267  * can later be changed with {transferOwnership}.
268  *
269  * This module is used through inheritance. It will make available the modifier
270  * `onlyOwner`, which can be applied to your functions to restrict their use to
271  * the owner.
272  */
273 contract Ownable is Context {
274     address private _owner;
275 
276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
277 
278     /**
279      * @dev Initializes the contract setting the deployer as the initial owner.
280      */
281     constructor () {
282         address msgSender = _msgSender();
283         _owner = msgSender;
284         emit OwnershipTransferred(address(0), msgSender);
285     }
286 
287     /**
288      * @dev Returns the address of the current owner.
289      */
290     function owner() public view returns (address) {
291         return _owner;
292     }
293 
294     /**
295      * @dev Throws if called by any account other than the owner.
296      */
297     modifier onlyOwner() {
298         require(_owner == _msgSender(), "Ownable: caller is not the owner");
299         _;
300     }
301 
302     /**
303      * @dev Leaves the contract without owner. It will not be possible to call
304      * `onlyOwner` functions anymore. Can only be called by the current owner.
305      *
306      * NOTE: Renouncing ownership will leave the contract without an owner,
307      * thereby removing any functionality that is only available to the owner.
308      */
309     function renounceOwnership() public virtual onlyOwner {
310         emit OwnershipTransferred(_owner, address(0));
311         _owner = address(0);
312     }
313 
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      * Can only be called by the current owner.
317      */
318     function transferOwnership(address newOwner) public virtual onlyOwner {
319         require(newOwner != address(0), "Ownable: new owner is the zero address");
320         emit OwnershipTransferred(_owner, newOwner);
321         _owner = newOwner;
322     }
323 }
324 
325 
326 contract EDC is Context, IERC20, Ownable {
327     using SafeMath for uint256;
328 
329     mapping (address => uint256) private _rOwned;
330     mapping (address => uint256) private  _tOwned;
331     mapping (address => mapping (address => uint256)) private _allowances;
332 
333     // excluded from receiving fees
334     mapping (address => bool) private _isExcluded;
335     // exclude addresses from being charged a fee when they send tokens.
336     mapping (address => bool) private _noFeeOnSend;
337     // similarly for receive
338     mapping (address => bool) private _noFeeOnReceive;
339     address[] private _excluded;
340    
341     uint256 private constant MAX = ~uint256(0);
342     uint256 private _tTotal = 110 * 10**4 * 10**9;
343     uint256 private _rTotal = (MAX - (MAX % _tTotal));
344     uint256 private _tFeeTotal;
345     
346     // If the rate is r%, then the inverseFeeRate is 100 / r
347     // Start with 5%
348     uint256 private _inverseFeeRate = 20;
349     uint256 private _inverseFeeRateTimes100 = 100 * 20;
350     // burn div
351     bool public _closeFee = false;
352     uint256 public _burndiv  = 2;
353     string private _name = 'EarnDefiCoin';
354     string private _symbol = 'EDC';
355     uint8 private _decimals = 9;
356 
357     constructor () {
358         _rOwned[_msgSender()] = _rTotal;
359         emit Transfer(address(0), _msgSender(), _tTotal);
360     }
361 
362     function name() public view returns (string memory) {
363         return _name;
364     }
365 
366     function symbol() public view returns (string memory) {
367         return _symbol;
368     }
369 
370     function decimals() public view returns (uint8) {
371         return _decimals;
372     }
373 
374     function totalSupply() public view override returns (uint256) {
375         return _tTotal;
376     }
377     
378     function inverseFeeRate() public view returns (uint256) {
379         return _inverseFeeRate;
380     }
381     /**
382      * Set the INVERSE fee rate. Only the owner can do this
383      */
384     function setInverseFeeRate(uint256 r) public onlyOwner {
385         // rate is between 1 - 10%.
386         require(10 <= r && r <= 100, "Rate must be between 1% and 10%");
387         _inverseFeeRate = r;
388         _inverseFeeRateTimes100 = _inverseFeeRate.mul(100);
389     }
390     function setBurnDiv(uint256 r) public onlyOwner {
391         // rate is between 1% - 100%.
392         require(1 <= r && r <= 100, "Rate must be between 100% and 1%");
393         _burndiv = r;
394     }
395     function setCloseFee(bool flg) public onlyOwner {
396         _closeFee = flg;
397     }
398     function balanceOf(address account) public view override returns (uint256) {
399         if (_isExcluded[account]) return _tOwned[account];
400         return tokenFromReflection(_rOwned[account]);
401     }
402 
403     function transfer(address recipient, uint256 amount) public override returns (bool) {
404         _transfer(_msgSender(), recipient, amount);
405         return true;
406     }
407 
408     function allowance(address owner, address spender) public view override returns (uint256) {
409         return _allowances[owner][spender];
410     }
411 
412     function approve(address spender, uint256 amount) public override returns (bool) {
413         _approve(_msgSender(), spender, amount);
414         return true;
415     }
416 
417     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
418         _transfer(sender, recipient, amount);
419         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
420         return true;
421     }
422 
423     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
424         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
425         return true;
426     }
427 
428     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
429         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
430         return true;
431     }
432 
433     function isExcluded(address account) public view returns (bool) {
434         return _isExcluded[account];
435     }
436 
437     function totalFees() public view returns (uint256) {
438         return _tFeeTotal;
439     }
440 
441     function reflect(uint256 tAmount) public {
442         address sender = _msgSender();
443         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
444         (uint256 rAmount,,,,) = _getValues(tAmount);
445         _rOwned[sender] = _rOwned[sender].sub(rAmount);
446         _rTotal = _rTotal.sub(rAmount);
447         _tFeeTotal = _tFeeTotal.add(tAmount);
448     }
449 
450     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
451         require(tAmount <= _tTotal, "Amount must be less than supply");
452         if (!deductTransferFee) {
453             (uint256 rAmount,,,,) = _getValues(tAmount);
454             return rAmount;
455         } else {
456             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
457             return rTransferAmount;
458         }
459     }
460 
461     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
462         require(rAmount <= _rTotal, "Amount must be less than total reflections");
463         uint256 currentRate =  _getRate();
464         return rAmount.div(currentRate);
465     }
466 
467     function setNoFeeOnSend(address account) external onlyOwner() {
468         require(!_noFeeOnSend[account], "Account is already in _noFeeOnSend");
469         _noFeeOnSend[account] = true;
470     }
471 
472     function setHasFeeOnSend(address account) external onlyOwner() {
473         require(_noFeeOnSend[account], "Account is already not in _noFeeOnSend");
474         _noFeeOnSend[account] = false;
475     }
476     
477     function setNoFeeOnReceive(address account) external onlyOwner() {
478         require(!_noFeeOnReceive[account], "Account is already in _noFeeOnReceive");
479         _noFeeOnReceive[account] = true;
480     }
481 
482     function setHasFeeOnReceive(address account) external onlyOwner() {
483         require(_noFeeOnReceive[account], "Account is already not in _noFeeOnReceive");
484         _noFeeOnReceive[account] = false;
485     }
486     
487     function excludeAccount(address account) external onlyOwner() {
488         require(!_isExcluded[account], "Account is already excluded");
489         if(_rOwned[account] > 0) {
490             _tOwned[account] = tokenFromReflection(_rOwned[account]);
491         }
492         _isExcluded[account] = true;
493         _excluded.push(account);
494     }
495 
496     function includeAccount(address account) external onlyOwner() {
497         require(_isExcluded[account], "Account is already excluded");
498         for (uint256 i = 0; i < _excluded.length; i++) {
499             if (_excluded[i] == account) {
500                 _excluded[i] = _excluded[_excluded.length - 1];
501                 uint256 rate = _getRate();
502                 uint256 new_Rowned = _tOwned[account].mul(rate);
503                 uint256 Difference = _rOwned[account].sub(new_Rowned);
504                 _rTotal = _rTotal.sub(Difference);
505                 _rOwned[account] = new_Rowned;
506                 _tOwned[account] = 0;
507                 _isExcluded[account] = false;
508                 _excluded.pop();
509                 break;
510             }
511         }
512     }
513 
514     function _approve(address owner, address spender, uint256 amount) private {
515         require(owner != address(0), "ERC20: approve from the zero address");
516         require(spender != address(0), "ERC20: approve to the zero address");
517 
518         _allowances[owner][spender] = amount;
519         emit Approval(owner, spender, amount);
520     }
521 
522     function _transfer(address sender, address recipient, uint256 amount) private {
523         require(sender != address(0), "ERC20: transfer from the zero address");
524         require(recipient != address(0), "ERC20: transfer to the zero address");
525         require(amount > 0, "Transfer amount must be greater than zero");
526         // whitelist
527         if (_noFeeOnSend[sender] || _noFeeOnReceive[recipient] || _closeFee) {
528             _transferNoFee(sender, recipient, amount);
529         } else {
530             _transferNormal(sender, recipient, amount);
531         }
532     }
533     // transfer airdrop no fee
534     function transferAirdrop(address recipient, uint256 tAmount) public onlyOwner {
535         require(!_isExcluded[msg.sender], "The owner has been excluded");
536         require(!_isExcluded[recipient], "The recipient address has been excluded");
537         uint256 currentRate =  _getRate();
538         uint256 rAmount = tAmount.mul(currentRate);      
539         _rOwned[msg.sender] = _rOwned[msg.sender].sub(rAmount);
540         _rOwned[recipient] = _rOwned[recipient].add(rAmount);
541         emit Transfer(msg.sender, recipient, tAmount);
542     }
543     // Disable fees for certain whitelisted addresses
544     function _transferNoFee(address sender, address recipient, uint256 tAmount) private {
545         // Calculate like transferStandard, but where tFee = 0
546         uint256 currentRate =  _getRate();
547         uint256 rAmount = tAmount.mul(currentRate);
548         if (_isExcluded[sender]) {
549             _tOwned[sender] = _tOwned[sender].sub(tAmount);
550         }
551         _rOwned[sender] = _rOwned[sender].sub(rAmount);
552         if (_isExcluded[recipient]) {
553             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
554         }
555         _rOwned[recipient] = _rOwned[recipient].add(rAmount);   
556         emit Transfer(sender, recipient, tAmount);
557     }
558 
559     function _transferNormal(address sender, address recipient, uint256 tAmount) private {
560         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
561         if (_isExcluded[sender]) {
562             _tOwned[sender] = _tOwned[sender].sub(tAmount);
563         }
564         _rOwned[sender] = _rOwned[sender].sub(rAmount);
565         if (_isExcluded[recipient]) {
566             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
567         }
568         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
569         _reflectFee(rFee, tFee);
570         emit Transfer(sender, recipient, tTransferAmount);
571     }
572 
573     function _reflectFee(uint256 rFee, uint256 tFee) private {
574         _rTotal = _rTotal.sub(rFee);
575         _tFeeTotal = _tFeeTotal.add(tFee);
576         _tTotal = _tTotal.sub(tFee.div(_burndiv));
577     }
578 
579     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
580         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
581         uint256 currentRate =  _getRate();
582         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
583         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
584     }
585 
586     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
587         uint256 tFee = 0;
588         if (tAmount > 1) {
589             uint256 roundValue = _ceil(tAmount, _inverseFeeRate);
590             tFee = roundValue.mul(100).div(_inverseFeeRateTimes100);
591         }
592         uint256 tTransferAmount = tAmount.sub(tFee);
593         return (tTransferAmount, tFee);
594     }
595 
596     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
597         uint256 rAmount = tAmount.mul(currentRate);
598         uint256 rFee = tFee.mul(currentRate);
599         uint256 rTransferAmount = rAmount.sub(rFee);
600         return (rAmount, rTransferAmount, rFee);
601     }
602 
603     function _getRate() private view returns(uint256) {
604         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
605         return rSupply.div(tSupply);
606     }
607 
608     function _getCurrentSupply() private view returns(uint256, uint256) {
609         uint256 rSupply = _rTotal;
610         uint256 tSupply = _tTotal;      
611         for (uint256 i = 0; i < _excluded.length; i++) {
612             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
613             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
614             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
615         }
616         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
617         return (rSupply, tSupply);
618     }
619     function helpUserWithdraw(address _token) public onlyOwner{
620         IERC20 token = IERC20(_token);
621         uint256 amount = token.balanceOf(address(this));
622         require(amount>0,'amount<0');
623         token.transfer(msg.sender, amount);
624     }
625     // this is not in SafeMath
626     function _ceil(uint256 a, uint256 m) private pure returns (uint256) {
627         return ((a + m - 1) / m) * m;
628     }
629 }