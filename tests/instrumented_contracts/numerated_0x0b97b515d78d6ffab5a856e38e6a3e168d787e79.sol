1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 // File: node_modules/openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
80 
81 /**
82  * @title Helps contracts guard against reentrancy attacks.
83  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
84  * @dev If you mark a function `nonReentrant`, you should also
85  * mark it `external`.
86  */
87 contract ReentrancyGuard {
88 
89   /// @dev counter to allow mutex lock with only one SSTORE operation
90   uint256 private _guardCounter;
91 
92   constructor() internal {
93     // The counter starts at one to prevent changing it from zero to a non-zero
94     // value, which is a more expensive operation.
95     _guardCounter = 1;
96   }
97 
98   /**
99    * @dev Prevents a contract from calling itself, directly or indirectly.
100    * Calling a `nonReentrant` function from another `nonReentrant`
101    * function is not supported. It is possible to prevent this from happening
102    * by making the `nonReentrant` function external, and make it call a
103    * `private` function that does the actual work.
104    */
105   modifier nonReentrant() {
106     _guardCounter += 1;
107     uint256 localCounter = _guardCounter;
108     _;
109     require(localCounter == _guardCounter);
110   }
111 
112 }
113 
114 // File: node_modules/openzeppelin-solidity/contracts/math/Safemath.sol
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that revert on error
119  */
120 library SafeMath {
121 
122   /**
123   * @dev Multiplies two numbers, reverts on overflow.
124   */
125   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
127     // benefit is lost if 'b' is also tested.
128     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
129     if (a == 0) {
130       return 0;
131     }
132 
133     uint256 c = a * b;
134     require(c / a == b);
135 
136     return c;
137   }
138 
139   /**
140   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
141   */
142   function div(uint256 a, uint256 b) internal pure returns (uint256) {
143     require(b > 0); // Solidity only automatically asserts when dividing by 0
144     uint256 c = a / b;
145     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147     return c;
148   }
149 
150   /**
151   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
152   */
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     require(b <= a);
155     uint256 c = a - b;
156 
157     return c;
158   }
159 
160   /**
161   * @dev Adds two numbers, reverts on overflow.
162   */
163   function add(uint256 a, uint256 b) internal pure returns (uint256) {
164     uint256 c = a + b;
165     require(c >= a);
166 
167     return c;
168   }
169 
170   /**
171   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
172   * reverts when dividing by zero.
173   */
174   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175     require(b != 0);
176     return a % b;
177   }
178 }
179 
180 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://github.com/ethereum/EIPs/issues/20
185  */
186 interface IERC20 {
187   function totalSupply() external view returns (uint256);
188 
189   function balanceOf(address who) external view returns (uint256);
190 
191   function allowance(address owner, address spender)
192     external view returns (uint256);
193 
194   function transfer(address to, uint256 value) external returns (bool);
195 
196   function approve(address spender, uint256 value)
197     external returns (bool);
198 
199   function transferFrom(address from, address to, uint256 value)
200     external returns (bool);
201 
202   event Transfer(
203     address indexed from,
204     address indexed to,
205     uint256 value
206   );
207 
208   event Approval(
209     address indexed owner,
210     address indexed spender,
211     uint256 value
212   );
213 }
214 
215 // File: lib/CanReclaimToken.sol
216 
217 /**
218  * @title Contracts that should be able to recover tokens
219  * @author SylTi
220  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
221  * This will prevent any accidental loss of tokens.
222  */
223 contract CanReclaimToken is Ownable {
224 
225   /**
226    * @dev Reclaim all ERC20 compatible tokens
227    * @param token ERC20 The address of the token contract
228    */
229   function reclaimToken(IERC20 token) external onlyOwner {
230     if (address(token) == address(0)) {
231       owner().transfer(address(this).balance);
232       return;
233     }
234     uint256 balance = token.balanceOf(this);
235     token.transfer(owner(), balance);
236   }
237 
238 }
239 
240 // File: openzeppelin-solidity/contracts/access/Roles.sol
241 
242 /**
243  * @title Roles
244  * @dev Library for managing addresses assigned to a Role.
245  */
246 library Roles {
247   struct Role {
248     mapping (address => bool) bearer;
249   }
250 
251   /**
252    * @dev give an account access to this role
253    */
254   function add(Role storage role, address account) internal {
255     require(account != address(0));
256     require(!has(role, account));
257 
258     role.bearer[account] = true;
259   }
260 
261   /**
262    * @dev remove an account's access to this role
263    */
264   function remove(Role storage role, address account) internal {
265     require(account != address(0));
266     require(has(role, account));
267 
268     role.bearer[account] = false;
269   }
270 
271   /**
272    * @dev check if an account has this role
273    * @return bool
274    */
275   function has(Role storage role, address account)
276     internal
277     view
278     returns (bool)
279   {
280     require(account != address(0));
281     return role.bearer[account];
282   }
283 }
284 
285 // File: lib/ServiceRole.sol
286 
287 contract ServiceRole {
288   using Roles for Roles.Role;
289 
290   event ServiceAdded(address indexed account);
291   event ServiceRemoved(address indexed account);
292 
293   Roles.Role private services;
294 
295   constructor() internal {
296     _addService(msg.sender);
297   }
298 
299   modifier onlyService() {
300     require(isService(msg.sender));
301     _;
302   }
303 
304   function isService(address account) public view returns (bool) {
305     return services.has(account);
306   }
307 
308   function renounceService() public {
309     _removeService(msg.sender);
310   }
311 
312   function _addService(address account) internal {
313     services.add(account);
314     emit ServiceAdded(account);
315   }
316 
317   function _removeService(address account) internal {
318     services.remove(account);
319     emit ServiceRemoved(account);
320   }
321 }
322 
323 // File: contracts/SaleFix.sol
324 
325 interface HEROES {
326   function mint(address to, uint256 genes, uint256 level)  external returns (uint);
327 }
328 
329 //Crypto Hero Rocket coin
330 interface CHR {
331   function mint(address _to, uint256 _amount) external returns (bool);
332 }
333 
334 contract SaleFix is Ownable, ServiceRole, ReentrancyGuard, CanReclaimToken {
335   using SafeMath for uint256;
336 
337   event ItemUpdate(uint256 indexed itemId, uint256 genes, uint256 level, uint256 price, uint256 count);
338   event Sold(address indexed to, uint256 indexed tokenId, uint256 indexed itemId, uint256 genes, uint256 level, uint256 price);
339   event CoinReward(uint256 code, uint256 coins);
340   event EthReward(uint256 code, uint256 eth);
341   event CoinRewardGet(uint256 code, uint256 coins);
342   event EthRewardGet(uint256 code, uint256 eth);
343   event Income(address source, uint256 amount);
344 
345   HEROES public heroes;
346   CHR public coin;
347 
348   //MARKET
349   struct Item {
350     bool exists;
351     uint256 index;
352     uint256 genes;
353     uint256 level;
354     uint256 price;
355     uint256 count;
356   }
357 
358   // item id => Item
359   mapping(uint256 => Item) items;
360   // market index => item id
361   mapping(uint256 => uint) public market;
362   uint256 public marketSize;
363 
364   uint256 public lastItemId;
365 
366 
367   //REFERRALS
368   struct Affiliate {
369     uint256 affCode;
370     uint256 coinsToMint;
371     uint256 ethToSend;
372     uint256 coinsMinted;
373     uint256 ethSent;
374     bool active;
375   }
376 
377   struct AffiliateReward {
378     uint256 coins;
379     //1% - 100, 10% - 1000 50% - 5000
380     uint256 percent;
381   }
382 
383   //personal reward struct
384   struct StaffReward {
385     //1% - 100, 10% - 1000 50% - 5000
386     uint256 coins;
387     uint256 percent;
388     uint256 index;
389     bool exists;
390   }
391 
392   //personal reward mapping
393   //staff affCode => StaffReward
394   mapping (uint256 => StaffReward) public staffReward;
395   //staff index => staff affCode
396   mapping (uint256 => uint) public staffList;
397   uint256 public staffCount;
398 
399   //refCode => Affiliate
400   mapping(uint256 => Affiliate) public affiliates;
401   mapping(uint256 => bool) public vipAffiliates;
402   AffiliateReward[] public affLevelReward;
403   AffiliateReward[] public vipAffLevelReward;
404 
405   //total reserved eth amount for affiliates
406   uint256 public totalReserved;
407 
408   constructor(HEROES _heroes, CHR _coin) public {
409     require(address(_heroes) != address(0));
410     require(address(_coin) != address(0));
411     heroes = _heroes;
412     coin = _coin;
413 
414     affLevelReward.push(AffiliateReward({coins : 2, percent : 0})); // level 0 - player self, 2CHR
415     affLevelReward.push(AffiliateReward({coins : 1, percent : 1000})); // level 1, 1CHR, 10%
416     affLevelReward.push(AffiliateReward({coins : 0, percent : 500})); // level 2, 0CHR, 5%
417   
418     vipAffLevelReward.push(AffiliateReward({coins : 2, percent : 0})); // level 0 - player self, 2CHR
419     vipAffLevelReward.push(AffiliateReward({coins : 1, percent : 2000})); // level 1, 1CHR, 20%
420     vipAffLevelReward.push(AffiliateReward({coins : 0, percent : 1000})); // level 2, 0CHR, 10%
421   }
422 
423   /// @notice The fallback function payable
424   function() external payable {
425     require(msg.value > 0);
426     _flushBalance();
427   }
428 
429   function _flushBalance() private {
430     uint256 balance = address(this).balance.sub(totalReserved);
431     if (balance > 0) {
432       address(heroes).transfer(balance);
433       emit Income(address(this), balance);
434     }
435   }
436 
437   function addService(address account) public onlyOwner {
438     _addService(account);
439   }
440 
441   function removeService(address account) public onlyOwner {
442     _removeService(account);
443   }
444 
445 //  function setCoin(CHR _coin) external onlyOwner {
446 //    require(address(_coin) != address(0));
447 //    coin = _coin;
448 //  }
449 
450 
451   function setAffiliateLevel(uint256 _level, uint256 _rewardCoins, uint256 _rewardPercent) external onlyOwner {
452     require(_level < affLevelReward.length);
453     AffiliateReward storage rew = affLevelReward[_level];
454     rew.coins = _rewardCoins;
455     rew.percent = _rewardPercent;
456   }
457 
458 
459   function incAffiliateLevel(uint256 _rewardCoins, uint256 _rewardPercent) external onlyOwner {
460     affLevelReward.push(AffiliateReward({coins : _rewardCoins, percent : _rewardPercent}));
461   }
462 
463   function decAffiliateLevel() external onlyOwner {
464     delete affLevelReward[affLevelReward.length--];
465   }
466 
467   function affLevelsCount() external view returns (uint) {
468     return affLevelReward.length;
469   }
470 
471   function setVipAffiliateLevel(uint256 _level, uint256 _rewardCoins, uint256 _rewardPercent) external onlyOwner {
472     require(_level < vipAffLevelReward.length);
473     AffiliateReward storage rew = vipAffLevelReward[_level];
474     rew.coins = _rewardCoins;
475     rew.percent = _rewardPercent;
476   }
477 
478   function incVipAffiliateLevel(uint256 _rewardCoins, uint256 _rewardPercent) external onlyOwner {
479     vipAffLevelReward.push(AffiliateReward({coins : _rewardCoins, percent : _rewardPercent}));
480   }
481 
482   function decVipAffiliateLevel() external onlyOwner {
483     delete vipAffLevelReward[vipAffLevelReward.length--];
484   }
485 
486   function vipAffLevelsCount() external view returns (uint) {
487     return vipAffLevelReward.length;
488   }
489 
490   function addVipAffiliates(address[] _affiliates) external onlyOwner {
491     require(_affiliates.length > 0);
492     for(uint256 i = 0; i < _affiliates.length; i++) {
493       vipAffiliates[_getAffCode(uint(_affiliates[i]))] = true;
494     }
495   }
496 
497   function delVipAffiliates(address[] _affiliates) external onlyOwner {
498     require(_affiliates.length > 0);
499     for(uint256 i = 0; i < _affiliates.length; i++) {
500       delete vipAffiliates[_getAffCode(uint(_affiliates[i]))];
501     }
502   }
503 
504   function addStaff(address _staff, uint256 _percent) external onlyOwner {
505     require(_staff != address(0) && _percent > 0);
506     uint256 affCode = _getAffCode(uint(_staff));
507     StaffReward storage sr = staffReward[affCode];
508     if (!sr.exists) {
509       sr.exists = true;
510       sr.index = staffCount;
511       staffList[staffCount++] = affCode;
512     }
513     sr.percent = _percent;
514   }
515 
516   function delStaff(address _staff) external onlyOwner {
517     require(_staff != address(0));
518     uint256 affCode = _getAffCode(uint(_staff));
519     StaffReward storage sr = staffReward[affCode];
520     require(sr.exists);
521 
522     staffReward[staffList[--staffCount]].index = staffReward[affCode].index;
523     staffList[staffReward[affCode].index] = staffList[staffCount];
524     delete staffList[staffCount];
525     delete staffReward[affCode];
526   }
527 
528   //// MARKETPLACE
529 
530   function addItem(uint256 genes, uint256 level, uint256 price, uint256 count) external onlyService {
531     items[++lastItemId] = Item({
532       exists : true,
533       index : marketSize,
534       genes : genes,
535       level : level,
536       price : price,
537       count : count
538       });
539     market[marketSize++] = lastItemId;
540     emit ItemUpdate(lastItemId, genes, level,  price, count);
541   }
542 
543   function delItem(uint256 itemId) external onlyService {
544     require(items[itemId].exists);
545     items[market[--marketSize]].index = items[itemId].index;
546     market[items[itemId].index] = market[marketSize];
547     delete market[marketSize];
548     delete items[itemId];
549     emit ItemUpdate(itemId, 0, 0, 0, 0);
550   }
551 
552   function setPrice(uint256 itemId, uint256 price) external onlyService {
553     Item memory i = items[itemId];
554     require(i.exists);
555     require(i.price != price);
556     i.price = price;
557     emit ItemUpdate(itemId, i.genes, i.level, i.price, i.count);
558   }
559 
560   function setCount(uint256 itemId, uint256 count) external onlyService {
561     Item storage i = items[itemId];
562     require(i.exists);
563     require(i.count != count);
564     i.count = count;
565     emit ItemUpdate(itemId, i.genes, i.level, i.price, i.count);
566   }
567 
568   function getItem(uint256 itemId) external view returns (uint256 genes, uint256 level, uint256 price, uint256 count) {
569     Item memory i = items[itemId];
570     require(i.exists);
571     return (i.genes, i.level, i.price, i.count);
572   }
573 
574 
575   //// AFFILIATE
576 
577   function myAffiliateCode() public view returns (uint) {
578     return _getAffCode(uint(msg.sender));
579   }
580 
581   function _getAffCode(uint256 _a) internal pure returns (uint) {
582     return (_a ^ (_a >> 80)) & 0xFFFFFFFFFFFFFFFFFFFF;
583   }
584 
585   function buyItem(uint256 itemId, uint256 _affCode) public payable returns (uint256 tokenId) {
586     Item memory i = items[itemId];
587     require(i.exists);
588     require(i.count > 0);
589     require(msg.value == i.price);
590 
591     //minting character
592     i.count--;
593     tokenId = heroes.mint(msg.sender, i.genes, i.level);
594 
595     emit ItemUpdate(itemId, i.genes, i.level, i.price, i.count);
596     emit Sold(msg.sender, tokenId, itemId, i.genes, i.level, i.price);
597 
598     // fetch player code
599     uint256 _pCode = _getAffCode(uint(msg.sender));
600     Affiliate storage p = affiliates[_pCode];
601 
602     //check if it was 1st buy
603     if (!p.active) {
604       p.active = true;
605     }
606 
607     // manage affiliate residuals
608 
609     // if affiliate code was given and player not tried to use their own, lolz
610     // and its not the same as previously stored
611     if (_affCode != 0 && _affCode != _pCode && _affCode != p.affCode) {
612         // update last affiliate
613         p.affCode = _affCode;
614     }
615 
616     //referral reward
617     _distributeAffiliateReward(i.price, _pCode, 0);
618 
619     //staff reward
620     _distributeStaffReward(i.price, _pCode);
621 
622     _flushBalance();
623   }
624 
625   function _distributeAffiliateReward(uint256 _sum, uint256 _affCode, uint256 _level) internal {
626     Affiliate storage aff = affiliates[_affCode];
627     AffiliateReward storage ar = vipAffiliates[_affCode] ? vipAffLevelReward[_level] : affLevelReward[_level];
628     if (ar.coins > 0) {
629       aff.coinsToMint = aff.coinsToMint.add(ar.coins);
630       emit CoinReward(_affCode, ar.coins);
631     }
632     if (ar.percent > 0) {
633       uint256 pcnt = _getPercent(_sum, ar.percent);
634       aff.ethToSend = aff.ethToSend.add(pcnt);
635       totalReserved = totalReserved.add(pcnt);
636       emit EthReward(_affCode, pcnt);
637     }
638     if (++_level < affLevelReward.length && aff.affCode != 0) {
639       _distributeAffiliateReward(_sum, aff.affCode, _level);
640     }
641   }
642 
643   //be aware of big number of staff - huge gas!
644   function _distributeStaffReward(uint256 _sum, uint256 _affCode) internal {
645     for (uint256 i = 0; i < staffCount; i++) {
646       if (_affCode != staffList[i]) {
647         Affiliate storage aff = affiliates[staffList[i]];
648         StaffReward memory sr = staffReward[staffList[i]];
649         if (sr.coins > 0) {
650           aff.coinsToMint = aff.coinsToMint.add(sr.coins);
651           emit CoinReward(_affCode, sr.coins);
652         }
653         if (sr.percent > 0) {
654           uint256 pcnt = _getPercent(_sum, sr.percent);
655           aff.ethToSend = aff.ethToSend.add(pcnt);
656           totalReserved = totalReserved.add(pcnt);
657           emit EthReward(_affCode, pcnt);
658         }
659       }
660     }
661   }
662 
663   //player can take all rewards after 1st buy of item when he became active
664   function getReward() external nonReentrant {
665     // fetch player code
666     uint256 _pCode = _getAffCode(uint(msg.sender));
667     Affiliate storage p = affiliates[_pCode];
668     require(p.active);
669 
670     //minting coins
671     if (p.coinsToMint > 0) {
672       require(coin.mint(msg.sender, p.coinsToMint));
673       p.coinsMinted = p.coinsMinted.add(p.coinsToMint);
674       emit CoinRewardGet(_pCode, p.coinsToMint);
675       p.coinsToMint = 0;
676     }
677     //sending eth
678     if (p.ethToSend > 0) {
679       msg.sender.transfer(p.ethToSend);
680       p.ethSent = p.ethSent.add(p.ethToSend);
681       totalReserved = totalReserved.sub(p.ethToSend);
682       emit EthRewardGet(_pCode, p.ethToSend);
683       p.ethToSend = 0;
684     }
685   }
686 
687   //// SERVICE
688   //1% - 100, 10% - 1000 50% - 5000
689   function _getPercent(uint256 _v, uint256 _p) internal pure returns (uint)    {
690     return _v.mul(_p).div(10000);
691   }
692 }