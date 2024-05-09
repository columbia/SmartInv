1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
120 
121 /**
122  * @title Pausable
123  * @dev Base contract which allows children to implement an emergency stop mechanism.
124  */
125 contract Pausable is Ownable {
126   event Pause();
127   event Unpause();
128 
129   bool public paused = false;
130 
131 
132   /**
133    * @dev Modifier to make a function callable only when the contract is not paused.
134    */
135   modifier whenNotPaused() {
136     require(!paused);
137     _;
138   }
139 
140   /**
141    * @dev Modifier to make a function callable only when the contract is paused.
142    */
143   modifier whenPaused() {
144     require(paused);
145     _;
146   }
147 
148   /**
149    * @dev called by the owner to pause, triggers stopped state
150    */
151   function pause() public onlyOwner whenNotPaused {
152     paused = true;
153     emit Pause();
154   }
155 
156   /**
157    * @dev called by the owner to unpause, returns to normal state
158    */
159   function unpause() public onlyOwner whenPaused {
160     paused = false;
161     emit Unpause();
162   }
163 }
164 
165 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
166 
167 /**
168  * @title ERC20Basic
169  * @dev Simpler version of ERC20 interface
170  * See https://github.com/ethereum/EIPs/issues/179
171  */
172 contract ERC20Basic {
173   function totalSupply() public view returns (uint256);
174   function balanceOf(address _who) public view returns (uint256);
175   function transfer(address _to, uint256 _value) public returns (bool);
176   event Transfer(address indexed from, address indexed to, uint256 value);
177 }
178 
179 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address _owner, address _spender)
187     public view returns (uint256);
188 
189   function transferFrom(address _from, address _to, uint256 _value)
190     public returns (bool);
191 
192   function approve(address _spender, uint256 _value) public returns (bool);
193   event Approval(
194     address indexed owner,
195     address indexed spender,
196     uint256 value
197   );
198 }
199 
200 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
201 
202 /**
203  * @title SafeERC20
204  * @dev Wrappers around ERC20 operations that throw on failure.
205  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
206  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
207  */
208 library SafeERC20 {
209   function safeTransfer(
210     ERC20Basic _token,
211     address _to,
212     uint256 _value
213   )
214     internal
215   {
216     require(_token.transfer(_to, _value));
217   }
218 
219   function safeTransferFrom(
220     ERC20 _token,
221     address _from,
222     address _to,
223     uint256 _value
224   )
225     internal
226   {
227     require(_token.transferFrom(_from, _to, _value));
228   }
229 
230   function safeApprove(
231     ERC20 _token,
232     address _spender,
233     uint256 _value
234   )
235     internal
236   {
237     require(_token.approve(_spender, _value));
238   }
239 }
240 
241 // File: contracts/IMonethaVoucher.sol
242 
243 interface IMonethaVoucher {
244     /**
245     * @dev Total number of vouchers in shared pool
246     */
247     function totalInSharedPool() external view returns (uint256);
248 
249     /**
250      * @dev Converts vouchers to equivalent amount of wei.
251      * @param _value amount of vouchers (vouchers) to convert to amount of wei
252      * @return A uint256 specifying the amount of wei.
253      */
254     function toWei(uint256 _value) external view returns (uint256);
255 
256     /**
257      * @dev Converts amount of wei to equivalent amount of vouchers.
258      * @param _value amount of wei to convert to vouchers (vouchers)
259      * @return A uint256 specifying the amount of vouchers.
260      */
261     function fromWei(uint256 _value) external view returns (uint256);
262 
263     /**
264      * @dev Applies discount for address by returning vouchers to shared pool and transferring funds (in wei). May be called only by Monetha.
265      * @param _for address to apply discount for
266      * @param _vouchers amount of vouchers to return to shared pool
267      * @return Actual number of vouchers returned to shared pool and amount of funds (in wei) transferred.
268      */
269     function applyDiscount(address _for, uint256 _vouchers) external returns (uint256 amountVouchers, uint256 amountWei);
270 
271     /**
272      * @dev Applies payback by transferring vouchers from the shared pool to the user.
273      * The amount of transferred vouchers is equivalent to the amount of Ether in the `_amountWei` parameter.
274      * @param _for address to apply payback for
275      * @param _amountWei amount of Ether to estimate the amount of vouchers
276      * @return The number of vouchers added
277      */
278     function applyPayback(address _for, uint256 _amountWei) external returns (uint256 amountVouchers);
279 
280     /**
281      * @dev Function to buy vouchers by transferring equivalent amount in Ether to contract. May be called only by Monetha.
282      * After the vouchers are purchased, they can be sold or released to another user. Purchased vouchers are stored in
283      * a separate pool and may not be expired.
284      * @param _vouchers The amount of vouchers to buy. The caller must also transfer an equivalent amount of Ether.
285      */
286     function buyVouchers(uint256 _vouchers) external payable;
287 
288     /**
289      * @dev The function allows Monetha account to sell previously purchased vouchers and get Ether from the sale.
290      * The equivalent amount of Ether will be transferred to the caller. May be called only by Monetha.
291      * @param _vouchers The amount of vouchers to sell.
292      * @return A uint256 specifying the amount of Ether (in wei) transferred to the caller.
293      */
294     function sellVouchers(uint256 _vouchers) external returns(uint256 weis);
295 
296     /**
297      * @dev Function allows Monetha account to release the purchased vouchers to any address.
298      * The released voucher acquires an expiration property and should be used in Monetha ecosystem within 6 months, otherwise
299      * it will be returned to shared pool. May be called only by Monetha.
300      * @param _to address to release vouchers to.
301      * @param _value the amount of vouchers to release.
302      */
303     function releasePurchasedTo(address _to, uint256 _value) external returns (bool);
304 
305     /**
306      * @dev Function to check the amount of vouchers that an owner (Monetha account) allowed to sell or release to some user.
307      * @param owner The address which owns the funds.
308      * @return A uint256 specifying the amount of vouchers still available for the owner.
309      */
310     function purchasedBy(address owner) external view returns (uint256);
311 }
312 
313 // File: monetha-utility-contracts/contracts/Restricted.sol
314 
315 /** @title Restricted
316  *  Exposes onlyMonetha modifier
317  */
318 contract Restricted is Ownable {
319 
320     //MonethaAddress set event
321     event MonethaAddressSet(
322         address _address,
323         bool _isMonethaAddress
324     );
325 
326     mapping (address => bool) public isMonethaAddress;
327 
328     /**
329      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
330      */
331     modifier onlyMonetha() {
332         require(isMonethaAddress[msg.sender]);
333         _;
334     }
335 
336     /**
337      *  Allows owner to set new monetha address
338      */
339     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
340         isMonethaAddress[_address] = _isMonethaAddress;
341 
342         emit MonethaAddressSet(_address, _isMonethaAddress);
343     }
344 }
345 
346 // File: monetha-utility-contracts/contracts/DateTime.sol
347 
348 library DateTime {
349     /**
350     * @dev For a given timestamp , toDate() converts it to specific Date.
351     */
352     function toDate(uint256 _ts) internal pure returns (uint256 year, uint256 month, uint256 day) {
353         _ts /= 86400;
354         uint256 a = (4 * _ts + 102032) / 146097 + 15;
355         uint256 b = _ts + 2442113 + a - (a / 4);
356         year = (20 * b - 2442) / 7305;
357         uint256 d = b - 365 * year - (year / 4);
358         month = d * 1000 / 30601;
359         day = d - month * 30 - month * 601 / 1000;
360 
361         //January and February are counted as months 13 and 14 of the previous year
362         if (month <= 13) {
363             year -= 4716;
364             month -= 1;
365         } else {
366             year -= 4715;
367             month -= 13;
368         }
369     }
370 
371     /**
372     * @dev Converts a given date to timestamp.
373     */
374     function toTimestamp(uint256 _year, uint256 _month, uint256 _day) internal pure returns (uint256 ts) {
375         //January and February are counted as months 13 and 14 of the previous year
376         if (_month <= 2) {
377             _month += 12;
378             _year -= 1;
379         }
380 
381         // Convert years to days
382         ts = (365 * _year) + (_year / 4) - (_year / 100) + (_year / 400);
383         //Convert months to days
384         ts += (30 * _month) + (3 * (_month + 1) / 5) + _day;
385         //Unix time starts on January 1st, 1970
386         ts -= 719561;
387         //Convert days to seconds
388         ts *= 86400;
389     }
390 }
391 
392 // File: contracts/ownership/CanReclaimEther.sol
393 
394 contract CanReclaimEther is Ownable {
395     event ReclaimEther(address indexed to, uint256 amount);
396 
397     /**
398      * @dev Transfer all Ether held by the contract to the owner.
399      */
400     function reclaimEther() external onlyOwner {
401         uint256 value = address(this).balance;
402         owner.transfer(value);
403 
404         emit ReclaimEther(owner, value);
405     }
406 
407     /**
408      * @dev Transfer specified amount of Ether held by the contract to the address.
409      * @param _to The address which will receive the Ether
410      * @param _value The amount of Ether to transfer
411      */
412     function reclaimEtherTo(address _to, uint256 _value) external onlyOwner {
413         require(_to != address(0), "zero address is not allowed");
414         _to.transfer(_value);
415 
416         emit ReclaimEther(_to, _value);
417     }
418 }
419 
420 // File: contracts/ownership/CanReclaimTokens.sol
421 
422 contract CanReclaimTokens is Ownable {
423     using SafeERC20 for ERC20Basic;
424 
425     event ReclaimTokens(address indexed to, uint256 amount);
426 
427     /**
428      * @dev Reclaim all ERC20Basic compatible tokens
429      * @param _token ERC20Basic The address of the token contract
430      */
431     function reclaimToken(ERC20Basic _token) external onlyOwner {
432         uint256 balance = _token.balanceOf(this);
433         _token.safeTransfer(owner, balance);
434 
435         emit ReclaimTokens(owner, balance);
436     }
437 
438     /**
439      * @dev Reclaim specified amount of ERC20Basic compatible tokens
440      * @param _token ERC20Basic The address of the token contract
441      * @param _to The address which will receive the tokens
442      * @param _value The amount of tokens to transfer
443      */
444     function reclaimTokenTo(ERC20Basic _token, address _to, uint256 _value) external onlyOwner {
445         require(_to != address(0), "zero address is not allowed");
446         _token.safeTransfer(_to, _value);
447 
448         emit ReclaimTokens(_to, _value);
449     }
450 }
451 
452 // File: contracts/MonethaTokenHoldersProgram.sol
453 
454 contract MonethaTokenHoldersProgram is Restricted, Pausable, CanReclaimEther, CanReclaimTokens {
455     using SafeMath for uint256;
456     using SafeERC20 for ERC20;
457     using SafeERC20 for ERC20Basic;
458 
459     event VouchersPurchased(uint256 vouchers, uint256 weis);
460     event VouchersSold(uint256 vouchers, uint256 weis);
461     event ParticipationStarted(address indexed participant, uint256 mthTokens);
462     event ParticipationStopped(address indexed participant, uint256 mthTokens);
463     event VouchersRedeemed(address indexed participant, uint256 vouchers);
464 
465     ERC20 public mthToken;
466     IMonethaVoucher public monethaVoucher;
467 
468     uint256 public participateFromTimestamp;
469 
470     mapping(address => uint256) public stakedBy;
471     uint256 public totalStacked;
472 
473     constructor(ERC20 _mthToken, IMonethaVoucher _monethaVoucher) public {
474         require(_monethaVoucher != address(0), "must be valid address");
475         require(_mthToken != address(0), "must be valid address");
476 
477         mthToken = _mthToken;
478         monethaVoucher = _monethaVoucher;
479         // don't allow to participate
480         participateFromTimestamp = uint256(- 1);
481     }
482 
483     /**
484      * @dev Before holders of MTH tokens can participate in the program, it is necessary to buy vouchers for the Ether
485      * available in the contract. 1/3 of Monetha's revenue will be transferred to this contract to buy the Monetha vouchers.
486      * This method uses all available Ethers of contract to buy Monetha vouchers.
487      * The method tries to buy the maximum possible amount of vouchers.
488      */
489     function buyVouchers() external onlyMonetha {
490         uint256 amountToExchange = address(this).balance;
491         require(amountToExchange > 0, "positive balance needed");
492 
493         uint256 vouchersAvailable = monethaVoucher.totalInSharedPool();
494         require(vouchersAvailable > 0, "no vouchers available");
495 
496         uint256 vouchersToBuy = monethaVoucher.fromWei(address(this).balance);
497         // limit vouchers
498         if (vouchersToBuy > vouchersAvailable) {
499             vouchersToBuy = vouchersAvailable;
500         }
501         // we should transfer exact amount of Ether which is equal to vouchers
502         amountToExchange = monethaVoucher.toWei(vouchersToBuy);
503 
504         (uint256 year, uint256 month,) = DateTime.toDate(now);
505         participateFromTimestamp = _nextMonth1stDayTimestamp(year, month);
506 
507         monethaVoucher.buyVouchers.value(amountToExchange)(vouchersToBuy);
508 
509         emit VouchersPurchased(vouchersToBuy, amountToExchange);
510     }
511 
512     /**
513      * @dev Converts all available vouchers to Ether and stops the program until vouchers are purchased again by
514      * calling `buyVouchers` method.
515      * Holders of MTH token holders can still call `cancelParticipation` method to reclaim the MTH tokens.
516      */
517     function sellVouchers() external onlyMonetha {
518         // don't allow to participate
519         participateFromTimestamp = uint256(- 1);
520 
521         uint256 vouchersPool = monethaVoucher.purchasedBy(address(this));
522         uint256 weis = monethaVoucher.sellVouchers(vouchersPool);
523 
524         emit VouchersSold(vouchersPool, weis);
525     }
526 
527     /**
528      * @dev Returns true when it's allowed to participate in token holders program, i.e. to call `participate()` method.
529      */
530     function isAllowedToParticipateNow() external view returns (bool) {
531         return now >= participateFromTimestamp && _participateIsAllowed(now);
532     }
533 
534     /**
535      * @dev To redeem vouchers, holders of MTH token must declare their participation on the 1st day of the month by calling
536      * this method. Before calling this method, holders of MTH token should approve this contract to transfer some amount
537      * of MTH tokens in their behalf, by calling `approve(address _spender, uint _value)` method of MTH token contract.
538      * `participate` method can be called on the first day of any month if the contract has purchased vouchers.
539      */
540     function participate() external {
541         require(now >= participateFromTimestamp, "too early to participate");
542         require(_participateIsAllowed(now), "participate on the 1st day of every month");
543 
544         uint256 allowedToTransfer = mthToken.allowance(msg.sender, address(this));
545         require(allowedToTransfer > 0, "positive allowance needed");
546 
547         mthToken.safeTransferFrom(msg.sender, address(this), allowedToTransfer);
548         stakedBy[msg.sender] = stakedBy[msg.sender].add(allowedToTransfer);
549         totalStacked = totalStacked.add(allowedToTransfer);
550 
551         emit ParticipationStarted(msg.sender, allowedToTransfer);
552     }
553 
554     /**
555      * @dev Returns true when it's allowed to redeem vouchers and reclaim MTH tokens, i.e. to call `redeem()` method.
556      */
557     function isAllowedToRedeemNow() external view returns (bool) {
558         return now >= participateFromTimestamp && _redeemIsAllowed(now);
559     }
560 
561     /**
562      * @dev Redeems vouchers to holder of MTH tokens and reclaims the MTH tokens.
563      * The method can be invoked only if the holder of the MTH tokens declared participation on the first day of the month.
564      * The method should be called half an hour after the beginning of the second day of the month and half an hour
565      * before the beginning of the next month.
566      */
567     function redeem() external {
568         require(now >= participateFromTimestamp, "too early to redeem");
569         require(_redeemIsAllowed(now), "redeem is not allowed at the moment");
570 
571         (uint256 stackedBefore, uint256 totalStackedBefore) = _cancelParticipation();
572 
573         uint256 vouchersPool = monethaVoucher.purchasedBy(address(this));
574         uint256 vouchers = vouchersPool.mul(stackedBefore).div(totalStackedBefore);
575 
576         require(monethaVoucher.releasePurchasedTo(msg.sender, vouchers), "vouchers was not released");
577 
578         emit VouchersRedeemed(msg.sender, vouchers);
579     }
580 
581     /**
582      * @dev Cancels participation of holder of MTH tokens at any time and reclaims MTH tokens.
583      */
584     function cancelParticipation() external {
585         _cancelParticipation();
586     }
587 
588     // Allows direct funds send by Monetha
589     function() external onlyMonetha payable {
590     }
591 
592     function _cancelParticipation() internal returns (uint256 stackedBefore, uint256 totalStackedBefore) {
593         stackedBefore = stakedBy[msg.sender];
594         require(stackedBefore > 0, "must be a participant");
595         totalStackedBefore = totalStacked;
596 
597         stakedBy[msg.sender] = 0;
598         totalStacked = totalStackedBefore.sub(stackedBefore);
599         mthToken.safeTransfer(msg.sender, stackedBefore);
600 
601         emit ParticipationStopped(msg.sender, stackedBefore);
602     }
603 
604     function _participateIsAllowed(uint256 _now) internal pure returns (bool) {
605         (,, uint256 day) = DateTime.toDate(_now);
606         return day == 1;
607     }
608 
609     function _redeemIsAllowed(uint256 _now) internal pure returns (bool) {
610         (uint256 year, uint256 month,) = DateTime.toDate(_now);
611         return _currentMonth2ndDayTimestamp(year, month) + 30 minutes <= _now &&
612         _now <= _nextMonth1stDayTimestamp(year, month) - 30 minutes;
613     }
614 
615     function _currentMonth2ndDayTimestamp(uint256 _year, uint256 _month) internal pure returns (uint256) {
616         return DateTime.toTimestamp(_year, _month, 2);
617     }
618 
619     function _nextMonth1stDayTimestamp(uint256 _year, uint256 _month) internal pure returns (uint256) {
620         _month += 1;
621         if (_month > 12) {
622             _year += 1;
623             _month = 1;
624         }
625         return DateTime.toTimestamp(_year, _month, 1);
626     }
627 }