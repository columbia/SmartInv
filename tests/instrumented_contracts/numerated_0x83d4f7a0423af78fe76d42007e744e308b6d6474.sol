1 pragma solidity ^0.4.24;
2 
3 contract Bonds {
4     /*=================================
5     =        MODIFIERS        =
6     =================================*/
7 
8     uint ACTIVATION_TIME = 1540213200;
9 
10     modifier onlyOwner(){
11         require(msg.sender == dev);
12         _;
13     }
14 
15     modifier isActivated(){
16         require(now >= ACTIVATION_TIME);
17         _;
18     }
19 
20 
21     /*==============================
22     =            EVENTS            =
23     ==============================*/
24     event onBondPurchase(
25         address customerAddress,
26         uint256 incomingEthereum,
27         uint256 bond,
28         uint256 newPrice
29     );
30 
31     event onWithdraw(
32         address customerAddress,
33         uint256 ethereumWithdrawn
34     );
35 
36     // ERC20
37     event Transfer(
38         address from,
39         address to,
40         uint256 bond
41     );
42 
43 
44     /*=====================================
45     =            CONFIGURABLES            =
46     =====================================*/
47     string public name = "BONDS";
48     string public symbol = "BOND";
49 
50     uint8 constant public nsDivRate = 10;
51     uint8 constant public devDivRate = 5;
52     uint8 constant public ownerDivRate = 50;
53     uint8 constant public distDivRate = 40;
54     uint8 constant public referralRate = 5;
55 
56     uint8 constant public decimals = 18;
57 
58     uint public totalBondValue = 9e18;
59 
60 
61    /*================================
62     =            DATASETS            =
63     ================================*/
64 
65     mapping(uint => address) internal bondOwner;
66     mapping(uint => uint) public bondPrice;
67     mapping(uint => uint) internal bondPreviousPrice;
68     mapping(address => uint) internal ownerAccounts;
69     mapping(uint => uint) internal totalBondDivs;
70     mapping(uint => string) internal bondName;
71 
72     uint bondPriceIncrement = 110;   //10% Price Increases
73     uint totalDivsProduced = 0;
74 
75     uint public maxBonds = 200;
76 
77     uint public initialPrice = 1e17;   //0.1 ETH
78 
79     uint public nextAvailableBond;
80 
81     bool allowReferral = false;
82 
83     bool allowAutoNewBond = false;
84 
85     uint public bondFund = 0;
86 
87     address dev;
88     address fundsDividendAddr;
89     address promoter1;
90     address promoter2;
91     address promoter3;
92 
93     /*=======================================
94     =            PUBLIC FUNCTIONS            =
95     =======================================*/
96     /*
97     * -- APPLICATION ENTRY POINTS --
98     */
99     constructor()
100         public
101     {
102         dev = msg.sender;
103         fundsDividendAddr = 0xBA209A9533FEAFA3c53Bc117Faf3561b5AB6B6f2;
104         promoter1 = 0xEc31176d4df0509115abC8065A8a3F8275aafF2b;
105         promoter2 = 0xEafE863757a2b2a2c5C3f71988b7D59329d09A78;
106         promoter3 = 0x4ffE17a2A72bC7422CB176bC71c04EE6D87cE329;
107         nextAvailableBond = 13;
108 
109         bondOwner[1] = dev;
110         bondPrice[1] = 2e18;//initialPrice;
111         bondPreviousPrice[1] = 0;
112 
113         bondOwner[2] = dev;
114         bondPrice[2] = 15e17;//initialPrice;
115         bondPreviousPrice[2] = 0;
116 
117         bondOwner[3] = dev;
118         bondPrice[3] = 10e17;//initialPrice;
119         bondPreviousPrice[3] = 0;
120 
121         bondOwner[4] = promoter1;
122         bondPrice[4] = 9e17;//initialPrice;
123         bondPreviousPrice[4] = 0;
124 
125         bondOwner[5] = promoter1;
126         bondPrice[5] = 8e17;//initialPrice;
127         bondPreviousPrice[5] = 0;
128 
129         bondOwner[6] = promoter1;
130         bondPrice[6] = 7e17;//initialPrice;
131         bondPreviousPrice[6] = 0;
132 
133         bondOwner[7] = promoter2;
134         bondPrice[7] = 6e17;//initialPrice;
135         bondPreviousPrice[7] = 0;
136 
137         bondOwner[8] = promoter2;
138         bondPrice[8] = 5e17;//initialPrice;
139         bondPreviousPrice[8] = 0;
140 
141         bondOwner[9] = promoter2;
142         bondPrice[9] = 4e17;//initialPrice;
143         bondPreviousPrice[9] = 0;
144 
145         bondOwner[10] = promoter3;
146         bondPrice[10] = 3e17;//initialPrice;
147         bondPreviousPrice[10] = 0;
148 
149         bondOwner[11] = promoter3;
150         bondPrice[11] = 2e17;//initialPrice;
151         bondPreviousPrice[11] = 0;
152 
153         bondOwner[12] = promoter3;
154         bondPrice[12] = 1e17;//initialPrice;
155         bondPreviousPrice[12] = 0;
156     }
157 
158     function addTotalBondValue(uint _new, uint _old)
159     internal
160     {
161         //uint newPrice = SafeMath.div(SafeMath.mul(_new,bondPriceIncrement),100);
162         totalBondValue = SafeMath.add(totalBondValue, SafeMath.sub(_new,_old));
163     }
164 
165     function buy(uint _bond, address _referrer)
166         isActivated()
167         public
168         payable
169 
170     {
171         require(_bond <= nextAvailableBond);
172         require(msg.value >= bondPrice[_bond]);
173         require(msg.sender != bondOwner[_bond]);
174 
175         uint _newPrice = SafeMath.div(SafeMath.mul(msg.value,bondPriceIncrement),100);
176 
177          //Determine the total dividends
178         uint _baseDividends = msg.value - bondPreviousPrice[_bond];
179         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
180 
181         uint _nsDividends = SafeMath.div(SafeMath.mul(_baseDividends, nsDivRate),100);
182         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends,ownerDivRate),100);
183 
184         totalBondDivs[_bond] = SafeMath.add(totalBondDivs[_bond],_ownerDividends);
185         _ownerDividends = SafeMath.add(_ownerDividends,bondPreviousPrice[_bond]);
186 
187         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends,distDivRate),100);
188 
189 
190         // If referrer is left blank,send to FUND address
191         if (allowReferral && _referrer != msg.sender) {
192             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends, referralRate), 100);
193             _distDividends = SafeMath.sub(_distDividends, _referralDividends);
194 
195             if (_referrer == 0x0) {
196                 fundsDividendAddr.transfer(_referralDividends);
197             }
198             else {
199                 ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer], _referralDividends);
200             }
201         }
202 
203         //distribute dividends to accounts
204         address _previousOwner = bondOwner[_bond];
205         address _newOwner = msg.sender;
206 
207         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner],_ownerDividends);
208         fundsDividendAddr.transfer(_nsDividends);
209 
210         bondOwner[_bond] = _newOwner;
211 
212         distributeYield(_distDividends);
213         distributeBondFund();
214         //Increment the bond Price
215         bondPreviousPrice[_bond] = msg.value;
216         bondPrice[_bond] = _newPrice;
217         addTotalBondValue(_newPrice, bondPreviousPrice[_bond]);
218 
219         emit onBondPurchase(msg.sender, msg.value, _bond, SafeMath.div(SafeMath.mul(msg.value,bondPriceIncrement),100));
220 
221     }
222 
223     function distributeYield(uint _distDividends) internal
224 
225     {
226         uint counter = 1;
227 
228         while (counter < nextAvailableBond) {
229 
230             uint _distAmountLocal = SafeMath.div(SafeMath.mul(_distDividends, bondPrice[counter]),totalBondValue);
231             ownerAccounts[bondOwner[counter]] = SafeMath.add(ownerAccounts[bondOwner[counter]],_distAmountLocal);
232             totalBondDivs[counter] = SafeMath.add(totalBondDivs[counter],_distAmountLocal);
233             counter = counter + 1;
234         }
235 
236     }
237 
238     function distributeBondFund() internal
239 
240     {
241         if(bondFund > 0){
242             uint counter = 1;
243 
244             while (counter < nextAvailableBond) {
245 
246                 uint _distAmountLocal = SafeMath.div(SafeMath.mul(bondFund, bondPrice[counter]),totalBondValue);
247                 ownerAccounts[bondOwner[counter]] = SafeMath.add(ownerAccounts[bondOwner[counter]],_distAmountLocal);
248                 totalBondDivs[counter] = SafeMath.add(totalBondDivs[counter],_distAmountLocal);
249                 counter = counter + 1;
250             }
251             bondFund = 0;
252         }
253     }
254 
255     function extDistributeBondFund() public
256     onlyOwner()
257     {
258         if(bondFund > 0){
259             uint counter = 1;
260 
261             while (counter < nextAvailableBond) {
262 
263                 uint _distAmountLocal = SafeMath.div(SafeMath.mul(bondFund, bondPrice[counter]),totalBondValue);
264                 ownerAccounts[bondOwner[counter]] = SafeMath.add(ownerAccounts[bondOwner[counter]],_distAmountLocal);
265                 totalBondDivs[counter] = SafeMath.add(totalBondDivs[counter],_distAmountLocal);
266                 counter = counter + 1;
267             }
268             bondFund = 0;
269         }
270     }
271 
272 
273     function withdraw()
274 
275         public
276     {
277         address _customerAddress = msg.sender;
278         require(ownerAccounts[_customerAddress] > 0);
279         uint _dividends = ownerAccounts[_customerAddress];
280         ownerAccounts[_customerAddress] = 0;
281         _customerAddress.transfer(_dividends);
282         // fire event
283         emit onWithdraw(_customerAddress, _dividends);
284     }
285 
286     function withdrawPart(uint _amount)
287 
288         public
289         onlyOwner()
290     {
291         address _customerAddress = msg.sender;
292         require(ownerAccounts[_customerAddress] > 0);
293         require(_amount <= ownerAccounts[_customerAddress]);
294         ownerAccounts[_customerAddress] = SafeMath.sub(ownerAccounts[_customerAddress],_amount);
295         _customerAddress.transfer(_amount);
296         // fire event
297         emit onWithdraw(_customerAddress, _amount);
298     }
299 
300      // Fallback function: add funds to the addional distibution amount.   This is what will be contributed from the exchange
301      // and other contracts
302 
303     function()
304         payable
305         public
306     {
307         uint devAmount = SafeMath.div(SafeMath.mul(devDivRate,msg.value),100);
308         uint bondAmount = msg.value - devAmount;
309         bondFund = SafeMath.add(bondFund, bondAmount);
310         ownerAccounts[dev] = SafeMath.add(ownerAccounts[dev], devAmount);
311     }
312 
313     /**
314      * Transfer bond to another address
315      */
316     function transfer(address _to, uint _bond )
317 
318         public
319     {
320         require(bondOwner[_bond] == msg.sender);
321 
322         bondOwner[_bond] = _to;
323 
324         emit Transfer(msg.sender, _to, _bond);
325 
326     }
327 
328     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
329     /**
330 
331     /**
332      * If we want to rebrand, we can.
333      */
334     function setName(string _name)
335         onlyOwner()
336         public
337     {
338         name = _name;
339     }
340 
341     /**
342      * If we want to rebrand, we can.
343      */
344     function setSymbol(string _symbol)
345         onlyOwner()
346         public
347     {
348         symbol = _symbol;
349     }
350 
351     function setInitialPrice(uint _price)
352         onlyOwner()
353         public
354     {
355         initialPrice = _price;
356     }
357 
358     function setMaxbonds(uint _bond)
359         onlyOwner()
360         public
361     {
362         maxBonds = _bond;
363     }
364 
365     function setBondPrice(uint _bond, uint _price)   //Allow the changing of a bond price owner if the dev owns it
366         onlyOwner()
367         public
368     {
369         require(bondOwner[_bond] == dev);
370         bondPrice[_bond] = _price;
371     }
372 
373     function addNewbond(uint _price)
374         onlyOwner()
375         public
376     {
377         require(nextAvailableBond < maxBonds);
378         bondPrice[nextAvailableBond] = _price;
379         bondOwner[nextAvailableBond] = dev;
380         totalBondDivs[nextAvailableBond] = 0;
381         bondPreviousPrice[nextAvailableBond] = 0;
382         nextAvailableBond = nextAvailableBond + 1;
383         addTotalBondValue(_price, 0);
384 
385     }
386 
387     function setAllowReferral(bool _allowReferral)
388         onlyOwner()
389         public
390     {
391         allowReferral = _allowReferral;
392     }
393 
394     function setAutoNewbond(bool _autoNewBond)
395         onlyOwner()
396         public
397     {
398         allowAutoNewBond = _autoNewBond;
399     }
400 
401     /*----------  HELPERS AND CALCULATORS  ----------*/
402     /**
403      * Method to view the current Ethereum stored in the contract
404      * Example: totalEthereumBalance()
405      */
406 
407 
408     function getMyBalance()
409         public
410         view
411         returns(uint)
412     {
413         return ownerAccounts[msg.sender];
414     }
415 
416     function getOwnerBalance(address _bondOwner)
417         public
418         view
419         returns(uint)
420     {
421         require(msg.sender == dev);
422         return ownerAccounts[_bondOwner];
423     }
424 
425     function getBondPrice(uint _bond)
426         public
427         view
428         returns(uint)
429     {
430         require(_bond <= nextAvailableBond);
431         return bondPrice[_bond];
432     }
433 
434     function getBondOwner(uint _bond)
435         public
436         view
437         returns(address)
438     {
439         require(_bond <= nextAvailableBond);
440         return bondOwner[_bond];
441     }
442 
443     function gettotalBondDivs(uint _bond)
444         public
445         view
446         returns(uint)
447     {
448         require(_bond <= nextAvailableBond);
449         return totalBondDivs[_bond];
450     }
451 
452     function getTotalDivsProduced()
453         public
454         view
455         returns(uint)
456     {
457 
458         return totalDivsProduced;
459     }
460 
461     function getBondDivShare(uint _bond)
462     public
463     view
464     returns(uint)
465     {
466         require(_bond <= nextAvailableBond);
467         return SafeMath.div(SafeMath.mul(bondPrice[_bond],10000),totalBondValue);
468     }
469 
470     function getTotalBondValue()
471         public
472         view
473         returns(uint)
474     {
475 
476         return totalBondValue;
477     }
478 
479     function totalEthereumBalance()
480         public
481         view
482         returns(uint)
483     {
484         return address (this).balance;
485     }
486 
487     function getNextAvailableBond()
488         public
489         view
490         returns(uint)
491     {
492         return nextAvailableBond;
493     }
494 
495 }
496 
497 /**
498  * @title SafeMath
499  * @dev Math operations with safety checks that throw on error
500  */
501 library SafeMath {
502 
503     /**
504     * @dev Multiplies two numbers, throws on overflow.
505     */
506     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
507         if (a == 0) {
508             return 0;
509         }
510         uint256 c = a * b;
511         assert(c / a == b);
512         return c;
513     }
514 
515     /**
516     * @dev Integer division of two numbers, truncating the quotient.
517     */
518     function div(uint256 a, uint256 b) internal pure returns (uint256) {
519         // assert(b > 0); // Solidity automatically throws when dividing by 0
520         uint256 c = a / b;
521         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
522         return c;
523     }
524 
525     /**
526     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
527     */
528     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
529         assert(b <= a);
530         return a - b;
531     }
532 
533     /**
534     * @dev Adds two numbers, throws on overflow.
535     */
536     function add(uint256 a, uint256 b) internal pure returns (uint256) {
537         uint256 c = a + b;
538         assert(c >= a);
539         return c;
540     }
541 }