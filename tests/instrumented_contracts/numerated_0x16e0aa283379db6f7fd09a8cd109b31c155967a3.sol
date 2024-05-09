1 pragma solidity ^0.4.25;
2 
3 /*
4 
5     Lambo Lotto Win | Dapps game for real crypto human
6     site: https://llotto.win/
7     telegram: https://t.me/Lambollotto/
8     discord: https://discord.gg/VWV5jeW/
9     
10     Rules of the game:
11     - Jackpot from 0.1 Ether;    
12     - Jackpot is currently 1.5% of the turnover for the jackpot period;    
13     - 2.5% of the bet goes to the next jackpot;   
14     - jackpot win number 888 (may vary during games);      
15     - in case of a jackpot from 0 to 15, the player wins a small jackpot which is equal to 0.5 of the turnover during the jackpot period;
16     - when the jackpot is between 500 and 515, the player wins the small jackpot which is equal to 0.3 of the turnover during the jackpot period;
17     - the minimum win is 15% of the bet amount, the maximum win is 150% (may be changed by the administration during the game but does not affect the existing bets);
18     - administration commission of 2.5% + 2.5% for the development and maintenance of the project;
19     - the administration also reserves the right to dispose of the entire bank including jackpots in the event of termination of interest in the game from the users ( 
20 what happened in Las Vegas stays in Las Vegas:) );
21     - there is an opportunity to add marketing wallets if you are interested in advertising our project;
22 
23 */
24 
25 contract lambolotto {
26     
27     using SafeMath
28     for uint;
29 
30     modifier onlyAdministrator(){    
31         address _customerAddress = msg.sender;
32         require(administrators[_customerAddress]);
33         _;
34     }
35     
36     modifier onlyActive(){    
37         require(boolContractActive);
38         _;
39     }
40     
41 	modifier onlyHumans() { 
42 	    require (msg.sender == tx.origin, "only approved contracts allowed"); 
43 	    _; 
44 	  }     
45 
46     constructor () public {
47     
48         administrators[msg.sender] = true;          
49     }
50     
51     uint templeContractPercent = 0;
52     
53     address private adminGet;
54 	address private promoGet;
55     
56     uint public forAdminGift = 25;
57     
58     uint public jackPot_percent_now = 15;
59     uint public jackPot_percent_next = 25;
60     
61     uint public jackPotWin = 888;
62     uint public jackPotWinMinAmount = 0.1 ether;
63     uint public maxBetsVolume = 10 ether;
64     
65     uint public jackPot_little_first = 5;
66     uint public jackPot_little_first_min = 0;    
67     uint public jackPot_little_first_max = 15;
68     
69     uint public jackPot_little_second = 3;
70     uint public jackPot_little_second_min = 500;    
71     uint public jackPot_little_second_max = 515;
72     
73     uint public addPercent = 15;
74     
75     uint public rand_pmin = 0;
76     uint public rand_pmax = 1350; 
77     
78     uint public rand_jmin = 0;
79     uint public rand_jmax = 1000;
80 
81     uint public currentReceiverIndex;
82     uint public totalInvested;
83 
84     uint public betsNum;
85     uint public jackPot_now;
86     uint public jackPot_next;
87     uint public jackPot_lf;
88     uint public jackPot_ls;    
89     
90     uint public jackPotNum = 0;
91     uint public jackPotLFNum = 0;
92     uint public jackPotLSNum = 0;
93     
94     struct Deposit {
95     
96         address depositor;
97         uint deposit;
98         uint winAmount;
99         uint depositJackPotValue;
100         uint payout;
101     }
102     
103     Deposit[] public queue;
104     
105     uint nonce;
106     
107     bool public boolContractActive = true;    
108     mapping(address => bool) public administrators;   
109     
110     address mkt = 0x0;
111     uint mktRate = 0;
112 
113     event bets(
114         address indexed customerAddress,
115         uint timestamp,
116         uint amount,
117         uint winAmount,
118         uint jackPotValue,
119         uint payout
120     );
121 
122     event jackPot(
123         uint indexed numIndex,
124         address customerAddress,
125         uint timestamp,
126         uint jackAmount
127     );
128 
129     event jackPotLittleFirst(
130         uint indexed numIndex,
131         address customerAddress,
132         uint timestamp,
133         uint jackAmount
134     );
135 
136     event jackPotLitteleSecond(
137         uint indexed numIndex,
138         address customerAddress,
139         uint timestamp,
140         uint jackAmount
141     );
142     
143     function ()
144         onlyActive()
145         onlyHumans()
146         public payable{
147 
148         if(msg.value > 0){
149         
150             require(gasleft() >= 250000); 
151             require(msg.value >= 0.001 ether && msg.value <= maxBetsVolume);
152             
153             uint winningNumber = rand(rand_pmin, rand_pmax);
154 
155             totalInvested += msg.value;
156             jackPot_now += msg.value.mul(jackPot_percent_now).div(1000);
157             jackPot_next += msg.value.mul(jackPot_percent_next).div(1000);
158             
159             jackPot_lf += msg.value.mul(jackPot_little_first).div(1000);
160             jackPot_ls += msg.value.mul(jackPot_little_second).div(1000);
161             
162             betsNum++;
163             
164             uint depositJPV = 0;
165             
166             if( msg.value >= jackPotWinMinAmount)
167             {                
168                 depositJPV = rand(rand_jmin, rand_jmax);
169             
170                 if (depositJPV == jackPotWin){     
171 
172                         msg.sender.transfer(jackPot_now);                        
173                         jackPotNum++;
174                         
175                         emit jackPot(jackPotNum,  msg.sender, now, jackPot_now );
176 
177                         jackPot_now = jackPot_next;  
178                         jackPot_next = 0;
179                 }
180                 
181                 if ( depositJPV > jackPot_little_first_min && depositJPV <= jackPot_little_first_max){     
182 
183                         msg.sender.transfer(jackPot_lf);   
184                         jackPotLFNum++;
185                                         
186                         emit jackPotLittleFirst(jackPotLFNum,  msg.sender, now, jackPot_lf );
187                         
188                         jackPot_lf = 0; 
189                 }
190                 
191                 if ( depositJPV >= jackPot_little_second_min && depositJPV <= jackPot_little_second_max){     
192 
193                         msg.sender.transfer(jackPot_ls);                        
194                         jackPotLSNum++;                        
195                         emit jackPotLitteleSecond(jackPotLSNum,  msg.sender, now, jackPot_ls );
196                         
197                         jackPot_ls = 0;
198                 }
199                 
200                 uint totalPayout = msg.value.mul(winningNumber.div(10).add(addPercent)).div(100);
201                             
202                 emit bets(msg.sender, now, msg.value, winningNumber, depositJPV, totalPayout);
203                 
204             }
205             
206             queue.push( Deposit(msg.sender, msg.value, winningNumber, depositJPV, 0) );
207             
208             uint adminGetValue = msg.value.mul(forAdminGift).div(1000); 
209             adminGet.transfer(adminGetValue);
210             
211 			uint promoGetValue = msg.value.mul(forAdminGift).div(1000);
212             promoGet.transfer(promoGetValue);
213             
214             if (mkt != 0x0 && mktRate != 0){
215                 
216                 uint mktGetValue = msg.value.mul(mktRate).div(1000);
217                 mkt.transfer(mktGetValue);                
218             }
219             
220             pay();
221         }
222     }
223 
224     function pay() internal {
225 
226         uint money = address(this).balance.sub(jackPot_now.add(jackPot_next).add(jackPot_lf).add(jackPot_ls));
227         
228         for (uint i = 0; i < queue.length; i++){   
229         
230             uint idx = currentReceiverIndex.add(i); 
231                 
232                 if(idx <= queue.length.sub(1)){
233                 
234                     Deposit storage dep = queue[idx]; 
235                     uint totalPayout = dep.deposit.mul(dep.winAmount.div(10).add(addPercent)).div(100);
236 
237                     if(totalPayout > dep.payout) { uint leftPayout = totalPayout.sub(dep.payout); }
238 
239                     if(money >= leftPayout){ 
240                     
241                         if (leftPayout > 0){                        
242                             dep.depositor.transfer(leftPayout); 
243                             dep.payout += leftPayout;                                                   
244                             money -= leftPayout; 
245                         }
246 
247                     }else{
248                         dep.depositor.transfer(money); 
249                         dep.payout += money;   
250                         break; 
251                     }
252 
253                     if(gasleft() <= 55000){ break; }   
254                     
255                 }else{ break; }                
256         }
257         currentReceiverIndex += i; 
258     }
259     
260     function rand(uint minValue, uint maxValue) internal returns (uint){
261     
262         nonce++;        
263         uint nonce_ = block.difficulty.div(block.number).mul(now).mod(nonce);        
264         uint mixUint = SafeMath.sub(SafeMath.mod(uint(keccak256(abi.encodePacked(nonce_))), SafeMath.add(minValue,maxValue)), minValue);
265         nonce += mixUint; 
266         return mixUint;        
267     }
268  
269     function donate()
270         public payable{        
271     } 
272 
273     function setJackPotNowValue()
274         onlyAdministrator()
275         public payable{
276       
277         require(msg.value > jackPot_now);      
278         jackPot_now = msg.value;     
279     } 
280     
281     function setJackPotNextValue()
282         onlyAdministrator()
283         public payable{
284       
285         require(msg.value > jackPot_next);      
286         jackPot_next = msg.value;     
287     } 
288     
289     function setJackPotLFValue()
290         onlyAdministrator()
291         public payable{
292       
293         require(msg.value > jackPot_lf);      
294         jackPot_lf = msg.value;     
295     }  
296     
297     function setJackPotLSValue()
298         onlyAdministrator()
299         public payable{
300       
301         require(msg.value > jackPot_ls);      
302         jackPot_ls =  msg.value;     
303     }     
304 
305     function setjackPotLillteF(uint _newJPLF)
306         onlyAdministrator()
307         public{
308       
309         jackPot_little_first = _newJPLF;     
310     }       
311     
312     function setjackPotLillteS(uint _newJPLS)
313         onlyAdministrator()
314         public{
315       
316         jackPot_little_second =  _newJPLS;     
317     }    
318     
319     function setMarket(address _newMkt)
320         onlyAdministrator()
321         public{
322       
323         mkt =  _newMkt;     
324     }
325     
326     function setMarketingRates(uint _newMktRate)
327         onlyAdministrator()
328         public{
329        
330         mktRate =  _newMktRate;
331     }  
332 
333     function setAdminGet(address _newAdminGet)
334         onlyAdministrator()
335         public{
336       
337         adminGet =  _newAdminGet;     
338     }     
339     
340     function setPromoGet(address _newPromoGet)
341         onlyAdministrator()
342         public{
343       
344         promoGet =  _newPromoGet;     
345     }   
346 
347     function setForAdminGift(uint _newAdminGift)
348         onlyAdministrator()
349         public{
350        
351         forAdminGift =  _newAdminGift;
352     }      
353     
354    function setJeckPotPercentNow(uint _newJeckPotPercentNow)
355         onlyAdministrator()
356         public{
357        
358         jackPot_percent_now =  _newJeckPotPercentNow;
359     }  
360  
361    function setJeckPotPercentNext(uint _newJeckPotPercentNext)
362         onlyAdministrator()
363         public{
364        
365         jackPot_percent_next =  _newJeckPotPercentNext;
366     }   
367  
368    function setJeckPotWin(uint _newJeckPotWin)
369         onlyAdministrator()
370         public{
371        
372         jackPotWin =  _newJeckPotWin;
373     } 
374     
375    function setAddPercent(uint _newAddPercent)
376         onlyAdministrator()
377         public{
378        
379         addPercent =  _newAddPercent;
380     } 
381 
382    function setRandPMax(uint _newRandPMax)
383         onlyAdministrator()
384         public{
385        
386         rand_pmax =  _newRandPMax;
387     }
388 
389    function setRandJMax(uint _newRandJMax)
390         onlyAdministrator()
391         public{
392        
393         rand_jmax =  _newRandJMax;
394     }
395     
396    function setNonce(uint _newNonce)
397         onlyAdministrator()
398         public{
399        
400         nonce =  _newNonce;
401     }    
402  
403    function setNewMaxVolume(uint _newMaxVol)
404         onlyAdministrator()
405         public{
406        
407         maxBetsVolume =  _newMaxVol;
408     }    
409     
410     function setContractActive(bool _status)
411         onlyAdministrator()
412         public{
413         
414         boolContractActive = _status;
415         
416     } 
417     
418     function setAdministrator(address _identifier, bool _status)
419         onlyAdministrator()
420         public{
421         
422         administrators[_identifier] = _status;
423     } 
424     
425     function getAllDepoIfGameStop() 
426         onlyAdministrator()
427         public{        
428         
429         jackPot_now = 0;
430         jackPot_next = 0;
431         jackPot_lf = 0;
432         jackPot_ls = 0;
433         
434         uint money = address(this).balance;
435         adminGet.transfer(money);
436     }
437 
438 
439 }    
440 
441 library SafeMath {
442     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
443         if (a == 0) {
444           return 0;
445         }
446         uint256 c = a * b;
447         require(c / a == b);
448         return c;
449     }
450     
451     function div(uint256 a, uint256 b) internal pure returns (uint256) {
452         require(b > 0);
453         uint256 c = a / b;
454         return c;
455     }
456     
457     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
458         require(b <= a);
459         uint256 c = a - b;
460         return c;
461     }
462     
463     function add(uint256 a, uint256 b) internal pure returns (uint256) {
464         uint256 c = a + b;
465         require(c >= a);
466         return c;
467     }
468     
469     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
470         require(b != 0);
471         return a % b;
472     }
473 }