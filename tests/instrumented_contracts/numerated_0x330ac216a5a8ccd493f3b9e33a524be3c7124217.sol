1 pragma solidity ^0.4.24;
2 
3 contract Bonds {
4     /*=================================
5     =        MODIFIERS        =
6     =================================*/
7 
8     modifier onlyOwner(){
9 
10         require(msg.sender == dev);
11         _;
12     }
13 
14 
15     /*==============================
16     =            EVENTS            =
17     ==============================*/
18     event onBondPurchase(
19         address customerAddress,
20         uint256 incomingEthereum,
21         uint256 bond,
22         uint256 newPrice
23     );
24 
25     event onWithdraw(
26         address customerAddress,
27         uint256 ethereumWithdrawn
28     );
29 
30     // ERC20
31     event Transfer(
32         address from,
33         address to,
34         uint256 bond
35     );
36 
37 
38     /*=====================================
39     =            CONFIGURABLES            =
40     =====================================*/
41     string public name = "NASDAQBONDS";
42     string public symbol = "BOND";
43 
44     uint8 constant public nsDivRate = 10;
45     uint8 constant public devDivRate = 5;
46     uint8 constant public ownerDivRate = 50;
47     uint8 constant public distDivRate = 40;
48     uint8 constant public referralRate = 5;
49 
50     uint8 constant public decimals = 18;
51 
52     uint public totalBondValue = 9e18;
53 
54 
55    /*================================
56     =            DATASETS            =
57     ================================*/
58 
59     mapping(uint => address) internal bondOwner;
60     mapping(uint => uint) public bondPrice;
61     mapping(uint => uint) internal bondPreviousPrice;
62     mapping(address => uint) internal ownerAccounts;
63     mapping(uint => uint) internal totalBondDivs;
64     mapping(uint => string) internal bondName;
65 
66     uint bondPriceIncrement = 110;   //10% Price Increases
67     uint totalDivsProduced = 0;
68 
69     uint public maxBonds = 200;
70 
71     uint public initialPrice = 1e17;   //0.1 ETH
72 
73     uint public nextAvailableBond;
74 
75     bool allowReferral = false;
76 
77     bool allowAutoNewBond = false;
78 
79     uint public bondFund = 0;
80 
81     address dev;
82     address fundsDividendAddr;
83     address promoter;
84 
85     /*=======================================
86     =            PUBLIC FUNCTIONS            =
87     =======================================*/
88     /*
89     * -- APPLICATION ENTRY POINTS --
90     */
91     constructor()
92         public
93     {
94         dev = msg.sender;
95         fundsDividendAddr = 0xd2e32AFc2949d37A221FBAe53DadF48270926F26;
96         promoter = 0xC558895aE123BB02b3c33164FdeC34E9Fb66B660;
97         nextAvailableBond = 13;
98 
99         bondOwner[1] = promoter;
100         bondPrice[1] = 2e18;//initialPrice;
101         bondPreviousPrice[1] = 0;
102 
103         bondOwner[2] = promoter;
104         bondPrice[2] = 15e17;//initialPrice;
105         bondPreviousPrice[2] = 0;
106 
107         bondOwner[3] = promoter;
108         bondPrice[3] = 10e17;//initialPrice;
109         bondPreviousPrice[3] = 0;
110 
111         bondOwner[4] = promoter;
112         bondPrice[4] = 9e17;//initialPrice;
113         bondPreviousPrice[4] = 0;
114 
115         bondOwner[5] = promoter;
116         bondPrice[5] = 8e17;//initialPrice;
117         bondPreviousPrice[5] = 0;
118 
119         bondOwner[6] = promoter;
120         bondPrice[6] = 7e17;//initialPrice;
121         bondPreviousPrice[6] = 0;
122 
123         bondOwner[7] = dev;
124         bondPrice[7] = 6e17;//initialPrice;
125         bondPreviousPrice[7] = 0;
126 
127         bondOwner[8] = dev;
128         bondPrice[8] = 5e17;//initialPrice;
129         bondPreviousPrice[8] = 0;
130 
131         bondOwner[9] = dev;
132         bondPrice[9] = 4e17;//initialPrice;
133         bondPreviousPrice[9] = 0;
134 
135         bondOwner[10] = dev;
136         bondPrice[10] = 3e17;//initialPrice;
137         bondPreviousPrice[10] = 0;
138 
139         bondOwner[11] = dev;
140         bondPrice[11] = 2e17;//initialPrice;
141         bondPreviousPrice[11] = 0;
142 
143         bondOwner[12] = dev;
144         bondPrice[12] = 1e17;//initialPrice;
145         bondPreviousPrice[12] = 0;
146     }
147 
148     function addTotalBondValue(uint _new, uint _old)
149     internal
150     {
151         //uint newPrice = SafeMath.div(SafeMath.mul(_new,bondPriceIncrement),100);
152         totalBondValue = SafeMath.add(totalBondValue, SafeMath.sub(_new,_old));
153     }
154 
155     function buy(uint _bond, address _referrer)
156         public
157         payable
158 
159     {
160         require(_bond <= nextAvailableBond);
161         require(msg.value >= bondPrice[_bond]);
162         require(msg.sender != bondOwner[_bond]);
163 
164         uint _newPrice = SafeMath.div(SafeMath.mul(msg.value,bondPriceIncrement),100);
165 
166          //Determine the total dividends
167         uint _baseDividends = msg.value - bondPreviousPrice[_bond];
168         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
169 
170         uint _nsDividends = SafeMath.div(SafeMath.mul(_baseDividends, nsDivRate),100);
171         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends,ownerDivRate),100);
172 
173         totalBondDivs[_bond] = SafeMath.add(totalBondDivs[_bond],_ownerDividends);
174         _ownerDividends = SafeMath.add(_ownerDividends,bondPreviousPrice[_bond]);
175 
176         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends,distDivRate),100);
177 
178 
179         // If referrer is left blank,send to FUND address
180         if (allowReferral && _referrer != msg.sender) {
181             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends, referralRate), 100);
182             _distDividends = SafeMath.sub(_distDividends, _referralDividends);
183 
184             if (_referrer == 0x0) {
185                 fundsDividendAddr.transfer(_referralDividends);
186             }
187             else {
188                 ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer], _referralDividends);
189             }
190         }
191 
192         //distribute dividends to accounts
193         address _previousOwner = bondOwner[_bond];
194         address _newOwner = msg.sender;
195 
196         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner],_ownerDividends);
197         fundsDividendAddr.transfer(_nsDividends);
198 
199         bondOwner[_bond] = _newOwner;
200 
201         distributeYield(_distDividends);
202         distributeBondFund();
203         //Increment the bond Price
204         bondPreviousPrice[_bond] = msg.value;
205         bondPrice[_bond] = _newPrice;
206         addTotalBondValue(_newPrice, bondPreviousPrice[_bond]);
207 
208         emit onBondPurchase(msg.sender, msg.value, _bond, SafeMath.div(SafeMath.mul(msg.value,bondPriceIncrement),100));
209 
210     }
211 
212     function distributeYield(uint _distDividends) internal
213 
214     {
215         uint counter = 1;
216 
217         while (counter < nextAvailableBond) {
218 
219             uint _distAmountLocal = SafeMath.div(SafeMath.mul(_distDividends, bondPrice[counter]),totalBondValue);
220             ownerAccounts[bondOwner[counter]] = SafeMath.add(ownerAccounts[bondOwner[counter]],_distAmountLocal);
221             totalBondDivs[counter] = SafeMath.add(totalBondDivs[counter],_distAmountLocal);
222             counter = counter + 1;
223         }
224 
225     }
226 
227     function distributeBondFund() internal
228 
229     {
230         if(bondFund > 0){
231             uint counter = 1;
232 
233             while (counter < nextAvailableBond) {
234 
235                 uint _distAmountLocal = SafeMath.div(SafeMath.mul(bondFund, bondPrice[counter]),totalBondValue);
236                 ownerAccounts[bondOwner[counter]] = SafeMath.add(ownerAccounts[bondOwner[counter]],_distAmountLocal);
237                 totalBondDivs[counter] = SafeMath.add(totalBondDivs[counter],_distAmountLocal);
238                 counter = counter + 1;
239             }
240             bondFund = 0;
241         }
242     }
243 
244     function extDistributeBondFund() public
245     onlyOwner()
246     {
247         if(bondFund > 0){
248             uint counter = 1;
249 
250             while (counter < nextAvailableBond) {
251 
252                 uint _distAmountLocal = SafeMath.div(SafeMath.mul(bondFund, bondPrice[counter]),totalBondValue);
253                 ownerAccounts[bondOwner[counter]] = SafeMath.add(ownerAccounts[bondOwner[counter]],_distAmountLocal);
254                 totalBondDivs[counter] = SafeMath.add(totalBondDivs[counter],_distAmountLocal);
255                 counter = counter + 1;
256             }
257             bondFund = 0;
258         }
259     }
260 
261 
262     function withdraw()
263 
264         public
265     {
266         address _customerAddress = msg.sender;
267         require(ownerAccounts[_customerAddress] > 0);
268         uint _dividends = ownerAccounts[_customerAddress];
269         ownerAccounts[_customerAddress] = 0;
270         _customerAddress.transfer(_dividends);
271         // fire event
272         emit onWithdraw(_customerAddress, _dividends);
273     }
274 
275     function withdrawPart(uint _amount)
276 
277         public
278         onlyOwner()
279     {
280         address _customerAddress = msg.sender;
281         require(ownerAccounts[_customerAddress] > 0);
282         require(_amount <= ownerAccounts[_customerAddress]);
283         ownerAccounts[_customerAddress] = SafeMath.sub(ownerAccounts[_customerAddress],_amount);
284         _customerAddress.transfer(_amount);
285         // fire event
286         emit onWithdraw(_customerAddress, _amount);
287     }
288 
289      // Fallback function: add funds to the addional distibution amount.   This is what will be contributed from the exchange
290      // and other contracts
291 
292     function()
293         payable
294         public
295     {
296         uint devAmount = SafeMath.div(SafeMath.mul(devDivRate,msg.value),100);
297         uint bondAmount = msg.value - devAmount;
298         bondFund = SafeMath.add(bondFund, bondAmount);
299         ownerAccounts[dev] = SafeMath.add(ownerAccounts[dev], devAmount);
300     }
301 
302     /**
303      * Transfer bond to another address
304      */
305     function transfer(address _to, uint _bond )
306 
307         public
308     {
309         require(bondOwner[_bond] == msg.sender);
310 
311         bondOwner[_bond] = _to;
312 
313         emit Transfer(msg.sender, _to, _bond);
314 
315     }
316 
317     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
318     /**
319 
320     /**
321      * If we want to rebrand, we can.
322      */
323     function setName(string _name)
324         onlyOwner()
325         public
326     {
327         name = _name;
328     }
329 
330     /**
331      * If we want to rebrand, we can.
332      */
333     function setSymbol(string _symbol)
334         onlyOwner()
335         public
336     {
337         symbol = _symbol;
338     }
339 
340     function setInitialPrice(uint _price)
341         onlyOwner()
342         public
343     {
344         initialPrice = _price;
345     }
346 
347     function setMaxbonds(uint _bond)
348         onlyOwner()
349         public
350     {
351         maxBonds = _bond;
352     }
353 
354     function setBondPrice(uint _bond, uint _price)   //Allow the changing of a bond price owner if the dev owns it
355         onlyOwner()
356         public
357     {
358         require(bondOwner[_bond] == dev);
359         bondPrice[_bond] = _price;
360     }
361 
362     function addNewbond(uint _price)
363         onlyOwner()
364         public
365     {
366         require(nextAvailableBond < maxBonds);
367         bondPrice[nextAvailableBond] = _price;
368         bondOwner[nextAvailableBond] = dev;
369         totalBondDivs[nextAvailableBond] = 0;
370         bondPreviousPrice[nextAvailableBond] = 0;
371         nextAvailableBond = nextAvailableBond + 1;
372         addTotalBondValue(_price, 0);
373 
374     }
375 
376     function setAllowReferral(bool _allowReferral)
377         onlyOwner()
378         public
379     {
380         allowReferral = _allowReferral;
381     }
382 
383     function setAutoNewbond(bool _autoNewBond)
384         onlyOwner()
385         public
386     {
387         allowAutoNewBond = _autoNewBond;
388     }
389 
390     /*----------  HELPERS AND CALCULATORS  ----------*/
391     /**
392      * Method to view the current Ethereum stored in the contract
393      * Example: totalEthereumBalance()
394      */
395 
396 
397     function getMyBalance()
398         public
399         view
400         returns(uint)
401     {
402         return ownerAccounts[msg.sender];
403     }
404 
405     function getOwnerBalance(address _bondOwner)
406         public
407         view
408         returns(uint)
409     {
410         require(msg.sender == dev);
411         return ownerAccounts[_bondOwner];
412     }
413 
414     function getBondPrice(uint _bond)
415         public
416         view
417         returns(uint)
418     {
419         require(_bond <= nextAvailableBond);
420         return bondPrice[_bond];
421     }
422 
423     function getBondOwner(uint _bond)
424         public
425         view
426         returns(address)
427     {
428         require(_bond <= nextAvailableBond);
429         return bondOwner[_bond];
430     }
431 
432     function gettotalBondDivs(uint _bond)
433         public
434         view
435         returns(uint)
436     {
437         require(_bond <= nextAvailableBond);
438         return totalBondDivs[_bond];
439     }
440 
441     function getTotalDivsProduced()
442         public
443         view
444         returns(uint)
445     {
446 
447         return totalDivsProduced;
448     }
449 
450     function getBondDivShare(uint _bond)
451     public
452     view
453     returns(uint)
454     {
455         require(_bond <= nextAvailableBond);
456         return SafeMath.div(SafeMath.mul(bondPrice[_bond],10000),totalBondValue);
457     }
458 
459     function getTotalBondValue()
460         public
461         view
462         returns(uint)
463     {
464 
465         return totalBondValue;
466     }
467 
468     function totalEthereumBalance()
469         public
470         view
471         returns(uint)
472     {
473         return address (this).balance;
474     }
475 
476     function getNextAvailableBond()
477         public
478         view
479         returns(uint)
480     {
481         return nextAvailableBond;
482     }
483 
484 }
485 
486 /**
487  * @title SafeMath
488  * @dev Math operations with safety checks that throw on error
489  */
490 library SafeMath {
491 
492     /**
493     * @dev Multiplies two numbers, throws on overflow.
494     */
495     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
496         if (a == 0) {
497             return 0;
498         }
499         uint256 c = a * b;
500         assert(c / a == b);
501         return c;
502     }
503 
504     /**
505     * @dev Integer division of two numbers, truncating the quotient.
506     */
507     function div(uint256 a, uint256 b) internal pure returns (uint256) {
508         // assert(b > 0); // Solidity automatically throws when dividing by 0
509         uint256 c = a / b;
510         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
511         return c;
512     }
513 
514     /**
515     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
516     */
517     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
518         assert(b <= a);
519         return a - b;
520     }
521 
522     /**
523     * @dev Adds two numbers, throws on overflow.
524     */
525     function add(uint256 a, uint256 b) internal pure returns (uint256) {
526         uint256 c = a + b;
527         assert(c >= a);
528         return c;
529     }
530 }