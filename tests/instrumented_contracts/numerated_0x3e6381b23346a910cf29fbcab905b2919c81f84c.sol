1 pragma solidity ^0.4.25;
2 /**
3 *
4 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
5 * Web site         - https://two4ever.club
6 * Telegram_chat - https://t.me/two4everClub
7 * Twitter          - https://twitter.com/ClubTwo4ever
8 * Youtube          - https://www.youtube.com/channel/UCl4-t8RS3-kEJIGQN6Xbtng
9 * Email:           - mailto:admin(at sign)two4ever.club  
10 * 
11 * --- Contract configuration:
12 *   - Daily payment of a deposit of 2%
13 *   - Minimal contribution 0.01 eth
14 *   - Currency and payment - ETH
15 *   - Contribution allocation schemes:
16 *       -- 5% Referral program (3% first level, 2% second level)
17 *       -- 7% Advertising
18 *       -- 5% Operating Expenses
19         -- 83% dividend payments
20 * 
21 * --- Referral Program:
22 *   - We have 2 level referral program.
23 *   - After your referral investment you will receive 3% of his investment 
24 *   as one time bonus from 1 level and 2% form his referrals.
25 *   - To become your referral, you future referral should specify your address
26 *   in field DATA, while transferring ETH.
27 *   - When making the every deposit, the referral must indicate your wallet in the data field!
28 *   - You must have a deposit in the contract, otherwise the person invited by you will not be assigned to you
29 *
30 * --- Awards:   
31 *   - The Best Investor
32 *       Largest investor becomes common referrer for investors without referrer 
33 *       and get a lump sum of 3% of their deposits. To become winner you must invest
34 *       more than previous winner.
35 * 
36 *   - The Best Promoter
37 *       Investor with the most referrals becomes common referrer for investors without referrer
38 *       and get a lump sum of 2% of their deposits. To become winner you must invite more than
39 *       previous winner.
40 *
41 * --- About the Project:
42 *   ETH cryptocurrency distribution project
43 *   Blockchain-enabled smart contracts have opened a new era of trustless relationships without intermediaries.
44 *   This technology opens incredible financial possibilities. Our automated investment distribution model
45 *   is written into a smart contract, uploaded to the Ethereum blockchain and can be freely accessed online.
46 *   In order to insure our investors' complete secuirty, full control over the project has been transferred
47 *   from the organizers to the smart contract: nobody can influence the system's permanent autonomous functioning.
48 * 
49 * --- How to invest:
50 *  1. Send from ETH wallet to the smart contract address any amount from 0.01 ETH.
51 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
52 *     of your wallet.
53 * --- How to get dividends:
54 *     Send 0 air to the address of the contract. Be careful. You can get your dividends only once every 24 hours.
55 *  
56 * --- RECOMMENDED GAS PRICE: https://ethgasstation.info/
57 *     You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
58 *
59 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
60 * have private keys.
61 * 
62 * Contracts reviewed and approved by pros!
63 * 
64 * Main contract - Two4ever. You can view the contract code by scrolling down.
65 */
66 contract Storage {
67 // define investor model   
68     struct investor {
69         uint keyIndex;
70         uint value;
71         uint paymentTime;
72         uint refs;
73         uint refBonus;
74     }
75     // define bestAddress model for bestInvestor and bestPromoter
76     struct bestAddress {
77         uint value;
78         address addr;
79     }
80     // statistic model
81     struct recordStats {
82         uint strg;
83         uint invested;
84     }
85   
86     struct Data {
87         mapping(uint => recordStats) stats;
88         mapping(address => investor) investors;
89         address[] keys;
90         bestAddress bestInvestor;
91         bestAddress bestPromoter;
92     }
93 
94     Data private d;
95 
96     // define log event when change value of  "bestInvestor" or "bestPromoter" changed
97     event LogBestInvestorChanged(address indexed addr, uint when, uint invested);
98     event LogBestPromoterChanged(address indexed addr, uint when, uint refs);
99 
100     //creating contract 
101     constructor() public {
102         d.keys.length++;
103     }
104     //insert new investor  
105     function insert(address addr, uint value) public  returns (bool) {
106         uint keyIndex = d.investors[addr].keyIndex;
107         if (keyIndex != 0) return false;
108         d.investors[addr].value = value;
109         keyIndex = d.keys.length++;
110         d.investors[addr].keyIndex = keyIndex;
111         d.keys[keyIndex] = addr;
112         updateBestInvestor(addr, d.investors[addr].value);
113     
114         return true;
115     }
116     // get full information about investor by "addr"
117     function investorFullInfo(address addr) public view returns(uint, uint, uint, uint, uint) {
118         return (
119         d.investors[addr].keyIndex,
120         d.investors[addr].value,
121         d.investors[addr].paymentTime,
122         d.investors[addr].refs,
123         d.investors[addr].refBonus
124         );
125     }
126     // get base information about investor by "addr"
127     function investorBaseInfo(address addr) public view returns(uint, uint, uint, uint) {
128         return (
129         d.investors[addr].value,
130         d.investors[addr].paymentTime,
131         d.investors[addr].refs,
132         d.investors[addr].refBonus
133         );
134     }
135     // get short information about investor by "addr"
136     function investorShortInfo(address addr) public view returns(uint, uint) {
137         return (
138         d.investors[addr].value,
139         d.investors[addr].refBonus
140         );
141     }
142     // get current  Best Investor 
143     function getBestInvestor() public view returns(uint, address) {
144         return (
145         d.bestInvestor.value,
146         d.bestInvestor.addr
147         );
148     }
149 
150     // get current  Best Promoter 
151     function getBestPromoter() public view returns(uint, address) {
152         return (
153         d.bestPromoter.value,
154         d.bestPromoter.addr
155         );
156     }
157 
158     // add referral bonus to address 
159     function addRefBonus(address addr, uint refBonus) public  returns (bool) {
160         if (d.investors[addr].keyIndex == 0) return false;
161         d.investors[addr].refBonus += refBonus;
162         return true;
163     }
164 
165     // add referral bonus to address  and update current Best Promoter value
166     function addRefBonusWithRefs(address addr, uint refBonus) public  returns (bool) {
167         if (d.investors[addr].keyIndex == 0) return false;
168         d.investors[addr].refBonus += refBonus;
169         d.investors[addr].refs++;
170         updateBestPromoter(addr, d.investors[addr].refs);
171         return true;
172     }
173 
174     //add  amount of invest by the address of  investor 
175     function addValue(address addr, uint value) public  returns (bool) {
176         if (d.investors[addr].keyIndex == 0) return false;
177         d.investors[addr].value += value;
178         updateBestInvestor(addr, d.investors[addr].value);
179         return true;
180     }
181 
182     // update statistics
183     function updateStats(uint dt, uint invested, uint strg) public {
184         d.stats[dt].invested += invested;
185         d.stats[dt].strg += strg;
186     }
187 
188     // get current statistics
189     function stats(uint dt) public view returns (uint invested, uint strg) {
190         return ( 
191         d.stats[dt].invested,
192         d.stats[dt].strg
193         );
194     }
195 
196     // update current "Best Investor"
197     function updateBestInvestor(address addr, uint investorValue) internal {
198         if(investorValue > d.bestInvestor.value){
199             d.bestInvestor.value = investorValue;
200             d.bestInvestor.addr = addr;
201             emit LogBestInvestorChanged(addr, now, d.bestInvestor.value);
202         }      
203     }
204 
205     // update value of current "Best Promoter"
206     function updateBestPromoter(address addr, uint investorRefs) internal {
207         if(investorRefs > d.bestPromoter.value){
208             d.bestPromoter.value = investorRefs;
209             d.bestPromoter.addr = addr;
210             emit LogBestPromoterChanged(addr, now, d.bestPromoter.value);
211         }      
212     }
213 
214     // set time of payment 
215     function setPaymentTime(address addr, uint paymentTime) public  returns (bool) {
216         if (d.investors[addr].keyIndex == 0) return false;
217         d.investors[addr].paymentTime = paymentTime;
218         return true;
219     }
220 
221     // set referral bonus
222     function setRefBonus(address addr, uint refBonus) public  returns (bool) {
223         if (d.investors[addr].keyIndex == 0) return false;
224         d.investors[addr].refBonus = refBonus;
225         return true;
226     }
227 
228     // check if contains such address in storage
229     function contains(address addr) public view returns (bool) {
230         return d.investors[addr].keyIndex > 0;
231     }
232 
233     // return current number of investors
234     function size() public view returns (uint) {
235         return d.keys.length;
236     }
237 }
238 //contract for restricting access to special functionality
239 contract Accessibility {
240 
241     address public owner;
242     //access modifier
243     modifier onlyOwner() {
244         require(msg.sender == owner, "access denied");
245         _;
246     }
247     //constructor with assignment of contract holder value
248     constructor() public {
249         owner = msg.sender;
250     }
251     // deletion of contract holder
252     function waiver() internal {
253         delete owner;
254     }
255 }
256 
257 //main contract
258 contract Two4ever is Accessibility  {
259     //connecting needed libraries
260     using Helper for *;
261     using Math for *;
262     // define internal model of percents
263     struct percent {
264         uint val;
265         uint den;
266     }
267   // contract name
268     string public  name;
269   // define storage
270     Storage private strg;
271   // collection of key value pairs ffor referrals
272     mapping(address => address) private referrals;
273   //variable for admin address
274     address public adminAddr;
275   //variable for  advertise address
276     address public advertiseAddr;
277   // time  when start current wave
278     uint public waveStartup;
279 
280     uint public totalInvestors;
281     uint public totalInvested;
282   // define constants
283   //size of minimal investing
284     uint public constant minInvesment = 10 finney; // 0.01 eth
285   //max size of balance 
286     uint public constant maxBalance = 100000 ether; 
287   // time period when dividends can be accrued
288     uint public constant dividendsPeriod = 24 hours; //24 hours
289 
290   // define contracts percents 
291     // percent of main dividends 
292     percent private dividends;
293     // percent of admin interest 
294     percent private adminInterest ;
295    // percent of 1-st level referral 
296     percent private ref1Bonus ;
297    // percent of 2-nd level referral 
298     percent private ref2Bonus ;
299    // percent of advertising interest 
300     percent private advertisePersent ;
301     // event call when Balance has Changed
302     event LogBalanceChanged(uint when, uint balance);
303 
304   // custom modifier for  event broadcasting
305     modifier balanceChanged {
306         _;
307         emit LogBalanceChanged(now, address(this).balance);
308     }
309     // constructor
310     // creating  contract. This function call once when contract is publishing.
311     constructor()  public {
312         name = "two4ever.club";
313       // set admin address by account address who  has published
314         adminAddr = msg.sender;
315         advertiseAddr = msg.sender;
316     //define value of main percents
317         dividends = percent(2, 100); //  2%
318         adminInterest = percent(5, 100); //  5%
319         ref1Bonus = percent(3, 100); //  3%
320         ref2Bonus = percent(2, 100); //  2%
321         advertisePersent = percent(7, 100); //  7% 
322     // start new wave 
323         startNewWave();
324     }
325     // set the value of the wallet address for advertising expenses
326     function setAdvertisingAddress(address addr) public onlyOwner {
327         if(addr.notEmptyAddr())
328         {
329             advertiseAddr = addr;
330         }
331     }
332     //set the value of the wallet address for operating expenses
333     function setAdminsAddress(address addr) public onlyOwner {
334         if(addr.notEmptyAddr())
335         {
336             adminAddr = addr;
337         }
338     }
339     // deletion of contract holder
340     function doWaiver() public onlyOwner {
341         waiver();
342     }
343 
344     //functions is calling when transfer money to address of this contract
345     function() public payable {
346     // investor get him dividends when send value = 0   to address of this contract
347         if (msg.value == 0) {
348             getDividends();
349             return;
350         }
351 
352     // getting referral address from data of request 
353         address a = msg.data.toAddr();
354     //call invest function
355         invest(a);
356     }
357     // private function for get dividends
358     function _getMydividends(bool withoutThrow) private {
359     // get  investor info
360         Storage.investor memory investor = getMemInvestor(msg.sender);
361     //check if investor exists
362         if(investor.keyIndex <= 0){
363             if(withoutThrow){
364                 return;
365             }
366             revert("sender is not investor");
367     }
368 
369     // calculate how many days have passed after last payment
370         uint256 daysAfter = now.sub(investor.paymentTime).div(dividendsPeriod);
371         if(daysAfter <= 0){
372             if(withoutThrow){
373                 return;
374             }
375             revert("the latest payment was earlier than dividends period");
376         }
377         assert(strg.setPaymentTime(msg.sender, now));
378 
379     // calc valaue of dividends
380         uint value = Math.div(Math.mul(dividends.val,investor.value),dividends.den) * daysAfter;
381     // add referral bonus to dividends
382         uint divid = value+ investor.refBonus; 
383     // check if enough money on balance of contract for payment
384         if (address(this).balance < divid) {
385             startNewWave();
386             return;
387         }
388   
389     // send dividends and ref bonus
390         if (investor.refBonus > 0) {
391             assert(strg.setRefBonus(msg.sender, 0));
392     //send dividends and referral bonus to investor
393             msg.sender.transfer(value+investor.refBonus);
394         } else {
395     //send dividends to investor
396             msg.sender.transfer(value);
397         }      
398     }
399     // public function for calling get dividends
400     function getDividends() public balanceChanged {
401         _getMydividends(false);
402     }
403     // function for investing money from investor
404     function invest(address ref) public payable balanceChanged {
405     //check minimum requirements
406         require(msg.value >= minInvesment, "msg.value must be >= minInvesment");
407         require(address(this).balance <= maxBalance, "the contract eth balance limit");
408     //save current money value
409         uint value = msg.value;
410     // ref system works only once for sender-referral
411         if (!referrals[msg.sender].notEmptyAddr()) {
412       //process first level of referrals
413             if (notZeroNotSender(ref) && strg.contains(ref)) {
414           //calc the reward
415                 uint reward = Math.div(Math.mul(ref1Bonus.val,value),ref1Bonus.den);
416                 assert(strg.addRefBonusWithRefs(ref, reward)); // referrer 1 bonus
417                 referrals[msg.sender] = ref;
418 
419         //process second level of referrals
420                 if (notZeroNotSender(referrals[ref]) && strg.contains(referrals[ref]) && ref != referrals[ref]) { 
421          //calc the reward
422                     reward = Math.div(Math.mul(ref2Bonus.val, value),ref2Bonus.den);
423                     assert(strg.addRefBonus(referrals[ref], reward)); // referrer 2 bonus
424                 }
425                 }else{
426          // get current Best Investor  
427                 Storage.bestAddress memory bestInvestor = getMemBestInvestor();
428         // get current Best Promoter  
429                 Storage.bestAddress memory bestPromoter = getMemBestPromoter();
430 
431                 if(notZeroNotSender(bestInvestor.addr)){
432                     assert(strg.addRefBonus(bestInvestor.addr, Math.div(Math.mul(ref1Bonus.val, value),ref1Bonus.den))); // referrer 1 bonus
433                     referrals[msg.sender] = bestInvestor.addr;
434                 }
435                 if(notZeroNotSender(bestPromoter.addr)){
436                     assert(strg.addRefBonus(bestPromoter.addr, Math.div(Math.mul(ref2Bonus.val, value),ref2Bonus.den))); // referrer 2 bonus
437                     referrals[msg.sender] = bestPromoter.addr;
438                 }
439             }
440     }
441 
442         _getMydividends(true);
443 
444     // send admins share
445         adminAddr.transfer(Math.div(Math.mul(adminInterest.val, msg.value),adminInterest.den));
446     // send advertise share 
447         advertiseAddr.transfer(Math.div(Math.mul(advertisePersent.val, msg.value),advertisePersent.den));
448     
449     // update statistics
450         if (strg.contains(msg.sender)) {
451             assert(strg.addValue(msg.sender, value));
452             strg.updateStats(now, value, 0);
453         } else {
454             assert(strg.insert(msg.sender, value));
455             strg.updateStats(now, value, 1);
456         }
457     
458         assert(strg.setPaymentTime(msg.sender, now));
459     //increase count of investments
460         totalInvestors++;
461     //increase amount of investments
462         totalInvested += msg.value;
463     }
464 /*views */
465     // show number of investors
466     function investorsNumber() public view returns(uint) {
467         return strg.size()-1;
468     // -1 because see Storage constructor where keys.length++ 
469     }
470     //show current contract balance
471     function balanceETH() public view returns(uint) {
472         return address(this).balance;
473     }
474     // show value of dividend percent
475     function DividendsPercent() public view returns(uint) {
476         return dividends.val;
477     }
478     // show value of admin percent
479     function AdminPercent() public view returns(uint) {
480         return adminInterest.val;
481     }
482      // show value of advertise persent
483     function AdvertisePersent() public view returns(uint) {
484         return advertisePersent.val;
485     }
486     // show value of referral of 1-st level percent
487     function FirstLevelReferrerPercent() public view returns(uint) {
488         return ref1Bonus.val; 
489     }
490     // show value of referral of 2-nd level percent
491     function SecondLevelReferrerPercent() public view returns(uint) {
492         return ref2Bonus.val;
493     }
494     // show value of statisctics by date
495     function statistic(uint date) public view returns(uint amount, uint user) {
496         (amount, user) = strg.stats(date);
497     }
498     // show investor info  by address
499     function investorInfo(address addr) public view returns(uint value, uint paymentTime, uint refsCount, uint refBonus, bool isReferral) {
500         (value, paymentTime, refsCount, refBonus) = strg.investorBaseInfo(addr);
501         isReferral = referrals[addr].notEmptyAddr();
502     }
503   // show best investor info
504     function bestInvestor() public view returns(uint invested, address addr) {
505         (invested, addr) = strg.getBestInvestor();
506     }
507   // show best promoter info
508     function bestPromoter() public view returns(uint refs, address addr) {
509         (refs, addr) = strg.getBestPromoter();
510     }
511   // return full investor info by address
512     function getMemInvestor(address addr) internal view returns(Storage.investor) {
513         (uint a, uint b, uint c, uint d, uint e) = strg.investorFullInfo(addr);
514         return Storage.investor(a, b, c, d, e);
515     }
516   //return best investor  info 
517     function getMemBestInvestor() internal view returns(Storage.bestAddress) {
518         (uint value, address addr) = strg.getBestInvestor();
519         return Storage.bestAddress(value, addr);
520     }
521   //return best investor promoter 
522     function getMemBestPromoter() internal view returns(Storage.bestAddress) {
523         (uint value, address addr) = strg.getBestPromoter();
524         return Storage.bestAddress(value, addr);
525     }
526     // check if address is not empty and not equal sender address
527     function notZeroNotSender(address addr) internal view returns(bool) {
528         return addr.notEmptyAddr() && addr != msg.sender;
529     }
530 
531 /**end views */
532 // start wave  
533     function startNewWave() private {
534         strg = new Storage();
535         totalInvestors = 0;
536         waveStartup = now;
537     }
538 }
539 
540 // Math library with simple arithmetical functions
541 library Math {
542     //multiplying
543     function mul(uint256 num1, uint256 num2) internal pure returns (uint256) {
544         return  num1 * num2;
545         if (num1 == 0) {
546             return 0;
547         }
548         return num1 * num2;   
549     }
550     //divide
551     function div(uint256 num1, uint256 num2) internal pure returns (uint256) {
552         uint256 result = 0;
553         require(num2 > 0); 
554         result = num1 / num2;
555         return result;
556     }
557     //subtract 
558     function sub(uint256 num1, uint256 num2) internal pure returns (uint256) {
559         require(num2 <= num1);
560         uint256 result = 0;
561         result = num1 - num2;
562         return result;
563     }
564     //add 
565     function add(uint256 num1, uint256 num2) internal pure returns (uint256) {
566         uint256 result = num1 + num2;
567         require(result >= num1);
568 
569         return result;
570     }
571     //module
572     function mod(uint256 num1, uint256 num2) internal pure returns (uint256) {
573         require(num2 != 0);
574         return num1 % num2;
575     } 
576 }
577 // Helper library with simple additional functions
578 library Helper{
579     //check if the address is not empty
580     function notEmptyAddr(address addr) internal pure returns(bool) {
581         return !(addr == address(0));
582     }
583      //check if the address is  empty
584     function isEmptyAddr(address addr) internal pure returns(bool) {
585         return addr == address(0);
586     }
587     // convert to address 
588     function toAddr(uint source) internal pure returns(address) {
589         return address(source);
590     }
591     //convert  from bytes to address
592     function toAddr(bytes source) internal pure returns(address addr) {
593         assembly { addr := mload(add(source,0x14)) }
594         return addr;
595     }
596 }