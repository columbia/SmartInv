1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
164 
165 
166 
167 pragma solidity ^0.6.0;
168 
169 /**
170  * @dev Interface of the ERC20 standard as defined in the EIP.
171  */
172 interface IERC20 {
173     /**
174      * @dev Returns the amount of tokens in existence.
175      */
176     function totalSupply() external view returns (uint256);
177 
178     /**
179      * @dev Returns the amount of tokens owned by `account`.
180      */
181     function balanceOf(address account) external view returns (uint256);
182 
183     /**
184      * @dev Moves `amount` tokens from the caller's account to `recipient`.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transfer(address recipient, uint256 amount) external returns (bool);
191 
192     /**
193      * @dev Returns the remaining number of tokens that `spender` will be
194      * allowed to spend on behalf of `owner` through {transferFrom}. This is
195      * zero by default.
196      *
197      * This value changes when {approve} or {transferFrom} are called.
198      */
199     function allowance(address owner, address spender) external view returns (uint256);
200 
201     /**
202      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * IMPORTANT: Beware that changing an allowance with this method brings the risk
207      * that someone may use both the old and the new allowance by unfortunate
208      * transaction ordering. One possible solution to mitigate this race
209      * condition is to first reduce the spender's allowance to 0 and set the
210      * desired value afterwards:
211      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212      *
213      * Emits an {Approval} event.
214      */
215     function approve(address spender, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Moves `amount` tokens from `sender` to `recipient` using the
219      * allowance mechanism. `amount` is then deducted from the caller's
220      * allowance.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Emitted when `value` tokens are moved from one account (`from`) to
230      * another (`to`).
231      *
232      * Note that `value` may be zero.
233      */
234     event Transfer(address indexed from, address indexed to, uint256 value);
235 
236     /**
237      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
238      * a call to {approve}. `value` is the new allowance.
239      */
240     event Approval(address indexed owner, address indexed spender, uint256 value);
241 }
242 
243 // File: @openzeppelin/contracts/GSN/Context.sol
244 
245 
246 
247 pragma solidity ^0.6.0;
248 
249 /*
250  * @dev Provides information about the current execution context, including the
251  * sender of the transaction and its data. While these are generally available
252  * via msg.sender and msg.data, they should not be accessed in such a direct
253  * manner, since when dealing with GSN meta-transactions the account sending and
254  * paying for execution may not be the actual sender (as far as an application
255  * is concerned).
256  *
257  * This contract is only required for intermediate, library-like contracts.
258  */
259 abstract contract Context {
260     function _msgSender() internal view virtual returns (address payable) {
261         return msg.sender;
262     }
263 
264     function _msgData() internal view virtual returns (bytes memory) {
265         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
266         return msg.data;
267     }
268 }
269 
270 // File: contracts/Ownable.sol
271 
272 pragma solidity ^0.6.10;
273 
274 
275 contract Ownable is Context {
276 
277     address public owner;
278     address private dev;
279 
280     modifier onlyOwner() {
281         require(_msgSender() == owner, "Owner only");
282         _;
283     }
284 
285     modifier onlyDev() {
286         require(_msgSender() == dev, "Dev only");
287         _;
288     }
289 
290     constructor(address _dev) public {
291         owner = _msgSender();
292         dev = _dev;
293     }
294 
295     function transferOwnership(address payable _owner) public onlyOwner() {
296         owner = _owner;
297     }
298 
299     function transferDev(address _dev) public onlyDev() {
300         dev = _dev;
301     }
302 
303 }
304 
305 // File: contracts/NFYTradingPlatform.sol
306 
307 pragma solidity 0.6.10;
308 pragma experimental ABIEncoderV2;
309 
310 
311 
312 
313 interface NFTContract {
314     function ownerOf(uint256 tokenId) external view returns (address owner);
315     function nftTokenId(address _stakeholder) external view returns(uint256 id);
316 }
317 
318 contract NFYTradingPlatform is Ownable {
319     using SafeMath for uint;
320 
321     bytes32[] private stakeTokenList;
322     uint private nextTradeId;
323     uint private nextOrderId;
324 
325     uint public platformFee;
326 
327     IERC20 public NFYToken;
328     address public rewardPool;
329     address public communityFund;
330     address public devAddress;
331 
332     enum Side {
333         BUY,
334         SELL
335     }
336 
337     struct StakeToken {
338         bytes32 ticker;
339         NFTContract nftContract;
340         address nftAddress;
341         address stakingAddress;
342     }
343 
344     struct Order {
345         uint id;
346         address userAddress;
347         Side side;
348         bytes32 ticker;
349         uint amount;
350         uint filled;
351         uint price;
352         uint date;
353     }
354 
355     struct PendingTransactions{
356         uint pendingAmount;
357         uint id;
358     }
359 
360     mapping(bytes32 => mapping(address => PendingTransactions[])) private pendingETH;
361 
362     mapping(bytes32 => mapping(address => PendingTransactions[])) private pendingToken;
363 
364     mapping(bytes32 => StakeToken) private tokens;
365 
366     mapping(address => mapping(bytes32 => uint)) private traderBalances;
367 
368     mapping(bytes32 => mapping(uint => Order[])) private orderBook;
369 
370     mapping(address => uint) private ethBalance;
371 
372     // Event for a new trade
373     event NewTrade(
374         uint tradeId,
375         uint orderId,
376         bytes32 indexed ticker,
377         address trader1,
378         address trader2,
379         uint amount,
380         uint price,
381         uint date
382     );
383 
384     constructor(address _nfy, address _rewardPool, uint _fee, address _devFeeAddress, address _communityFundAddress, address _dev) Ownable(_dev) public {
385         NFYToken = IERC20(_nfy);
386         rewardPool = _rewardPool;
387         platformFee = _fee;
388         devAddress = _devFeeAddress;
389         communityFund = _communityFundAddress;
390     }
391 
392     // Function that updates platform fee
393     function setFee(uint _fee) external onlyOwner() {
394         platformFee = _fee;
395     }
396 
397     // Function that updates dev address for portion of fee
398     function setDevFeeAddress(address _devAddress) external onlyDev() {
399         require(_devAddress != address(0), "Can not be 0 address");
400         devAddress = _devAddress;
401     }
402 
403     // Function that updates community address for portion of fee
404     function setCommunityFeeAddress(address _communityAddress) external onlyOwner() {
405         require(_communityAddress != address(0), "Can not be 0 address");
406         communityFund = _communityAddress;
407     }
408 
409     // Function that gets balance of a user
410     function getTraderBalance(address _user, string memory ticker) external view returns(uint) {
411         bytes32 _ticker = stringToBytes32(ticker);
412 
413         return traderBalances[_user][_ticker];
414     }
415 
416     // Function that gets eth balance of a user
417     function getEthBalance(address _user) external view returns(uint) {
418         return ethBalance[_user];
419     }
420 
421     // Function that adds staking NFT
422     function addToken(string memory ticker, NFTContract _NFTContract, address _nftAddress, address _stakingAddress) onlyOwner() external {
423         bytes32 _ticker = stringToBytes32(ticker);
424         require(tokens[_ticker].stakingAddress == address(0), "Already exists");
425         tokens[_ticker] = StakeToken(_ticker, _NFTContract, _nftAddress, _stakingAddress);
426         stakeTokenList.push(_ticker);
427     }
428 
429     // Function that allows user to deposit staking NFT
430     function depositStake(string memory ticker, uint _tokenId, uint _amount) stakeNFTExist(ticker) external {
431         bytes32 _ticker = stringToBytes32(ticker);
432         require(tokens[_ticker].nftContract.ownerOf(_tokenId) == _msgSender(), "Owner of token is not user");
433 
434         (bool success, ) = tokens[_ticker].stakingAddress.call(abi.encodeWithSignature("decrementNFTValue(uint256,uint256)", _tokenId, _amount));
435         require(success == true, "decrement call failed");
436 
437         traderBalances[_msgSender()][_ticker] = traderBalances[_msgSender()][_ticker].add(_amount);
438     }
439 
440     // Function that allows a user to withdraw their staking NFT
441     function withdrawStake(string memory ticker, uint _amount) stakeNFTExist(ticker) external {
442         bytes32 _ticker = stringToBytes32(ticker);
443 
444         if(tokens[_ticker].nftContract.nftTokenId(_msgSender()) == 0){
445 
446             // Call to contract to add stake holder
447             (bool addSuccess, ) = tokens[_ticker].stakingAddress.call(abi.encodeWithSignature("addStakeholderExternal(address)", _msgSender()));
448             require(addSuccess == true, "add stakeholder call failed");
449         }
450 
451         uint _tokenId = tokens[_ticker].nftContract.nftTokenId(_msgSender());
452         require(traderBalances[_msgSender()][_ticker] >= _amount, 'balance too low');
453 
454         traderBalances[_msgSender()][_ticker] = traderBalances[_msgSender()][_ticker].sub(_amount);
455 
456         (bool success, ) = tokens[_ticker].stakingAddress.call(abi.encodeWithSignature("incrementNFTValue(uint256,uint256)", _tokenId, _amount));
457         require(success == true, "increment call failed");
458     }
459 
460     // Function that deposits eth
461     function depositEth() external payable{
462         ethBalance[_msgSender()] = ethBalance[_msgSender()].add(msg.value);
463     }
464 
465     // Function that withdraws eth
466     function withdrawEth(uint _amount) external{
467         require(_amount > 0, "cannot withdraw 0 eth");
468         require(ethBalance[_msgSender()] >= _amount, "Not enough eth in trading balance");
469 
470         ethBalance[_msgSender()] = ethBalance[_msgSender()].sub(_amount);
471 
472         _msgSender().transfer(_amount);
473     }
474 
475     // Function that gets total all orders
476     function getOrders(string memory ticker, Side side) external view returns(Order[] memory) {
477         bytes32 _ticker = stringToBytes32(ticker);
478         return orderBook[_ticker][uint(side)];
479      }
480 
481     // Function that gets all trading
482     function getTokens() external view returns(StakeToken[] memory) {
483          StakeToken[] memory _tokens = new StakeToken[](stakeTokenList.length);
484          for (uint i = 0; i < stakeTokenList.length; i++) {
485              _tokens[i] = StakeToken(
486                tokens[stakeTokenList[i]].ticker,
487                tokens[stakeTokenList[i]].nftContract,
488                tokens[stakeTokenList[i]].nftAddress,
489                tokens[stakeTokenList[i]].stakingAddress
490              );
491          }
492          return _tokens;
493     }
494 
495     // Function that creates limit order
496     function createLimitOrder(string memory ticker, uint _amount, uint _price, Side _side) external {
497 
498         uint devFee = platformFee.mul(10).div(100);
499         uint communityFee = platformFee.mul(5).div(100);
500 
501         uint rewardFee = platformFee.sub(devFee).sub(communityFee);
502 
503         NFYToken.transferFrom(_msgSender(), devAddress, devFee);
504         NFYToken.transferFrom(_msgSender(), communityFund, communityFee);
505         NFYToken.transferFrom(_msgSender(), rewardPool, rewardFee);
506 
507         _limitOrder(ticker, _amount, _price, _side);
508     }
509 
510     // Limit order Function
511     function _limitOrder(string memory ticker, uint _amount, uint _price, Side _side) stakeNFTExist(ticker) internal {
512         bytes32 _ticker = stringToBytes32(ticker);
513         require(_amount > 0, "Amount can not be 0");
514         require(_price > 0, "Price can not be 0");
515 
516         Order[] storage orders = orderBook[_ticker][uint(_side == Side.BUY ? Side.SELL : Side.BUY)];
517         if(orders.length == 0){
518             _createOrder(_ticker, _amount, _price, _side);
519         }
520         else{
521             if(_side == Side.BUY){
522                 uint remaining = _amount;
523                 uint i;
524                 uint orderLength = orders.length;
525                 while(i < orders.length && remaining > 0) {
526 
527                     if(_price >= orders[i].price){
528                         remaining = _matchOrder(_ticker,orders, remaining, i, _side);
529                         nextTradeId = nextTradeId.add(1);
530 
531                         if(orders.length.sub(i) == 1 && remaining > 0){
532                             _createOrder(_ticker, remaining, _price, _side);
533                         }
534                         i = i.add(1);
535                     }
536                     else{
537                         i = orderLength;
538                         if(remaining > 0){
539                             _createOrder(_ticker, remaining, _price, _side);
540                         }
541                     }
542                 }
543             }
544 
545             if(_side == Side.SELL){
546                 uint remaining = _amount;
547                 uint i;
548                 uint orderLength = orders.length;
549                 while(i < orders.length && remaining > 0) {
550                     if(_price <= orders[i].price){
551                         remaining = _matchOrder(_ticker,orders, remaining, i, _side);
552                         nextTradeId = nextTradeId.add(1);
553 
554                         if(orders.length.sub(i) == 1 && remaining > 0){
555                             _createOrder(_ticker, remaining, _price, _side);
556                         }
557                         i = i.add(1);
558                     }
559                     else{
560                         i = orderLength;
561                         if(remaining > 0){
562                             _createOrder(_ticker, remaining, _price, _side);
563                         }
564                     }
565                 }
566             }
567 
568            uint i = 0;
569 
570             while(i < orders.length && orders[i].filled == orders[i].amount) {
571                 for(uint j = i; j < orders.length.sub(1); j = j.add(1) ) {
572                     orders[j] = orders[j.add(1)];
573                 }
574             orders.pop();
575             i = i.add(1);
576             }
577         }
578     }
579 
580     function _createOrder(bytes32 _ticker, uint _amount, uint _price, Side _side) internal {
581         if(_side == Side.BUY) {
582             require(ethBalance[_msgSender()] > 0, "Can not purchase no stake");
583             require(ethBalance[_msgSender()] >= _amount.mul(_price).div(1e18), "Eth too low");
584             PendingTransactions[] storage pending = pendingETH[_ticker][_msgSender()];
585             pending.push(PendingTransactions(_amount.mul(_price).div(1e18), nextOrderId));
586             ethBalance[_msgSender()] = ethBalance[_msgSender()].sub(_amount.mul(_price).div(1e18));
587         }
588         else {
589             require(traderBalances[_msgSender()][_ticker] >= _amount, "Token too low");
590             PendingTransactions[] storage pending = pendingToken[_ticker][_msgSender()];
591             pending.push(PendingTransactions(_amount, nextOrderId));
592             traderBalances[_msgSender()][_ticker] = traderBalances[_msgSender()][_ticker].sub(_amount);
593         }
594 
595         Order[] storage orders = orderBook[_ticker][uint(_side)];
596 
597         orders.push(Order(
598             nextOrderId,
599             _msgSender(),
600             _side,
601             _ticker,
602             _amount,
603             0,
604             _price,
605             now
606         ));
607 
608         uint i = orders.length > 0 ? orders.length.sub(1) : 0;
609         while(i > 0) {
610             if(_side == Side.BUY && orders[i.sub(1)].price > orders[i].price) {
611                 break;
612             }
613             if(_side == Side.SELL && orders[i.sub(1)].price < orders[i].price) {
614                 break;
615             }
616             Order memory order = orders[i.sub(1)];
617             orders[i.sub(1)] = orders[i];
618             orders[i] = order;
619             i = i.sub(1);
620         }
621         nextOrderId = nextOrderId.add(1);
622     }
623 
624     function _matchOrder(bytes32 _ticker, Order[] storage orders, uint remaining, uint i, Side side) internal returns(uint left){
625         uint available = orders[i].amount.sub(orders[i].filled);
626         uint matched = (remaining > available) ? available : remaining;
627         remaining = remaining.sub(matched);
628         orders[i].filled = orders[i].filled.add(matched);
629 
630         emit NewTrade(
631             nextTradeId,
632             orders[i].id,
633             _ticker,
634             orders[i].userAddress,
635             _msgSender(),
636             matched,
637             orders[i].price,
638             now
639         );
640 
641         if(side == Side.SELL) {
642             traderBalances[_msgSender()][_ticker] = traderBalances[_msgSender()][_ticker].sub(matched);
643             traderBalances[orders[i].userAddress][_ticker] = traderBalances[orders[i].userAddress][_ticker].add(matched);
644             ethBalance[_msgSender()]  = ethBalance[_msgSender()].add(matched.mul(orders[i].price).div(1e18));
645 
646             PendingTransactions[] storage pending = pendingETH[_ticker][orders[i].userAddress];
647             uint userOrders = pending.length;
648             uint b = 0;
649             uint id = orders[i].id;
650             while(b < userOrders){
651                 if(pending[b].id == id && orders[i].filled == orders[i].amount){
652                     for(uint o = b; o < userOrders.sub(1); o = o.add(1)){
653                         pending[o] = pending[o.add(1)];
654                         b = userOrders;
655                     }
656                     pending.pop();
657                 }
658                 b = b.add(1);
659             }
660         }
661 
662         if(side == Side.BUY) {
663             require(ethBalance[_msgSender()] >= matched.mul(orders[i].price).div(1e18), 'eth balance too low');
664             traderBalances[_msgSender()][_ticker] = traderBalances[_msgSender()][_ticker].add(matched);
665             ethBalance[orders[i].userAddress]  = ethBalance[orders[i].userAddress].add(matched.mul(orders[i].price).div(1e18));
666             ethBalance[_msgSender()]  = ethBalance[_msgSender()].sub(matched.mul(orders[i].price).div(1e18));
667 
668             PendingTransactions[] storage pending = pendingToken[_ticker][orders[i].userAddress];
669             uint userOrders = pending.length;
670             uint b = 0;
671             while(b < userOrders){
672                 if(pending[b].id == orders[i].id && orders[i].filled == orders[i].amount){
673                     for(uint o = b; o < userOrders.sub(1); o = o.add(1)){
674                         pending[o] = pending[o.add(1)];
675                         b = userOrders;
676                     }
677                     pending.pop();
678                 }
679                 b = b.add(1);
680             }
681         }
682         left = remaining;
683         return left;
684     }
685 
686     function cancelOrder(string memory ticker, Side _side) external stakeNFTExist(ticker) {
687         bytes32 _ticker = stringToBytes32(ticker);
688 
689         Order[] storage orders = orderBook[_ticker][uint(_side)];
690 
691         if(_side == Side.BUY) {
692             PendingTransactions[] storage pending = pendingETH[_ticker][_msgSender()];
693             uint amount = _cancelOrder(pending, orders, _side);
694             ethBalance[_msgSender()]  = ethBalance[_msgSender()].add(amount);
695         }
696         else{
697             PendingTransactions[] storage pending = pendingToken[_ticker][_msgSender()];
698             uint amount = _cancelOrder(pending, orders, _side);
699             traderBalances[_msgSender()][_ticker] = traderBalances[_msgSender()][_ticker].add(amount);
700         }
701     }
702 
703     function _cancelOrder(PendingTransactions[] storage pending, Order[] storage orders, Side _side) internal returns(uint left){
704         int userOrders = int(pending.length - 1);
705         require(userOrders >= 0, 'users has no pending order');
706         uint userOrder = uint(userOrders);
707         uint orderId = pending[userOrder].id;
708         uint orderLength = orders.length;
709 
710         uint i = 0;
711         uint amount;
712 
713         while(i < orders.length){
714 
715            if(orders[i].id == orderId){
716 
717                 if(_side == Side.BUY){
718                     amount = pending[userOrder].pendingAmount.sub(orders[i].filled.mul(orders[i].price).div(1e18));
719                 }
720 
721                 else {
722                     amount = pending[userOrder].pendingAmount.sub(orders[i].filled);
723                 }
724 
725                 for(uint c = i; c < orders.length.sub(1); c = c.add(1)){
726                     orders[c] = orders[c.add(1)];
727                 }
728 
729                 orders.pop();
730                 pending.pop();
731                 i = orderLength;
732            }
733 
734            i = i.add(1);
735         }
736         left = amount;
737         return left;
738     }
739 
740     modifier stakeNFTExist(string memory ticker) {
741         bytes32 _ticker = stringToBytes32(ticker);
742         require(tokens[_ticker].stakingAddress != address(0), "staking NFT does not exist");
743         _;
744     }
745 
746     //HELPER FUNCTION
747     // CONVERT STRING TO BYTES32
748 
749     function stringToBytes32(string memory _source)
750     public pure
751     returns (bytes32 result) {
752         bytes memory tempEmptyStringTest = bytes(_source);
753         string memory tempSource = _source;
754 
755         if (tempEmptyStringTest.length == 0) {
756             return 0x0;
757         }
758 
759         assembly {
760             result := mload(add(tempSource, 32))
761         }
762     }
763 
764 }