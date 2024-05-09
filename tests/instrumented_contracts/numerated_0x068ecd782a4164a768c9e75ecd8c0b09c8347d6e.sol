1 pragma solidity 0.5.8; 
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function decimals() public view returns (uint8);
10     function totalSupply() public view returns (uint256);
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @dev Wrappers over Solidity's arithmetic operations with added overflow
18  * checks.
19  *
20  * Arithmetic operations in Solidity wrap on overflow. This can easily result
21  * in bugs, because programmers usually assume that an overflow raises an
22  * error, which is the standard behavior in high level programming languages.
23  * `SafeMath` restores this intuition by reverting the transaction when an
24  * operation overflows.
25  *
26  * Using this library instead of the unchecked operations eliminates an entire
27  * class of bugs, so it's recommended to use it always.
28  */
29 library SafeMath {
30     /**
31      * @dev Returns the addition of two unsigned integers, reverting on
32      * overflow.
33      *
34      * Counterpart to Solidity's `+` operator.
35      *
36      * Requirements:
37      * - Addition cannot overflow.
38      */
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42 
43         return c;
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      */
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         return sub(a, b, "SafeMath: subtraction overflow");
57     }
58 
59     /**
60      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
61      * overflow (when the result is negative).
62      *
63      * Counterpart to Solidity's `-` operator.
64      *
65      * Requirements:
66      * - Subtraction cannot overflow.
67      *
68      * _Available since v2.4.0._
69      */
70     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b <= a, errorMessage);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the multiplication of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `*` operator.
82      *
83      * Requirements:
84      * - Multiplication cannot overflow.
85      */
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      * - The divisor cannot be zero.
110      */
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         return div(a, b, "SafeMath: division by zero");
113     }
114 
115     /**
116      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
117      * division by zero. The result is rounded towards zero.
118      *
119      * Counterpart to Solidity's `/` operator. Note: this function uses a
120      * `revert` opcode (which leaves remaining gas untouched) while Solidity
121      * uses an invalid opcode to revert (consuming all remaining gas).
122      *
123      * Requirements:
124      * - The divisor cannot be zero.
125      *
126      * _Available since v2.4.0._
127      */
128     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129         // Solidity only automatically asserts when dividing by 0
130         require(b > 0, errorMessage);
131         uint256 c = a / b;
132         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * Reverts when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
149         return mod(a, b, "SafeMath: modulo by zero");
150     }
151 
152     /**
153      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
154      * Reverts with custom message when dividing by zero.
155      *
156      * Counterpart to Solidity's `%` operator. This function uses a `revert`
157      * opcode (which leaves remaining gas untouched) while Solidity uses an
158      * invalid opcode to revert (consuming all remaining gas).
159      *
160      * Requirements:
161      * - The divisor cannot be zero.
162      *
163      * _Available since v2.4.0._
164      */
165     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b != 0, errorMessage);
167         return a % b;
168     }
169 }
170 
171 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
172 
173 /**
174  * @title ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/20
176  */
177 contract ERC20 is ERC20Basic {
178   function allowance(address owner, address spender) public view returns (uint256);
179   function transferFrom(address from, address to, uint256 value) public returns (bool);
180   function approve(address spender, uint256 value) public returns (bool);
181   event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
185 
186 /**
187  * @title Ownable
188  * @dev The Ownable contract has an owner address, and provides basic authorization control
189  * functions, this simplifies the implementation of "user permissions".
190  */
191 contract Ownable {
192     address public owner;
193     address public proposedOwner;
194     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
195 
196 
197     /**
198     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
199     * account.
200     */
201     constructor() public {
202         owner = msg.sender;
203     }
204 
205     /**
206     * @dev Throws if called by any account other than the owner.
207     */
208     modifier onlyOwner() {
209         require(msg.sender == owner, "Has to be owner");
210         _;
211     }
212 
213     function transferOwnership(address _proposedOwner) public onlyOwner {
214         require(msg.sender != _proposedOwner, "Has to be diff than current owner");
215         proposedOwner = _proposedOwner;
216     }
217 
218     function claimOwnership() public {
219         require(msg.sender == proposedOwner, "Has to be the proposed owner");
220         emit OwnershipTransferred(owner, proposedOwner);
221         owner = proposedOwner;
222         proposedOwner = address(0);
223     }
224 }
225 
226 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
227 
228 /**
229  * @title Pausable
230  * @dev Base contract which allows children to implement an emergency stop mechanism.
231  */
232 contract Pausable is Ownable {
233     event Pause();
234     event Unpause();
235 
236     bool public paused = false;
237 
238 
239     /**
240     * @dev Modifier to make a function callable only when the contract is not paused.
241     */
242     modifier whenNotPaused() {
243         require(!paused, "Has to be unpaused");
244         _;
245     }
246 
247     /**
248     * @dev Modifier to make a function callable only when the contract is paused.
249     */
250     modifier whenPaused() {
251         require(paused, "Has to be paused");
252         _;
253     }
254 
255     /**
256     * @dev called by the owner to pause, triggers stopped state
257     */
258     function pause() onlyOwner whenNotPaused public {
259         paused = true;
260         emit Pause();
261     }
262 
263     /**
264     * @dev called by the owner to unpause, returns to normal state
265     */
266     function unpause() onlyOwner whenPaused public {
267         paused = false;
268         emit Unpause();
269     }
270 }
271 
272 
273 contract Whitelist is Ownable {
274 
275     mapping(address => bool) public whitelist;
276     address[] public whitelistedAddresses;
277     bool public hasWhitelisting = false;
278 
279     event AddedToWhitelist(address[] indexed accounts);
280     event RemovedFromWhitelist(address indexed account);
281 
282     modifier onlyWhitelisted() {
283         if(hasWhitelisting){
284             require(isWhitelisted(msg.sender));
285         }
286         _;
287     }
288     
289     constructor (bool _hasWhitelisting) public{
290         hasWhitelisting = _hasWhitelisting;
291     }
292 
293     function add(address[] memory _addresses) public onlyOwner {
294         for (uint i = 0; i < _addresses.length; i++) {
295             require(whitelist[_addresses[i]] != true);
296             whitelist[_addresses[i]] = true;
297             whitelistedAddresses.push(_addresses[i]);
298         }
299         emit AddedToWhitelist(_addresses);
300     }
301 
302     function remove(address _address, uint256 _index) public onlyOwner {
303         require(_address == whitelistedAddresses[_index]);
304         whitelist[_address] = false;
305         delete whitelistedAddresses[_index];
306         emit RemovedFromWhitelist(_address);
307     }
308 
309     function getWhitelistedAddresses() public view returns(address[] memory) {
310         return whitelistedAddresses;
311     } 
312 
313     function isWhitelisted(address _address) public view returns(bool) {
314         return whitelist[_address];
315     }
316 }
317 
318 contract FixedSwap is Pausable, Whitelist {
319     using SafeMath for uint256;
320     uint256 increment = 0;
321 
322     mapping(uint256 => Purchase) public purchases; /* Purchasers mapping */
323     address[] public buyers; /* Current Buyers Addresses */
324     uint256[] public purchaseIds; /* All purchaseIds */
325     mapping(address => uint256[]) public myPurchases; /* Purchasers mapping */
326 
327     ERC20 public erc20;
328     bool public isSaleFunded = false;
329     uint public decimals = 0;
330     bool public unsoldTokensReedemed = false;
331     uint256 public tradeValue; /* Price in Wei */
332     uint256 public startDate; /* Start Date  */
333     uint256 public endDate;  /* End Date  */
334     uint256 public individualMinimumAmount = 0;  /* Minimum Amount Per Address */
335     uint256 public individualMaximumAmount = 0;  /* Minimum Amount Per Address */
336     uint256 public minimumRaise = 0;  /* Minimum Amount of Tokens that have to be sold */
337     uint256 public tokensAllocated = 0; /* Tokens Available for Allocation - Dynamic */
338     uint256 public tokensForSale = 0; /* Tokens Available for Sale */
339     bool    public isTokenSwapAtomic; /* Make token release atomic or not */
340     address payable public FEE_ADDRESS = 0xAEb39b67F27b641Ef9F95fB74F1A46b1EE4Efc83; /* Default Address for Fee Percentage */
341     uint256 public feePercentage = 1; /* Default Fee 1% */
342 
343     struct Purchase {
344         uint256 amount;
345         address purchaser;
346         uint256 ethAmount;
347         uint256 timestamp;
348         bool wasFinalized /* Confirm the tokens were sent already */;
349         bool reverted /* Confirm the tokens were sent already */;
350     }
351 
352     event PurchaseEvent(uint256 amount, address indexed purchaser, uint256 timestamp);
353 
354     constructor(address _tokenAddress, uint256 _tradeValue, uint256 _tokensForSale, uint256 _startDate, 
355         uint256 _endDate, uint256 _individualMinimumAmount, uint256 _individualMaximumAmount, bool _isTokenSwapAtomic, uint256 _minimumRaise,
356         uint256 _feeAmount, bool _hasWhitelisting
357     ) public Whitelist(_hasWhitelisting) {
358         
359         /* Confirmations */
360         require(block.timestamp < _endDate, "End Date should be further than current date");
361         require(block.timestamp < _startDate, "End Date should be further than current date");
362         require(_startDate < _endDate, "End Date higher than Start Date");
363         require(_tokensForSale > 0, "Tokens for Sale should be > 0");
364         require(_tokensForSale > _individualMinimumAmount, "Tokens for Sale should be > Individual Minimum Amount");
365         require(_individualMaximumAmount >= _individualMinimumAmount, "Individual Maximim AMount should be > Individual Minimum Amount");
366         require(_minimumRaise <= _tokensForSale, "Minimum Raise should be < Tokens For Sale");
367         require(_feeAmount >= feePercentage, "Fee Percentage has to be >= 1");
368         require(_feeAmount <= 99, "Fee Percentage has to be < 100");
369 
370         startDate = _startDate; 
371         endDate = _endDate;
372         tokensForSale = _tokensForSale;
373         tradeValue = _tradeValue;
374 
375         individualMinimumAmount = _individualMinimumAmount; 
376         individualMaximumAmount = _individualMaximumAmount; 
377         isTokenSwapAtomic = _isTokenSwapAtomic;
378 
379         if(!_isTokenSwapAtomic){ /* If raise is not atomic swap */
380             minimumRaise = _minimumRaise;
381         }
382 
383         erc20 = ERC20(_tokenAddress);
384         decimals = erc20.decimals();
385         feePercentage = _feeAmount;
386     }
387 
388     /**
389     * Modifier to make a function callable only when the contract has Atomic Swaps not available.
390     */
391     modifier isNotAtomicSwap() {
392         require(!isTokenSwapAtomic, "Has to be non Atomic swap");
393         _;
394     }
395 
396      /**
397     * Modifier to make a function callable only when the contract has Atomic Swaps not available.
398     */
399     modifier isSaleFinalized() {
400         require(hasFinalized(), "Has to be finalized");
401         _;
402     }
403 
404      /**
405     * Modifier to make a function callable only when the swap time is open.
406     */
407     modifier isSaleOpen() {
408         require(isOpen(), "Has to be open");
409         _;
410     }
411 
412      /**
413     * Modifier to make a function callable only when the contract has Atomic Swaps not available.
414     */
415     modifier isSalePreStarted() {
416         require(isPreStart(), "Has to be pre-started");
417         _;
418     }
419 
420     /**
421     * Modifier to make a function callable only when the contract has Atomic Swaps not available.
422     */
423     modifier isFunded() {
424         require(isSaleFunded, "Has to be funded");
425         _;
426     }
427 
428 
429     /* Get Functions */
430     function isBuyer(uint256 purchase_id) public view returns (bool) {
431         return (msg.sender == purchases[purchase_id].purchaser);
432     }
433 
434     /* Get Functions */
435     function totalRaiseCost() public view returns (uint256) {
436         return (cost(tokensForSale));
437     }
438 
439     function availableTokens() public view returns (uint256) {
440         return erc20.balanceOf(address(this));
441     }
442 
443     function tokensLeft() public view returns (uint256) {
444         return tokensForSale - tokensAllocated;
445     }
446 
447     function hasMinimumRaise() public view returns (bool){
448         return (minimumRaise != 0);
449     }
450 
451     /* Verify if minimum raise was not achieved */
452     function minimumRaiseNotAchieved() public view returns (bool){
453         require(cost(tokensAllocated) < cost(minimumRaise), "TotalRaise is bigger than minimum raise amount");
454         return true;
455     }
456 
457     /* Verify if minimum raise was achieved */
458     function minimumRaiseAchieved() public view returns (bool){
459         if(hasMinimumRaise()){
460             require(cost(tokensAllocated) >= cost(minimumRaise), "TotalRaise is less than minimum raise amount");
461         }
462         return true;
463     }
464 
465     function hasFinalized() public view returns (bool){
466         return block.timestamp > endDate;
467     }
468 
469     function hasStarted() public view returns (bool){
470         return block.timestamp >= startDate;
471     }
472     
473     function isPreStart() public view returns (bool){
474         return block.timestamp < startDate;
475     }
476 
477     function isOpen() public view returns (bool){
478         return hasStarted() && !hasFinalized();
479     }
480 
481     function hasMinimumAmount() public view returns (bool){
482        return (individualMinimumAmount != 0);
483     }
484 
485     function cost(uint256 _amount) public view returns (uint){
486         return _amount.mul(tradeValue).div(10**decimals); 
487     }
488 
489     function getPurchase(uint256 _purchase_id) external view returns (uint256, address, uint256, uint256, bool, bool){
490         Purchase memory purchase = purchases[_purchase_id];
491         return (purchase.amount, purchase.purchaser, purchase.ethAmount, purchase.timestamp, purchase.wasFinalized, purchase.reverted);
492     }
493 
494     function getPurchaseIds() public view returns(uint256[] memory) {
495         return purchaseIds;
496     }
497 
498     function getBuyers() public view returns(address[] memory) {
499         return buyers;
500     }
501 
502     function getMyPurchases(address _address) public view returns(uint256[] memory) {
503         return myPurchases[_address];
504     }
505 
506     /* Fund - Pre Sale Start */
507     function fund(uint256 _amount) public isSalePreStarted {
508         
509         /* Confirm transfered tokens is no more than needed */
510         require(availableTokens().add(_amount) <= tokensForSale, "Transfered tokens have to be equal or less than proposed");
511 
512         /* Transfer Funds */
513         require(erc20.transferFrom(msg.sender, address(this), _amount), "Failed ERC20 token transfer");
514         
515         /* If Amount is equal to needed - sale is ready */
516         if(availableTokens() == tokensForSale){
517             isSaleFunded = true;
518         }
519     }
520     
521     /* Action Functions */
522     function swap(uint256 _amount) payable external whenNotPaused isFunded isSaleOpen onlyWhitelisted {
523 
524         /* Confirm Amount is positive */
525         require(_amount > 0, "Amount has to be positive");
526 
527         /* Confirm Amount is less than tokens available */
528         require(_amount <= tokensLeft(), "Amount is less than tokens available");
529             
530         /* Confirm the user has funds for the transfer, confirm the value is equal */
531         require(msg.value == cost(_amount), "User has to cover the cost of the swap in ETH, use the cost function to determine");
532 
533         /* Confirm Amount is bigger than minimum Amount */
534         require(_amount >= individualMinimumAmount, "Amount is bigger than minimum amount");
535 
536         /* Confirm Amount is smaller than maximum Amount */
537         require(_amount <= individualMaximumAmount, "Amount is smaller than maximum amount");
538 
539         /* Verify all user purchases, loop thru them */
540         uint256[] memory _purchases = getMyPurchases(msg.sender);
541         uint256 purchaserTotalAmountPurchased = 0;
542         for (uint i = 0; i < _purchases.length; i++) {
543             Purchase memory _purchase = purchases[_purchases[i]];
544             purchaserTotalAmountPurchased = purchaserTotalAmountPurchased.add(_purchase.amount);
545         }
546         require(purchaserTotalAmountPurchased.add(_amount) <= individualMaximumAmount, "Address has already passed the max amount of swap");
547 
548         if(isTokenSwapAtomic){
549             /* Confirm transfer */
550             require(erc20.transfer(msg.sender, _amount), "ERC20 transfer didn´t work");
551         }
552         
553         uint256 purchase_id = increment;
554         increment = increment.add(1);
555 
556         /* Create new purchase */
557         Purchase memory purchase = Purchase(_amount, msg.sender, msg.value, block.timestamp, isTokenSwapAtomic /* If Atomic Swap */, false);
558         purchases[purchase_id] = purchase;
559         purchaseIds.push(purchase_id);
560         myPurchases[msg.sender].push(purchase_id);
561         buyers.push(msg.sender);
562         tokensAllocated = tokensAllocated.add(_amount);
563         emit PurchaseEvent(_amount, msg.sender, block.timestamp);
564     }
565 
566     /* Redeem tokens when the sale was finalized */
567     function redeemTokens(uint256 purchase_id) external isNotAtomicSwap isSaleFinalized whenNotPaused {
568         /* Confirm it exists and was not finalized */
569         require((purchases[purchase_id].amount != 0) && !purchases[purchase_id].wasFinalized, "Purchase is either 0 or finalized");
570         require(isBuyer(purchase_id), "Address is not buyer");
571         purchases[purchase_id].wasFinalized = true;
572         require(erc20.transfer(msg.sender, purchases[purchase_id].amount), "ERC20 transfer failed");
573     }
574 
575     /* Retrieve Minumum Amount */
576     function redeemGivenMinimumGoalNotAchieved(uint256 purchase_id) external isSaleFinalized isNotAtomicSwap {
577         require(hasMinimumRaise(), "Minimum raise has to exist");
578         require(minimumRaiseNotAchieved(), "Minimum raise has to be reached");
579         /* Confirm it exists and was not finalized */
580         require((purchases[purchase_id].amount != 0) && !purchases[purchase_id].wasFinalized, "Purchase is either 0 or finalized");
581         require(isBuyer(purchase_id), "Address is not buyer");
582         purchases[purchase_id].wasFinalized = true;
583         purchases[purchase_id].reverted = true;
584         msg.sender.transfer(purchases[purchase_id].ethAmount);
585     }
586 
587     /* Admin Functions */
588     function withdrawFunds() external onlyOwner whenNotPaused isSaleFinalized {
589         require(minimumRaiseAchieved(), "Minimum raise has to be reached");
590         FEE_ADDRESS.transfer(address(this).balance.mul(feePercentage).div(100)); /* Fee Address */
591         msg.sender.transfer(address(this).balance);
592     }  
593     
594     function withdrawUnsoldTokens() external onlyOwner isSaleFinalized {
595         require(!unsoldTokensReedemed);
596         uint256 unsoldTokens;
597         if(hasMinimumRaise() && 
598             (cost(tokensAllocated) < cost(minimumRaise))){ /* Minimum Raise not reached */
599                 unsoldTokens = tokensForSale;
600         }else{
601             /* If minimum Raise Achieved Redeem All Tokens minus the ones */
602             unsoldTokens = tokensForSale.sub(tokensAllocated);
603         }
604 
605         if(unsoldTokens > 0){
606             unsoldTokensReedemed = true;
607             require(erc20.transfer(msg.sender, unsoldTokens), "ERC20 transfer failed");
608         }
609     }   
610 
611     function removeOtherERC20Tokens(address _tokenAddress, address _to) external onlyOwner isSaleFinalized {
612         require(_tokenAddress != address(erc20), "Token Address has to be diff than the erc20 subject to sale"); // Confirm tokens addresses are different from main sale one
613         ERC20 erc20Token = ERC20(_tokenAddress);
614         require(erc20Token.transfer(_to, erc20Token.balanceOf(address(this))), "ERC20 Token transfer failed");
615     } 
616 
617     /* Safe Pull function */
618     function safePull() payable external onlyOwner whenPaused {
619         msg.sender.transfer(address(this).balance);
620         erc20.transfer(msg.sender, erc20.balanceOf(address(this)));
621     }
622 }