1 pragma solidity ^0.4.24;
2 
3 // ////////////////////////////////////////////////////////////////////////////////////////////////////
4 //                     ___           ___           ___                    __      
5 //       ___          /  /\         /  /\         /  /\                  |  |\    
6 //      /__/\        /  /::\       /  /::\       /  /::|                 |  |:|   
7 //      \  \:\      /  /:/\:\     /  /:/\:\     /  /:|:|                 |  |:|   
8 //       \__\:\    /  /::\ \:\   /  /::\ \:\   /  /:/|:|__               |__|:|__ 
9 //       /  /::\  /__/:/\:\ \:\ /__/:/\:\_\:\ /__/:/_|::::\          ____/__/::::\
10 //      /  /:/\:\ \  \:\ \:\_\/ \__\/  \:\/:/ \__\/  /~~/:/          \__\::::/~~~~
11 //     /  /:/__\/  \  \:\ \:\        \__\::/        /  /:/              |~~|:|    
12 //    /__/:/        \  \:\_\/        /  /:/        /  /:/               |  |:|    
13 //    \__\/          \  \:\         /__/:/        /__/:/                |__|:|    
14 //                    \__\/         \__\/         \__\/                  \__\|    
15 //  ______   ______   ______   _____    _    _   ______  ______  _____ 
16 // | |  | \ | |  | \ / |  | \ | | \ \  | |  | | | |     | |     | | \ \ 
17 // | |__|_/ | |__| | | |  | | | |  | | | |  | | | |     | |---- | |  | |
18 // |_|      |_|  \_\ \_|__|_/ |_|_/_/  \_|__|_| |_|____ |_|____ |_|_/_/ 
19 // 
20 // TEAM X All Rights Received. http://teamx.club 
21 // This product is protected under license.  Any unauthorized copy, modification, or use without 
22 // express written consent from the creators is prohibited.
23 // v 0.1.3
24 // Any cooperation Please email: service@teamx.club
25 // Follow these step to become a site owner:
26 // 1. fork git repository: https://github.com/teamx-club/escape-mmm
27 // 2. modify file: js/config.js
28 // 3. replace siteOwner with your address
29 // 4. search for how to use github pages and bind your domain, setup the forked repository
30 // 5. having fun, you will earn 5% every privode from your site page
31 // ////////////////////////////////////////////////////////////////////////////////////////////////////
32 
33 //=========================================================...
34 // (~   _  _ _|_ _  .
35 // (_\/(/_| | | _\  . Events
36 //=========================================================                   
37 contract EscapeMmmEvents {
38     event onOffered (
39         address indexed playerAddress,
40         uint256 offerAmount,
41         address affiliateAddress,
42         address siteOwner,
43         uint256 timestamp
44     );
45     event onAccepted (
46         address indexed playerAddress,
47         uint256 acceptAmount
48     );
49     event onWithdraw (
50         address indexed playerAddress,
51         uint256 withdrawAmount
52     );
53     event onAirDrop (
54         address indexed playerAddress,
55         uint256 airdropAmount,
56         uint256 offerAmount
57     );
58 }
59 
60 /**
61  * @title Ownable
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract Ownable {
66     address public owner;
67 
68 
69     event OwnershipRenounced(address indexed previousOwner);
70     event OwnershipTransferred(
71         address indexed previousOwner,
72         address indexed newOwner
73     );
74 
75 
76     /**
77     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78     * account.
79     */
80     constructor() public {
81         owner = msg.sender;
82     }
83 
84     /**
85     * @dev Throws if called by any account other than the owner.
86     */
87     modifier onlyOwner() {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     /**
93     * @dev Allows the current owner to relinquish control of the contract.
94     * @notice Renouncing to ownership will leave the contract without an owner.
95     * It will not be possible to call the functions with the `onlyOwner`
96     * modifier anymore.
97     */
98     function renounceOwnership() public onlyOwner {
99         emit OwnershipRenounced(owner);
100         owner = address(0);
101     }
102 
103     /**
104     * @dev Allows the current owner to transfer control of the contract to a newOwner.
105     * @param _newOwner The address to transfer ownership to.
106     */
107     function transferOwnership(address _newOwner) public onlyOwner {
108         _transferOwnership(_newOwner);
109     }
110 
111     /**
112     * @dev Transfers control of the contract to a newOwner.
113     * @param _newOwner The address to transfer ownership to.
114     */
115     function _transferOwnership(address _newOwner) internal {
116         require(_newOwner != address(0));
117         emit OwnershipTransferred(owner, _newOwner);
118         owner = _newOwner;
119     }
120 }
121 
122 //=========================================================...
123 // |\/| _ . _   /~` _  _ _|_ _ _  __|_  .
124 // |  |(_||| |  \_,(_)| | | | (_|(_ |   . Main Contract
125 //=========================================================                   
126 contract EFMAPlatform is EscapeMmmEvents, Ownable {
127     using SafeMath for *;
128 
129     //=========================================================...
130     //  _ _  _  |`. _     _ _  .
131     // (_(_)| |~|~|(_||_|| (/_ .  system settings
132     //==============_|=========================================        
133     string constant public name = "Escape Financial Mutual Aid Platform";
134     string constant public symbol = "EFMAP";
135 
136     address private xTokenAddress = 0xfe8b40a35ff222c8475385f74e77d33954531b41;
137 
138     uint8 public feePercent_ = 1; // 1% for fee
139     uint8 public affPercent_ = 5; // 5% for affiliate
140     uint8 public sitePercent_ = 5; // 5% for site owner
141     uint8 public airDropPercent_ = 10; // 10% for air drop
142     uint8 public xTokenPercent_ = 3; // 3% for x token
143 
144     uint256 constant public interestPeriod_ = 1 hours;
145     uint256 constant public maxInterestTime_ = 7 days;
146     //=========================================================...
147     //  _| _ _|_ _    _ _ _|_   _  .
148     // (_|(_| | (_|  _\(/_ ||_||_) . data setup
149     //=========================|===============================  
150     uint256 public airDropPool_;
151     uint256 public airDropTracker_ = 0; // +1 every (0.001 ether) time triggered; if 0.002 eth, trigger twice
152 
153     //=========================================================...
154     //  _ | _ _|_|` _  _ _ _    _| _ _|_ _  .
155     // |_)|(_| |~|~(_)| | | |  (_|(_| | (_| . platform data
156     //=|=======================================================
157     mapping (address => FMAPDatasets.Player) public players_;
158     mapping (address => mapping (uint256 => FMAPDatasets.OfferInfo)) public playerOfferOrders_; // player => player offer count => offerInfo.
159     mapping (address => mapping (uint256 => uint256)) public playerAcceptOrders_; // player => count => orderId. player orders to accept;
160     uint256 private restOfferAmount_ = 0; // offered amount that not been accepted;
161     FMAPDatasets.AcceptOrder private currentOrder_; // unmatched current order;
162     mapping (uint256 => FMAPDatasets.AcceptOrder) public acceptOrders_; // accept orders;
163 
164     address private teamXWallet;
165     uint256 public _totalFee;
166     uint256 public _totalXT;
167 
168     //=========================================================...
169     //  _ _  _  __|_ _   __|_ _  _
170     // (_(_)| |_\ | ||_|(_ | (_)| 
171     //=========================================================
172     constructor() public {
173         teamXWallet = msg.sender;
174         // setting something ?
175         FMAPDatasets.AcceptOrder memory ao;
176         ao.nextOrder = 1;
177         ao.playerAddress = msg.sender;
178         ao.acceptAmount = 1 finney;
179         acceptOrders_[0] = ao;
180         currentOrder_ = ao;
181     }
182 
183     function transFee() public onlyOwner {
184         teamXWallet.transfer(_totalFee);
185     }
186     function setTeamWallet(address wallet) public onlyOwner {
187         teamXWallet = wallet;
188     }
189     function setXToken(address xToken) public onlyOwner {
190         xTokenAddress = xToken;
191     }
192 
193     //=========================================================...
194     //  _ _  _  _|. |`. _  _ _ .
195     // | | |(_)(_||~|~|(/_| _\ . modifiers
196     //=========================================================
197     modifier isHuman() {
198         require(AddressUtils.isContract(msg.sender) == false, "sorry, only human allowed");
199         _;
200     }
201 
202     //=========================================================...
203     //  _    |_ |. _   |`    _  __|_. _  _  _  .
204     // |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  . public functions
205     //=|=======================================================
206     /**
207      * offer help directly
208      */
209     function() isHuman() public payable {
210         FMAPDatasets.OfferInfo memory offerInfo = packageOfferInfo(address(0), msg.value);
211         offerCore(offerInfo, false);
212     }
213 
214     function offerHelp(address siteOwner, address affiliate) isHuman() public payable {
215         FMAPDatasets.OfferInfo memory offerInfo = packageOfferInfo(siteOwner, msg.value);
216         bool updateAff = false;
217         if(affiliate != address(0) && affiliate != offerInfo.affiliateAddress) {
218             offerInfo.affiliateAddress = affiliate;
219             updateAff = true;
220         }
221         offerCore(offerInfo, updateAff);
222 
223         emit onOffered(offerInfo.playerAddress, offerInfo.offerAmount, offerInfo.affiliateAddress, offerInfo.siteOwner, offerInfo.timestamp);
224     }
225 
226     function offerHelpUsingBalance(address siteOwner, address affiliate, uint256 ethAmount) isHuman() public {
227         require(ethAmount <= players_[msg.sender].balance, "sorry, you don't have enough balance");
228         FMAPDatasets.OfferInfo memory offerInfo = packageOfferInfo(siteOwner, ethAmount);
229         bool updateAff = false;
230         if(affiliate != address(0) && affiliate != offerInfo.affiliateAddress) {
231             offerInfo.affiliateAddress = affiliate;
232             updateAff = true;
233         }
234         players_[msg.sender].balance = players_[msg.sender].balance.sub(ethAmount);
235         offerCore(offerInfo, updateAff);
236 
237         emit onOffered(offerInfo.playerAddress, offerInfo.offerAmount, offerInfo.affiliateAddress, offerInfo.siteOwner, offerInfo.timestamp);
238     }
239 
240     function acceptHelp(uint256 amount) isHuman() public returns (uint256 canAcceptLeft) {
241         (canAcceptLeft, ) = calcCanAcceptAmount(msg.sender, true, 0);
242         require(amount <= canAcceptLeft, "sorry, you don't have enough acceptable amount");
243 
244         uint256 _nextOrderId = currentOrder_.nextOrder;
245         FMAPDatasets.AcceptOrder memory acceptOrder;
246         acceptOrder.playerAddress = msg.sender;
247         acceptOrder.acceptAmount = amount;
248         acceptOrder.acceptedAmount = 0;
249         acceptOrder.nextOrder = _nextOrderId + 1;
250         acceptOrders_[_nextOrderId] = acceptOrder;
251 
252         // see if currentOrder_ is finished
253         if (currentOrder_.orderId == _nextOrderId || currentOrder_.acceptAmount == currentOrder_.acceptedAmount) {
254             currentOrder_ = acceptOrder;
255         }
256 
257         players_[acceptOrder.playerAddress].totalAccepted = amount.add(players_[acceptOrder.playerAddress].totalAccepted);
258         players_[acceptOrder.playerAddress].acceptOrderCount++;
259 
260         if (restOfferAmount_ > 0) {
261             matching();
262         }
263         calcAndSetPlayerTotalCanAccept(acceptOrder.playerAddress, amount);
264 
265         emit onAccepted(acceptOrder.playerAddress, acceptOrder.acceptAmount);
266 
267         return (canAcceptLeft);
268     }
269 
270     function withdraw() isHuman() public {
271         require(players_[msg.sender].balance >= 1 finney, "sorry, withdraw at least 1 finney");
272 
273         uint256 _balance = players_[msg.sender].balance;
274         players_[msg.sender].balance = 0;
275         msg.sender.transfer(_balance);
276 
277         emit onWithdraw(msg.sender, _balance);
278     }
279 
280     //=========================================================...
281     //   . _      |`    _  __|_. _  _  _  .
282     // \/|(/_VV  ~|~|_|| |(_ | |(_)| |_\  . view functions
283     //=========================================================
284     function getCanAcceptAmount(address playerAddr) public view returns (uint256 canAccept, uint256 earliest) {
285         (canAccept, earliest) = calcCanAcceptAmount(playerAddr, true, 0);
286         return (canAccept, earliest);
287     }
288 
289     function getBalance(address playerAddr) public view returns (uint256) {
290         uint256 balance = players_[playerAddr].balance;
291         return (balance);
292     }
293 
294     function getPlayerInfo(address playerAddr) public view
295         returns (uint256 totalAssets, uint256 nextPeriodAssets, uint256 balance, uint256 canAccept, uint256 airdrop, uint256 offered, uint256 accepted, uint256 affiliateEarned, uint256 siteEarned, uint256 nextUpdateTime) {
296         FMAPDatasets.Player memory _player = players_[playerAddr];
297         uint256 _calculatedCanAccept;
298         (_calculatedCanAccept, ) = calcCanAcceptAmount(playerAddr, false, 0);
299         totalAssets = _player.balance.add(_calculatedCanAccept);
300         (_calculatedCanAccept, ) = calcCanAcceptAmount(playerAddr, false, interestPeriod_);
301         nextPeriodAssets = _player.balance.add(_calculatedCanAccept);
302         (canAccept, nextUpdateTime) = calcCanAcceptAmount(playerAddr, true, 0);
303 
304         return (totalAssets, nextPeriodAssets, _player.balance, canAccept, _player.airDroped, _player.totalOffered, _player.totalAccepted, _player.affiliateEarned, _player.siteEarned, nextUpdateTime);
305     }
306 
307     //=========================================================...
308     //  _  _.   _ _|_ _    |`    _  __|_. _  _  _  .
309     // |_)| |\/(_| | (/_  ~|~|_|| |(_ | |(_)| |_\  . private functions
310     //=|=======================================================
311     function packageOfferInfo(address siteOwner, uint256 amount) private view returns (FMAPDatasets.OfferInfo) {
312         FMAPDatasets.OfferInfo memory offerInfo;
313         offerInfo.playerAddress = msg.sender;
314         offerInfo.offerAmount = amount;
315         offerInfo.affiliateAddress = players_[msg.sender].lastAffiliate;
316         offerInfo.siteOwner = siteOwner;
317         offerInfo.timestamp = block.timestamp;
318         offerInfo.interesting = true;
319         return (offerInfo);
320     }
321 
322     //=========================================================...
323     //  _ _  _ _    |`    _  __|_. _  _  _  .
324     // (_(_)| (/_  ~|~|_|| |(_ | |(_)| |_\  .  core functions
325     //=========================================================
326     function offerCore(FMAPDatasets.OfferInfo memory offerInfo, bool updateAff) private {
327         uint256 _fee = (offerInfo.offerAmount).mul(feePercent_).div(100); // 1% for fee
328         uint256 _aff = (offerInfo.offerAmount).mul(affPercent_).div(100); // 5% for affiliate
329         uint256 _sit = (offerInfo.offerAmount).mul(sitePercent_).div(100); // 5% for site owner
330         uint256 _air = (offerInfo.offerAmount).mul(airDropPercent_).div(100); // 10% for air drop
331         uint256 _xt = (offerInfo.offerAmount).mul(xTokenPercent_).div(100); // 3% for x token
332 
333         uint256 _leftAmount = offerInfo.offerAmount;
334 
335         if (offerInfo.affiliateAddress == offerInfo.siteOwner) { // site owner is forbid to be affiliater
336             offerInfo.affiliateAddress = address(0);
337         }
338         // fee
339         players_[offerInfo.playerAddress].totalOffered = (offerInfo.offerAmount).add(players_[offerInfo.playerAddress].totalOffered);
340         if (offerInfo.affiliateAddress == address(0) || offerInfo.affiliateAddress == offerInfo.playerAddress) {
341             _fee = _fee.add(_aff);
342             _aff = 0;
343         }
344         if (offerInfo.siteOwner == address(0) || offerInfo.siteOwner == offerInfo.playerAddress) {
345             _fee = _fee.add(_sit);
346             _sit = 0;
347         }
348 
349         _totalFee = _totalFee.add(_fee);
350         _totalXT = _totalXT.add(_xt);
351         if (_totalXT > 1 finney) {
352             xTokenAddress.transfer(_totalXT);
353         }
354 
355         _leftAmount = _leftAmount.sub(_fee);
356 
357         // affiliate
358         if (_aff > 0) {
359             players_[offerInfo.affiliateAddress].balance = _aff.add(players_[offerInfo.affiliateAddress].balance);
360             players_[offerInfo.affiliateAddress].affiliateEarned = _aff.add(players_[offerInfo.affiliateAddress].affiliateEarned);
361             _leftAmount = _leftAmount.sub(_aff);
362         }
363         // site
364         if (_sit > 0) {
365             players_[offerInfo.siteOwner].balance = _sit.add(players_[offerInfo.siteOwner].balance);
366             players_[offerInfo.siteOwner].siteEarned = _sit.add(players_[offerInfo.siteOwner].siteEarned);
367             _leftAmount = _leftAmount.sub(_sit);
368         }
369 
370         // air drop
371         if (offerInfo.offerAmount >= 1 finney) {
372             airDropTracker_ = airDropTracker_ + FMAPMath.calcTrackerCount(offerInfo.offerAmount);
373             if (airdrop() == true) {
374                 uint256 _airdrop = FMAPMath.calcAirDropAmount(offerInfo.offerAmount);
375                 players_[offerInfo.playerAddress].balance = _airdrop.add(players_[offerInfo.playerAddress].balance);
376                 players_[offerInfo.playerAddress].airDroped = _airdrop.add(players_[offerInfo.playerAddress].airDroped);
377                 emit onAirDrop(offerInfo.playerAddress, _airdrop, offerInfo.offerAmount);
378             }
379         }
380         airDropPool_ = airDropPool_.add(_air);
381         _leftAmount = _leftAmount.sub(_air);
382 
383         if (updateAff) {
384             players_[offerInfo.playerAddress].lastAffiliate = offerInfo.affiliateAddress;
385         }
386 
387         restOfferAmount_ = restOfferAmount_.add(_leftAmount);
388         if (currentOrder_.acceptAmount > currentOrder_.acceptedAmount) {
389             matching();
390         }
391 
392         playerOfferOrders_[offerInfo.playerAddress][players_[offerInfo.playerAddress].offeredCount] = offerInfo;
393         players_[offerInfo.playerAddress].offeredCount = (players_[offerInfo.playerAddress].offeredCount).add(1);
394 
395         if (players_[offerInfo.playerAddress].playerAddress == address(0)) {
396             players_[offerInfo.playerAddress].playerAddress = offerInfo.playerAddress;
397         }
398     }
399 
400     function matching() private {
401         while (restOfferAmount_ > 0 && currentOrder_.acceptAmount > currentOrder_.acceptedAmount) {
402             uint256 needAcceptAmount = (currentOrder_.acceptAmount).sub(currentOrder_.acceptedAmount);
403             if (needAcceptAmount <= restOfferAmount_) { // currentOrder finished
404                 restOfferAmount_ = restOfferAmount_.sub(needAcceptAmount);
405                 players_[currentOrder_.playerAddress].balance = needAcceptAmount.add(players_[currentOrder_.playerAddress].balance);
406                 currentOrder_.acceptedAmount = (currentOrder_.acceptedAmount).add(needAcceptAmount);
407                 currentOrder_ = acceptOrders_[currentOrder_.nextOrder];
408             } else { // offer end
409                 currentOrder_.acceptedAmount = (currentOrder_.acceptedAmount).add(restOfferAmount_);
410                 players_[currentOrder_.playerAddress].balance = (players_[currentOrder_.playerAddress].balance).add(restOfferAmount_);
411                 restOfferAmount_ = 0;
412             }
413         }
414     }
415 
416     function calcAndSetPlayerTotalCanAccept(address pAddr, uint256 acceptAmount) private {
417         uint256 _now = block.timestamp;
418         uint256 _latestCalced = players_[pAddr].lastCalcOfferNo;
419         uint256 _acceptedAmount = acceptAmount;
420 
421         while(_latestCalced < players_[pAddr].offeredCount) {
422             FMAPDatasets.OfferInfo storage oi = playerOfferOrders_[pAddr][_latestCalced];
423             uint256 _ts = _now.sub(oi.timestamp);
424             if (oi.interesting == true) {
425                 if (_ts >= maxInterestTime_) {                    
426                     // stop interesting...
427                     uint256 interest1 = oi.offerAmount.sub(oi.acceptAmount).mul(1).div(1000).mul(maxInterestTime_ / interestPeriod_); // 24 * 7
428                     players_[pAddr].canAccept = (players_[pAddr].canAccept).add(oi.offerAmount).add(interest1);
429                     oi.interesting = false;
430 
431                     // set accept
432                     if (oi.offerAmount.sub(oi.acceptAmount) > _acceptedAmount) {
433                         _acceptedAmount = 0;
434                         oi.acceptAmount = oi.acceptAmount.add(_acceptedAmount);
435                     } else {
436                         _acceptedAmount = _acceptedAmount.sub(oi.offerAmount.sub(oi.acceptAmount));
437                         oi.acceptAmount = oi.offerAmount;
438                     }
439                 } else if (_acceptedAmount > 0) {
440                     if (_acceptedAmount < oi.offerAmount.sub(oi.acceptAmount)) {
441                         oi.acceptAmount = oi.acceptAmount.add(_acceptedAmount);
442                         _acceptedAmount = 0;
443                     } else {
444                         uint256 interest0 = oi.offerAmount.sub(oi.acceptAmount).mul(1).div(1000).mul(_ts / interestPeriod_);
445                         players_[pAddr].canAccept = (players_[pAddr].canAccept).add(oi.offerAmount).add(interest0);
446                         oi.interesting = false;
447                         
448                         _acceptedAmount = _acceptedAmount.sub(oi.offerAmount.sub(oi.acceptAmount));
449                         oi.acceptAmount = oi.offerAmount;
450             
451                     }
452                 }
453             } else if (oi.offerAmount > oi.acceptAmount && _acceptedAmount > 0) {
454                 // set accept
455                 if (oi.offerAmount.sub(oi.acceptAmount) > _acceptedAmount) {
456                     _acceptedAmount = 0;
457                     oi.acceptAmount = oi.acceptAmount.add(_acceptedAmount);
458                 } else {
459                     _acceptedAmount = _acceptedAmount.sub(oi.offerAmount.sub(oi.acceptAmount));
460                     oi.acceptAmount = oi.offerAmount;
461                 }
462             }
463             if (_acceptedAmount == 0) {
464                 break;
465             }
466             _latestCalced = _latestCalced + 1;
467         }
468         players_[pAddr].lastCalcOfferNo = _latestCalced;
469     }
470 
471     function airdrop() private view returns (bool) {
472         uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, block.number, block.timestamp, block.difficulty, block.gaslimit, airDropTracker_, block.coinbase, msg.sender)));
473         if(seed - (seed / 10000).mul(10000) < airDropTracker_) {
474             return (true);
475         }
476         return (false);
477     }
478 
479     function calcCanAcceptAmount(address pAddr, bool isLimit, uint256 offsetTime) private view returns (uint256, uint256 nextUpdateTime) {
480         uint256 _totalCanAccepted = players_[pAddr].canAccept;
481         uint256 i = players_[pAddr].offeredCount;
482         uint256 _now = block.timestamp.add(offsetTime);
483         uint256 _nextUpdateTime = _now.add(interestPeriod_);
484         for(;i > 0; i--) {
485             FMAPDatasets.OfferInfo memory oi = playerOfferOrders_[pAddr][i - 1];
486             if (oi.interesting == true) {
487                 uint256 timepassed = _now.sub(oi.timestamp);
488                 if (!isLimit || (timepassed >= interestPeriod_)) { // at least 1 period
489                     uint256 interest;
490                     if (timepassed < maxInterestTime_) {
491                         interest = oi.offerAmount.sub(oi.acceptAmount).mul(1).div(1000).mul(timepassed / interestPeriod_);
492                         
493                         uint256 oiNextUpdateTime = (timepassed / interestPeriod_).add(1).mul(interestPeriod_).add(oi.timestamp);
494                         if (_nextUpdateTime > oiNextUpdateTime) {
495                             _nextUpdateTime = oiNextUpdateTime;
496                         }
497                     } else {
498                         interest = oi.offerAmount.sub(oi.acceptAmount).mul(1).div(1000).mul(maxInterestTime_ / interestPeriod_);
499                     }
500                     _totalCanAccepted = _totalCanAccepted.add(oi.offerAmount).add(interest);
501                 }
502             } else if (oi.timestamp == 0) {
503                 continue;
504             } else {
505                 break;
506             }
507         }
508 
509         return (_totalCanAccepted.sub(players_[pAddr].totalAccepted), _nextUpdateTime);
510     }
511 
512 }
513 
514 //=========================================================...
515 //  _ _  _ _|_|_   |.|_  _ _  _   .
516 // | | |(_| | | |  |||_)| (_||\/  . math library
517 //============================/============================    
518 library FMAPMath {
519     using SafeMath for uint256;
520     function calcTrackerCount(uint256 ethAmount) internal pure returns (uint256) {
521         if (ethAmount >= 1 finney && ethAmount < 10 finney) {
522             return (1);
523         } else if (ethAmount < 50 finney) {
524             return (2);
525         } else if (ethAmount < 200 finney) {
526             return (3);
527         } else if (ethAmount < 500 finney) {
528             return (4);
529         } else if (ethAmount < 1 ether) {
530             return (5);
531         } else if (ethAmount >= 1 ether) {
532             return ethAmount.div(1 ether).add(5);
533         }
534         return (0);
535     }
536     function calcAirDropAmount(uint256 ethAmount) internal pure returns (uint256) {
537         if (ethAmount >= 1 finney && ethAmount < 10 finney) {
538             return (5);
539         } else if (ethAmount < 50 finney) {
540             return (10);
541         } else if (ethAmount < 200 finney) {
542             return (15);
543         } else if (ethAmount < 500 finney) {
544             return (20);
545         } else if (ethAmount < 1 ether) {
546             return (25);
547         } else if (ethAmount >= 1 ether) {
548             uint256 a = ethAmount.div(1 ether).add(5).mul(5);
549             return (a > 75 ? 75 : a);
550         }
551         return (0);
552     }
553 }
554 //=========================================================...
555 //  __|_ _   __|_  .
556 // _\ | ||_|(_ |   .
557 //=========================================================
558 library FMAPDatasets {
559     struct OfferInfo {
560         address playerAddress;
561         uint256 offerAmount;
562         uint256 acceptAmount; // 不再计算利息
563         address affiliateAddress;
564         address siteOwner;
565         uint256 timestamp;
566         bool interesting;
567     }
568     struct AcceptOrder {
569         uint256 orderId;
570         address playerAddress;
571         uint256 acceptAmount;
572         uint256 acceptedAmount;
573         uint256 nextOrder;
574     }
575     struct Player {
576         address playerAddress;
577         address lastAffiliate;
578         uint256 totalOffered;
579         uint256 totalAccepted;
580         uint256 airDroped;
581         uint256 balance; // can withdraw
582         uint256 offeredCount;
583         uint256 acceptOrderCount;
584         uint256 canAccept;
585         uint256 lastCalcOfferNo;
586         uint256 affiliateEarned;
587         uint256 siteEarned;
588     }
589 }
590 
591 /**
592  * @title SafeMath
593  * @dev Math operations with safety checks that throw on error
594  */
595 library SafeMath {
596 
597     /**
598     * @dev Multiplies two numbers, throws on overflow.
599     */
600     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
601         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
602         // benefit is lost if 'b' is also tested.
603         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
604         if (a == 0) {
605             return 0;
606         }
607 
608         c = a * b;
609         assert(c / a == b);
610         return c;
611     }
612 
613     /**
614     * @dev Integer division of two numbers, truncating the quotient.
615     */
616     function div(uint256 a, uint256 b) internal pure returns (uint256) {
617         // assert(b > 0); // Solidity automatically throws when dividing by 0
618         // uint256 c = a / b;
619         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
620         return a / b;
621     }
622 
623     /**
624     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
625     */
626     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
627         assert(b <= a);
628         return a - b;
629     }
630 
631     /**
632     * @dev Adds two numbers, throws on overflow.
633     */
634     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
635         c = a + b;
636         assert(c >= a);
637         return c;
638     }
639 }
640 
641 
642 /**
643  * Utility library of inline functions on addresses
644  */
645 library AddressUtils {
646 
647     /**
648     * Returns whether the target address is a contract
649     * @dev This function will return false if invoked during the constructor of a contract,
650     * as the code is not actually created until after the constructor finishes.
651     * @param addr address to check
652     * @return whether the target address is a contract
653     */
654     function isContract(address addr) internal view returns (bool) {
655         uint256 size;
656         // XXX Currently there is no better way to check if there is a contract in an address
657         // than to check the size of the code at that address.
658         // See https://ethereum.stackexchange.com/a/14016/36603
659         // for more details about how this works.
660         // TODO Check this again before the Serenity release, because all addresses will be
661         // contracts then.
662         // solium-disable-next-line security/no-inline-assembly
663         assembly { size := extcodesize(addr) }
664         return size > 0;
665     }
666 
667 }