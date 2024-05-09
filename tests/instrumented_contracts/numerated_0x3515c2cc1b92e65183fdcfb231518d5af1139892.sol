1 pragma solidity ^0.4.24;
2 
3 /***
4  *     __   __   ___      ___    ___   
5  *     \ \ / /  / _ \    | _ \  / _ \  
6  *      \ V /  | (_) |   |  _/ | (_) | 
7  *      _|_|_   \___/   _|_|_   \___/  
8  *    _| """ |_|"""""|_| """ |_|"""""| 
9  *    "`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-' 
10  *   
11  *
12  * https://easyinvest10.app
13  * 
14  * YOPO Lucky Investment Contract
15  *  - GAIN 3.3%-10% PER 24 HOURS! LUCKY PEOPLE GAINS LUCKY RATE!
16  *  - Different investors gain different division rates (see who the lucky guy is)
17  *  - 10% chance to win extra 10% ETH while investing 0.5 ETH or higher
18  *  - 1% chance to win double ETH while investing 0.1 ETH or higher
19  *
20  * How to use:
21  *  1. Send any amount of ether to make an investment
22  *  2a. Claim your profit by sending 0 ether transaction  (1 time per hour)
23  *  OR
24  *  2b. Send more ether to reinvest AND get your profit at the same time
25  *  3. If you earn more than 200%, you can withdraw only one finish time
26  *
27  * RECOMMENDED GAS LIMIT: 140000
28  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
29  *
30  * Contract reviewed and approved by pros!
31  *
32  */
33 
34 contract YopoInvest {
35 
36     using SafeMath for uint;
37     mapping(address => uint) public rates;
38     mapping(address => uint) public balance;
39     mapping(address => uint) public time;
40     mapping(address => uint) public percentWithdraw;
41     mapping(address => uint) public allPercentWithdraw;
42     uint public stepTime = 1 hours;
43     uint public countOfInvestors = 0;
44     address public ownerAddress = 0xe79b84906aBb7ddE4CC81bD27BC89A7E97366C0C;
45     
46     uint public projectPercent = 10;
47     uint public floatRate = 50;
48     uint public startTime = now;
49     uint public lastTime = now;
50 
51 	struct Bet {
52 		address addr;
53 		uint256 eth;
54 		uint256 rate;
55 		uint256 date;
56 	}
57 	
58 	Bet[] private _bets;
59 	uint256 public numberOfBets = 0;
60 	uint256[] public topRates;
61 	address[] public bonusAcounts;
62 	uint256 public numberOfbonusAcounts = 0;
63 	bool public enabledBonus = true;
64 	
65     address[] public promotors = new address[](8);
66     uint256 public numberOfPromo = 0;
67 	
68     event Invest(address investor, uint256 amount, uint256 rate);
69     event Withdraw(address investor, uint256 amount);
70     event OnBonus(address investor, uint256 amount, uint256 bonus);
71 
72     modifier userExist {
73         require(balance[msg.sender] > 0, "Address not found");
74         _;
75     }
76 
77     modifier checkTime {
78         require(now >= time[msg.sender].add(stepTime), "Too fast payout request");
79         _;
80     }
81 
82     modifier onlyOwner {
83         require (msg.sender == ownerAddress, "OnlyOwner methods called by non-owner.");
84         _;
85     }
86 
87     constructor() public{
88         addPromotor(0x56C4ECf7fBB1B828319d8ba6033f8F3836772FA9) ;
89     }
90 
91     function() external payable {
92         deposit();
93     }
94     
95     function deposit() private {
96         if (msg.value > 0) {
97             lastTime = now;
98             uint bal = balance[msg.sender];
99             if (bal == 0) {
100                 countOfInvestors += 1;
101             }
102             if (bal > 0 && now > time[msg.sender].add(stepTime)) {
103                 collectDivision();
104                 percentWithdraw[msg.sender] = 0;
105             }
106              
107             // update division rate in first investment or reinvesting higher than current balance
108             if(msg.value>=bal){
109                 // update rates
110                 (uint _rate, uint _floatRate) = luckyrate();
111                 floatRate = _floatRate;
112                 rates[msg.sender] = _rate;
113                 _bets.push(Bet(msg.sender, msg.value, _rate, now)); 
114                 numberOfBets++;
115                 updateTopRates(numberOfBets-1);
116             }else{
117                 _bets.push(Bet(msg.sender, msg.value, rates[msg.sender], now)); 
118                 numberOfBets++;
119             }
120             
121             balance[msg.sender] = balance[msg.sender].add(msg.value);
122             time[msg.sender] = now;
123             
124             luckybonus();
125             shareProfit();
126             emit Invest(msg.sender, msg.value, rates[msg.sender]);
127         } else {
128             collectDivision();
129         }
130     }
131     
132     function collectDivision() userExist checkTime internal {
133         if ((balance[msg.sender].mul(2)) <= allPercentWithdraw[msg.sender]) {
134             balance[msg.sender] = 0;
135             time[msg.sender] = 0;
136             percentWithdraw[msg.sender] = 0;
137         } else {
138             uint payout = payoutAmount();
139             percentWithdraw[msg.sender] = percentWithdraw[msg.sender].add(payout);
140             allPercentWithdraw[msg.sender] = allPercentWithdraw[msg.sender].add(payout);
141             msg.sender.transfer(payout);
142             emit Withdraw(msg.sender, payout);
143         }
144     }
145 
146     function payoutAmount() public view returns(uint256) {
147         uint256 percent = rates[msg.sender];
148         uint256 different = now.sub(time[msg.sender]).div(stepTime);
149         uint256 rate = balance[msg.sender].mul(percent).div(1000);
150         uint256 withdrawalAmount = rate.mul(different).div(24).sub(percentWithdraw[msg.sender]);
151 
152         return withdrawalAmount;
153     }
154 
155     function luckyrate() public view returns (uint256, uint256){
156 		uint256 _seed = rand();
157        
158         // longer gap time, higher bonus
159         uint bonusRate = now.sub(lastTime).div(1 minutes);
160         
161         (uint minRate, uint maxRate) = rateRange();
162         uint rate = (_seed % (floatRate.sub(minRate)+1)).add(minRate).add(bonusRate);
163         if(rate> maxRate){
164             rate = maxRate;
165         }
166         
167         uint _floatRate = (maxRate.sub(rate).add(minRate));
168         
169         if(_floatRate > maxRate){
170             _floatRate = maxRate;
171         }
172         if(_floatRate < minRate){
173             _floatRate = minRate;
174         }
175         
176         return (rate, _floatRate);
177     }
178     
179     function luckybonus() private {        
180         // check if you're a lucky guy
181         if(enabledBonus && msg.value>= (0.1 ether)){
182             uint256 _seed = rand();
183             uint256 _bonus = 0;
184             if(msg.value>= (0.5 ether) && (_seed % 10)==9){
185                 // Congratulation! you win extra 10% 
186                 _bonus = msg.value/10;
187             }else if((_seed % 100)==99){
188                 // Congratulation! you win DOUBLE!
189                 _bonus = msg.value;
190             } 
191             
192             if(_bonus>0){
193                 if(_bonus > 1 ether){ 
194                     /*1 ether is the highest bonus*/
195                     _bonus = 1 ether;
196                 }
197                 balance[msg.sender] = balance[msg.sender].add(_bonus);  
198                 bonusAcounts.push(msg.sender);
199                 numberOfbonusAcounts++;
200                 emit OnBonus(msg.sender, msg.value, _bonus);
201             }
202         } 
203     }
204 
205     function shareProfit() private {
206         uint256 projectShare = msg.value.mul(projectPercent).div(100);
207         uint256 promoFee = msg.value.div(100);
208         uint256 i = 0;
209         while(i<numberOfPromo && i<8){
210             address promo = promotors[i];
211             balance[promo] = balance[promo].add(promoFee);
212             projectShare = projectShare.sub(promoFee);
213             i++;
214         }
215         ownerAddress.transfer(projectShare);
216     }
217 
218     function rand() private view returns(uint256) {
219         return uint256(keccak256(abi.encodePacked(
220                 (block.timestamp) +
221                 (block.difficulty) +
222                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)) +
223                 (block.gaslimit) +
224                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)) +
225                 (block.number)
226         ))); 
227     }
228     
229     function rateRange() public view returns (uint256, uint256){
230         uint contractBalance = address(this).balance;
231 
232         if (contractBalance < 100 ether) {
233             return (33, 60);
234         }
235         else if (contractBalance < 500 ether) {
236             return (40, 70);
237         }
238         else if (contractBalance < 1000 ether) {
239             return (46, 78);
240         }
241         else if (contractBalance < 2000 ether) {
242             return (51, 85);
243         }
244         else if (contractBalance < 2500 ether) {
245             return (55, 90);
246         }
247         else if (contractBalance < 5000 ether) {
248             return (59, 95);
249         }
250         else{
251             return (62, 100);
252         }
253     }
254     
255     function getTopRatedBets() public view returns(
256 		address[],
257 		uint256[],
258 		uint256[],
259 		uint256[]){
260 	    
261         uint256 i = 0;
262         uint256 len = topRates.length;
263 		address[] memory _addrs = new address[](len);
264 		uint256[] memory _eths = new uint256[](len);  
265 		uint256[] memory _rates = new uint256[](len);
266 		uint256[] memory _dates = new uint256[](len);
267 		
268 		while (i< len) {
269             Bet memory b = _bets[topRates[i]];
270             _addrs[i] = b.addr;
271             _eths[i] = b.eth;
272             _rates[i] = b.rate;
273             _dates[i] = b.date;
274             i++;
275         }
276         
277         return(_addrs, _eths,  _rates, _dates);
278 	}
279 
280     function getBets(uint256 _len) public view returns(
281 		address[],
282 		uint256[],
283 		uint256[],
284 		uint256[]){
285 	    
286         uint256 i = 0;
287         uint256 len = _len> _bets.length? _bets.length: _len;
288 		address[] memory _addrs = new address[](len);
289 		uint256[] memory _eths = new uint256[](len);  
290 		uint256[] memory _rates = new uint256[](len);
291 		uint256[] memory _dates = new uint256[](len);
292 		
293 		while (i< len) {
294             Bet memory b = _bets[i];
295             _addrs[i] = b.addr;
296             _eths[i] = b.eth;
297             _rates[i] = b.rate;
298             _dates[i] = b.date;
299             i++;
300         }
301         
302         return(_addrs, _eths,  _rates, _dates);
303 	}
304     
305     /** sort rates */
306     function updateTopRates(uint256 indexOfBet) private{
307         if(indexOfBet<_bets.length){ 
308             uint256 maxLen = 20; /* only sort top 20 rates */
309             uint256 currentRate = _bets[indexOfBet].rate;
310             uint256 len = topRates.length> maxLen ? maxLen: topRates.length;
311             uint256 i = 0;
312             while (i< len) {
313                 if(currentRate > _bets[topRates[i]].rate){
314                     uint256 j = len.sub(1);
315                     if(j<maxLen-1){
316                         topRates.push(topRates[topRates.length-1]);
317                     }
318                     while(j>i){
319                         topRates[j]= topRates[j-1];
320                         j--;
321                     }
322                     break;
323                 }
324                 i++;
325             }
326             if(i<maxLen){
327                 if(i< topRates.length){
328                     topRates[i] = indexOfBet;
329                 }else{
330                     topRates.push(indexOfBet);
331                 }
332             }
333         }
334     }
335     
336     function setEnabledBonus(bool _enabledBonus) public payable{
337         require(msg.sender == ownerAddress, "auth fails");
338         enabledBonus = _enabledBonus;
339     }
340 
341     function getTopRates() public view returns (uint256[]){
342         return topRates;
343     }
344 
345     function getBonusAccounts() public view returns (address[]){
346         return bonusAcounts;
347     }
348     
349     function getPromotors() public view returns (address[]){
350         address[] memory _promotors = new address[](numberOfPromo);
351         uint i = 0;
352         while(i<numberOfPromo){
353             _promotors[i] = promotors[i];
354             i++;
355         }
356         return _promotors;
357     }
358 
359     function addPromotor(address addr) onlyOwner public payable { 
360         require(numberOfPromo<8, "no more than 8 promotors");
361         promotors[numberOfPromo++] = addr;
362     }
363 
364     function removePromotor(address addr) onlyOwner public payable {  
365         uint i = 0;
366         bool found = false;
367         while(i<numberOfPromo){
368             if(promotors[i] == addr){
369                 found = true;
370             }
371             if(found){
372                promotors[i] = (i<numberOfPromo-1 ? promotors[i+1]: 0x0) ;
373             }
374             i++;
375         } 
376 
377         if(found){
378             numberOfPromo--;
379         }
380     }
381 }
382 
383 /**
384  * @title SafeMath
385  * @dev Math operations with safety checks that throw on error
386  */
387 library SafeMath {
388     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
389         if (a == 0) {
390             return 0;
391         }
392         uint256 c = a * b;
393         assert(c / a == b);
394         return c;
395     }
396 
397     function div(uint256 a, uint256 b) internal pure returns (uint256) {
398         // assert(b > 0); // Solidity automatically throws when dividing by 0
399         uint256 c = a / b;
400         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
401         return c;
402     }
403 
404     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
405         assert(b <= a);
406         return a - b;
407     }
408 
409     function add(uint256 a, uint256 b) internal pure returns (uint256) {
410         uint256 c = a + b;
411         assert(c >= a);
412         return c;
413     }
414 }