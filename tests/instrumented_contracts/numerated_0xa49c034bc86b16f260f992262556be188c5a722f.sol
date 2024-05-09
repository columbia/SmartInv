1 pragma solidity ^0.4.23;
2 /*
3 ** WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
4 *
5 
6 * BUNNY IS GAME MARKET
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
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23  
24 
25     /**
26     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27     * account.
28     */    
29     constructor() public {
30         owner = msg.sender;
31         ownerMoney = msg.sender;
32     }
33 
34     /**
35     * @dev Throws if called by any account other than the owner.
36     */
37     modifier onlyOwner() {
38         require(msg.sender == owner);
39         _;
40     }
41 
42  
43 
44     function transferMoney(address _add) public  onlyOwner {
45         if (_add != address(0)) {
46             ownerMoney = _add;
47         }
48     }
49     
50  
51     function transferOwner(address _add) public onlyOwner {
52         if (_add != address(0)) {
53             owner = _add;
54         }
55     } 
56       
57     function getOwnerMoney() public view onlyOwner returns(address) {
58         return ownerMoney;
59     } 
60  
61 }
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
181 /// @title Interface new rabbits address
182 contract PublicInterface { 
183     function transferFrom(address _from, address _to, uint32 _tokenId) public returns (bool);
184     function ownerOf(uint32 _tokenId) public view returns (address owner);
185     function isUIntPublic() public view returns(bool);// check pause
186     function getRabbitMother( uint32 mother) public view returns(uint32[5]);
187     function getRabbitMotherSumm(uint32 mother) public view returns(uint count);
188 }
189 
190 contract Market  is Whitelist { 
191            
192     using SafeMath for uint256;
193     
194     event StopMarket(uint32 bunnyId);
195     event StartMarket(uint32 bunnyId, uint money, uint timeStart, uint stepTimeSale);
196     event BunnyBuy(uint32 bunnyId, uint money);  
197     event Tournament(address who, uint bank, uint timeLeft, uint timeRange);
198     event AddBank(uint bankMoney, uint countInvestor, address lastOwner, uint addTime, uint stepTime);
199 
200     event OwnBank(uint bankMoney, uint countInvestor, address lastOwner, uint addTime, uint stepTime);
201 
202     event MotherMoney(uint32 motherId, uint32 bunnyId, uint money);
203      
204 
205 
206     bool public pause = false; 
207     
208     uint stepTimeBank = 12*60*60; 
209     uint stepTimeSale = 1;
210  
211 
212 
213     uint minPrice = 0.0001 ether;
214     uint reallyPrice = 0.0001 ether;
215     uint rangePrice = 20;
216 
217     uint minTimeBank = 12*60*60;
218     uint coefficientTimeStep = 5;
219  
220     uint public commission = 5;
221     uint public commission_mom = 5;
222     uint public percentBank = 10;
223 
224     // how many times have the bank been increased
225  
226     uint public added_to_the_bank = 0;
227 
228     uint public marketCount = 0; 
229     uint public numberOfWins = 0;  
230     uint public getMoneyCount = 0;
231 
232     string public advertising = "Your advertisement here!";
233 
234      uint sec = 1;
235     // how many last sales to take into account in the contract before the formation of the price
236   //  uint8 middlelast = 20;
237      
238      
239  
240     // the last cost of a sold seal
241     uint public lastmoney = 0;   
242     uint public totalClosedBID = 0;
243 
244     // how many a bunny
245     mapping (uint32 => uint) public bunnyCost;
246     mapping (uint32 => uint) public timeCost;
247 
248     
249     address public lastOwner;
250     uint public bankMoney;
251     uint public lastSaleTime;
252 
253     address public pubAddress;
254     PublicInterface publicContract; 
255 
256 
257     /**
258     * For convenience in the client interface
259      */
260     function getProperty() public view 
261     returns(
262             uint tmp_stepTimeBank,
263             uint tmp_stepTimeSale,
264             uint tmp_minPrice,
265             uint tmp_reallyPrice,
266           //  uint tmp_rangePrice,
267           //  uint tmp_commission,
268           //  uint tmp_percentBank,
269             uint tmp_added_to_the_bank,
270             uint tmp_marketCount, 
271             uint tmp_numberOfWins,
272             uint tmp_getMoneyCount,
273             uint tmp_lastmoney,   
274             uint tmp_totalClosedBID,
275             uint tmp_bankMoney,
276             uint tmp_lastSaleTime
277             )
278             {
279                 tmp_stepTimeBank = stepTimeBank;
280                 tmp_stepTimeSale = stepTimeSale;
281                 tmp_minPrice = minPrice;
282                 tmp_reallyPrice = reallyPrice;
283               //  tmp_rangePrice = rangePrice;
284              //   tmp_commission = commission;
285              //   tmp_percentBank = percentBank;
286                 tmp_added_to_the_bank = added_to_the_bank;
287                 tmp_marketCount = marketCount; 
288                 tmp_numberOfWins = numberOfWins;
289                 tmp_getMoneyCount = getMoneyCount;
290 
291                 tmp_lastmoney = lastmoney;   
292                 tmp_totalClosedBID = totalClosedBID;
293                 tmp_bankMoney = bankMoney;
294                 tmp_lastSaleTime = lastSaleTime;
295     }
296 
297 
298     constructor() public { 
299         transferContract(0x35Ea9df0B7E2E450B1D129a6F81276103b84F3dC);
300     }
301 
302     function setRangePrice(uint _rangePrice) public onlyWhitelisted {
303         require(_rangePrice > 0);
304         rangePrice = _rangePrice;
305     }
306 
307 
308     function setStepTimeSale(uint _stepTimeSale) public onlyWhitelisted {
309         require(_stepTimeSale > 0);
310         stepTimeSale = _stepTimeSale;
311     }
312 
313  
314 
315     // minimum time step
316     function setMinTimeBank(uint _minTimeBank) public onlyWhitelisted {
317         require(_minTimeBank > 0);
318         minTimeBank = _minTimeBank;
319     }
320 
321     // time increment change rate
322     function setCoefficientTimeStep(uint _coefficientTimeStep) public onlyWhitelisted {
323         require(_coefficientTimeStep > 0);
324         coefficientTimeStep = _coefficientTimeStep;
325     }
326 
327  
328 
329     function setPercentCommission(uint _commission) public onlyWhitelisted {
330         require(_commission > 0);
331         commission = _commission;
332     }
333 
334     function setPercentBank(uint _percentBank) public onlyWhitelisted {
335         require(_percentBank > 0);
336         percentBank = _percentBank; 
337     }
338     /**
339     * @dev change min price a bunny
340      */
341     function setMinPrice(uint _minPrice) public onlyWhitelisted {
342         require(_minPrice > 0);
343         minPrice = _minPrice;
344         
345     }
346 
347     function setStepTime(uint _stepTimeBank) public onlyWhitelisted {
348         require(_stepTimeBank > 0);
349         stepTimeBank = _stepTimeBank;
350     }
351  
352  
353  
354     /**
355     * @dev Allows the current owner to transfer control of the contract to a newOwner.
356     * @param _pubAddress  public address of the main contract
357     */
358     function transferContract(address _pubAddress) public onlyWhitelisted {
359         require(_pubAddress != address(0)); 
360         pubAddress = _pubAddress;
361         publicContract = PublicInterface(_pubAddress);
362     } 
363  
364     function setPause() public onlyWhitelisted {
365         pause = !pause;
366     }
367 
368     function isPauseSave() public  view returns(bool){
369         return !pause;
370     }
371 
372     /**
373     * @dev get rabbit price
374     */
375     function currentPrice(uint32 _bunnyid) public view returns(uint) { 
376         uint money = bunnyCost[_bunnyid];
377         if (money > 0) {
378             //commission_mom
379             uint percOne = money.div(100);
380             // commision
381             
382             uint commissionMoney = percOne.mul(commission);
383             money = money.add(commissionMoney); 
384 
385             uint commissionMom = percOne.mul(commission_mom);
386             money = money.add(commissionMom); 
387 
388             uint percBank = percOne.mul(percentBank);
389             money = money.add(percBank); 
390 
391             return money;
392         }
393     } 
394 
395     /**
396     * @dev We are selling rabbit for sale
397     * @param _bunnyId - whose rabbit we exhibit 
398     * @param _money - sale amount 
399     */
400   function startMarket(uint32 _bunnyId, uint _money) public returns (uint) {
401         require(checkContract());
402         require(isPauseSave());
403 
404         require(_money >= reallyPrice);
405 
406         require(publicContract.ownerOf(_bunnyId) == msg.sender);
407         bunnyCost[_bunnyId] = _money;
408         timeCost[_bunnyId] = block.timestamp;
409         
410         emit StartMarket(_bunnyId, currentPrice(_bunnyId), block.timestamp, stepTimeSale);
411         return marketCount++;
412     }
413 
414     /**
415     * @dev remove from sale rabbit
416     * @param _bunnyId - a rabbit that is removed from sale 
417     */
418     function stopMarket(uint32 _bunnyId) public returns(uint) {
419         require(checkContract());
420         require(isPauseSave());
421         require(publicContract.ownerOf(_bunnyId) == msg.sender);
422         bunnyCost[_bunnyId] = 0;
423         emit StopMarket(_bunnyId);
424         return marketCount--;
425     }
426  
427  
428     function changeReallyPrice() internal {
429         if (added_to_the_bank > 0 && rangePrice > 0 && added_to_the_bank > rangePrice) {
430             uint tmp = added_to_the_bank.div(rangePrice);
431             tmp = reallyPrice.div(tmp); 
432             reallyPrice = reallyPrice.add(tmp);
433         } 
434     }
435  
436      
437 
438 
439     function timeBunny(uint32 _bunnyId) public view returns(bool can, uint timeleft) {
440         uint _tmp = timeCost[_bunnyId].add(stepTimeSale);
441         if (timeCost[_bunnyId] > 0 && block.timestamp >= _tmp) {
442             can = true;
443             timeleft = 0;
444         } else { 
445             can = false; 
446             _tmp = _tmp.sub(block.timestamp);
447             if (_tmp > 0) {
448                 timeleft = _tmp;
449             } else {
450                 timeleft = 0;
451             }
452         } 
453     }
454 
455     function transferFromBunny(uint32 _bunnyId) public {
456         require(checkContract());
457         publicContract.transferFrom(publicContract.ownerOf(_bunnyId), msg.sender, _bunnyId); 
458     }
459 
460 
461 // https://rinkeby.etherscan.io/address/0xc7984712b3d0fac8e965dd17a995db5007fe08f2#writeContract
462     /**
463     * @dev Acquisition of a rabbit from another user
464     * @param _bunnyId  Bunny
465      */
466     function buyBunny(uint32 _bunnyId) public payable {
467         require(isPauseSave());
468         require(checkContract());
469         require(publicContract.ownerOf(_bunnyId) != msg.sender);
470         lastmoney = currentPrice(_bunnyId);
471         require(msg.value >= lastmoney && 0 != lastmoney);
472 
473         bool can;
474         (can,) = timeBunny(_bunnyId);
475         require(can); 
476         // stop trading on the current rabbit
477         totalClosedBID++;
478         // Sending money to the old user 
479         // is sent to the new owner of the bought rabbit
480  
481         checkTimeWin();
482         
483         sendMoney(publicContract.ownerOf(_bunnyId), lastmoney);
484         
485         publicContract.transferFrom(publicContract.ownerOf(_bunnyId), msg.sender, _bunnyId); 
486         
487         sendMoneyMother(_bunnyId);
488 
489         stopMarket(_bunnyId);
490 
491         changeReallyPrice();
492         lastOwner = msg.sender; 
493         lastSaleTime = block.timestamp; 
494 
495         emit OwnBank(bankMoney, added_to_the_bank, lastOwner, lastSaleTime, stepTimeBank);
496         emit BunnyBuy(_bunnyId, lastmoney);
497     }  
498      
499     function sendMoneyMother(uint32 _bunnyId) internal {
500         if (bunnyCost[_bunnyId] > 0) { 
501             uint procentOne = (bunnyCost[_bunnyId].div(100)); 
502             // commission_mom
503             uint32[5] memory mother;
504             mother = publicContract.getRabbitMother(_bunnyId);
505 
506             uint motherCount = publicContract.getRabbitMotherSumm(_bunnyId);
507             if (motherCount > 0) {
508                 uint motherMoney = (procentOne*commission_mom).div(motherCount);
509                     for (uint m = 0; m < 5; m++) {
510                         if (mother[m] != 0) {
511                             publicContract.ownerOf(mother[m]).transfer(motherMoney);
512                             emit MotherMoney(mother[m], _bunnyId, motherMoney);
513                         }
514                     }
515                 } 
516         }
517     }
518 
519 
520     /**
521     * @param _to to whom money is sent
522     * @param _money the amount of money is being distributed at the moment
523      */
524     function sendMoney(address _to, uint256 _money) internal { 
525         if (_money > 0) { 
526             uint procentOne = (_money/100); 
527             _to.transfer(procentOne * (100-(commission+percentBank+commission_mom)));
528             addBank(procentOne*percentBank);
529             ownerMoney.transfer(procentOne*commission);  
530         }
531     }
532 
533 
534 
535     function checkTimeWin() internal {
536         if (lastSaleTime + stepTimeBank < block.timestamp) {
537             win(); 
538         }
539         lastSaleTime = block.timestamp;
540     }
541     function win() internal {
542         // ####### WIN ##############
543         // send money
544         if (address(this).balance > 0 && address(this).balance >= bankMoney && lastOwner != address(0)) { 
545             advertising = "";
546             added_to_the_bank = 0;
547             reallyPrice = minPrice;
548             lastOwner.transfer(bankMoney);
549             numberOfWins = numberOfWins.add(1); 
550             emit Tournament (lastOwner, bankMoney, lastSaleTime, block.timestamp);
551             bankMoney = 0;
552         }
553     }    
554     
555         /**
556     * @dev add money of bank
557     */
558     function addBank(uint _money) internal { 
559         bankMoney = bankMoney.add(_money);
560         added_to_the_bank = added_to_the_bank.add(1);
561 
562         emit AddBank(bankMoney, added_to_the_bank, lastOwner, block.timestamp, stepTimeBank);
563 
564     }  
565      
566  
567     function ownerOf(uint32 _bunnyId) public  view returns(address) {
568         return publicContract.ownerOf(_bunnyId);
569     } 
570     
571     /**
572     * Check
573      */
574     function checkContract() public view returns(bool) {
575         return publicContract.isUIntPublic(); 
576     }
577 
578     function buyAdvert(string _text)  public payable { 
579         require(msg.value > (reallyPrice*2));
580         require(checkContract());
581         advertising = _text;
582         addBank(msg.value); 
583     }
584  
585     /**
586     * Only if the user has violated the advertising rules
587      */
588     function noAdvert() public onlyWhitelisted {
589         advertising = "";
590     } 
591  
592     /**
593     * Only unforeseen situations
594      */
595     function getMoney(uint _value) public onlyOwner {
596         require(address(this).balance >= _value); 
597         ownerMoney.transfer(_value);
598         // for public, no scam
599         getMoneyCount = getMoneyCount.add(_value);
600     }
601 }