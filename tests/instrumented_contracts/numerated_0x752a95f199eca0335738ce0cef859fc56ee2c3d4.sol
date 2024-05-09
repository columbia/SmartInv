1 pragma solidity ^0.4.24;
2 
3 /*
4 
5     ____  _______   ________   __________  _   ____________  ____  __ 
6    / __ \/ ____/ | / /_  __/  / ____/ __ \/ | / /_  __/ __ \/ __ \/ / 
7   / /_/ / __/ /  |/ / / /    / /   / / / /  |/ / / / / /_/ / / / / /  
8  / _, _/ /___/ /|  / / /    / /___/ /_/ / /|  / / / / _, _/ /_/ / /___
9 /_/ |_/_____/_/ |_/ /_/     \____/\____/_/ |_/ /_/ /_/ |_|\____/_____/
10                                                                       
11 website:    https://rentcontrol.tk
12 
13 discord:    https://discord.gg/X78kgWp
14 
15 Buy Property.   Collect Rent.
16 
17 Rent Control is a strategy game where you buy property levels and collect rent from other owners.
18 
19 Game begins with 20 property levels.    Level 1 is the best and most valuable.    When you own a property level, you collect rent from the purchases of every other level.
20 Different levels have different rates of rent.    Level 1 collects 10% of all rent distributions from each purchase.
21 Once you buy a property level it is then available for purchase at a price 10% higher than what you paid.    So you will earn rent while you won the property AND you will have a capital gain
22 when someone buys the level from you.
23 
24 Property owner receives 50% of the gain from a sale.
25 
26 30% of gains are distributed to other property owners based on their rates of rent.
27 
28 20% of gains are distributed to dev.
29 
30 Masternodes recieve 5% of any distributions from buyers using the link.
31 
32 */
33 
34 contract RENTCONTROL {
35     /*=================================
36     =        MODIFIERS        =
37     =================================*/
38    
39 
40 
41     modifier onlyOwner(){
42         
43         require(msg.sender == dev);
44         _;
45     }
46     
47 
48     /*==============================
49     =            EVENTS            =
50     ==============================*/
51     event onLevelPurchase(
52         address customerAddress,
53         uint256 incomingEthereum,
54         uint256 level,
55         uint256 newPrice
56     );
57     
58     event onWithdraw(
59         address customerAddress,
60         uint256 ethereumWithdrawn
61     );
62     
63     // ERC20
64     event Transfer(
65         address from,
66         address to,
67         uint256 level
68     );
69 
70     
71     /*=====================================
72     =            CONFIGURABLES            =
73     =====================================*/
74     string public name = "RENT CONTROL";
75     string public symbol = "LEVEL";
76 
77     uint8 constant public devDivRate = 20;
78     uint8 constant public ownerDivRate = 50;
79     uint8 constant public distDivRate = 30;
80 
81     uint8 constant public referralRate = 5; 
82 
83     uint8 constant public decimals = 18;
84   
85     uint public totalLevelValue = 2465e16;
86 
87     
88    /*================================
89     =            DATASETS            =
90     ================================*/
91     
92     mapping(uint => address) internal levelOwner;
93     mapping(uint => uint) public levelPrice;
94     mapping(uint => uint) internal levelPreviousPrice;
95     mapping(address => uint) internal ownerAccounts;
96     mapping(uint => uint) internal totalLevelDivs;
97     mapping(uint => string) internal levelName;
98 
99     uint levelPriceIncrement = 110;
100     uint totalDivsProduced = 0;
101 
102     uint public maxLevels = 200;
103     
104     uint public initialPrice = 5e16;   //0.05 ETH
105 
106     uint public nextAvailableLevel;
107 
108     bool allowReferral = false;
109 
110     bool allowAutoNewLevel = false;
111    
112     address dev;
113 
114     
115     
116 
117 
118     /*=======================================
119     =            PUBLIC FUNCTIONS            =
120     =======================================*/
121     /*
122     * -- APPLICATION ENTRY POINTS --  
123     */
124     function RENTCONTROL()
125         public
126     {
127         dev = msg.sender;
128         nextAvailableLevel = 21;
129 
130         levelOwner[1] = dev;
131         levelPrice[1] = 5e18;
132         levelPreviousPrice[1] = levelPrice[1];
133 
134         levelOwner[2] = dev;
135         levelPrice[2] = 4e18;
136         levelPreviousPrice[2] = levelPrice[2];
137 
138         levelOwner[3] = dev;
139         levelPrice[3] = 3e18;
140         levelPreviousPrice[3] = levelPrice[3];
141 
142         levelOwner[4] = dev;
143         levelPrice[4] = 25e17;
144         levelPreviousPrice[4] = levelPrice[4];
145 
146         levelOwner[5] = dev;
147         levelPrice[5] = 20e17;
148         levelPreviousPrice[5] = levelPrice[5];
149 
150         levelOwner[6] = dev;
151         levelPrice[6] = 15e17;
152         levelPreviousPrice[6] = levelPrice[6];
153 
154         levelOwner[7] = dev;
155         levelPrice[7] = 125e16;
156         levelPreviousPrice[7] = levelPrice[7];
157 
158         levelOwner[8] = dev;
159         levelPrice[8] = 100e16;
160         levelPreviousPrice[8] = levelPrice[8];
161 
162         levelOwner[9] = dev;
163         levelPrice[9] = 80e16;
164         levelPreviousPrice[9] = levelPrice[9];
165 
166         levelOwner[10] = dev;
167         levelPrice[10] = 70e16;
168         levelPreviousPrice[10] = levelPrice[10];
169 
170         levelOwner[11] = dev;
171         levelPrice[11] = 60e16;
172         levelPreviousPrice[11] = levelPrice[11];
173 
174         levelOwner[12] = dev;
175         levelPrice[12] = 50e16;
176         levelPreviousPrice[12] = levelPrice[12];
177 
178         levelOwner[13] = dev;
179         levelPrice[13] = 40e16;
180         levelPreviousPrice[13] = levelPrice[13];
181 
182         levelOwner[14] = dev;
183         levelPrice[14] = 35e16;
184         levelPreviousPrice[14] = levelPrice[14];
185 
186         levelOwner[15] = dev;
187         levelPrice[15] = 30e16;
188         levelPreviousPrice[15] = levelPrice[15];
189 
190         levelOwner[16] = dev;
191         levelPrice[16] = 25e16;
192         levelPreviousPrice[16] = levelPrice[16];
193 
194         levelOwner[17] = dev;
195         levelPrice[17] = 20e16;
196         levelPreviousPrice[17] = levelPrice[17];
197 
198         levelOwner[18] = dev;
199         levelPrice[18] = 15e16;
200         levelPreviousPrice[18] = levelPrice[18];
201 
202         levelOwner[19] = dev;
203         levelPrice[19] = 10e16;
204         levelPreviousPrice[19] = levelPrice[19];
205 
206         levelOwner[20] = dev;
207         levelPrice[20] = 5e16;
208         levelPreviousPrice[20] = levelPrice[20];
209 
210 
211     }
212 
213     function addTotalLevelValue(uint _new, uint _old)
214     internal
215     {
216         uint newPrice = SafeMath.div(SafeMath.mul(_new,levelPriceIncrement),100);
217         totalLevelValue = SafeMath.add(totalLevelValue, SafeMath.sub(newPrice,_old));
218     }
219     
220     function buy(uint _level, address _referrer)
221         public
222         payable
223 
224     {
225         require(_level <= nextAvailableLevel);
226         require(msg.value >= levelPrice[_level]);
227         addTotalLevelValue(msg.value, levelPreviousPrice[_level]);
228 
229         if (levelOwner[_level] == dev){   
230 
231             require(msg.value >= levelPrice[_level]);
232            // uint _price = msg.value;
233 
234             if ((allowAutoNewLevel) && (_level == nextAvailableLevel - 1) && nextAvailableLevel < maxLevels) {
235                 levelOwner[nextAvailableLevel] = dev;
236                 levelPrice[nextAvailableLevel] = initialPrice;
237                 nextAvailableLevel = nextAvailableLevel + 1;
238                 
239             }
240 
241             
242 
243             ownerAccounts[dev] = SafeMath.add(ownerAccounts[dev],msg.value);
244 
245             levelOwner[_level] = msg.sender;
246 
247             //Increment the Level Price
248             levelPreviousPrice[_level] = msg.value;
249             levelPrice[_level] = SafeMath.div(SafeMath.mul(msg.value,levelPriceIncrement),100);
250             //levelName[_level] = _name;     //Give your level an optional name
251 
252 
253         } else {      
254 
255             require(msg.sender != levelOwner[_level]);
256 
257            // uint _price = msg.value;
258 
259             uint _newPrice = SafeMath.div(SafeMath.mul(msg.value,levelPriceIncrement),100);
260 
261              //Determine the total dividends
262             uint _baseDividends = msg.value - levelPreviousPrice[_level];
263             totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
264 
265             uint _devDividends = SafeMath.div(SafeMath.mul(_baseDividends,devDivRate),100);
266             uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends,ownerDivRate),100);
267 
268             totalLevelDivs[_level] = SafeMath.add(totalLevelDivs[_level],_ownerDividends);
269             _ownerDividends = SafeMath.add(_ownerDividends,levelPreviousPrice[_level]);
270             
271             uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends,distDivRate),100);
272 
273             if (allowReferral && (_referrer != msg.sender) && (_referrer != 0x0000000000000000000000000000000000000000)) {
274                 
275                 uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends,referralRate),100);
276                 _distDividends = SafeMath.sub(_distDividends,_referralDividends);
277                 ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer],_referralDividends);
278             }
279             
280 
281 
282             //distribute dividends to accounts
283             address _previousOwner = levelOwner[_level];
284             address _newOwner = msg.sender;
285 
286             ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner],_ownerDividends);
287             ownerAccounts[dev] = SafeMath.add(ownerAccounts[dev],_devDividends);
288 
289             distributeRent(nextAvailableLevel, _distDividends);
290 
291             //Increment the Level Price
292             levelPreviousPrice[_level] = msg.value;
293             levelPrice[_level] = _newPrice;
294             levelOwner[_level] = _newOwner;
295             //levelName[_level] = _name;   //Give your level an optional name
296 
297         }
298 
299         emit onLevelPurchase(msg.sender, msg.value, _level, SafeMath.div(SafeMath.mul(msg.value,levelPriceIncrement),100));
300      
301     }
302 
303     function distributeRent(uint _levels, uint _distDividends) {
304 
305         uint _distFactor = 10;
306         uint counter = 1;
307 
308         ownerAccounts[dev] = SafeMath.add(ownerAccounts[dev], _distDividends);
309 
310         while (counter < nextAvailableLevel) { 
311                 
312             uint _distAmountLocal = SafeMath.div(_distDividends,_distFactor);
313             ownerAccounts[levelOwner[counter]] = SafeMath.add(ownerAccounts[levelOwner[counter]],_distAmountLocal);
314             totalLevelDivs[counter] = SafeMath.add(totalLevelDivs[counter],_distAmountLocal);
315             counter = counter + 1;
316             ownerAccounts[dev] = SafeMath.sub(ownerAccounts[dev], _distAmountLocal);
317             _distFactor = SafeMath.div(SafeMath.mul(_distFactor, 112),100);
318         } 
319 
320     }
321 
322 
323     function withdraw()
324     
325         public
326     {
327         address _customerAddress = msg.sender;
328         require(ownerAccounts[_customerAddress] > 0);
329         uint _dividends = ownerAccounts[_customerAddress];
330         ownerAccounts[_customerAddress] = 0;
331         _customerAddress.transfer(_dividends);
332         // fire event
333         onWithdraw(_customerAddress, _dividends);
334     }
335 
336     function withdrawPart(uint _amount)
337     
338         public
339         onlyOwner()
340     {
341         address _customerAddress = msg.sender;
342         require(ownerAccounts[_customerAddress] > 0);
343         require(_amount <= ownerAccounts[_customerAddress]);
344         ownerAccounts[_customerAddress] = SafeMath.sub(ownerAccounts[_customerAddress],_amount);
345         _customerAddress.transfer(_amount);
346         // fire event
347         onWithdraw(_customerAddress, _amount);
348     }
349 
350 
351     
352 
353      // Fallback function: just send funds back
354 
355     function()
356         payable
357         public
358     {
359         revert();
360     }
361     
362     /**
363      * Transfer Level to another address
364      */
365     function transfer(address _to, uint _level )
366        
367         public
368     {
369         require(levelOwner[nextAvailableLevel] == msg.sender);
370 
371         levelOwner[nextAvailableLevel] = _to;
372 
373         emit Transfer(msg.sender, _to, _level);
374 
375     }
376     
377     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
378     /**
379 
380     /**
381      * If we want to rebrand, we can.
382      */
383     function setName(string _name)
384         onlyOwner()
385         public
386     {
387         name = _name;
388     }
389     
390     /**
391      * If we want to rebrand, we can.
392      */
393     function setSymbol(string _symbol)
394         onlyOwner()
395         public
396     {
397         symbol = _symbol;
398     }
399 
400     function setInitialPrice(uint _price)
401         onlyOwner()
402         public
403     {
404         initialPrice = _price;
405     }
406 
407     function setMaxLevels(uint _level)  
408         onlyOwner()
409         public
410     {
411         maxLevels = _level;
412     }
413 
414     function setLevelPrice(uint _level, uint _price)   //Allow the changing of a level price owner if the dev owns it
415         onlyOwner()
416         public
417     {
418         require(levelOwner[_level] == dev);
419         levelPrice[_level] = _price;
420     }
421     
422     function addNewLevel(uint _price) 
423         onlyOwner()
424         public
425     {
426         require(nextAvailableLevel < maxLevels);
427         levelPrice[nextAvailableLevel] = _price;
428         levelOwner[nextAvailableLevel] = dev;
429         totalLevelDivs[nextAvailableLevel] = 0;
430         nextAvailableLevel = nextAvailableLevel + 1;
431     }
432 
433     function setAllowReferral(bool _allowReferral)   
434         onlyOwner()
435         public
436     {
437         allowReferral = _allowReferral;
438     }
439 
440     function setAutoNewlevel(bool _autoNewLevel)   
441         onlyOwner()
442         public
443     {
444         allowAutoNewLevel = _autoNewLevel;
445     }
446 
447     
448     /*----------  HELPERS AND CALCULATORS  ----------*/
449     /**
450      * Method to view the current Ethereum stored in the contract
451      * Example: totalEthereumBalance()
452      */
453 
454 
455     function getMyBalance()
456         public
457         view
458         returns(uint)
459     {
460         return ownerAccounts[msg.sender];
461     }
462 
463     function getOwnerBalance(address _levelOwner)
464         public
465         view
466         returns(uint)
467     {
468         require(msg.sender == dev);
469         return ownerAccounts[_levelOwner];
470     }
471     
472     function getlevelPrice(uint _level)
473         public
474         view
475         returns(uint)
476     {
477         require(_level <= nextAvailableLevel);
478         return levelPrice[_level];
479     }
480 
481     function getlevelOwner(uint _level)
482         public
483         view
484         returns(address)
485     {
486         require(_level <= nextAvailableLevel);
487         return levelOwner[_level];
488     }
489 
490     function gettotalLevelDivs(uint _level)
491         public
492         view
493         returns(uint)
494     {
495         require(_level <= nextAvailableLevel);
496         return totalLevelDivs[_level];
497     }
498 
499     function getTotalDivsProduced()
500         public
501         view
502         returns(uint)
503     {
504      
505         return totalDivsProduced;
506     }
507 
508     function getTotalLevelValue()
509         public
510         view
511         returns(uint)
512     {
513       
514         return totalLevelValue;
515     }
516 
517     function totalEthereumBalance()
518         public
519         view
520         returns(uint)
521     {
522         return address (this).balance;
523     }
524 
525     function getNextAvailableLevel()
526         public
527         view
528         returns(uint)
529     {
530         return nextAvailableLevel;
531     }
532 
533 }
534 
535 /**
536  * @title SafeMath
537  * @dev Math operations with safety checks that throw on error
538  */
539 library SafeMath {
540 
541     /**
542     * @dev Multiplies two numbers, throws on overflow.
543     */
544     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
545         if (a == 0) {
546             return 0;
547         }
548         uint256 c = a * b;
549         assert(c / a == b);
550         return c;
551     }
552 
553     /**
554     * @dev Integer division of two numbers, truncating the quotient.
555     */
556     function div(uint256 a, uint256 b) internal pure returns (uint256) {
557         // assert(b > 0); // Solidity automatically throws when dividing by 0
558         uint256 c = a / b;
559         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
560         return c;
561     }
562 
563     /**
564     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
565     */
566     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
567         assert(b <= a);
568         return a - b;
569     }
570 
571     /**
572     * @dev Adds two numbers, throws on overflow.
573     */
574     function add(uint256 a, uint256 b) internal pure returns (uint256) {
575         uint256 c = a + b;
576         assert(c >= a);
577         return c;
578     }
579 }