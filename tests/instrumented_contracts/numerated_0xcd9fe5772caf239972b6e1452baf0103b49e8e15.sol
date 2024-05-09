1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.1;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 
162 /**
163  * @dev Collection of functions related to the address type
164  */
165 library Address {
166     /**
167      * @dev Returns true if `account` is a contract.
168      *
169      * [IMPORTANT]
170      * ====
171      * It is unsafe to assume that an address for which this function returns
172      * false is an externally-owned account (EOA) and not a contract.
173      *
174      * Among others, `isContract` will return false for the following
175      * types of addresses:
176      *
177      *  - an externally-owned account
178      *  - a contract in construction
179      *  - an address where a contract will be created
180      *  - an address where a contract lived, but was destroyed
181      * ====
182      */
183     function isContract(address account) internal view returns (bool) {
184         // This method relies in extcodesize, which returns 0 for contracts in
185         // construction, since the code is only stored at the end of the
186         // constructor execution.
187 
188         uint256 size;
189         // solhint-disable-next-line no-inline-assembly
190         assembly { size := extcodesize(account) }
191         return size > 0;
192     }
193 
194     /**
195      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
196      * `recipient`, forwarding all available gas and reverting on errors.
197      *
198      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
199      * of certain opcodes, possibly making contracts go over the 2300 gas limit
200      * imposed by `transfer`, making them unable to receive funds via
201      * `transfer`. {sendValue} removes this limitation.
202      *
203      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
204      *
205      * IMPORTANT: because control is transferred to `recipient`, care must be
206      * taken to not create reentrancy vulnerabilities. Consider using
207      * {ReentrancyGuard} or the
208      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
209      */
210     function sendValue(address payable recipient, uint256 amount) internal {
211         require(address(this).balance >= amount, "Address: insufficient balance");
212 
213         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
214         (bool success, ) = recipient.call{ value: amount }("");
215         require(success, "Address: unable to send value, recipient may have reverted");
216     }
217 
218     /**
219      * @dev Performs a Solidity function call using a low level `call`. A
220      * plain`call` is an unsafe replacement for a function call: use this
221      * function instead.
222      *
223      * If `target` reverts with a revert reason, it is bubbled up by this
224      * function (like regular Solidity function calls).
225      *
226      * Returns the raw returned data. To convert to the expected return value,
227      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
228      *
229      * Requirements:
230      *
231      * - `target` must be a contract.
232      * - calling `target` with `data` must not revert.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
237       return functionCall(target, data, "Address: low-level call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
242      * `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
247         return _functionCallWithValue(target, data, 0, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but also transferring `value` wei to `target`.
253      *
254      * Requirements:
255      *
256      * - the calling contract must have an ETH balance of at least `value`.
257      * - the called Solidity function must be `payable`.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
262         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
267      * with `errorMessage` as a fallback revert reason when `target` reverts.
268      *
269      * _Available since v3.1._
270      */
271     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
272         require(address(this).balance >= value, "Address: insufficient balance for call");
273         return _functionCallWithValue(target, data, value, errorMessage);
274     }
275 
276     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
277         require(isContract(target), "Address: call to non-contract");
278 
279         // solhint-disable-next-line avoid-low-level-calls
280         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
281         if (success) {
282             return returndata;
283         } else {
284             // Look for revert reason and bubble it up if present
285             if (returndata.length > 0) {
286                 // The easiest way to bubble the revert reason is using memory via assembly
287 
288                 // solhint-disable-next-line no-inline-assembly
289                 assembly {
290                     let returndata_size := mload(returndata)
291                     revert(add(32, returndata), returndata_size)
292                 }
293             } else {
294                 revert(errorMessage);
295             }
296         }
297     }
298 }
299 
300 
301 /**
302  * @dev Interface of the ERC20 standard as defined in the EIP.
303  */
304 interface IERC20 {
305     /**
306      * @dev Returns the amount of tokens in existence.
307      */
308     function totalSupply() external view returns (uint256);
309 
310     /**
311      * @dev Returns the amount of tokens owned by `account`.
312      */
313     function balanceOf(address account) external view returns (uint256);
314 
315     /**
316      * @dev Moves `amount` tokens from the caller's account to `recipient`.
317      *
318      * Returns a boolean value indicating whether the operation succeeded.
319      *
320      * Emits a {Transfer} event.
321      */
322     function transfer(address recipient, uint256 amount) external returns (bool);
323 
324     /**
325      * @dev Returns the remaining number of tokens that `spender` will be
326      * allowed to spend on behalf of `owner` through {transferFrom}. This is
327      * zero by default.
328      *
329      * This value changes when {approve} or {transferFrom} are called.
330      */
331     function allowance(address owner, address spender) external view returns (uint256);
332 
333     /**
334      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
335      *
336      * Returns a boolean value indicating whether the operation succeeded.
337      *
338      * IMPORTANT: Beware that changing an allowance with this method brings the risk
339      * that someone may use both the old and the new allowance by unfortunate
340      * transaction ordering. One possible solution to mitigate this race
341      * condition is to first reduce the spender's allowance to 0 and set the
342      * desired value afterwards:
343      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
344      *
345      * Emits an {Approval} event.
346      */
347     function approve(address spender, uint256 amount) external returns (bool);
348 
349     /**
350      * @dev Moves `amount` tokens from `sender` to `recipient` using the
351      * allowance mechanism. `amount` is then deducted from the caller's
352      * allowance.
353      *
354      * Returns a boolean value indicating whether the operation succeeded.
355      *
356      * Emits a {Transfer} event.
357      */
358     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
359 
360     /**
361      * @dev Emitted when `value` tokens are moved from one account (`from`) to
362      * another (`to`).
363      *
364      * Note that `value` may be zero.
365      */
366     event Transfer(address indexed from, address indexed to, uint256 value);
367 
368     /**
369      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
370      * a call to {approve}. `value` is the new allowance.
371      */
372     event Approval(address indexed owner, address indexed spender, uint256 value);
373 }
374 
375 /*
376  * @dev Provides information about the current execution context, including the
377  * sender of the transaction and its data. While these are generally available
378  * via msg.sender and msg.data, they should not be accessed in such a direct
379  * manner, since when dealing with GSN meta-transactions the account sending and
380  * paying for execution may not be the actual sender (as far as an application
381  * is concerned).
382  *
383  * This contract is only required for intermediate, library-like contracts.
384  */
385 abstract contract Context {
386     function _msgSender() internal view virtual returns (address payable) {
387         return msg.sender;
388     }
389 
390     function _msgData() internal view virtual returns (bytes memory) {
391         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
392         return msg.data;
393     }
394 }
395 
396 
397  /* @dev Contract module which provides a basic access control mechanism, where
398  * there is an account (an owner) that can be granted exclusive access to
399  * specific functions.
400  *
401  * By default, the owner account will be the one that deploys the contract. This
402  * can later be changed with {transferOwnership}.
403  *
404  * This module is used through inheritance. It will make available the modifier
405  * `onlyOwner`, which can be applied to your functions to restrict their use to
406  * the owner.
407  */
408 contract Ownable is Context {
409     address private _owner;
410 
411     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
412 
413     /**
414      * @dev Initializes the contract setting the deployer as the initial owner.
415      */
416     constructor () {
417         address msgSender = _msgSender();
418         _owner = msgSender;
419         emit OwnershipTransferred(address(0), msgSender);
420     }
421 
422     /**
423      * @dev Returns the address of the current owner.
424      */
425     function owner() public view returns (address) {
426         return _owner;
427     }
428 
429     /**
430      * @dev Throws if called by any account other than the owner.
431      */
432     modifier onlyOwner() {
433         require(_owner == _msgSender(), "Ownable: caller is not the owner");
434         _;
435     }
436 
437     /**
438      * @dev Transfers ownership of the contract to a new account (`newOwner`).
439      * Can only be called by the current owner.
440      */
441     function transferOwnership(address newOwner) public virtual onlyOwner {
442         require(newOwner != address(0), "Ownable: new owner is the zero address");
443         emit OwnershipTransferred(_owner, newOwner);
444         _owner = newOwner;
445     }
446 }
447 
448 contract YFIECStake is Ownable {
449     using SafeMath for uint256;
450     
451     uint256 private dRoi = 3;
452     uint256 private tax = 30;
453     uint256 private divisor = 1e3;
454     uint256 private decimals = 1e8;
455     uint256 private uDuration = 864e2;
456     uint256 private duration = uDuration.mul(1e2);
457     
458     IERC20 public YFIEC;
459     uint256 public pool;
460     uint256 public min;
461     uint256 public max;
462     uint256 public totalStaked;
463     uint256 public totalStakers;
464     uint256 public totalPaid;
465     uint256 public withdrawable;
466     
467     struct Stake {
468         bool exists;
469         uint256 createdOn;
470         uint256 amount;
471         uint256 withdrawn;
472     }
473     
474     mapping(address => Stake) stakes;
475     
476     constructor() {
477         pool = decimals.mul(5e3);
478         withdrawable = pool;
479         min = decimals.mul(10);
480         max = decimals.mul(divisor);
481         YFIEC = IERC20(0x2E6E152d29053B6337E434bc9bE17504170f8a5B);
482     }
483     
484     function stakeExists(address _stake) public view returns(bool) {
485         return stakes[_stake].exists;
486     }
487     
488     function createdDate(address _stake) external view returns(uint256) {
489         return stakes[_stake].createdOn;
490     }
491     
492     function endsAt(address _stake) external view returns(uint256) {
493         uint256 date = stakes[_stake].createdOn;
494         if (date > 0) {
495              date = date.add(duration);     
496         }
497         return date;
498     }
499     
500     function withdrawn(address _stake) external view returns(uint256) {
501         return stakes[_stake].withdrawn;
502     }
503     
504     function stakedAmount(address _stake) external view returns(uint256) {
505         return stakes[_stake].amount;
506     }
507     
508     function newStake(uint256 _amount) public {
509         require(!stakeExists(_msgSender()), "Sender is staking");
510         require(!poolFilled(_amount), "Staking pool filled");
511         require(_amount >= min, "Amount is lower than required");
512         require(_amount <= max, "Amount is higher than maximum");
513         require(YFIEC.transferFrom(_msgSender(), address(this), _amount), "Could not transfer token");
514         
515         totalStaked = totalStaked.add(_amount);
516         totalStakers = totalStakers.add(1);
517         stakes[_msgSender()] = Stake({exists: true, createdOn: block.timestamp, amount: _amount, withdrawn: 0});
518         withdrawable = withdrawable.sub(estimateRoi(_amount));
519         emit NewStake(_msgSender(), _amount);
520     }
521     
522     function unstake() public {
523         require(stakeExists(_msgSender()), "Sender is not staking");
524         Stake memory stake = stakes[_msgSender()];
525         uint256 amount = stake.amount;
526         uint256 thisRoi = _ROI(stake);
527         uint256 offset = estimateRoi(amount).sub(thisRoi);
528         uint256 finalRoi = thisRoi.sub(stake.withdrawn);
529         
530         if (!stakeEnded(_msgSender())) {
531             uint256 thisTax = amount.mul(tax).div(divisor);
532             amount = amount.sub(thisTax);
533             offset = offset.add(thisTax);
534         }
535         
536         withdrawable = withdrawable.add(offset);
537         uint256 total = amount.add(finalRoi);
538         totalPaid = totalPaid.add(finalRoi);
539         require(YFIEC.transfer(_msgSender(), total), "Could not transfer token");
540         
541         totalStakers = totalStakers.sub(1);
542         totalStaked = totalStaked.sub(stake.amount);
543         delete stakes[_msgSender()];
544         emit Unstake(_msgSender(), total);
545     }
546     
547     function withdrawReward() public {
548         require(stakeExists(_msgSender()), "Sender is not staking");
549         Stake storage stake = stakes[_msgSender()];
550         uint256 thisRoi = _ROI(stake).sub(stake.withdrawn);
551         totalPaid = totalPaid.add(thisRoi);
552         stake.withdrawn = stake.withdrawn.add(thisRoi);
553         require(YFIEC.transfer(_msgSender(), thisRoi), "Could not transfer token");
554         emit Withdrawal(_msgSender(), thisRoi);
555     }
556     
557     function ownerWithraw(uint256 _amount) public onlyOwner {
558         require(_amount <= withdrawable, "Not enough balance");
559         require(YFIEC.balanceOf(address(this)) >= _amount, "Balance is less than amount");
560         require(YFIEC.transfer(owner(), _amount), "Token transfer failed");
561         emit Withdrawal(owner(), _amount);
562         withdrawable = withdrawable.sub(_amount);
563     }
564     
565     function ROI(address _stake) public view returns(uint256) {
566         Stake memory stake = stakes[_stake];
567         return _ROI(stake);
568     }
569     
570     function estimateRoi(uint256 _amount) public view returns(uint256) {
571         return _amount.mul(dRoi).mul(duration).div(uDuration).div(divisor);
572     }
573     
574     function poolFilled(uint256 _amount) public view returns(bool) {
575         uint256 (totalStaked.add(_amount)) > pool;
576     }
577     
578     function stakeEnded(address _stake) public view returns(bool) {
579         if (stakeExists(_stake) && block.timestamp.sub(stakes[_stake].createdOn) > duration) {
580             return true;
581         }
582         return false;
583     }
584     
585     function _ROI(Stake memory _stake) internal view returns(uint256) {
586         uint256 dur = block.timestamp.sub(_stake.createdOn);
587         if (dur > duration) {
588             dur = duration;
589         }
590         
591         uint256 uDur = dur.div(uDuration);
592         uint256 roi = uDur.mul(dRoi).mul(_stake.amount);
593         return roi.div(divisor);
594     }
595     
596     event NewStake(address indexed staker, uint256 amount);
597     event Unstake(address indexed staker, uint256 amount);
598     event Withdrawal(address indexed staker, uint256 amount);
599 }