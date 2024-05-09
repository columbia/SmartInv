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
346 // File: contracts/token/ERC20/IERC20.sol
347 
348 /**
349  * @title ERC20 interface
350  * @dev see https://github.com/ethereum/EIPs/issues/20
351  */
352 interface IERC20 {
353     function totalSupply() external view returns (uint256);
354 
355     function balanceOf(address who) external view returns (uint256);
356 
357     function allowance(address owner, address spender) external view returns (uint256);
358 
359     function transfer(address to, uint256 value) external returns (bool);
360 
361     function approve(address spender, uint256 value) external returns (bool);
362 
363     function transferFrom(address from, address to, uint256 value) external returns (bool);
364 
365     event Transfer(address indexed from, address indexed to, uint256 value);
366 
367     event Approval(address indexed owner, address indexed spender, uint256 value);
368 }
369 
370 // File: contracts/ownership/CanReclaimEther.sol
371 
372 contract CanReclaimEther is Ownable {
373     event ReclaimEther(address indexed to, uint256 amount);
374 
375     /**
376      * @dev Transfer all Ether held by the contract to the owner.
377      */
378     function reclaimEther() external onlyOwner {
379         uint256 value = address(this).balance;
380         owner.transfer(value);
381 
382         emit ReclaimEther(owner, value);
383     }
384 
385     /**
386      * @dev Transfer specified amount of Ether held by the contract to the address.
387      * @param _to The address which will receive the Ether
388      * @param _value The amount of Ether to transfer
389      */
390     function reclaimEtherTo(address _to, uint256 _value) external onlyOwner {
391         require(_to != address(0), "zero address is not allowed");
392         _to.transfer(_value);
393 
394         emit ReclaimEther(_to, _value);
395     }
396 }
397 
398 // File: contracts/ownership/CanReclaimTokens.sol
399 
400 contract CanReclaimTokens is Ownable {
401     using SafeERC20 for ERC20Basic;
402 
403     event ReclaimTokens(address indexed to, uint256 amount);
404 
405     /**
406      * @dev Reclaim all ERC20Basic compatible tokens
407      * @param _token ERC20Basic The address of the token contract
408      */
409     function reclaimToken(ERC20Basic _token) external onlyOwner {
410         uint256 balance = _token.balanceOf(this);
411         _token.safeTransfer(owner, balance);
412 
413         emit ReclaimTokens(owner, balance);
414     }
415 
416     /**
417      * @dev Reclaim specified amount of ERC20Basic compatible tokens
418      * @param _token ERC20Basic The address of the token contract
419      * @param _to The address which will receive the tokens
420      * @param _value The amount of tokens to transfer
421      */
422     function reclaimTokenTo(ERC20Basic _token, address _to, uint256 _value) external onlyOwner {
423         require(_to != address(0), "zero address is not allowed");
424         _token.safeTransfer(_to, _value);
425 
426         emit ReclaimTokens(_to, _value);
427     }
428 }
429 
430 // File: contracts/MonethaVoucher.sol
431 
432 contract MonethaVoucher is IMonethaVoucher, Restricted, Pausable, IERC20, CanReclaimEther, CanReclaimTokens {
433     using SafeMath for uint256;
434     using SafeERC20 for ERC20Basic;
435 
436     event DiscountApplied(address indexed user, uint256 releasedVouchers, uint256 amountWeiTransferred);
437     event PaybackApplied(address indexed user, uint256 addedVouchers, uint256 amountWeiEquivalent);
438     event VouchersBought(address indexed user, uint256 vouchersBought);
439     event VouchersSold(address indexed user, uint256 vouchersSold, uint256 amountWeiTransferred);
440     event VoucherMthRateUpdated(uint256 oldVoucherMthRate, uint256 newVoucherMthRate);
441     event MthEthRateUpdated(uint256 oldMthEthRate, uint256 newMthEthRate);
442     event VouchersAdded(address indexed user, uint256 vouchersAdded);
443     event VoucherReleased(address indexed user, uint256 releasedVoucher);
444     event PurchasedVouchersReleased(address indexed from, address indexed to, uint256 vouchers);
445 
446     /* Public variables of the token */
447     string constant public standard = "ERC20";
448     string constant public name = "Monetha Voucher";
449     string constant public symbol = "MTHV";
450     uint8 constant public decimals = 5;
451 
452     /* For calculating half year */
453     uint256 constant private DAY_IN_SECONDS = 86400;
454     uint256 constant private YEAR_IN_SECONDS = 365 * DAY_IN_SECONDS;
455     uint256 constant private LEAP_YEAR_IN_SECONDS = 366 * DAY_IN_SECONDS;
456     uint256 constant private YEAR_IN_SECONDS_AVG = (YEAR_IN_SECONDS * 3 + LEAP_YEAR_IN_SECONDS) / 4;
457     uint256 constant private HALF_YEAR_IN_SECONDS_AVG = YEAR_IN_SECONDS_AVG / 2;
458 
459     uint256 constant public RATE_COEFFICIENT = 1000000000000000000; // 10^18
460     uint256 constant private RATE_COEFFICIENT2 = RATE_COEFFICIENT * RATE_COEFFICIENT; // RATE_COEFFICIENT^2
461     
462     uint256 public voucherMthRate; // number of voucher units in 10^18 MTH units
463     uint256 public mthEthRate; // number of mth units in 10^18 wei
464     uint256 internal voucherMthEthRate; // number of vouchers units (= voucherMthRate * mthEthRate) in 10^36 wei
465 
466     ERC20Basic public mthToken;
467 
468     mapping(address => uint256) public purchased; // amount of vouchers purchased by other monetha contract
469     uint256 public totalPurchased;                        // total amount of vouchers purchased by monetha
470 
471     mapping(uint16 => uint256) public totalDistributedIn; // аmount of vouchers distributed in specific half-year
472     mapping(uint16 => mapping(address => uint256)) public distributed; // amount of vouchers distributed in specific half-year to specific user
473 
474     constructor(uint256 _voucherMthRate, uint256 _mthEthRate, ERC20Basic _mthToken) public {
475         require(_voucherMthRate > 0, "voucherMthRate should be greater than 0");
476         require(_mthEthRate > 0, "mthEthRate should be greater than 0");
477         require(_mthToken != address(0), "must be valid contract");
478 
479         voucherMthRate = _voucherMthRate;
480         mthEthRate = _mthEthRate;
481         mthToken = _mthToken;
482         _updateVoucherMthEthRate();
483     }
484 
485     /**
486     * @dev Total number of vouchers in existence = vouchers in shared pool + vouchers distributed + vouchers purchased
487     */
488     function totalSupply() external view returns (uint256) {
489         return _totalVouchersSupply();
490     }
491 
492     /**
493     * @dev Total number of vouchers in shared pool
494     */
495     function totalInSharedPool() external view returns (uint256) {
496         return _vouchersInSharedPool(_currentHalfYear());
497     }
498 
499     /**
500     * @dev Total number of vouchers distributed
501     */
502     function totalDistributed() external view returns (uint256) {
503         return _vouchersDistributed(_currentHalfYear());
504     }
505 
506     /**
507     * @dev Gets the balance of the specified address.
508     * @param owner The address to query the balance of.
509     * @return An uint256 representing the amount owned by the passed address.
510     */
511     function balanceOf(address owner) external view returns (uint256) {
512         return _distributedTo(owner, _currentHalfYear()).add(purchased[owner]);
513     }
514 
515     /**
516      * @dev Function to check the amount of vouchers that an owner allowed to a spender.
517      * @param owner address The address which owns the funds.
518      * @param spender address The address which will spend the funds.
519      * @return A uint256 specifying the amount of vouchers still available for the spender.
520      */
521     function allowance(address owner, address spender) external view returns (uint256) {
522         owner;
523         spender;
524         return 0;
525     }
526 
527     /**
528     * @dev Transfer voucher for a specified address
529     * @param to The address to transfer to.
530     * @param value The amount to be transferred.
531     */
532     function transfer(address to, uint256 value) external returns (bool) {
533         to;
534         value;
535         revert();
536     }
537 
538     /**
539      * @dev Approve the passed address to spend the specified amount of vouchers on behalf of msg.sender.
540      * Beware that changing an allowance with this method brings the risk that someone may use both the old
541      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
542      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
543      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
544      * @param spender The address which will spend the funds.
545      * @param value The amount of vouchers to be spent.
546      */
547     function approve(address spender, uint256 value) external returns (bool) {
548         spender;
549         value;
550         revert();
551     }
552 
553     /**
554      * @dev Transfer vouchers from one address to another
555      * @param from address The address which you want to send vouchers from
556      * @param to address The address which you want to transfer to
557      * @param value uint256 the amount of vouchers to be transferred
558      */
559     function transferFrom(address from, address to, uint256 value) external returns (bool) {
560         from;
561         to;
562         value;
563         revert();
564     }
565 
566     // Allows direct funds send by Monetha
567     function () external onlyMonetha payable {
568     }
569 
570     /**
571      * @dev Converts vouchers to equivalent amount of wei.
572      * @param _value amount of vouchers to convert to amount of wei
573      * @return A uint256 specifying the amount of wei.
574      */
575     function toWei(uint256 _value) external view returns (uint256) {
576         return _vouchersToWei(_value);
577     }
578 
579     /**
580      * @dev Converts amount of wei to equivalent amount of vouchers.
581      * @param _value amount of wei to convert to vouchers
582      * @return A uint256 specifying the amount of vouchers.
583      */
584     function fromWei(uint256 _value) external view returns (uint256) {
585         return _weiToVouchers(_value);
586     }
587 
588     /**
589      * @dev Applies discount for address by returning vouchers to shared pool and transferring funds (in wei). May be called only by Monetha.
590      * @param _for address to apply discount for
591      * @param _vouchers amount of vouchers to return to shared pool
592      * @return Actual number of vouchers returned to shared pool and amount of funds (in wei) transferred.
593      */
594     function applyDiscount(address _for, uint256 _vouchers) external onlyMonetha returns (uint256 amountVouchers, uint256 amountWei) {
595         require(_for != address(0), "zero address is not allowed");
596         uint256 releasedVouchers = _releaseVouchers(_for, _vouchers);
597         if (releasedVouchers == 0) {
598             return (0,0);
599         }
600         
601         uint256 amountToTransfer = _vouchersToWei(releasedVouchers);
602 
603         require(address(this).balance >= amountToTransfer, "insufficient funds");
604         _for.transfer(amountToTransfer);
605 
606         emit DiscountApplied(_for, releasedVouchers, amountToTransfer);
607 
608         return (releasedVouchers, amountToTransfer);
609     }
610 
611     /**
612      * @dev Applies payback by transferring vouchers from the shared pool to the user.
613      * The amount of transferred vouchers is equivalent to the amount of Ether in the `_amountWei` parameter.
614      * @param _for address to apply payback for
615      * @param _amountWei amount of Ether to estimate the amount of vouchers
616      * @return The number of vouchers added
617      */
618     function applyPayback(address _for, uint256 _amountWei) external onlyMonetha returns (uint256 amountVouchers) {
619         amountVouchers = _weiToVouchers(_amountWei);
620         require(_addVouchers(_for, amountVouchers), "vouchers must be added");
621 
622         emit PaybackApplied(_for, amountVouchers, _amountWei);
623     }
624 
625     /**
626      * @dev Function to buy vouchers by transferring equivalent amount in Ether to contract. May be called only by Monetha.
627      * After the vouchers are purchased, they can be sold or released to another user. Purchased vouchers are stored in
628      * a separate pool and may not be expired.
629      * @param _vouchers The amount of vouchers to buy. The caller must also transfer an equivalent amount of Ether.
630      */
631     function buyVouchers(uint256 _vouchers) external onlyMonetha payable {
632         uint16 currentHalfYear = _currentHalfYear();
633         require(_vouchersInSharedPool(currentHalfYear) >= _vouchers, "insufficient vouchers present");
634         require(msg.value == _vouchersToWei(_vouchers), "insufficient funds");
635 
636         _addPurchasedTo(msg.sender, _vouchers);
637 
638         emit VouchersBought(msg.sender, _vouchers);
639     }
640 
641     /**
642      * @dev The function allows Monetha account to sell previously purchased vouchers and get Ether from the sale.
643      * The equivalent amount of Ether will be transferred to the caller. May be called only by Monetha.
644      * @param _vouchers The amount of vouchers to sell.
645      * @return A uint256 specifying the amount of Ether (in wei) transferred to the caller.
646      */
647     function sellVouchers(uint256 _vouchers) external onlyMonetha returns(uint256 weis) {
648         require(_vouchers <= purchased[msg.sender], "Insufficient vouchers");
649 
650         _subPurchasedFrom(msg.sender, _vouchers);
651         weis = _vouchersToWei(_vouchers);
652         msg.sender.transfer(weis);
653         
654         emit VouchersSold(msg.sender, _vouchers, weis);
655     }
656 
657     /**
658      * @dev Function allows Monetha account to release the purchased vouchers to any address.
659      * The released voucher acquires an expiration property and should be used in Monetha ecosystem within 6 months, otherwise
660      * it will be returned to shared pool. May be called only by Monetha.
661      * @param _to address to release vouchers to.
662      * @param _value the amount of vouchers to release.
663      */
664     function releasePurchasedTo(address _to, uint256 _value) external onlyMonetha returns (bool) {
665         require(_value <= purchased[msg.sender], "Insufficient Vouchers");
666         require(_to != address(0), "address should be valid");
667 
668         _subPurchasedFrom(msg.sender, _value);
669         _addVouchers(_to, _value);
670 
671         emit PurchasedVouchersReleased(msg.sender, _to, _value);
672 
673         return true;
674     }
675 
676     /**
677      * @dev Function to check the amount of vouchers that an owner (Monetha account) allowed to sell or release to some user.
678      * @param owner The address which owns the funds.
679      * @return A uint256 specifying the amount of vouchers still available for the owner.
680      */
681     function purchasedBy(address owner) external view returns (uint256) {
682         return purchased[owner];
683     }
684 
685     /**
686      * @dev updates voucherMthRate.
687      */
688     function updateVoucherMthRate(uint256 _voucherMthRate) external onlyMonetha {
689         require(_voucherMthRate > 0, "should be greater than 0");
690         require(voucherMthRate != _voucherMthRate, "same as previous value");
691 
692         voucherMthRate = _voucherMthRate;
693         _updateVoucherMthEthRate();
694 
695         emit VoucherMthRateUpdated(voucherMthRate, _voucherMthRate);
696     }
697 
698     /**
699      * @dev updates mthEthRate.
700      */
701     function updateMthEthRate(uint256 _mthEthRate) external onlyMonetha {
702         require(_mthEthRate > 0, "should be greater than 0");
703         require(mthEthRate != _mthEthRate, "same as previous value");
704         
705         mthEthRate = _mthEthRate;
706         _updateVoucherMthEthRate();
707 
708         emit MthEthRateUpdated(mthEthRate, _mthEthRate);
709     }
710 
711     function _addPurchasedTo(address _to, uint256 _value) internal {
712         purchased[_to] = purchased[_to].add(_value);
713         totalPurchased = totalPurchased.add(_value);
714     }
715 
716     function _subPurchasedFrom(address _from, uint256 _value) internal {
717         purchased[_from] = purchased[_from].sub(_value);
718         totalPurchased = totalPurchased.sub(_value);
719     }
720 
721     function _updateVoucherMthEthRate() internal {
722         voucherMthEthRate = voucherMthRate.mul(mthEthRate);
723     }
724 
725     /**
726      * @dev Transfer vouchers from shared pool to address. May be called only by Monetha.
727      * @param _to The address to transfer to.
728      * @param _value The amount to be transferred.
729      */
730     function _addVouchers(address _to, uint256 _value) internal returns (bool) {
731         require(_to != address(0), "zero address is not allowed");
732 
733         uint16 currentHalfYear = _currentHalfYear();
734         require(_vouchersInSharedPool(currentHalfYear) >= _value, "must be less or equal than vouchers present in shared pool");
735 
736         uint256 oldDist = totalDistributedIn[currentHalfYear];
737         totalDistributedIn[currentHalfYear] = oldDist.add(_value);
738         uint256 oldBalance = distributed[currentHalfYear][_to];
739         distributed[currentHalfYear][_to] = oldBalance.add(_value);
740 
741         emit VouchersAdded(_to, _value);
742 
743         return true;
744     }
745 
746     /**
747      * @dev Transfer vouchers from address to shared pool
748      * @param _from address The address which you want to send vouchers from
749      * @param _value uint256 the amount of vouchers to be transferred
750      * @return A uint256 specifying the amount of vouchers released to shared pool.
751      */
752     function _releaseVouchers(address _from, uint256 _value) internal returns (uint256) {
753         require(_from != address(0), "must be valid address");
754 
755         uint16 currentHalfYear = _currentHalfYear();
756         uint256 released = 0;
757         if (currentHalfYear > 0) {
758             released = released.add(_releaseVouchers(_from, _value, currentHalfYear - 1));
759             _value = _value.sub(released);
760         }
761         released = released.add(_releaseVouchers(_from, _value, currentHalfYear));
762 
763         emit VoucherReleased(_from, released);
764 
765         return released;
766     }
767 
768     function _releaseVouchers(address _from, uint256 _value, uint16 _currentHalfYear) internal returns (uint256) {
769         if (_value == 0) {
770             return 0;
771         }
772 
773         uint256 oldBalance = distributed[_currentHalfYear][_from];
774         uint256 subtracted = _value;
775         if (oldBalance <= _value) {
776             delete distributed[_currentHalfYear][_from];
777             subtracted = oldBalance;
778         } else {
779             distributed[_currentHalfYear][_from] = oldBalance.sub(_value);
780         }
781 
782         uint256 oldDist = totalDistributedIn[_currentHalfYear];
783         if (oldDist == subtracted) {
784             delete totalDistributedIn[_currentHalfYear];
785         } else {
786             totalDistributedIn[_currentHalfYear] = oldDist.sub(subtracted);
787         }
788         return subtracted;
789     }
790 
791     // converts vouchers to Ether (in wei)
792     function _vouchersToWei(uint256 _value) internal view returns (uint256) {
793         return _value.mul(RATE_COEFFICIENT2).div(voucherMthEthRate);
794     }
795 
796     // converts Ether (in wei) to vouchers
797     function _weiToVouchers(uint256 _value) internal view returns (uint256) {
798         return _value.mul(voucherMthEthRate).div(RATE_COEFFICIENT2);
799     }
800 
801     // converts MTH tokens to vouchers
802     function _mthToVouchers(uint256 _value) internal view returns (uint256) {
803         return _value.mul(voucherMthRate).div(RATE_COEFFICIENT);
804     }
805 
806     // converts Ether (in wei) to MTH
807     function _weiToMth(uint256 _value) internal view returns (uint256) {
808         return _value.mul(mthEthRate).div(RATE_COEFFICIENT);
809     }
810 
811     function _totalVouchersSupply() internal view returns (uint256) {
812         return _mthToVouchers(mthToken.balanceOf(address(this)));
813     }
814 
815     function _vouchersInSharedPool(uint16 _currentHalfYear) internal view returns (uint256) {
816         return _totalVouchersSupply().sub(_vouchersDistributed(_currentHalfYear)).sub(totalPurchased);
817     }
818 
819     function _vouchersDistributed(uint16 _currentHalfYear) internal view returns (uint256) {
820         uint256 dist = totalDistributedIn[_currentHalfYear];
821         if (_currentHalfYear > 0) {
822             // include previous half-year
823             dist = dist.add(totalDistributedIn[_currentHalfYear - 1]);
824         }
825         return dist;
826     }
827 
828     function _distributedTo(address _owner, uint16 _currentHalfYear) internal view returns (uint256) {
829         uint256 balance = distributed[_currentHalfYear][_owner];
830         if (_currentHalfYear > 0) {
831             // include previous half-year
832             balance = balance.add(distributed[_currentHalfYear - 1][_owner]);
833         }
834         return balance;
835     }
836     
837     function _currentHalfYear() internal view returns (uint16) {
838         return uint16(now / HALF_YEAR_IN_SECONDS_AVG);
839     }
840 }