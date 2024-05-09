1 pragma solidity ^0.4.16;
2 
3 contract Owned {
4     
5     address public owner;
6     mapping(address => bool) public owners;
7 
8     function Owned() public {
9         owner = msg.sender;
10         owners[msg.sender] = true;
11     }
12 
13     modifier onlyOwners{
14         address sen = msg.sender;
15         require(owners[msg.sender] == true);
16         _;
17     }
18 
19     modifier onlyOwner{
20         require(msg.sender == owner);
21         _;
22     }
23 
24     modifier onlyOwnerOrigin{
25         require(tx.origin == owner);
26         _;
27     }
28 
29     function addOwner(address newOwner) public onlyOwners{
30         owners[newOwner] = true;
31     }
32 
33     function removeOwner() public onlyOwners{
34         owners[msg.sender] = false;
35     }
36 
37     function removeOwner(address newOwner) public onlyOwner{
38         owners[newOwner] = false;
39     }
40 
41     function isOwner(address o) public view returns(bool){
42         return owners[o] == true;
43     }
44 }
45 
46 //Can be used by other contracts to get approval to spend tokens
47 interface TokenRecipient {
48     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
49 }
50 
51 
52 contract TokenERC20 is Owned {
53 
54     string public name;
55     string public symbol;
56     uint8 public decimals;
57     uint256 public totalSupply;
58     mapping(address => uint256) public balanceOf;
59     mapping(address => mapping(address => uint256)) public allowance;
60 
61     // This generates a public event on the blockchain that will notify clients
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
64 
65     event Burn(address indexed from, uint256 value);
66 
67     function TokenERC20(uint256 initialSupply,
68 		string tokenName,
69 		string tokenSymbol,
70 		uint8 dec) public {
71         // totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
72         totalSupply = initialSupply; // Update total supply with the decimal amount
73         balanceOf[this] = totalSupply; // Give the creator all initial tokens
74         name = tokenName; // Set the name for display purposes
75         symbol = tokenSymbol; // Set the symbol for display purposes
76         decimals = dec;
77     }
78 
79 
80     function transfer(address _from, address _to, uint _value) internal {
81         // Prevent transfer to 0x0 address. Use burn() instead
82         require(_to != 0x0);
83         // Check if the sender has enough
84         require(balanceOf[_from] >= _value);
85         // Check for overflows
86         require(balanceOf[_to] + _value > balanceOf[_to]);
87         // Save this for an assertion in the future
88         uint previousBalances = balanceOf[_from] + balanceOf[_to];
89         // Subtract from the sender
90         balanceOf[_from] -= _value;
91         // Add the same to the recipient
92         balanceOf[_to] += _value;
93         Transfer(_from, _to, _value);
94         // Asserts are used to use static analysis to find bugs in your code. They should never fail
95         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
96     }
97 
98     function transfer(address _to, uint256 _value) public {
99         transfer(msg.sender, _to, _value);
100     }
101 
102     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
103         require(_value <= allowance[_from][msg.sender]); // Check allowance
104         allowance[_from][msg.sender] -= _value;
105         transfer(_from, _to, _value);
106         return true;
107     }
108 
109     function approve(address _spender, uint256 _value) public returns(bool success){
110         allowance[msg.sender][_spender] = _value;
111         Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public
116 	returns(bool success){
117         TokenRecipient spender = TokenRecipient(_spender);
118         if (approve(_spender, _value)) {
119             spender.receiveApproval(msg.sender, _value, this, _extraData);
120             return true;
121         }
122     }
123 
124     function burn(uint256 _value) public returns(bool success){
125         require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
126         balanceOf[msg.sender] -= _value; // Subtract from the sender
127         totalSupply -= _value; // Updates totalSupply
128         Burn(msg.sender, _value);
129         return true;
130     }
131 
132     function burnFrom(address _from, uint256 _value) public returns(bool success){
133         require(balanceOf[_from] >= _value); // Check if the targeted balance is enough
134         require(_value <= allowance[_from][msg.sender]); // Check allowance
135         balanceOf[_from] -= _value; // Subtract from the targeted balance
136         allowance[_from][msg.sender] -= _value; // Subtract from the sender's allowance
137         totalSupply -= _value; // Update totalSupply
138         Burn(_from, _value);
139         return true;
140     }
141 }
142 
143 
144 contract MifflinToken is Owned, TokenERC20 {
145     
146     uint8 public tokenId;
147     uint256 ethDolRate = 1000;
148     uint256 weiRate = 1000000000000000000;
149     address exchange;
150     uint256 public buyPrice;
151     uint256 public totalContribution = 0;
152     uint256 public highestContribution = 0;
153     uint256 public lowestContribution = 2 ** 256 - 1;
154     uint256 public totalBought = 0;
155     mapping(address => bool) public frozenAccount;
156 
157     /* This generates a public event on the blockchain that will notify clients */
158     event FrozenFunds(address target, bool frozen);
159 
160     function MifflinToken(address exad,
161 		uint8 tid,
162 		uint256 issue,
163 		string tokenName,
164 		string tokenSymbol,
165 		uint8 dec)
166 		TokenERC20(issue * 10 ** uint256(dec), tokenName, tokenSymbol, dec) public {
167         tokenId = tid;
168         MifflinMarket e = MifflinMarket(exad);
169         e.setToken(tokenId,this);
170         exchange = exad;
171         addOwner(exchange);
172     }
173 
174     function buy(uint _value) internal {
175         transfer(this, msg.sender, _value);
176         totalBought += _value;
177     }
178 
179     function transfer(address _from, address _to, uint _value) internal {
180         require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
181         require(balanceOf[_from] >= _value); // Check if the sender has enough
182         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
183         require(!frozenAccount[_from]); // Check if sender is frozen
184         require(!frozenAccount[_to]); // Check if recipient is frozen
185         balanceOf[_from] -= _value; // Subtract from the sender
186         balanceOf[_to] += _value; // Add the same to the recipient
187         Transfer(_from, _to, _value);
188     }
189 
190     // public methods to give and take that only owners can call
191     function give(address _to, uint256 _value) public onlyOwners returns(bool success){
192         transfer(this, _to, _value);
193         return true;
194     }
195 
196     function take(address _from, uint256 _value) public onlyOwners returns(bool success){
197         transfer(_from, this, _value);
198         return true;
199     }
200 
201     // / @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
202     // / @param target Address to be frozen
203     // / @param freeze either to freeze it or not
204     function freezeAccount(address target, bool freeze) public onlyOwners{
205         frozenAccount[target] = freeze;
206         FrozenFunds(target, freeze);
207     }
208 
209     // / @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
210     // / @param newBuyPrice Price users can buy from the contract
211     function setBuyPrice(uint256 newBuyPrice) public onlyOwners{
212         buyPrice = newBuyPrice;
213     }
214 
215     // RULE we always lower the price any time there is a new high contribution!
216     function contribution(uint256 amount)internal returns(int highlow){
217         owner.transfer(msg.value);
218         totalContribution += msg.value;
219         if (amount > highestContribution) {
220             uint256 oneper = buyPrice * 99 / 100; // lower by 1%*
221             uint256 fullper = buyPrice *  highestContribution / amount; // lower by how much you beat the prior contribution
222             if(fullper > oneper) buyPrice = fullper;
223             else buyPrice = oneper;
224             highestContribution = amount;
225             // give reward
226             MifflinMarket(exchange).highContributionAward(msg.sender);
227             return 1;
228         } else if(amount < lowestContribution){
229             MifflinMarket(exchange).lowContributionAward(msg.sender);
230             lowestContribution = amount;
231             return -1;
232         } else return 0;
233     }
234 
235     // sell tokens back to sender using owners ether
236     function sell(uint256 amount) public {
237         transfer(msg.sender, this, amount); // makes the transfers
238     }
239 }
240 
241 
242 /******************************************/
243 /*       CUSTOM MIFFLIN TOKENS       */
244 /******************************************/
245 
246 contract BeetBuck is Owned, MifflinToken {
247     function BeetBuck(address exchange)MifflinToken(exchange, 2, 2000000, "Beet Buck", "BEET", 8) public {
248         buyPrice = weiRate / ethDolRate / uint(10) ** decimals; // 1d
249     }
250 
251     function () payable public {
252         contribution(msg.value);
253         uint256 amountToGive = 0;
254         uint256 price = buyPrice;
255         if (totalBought < 10000) {
256             price -= price * 15 / 100;
257         } else if (totalBought < 50000) {
258             price -= price / 10;
259         } else if (totalBought < 100000) {
260             price -= price / 20;
261         } else if (totalBought < 200000) {
262             price -= price / 100;
263         }
264         amountToGive += msg.value / price;
265         buy(amountToGive);
266     }
267 }
268 
269 
270 contract NapNickel is Owned, MifflinToken {
271 
272     function NapNickel(address exchange)
273 	MifflinToken(exchange, 3, 1000000000, "Nap Nickel", "NAPP", 8) public {
274         buyPrice = weiRate / ethDolRate /  uint(10) ** decimals / 20; // 5c
275     }
276 
277     function () payable public {
278         contribution(msg.value);
279         uint256 price = buyPrice;
280         uint256 estTime = block.timestamp - 5 * 60 * 60;
281         uint8 month;
282         uint8 day;
283         uint8 hour;
284         uint8 weekday;
285         (, month,day,hour,,,weekday) = parseTimestampParts(estTime);
286         if (month == 4 && day == 26) {
287             // its pretzel day
288             price += buyPrice / 5;
289         } else if (weekday == 0 || weekday == 6) {
290             // buying during weekend, get off my property
291             price += buyPrice * 15 / 100;
292         } else if (hour < 9 || hour >= 17) {
293             // buying outside of work hours, im in my hot tub
294             price += buyPrice / 10;
295         } else if (hour > 12 && hour < 13) {
296             // buying during lunch, leave me alone dammit
297             price += buyPrice / 20;
298         }
299         uint256 amountToGive = 0;
300         amountToGive += msg.value / price;
301         buy(amountToGive);
302     }
303     
304     struct _DateTime {
305                 uint16 year;
306                 uint8 month;
307                 uint8 day;
308                 uint8 hour;
309                 uint8 minute;
310                 uint8 second;
311                 uint8 weekday;
312         }
313 
314         uint constant DAY_IN_SECONDS = 86400;
315         uint constant YEAR_IN_SECONDS = 31536000;
316         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
317 
318         uint constant HOUR_IN_SECONDS = 3600;
319         uint constant MINUTE_IN_SECONDS = 60;
320 
321         uint16 constant ORIGIN_YEAR = 1970;
322 
323         function isLeapYear(uint16 year) public pure returns (bool) {
324                 if (year % 4 != 0) {
325                         return false;
326                 }
327                 if (year % 100 != 0) {
328                         return true;
329                 }
330                 if (year % 400 != 0) {
331                         return false;
332                 }
333                 return true;
334         }
335 
336         function leapYearsBefore(uint year) public pure returns (uint) {
337                 year -= 1;
338                 return year / 4 - year / 100 + year / 400;
339         }
340 
341         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
342                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
343                         return 31;
344                 }
345                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
346                         return 30;
347                 }
348                 else if (isLeapYear(year)) {
349                         return 29;
350                 }
351                 else {
352                         return 28;
353                 }
354         }
355         
356         function parseTimestampParts(uint timestamp) public pure returns (uint16 year,uint8 month,uint8 day, uint8 hour,uint8 minute,uint8 second,uint8 weekday) {
357             _DateTime memory dt = parseTimestamp(timestamp);
358             return (dt.year,dt.month,dt.day,dt.hour,dt.minute,dt.second,dt.weekday);
359         }
360 
361 
362         function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
363                 uint secondsAccountedFor = 0;
364                 uint buf;
365                 uint8 i;
366 
367                 // Year
368                 dt.year = getYear(timestamp);
369                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
370 
371                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
372                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
373 
374                 // Month
375                 uint secondsInMonth;
376                 for (i = 1; i <= 12; i++) {
377                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
378                         if (secondsInMonth + secondsAccountedFor > timestamp) {
379                                 dt.month = i;
380                                 break;
381                         }
382                         secondsAccountedFor += secondsInMonth;
383                 }
384 
385                 // Day
386                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
387                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
388                                 dt.day = i;
389                                 break;
390                         }
391                         secondsAccountedFor += DAY_IN_SECONDS;
392                 }
393 
394                 // Hour
395                 dt.hour = getHour(timestamp);
396 
397                 // Minute
398                 dt.minute = getMinute(timestamp);
399 
400                 // Second
401                 dt.second = getSecond(timestamp);
402 
403                 // Day of week.
404                 dt.weekday = getWeekday(timestamp);
405         }
406 
407         function getYear(uint timestamp) public pure returns (uint16) {
408                 uint secondsAccountedFor = 0;
409                 uint16 year;
410                 uint numLeapYears;
411 
412                 // Year
413                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
414                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
415 
416                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
417                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
418 
419                 while (secondsAccountedFor > timestamp) {
420                         if (isLeapYear(uint16(year - 1))) {
421                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
422                         }
423                         else {
424                                 secondsAccountedFor -= YEAR_IN_SECONDS;
425                         }
426                         year -= 1;
427                 }
428                 return year;
429         }
430 
431         function getMonth(uint timestamp) public pure returns (uint8) {
432                 return parseTimestamp(timestamp).month;
433         }
434 
435         function getDay(uint timestamp) public pure returns (uint8) {
436                 return parseTimestamp(timestamp).day;
437         }
438 
439         function getHour(uint timestamp) public pure returns (uint8) {
440                 return uint8((timestamp / 60 / 60) % 24);
441         }
442 
443         function getMinute(uint timestamp) public pure returns (uint8) {
444                 return uint8((timestamp / 60) % 60);
445         }
446 
447         function getSecond(uint timestamp) public pure returns (uint8) {
448                 return uint8(timestamp % 60);
449         }
450 
451         function getWeekday(uint timestamp) public pure returns (uint8) {
452                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
453         }
454 
455 }
456 
457 
458 contract QuabityQuarter is Owned, MifflinToken {
459     uint lastContributionTime = 0;
460 
461     function QuabityQuarter(address exchange)
462 	MifflinToken(exchange, 4, 420000000, "Quabity Quarter", "QUAB", 8) public {
463         buyPrice = weiRate / ethDolRate / uint(10) ** decimals / 4; // 25c
464     }
465 
466     function () payable public {
467         contribution(msg.value);
468         uint256 amountToGive = 0;
469         amountToGive += msg.value / buyPrice;
470         uint256 time = block.timestamp;
471         uint256 diff = time - lastContributionTime / 60 / 60;
472         uint256 chance = 0;
473         if (diff > 96)
474 			chance = 50;
475         if (diff > 48)
476 			chance = 40;
477         else if (diff > 24)
478 			chance = 30;
479         else if (diff > 12)
480 			chance = 20;
481         else if (diff > 1)
482 			chance = 10;
483         else chance = 5;
484         if (chance > 0) {
485             uint256 lastBlockHash = uint256(keccak256(block.blockhash(block.number - 1), uint8(0)));
486             if (lastBlockHash % 100 < chance) {
487                 // stole 10% extra!
488                 amountToGive += amountToGive / 10;
489             }}
490         buy(amountToGive);
491     }
492 }
493 
494 
495 contract KelevinKoin is Owned, MifflinToken {
496     
497     function KelevinKoin(address exchange)
498 	MifflinToken(exchange, 5, 69000000, "Kelevin Koin", "KLEV", 8) public {
499         buyPrice = weiRate / ethDolRate / uint(10) ** decimals / 50; // 2c
500     }
501 
502     function () payable public {
503         contribution(msg.value);
504         // have to balance the books!
505         uint256 lastBlockHash = uint256(keccak256(block.blockhash(block.number - 1), uint8(0)));
506         uint256 newPrice = buyPrice + ((lastBlockHash % (buyPrice * 69 / 1000)) - (buyPrice * 69 * 2 / 1000));
507         buyPrice = newPrice;
508         uint256 amountToGive = msg.value / buyPrice;
509         if (buyPrice % msg.value == 0)
510 			amountToGive += amountToGive * 69 / 1000; // add 6.9%
511         buy(amountToGive);
512     }
513 }
514 
515 
516 contract NnexNote is Owned, MifflinToken {
517     
518     function NnexNote(address exchange) 
519 	MifflinToken(exchange, 6, 666000000, "Nnex Note", "NNEX", 8) public {
520         buyPrice = weiRate / ethDolRate / uint(10) ** decimals / 100; // 1c
521     }
522 
523     // Do you really want a Nnex Note?
524     function () payable public {
525         // this is the only place I have human contact, so the more the better
526         contribution(msg.value);
527         // you can get up to a 50% discount
528         uint maxDiscountRange = buyPrice * 100;
529         uint discountPercent;
530         if(msg.value >= maxDiscountRange) discountPercent = 100;
531         else discountPercent = msg.value / maxDiscountRange * 100;
532         uint price = buyPrice - (buyPrice / 2) * (discountPercent / 100);
533         uint amountToGive = msg.value / price;
534         buy(amountToGive);
535     }
536 }
537 
538 
539 contract DundieDollar is Owned, MifflinToken {
540     mapping(uint8 => string) public awards;
541     uint8 public awardsCount;
542     mapping(address => mapping(uint8 => uint256)) public awardsOf;
543 
544     function DundieDollar(address exchange)
545 	MifflinToken(exchange, 1, 1725000000, "Dundie Dollar", "DUND", 0) public {
546         buyPrice = weiRate / ethDolRate * 10; // 10d
547         awards[0] = "Best Dad Award";
548         awards[1] = "Best Mom Award";
549         awards[2] = "Hottest in the Office Award";
550         awards[3] = "Diabetes Award";
551         awards[4] = "Promising Assistant Manager Award";
552         awards[5] = "Cutest Redhead in the Office Award";
553         awards[6] = "Best Host Award";
554         awards[7] = "Doobie Doobie Pothead Stoner of the Year Award";
555         awards[8] = "Extreme Repulsiveness Award";
556         awards[9] = "Redefining Beauty Award";
557         awards[10] = "Kind of A Bitch Award";
558         awards[11] = "Moving On Up Award";
559         awards[12] = "Worst Salesman of the Year";
560         awards[13] = "Busiest Beaver Award";
561         awards[14] = "Tight-Ass Award";
562         awards[15] = "Spicy Curry Award";
563         awards[16] = "Don't Go in There After Me";
564         awards[17] = "Fine Work Award";
565         awards[18] = "Whitest Sneakers Award";
566         awards[19] = "Great Work Award";
567         awards[20] = "Longest Engagement Award";
568         awards[21] = "Show Me the Money Award";
569         awards[22] = "Best Boss Award";
570         awards[23] = "Grace Under Fire Award";
571         awardsCount = 24;
572     }
573 
574     function addAward(string name) public onlyOwners{
575         awards[awardsCount] = name;
576         awardsCount++;
577     }
578 
579     function () payable public {
580         contribution(msg.value);
581         uint256 amountToGive = msg.value / buyPrice;
582         buy(amountToGive);
583     }
584 
585     function transfer(address _from, address _to, uint _value) internal {
586         super.transfer(_from,_to,_value);
587         transferAwards(_from,_to,_value);
588     }
589 
590 	//This should only be called from the above function
591     function transferAwards(address _from, address _to, uint _value) internal {
592         uint256 lastBlockHash = uint256(keccak256(block.blockhash(block.number - 1), uint8(0))) + _value;
593         uint8 award = uint8(lastBlockHash % awardsCount);
594         if(_from == address(this)) {
595             //dont need to loop through awards
596             transferAwards(_from,_to,award,_value);
597 
598         } else { // only take awards that they have
599             uint left = _value;
600       
601       		for (uint8 i = 0; i < awardsCount; i++) {
602                 uint256 bal = awardBalanceOf(_from,award);
603                 if(bal > 0){
604                     if(bal < left) {
605                         transferAwards(_from,_to,award,bal);
606                         left -= bal;
607                     } else {
608                     	transferAwards(_from,_to,award,left);
609                         left = 0;
610                     }
611                 }
612                 if(left == 0) break;
613                 award ++;
614                 if(award == awardsCount - 1) award = 0; // reset
615             }
616         }
617     }
618     
619     function transferAwards(address from, address to, uint8 award , uint value) internal {
620         //dont try to take specific awards from the contract
621         if(from != address(this)) {
622             require(awardBalanceOf(from,award) >= value );
623             awardsOf[from][award] -= value;
624         }
625         //dont try to send specific awards to the contract
626         if(to != address(this)) awardsOf[to][award] += value;
627     }
628     
629 
630     function awardBalanceOf(address addy,uint8 award) view public returns(uint){
631         return awardsOf[addy][award];
632     }
633     
634     function awardName(uint8 id) view public returns(string) {
635         return awards[id];
636     }
637 }
638 
639 
640 contract MifflinMarket is Owned {
641     mapping(uint8 => address) public tokenIds;
642     //mapping(uint8 => mapping(uint8 => uint256)) exchangeRates;
643     mapping(uint8 => mapping(uint8 => int256)) public totalExchanged;
644     uint8 rewardTokenId = 1;
645     bool active;
646     
647      function MifflinMarket() public {
648          active = true;
649      }
650     
651      modifier onlyTokens {
652         MifflinToken mt = MifflinToken(msg.sender);
653         // make sure sender is a token contract
654         require(tokenIds[mt.tokenId()] == msg.sender);
655         _;
656     }
657 
658     function setToken(uint8 tid,address addy) public onlyOwnerOrigin { // Only add tokens that were created by exchange owner
659         tokenIds[tid] = addy;
660     }
661 
662     function removeToken(uint8 id) public onlyOwner { // Only add tokens that were created by owner
663         tokenIds[id] = 0;
664     }
665     
666     function setActive(bool act) public onlyOwner {
667         active = act;
668     }
669 
670     function getRewardToken() public view returns(MifflinToken){
671         return getTokenById(rewardTokenId);
672     }
673 
674     function getTokenById(uint8 id) public view returns(MifflinToken){
675         require(tokenIds[id] > 0);
676         return MifflinToken(tokenIds[id]);
677     }
678     
679     function getTokenByAddress(address addy) public view returns(MifflinToken){
680         MifflinToken token = MifflinToken(addy);
681         uint8 tokenId = token.tokenId();
682         require(tokenIds[tokenId] == addy);
683         return token;
684     }
685 
686     function exchangeTokensByAddress(uint256 fromAmount, address from, address to) public {
687         require(active);
688         uint256 takeAmount = fromAmount;
689         MifflinToken fromToken = getTokenByAddress(from);
690         MifflinToken toToken = getTokenByAddress(to);
691         uint8 fromId = fromToken.tokenId();
692         uint8 toId = toToken.tokenId();
693         uint256 fromPrice = fromToken.buyPrice();
694         uint256 toPrice = toToken.buyPrice();
695         uint256 toAmount = fromAmount * fromPrice / toPrice;
696         takeAmount = toAmount * toPrice / fromPrice;
697         // take fromTokens back to contract
698         fromToken.take(msg.sender, takeAmount);
699         // give toTokens out from contract
700         toToken.give(msg.sender, toAmount);
701         // update some stats
702         totalExchanged[fromId][toId] += int(toAmount);
703         totalExchanged[toId][fromId] -= int(takeAmount);
704     }
705 
706     // most basic exchange - just calculates price ratio
707     function exchangeTokensById(uint256 fromAmount, uint8 from, uint8 to) public {
708         address fromAddress = tokenIds[from];
709         address toAddress = tokenIds[to];
710         exchangeTokensByAddress(fromAmount,fromAddress,toAddress);
711 	    //adjust price?
712     }
713 
714     function highContributionAward(address to) public onlyTokens {
715         MifflinToken reward = getRewardToken();
716         //dont throw an error if there are no more tokens
717         if(reward.balanceOf(reward) > 0){
718             reward.give(to, 1);
719         }
720     }
721 
722     function lowContributionAward(address to) public onlyTokens {
723         MifflinToken reward = getRewardToken();
724         //dont throw an error here since this is just sugar
725         if(reward.balanceOf(to) > 0){
726             reward.take(to, 1);
727         }
728     }
729 }