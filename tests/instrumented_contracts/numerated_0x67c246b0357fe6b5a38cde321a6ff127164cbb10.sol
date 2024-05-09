1 pragma solidity ^0.4.21;
2 
3 // WARNING. The examples used in the formulas in the comments are the right formulas. However, they are not implemented like this to prevent overflows. 
4 // The formulas in the contract do work the same as in the comments. 
5 
6 // NOTE: In part two of the contract, the DIVIDEND is explained. 
7 // The dividend has a very easy implementation
8 // the price of the token rise when bought.
9 // when it's sold, price will decrease with 50% of rate of price bought
10 // if you sell, you will sell all tokens, and you have thus to buy in at higher price
11 // make sure you hold dividend for a long time.
12 
13 contract RobinHood{
14     // Owner of this contract
15     address public owner;
16     
17     // % of dev fee (can be set to 0,1,2,3,4,5 %);
18     uint8 devFee = 5;
19     // Users who want to create their own Robin Hood tower have to pay this. Can be reset to any value.
20     uint256 public amountToCreate = 20000000000000000;
21     
22     // If this is false, you cannot use the contract. It can be opened by owner. After that, it cannot be closed anymore.
23     // If it is not open, you cannot interact with the contract.
24     bool public open = false;
25     
26     event TowerCreated(uint256 id);
27     event TowerBought(uint256 id);
28     event TowerWon(uint256 id);
29 
30     // Tower struct. 
31     struct Tower{
32         //Timer in seconds: Base time for how long the new owner of the Tower has to wait until he can pay the amount.
33         uint32 timer; 
34         // Timestamp: if this is 0, the contract does not run. If it runs it is set to the blockchain timestamp. 
35         // If Timestamp + GetTime() > Blockchain timestamp the user will be paid out  by the person who tries to buy the tower OR the user can decide to buy himself.
36         uint256 timestamp;
37         // Payout of the amount in percent. Ranges from 0 - 10000. Here 0 is 0 % and 10000 is 100%.
38         // This percentage of amount is paid to owner of tower. 
39         // The other part of amount stays in Tower and can be collected by new people.
40         // However, if the amount is larger or equal than the minPrice, the Tower will immediately change the timestamp and move on.
41         // This means that the owner of the tower does not change, and can possibly collect the amount more times, if no one buys!!
42         uint16 payout; 
43         // Price increasate, ranged again from 0-10000 (0 = 0%, 10000 = 100%), which decides how much the price increases if someone buys the tower.
44         // Ex: 5000 means that if the price is 1 ETH and if someone buys it, then the new price is 1 * (1 + 5000/10000) = 1.5 ETH.
45         uint16 priceIncrease; // priceIncrease in percent (same)
46         // Price, which can be checked to see how much the tower costs. Initially set to minPrice.
47         uint256 price;
48         // Amount which the Tower has to pay to the owner.
49         uint256 amount; 
50         // Min Price: the minimum price in wei. Is also the setting to make the contract move on if someone has been paid (if amount >= minPrice);
51         // The minimum price is 1 szabo, maximum price is 1 ether. Both are included in the range.
52         uint256 minPrice; 
53         // If you create a contract (not developer) then you are allowed to set a fee which you will get from people who buy your Tower.
54         // Ranged again from 0 -> 10000,  but the maximum value is 2500 (25%) minimum is 0 (0%).
55         // Developer is not allowed to set creatorFee.
56         uint16 creatorFee; 
57         // This is the amount, in wei, to set at which amount the time necessary to wait will reduce by half.
58         // If this is set to 0, this option is not allowed and the time delta is always the same.
59         // The minimum wait time is 5 minutes.
60         // The time to wait is calculated by: Tower.time * (Tower.amountToHalfTime / (Tower.amount + Tower.amountToHalfTime)
61         uint256 amountToHalfTime; 
62         // If someone wins, the price is reduced by this. The new price is calculated by:
63         // Tower.price = max(Tower.price * Tower.minPriceAfterWin/10000, Tower.minPrice);
64         // Again, this value is ranged from 0 (0%) to 10000 (100%), all values allowed.
65         // Note that price will always be the minimum price or higher.
66         // If this is set to 0, price will always be set back to new price.
67         // If it is set to 10000, the price will NOT change!
68         uint16 minPriceAfterWin; // also in percent. 
69         // Address of the creator of this tower. Used to pay creatorFee. Developer will not receive creatorFee because his creatorFee is automatically set to 0.
70         address creator;
71         // The current owner of this Tower. If he owns it for longer than getTime() of this Tower, he will receive his portion of the amount in the Tower.
72         address owner;
73         // You can add a quote to troll your fellow friends. Hopefully they won't buy your tower!
74         string quote;
75     }
76     
77    
78     // Mapping of all towers, indexed by ID. Starting at 0. 
79     mapping(uint256 => Tower) public Towers;
80     
81     // Take track of at what position we insert the Tower. 
82     uint256 public next_tower_index=0;
83 
84     // Check if contract is open. 
85     // If value is send and contract is not open, it is reverted and you will get it back. 
86     // Note that if contract is open it cannot be closed anymore.
87     modifier onlyOpen(){
88         if (open){
89             _;
90         }
91         else{
92             revert();
93         }
94     }
95     
96     // Check if owner or if contract is open. This works for the AddTower function so owner (developer) can already add Towers. 
97     // Note that if contract is open it cannot be closed anymore. 
98     // If value is send it will be reverted if you are not owner or the contract is not open. 
99     modifier onlyOpenOrOwner(){
100         if (open || msg.sender == owner){
101             _;
102         }
103         else{
104             revert();
105         }
106     }
107     
108     // Functions only for owner (developer)
109     // If you send something to a owner function you will get your ethers back via revert. 
110     modifier onlyOwner(){
111         if (msg.sender == owner){
112             _;
113         }
114         else{
115             revert();
116         }
117     }
118     
119     
120     // Constructor. 
121     // Setups 4 towers. 
122     function RobinHood() public{
123         // Log contract developer
124         owner = msg.sender;
125     
126         
127         
128         // FIRST tower. (ID = 0)
129         // Robin Hood has to climb a tower!
130         // 10 minutes time range!
131         // 90% payout of the amount 
132         // 30% price increase 
133         // Timer halfs at 5 ETH. This is a lot, but realize that this high value is choosen because the timer cannot shrink to fast. 
134         // At 5 ETH the limit is only 5 minutes, the minimum!
135         // Minimum price is 2 finney. 
136         // Price reduces 90% (100% - 10%) after someone has won the tower!
137         // 0% creator fee. 
138        
139        
140         AddTower(600, 9000, 3000, 5000000000000000000, 2000000000000000, 1000, 0);
141     
142     
143         // SECOND tower (ID = 1)
144         // Robin Hood has to search a house!
145         // 10 minutes tme range 
146         // 50% payout 
147         // 1.5% price increase 
148         // Timer halfs at 2.5 ETH (also a lot, but at this time then timer is minimum (5 min))
149         // Price is 4 finney
150         // Price is reduced to 4 finney if won 
151         // 0% fee 
152         
153         AddTower(600, 5000,150 , 2500000000000000000, 4000000000000000, 0, 0);
154   
155         // THIRD tower. (ID = 2)
156         // Robin Hood has to explore a forest!
157         // 1 hour time range!
158         // 50% payout of the amount 
159         // 10% price increase 
160         // Timer halfs at 1 ETH. 
161         // Minimum price is 5 finney. 
162         // Price reduces 50% (100% - 50%) after someone has won the tower!
163         // 0% creator fee. 
164         AddTower(3600, 5000, 1000, (1000000000000000000), 5000000000000000, 5000, 0);
165 
166         // FOURTH tower. (ID = 3)
167         // Robin Hood has to cross a sea to an island!
168         // 1 day time range!
169         // 75% payout of the amount 
170         // 20% price increase 
171         // Timer halfs at 2 ETH.
172         // Minimum price is 10 finney. 
173         // Price reduces 75% (100% - 25%) after someone has won the tower!
174         // 0% creator fee. 
175         AddTower(86400, 7500, 2000, (2000000000000000000), 10000000000000000, 2500, 0);
176          
177 
178   
179         // FIFTH tower (ID = 4)
180         // Robin Hood has to fly with a rocket to a nearby asteroid!
181         // 1 week time range!
182         // 75% payout of the amount 
183         // 25% price increase 
184         // Timer halfs at 2.5 ETH.
185         // Minimum price is 50 finney. 
186         // Price reduces 100% (100% - 0%) after someone has won the tower!
187         // 0% creator fee. 
188         AddTower(604800, 7500, 2500, (2500000000000000000), 50000000000000000, 0, 0);
189     }
190     
191     // Developer (owner) can open game 
192     // Open can only be set true once, can never be set false again. 
193     function OpenGame() public onlyOwner{
194         open = true;
195     }
196     
197     // Developer can change fee. 
198     // DevFee is only a simple int, so can  be 0,1,2,3,4,5 
199     // Fee has to be less or equal to 5, otherwise it is reverted. 
200     function ChangeFee(uint8 _fee) public onlyOwner{
201         require(_fee <= 5);
202         devFee = _fee;
203     }
204     
205     // Developer change amount price to add tower. 
206     function ChangeAmountPrice(uint256 _newPrice) public onlyOwner{
207         amountToCreate = _newPrice;
208     }
209     
210     // Add Tower. Only possible if you are developer OR if contract is open. 
211     // If you want to buy a tower, you have to pay amountToCreate (= wei) to developer. 
212     // The default value is 0.02 ETH.
213     // You can check the price (in wei) either on site or by reading the contract on etherscan.
214     
215     // _timer: Timer in seconds for how long someone has to wait before he wins the tower. This is constant and will not be changed. 
216     // If you set _amountToHalfTime to nonzero, getTimer will reduce less amounts (minimum 300 seconds, maximum _timer) from the formula Tower.time * (Tower.amountToHalfTime / (Tower.amount + Tower.amountToHalfTime) 
217     // _timer has to be between 300 seconds ( 5 minutes) and maximally 366 days (366*24*60*60) (which is maximally one year);
218     
219     //_payout: number between 0-10000, is a pecent: 0% = 0, 100% = 10000. Sets how much percentage of the Tower.amount is paid to Tower.owner if he wins. 
220     // The rest of the amount of that tower which stays over will be kept inside the tower, up for a new round. 
221     // If someone wins and amount is more than the minPrice, timestamp is set to the blockchain timer and new round is started without changing the owner of the Tower!
222     
223     // _priceIncrease: number between 0-10000, is a pecent: 0% = 0, 100% = 10000. Sets how much percentage the price will increase. Note that "100%" is always added. 
224     // If you set it at 5000 (which is 50%) then the total increase of price is 150%. So if someone buys tower for price at 1 ETH, the new price is then 1.5 ETH. 
225     
226     // _amountToHalfTime: number of Wei which sets how much Wei you need in order to reduce the time necessary to hold tower to win for 50%.
227     // Formula used is Tower.time * (Tower.amountToHalfTime / (Tower.amount + Tower.amountToHalfTime) to calculate the time necessary.
228     // If you set 0, then this formula is not used and Tower.time is always returned.
229     // Due to overflows the minimum amount (which is reasonable) is still 1/1000 finney. 
230     // Do not make this number extremely high. 
231     
232     // _minPrice: amount of Wei which the starting price of the Tower is. Minimum is 1/1000 finney, max is 1 ETH. 
233     // This is also the check value to see if the round moves on after someone has won. If amount >= minPrice then the timestamp will be upgraded and a new round will start
234     // Of course that is after paying the owner of this tower. The owner of the tower does not change. He can win multiple times, in theory. 
235     
236     // _minPriceAfterWin: number between 0-10000, is a pecent: 0% = 0, 100% = 10000. After someone wins, the new price of the game is calculated.
237     // This is done by doing Tower.price * (Tower.minPriceAfterWin) / 10000; 
238     // If Tower.price is now less than Tower.minPrice then the Tower.price will be set to Tower.minPrice.
239 
240     // _creatorFee: number between 0-10000, is a pecent: 0% = 0, 100% = 10000. Maximum is 2500 (25%), with 2500 included. 
241     // If you create a tower, you can set this value. If people pay the tower, then this percentage of the price is taken and is sent to you.
242     // The rest, after subtracting the dev fee, will be put into Tower.amount. 
243     
244     function AddTower(uint32 _timer, uint16 _payout, uint16 _priceIncrease, uint256 _amountToHalfTime, uint256 _minPrice, uint16 _minPriceAfterWin, uint16 _creatorFee) public payable onlyOpenOrOwner returns (uint256) {
245         require (_timer >= 300); // Need at least 5 minutes
246         require (_timer <= 31622400);
247         require (_payout >= 0 && _payout <= 10000);
248         require (_priceIncrease >= 0 && _priceIncrease <= 10000);
249         require (_minPriceAfterWin >= 0 && _minPriceAfterWin <= 10000);
250        //amount to half time can be everything, but has to be 0 OR 1000000000000 due to division rules
251         require(_amountToHalfTime == 0 || _amountToHalfTime >= 1000000000000);
252         require(_creatorFee >= 0 && _creatorFee <= 2500);
253         require(_minPrice >= (1 szabo) && _minPrice <= (1 ether));
254         if (msg.sender == owner){
255             // If owner make sure creator fee is 0.
256             _creatorFee = 0;
257             if (msg.value > 0){
258                 owner.transfer(msg.value);
259             }
260         }
261         else{
262             if (msg.value >= amountToCreate){
263                 uint256 toDiv = (mul(amountToCreate, tokenDividend))/100;
264                 uint256 left = sub(amountToCreate, toDiv);
265                 owner.transfer(left);
266                 addDividend(toDiv);
267                 processBuyAmount(amountToCreate);
268             }
269             else{
270                 revert(); // not enough ETH send.
271             }
272             uint256 diff = sub(msg.value, amountToCreate);
273             // If you send to much, you will get rest back.
274             // Might be case if amountToCreate is transferred and this is not seen. 
275             if (diff >= 0){
276                 msg.sender.transfer(diff);
277             }
278         }
279    
280         // Check latest values. 
281 
282         
283         // Create tower. 
284         var NewTower = Tower(_timer, 0, _payout, _priceIncrease, _minPrice, 0, _minPrice, _creatorFee, _amountToHalfTime, _minPriceAfterWin, msg.sender, msg.sender, "");
285         
286         // Insert this into array. 
287         Towers[next_tower_index] = NewTower;
288         
289         // Emit TowerCreated event. 
290         emit TowerCreated(next_tower_index);
291         
292         // Upgrade index for next tower.
293         next_tower_index = add(next_tower_index, 1);
294         return (next_tower_index - 1);
295     }
296     
297     // getTimer of TowerID to see how much time (in seconds) you need to win that tower. 
298     // only works if contract is open. 
299     // id = tower id (note that "first tower" has ID 0 into the mapping)
300     function getTimer(uint256 _id) public onlyOpen returns (uint256)  {
301         require(_id < next_tower_index);
302         var UsedTower = Towers[_id];
303         //unsigned long long int pr =  totalPriceHalf/((total)/1000000000000+ totalPriceHalf/1000000000000);    
304         // No half time? Return tower.
305         if (UsedTower.amountToHalfTime == 0){
306             return UsedTower.timer;
307         }
308         
309         uint256 var2 = UsedTower.amountToHalfTime;
310         uint256 var3 = add(UsedTower.amount / 1000000000000, UsedTower.amountToHalfTime / 1000000000000);
311         
312         
313        if (var2 == 0 && var3 == 0){
314            // exception, both are zero!? Weird, return timer.
315            return UsedTower.timer;
316        }
317        
318 
319        
320        uint256 target = (mul(UsedTower.timer, var2/var3 )/1000000000000);
321        
322        // Warning, if for some reason the calculation get super low, it will return 300, which is the absolute minimum.
323        //This prevents users from winning because people don't have enough time to edit gas, which would be unfair.
324        if (target < 300){
325            return 300;
326        }
327        
328        return target;
329     }
330     
331     // Internal payout function. 
332     function Payout_intern(uint256 _id) internal {
333         //payout.
334         
335         var UsedTower = Towers[_id];
336         // Calculate how much has to be paid. 
337         uint256 Paid = mul(UsedTower.amount, UsedTower.payout) / 10000;
338         
339         // Remove paid from amount. 
340         UsedTower.amount = sub(UsedTower.amount, Paid);
341         
342         // Send this Paid amount to owner. 
343         UsedTower.owner.transfer(Paid);
344         
345         // Calculate new price. 
346         uint256 newPrice = (UsedTower.price * UsedTower.minPriceAfterWin)/10000;
347         
348         // Check if lower than minPrice; if yes, set it to minPrice. 
349         if (newPrice < UsedTower.minPrice){
350             newPrice = UsedTower.minPrice;
351         }
352         
353         // Upgrade tower price. 
354         UsedTower.price = newPrice;
355         
356          // Will we move on with game?
357         if (UsedTower.amount > UsedTower.minPrice){
358             // RESTART game. OWNER STAYS SAME 
359             UsedTower.timestamp = block.timestamp;
360         }
361         else{
362             // amount too low. do not restart.
363             UsedTower.timestamp = 0;
364         }
365     
366         // Emit TowerWon event. 
367         emit TowerWon(_id);
368     }
369     
370     
371     // TakePrize, can be called by everyone if contract is open.
372     // Usually owner of tower can call this. 
373     // Note that if you are too late because someone else paid it, then this person will pay you. 
374     // There is no way to cheat that.
375     // id = tower id. (id's start with 0, not 1!)
376     function TakePrize(uint256 _id) public onlyOpen{
377         require(_id < next_tower_index);
378         var UsedTower = Towers[_id];
379         require(UsedTower.timestamp > 0); // otherwise game has not started.
380         var Timing = getTimer(_id);
381         if (block.timestamp > (add(UsedTower.timestamp,  Timing))){
382             Payout_intern(_id);
383         }
384         else{
385             revert();
386         }
387     }
388     
389     // Shoot the previous Robin Hood! 
390     // If you want, you can also buy your own tower again. This might be used to extract leftovers into the amount. 
391     
392     // _id = tower id   (starts at 0 for first tower);
393     // _quote is optional: you can upload a quote to troll your enemies.
394     function ShootRobinHood(uint256 _id, string _quote) public payable onlyOpen{
395         require(_id < next_tower_index);
396         var UsedTower = Towers[_id];
397         var Timing = getTimer(_id);
398     
399         // Check if game has started and if we are too late. If yes, we pay out and return. 
400         if (UsedTower.timestamp != 0 && block.timestamp > (add(UsedTower.timestamp,  Timing))){
401             Payout_intern(_id);
402             // We will not buy, give tokens back. 
403             if (msg.value > 0){
404                 msg.sender.transfer(msg.value);
405             }
406             return;
407         }
408         
409         // Check if enough price. 
410         require(msg.value >= UsedTower.price);
411         // Tower can still be bought, great. 
412         
413         uint256 devFee_used = (mul( UsedTower.price, 5))/100;
414         uint256 creatorFee = (mul(UsedTower.creatorFee, UsedTower.price)) / 10000;
415         uint256 divFee = (mul(UsedTower.price,  tokenDividend)) / 100;
416         
417         // Add dividend
418         addDividend(divFee);
419         // Buy div tokens 
420         processBuyAmount(UsedTower.price);
421         
422         // Calculate what we put into amount (ToPay)
423         
424         uint256 ToPay = sub(sub(UsedTower.price, devFee_used), creatorFee);
425         
426         //Pay creator the creator fee. 
427         uint256 diff = sub(msg.value, UsedTower.price);
428         if (creatorFee != 0){
429             UsedTower.creator.transfer(creatorFee);
430         }
431         // Did you send too much? Get back difference. 
432         if (diff > 0){
433             msg.sender.transfer(diff); 
434         }
435         
436         // Pay dev. 
437         owner.transfer(devFee_used);
438         
439         // Change results. 
440         // Set timestamp to current time. 
441         UsedTower.timestamp = block.timestamp;
442         // Set you as owner 
443         UsedTower.owner = msg.sender;
444         // Set (or reset) quote 
445         UsedTower.quote = _quote;
446         // Add ToPay to amount, which you can earn if you win. 
447         UsedTower.amount = add(UsedTower.amount, sub(ToPay, divFee));
448         // Upgrade price of tower
449         UsedTower.price = (UsedTower.price * (10000 + UsedTower.priceIncrease)) / 10000;
450         
451         // Emit TowerBought event 
452         emit TowerBought(_id);
453     }
454     
455 
456     
457     
458     
459     
460     // Not interesting, safe math functions
461     
462     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
463       if (a == 0) {
464          return 0;
465       }
466       uint256 c = a * b;
467       assert(c / a == b);
468       return c;
469    }
470 
471    function div(uint256 a, uint256 b) internal pure returns (uint256) {
472       // assert(b > 0); // Solidity automatically throws when dividing by 0
473       uint256 c = a / b;
474       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
475       return c;
476    }
477 
478    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
479       assert(b <= a);
480       return a - b;
481    }
482 
483    function add(uint256 a, uint256 b) internal pure returns (uint256) {
484       uint256 c = a + b;
485       assert(c >= a);
486       return c;
487    }
488     
489     
490     // START OF DIVIDEND PART
491 
492 
493     // total number of tokens
494     uint256 public numTokens;
495     // amount of dividend in pool 
496     uint256 public ethDividendAmount;
497     // 15 szabo start price per token 
498     uint256 constant public tokenStartPrice = 1000000000000;
499     // 1 szabo increase per token 
500     uint256 constant public tokenIncrease = 100000000000;
501     
502     // token price tracker. 
503     uint256 public tokenPrice = tokenStartPrice;
504     
505     // percentage token dividend 
506     uint8 constant public tokenDividend = 5;
507     
508     // token scale factor to make sure math is correct.
509     uint256 constant public tokenScaleFactor = 1000;
510     
511     // address link to how much token that address has 
512     mapping(address => uint256) public tokensPerAddress;
513     //mapping(address => uint256) public payments;
514     
515     
516     // add dividend to pool
517     function addDividend(uint256 amt) internal {
518         ethDividendAmount = ethDividendAmount + amt;
519     }
520     
521     // get how much tokens you get for amount 
522     // bah area calculation results in a quadratic equation
523     // i hate square roots in solidity
524     function getNumTokens(uint256 amt) internal  returns (uint256){
525         uint256 a = tokenIncrease;
526         uint256 b = 2*tokenPrice - tokenIncrease;
527       //  var c = -2*amt;
528         uint256 D = b*b + 8*a*amt;
529         uint256 sqrtD = tokenScaleFactor*sqrt(D);
530         //uint256 (sqrtD - b) / (2*a);
531         return (sqrtD - (b * tokenScaleFactor)) / (2*a);
532     }
533     
534     // buy tokens, only being called from robinhood. 
535     function processBuyAmount(uint256 amt) internal {
536         uint256 tokens = getNumTokens(amt );
537         tokensPerAddress[msg.sender] = add(tokensPerAddress[msg.sender], tokens);
538 
539         
540         numTokens = add(numTokens, tokens);
541         //uint256 tokens_normscale = tokens;
542         //pushuint(tokens);
543         
544         // check new price.
545         
546         //tokenPrice = tokenPrice + (( (tokens * tokens ) + tokens) / 2) * tokenIncrease;
547         
548        tokenPrice = add(tokenPrice , ((mul(tokenIncrease, tokens))/tokenScaleFactor));
549 
550     }
551     
552     // sell ALL your tokens to claim your dividend 
553     function sellTokens() public {
554         uint256 tokens = tokensPerAddress[msg.sender];
555         if (tokens > 0 && numTokens >= tokens){
556             // get amount of tokens: 
557             uint256 usetk = numTokens;
558             uint256 amt = 0;
559             if (numTokens > 0){
560              amt = (mul(tokens, ethDividendAmount))/numTokens ;
561             }
562             if (numTokens < tokens){
563                 usetk = tokens;
564             }
565             
566             // update price. 
567             
568             uint256 nPrice = (sub(tokenPrice, ((mul(tokenIncrease, tokens))/ (2*tokenScaleFactor)))) ;
569             
570             if (nPrice < tokenStartPrice){
571                 nPrice = tokenStartPrice;
572             }
573             tokenPrice = nPrice; 
574             
575             // update tokens 
576             
577             tokensPerAddress[msg.sender] = 0; 
578             
579             // update total tokens 
580             
581             if (tokens <= numTokens){
582                 numTokens = numTokens - tokens; 
583             }
584             else{
585                 numTokens = 0;
586             }
587             
588             
589             // update dividend 
590             
591             if (amt <= ethDividendAmount){
592                 ethDividendAmount = ethDividendAmount - amt;
593             }
594             else{
595                 ethDividendAmount = 0;
596             }
597             
598             // pay 
599             
600             if (amt > 0){
601                 msg.sender.transfer(amt);
602             }
603         }
604     }
605     
606     // square root function, taken from ethereum stack exchange 
607     function sqrt(uint x) internal returns (uint y) {
608     uint z = (x + 1) / 2;
609     y = x;
610         while (z < y) {
611             y = z;
612             z = (x / z + z) / 2;
613         }
614     }
615 
616     
617 }