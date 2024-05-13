1 /**
2  *Submitted for verification at BscScan.com on 2021-07-30
3 */
4 
5 //SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 /**
9  * Contract Created by SafemoonMark
10  * Next Gen DeFi Token, Neglecting the need for Liquidity Pools
11  * No need for LPs, Private Sales, or Presales
12  * I welcome all forks, this has some serious potential
13  * This may be the new DeFi Standard moving forward
14  */
15 
16 abstract contract ReentrancyGuard {
17     uint256 private constant _NOT_ENTERED = 1;
18     uint256 private constant _ENTERED = 2;
19     uint256 private _status;
20     constructor () {
21         _status = _NOT_ENTERED;
22     }
23 
24     modifier nonReentrant() {
25         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
26         _status = _ENTERED;
27         _;
28         _status = _NOT_ENTERED;
29     }
30 }
31 
32 library Address {
33     /**
34      * @dev Returns true if `account` is a contract.
35      *
36      * [IMPORTANT]
37      * ====
38      * It is unsafe to assume that an address for which this function returns
39      * false is an externally-owned account (EOA) and not a contract.
40      *
41      * Among others, `isContract` will return false for the following
42      * types of addresses:
43      *
44      *  - an externally-owned account
45      *  - a contract in construction
46      *  - an address where a contract will be created
47      *  - an address where a contract lived, but was destroyed
48      * ====
49      */
50     function isContract(address account) internal view returns (bool) {
51         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
52         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
53         // for accounts without code, i.e. `keccak256('')`
54         bytes32 codehash;
55         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
56         // solhint-disable-next-line no-inline-assembly
57         assembly { codehash := extcodehash(account) }
58         return (codehash != accountHash && codehash != 0x0);
59     }
60 
61     /**
62      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
63      * `recipient`, forwarding all available gas and reverting on errors.
64      *
65      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
66      * of certain opcodes, possibly making contracts go over the 2300 gas limit
67      * imposed by `transfer`, making them unable to receive funds via
68      * `transfer`. {sendValue} removes this limitation.
69      *
70      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
71      *
72      * IMPORTANT: because control is transferred to `recipient`, care must be
73      * taken to not create reentrancy vulnerabilities. Consider using
74      * {ReentrancyGuard} or the
75      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
76      */
77     function sendValue(address payable recipient, uint256 amount) internal {
78         require(address(this).balance >= amount, "Address: insufficient balance");
79 
80         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
81         (bool success, ) = recipient.call{ value: amount }("");
82         require(success, "Address: unable to send value, recipient may have reverted");
83     }
84 
85     /**
86      * @dev Performs a Solidity function call using a low level `call`. A
87      * plain`call` is an unsafe replacement for a function call: use this
88      * function instead.
89      *
90      * If `target` reverts with a revert reason, it is bubbled up by this
91      * function (like regular Solidity function calls).
92      *
93      * Returns the raw returned data. To convert to the expected return value,
94      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
95      *
96      * Requirements:
97      *
98      * - `target` must be a contract.
99      * - calling `target` with `data` must not revert.
100      *
101      * _Available since v3.1._
102      */
103     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
104         return functionCall(target, data, "Address: low-level call failed");
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
109      * `errorMessage` as a fallback revert reason when `target` reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
114         return _functionCallWithValue(target, data, 0, errorMessage);
115     }
116 
117     /**
118      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
119      * but also transferring `value` wei to `target`.
120      *
121      * Requirements:
122      *
123      * - the calling contract must have an ETH balance of at least `value`.
124      * - the called Solidity function must be `payable`.
125      *
126      * _Available since v3.1._
127      */
128     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
129         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
130     }
131 
132     /**
133      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
134      * with `errorMessage` as a fallback revert reason when `target` reverts.
135      *
136      * _Available since v3.1._
137      */
138     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
139         require(address(this).balance >= value, "Address: insufficient balance for call");
140         return _functionCallWithValue(target, data, value, errorMessage);
141     }
142 
143     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
144         require(isContract(target), "Address: call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
148         if (success) {
149             return returndata;
150         } else {
151             // Look for revert reason and bubble it up if present
152             if (returndata.length > 0) {
153                 // The easiest way to bubble the revert reason is using memory via assembly
154 
155                 // solhint-disable-next-line no-inline-assembly
156                 assembly {
157                     let returndata_size := mload(returndata)
158                     revert(add(32, returndata), returndata_size)
159                 }
160             } else {
161                 revert(errorMessage);
162             }
163         }
164     }
165 }
166 
167 interface IERC20 {
168 
169     function totalSupply() external view returns (uint256);
170 
171     /**
172      * @dev Returns the amount of tokens owned by `account`.
173      */
174     function balanceOf(address account) external view returns (uint256);
175 
176     /**
177      * @dev Moves `amount` tokens from the caller's account to `recipient`.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transfer(address recipient, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Returns the remaining number of tokens that `spender` will be
187      * allowed to spend on behalf of `owner` through {transferFrom}. This is
188      * zero by default.
189      *
190      * This value changes when {approve} or {transferFrom} are called.
191      */
192     function allowance(address owner, address spender) external view returns (uint256);
193 
194     /**
195      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * IMPORTANT: Beware that changing an allowance with this method brings the risk
200      * that someone may use both the old and the new allowance by unfortunate
201      * transaction ordering. One possible solution to mitigate this race
202      * condition is to first reduce the spender's allowance to 0 and set the
203      * desired value afterwards:
204      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205      *
206      * Emits an {Approval} event.
207      */
208     function approve(address spender, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Moves `amount` tokens from `sender` to `recipient` using the
212      * allowance mechanism. `amount` is then deducted from the caller's
213      * allowance.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
220 
221     /**
222      * @dev Emitted when `value` tokens are moved from one account (`from`) to
223      * another (`to`).
224      *
225      * Note that `value` may be zero.
226      */
227     event Transfer(address indexed from, address indexed to, uint256 value);
228 
229     /**
230      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
231      * a call to {approve}. `value` is the new allowance.
232      */
233     event Approval(address indexed owner, address indexed spender, uint256 value);
234 }
235 
236 library SafeMath {
237     /**
238      * @dev Returns the addition of two unsigned integers, reverting on
239      * overflow.
240      *
241      * Counterpart to Solidity's `+` operator.
242      *
243      * Requirements:
244      *
245      * - Addition cannot overflow.
246      */
247     function add(uint256 a, uint256 b) internal pure returns (uint256) {
248         uint256 c = a + b;
249         require(c >= a, "SafeMath: addition overflow");
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the subtraction of two unsigned integers, reverting on
256      * overflow (when the result is negative).
257      *
258      * Counterpart to Solidity's `-` operator.
259      *
260      * Requirements:
261      *
262      * - Subtraction cannot overflow.
263      */
264     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
265         return sub(a, b, "SafeMath: subtraction overflow");
266     }
267 
268     /**
269      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
270      * overflow (when the result is negative).
271      *
272      * Counterpart to Solidity's `-` operator.
273      *
274      * Requirements:
275      *
276      * - Subtraction cannot overflow.
277      */
278     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         require(b <= a, errorMessage);
280         uint256 c = a - b;
281 
282         return c;
283     }
284 
285     /**
286      * @dev Returns the multiplication of two unsigned integers, reverting on
287      * overflow.
288      *
289      * Counterpart to Solidity's `*` operator.
290      *
291      * Requirements:
292      *
293      * - Multiplication cannot overflow.
294      */
295     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
296         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
297         // benefit is lost if 'b' is also tested.
298         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
299         if (a == 0) {
300             return 0;
301         }
302 
303         uint256 c = a * b;
304         require(c / a == b, "SafeMath: multiplication overflow");
305 
306         return c;
307     }
308 
309     /**
310      * @dev Returns the integer division of two unsigned integers. Reverts on
311      * division by zero. The result is rounded towards zero.
312      *
313      * Counterpart to Solidity's `/` operator. Note: this function uses a
314      * `revert` opcode (which leaves remaining gas untouched) while Solidity
315      * uses an invalid opcode to revert (consuming all remaining gas).
316      *
317      * Requirements:
318      *
319      * - The divisor cannot be zero.
320      */
321     function div(uint256 a, uint256 b) internal pure returns (uint256) {
322         return div(a, b, "SafeMath: division by zero");
323     }
324 
325     /**
326      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
327      * division by zero. The result is rounded towards zero.
328      *
329      * Counterpart to Solidity's `/` operator. Note: this function uses a
330      * `revert` opcode (which leaves remaining gas untouched) while Solidity
331      * uses an invalid opcode to revert (consuming all remaining gas).
332      *
333      * Requirements:
334      *
335      * - The divisor cannot be zero.
336      */
337     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
338         require(b > 0, errorMessage);
339         uint256 c = a / b;
340         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
341 
342         return c;
343     }
344 
345     /**
346      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
347      * Reverts when dividing by zero.
348      *
349      * Counterpart to Solidity's `%` operator. This function uses a `revert`
350      * opcode (which leaves remaining gas untouched) while Solidity uses an
351      * invalid opcode to revert (consuming all remaining gas).
352      *
353      * Requirements:
354      *
355      * - The divisor cannot be zero.
356      */
357     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
358         return mod(a, b, "SafeMath: modulo by zero");
359     }
360 
361     /**
362      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
363      * Reverts with custom message when dividing by zero.
364      *
365      * Counterpart to Solidity's `%` operator. This function uses a `revert`
366      * opcode (which leaves remaining gas untouched) while Solidity uses an
367      * invalid opcode to revert (consuming all remaining gas).
368      *
369      * Requirements:
370      *
371      * - The divisor cannot be zero.
372      */
373     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
374         require(b != 0, errorMessage);
375         return a % b;
376     }
377 }
378 
379 abstract contract Context {
380     function _msgSender() internal view virtual returns (address payable) {
381         return payable(msg.sender);
382     }
383 
384     function _msgData() internal view virtual returns (bytes memory) {
385         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
386         return msg.data;
387     }
388 }
389 
390 contract Ownable is Context {
391     address private _owner;
392     address private _previousOwner;
393     uint256 private _lockTime;
394 
395     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
396 
397     /**
398      * @dev Initializes the contract setting the deployer as the initial owner.
399      */
400     constructor () {
401         address msgSender = _msgSender();
402         _owner = msgSender;
403         emit OwnershipTransferred(address(0), msgSender);
404     }
405 
406     /**
407      * @dev Returns the address of the current owner.
408      */
409     function owner() public view returns (address) {
410         return _owner;
411     }
412 
413     /**
414      * @dev Throws if called by any account other than the owner.
415      */
416     modifier onlyOwner() {
417         require(_owner == _msgSender(), "Ownable: caller is not the owner");
418         _;
419     }
420 
421     /**
422      * @dev Leaves the contract without owner. It will not be possible to call
423      * `onlyOwner` functions anymore. Can only be called by the current owner.
424      *
425      * NOTE: Renouncing ownership will leave the contract without an owner,
426      * thereby removing any functionality that is only available to the owner.
427      */
428     function renounceOwnership() public virtual onlyOwner {
429         emit OwnershipTransferred(_owner, address(0));
430         _owner = address(0);
431     }
432 
433     /**
434      * @dev Transfers ownership of the contract to a new account (`newOwner`).
435      * Can only be called by the current owner.
436      */
437     function transferOwnership(address newOwner) public virtual onlyOwner {
438         require(newOwner != address(0), "Ownable: new owner is the zero address");
439         emit OwnershipTransferred(_owner, newOwner);
440         _owner = newOwner;
441     }
442 
443     function geUnlockTime() public view returns (uint256) {
444         return _lockTime;
445     }
446 
447     //Locks the contract for owner for the amount of time provided
448     function lock(uint256 time) public virtual onlyOwner {
449         _previousOwner = _owner;
450         _owner = address(0);
451         _lockTime = block.timestamp + time;
452         emit OwnershipTransferred(_owner, address(0));
453     }
454 
455     //Unlocks the contract for owner when _lockTime is exceeds
456     function unlock() public virtual {
457         require(_previousOwner == msg.sender, "You don't have permission to unlock");
458         require(block.timestamp > _lockTime , "Contract is locked");
459         emit OwnershipTransferred(_owner, _previousOwner);
460         _owner = _previousOwner;
461     }
462 }
463 
464 /** 
465  * Contract: Surge Token
466  * Developed By: SafemoonMark
467  * 
468  * Liquidity-less Token, DEX built into Contract
469  * Send BNB to contract and it mints Surge Token to your receive Address
470  * Sell this token via dApp like bscscan, removes from Supply
471  * Price is calculated as a ratio between Total Supply and BNB in Contract
472  * Next Gen DeFi Token :D
473  * 
474  */
475 contract SurgeToken is IERC20, Context, Ownable, ReentrancyGuard {
476     
477     using SafeMath for uint256;
478     using SafeMath for uint8;
479     using Address for address;
480 
481     // token data
482     string constant _name = "Surge";
483     string constant _symbol = "SURGE";
484     uint8 constant _decimals = 0;
485     // 1 Billion Total Supply
486     uint256 _totalSupply = 1 * 10**9;
487     // balances
488     mapping (address => uint256) _balances;
489     mapping (address => mapping (address => uint256)) _allowances;
490 
491     uint256 public sellFee = 94;
492     uint256 public spreadDivisor = 94;
493     uint256 public transferFee = 98;
494     bool public hyperInflatePrice = false;
495     
496     bool inSwap;
497     modifier swapping() { inSwap = true; _; inSwap = false; }
498     
499     // initialize some stuff
500     constructor (
501     ) {
502         // exempt this contract, the LP, and OUR burn wallet from receiving Safemoon Rewards
503         _balances[msg.sender] = _totalSupply;
504         emit Transfer(address(0), msg.sender, _totalSupply);
505     }
506 
507     function totalSupply() external view override returns (uint256) { return _totalSupply; }
508     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
509     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
510     function name() public pure returns (string memory) {
511         return _name;
512     }
513 
514     function symbol() public pure returns (string memory) {
515         return _symbol;
516     }
517 
518     function decimals() public pure returns (uint8) {
519         return _decimals;
520     }
521 
522     function approve(address spender, uint256 amount) public override returns (bool) {
523         _allowances[msg.sender][spender] = amount;
524         emit Approval(msg.sender, spender, amount);
525         return true;
526     }
527   
528     /** Transfer Function */
529     function transfer(address recipient, uint256 amount) external override returns (bool) {
530         return _transferFrom(msg.sender, recipient, amount);
531     }
532     /** Transfer Function */
533     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
534         require(sender == msg.sender);
535         return _transferFrom(sender, recipient, amount);
536     }
537     
538     /** Internal Transfer */
539     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
540         // make standard checks
541         require(recipient != address(0), "BEP20: transfer to the zero address");
542         require(amount > 0, "Transfer amount must be greater than zero");
543         // subtract form sender, give to receiver, burn the fee
544         uint256 tAmount = amount.mul(transferFee).div(10**2);
545         uint256 tax = amount.sub(tAmount);
546         // subtract from sender
547         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
548         // give reduced amount to receiver
549         _balances[recipient] = _balances[recipient].add(tAmount);
550         // burn the tax
551         _totalSupply = _totalSupply.sub(tax);
552         // Transfer Event
553         emit Transfer(sender, recipient, tAmount);
554         return true;
555     }
556     
557     /** Purchases SURGE Tokens and Deposits Them in Sender's Address*/
558     function purchase(address buyer, uint256 bnbAmount) internal returns (bool) {
559         // make sure we don't buy more than the bnb in this contract
560         require(bnbAmount <= address(this).balance, 'purchase not included in balance');
561         // previous amount of BNB before we received any        
562         uint256 prevBNBAmount = (address(this).balance).sub(bnbAmount);
563         // if this is the first purchase, use current balance
564         prevBNBAmount = prevBNBAmount == 0 ? address(this).balance : prevBNBAmount;
565         // find the number of tokens we should mint to keep up with the current price
566         uint256 nShouldPurchase = hyperInflatePrice ? _totalSupply.mul(bnbAmount).div(address(this).balance) : _totalSupply.mul(bnbAmount).div(prevBNBAmount);
567         // apply our spread to tokens to inflate price relative to total supply
568         uint256 tokensToSend = nShouldPurchase.mul(spreadDivisor).div(10**2);
569         // revert if under 1
570         if (tokensToSend < 1) {
571             revert('Must Buy More Than One Surge');
572         }
573         
574         // mint the tokens we need to the buyer
575         mint(buyer, tokensToSend);
576         emit Transfer(address(this), buyer, tokensToSend);
577         return true;
578     }
579     
580     /** Sells SURGE Tokens And Deposits the BNB into Seller's Address */
581     function sell(uint256 tokenAmount) public nonReentrant returns (bool) {
582         
583         address seller = msg.sender;
584         
585         // make sure seller has this balance
586         require(_balances[seller] >= tokenAmount, 'cannot sell above token amount');
587         
588         // calculate the sell fee from this transaction
589         uint256 tokensToSwap = tokenAmount.mul(sellFee).div(10**2);
590         
591         // how much BNB are these tokens worth?
592         uint256 amountBNB = tokensToSwap.mul(calculatePrice());
593         
594         // send BNB to Seller
595         (bool successful,) = payable(seller).call{value: amountBNB, gas: 40000}(""); 
596         if (successful) {
597             // subtract full amount from sender
598             _balances[seller] = _balances[seller].sub(tokenAmount, 'sender does not have this amount to sell');
599             // if successful, remove tokens from supply
600             _totalSupply = _totalSupply.sub(tokenAmount);
601         } else {
602             revert();
603         }
604         emit Transfer(seller, address(this), tokenAmount);
605         return true;
606     }
607     
608     /** Returns the Current Price of the Token */
609     function calculatePrice() public view returns (uint256) {
610         return ((address(this).balance).div(_totalSupply));
611     }
612     
613     /** Mints Tokens to the Receivers Address */
614     function mint(address receiver, uint amount) internal {
615         _balances[receiver] = _balances[receiver].add(amount);
616         _totalSupply = _totalSupply.add(amount);
617     }
618     
619     /** Amount of BNB in Contract */
620     function getBNBQuantityInContract() public view returns(uint256){
621         return address(this).balance;
622     }
623     /** Returns the value of your holdings before the 6% sell fee */
624     function getValueOfHoldings(address holder) public view returns(uint256) {
625         return _balances[holder].mul(calculatePrice());
626     }
627     
628     receive() external payable {
629         uint256 val = msg.value;
630         address buyer = msg.sender;
631         purchase(buyer, val);
632     }
633 
634     
635 }