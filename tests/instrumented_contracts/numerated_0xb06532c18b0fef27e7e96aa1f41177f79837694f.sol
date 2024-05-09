1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9   /**
10    * @dev Returns the amount of tokens in existence.
11    */
12   function totalSupply() external view returns (uint256);
13 
14   /**
15    * @dev Returns the amount of tokens owned by `account`.
16    */
17   function balanceOf(address account) external view returns (uint256);
18 
19   /**
20    * @dev Moves `amount` tokens from the caller's account to `recipient`.
21    *
22    * Returns a boolean value indicating whether the operation succeeded.
23    *
24    * Emits a {Transfer} event.
25    */
26   function transfer(address recipient, uint256 amount) external returns (bool);
27 
28   /**
29    * @dev Returns the remaining number of tokens that `spender` will be
30    * allowed to spend on behalf of `owner` through {transferFrom}. This is
31    * zero by default.
32    *
33    * This value changes when {approve} or {transferFrom} are called.
34    */
35   function allowance(address owner, address spender)
36     external
37     view
38     returns (uint256);
39 
40   /**
41    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42    *
43    * Returns a boolean value indicating whether the operation succeeded.
44    *
45    * IMPORTANT: Beware that changing an allowance with this method brings the risk
46    * that someone may use both the old and the new allowance by unfortunate
47    * transaction ordering. One possible solution to mitigate this race
48    * condition is to first reduce the spender's allowance to 0 and set the
49    * desired value afterwards:
50    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51    *
52    * Emits an {Approval} event.
53    */
54   function approve(address spender, uint256 amount) external returns (bool);
55 
56   /**
57    * @dev Moves `amount` tokens from `sender` to `recipient` using the
58    * allowance mechanism. `amount` is then deducted from the caller's
59    * allowance.
60    *
61    * Returns a boolean value indicating whether the operation succeeded.
62    *
63    * Emits a {Transfer} event.
64    */
65   function transferFrom(
66     address sender,
67     address recipient,
68     uint256 amount
69   ) external returns (bool);
70 
71   /**
72    * @dev Emitted when `value` tokens are moved from one account (`from`) to
73    * another (`to`).
74    *
75    * Note that `value` may be zero.
76    */
77   event Transfer(address indexed from, address indexed to, uint256 value);
78 
79   /**
80    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81    * a call to {approve}. `value` is the new allowance.
82    */
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // File: @openzeppelin/contracts/math/SafeMath.sol
87 
88 pragma solidity ^0.6.0;
89 
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations with added overflow
92  * checks.
93  *
94  * Arithmetic operations in Solidity wrap on overflow. This can easily result
95  * in bugs, because programmers usually assume that an overflow raises an
96  * error, which is the standard behavior in high level programming languages.
97  * `SafeMath` restores this intuition by reverting the transaction when an
98  * operation overflows.
99  *
100  * Using this library instead of the unchecked operations eliminates an entire
101  * class of bugs, so it's recommended to use it always.
102  */
103 library SafeMath {
104   /**
105    * @dev Returns the addition of two unsigned integers, reverting on
106    * overflow.
107    *
108    * Counterpart to Solidity's `+` operator.
109    *
110    * Requirements:
111    *
112    * - Addition cannot overflow.
113    */
114   function add(uint256 a, uint256 b) internal pure returns (uint256) {
115     uint256 c = a + b;
116     require(c >= a, 'SafeMath: addition overflow');
117 
118     return c;
119   }
120 
121   /**
122    * @dev Returns the subtraction of two unsigned integers, reverting on
123    * overflow (when the result is negative).
124    *
125    * Counterpart to Solidity's `-` operator.
126    *
127    * Requirements:
128    *
129    * - Subtraction cannot overflow.
130    */
131   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132     return sub(a, b, 'SafeMath: subtraction overflow');
133   }
134 
135   /**
136    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
137    * overflow (when the result is negative).
138    *
139    * Counterpart to Solidity's `-` operator.
140    *
141    * Requirements:
142    *
143    * - Subtraction cannot overflow.
144    */
145   function sub(
146     uint256 a,
147     uint256 b,
148     string memory errorMessage
149   ) internal pure returns (uint256) {
150     require(b <= a, errorMessage);
151     uint256 c = a - b;
152 
153     return c;
154   }
155 
156   /**
157    * @dev Returns the multiplication of two unsigned integers, reverting on
158    * overflow.
159    *
160    * Counterpart to Solidity's `*` operator.
161    *
162    * Requirements:
163    *
164    * - Multiplication cannot overflow.
165    */
166   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168     // benefit is lost if 'b' is also tested.
169     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
170     if (a == 0) {
171       return 0;
172     }
173 
174     uint256 c = a * b;
175     require(c / a == b, 'SafeMath: multiplication overflow');
176 
177     return c;
178   }
179 
180   /**
181    * @dev Returns the integer division of two unsigned integers. Reverts on
182    * division by zero. The result is rounded towards zero.
183    *
184    * Counterpart to Solidity's `/` operator. Note: this function uses a
185    * `revert` opcode (which leaves remaining gas untouched) while Solidity
186    * uses an invalid opcode to revert (consuming all remaining gas).
187    *
188    * Requirements:
189    *
190    * - The divisor cannot be zero.
191    */
192   function div(uint256 a, uint256 b) internal pure returns (uint256) {
193     return div(a, b, 'SafeMath: division by zero');
194   }
195 
196   /**
197    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
198    * division by zero. The result is rounded towards zero.
199    *
200    * Counterpart to Solidity's `/` operator. Note: this function uses a
201    * `revert` opcode (which leaves remaining gas untouched) while Solidity
202    * uses an invalid opcode to revert (consuming all remaining gas).
203    *
204    * Requirements:
205    *
206    * - The divisor cannot be zero.
207    */
208   function div(
209     uint256 a,
210     uint256 b,
211     string memory errorMessage
212   ) internal pure returns (uint256) {
213     require(b > 0, errorMessage);
214     uint256 c = a / b;
215     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216 
217     return c;
218   }
219 
220   /**
221    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222    * Reverts when dividing by zero.
223    *
224    * Counterpart to Solidity's `%` operator. This function uses a `revert`
225    * opcode (which leaves remaining gas untouched) while Solidity uses an
226    * invalid opcode to revert (consuming all remaining gas).
227    *
228    * Requirements:
229    *
230    * - The divisor cannot be zero.
231    */
232   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233     return mod(a, b, 'SafeMath: modulo by zero');
234   }
235 
236   /**
237    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238    * Reverts with custom message when dividing by zero.
239    *
240    * Counterpart to Solidity's `%` operator. This function uses a `revert`
241    * opcode (which leaves remaining gas untouched) while Solidity uses an
242    * invalid opcode to revert (consuming all remaining gas).
243    *
244    * Requirements:
245    *
246    * - The divisor cannot be zero.
247    */
248   function mod(
249     uint256 a,
250     uint256 b,
251     string memory errorMessage
252   ) internal pure returns (uint256) {
253     require(b != 0, errorMessage);
254     return a % b;
255   }
256 }
257 
258 // File: @openzeppelin/contracts/GSN/Context.sol
259 
260 pragma solidity ^0.6.0;
261 
262 /*
263  * @dev Provides information about the current execution context, including the
264  * sender of the transaction and its data. While these are generally available
265  * via msg.sender and msg.data, they should not be accessed in such a direct
266  * manner, since when dealing with GSN meta-transactions the account sending and
267  * paying for execution may not be the actual sender (as far as an application
268  * is concerned).
269  *
270  * This contract is only required for intermediate, library-like contracts.
271  */
272 abstract contract Context {
273   function _msgSender() internal virtual view returns (address payable) {
274     return msg.sender;
275   }
276 
277   function _msgData() internal virtual view returns (bytes memory) {
278     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
279     return msg.data;
280   }
281 }
282 
283 // File: @openzeppelin/contracts/access/Ownable.sol
284 
285 pragma solidity ^0.6.0;
286 
287 /**
288  * @dev Contract module which provides a basic access control mechanism, where
289  * there is an account (an owner) that can be granted exclusive access to
290  * specific functions.
291  *
292  * By default, the owner account will be the one that deploys the contract. This
293  * can later be changed with {transferOwnership}.
294  *
295  * This module is used through inheritance. It will make available the modifier
296  * `onlyOwner`, which can be applied to your functions to restrict their use to
297  * the owner.
298  */
299 contract Ownable is Context {
300   address private _owner;
301 
302   event OwnershipTransferred(
303     address indexed previousOwner,
304     address indexed newOwner
305   );
306 
307   /**
308    * @dev Initializes the contract setting the deployer as the initial owner.
309    */
310   constructor() internal {
311     address msgSender = _msgSender();
312     _owner = msgSender;
313     emit OwnershipTransferred(address(0), msgSender);
314   }
315 
316   /**
317    * @dev Returns the address of the current owner.
318    */
319   function owner() public view returns (address) {
320     return _owner;
321   }
322 
323   /**
324    * @dev Throws if called by any account other than the owner.
325    */
326   modifier onlyOwner() {
327     require(_owner == _msgSender(), 'Ownable: caller is not the owner');
328     _;
329   }
330 
331   /**
332    * @dev Leaves the contract without owner. It will not be possible to call
333    * `onlyOwner` functions anymore. Can only be called by the current owner.
334    *
335    * NOTE: Renouncing ownership will leave the contract without an owner,
336    * thereby removing any functionality that is only available to the owner.
337    */
338   function renounceOwnership() public virtual onlyOwner {
339     emit OwnershipTransferred(_owner, address(0));
340     _owner = address(0);
341   }
342 
343   /**
344    * @dev Transfers ownership of the contract to a new account (`newOwner`).
345    * Can only be called by the current owner.
346    */
347   function transferOwnership(address newOwner) public virtual onlyOwner {
348     require(newOwner != address(0), 'Ownable: new owner is the zero address');
349     emit OwnershipTransferred(_owner, newOwner);
350     _owner = newOwner;
351   }
352 }
353 
354 // File: contracts/StonkMarket.sol
355 
356 pragma solidity >=0.6.0;
357 
358 interface IStonkTaxPool {
359   function addRewards(uint256 _amount) external;
360 }
361 
362 contract StonkMarket is Ownable {
363   using SafeMath for uint256;
364 
365   struct Negotiation {
366     uint256 amount;
367     address player;
368     address other;
369   }
370 
371   mapping(address => uint256) public stakedBalances;
372   mapping(address => string) public spoNames;
373 
374   mapping(address => uint8) public hasStaked;
375 
376   address[] private _stakerAddresses;
377   uint256 private _stakerAddressesLength;
378   uint256 private _totalStaked;
379 
380   bool public isNegotiationPaused = false;
381 
382   IERC20 public stonkToken;
383   IStonkTaxPool public stonkTaxPool;
384 
385   uint256 public taxPerNegotiation = 100; // 1% tax
386   uint256 public taxPerWithdrawal = 100; // 1% tax
387   uint256 public maxTakeoverPercent = 5000; // 50% max takeover
388   uint256 public negotiatorAdvantage = 200; // 2% advantage
389   uint256 public minimumStake = 1; // 1e-18 minimum stake
390 
391   address payable public treasury;
392 
393   event SPOCreated(
394     address player,
395     uint256 amount,
396     string name,
397     uint256 timestamp
398   );
399   event SPOWithdrawn(address player, uint256 amount, string name);
400   event AcquisitionNegotiated(
401     address spoA,
402     address spoB,
403     string spoAName,
404     string spoBName,
405     bool winner,
406     uint256 amount,
407     uint256 amountWon,
408     uint256 timestamp
409   );
410 
411   modifier onlyEOA() {
412     require(msg.sender == tx.origin, 'Not eoa');
413     _;
414   }
415 
416   constructor(
417     IERC20 _stonkToken,
418     IStonkTaxPool _stonkTaxPool,
419     address payable _treasury
420   ) public {
421     stonkToken = _stonkToken;
422     stonkTaxPool = _stonkTaxPool;
423     treasury = _treasury;
424   }
425 
426   function stakerAddresses() public view returns (address[] memory) {
427     return _stakerAddresses;
428   }
429 
430   function stakerAddressesLength() public view returns (uint256) {
431     return _stakerAddressesLength;
432   }
433 
434   function totalStaked() public view returns (uint256) {
435     return _totalStaked;
436   }
437 
438   function setTaxPerNegotiation(uint256 _taxPerNegotiation) external onlyOwner {
439     taxPerNegotiation = _taxPerNegotiation;
440   }
441 
442   function setTaxPerWithdrawal(uint256 _taxPerWithdrawal) external onlyOwner {
443     taxPerWithdrawal = _taxPerWithdrawal;
444   }
445 
446   function setStonkTaxPool(IStonkTaxPool _stonkTaxPool) external onlyOwner {
447     stonkTaxPool = _stonkTaxPool;
448   }
449 
450   function setMinimumStake(uint256 _minimumStake) external onlyOwner {
451     minimumStake = _minimumStake;
452   }
453 
454   function setNegotiationPaused(bool value) external onlyOwner {
455     isNegotiationPaused = value;
456   }
457 
458   function setMaxTakeoverPercent(uint256 _maxTakeoverPercent)
459     external
460     onlyOwner
461   {
462     maxTakeoverPercent = _maxTakeoverPercent;
463   }
464 
465   function addressesInRange(uint256 start, uint256 end)
466     external
467     view
468     returns (address[] memory)
469   {
470     require(end > start, 'Invalid bounds');
471 
472     address[] memory addresses;
473 
474     for (uint256 i; i < start - end; i++) {
475       addresses[i] = _stakerAddresses[start + i];
476     }
477 
478     return addresses;
479   }
480 
481   function _rng(uint256 _seed) internal view returns (uint256) {
482     return
483       uint256(
484         keccak256(
485           abi.encodePacked(
486             (block.timestamp)
487               .add(_seed)
488               .add(block.difficulty)
489               .add(
490               (uint256(keccak256(abi.encodePacked(block.coinbase)))) /
491                 block.timestamp
492             )
493               .add(block.gaslimit)
494               .add(
495               (uint256(keccak256(abi.encodePacked(msg.sender)))) /
496                 block.timestamp
497             )
498               .add(block.number)
499           )
500         )
501       );
502   }
503 
504   function launchSPO(uint256 amount, string memory name) public {
505     require(amount > minimumStake, 'Invalid amount.');
506     require(bytes(name).length >= 1, 'SPO name must be >= 1 byte');
507     require(bytes(name).length <= 4, 'SPO name must be <= 4 bytes');
508 
509     require(
510       stonkToken.transferFrom(msg.sender, address(this), amount),
511       'Transfer failed'
512     );
513 
514     spoNames[msg.sender] = name;
515     stakedBalances[msg.sender] = stakedBalances[msg.sender].add(amount);
516 
517     _totalStaked = _totalStaked.add(amount);
518 
519     if (hasStaked[msg.sender] == 0) {
520       _stakerAddresses.push(msg.sender);
521       _stakerAddressesLength++;
522       hasStaked[msg.sender] = 1;
523     }
524 
525     emit SPOCreated(msg.sender, amount, name, block.timestamp);
526   }
527 
528   function maxNegotiationAmount(address spo) public view returns (uint256) {
529     return stakedBalances[spo].mul(maxTakeoverPercent).div(10000);
530   }
531 
532   function enterNegotiation(address opponentSpo, uint256 amount)
533     external
534     onlyEOA
535   {
536     require(amount > minimumStake, 'Invalid amount.');
537     require(isNegotiationPaused == false, 'Negotiations are paused');
538     require(opponentSpo != msg.sender, 'Invalid opponent');
539     require(stakedBalances[msg.sender] >= amount, 'Insufficient balance');
540 
541     require(
542       maxNegotiationAmount(opponentSpo) >= amount,
543       'Insufficient opponent balance'
544     );
545 
546     address player = msg.sender;
547     address other = opponentSpo;
548     uint256 amountTaxed = amount.mul(taxPerNegotiation).div(10000);
549     uint256 amountWon = amount.sub(amountTaxed);
550 
551     stonkToken.approve(address(stonkTaxPool), amountTaxed);
552     stonkTaxPool.addRewards(amountTaxed);
553 
554     uint256 midpoint = uint256(5000).sub(
555       uint256(10000).mul(negotiatorAdvantage.div(2)).div(10000)
556     );
557     uint256 rngBetweenOneAndOneHundred = _rng(stakedBalances[player]) % 10000;
558     bool winner = false;
559 
560     if (rngBetweenOneAndOneHundred >= midpoint) {
561       winner = true;
562 
563       stakedBalances[player] = stakedBalances[player].add(amountWon);
564       stakedBalances[other] = stakedBalances[other].sub(amount);
565     } else {
566       stakedBalances[other] = stakedBalances[other].add(amountWon);
567       stakedBalances[player] = stakedBalances[player].sub(amount);
568     }
569 
570     emit AcquisitionNegotiated(
571       player,
572       other,
573       spoNames[player],
574       spoNames[other],
575       winner,
576       amount,
577       amountWon,
578       block.timestamp
579     );
580   }
581 
582   function withdraw(uint256 amount) external {
583     require(stakedBalances[msg.sender] >= amount, 'Insufficient balance');
584 
585     uint256 amountTaxed = amount.mul(taxPerWithdrawal).div(10000);
586     stonkToken.approve(address(stonkTaxPool), amountTaxed);
587     stonkTaxPool.addRewards(amountTaxed);
588 
589     uint256 amountAfterTax = amount.sub(amountTaxed);
590 
591     stakedBalances[msg.sender] = stakedBalances[msg.sender].sub(amount);
592     _totalStaked = _totalStaked.sub(amount);
593 
594     require(safeStonkTransfer(msg.sender, amountAfterTax), 'Transfer failed');
595 
596     emit SPOWithdrawn(msg.sender, amount, spoNames[msg.sender]);
597   }
598 
599   function safeStonkTransfer(address _to, uint256 _amount)
600     internal
601     returns (bool)
602   {
603     uint256 stonkBal = stonkToken.balanceOf(address(this));
604 
605     if (_amount > stonkBal) {
606       return stonkToken.transfer(_to, stonkBal);
607     } else {
608       return stonkToken.transfer(_to, _amount);
609     }
610   }
611 
612   // This function send any eth remaining from oracle fees, to treasury
613   function flushEth() public {
614     treasury.transfer(address(this).balance);
615   }
616 }