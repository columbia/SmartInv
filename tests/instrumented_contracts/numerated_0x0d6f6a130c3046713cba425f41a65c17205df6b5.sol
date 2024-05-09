1 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
2 //++++++++++++++++++++++++++++++++++++++++++++oyhhhso++++++++++++++++++++++++++o++++++++++++++++++++++
3 //++++++++++++++++++++++shhhhysoo++++++++++++sms/:+yds++++++++++++++++++++osyhhhyyyo++++++++++++++++++
4 //+++++++++++++++++++++oN+::/+oyhhso++++++++sm+-``--/dho+++++++++++++++++odh/:---:+hho++++++++++++++++
5 //+++++++++++++++++++++hm-.``.--:ohmyyyyyyyhN+-`  `.-:ydoooossssoooooo+++yN:----os:-sd++++++++++++++++
6 //+++++++++++++++++++++hd-` `./syyyso++////ms-.     .--hNyssssssssyyhhhhyhN-----:ds-.Ns+++++++++++++++
7 //+++++++++++++++++++++yN::oyyo/----------:s--.     `--:mo------------:/+sms:---:ds-`Ns+++++++++++++++
8 //+++++++++++++++++++++oMhy+-------------------.``   `--om----------------:yhsshdo-.sm++++++++++++++++
9 //++++++++++++++++++++sdy:------------------------....---N+------------------//sdsydy+++++++++++++++++
10 //+++++++++++++++++++ym/---------------------------------ds---------------------:ymo++++++++++++++++++
11 //++++++++++++++++++hm:..--------------------------------hm/----------------------+Ns+++++++++++++++++
12 //+++++++++++++++++yN:    -------.``.--------------------yymo----------------------/No++++++++++++++++
13 //++++++++++++++++oN+--...------.    .---------------------:dy----------------------yd++++++++++++++++
14 //+++++++++++++++oddds+oyh/------...------------------------:dy---------------------+N++++++++++++++++
15 //++++++++++++++ym:.+mNy:-------so:--/sh/--------------------:mo--------------------oN++++++++++++++++
16 //+++++++++++++ym.oNMMMMNs.``.--:syyys+:-------------......---om------:d:-----------dh++++++++++++++++
17 //+++++++++++++m+ NMMMMMMMm    `.---------------..`         `.+N------om-----------sNo++++++++++++++++
18 //+++++++++++++m+ dMMMMMMN/       `.-------..``               sd------yh----------+myyhy++++++++++++++
19 //+++++++++++++sm-mymMMdo.      `.                           +msys+/++hd----------h/. `yd+++++++++++++
20 //+++++++++++++odmMo.+N-       .d/                        `:hy:::/hs//sM+-------------.+N+++++++++++++
21 //++++++++++++++oydmmmysso+::/shmo                     .:oys/-----.    hNs/:---:/+oyhdhyo+++++++++++++
22 //++++++++++++++++osydddysMhohy/hs               .-:+syso/:--------   -mNNmddddddhhyso++++++++++++++++
23 //+++++++++++++++++++oosyhddddmmNo+///:///++osyhddmNNmmdyso++//////:+ydhyyysssooo+++++++++++++++++++++
24 //+++++++++++++++++++++++++oooosssyyyyhhhhhhhhyyyyyyyyyyyyyhyyyyyyyysooo++++++++++++++++++++++++++++++
25 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
26 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
27 
28 //TG: https://t.me/BabyAkitaCrypto
29 
30 //Website: http://akita.baby
31 
32 // SPDX-License-Identifier: Unlicensed
33 
34 pragma solidity ^0.6.12;    
35 
36 abstract contract Context {
37     
38     function _msgSender() internal view virtual returns (address payable) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes memory) {
43         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
44         return msg.data;
45     }
46 }
47 
48 interface IERC20 {
49     /**
50      * @dev Returns the amount of tokens in existence.
51      */
52     function totalSupply() external view returns (uint256);
53 
54     /**
55      * @dev Returns the amount of tokens owned by `account`.
56      */
57     function balanceOf(address account) external view returns (uint256);
58 
59     /**
60      * @dev Moves `amount` tokens from the caller's account to `recipient`.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.s
63      *
64      * Emits a {Transfer} event.
65      */
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Returns the remaining number of tokens that `spender` will be
70      * allowed to spend on behalf of `owner` through {transferFrom}. This is
71      * zero by default.
72      *
73      * This value changes when {approve} or {transferFrom} are called.
74      */
75     function allowance(address owner, address spender) external view returns (uint256);
76 
77     /**
78      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * IMPORTANT: Beware that changing an allowance with this method brings the risk
83      * that someone may use both the old and the new allowance by unfortunate
84      * transaction ordering. One possible solution to mitigate this race
85      * condition is to first reduce the spender's allowance to 0 and set the
86      * desired value afterwards:
87      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88      *
89      * Emits an {Approval} event.
90      */
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Moves `amount` tokens from `sender` to `recipient` using the
95      * allowance mechanism. `amount` is then deducted from the caller's
96      * allowance.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
103 
104     /**
105      * @dev Emitted when `value` tokens are moved from one account (`from`) to
106      * another (`to`).
107      *
108      * Note that `value` may be zero.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     /**
113      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
114      * a call to {approve}. `value` is the new allowance.
115      */
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      *
128      * - Addition cannot overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      *
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 library Address {
263     /**
264      * @dev Returns true if `account` is a contract.
265      *
266      * [IMPORTANT]
267      * ====
268      * It is unsafe to assume that an address for which this function returns
269      * false is an externally-owned account (EOA) and not a contract.
270      *
271      * Among others, `isContract` will return false for the following
272      * types of addresses:
273      *
274      *  - an externally-owned account
275      *  - a contract in construction
276      *  - an address where a contract will be created
277      *  - an address where a contract lived, but was destroyed
278      * ====
279      */
280     function isContract(address account) internal view returns (bool) {
281         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
282         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
283         // for accounts without code, i.e. `keccak256('')`
284         bytes32 codehash;
285         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
286         // solhint-disable-next-line no-inline-assembly
287         assembly { codehash := extcodehash(account) }
288         return (codehash != accountHash && codehash != 0x0);
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
311         (bool success, ) = recipient.call{ value: amount }("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 
315     /**
316      * @dev Performs a Solidity function call using a low level `call`. A
317      * plain`call` is an unsafe replacement for a function call: use this
318      * function instead.
319      *
320      * If `target` reverts with a revert reason, it is bubbled up by this
321      * function (like regular Solidity function calls).
322      *
323      * Returns the raw returned data. To convert to the expected return value,
324      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
325      *
326      * Requirements:
327      *
328      * - `target` must be a contract.
329      * - calling `target` with `data` must not revert.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
334       return functionCall(target, data, "Address: low-level call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
339      * `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
344         return _functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but also transferring `value` wei to `target`.
350      *
351      * Requirements:
352      *
353      * - the calling contract must have an ETH balance of at least `value`.
354      * - the called Solidity function must be `payable`.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364      * with `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         return _functionCallWithValue(target, data, value, errorMessage);
371     }
372 
373     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
374         require(isContract(target), "Address: call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 // solhint-disable-next-line no-inline-assembly
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 
397 contract Ownable is Context {
398     address private _owner;
399 
400     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
401 
402     /**
403      * @dev Initializes the contract setting the deployer as the initial owner.
404      */
405     constructor () internal {
406         address msgSender = _msgSender();
407         _owner = msgSender;
408         emit OwnershipTransferred(address(0), msgSender);
409     }
410 
411     /**
412      * @dev Returns the address of the current owner.
413      */
414     function owner() public view returns (address) {
415         return _owner;
416     }
417 
418     /**
419      * @dev Throws if called by any account other than the owner.
420      */
421     modifier onlyOwner() {
422         require(_owner == _msgSender(), "Ownable: caller is not the owner");
423         _;
424     }
425 
426     /**
427      * @dev Leaves the contract without owner. It will not be possible to call
428      * `onlyOwner` functions anymore. Can only be called by the current owner.
429      *
430      * NOTE: Renouncing ownership will leave the contract without an owner,
431      * thereby removing any functionality that is only available to the owner.
432      */
433     function renounceOwnership() public virtual onlyOwner {
434         emit OwnershipTransferred(_owner, address(0));
435         _owner = address(0);
436     }
437 
438     /**
439      * @dev Transfers ownership of the contract to a new account (`newOwner`).
440      * Can only be called by the current owner.
441      */
442     function transferOwnership(address newOwner) public virtual onlyOwner {
443         require(newOwner != address(0), "Ownable: new owner is the zero address");
444         emit OwnershipTransferred(_owner, newOwner);
445         _owner = newOwner;
446     }
447 }
448 
449 
450 
451 contract BabyAkita is Context, IERC20, Ownable {
452     using SafeMath for uint256;
453     using Address for address;
454 
455     mapping (address => uint256) private _rOwned;
456     mapping (address => uint256) private _tOwned;
457     mapping (address => mapping (address => uint256)) private _allowances;
458 
459     mapping (address => bool) private _isExcluded;
460     address[] private _excluded;
461    
462     uint256 private constant MAX = ~uint256(0);
463     uint256 private constant _tTotal = 10000000 * 10**5 * 10**9;
464     uint256 private _rTotal = (MAX - (MAX % _tTotal));
465     uint256 private _tFeeTotal;
466 
467     string private _name = 'Baby Akita';
468     string private _symbol = 'BKITA';
469     uint8 private _decimals = 9;
470     
471     uint256 public _maxTxAmount = 10000000 * 10**5 * 10**9;
472 
473     constructor () public {
474         _rOwned[_msgSender()] = _rTotal;
475         emit Transfer(address(0), _msgSender(), _tTotal);
476     }
477 
478     function name() public view returns (string memory) {
479         return _name;
480     }
481 
482     function symbol() public view returns (string memory) {
483         return _symbol;
484     }
485 
486     function decimals() public view returns (uint8) {
487         return _decimals;
488     }
489 
490     function totalSupply() public view override returns (uint256) {
491         return _tTotal;
492     }
493 
494     function balanceOf(address account) public view override returns (uint256) {
495         if (_isExcluded[account]) return _tOwned[account];
496         return tokenFromReflection(_rOwned[account]);
497     }
498 
499     function transfer(address recipient, uint256 amount) public override returns (bool) {
500         _transfer(_msgSender(), recipient, amount);
501         return true;
502     }
503 
504     function allowance(address owner, address spender) public view override returns (uint256) {
505         return _allowances[owner][spender];
506     }
507 
508     function approve(address spender, uint256 amount) public override returns (bool) {
509         _approve(_msgSender(), spender, amount);
510         return true;
511     }
512 
513     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
514         _transfer(sender, recipient, amount);
515         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
516         return true;
517     }
518 
519     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
520         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
521         return true;
522     }
523 
524     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
525         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
526         return true;
527     }
528 
529     function isExcluded(address account) public view returns (bool) {
530         return _isExcluded[account];
531     }
532 
533     function totalFees() public view returns (uint256) {
534         return _tFeeTotal;
535     }
536     
537     
538     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
539         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
540             10**2
541         );
542     }
543 
544     function reflect(uint256 tAmount) public {
545         address sender = _msgSender();
546         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
547         (uint256 rAmount,,,,) = _getValues(tAmount);
548         _rOwned[sender] = _rOwned[sender].sub(rAmount);
549         _rTotal = _rTotal.sub(rAmount);
550         _tFeeTotal = _tFeeTotal.add(tAmount);
551     }
552 
553     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
554         require(tAmount <= _tTotal, "Amount must be less than supply");
555         if (!deductTransferFee) {
556             (uint256 rAmount,,,,) = _getValues(tAmount);
557             return rAmount;
558         } else {
559             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
560             return rTransferAmount;
561         }
562     }
563 
564     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
565         require(rAmount <= _rTotal, "Amount must be less than total reflections");
566         uint256 currentRate =  _getRate();
567         return rAmount.div(currentRate);
568     }
569 
570     function excludeAccount(address account) external onlyOwner() {
571         require(!_isExcluded[account], "Account is already excluded");
572         if(_rOwned[account] > 0) {
573             _tOwned[account] = tokenFromReflection(_rOwned[account]);
574         }
575         _isExcluded[account] = true;
576         _excluded.push(account);
577     }
578 
579     function includeAccount(address account) external onlyOwner() {
580         require(_isExcluded[account], "Account is already excluded");
581         for (uint256 i = 0; i < _excluded.length; i++) {
582             if (_excluded[i] == account) {
583                 _excluded[i] = _excluded[_excluded.length - 1];
584                 _tOwned[account] = 0;
585                 _isExcluded[account] = false;
586                 _excluded.pop();
587                 break;
588             }
589         }
590     }
591 
592     function _approve(address owner, address spender, uint256 amount) private {
593         require(owner != address(0), "ERC20: approve from the zero address");
594         require(spender != address(0), "ERC20: approve to the zero address");
595 
596         _allowances[owner][spender] = amount;
597         emit Approval(owner, spender, amount);
598     }
599 
600     function _transfer(address sender, address recipient, uint256 amount) private {
601         require(sender != address(0), "ERC20: transfer from the zero address");
602         require(recipient != address(0), "ERC20: transfer to the zero address");
603         require(amount > 0, "Transfer amount must be greater than zero");
604         if(sender != owner() && recipient != owner())
605           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
606             
607         if (_isExcluded[sender] && !_isExcluded[recipient]) {
608             _transferFromExcluded(sender, recipient, amount);
609         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
610             _transferToExcluded(sender, recipient, amount);
611         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
612             _transferStandard(sender, recipient, amount);
613         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
614             _transferBothExcluded(sender, recipient, amount);
615         } else {
616             _transferStandard(sender, recipient, amount);
617         }
618     }
619 
620     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
621         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
622         _rOwned[sender] = _rOwned[sender].sub(rAmount);
623         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
624         _reflectFee(rFee, tFee);
625         emit Transfer(sender, recipient, tTransferAmount);
626     }
627 
628     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
629         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
630         _rOwned[sender] = _rOwned[sender].sub(rAmount);
631         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
632         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
633         _reflectFee(rFee, tFee);
634         emit Transfer(sender, recipient, tTransferAmount);
635     }
636 
637     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
638         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
639         _tOwned[sender] = _tOwned[sender].sub(tAmount);
640         _rOwned[sender] = _rOwned[sender].sub(rAmount);
641         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
642         _reflectFee(rFee, tFee);
643         emit Transfer(sender, recipient, tTransferAmount);
644     }
645 
646     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
647         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
648         _tOwned[sender] = _tOwned[sender].sub(tAmount);
649         _rOwned[sender] = _rOwned[sender].sub(rAmount);
650         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
651         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
652         _reflectFee(rFee, tFee);
653         emit Transfer(sender, recipient, tTransferAmount);
654     }
655 
656     function _reflectFee(uint256 rFee, uint256 tFee) private {
657         _rTotal = _rTotal.sub(rFee);
658         _tFeeTotal = _tFeeTotal.add(tFee);
659     }
660 
661     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
662         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
663         uint256 currentRate =  _getRate();
664         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
665         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
666     }
667 
668     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
669         uint256 tFee = tAmount.div(100).mul(2);
670         uint256 tTransferAmount = tAmount.sub(tFee);
671         return (tTransferAmount, tFee);
672     }
673 
674     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
675         uint256 rAmount = tAmount.mul(currentRate);
676         uint256 rFee = tFee.mul(currentRate);
677         uint256 rTransferAmount = rAmount.sub(rFee);
678         return (rAmount, rTransferAmount, rFee);
679     }
680 
681     function _getRate() private view returns(uint256) {
682         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
683         return rSupply.div(tSupply);
684     }
685 
686     function _getCurrentSupply() private view returns(uint256, uint256) {
687         uint256 rSupply = _rTotal;
688         uint256 tSupply = _tTotal;      
689         for (uint256 i = 0; i < _excluded.length; i++) {
690             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
691             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
692             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
693         }
694         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
695         return (rSupply, tSupply);
696     }
697 }