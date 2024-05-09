1 pragma solidity ^0.4.4;
2  
3 
4 /*    
5 * Author:  Konstantin G...
6 * Telegram: @bunnygame
7 * 
8 * email: info@bunnycoin.co
9 * site : http://bunnycoin.co
10 * @title Ownable
11 * @dev The Ownable contract has an owner address, and provides basic authorization control
12 * functions, this simplifies the implementation of "user permissions".
13 */
14 
15 contract Ownable {
16     
17     address owner;
18     address ownerMoney;   
19     
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21  
22 
23     /**
24     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25     * account.
26     */    
27     constructor() public {
28         owner = msg.sender;
29         ownerMoney = msg.sender;
30     }
31 
32     /**
33     * @dev Throws if called by any account other than the owner.
34     */
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40  
41 
42     function transferMoney(address _add) public  onlyOwner {
43         if (_add != address(0)) {
44             ownerMoney = _add;
45         }
46     }
47     
48  
49     function transferOwner(address _add) public onlyOwner {
50         if (_add != address(0)) {
51             owner = _add;
52         }
53     } 
54       
55     function getOwnerMoney() public view onlyOwner returns(address) {
56         return ownerMoney;
57     } 
58  
59 }
60 
61  
62 
63 /**
64  * @title Whitelist
65  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
66  * @dev This simplifies the implementation of "user permissions".
67  */
68 contract Whitelist is Ownable {
69     mapping(address => bool) public whitelist;
70 
71     event WhitelistedAddressAdded(address addr);
72     event WhitelistedAddressRemoved(address addr);
73  
74   /**
75    * @dev Throws if called by any account that's not whitelisted.
76    */
77     modifier onlyWhitelisted() {
78         require(whitelist[msg.sender]);
79         _;
80     }
81 
82     constructor() public {
83         addAddressToWhitelist(msg.sender);   
84     }
85 
86   /**
87    * @dev add an address to the whitelist
88    * @param addr address
89    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
90    */
91     function addAddressToWhitelist(address addr) public onlyOwner returns(bool success) {
92         if (!whitelist[addr]) {
93             whitelist[addr] = true;
94             emit WhitelistedAddressAdded(addr);
95             success = true;
96         }
97     }
98 
99     function getInWhitelist(address addr) public view returns(bool) {
100         return whitelist[addr];
101     }
102 
103     /**
104     * @dev add addresses to the whitelist
105     * @param addrs addresses
106     * @return true if at least one address was added to the whitelist,
107     * false if all addresses were already in the whitelist
108     */
109     function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
110         for (uint256 i = 0; i < addrs.length; i++) {
111             if (addAddressToWhitelist(addrs[i])) {
112                 success = true;
113             }
114         }
115     }
116 
117     /**
118     * @dev remove an address from the whitelist
119     * @param addr address
120     * @return true if the address was removed from the whitelist,
121     * false if the address wasn't in the whitelist in the first place
122     */
123     function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
124         if (whitelist[addr]) {
125             whitelist[addr] = false;
126             emit WhitelistedAddressRemoved(addr);
127             success = true;
128         }
129     }
130 
131     /**
132     * @dev remove addresses from the whitelist
133     * @param addrs addresses
134     * @return true if at least one address was removed from the whitelist,
135     * false if all addresses weren't in the whitelist in the first place
136     */
137     function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
138         for (uint256 i = 0; i < addrs.length; i++) {
139             if (removeAddressFromWhitelist(addrs[i])) {
140                 success = true;
141             }
142         }
143     }
144 } 
145 /**
146  * @title SafeMath
147  * @dev Math operations with safety checks that throw on error
148  */
149 library SafeMath {
150     
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         if (a == 0) {
153             return 0;
154         }
155         uint c = a * b;
156         assert(c / a == b);
157         return c;
158     }
159 
160     function div(uint256 a, uint256 b) internal pure returns (uint256) {
161         // assert(b > 0); // Solidity automatically throws when dividing by 0
162         uint256 c = a / b;
163         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
164         return c;
165     }
166 
167     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168         assert(b <= a);
169         return a - b;
170     }
171 
172     function add(uint256 a, uint256 b) internal pure returns (uint256) {
173         uint256 c = a + b;
174         assert(c >= a);
175         return c;
176     }
177   
178 }
179  
180 /// @title Interface new rabbits address
181 contract PublicInterface { 
182     function transferFrom(address _from, address _to, uint32 _tokenId) public returns (bool);
183     function ownerOf(uint32 _tokenId) public view returns (address owner);
184     function isUIntPublic() public view returns(bool);// check pause
185     function getRabbitMother( uint32 mother) public view returns(uint32[5]);
186     function getRabbitMotherSumm(uint32 mother) public view returns(uint count);
187 }
188 
189 contract Market  is Whitelist { 
190            
191     using SafeMath for uint256;
192     
193     event StopMarket(uint32 bunnyId);
194     event StartMarket(uint32 bunnyId, uint money, uint timeStart, uint stepTimeSale);
195     event BunnyBuy(uint32 bunnyId, uint money);  
196     event Tournament(address who, uint bank, uint timeLeft, uint timeRange);
197     event AddBank(uint bankMoney, uint countInvestor, address lastOwner, uint addTime, uint stepTime);
198 
199     event MotherMoney(uint32 motherId, uint32 bunnyId, uint money);
200      
201 
202 
203     bool public pause = false; 
204     
205     uint stepTimeBank = 50*60; 
206     uint stepTimeSale = (stepTimeBank/10)+stepTimeBank;
207 
208   //  uint stepTimeBank = 1; 
209   //  uint stepTimeSale = (stepTimeBank/10)+stepTimeBank;
210 
211 
212     uint minPrice = 0.001 ether;
213     uint reallyPrice = 0.001 ether;
214     uint rangePrice = 2;
215 
216     uint minTimeBank = 300;
217     uint coefficientTimeStep = 5;
218  
219     uint public commission = 5;
220     uint public commission_mom = 5;
221     uint public percentBank = 10;
222 
223     // how many times have the bank been increased
224  
225     uint added_to_the_bank = 0;
226 
227     uint marketCount = 0; 
228     uint numberOfWins = 0;  
229     uint getMoneyCount = 0;
230 
231     string public advertising = "Your advertisement here!";
232 
233      uint sec = 1;
234     // how many last sales to take into account in the contract before the formation of the price
235   //  uint8 middlelast = 20;
236      
237      
238  
239     // the last cost of a sold seal
240     uint lastmoney = 0;   
241     uint totalClosedBID = 0;
242 
243     // how many a bunny
244     mapping (uint32 => uint) public bunnyCost;
245     mapping (uint32 => uint) public timeCost;
246 
247     
248     address public lastOwner;
249     uint bankMoney;
250     uint lastSaleTime;
251 
252     address public pubAddress;
253     PublicInterface publicContract; 
254 
255 
256     /**
257     * For convenience in the client interface
258      */
259     function getProperty() public view 
260     returns(
261             uint tmp_stepTimeBank,
262             uint tmp_stepTimeSale,
263             uint tmp_minPrice,
264             uint tmp_reallyPrice,
265           //  uint tmp_rangePrice,
266           //  uint tmp_commission,
267           //  uint tmp_percentBank,
268             uint tmp_added_to_the_bank,
269             uint tmp_marketCount, 
270             uint tmp_numberOfWins,
271             uint tmp_getMoneyCount,
272             uint tmp_lastmoney,   
273             uint tmp_totalClosedBID,
274             uint tmp_bankMoney,
275             uint tmp_lastSaleTime
276             )
277             {
278                 tmp_stepTimeBank = stepTimeBank;
279                 tmp_stepTimeSale = stepTimeSale;
280                 tmp_minPrice = minPrice;
281                 tmp_reallyPrice = reallyPrice;
282               //  tmp_rangePrice = rangePrice;
283              //   tmp_commission = commission;
284              //   tmp_percentBank = percentBank;
285                 tmp_added_to_the_bank = added_to_the_bank;
286                 tmp_marketCount = marketCount; 
287                 tmp_numberOfWins = numberOfWins;
288                 tmp_getMoneyCount = getMoneyCount;
289 
290                 tmp_lastmoney = lastmoney;   
291                 tmp_totalClosedBID = totalClosedBID;
292                 tmp_bankMoney = bankMoney;
293                 tmp_lastSaleTime = lastSaleTime;
294     }
295 
296 
297     constructor() public { 
298         transferContract(0x434f0DCF2fE5Cb51d888850e7C77C4551725F2Ff);
299     }
300 
301     function setRangePrice(uint _rangePrice) public onlyWhitelisted {
302         require(_rangePrice > 0);
303         rangePrice = _rangePrice;
304     }
305     // minimum time step
306     function setMinTimeBank(uint _minTimeBank) public onlyWhitelisted {
307         require(_minTimeBank > 0);
308         minTimeBank = _minTimeBank;
309     }
310 
311     // time increment change rate
312     function setCoefficientTimeStep(uint _coefficientTimeStep) public onlyWhitelisted {
313         require(_coefficientTimeStep > 0);
314         coefficientTimeStep = _coefficientTimeStep;
315     }
316 
317  
318 
319     function setPercentCommission(uint _commission) public onlyWhitelisted {
320         require(_commission > 0);
321         commission = _commission;
322     }
323 
324     function setPercentBank(uint _percentBank) public onlyWhitelisted {
325         require(_percentBank > 0);
326         percentBank = _percentBank; 
327     }
328     /**
329     * @dev change min price a bunny
330      */
331     function setMinPrice(uint _minPrice) public onlyWhitelisted {
332         require(_minPrice > (10**15));
333         minPrice = _minPrice;
334         
335     }
336 
337     function setStepTime(uint _stepTimeBank) public onlyWhitelisted {
338         require(_stepTimeBank > 0);
339         stepTimeBank = _stepTimeBank;
340         stepTimeSale = _stepTimeBank+1;
341     }
342  
343  
344  
345     /**
346     * @dev Allows the current owner to transfer control of the contract to a newOwner.
347     * @param _pubAddress  public address of the main contract
348     */
349     function transferContract(address _pubAddress) public onlyWhitelisted {
350         require(_pubAddress != address(0)); 
351         pubAddress = _pubAddress;
352         publicContract = PublicInterface(_pubAddress);
353     } 
354  
355     function setPause() public onlyWhitelisted {
356         pause = !pause;
357     }
358 
359     function isPauseSave() public  view returns(bool){
360         return !pause;
361     }
362 
363     /**
364     * @dev get rabbit price
365     */
366     function currentPrice(uint32 _bunnyid) public view returns(uint) { 
367         uint money = bunnyCost[_bunnyid];
368         if (money > 0) {
369             //commission_mom
370             uint percOne = money.div(100);
371             // commision
372             
373             uint commissionMoney = percOne.mul(commission);
374             money = money.add(commissionMoney); 
375 
376             uint commissionMom = percOne.mul(commission_mom);
377             money = money.add(commissionMom); 
378 
379             uint percBank = percOne.mul(percentBank);
380             money = money.add(percBank); 
381 
382             return money;
383         }
384     } 
385 
386     /**
387     * @dev We are selling rabbit for sale
388     * @param _bunnyId - whose rabbit we exhibit 
389     * @param _money - sale amount 
390     */
391   function startMarket(uint32 _bunnyId, uint _money) public returns (uint) {
392         require(checkContract());
393         require(isPauseSave());
394         require(_money >= reallyPrice);
395         require(publicContract.ownerOf(_bunnyId) == msg.sender);
396         bunnyCost[_bunnyId] = _money;
397         timeCost[_bunnyId] = block.timestamp;
398         
399         emit StartMarket(_bunnyId, currentPrice(_bunnyId), block.timestamp, stepTimeSale);
400         return marketCount++;
401     }
402 
403     /**
404     * @dev remove from sale rabbit
405     * @param _bunnyId - a rabbit that is removed from sale 
406     */
407     function stopMarket(uint32 _bunnyId) public returns(uint) {
408         require(checkContract());
409         require(isPauseSave());
410         require(publicContract.ownerOf(_bunnyId) == msg.sender);
411         bunnyCost[_bunnyId] = 0;
412         emit StopMarket(_bunnyId);
413         return marketCount--;
414     }
415  
416  
417     function changeReallyPrice() internal {
418         if (added_to_the_bank > 0 && rangePrice > 0) {
419             uint tmp = added_to_the_bank.div(rangePrice);
420             reallyPrice = tmp * (10**15)+reallyPrice; 
421 
422 
423             uint tmpTime = added_to_the_bank.div(coefficientTimeStep);
424             if (tmpTime <= minTimeBank) {
425                 stepTimeBank = minTimeBank;
426             } else {
427                 stepTimeBank = tmpTime;
428             }
429         } 
430     }
431  
432      
433 
434 
435     function timeBunny(uint32 _bunnyId) public view returns(bool can, uint timeleft) {
436         uint _tmp = timeCost[_bunnyId].add(stepTimeSale);
437         if (timeCost[_bunnyId] > 0 && block.timestamp >= _tmp) {
438             can = true;
439             timeleft = 0;
440         } else { 
441             can = false; 
442             _tmp = _tmp.sub(block.timestamp);
443             if (_tmp > 0) {
444                 timeleft = _tmp;
445             } else {
446                 timeleft = 0;
447             }
448         } 
449     }
450 
451     function transferFromBunny(uint32 _bunnyId) public {
452         require(checkContract());
453         publicContract.transferFrom(publicContract.ownerOf(_bunnyId), msg.sender, _bunnyId); 
454     }
455 
456 
457 // https://rinkeby.etherscan.io/address/0xc7984712b3d0fac8e965dd17a995db5007fe08f2#writeContract
458     /**
459     * @dev Acquisition of a rabbit from another user
460     * @param _bunnyId  Bunny
461      */
462     function buyBunny(uint32 _bunnyId) public payable {
463         require(isPauseSave());
464         require(checkContract());
465         require(publicContract.ownerOf(_bunnyId) != msg.sender);
466         lastmoney = currentPrice(_bunnyId);
467         require(msg.value >= lastmoney && 0 != lastmoney);
468 
469         bool can;
470         (can,) = timeBunny(_bunnyId);
471         require(can); 
472         // stop trading on the current rabbit
473         totalClosedBID++;
474         // Sending money to the old user 
475         // is sent to the new owner of the bought rabbit
476  
477         checkTimeWin();
478         
479         sendMoney(publicContract.ownerOf(_bunnyId), lastmoney);
480         
481         publicContract.transferFrom(publicContract.ownerOf(_bunnyId), msg.sender, _bunnyId); 
482         
483         sendMoneyMother(_bunnyId);
484 
485         stopMarket(_bunnyId);
486 
487         changeReallyPrice();
488         lastOwner = msg.sender; 
489         lastSaleTime = block.timestamp; 
490 
491         emit BunnyBuy(_bunnyId, lastmoney);
492     } 
493      
494     function sendMoneyMother(uint32 _bunnyId) internal {
495         if (bunnyCost[_bunnyId] > 0) { 
496             uint procentOne = (bunnyCost[_bunnyId].div(100)); 
497             // commission_mom
498             uint32[5] memory mother;
499             mother = publicContract.getRabbitMother(_bunnyId);
500 
501             uint motherCount = publicContract.getRabbitMotherSumm(_bunnyId);
502             if (motherCount > 0) {
503                 uint motherMoney = (procentOne*commission_mom).div(motherCount);
504                     for (uint m = 0; m < 5; m++) {
505                         if (mother[m] != 0) {
506                             publicContract.ownerOf(mother[m]).transfer(motherMoney);
507                             emit MotherMoney(mother[m], _bunnyId, motherMoney);
508                         }
509                     }
510                 } 
511         }
512     }
513 
514 
515     /**
516     * @param _to to whom money is sent
517     * @param _money the amount of money is being distributed at the moment
518      */
519     function sendMoney(address _to, uint256 _money) internal { 
520         if (_money > 0) { 
521             uint procentOne = (_money/100); 
522             _to.transfer(procentOne * (100-(commission+percentBank+commission_mom)));
523             addBank(procentOne*percentBank);
524             ownerMoney.transfer(procentOne*commission);  
525         }
526     }
527 
528 
529 
530     function checkTimeWin() internal {
531         if (lastSaleTime + stepTimeBank < block.timestamp) {
532             win(); 
533         }
534         lastSaleTime = block.timestamp;
535     }
536     function win() internal {
537         // ####### WIN ##############
538         // send money
539         if (address(this).balance > 0 && address(this).balance >= bankMoney && lastOwner != address(0)) { 
540             advertising = "";
541             added_to_the_bank = 0;
542             reallyPrice = minPrice;
543             lastOwner.transfer(bankMoney);
544             numberOfWins = numberOfWins.add(1); 
545             emit Tournament (lastOwner, bankMoney, lastSaleTime, block.timestamp);
546             bankMoney = 0;
547         }
548     }    
549     
550         /**
551     * @dev add money of bank
552     */
553     function addBank(uint _money) internal { 
554         bankMoney = bankMoney.add(_money);
555         added_to_the_bank = added_to_the_bank.add(1);
556 
557         emit AddBank(bankMoney, added_to_the_bank, lastOwner, block.timestamp, stepTimeBank);
558 
559     }  
560      
561  
562     function ownerOf(uint32 _bunnyId) public  view returns(address) {
563         return publicContract.ownerOf(_bunnyId);
564     } 
565     
566     /**
567     * Check
568      */
569     function checkContract() public view returns(bool) {
570         return publicContract.isUIntPublic(); 
571     }
572 
573     function buyAdvert(string _text)  public payable { 
574         require(msg.value > (reallyPrice*2));
575         require(checkContract());
576         advertising = _text;
577         addBank(msg.value); 
578     }
579  
580     /**
581     * Only if the user has violated the advertising rules
582      */
583     function noAdvert() public onlyWhitelisted {
584         advertising = "";
585     } 
586  
587     /**
588     * Only unforeseen situations
589      */
590     function getMoney(uint _value) public onlyOwner {
591         require(address(this).balance >= _value); 
592         ownerMoney.transfer(_value);
593         // for public, no scam
594         getMoneyCount = getMoneyCount.add(_value);
595     }
596 }