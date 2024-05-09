1 pragma solidity ^0.4.23;
2 /*
3 ** WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
4 */
5 
6 /*    
7 * Author:  Konstantin G...
8 * Telegram: @bunnygame
9 * 
10 * email: info@bunnycoin.co
11 * site : http://bunnycoin.co
12 * @title Ownable
13 * @dev The Ownable contract has an owner address, and provides basic authorization control
14 * functions, this simplifies the implementation of "user permissions".
15 */
16 
17 contract Ownable {
18     
19     address owner;
20     address ownerMoney;   
21      
22  
23 
24     /**
25     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26     * account.
27     */    
28     constructor() public {
29         owner = msg.sender;
30         ownerMoney = msg.sender;
31     }
32 
33     /**
34     * @dev Throws if called by any account other than the owner.
35     */
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40 
41  
42 
43     function transferMoney(address _add) public  onlyOwner {
44         if (_add != address(0)) {
45             ownerMoney = _add;
46         }
47     }
48     
49  
50     function transferOwner(address _add) public onlyOwner {
51         if (_add != address(0)) {
52             owner = _add;
53         }
54     } 
55       
56     function getOwnerMoney() public view onlyOwner returns(address) {
57         return ownerMoney;
58     } 
59  
60 }
61 
62  
63 
64 
65 /**
66  * @title Whitelist
67  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
68  * @dev This simplifies the implementation of "user permissions".
69  */
70 contract Whitelist is Ownable {
71     mapping(address => bool) public whitelist;
72     event WhitelistedAddressAdded(address addr);
73     event WhitelistedAddressRemoved(address addr);
74  
75   /**
76    * @dev Throws if called by any account that's not whitelisted.
77    */
78     modifier onlyWhitelisted() {
79         require(whitelist[msg.sender]);
80         _;
81     }
82 
83     constructor() public {
84         addAddressToWhitelist(msg.sender);   
85     }
86 
87   /**
88    * @dev add an address to the whitelist
89    * @param addr address
90    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
91    */
92     function addAddressToWhitelist(address addr) public onlyOwner returns(bool success) {
93         if (!whitelist[addr]) {
94             whitelist[addr] = true;
95             emit WhitelistedAddressAdded(addr);
96             success = true;
97         }
98     }
99 
100     function getInWhitelist(address addr) public view returns(bool) {
101         return whitelist[addr];
102     }
103 
104     /**
105     * @dev add addresses to the whitelist
106     * @param addrs addresses
107     * @return true if at least one address was added to the whitelist,
108     * false if all addresses were already in the whitelist
109     */
110     function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
111         for (uint256 i = 0; i < addrs.length; i++) {
112             if (addAddressToWhitelist(addrs[i])) {
113                 success = true;
114             }
115         }
116     }
117 
118     /**
119     * @dev remove an address from the whitelist
120     * @param addr address
121     * @return true if the address was removed from the whitelist,
122     * false if the address wasn't in the whitelist in the first place
123     */
124     function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
125         if (whitelist[addr]) {
126             whitelist[addr] = false;
127             emit WhitelistedAddressRemoved(addr);
128             success = true;
129         }
130     }
131 
132     /**
133     * @dev remove addresses from the whitelist
134     * @param addrs addresses
135     * @return true if at least one address was removed from the whitelist,
136     * false if all addresses weren't in the whitelist in the first place
137     */
138     function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
139         for (uint256 i = 0; i < addrs.length; i++) {
140             if (removeAddressFromWhitelist(addrs[i])) {
141                 success = true;
142             }
143         }
144     }
145 }
146 /**
147  * @title SafeMath
148  * @dev Math operations with safety checks that throw on error
149  */
150 library SafeMath {
151     
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         if (a == 0) {
154             return 0;
155         }
156         uint c = a * b;
157         assert(c / a == b);
158         return c;
159     }
160 
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         // assert(b > 0); // Solidity automatically throws when dividing by 0
163         uint256 c = a / b;
164         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165         return c;
166     }
167 
168     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
169         assert(b <= a);
170         return a - b;
171     }
172 
173     function add(uint256 a, uint256 b) internal pure returns (uint256) {
174         uint256 c = a + b;
175         assert(c >= a);
176         return c;
177     }
178   
179 }
180 
181 
182 contract StorageInterface { 
183     function setBunnyCost(uint32 _bunnyID, uint _money) external;
184     function getBunnyCost(uint32 _bunnyID) public view returns (uint money);
185     function deleteBunnyCost(uint32 _bunnyID) external; 
186     function isPauseSave() public  view returns(bool);
187 }
188 
189 
190 
191 
192  
193 /// @title Interface new rabbits address
194 contract PublicInterface { 
195     function transferFrom(address _from, address _to, uint32 _tokenId) public returns (bool);
196     function ownerOf(uint32 _tokenId) public view returns (address owner);
197     function isUIntPublic() public view returns(bool);// check pause
198     function getRabbitMother( uint32 mother) public view returns(uint32[5]);
199     function getRabbitMotherSumm(uint32 mother) public view returns(uint count);
200 }
201 
202 contract Market  is Whitelist { 
203            
204     using SafeMath for uint256;
205     
206     event StopMarket(uint32 bunnyId);
207     event StartMarket(uint32 bunnyId, uint money, uint timeStart, uint stepTimeSale);
208     event BunnyBuy(uint32 bunnyId, uint money);  
209     event Tournament(address who, uint bank, uint timeLeft, uint timeRange);
210     
211     event OwnBank(uint bankMoney, uint countInvestor, address lastOwner, uint addTime, uint stepTime);
212     event MotherMoney(uint32 motherId, uint32 bunnyId, uint money);
213      
214 
215 
216     bool public pause = false; 
217     
218     
219     uint public stepTimeSale = 1;
220  
221 
222     uint public minPrice = 0.0001 ether;
223     uint reallyPrice = 0.0001 ether;
224     uint public rangePrice = 20;
225 
226 
227     uint public minTimeBank = 12*60*60;
228     uint public maxTimeBank = 13*60*60;
229     uint public currentTimeBank = maxTimeBank;
230     uint public rangeTimeBank = 2;
231 
232 
233     uint public coefficientTimeStep = 5;
234     uint public commission = 5;
235     uint public commission_mom = 5;
236     uint public percentBank = 10;
237 
238     // how many times have the bank been increased
239  
240     uint public added_to_the_bank = 0;
241 
242     uint public marketCount = 0; 
243     uint public numberOfWins = 0;  
244     uint public getMoneyCount = 0;
245 
246     string public advertising = "Your advertisement here!";
247  
248     // how many last sales to take into account in the contract before the formation of the price
249   //  uint8 middlelast = 20;
250      
251      
252  
253     // the last cost of a sold seal
254     uint public lastmoney = 0;   
255     uint public totalClosedBID = 0;
256 
257     // how many a bunny
258    // mapping (uint32 => uint) public bunnyCost;
259     mapping (uint32 => uint) public timeCost;
260 
261     
262     address public lastOwner;
263     uint public bankMoney;
264     uint public lastSaleTime;
265 
266     address public pubAddress;
267     address public storageAddress;
268     PublicInterface publicContract; 
269     StorageInterface storageContract; 
270 
271  
272  
273 
274     constructor() public { 
275         transferContract(0x35Ea9df0B7E2E450B1D129a6F81276103b84F3dC); 
276         transferStorage(0x8AC4Da82C4a1E0C1578558C5C685F8AE790dA5a3);
277     }
278 
279     function setRangePrice(uint _rangePrice) public onlyWhitelisted {
280         require(_rangePrice > 0);
281         rangePrice = _rangePrice;
282     }
283 
284     function setReallyPrice(uint _reallyPrice) public onlyWhitelisted {
285         require(_reallyPrice > 0);
286         reallyPrice = _reallyPrice;
287     }
288 
289  
290 
291 
292     function setStepTimeSale(uint _stepTimeSale) public onlyWhitelisted {
293         require(_stepTimeSale > 0);
294         stepTimeSale = _stepTimeSale;
295     }
296 
297     function setRangeTimeBank(uint _rangeTimeBank) public onlyWhitelisted {
298         require(_rangeTimeBank > 0);
299         rangeTimeBank = _rangeTimeBank;
300     }
301 
302     // minimum time step
303     function setMinTimeBank(uint _minTimeBank) public onlyWhitelisted {
304         require(_minTimeBank > 0);
305         minTimeBank = _minTimeBank;
306     }
307 
308     // minimum time step
309     function setMaxTimeBank(uint _maxTimeBank) public onlyWhitelisted {
310         require(_maxTimeBank > 0);
311         maxTimeBank = _maxTimeBank;
312     }
313 
314     // time increment change rate
315     function setCoefficientTimeStep(uint _coefficientTimeStep) public onlyWhitelisted {
316         require(_coefficientTimeStep > 0);
317         coefficientTimeStep = _coefficientTimeStep;
318     }
319 
320  
321 
322     function setPercentCommission(uint _commission) public onlyWhitelisted {
323         require(_commission > 0);
324         commission = _commission;
325     }
326 
327     function setPercentBank(uint _percentBank) public onlyWhitelisted {
328         require(_percentBank > 0);
329         percentBank = _percentBank; 
330     }
331     /**
332     * @dev change min price a bunny
333      */
334     function setMinPrice(uint _minPrice) public onlyWhitelisted {
335         require(_minPrice > 0);
336         minPrice = _minPrice;
337         
338     }
339 
340     function setCurrentTimeBank(uint _currentTimeBank) public onlyWhitelisted {
341         require(_currentTimeBank > 0);
342         currentTimeBank = _currentTimeBank;
343     }
344  
345  
346     /**
347     * @dev We are selling rabbit for sale
348     * @param _bunnyId - whose rabbit we exhibit 
349     * @param _money - sale amount 
350     */
351   function startMarketOwner(uint32 _bunnyId, uint _money) public  onlyWhitelisted {
352         require(checkContract());
353         require(isPauseSave());
354         require(currentPrice(_bunnyId) != _money);
355         require(storageContract.isPauseSave());
356           
357       //  bunnyCost[_bunnyId] = _money;
358         timeCost[_bunnyId] = block.timestamp;
359         storageContract.setBunnyCost(_bunnyId, _money);
360         emit StartMarket(_bunnyId, currentPrice(_bunnyId), block.timestamp, stepTimeSale);
361         marketCount++;
362     }
363  
364     /**
365     * @dev Allows the current owner to transfer control of the contract to a newOwner.
366     * @param _pubAddress  public address of the main contract
367     */
368     function transferContract(address _pubAddress) public onlyWhitelisted {
369         require(_pubAddress != address(0)); 
370         pubAddress = _pubAddress;
371         publicContract = PublicInterface(_pubAddress);
372     } 
373 
374     /**
375     * @dev Allows the current owner to transfer control of the contract to a newOwner.
376     * @param _storageAddress  public address of the main contract
377     */
378     function transferStorage(address _storageAddress) public onlyWhitelisted {
379         require(_storageAddress != address(0)); 
380         storageAddress = _storageAddress;
381         storageContract = StorageInterface(_storageAddress);
382     } 
383  
384     function setPause() public onlyWhitelisted {
385         pause = !pause;
386     }
387 
388     function isPauseSave() public  view returns(bool){
389         return !pause;
390     }
391 
392     /**
393     * @dev get rabbit price
394     */
395     function currentPrice(uint32 _bunnyid) public view returns(uint) { 
396         require(storageContract.isPauseSave());
397         uint money = storageContract.getBunnyCost(_bunnyid);
398         if (money > 0) {
399             //commission_mom
400             uint percOne = money.div(100);
401             // commision
402             
403             uint commissionMoney = percOne.mul(commission);
404             money = money.add(commissionMoney); 
405 
406             uint commissionMom = percOne.mul(commission_mom);
407             money = money.add(commissionMom); 
408 
409             uint percBank = percOne.mul(percentBank);
410             money = money.add(percBank); 
411 
412             return money;
413         }
414     } 
415 
416     function getReallyPrice() public view returns (uint) {
417         return reallyPrice;
418     }
419 
420     /**
421     * @dev We are selling rabbit for sale
422     * @param _bunnyId - whose rabbit we exhibit 
423     * @param _money - sale amount 
424     */
425   function startMarket(uint32 _bunnyId, uint _money) public{
426         require(checkContract());
427         require(isPauseSave());
428         require(currentPrice(_bunnyId) != _money);
429         require(storageContract.isPauseSave());
430         require(_money >= reallyPrice);
431 
432         require(publicContract.ownerOf(_bunnyId) == msg.sender);
433 
434         timeCost[_bunnyId] = block.timestamp;
435 
436         storageContract.setBunnyCost(_bunnyId, _money);
437         
438         emit StartMarket(_bunnyId, currentPrice(_bunnyId), block.timestamp, stepTimeSale);
439         marketCount++;
440     }
441 
442     /**
443     * @dev remove from sale rabbit
444     * @param _bunnyId - a rabbit that is removed from sale 
445     */
446     function stopMarket(uint32 _bunnyId) public returns(uint) {
447         require(checkContract());
448         require(isPauseSave());
449         require(publicContract.ownerOf(_bunnyId) == msg.sender);
450         require(storageContract.isPauseSave());
451 
452         storageContract.deleteBunnyCost(_bunnyId);
453         emit StopMarket(_bunnyId);
454         return marketCount--;
455     }
456 
457     function timeBunny(uint32 _bunnyId) public view returns(bool can, uint timeleft) {
458         uint _tmp = timeCost[_bunnyId].add(stepTimeSale);
459         if (timeCost[_bunnyId] > 0 && block.timestamp >= _tmp) {
460             can = true;
461             timeleft = 0;
462         } else { 
463             can = false; 
464             _tmp = _tmp.sub(block.timestamp);
465             if (_tmp > 0) {
466                 timeleft = _tmp;
467             } else {
468                 timeleft = 0;
469             }
470         } 
471     }
472 
473     function transferFromBunny(uint32 _bunnyId) public {
474         require(checkContract());
475         publicContract.transferFrom(publicContract.ownerOf(_bunnyId), msg.sender, _bunnyId); 
476     }
477 
478 
479 // https://rinkeby.etherscan.io/address/0xc7984712b3d0fac8e965dd17a995db5007fe08f2#writeContract
480     /**
481     * @dev Acquisition of a rabbit from another user
482     * @param _bunnyId  Bunny
483      */
484     function buyBunny(uint32 _bunnyId) public payable {
485         require(isPauseSave());
486         require(checkContract());
487         require(publicContract.ownerOf(_bunnyId) != msg.sender);
488         require(storageContract.isPauseSave());
489         lastmoney = currentPrice(_bunnyId);
490         require(msg.value >= lastmoney && 0 != lastmoney);
491 
492         bool can;
493         (can,) = timeBunny(_bunnyId);
494         require(can); 
495         // stop trading on the current rabbit
496         totalClosedBID++;
497         // Sending money to the old user 
498         // is sent to the new owner of the bought rabbit
499  
500         checkTimeWin();
501         sendMoney(publicContract.ownerOf(_bunnyId), lastmoney);
502 
503         publicContract.transferFrom(publicContract.ownerOf(_bunnyId), msg.sender, _bunnyId); 
504         sendMoneyMother(_bunnyId);
505         stopMarket(_bunnyId);
506         changeReallyPrice();
507         changeReallyTime();
508         lastOwner = msg.sender; 
509         lastSaleTime = block.timestamp; 
510         emit OwnBank(bankMoney, added_to_the_bank, lastOwner, lastSaleTime, currentTimeBank);
511         emit BunnyBuy(_bunnyId, lastmoney);
512     }  
513 
514     
515     function changeReallyTime() internal {
516         if (rangeTimeBank > 0) {
517             uint tmp = added_to_the_bank.div(rangeTimeBank);
518             tmp = maxTimeBank.sub(tmp);
519 
520             if (currentTimeBank > minTimeBank) { 
521                 currentTimeBank = tmp;
522             }
523         } 
524     }
525  
526     function changeReallyPrice() internal {
527         if (added_to_the_bank > 0 && rangePrice > 0) {
528             uint tmp = added_to_the_bank.div(rangePrice);
529             reallyPrice = minPrice.mul(tmp);  
530         } 
531     }
532   
533 
534      
535     function sendMoneyMother(uint32 _bunnyId) internal {
536         uint money = storageContract.getBunnyCost(_bunnyId);
537         if (money > 0) { 
538             uint procentOne = (money.div(100)); 
539             // commission_mom
540             uint32[5] memory mother;
541             mother = publicContract.getRabbitMother(_bunnyId);
542             uint motherCount = publicContract.getRabbitMotherSumm(_bunnyId);
543             if (motherCount > 0) {
544                 uint motherMoney = (procentOne*commission_mom).div(motherCount);
545                     for (uint m = 0; m < 5; m++) {
546                         if (mother[m] != 0) {
547                             publicContract.ownerOf(mother[m]).transfer(motherMoney);
548                             emit MotherMoney(mother[m], _bunnyId, motherMoney);
549                         }
550                     }
551                 } 
552         }
553     }
554 
555 
556     /**
557     * @param _to to whom money is sent
558     * @param _money the amount of money is being distributed at the moment
559      */
560     function sendMoney(address _to, uint256 _money) internal { 
561         if (_money > 0) { 
562             uint procentOne = (_money/100); 
563             _to.transfer(procentOne * (100-(commission+percentBank+commission_mom)));
564             addBank(procentOne*percentBank);
565             ownerMoney.transfer(procentOne*commission);  
566         }
567     }
568 
569 
570 
571     function checkTimeWin() internal {
572         if (lastSaleTime + currentTimeBank < block.timestamp) {
573             win(); 
574         }
575         lastSaleTime = block.timestamp;
576     }
577 
578     
579     function win() internal {
580         // ####### WIN ##############
581         // send money
582         if (address(this).balance > 0 && address(this).balance >= bankMoney && lastOwner != address(0)) { 
583             advertising = "";
584             added_to_the_bank = 0;
585             reallyPrice = minPrice;
586             currentTimeBank = maxTimeBank;
587 
588             lastOwner.transfer(bankMoney);
589             numberOfWins = numberOfWins.add(1); 
590             emit Tournament (lastOwner, bankMoney, lastSaleTime, block.timestamp);
591             bankMoney = 0;
592         }
593     }    
594     
595     
596     /**
597     * @dev add money of bank
598     */
599     function addCountInvestors(uint countInvestors) public onlyWhitelisted  { 
600         added_to_the_bank = countInvestors;
601     }
602 
603         /**
604     * @dev add money of bank
605     */
606     function addBank(uint _money) internal { 
607         bankMoney = bankMoney.add(_money);
608         added_to_the_bank = added_to_the_bank.add(1);
609     }
610      
611  
612     function ownerOf(uint32 _bunnyId) public  view returns(address) {
613         return publicContract.ownerOf(_bunnyId);
614     } 
615     
616     /**
617     * Check
618      */
619     function checkContract() public view returns(bool) {
620         return publicContract.isUIntPublic(); 
621     }
622 
623     function buyAdvert(string _text)  public payable { 
624         require(msg.value > (reallyPrice*2));
625         require(checkContract());
626         advertising = _text;
627         addBank(msg.value); 
628     }
629  
630     /**
631     * Only if the user has violated the advertising rules
632      */
633     function noAdvert() public onlyWhitelisted {
634         advertising = "";
635     } 
636  
637     /**
638     * Only unforeseen situations
639      */
640     function getMoney(uint _value) public onlyWhitelisted {
641         require(address(this).balance >= _value); 
642         ownerMoney.transfer(_value);
643         // for public, no scam
644         getMoneyCount = getMoneyCount.add(_value);
645     }
646     /**
647     * For convenience in the client interface
648      */
649     function getProperty() public view 
650     returns(
651             uint tmp_currentTimeBank,
652             uint tmp_stepTimeSale,
653             uint tmp_minPrice,
654             uint tmp_reallyPrice,
655             
656             uint tmp_added_to_the_bank,
657             uint tmp_marketCount, 
658             uint tmp_numberOfWins,
659             uint tmp_getMoneyCount,
660             uint tmp_lastmoney,   
661             uint tmp_totalClosedBID,
662             uint tmp_bankMoney,
663             uint tmp_lastSaleTime
664             )
665             {
666                 tmp_currentTimeBank = currentTimeBank;
667                 tmp_stepTimeSale = stepTimeSale;
668                 tmp_minPrice = minPrice;
669                 tmp_reallyPrice = reallyPrice;
670                 tmp_added_to_the_bank = added_to_the_bank;
671                 tmp_marketCount = marketCount; 
672                 tmp_numberOfWins = numberOfWins;
673                 tmp_getMoneyCount = getMoneyCount;
674 
675                 tmp_lastmoney = lastmoney;   
676                 tmp_totalClosedBID = totalClosedBID;
677                 tmp_bankMoney = bankMoney;
678                 tmp_lastSaleTime = lastSaleTime;
679     }
680 
681 }