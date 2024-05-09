1 pragma solidity ^0.4.24;
2 
3 contract Bonds {
4     /*=================================
5     =        MODIFIERS        =
6     =================================*/
7 
8     uint ACTIVATION_TIME = 1539302400;
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
89     address promoter;
90 
91     /*=======================================
92     =            PUBLIC FUNCTIONS            =
93     =======================================*/
94     /*
95     * -- APPLICATION ENTRY POINTS --
96     */
97     constructor()
98         public
99     {
100         dev = msg.sender;
101         fundsDividendAddr = 0xBA209A9533FEAFA3c53Bc117Faf3561b5AB6B6f2;
102         promoter = 0xEafE863757a2b2a2c5C3f71988b7D59329d09A78;
103         nextAvailableBond = 13;
104 
105         bondOwner[1] = promoter;
106         bondPrice[1] = 2e18;//initialPrice;
107         bondPreviousPrice[1] = 0;
108 
109         bondOwner[2] = promoter;
110         bondPrice[2] = 15e17;//initialPrice;
111         bondPreviousPrice[2] = 0;
112 
113         bondOwner[3] = promoter;
114         bondPrice[3] = 10e17;//initialPrice;
115         bondPreviousPrice[3] = 0;
116 
117         bondOwner[4] = promoter;
118         bondPrice[4] = 9e17;//initialPrice;
119         bondPreviousPrice[4] = 0;
120 
121         bondOwner[5] = promoter;
122         bondPrice[5] = 8e17;//initialPrice;
123         bondPreviousPrice[5] = 0;
124 
125         bondOwner[6] = promoter;
126         bondPrice[6] = 7e17;//initialPrice;
127         bondPreviousPrice[6] = 0;
128 
129         bondOwner[7] = dev;
130         bondPrice[7] = 6e17;//initialPrice;
131         bondPreviousPrice[7] = 0;
132 
133         bondOwner[8] = dev;
134         bondPrice[8] = 5e17;//initialPrice;
135         bondPreviousPrice[8] = 0;
136 
137         bondOwner[9] = dev;
138         bondPrice[9] = 4e17;//initialPrice;
139         bondPreviousPrice[9] = 0;
140 
141         bondOwner[10] = dev;
142         bondPrice[10] = 3e17;//initialPrice;
143         bondPreviousPrice[10] = 0;
144 
145         bondOwner[11] = dev;
146         bondPrice[11] = 2e17;//initialPrice;
147         bondPreviousPrice[11] = 0;
148 
149         bondOwner[12] = dev;
150         bondPrice[12] = 1e17;//initialPrice;
151         bondPreviousPrice[12] = 0;
152     }
153 
154     function addTotalBondValue(uint _new, uint _old)
155     internal
156     {
157         //uint newPrice = SafeMath.div(SafeMath.mul(_new,bondPriceIncrement),100);
158         totalBondValue = SafeMath.add(totalBondValue, SafeMath.sub(_new,_old));
159     }
160 
161     function buy(uint _bond, address _referrer)
162         isActivated()
163         public
164         payable
165 
166     {
167         require(_bond <= nextAvailableBond);
168         require(msg.value >= bondPrice[_bond]);
169         require(msg.sender != bondOwner[_bond]);
170 
171         uint _newPrice = SafeMath.div(SafeMath.mul(msg.value,bondPriceIncrement),100);
172 
173          //Determine the total dividends
174         uint _baseDividends = msg.value - bondPreviousPrice[_bond];
175         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
176 
177         uint _nsDividends = SafeMath.div(SafeMath.mul(_baseDividends, nsDivRate),100);
178         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends,ownerDivRate),100);
179 
180         totalBondDivs[_bond] = SafeMath.add(totalBondDivs[_bond],_ownerDividends);
181         _ownerDividends = SafeMath.add(_ownerDividends,bondPreviousPrice[_bond]);
182 
183         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends,distDivRate),100);
184 
185 
186         // If referrer is left blank,send to FUND address
187         if (allowReferral && _referrer != msg.sender) {
188             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends, referralRate), 100);
189             _distDividends = SafeMath.sub(_distDividends, _referralDividends);
190 
191             if (_referrer == 0x0) {
192                 fundsDividendAddr.transfer(_referralDividends);
193             }
194             else {
195                 ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer], _referralDividends);
196             }
197         }
198 
199         //distribute dividends to accounts
200         address _previousOwner = bondOwner[_bond];
201         address _newOwner = msg.sender;
202 
203         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner],_ownerDividends);
204         fundsDividendAddr.transfer(_nsDividends);
205 
206         bondOwner[_bond] = _newOwner;
207 
208         distributeYield(_distDividends);
209         distributeBondFund();
210         //Increment the bond Price
211         bondPreviousPrice[_bond] = msg.value;
212         bondPrice[_bond] = _newPrice;
213         addTotalBondValue(_newPrice, bondPreviousPrice[_bond]);
214 
215         emit onBondPurchase(msg.sender, msg.value, _bond, SafeMath.div(SafeMath.mul(msg.value,bondPriceIncrement),100));
216 
217     }
218 
219     function distributeYield(uint _distDividends) internal
220 
221     {
222         uint counter = 1;
223 
224         while (counter < nextAvailableBond) {
225 
226             uint _distAmountLocal = SafeMath.div(SafeMath.mul(_distDividends, bondPrice[counter]),totalBondValue);
227             ownerAccounts[bondOwner[counter]] = SafeMath.add(ownerAccounts[bondOwner[counter]],_distAmountLocal);
228             totalBondDivs[counter] = SafeMath.add(totalBondDivs[counter],_distAmountLocal);
229             counter = counter + 1;
230         }
231 
232     }
233 
234     function distributeBondFund() internal
235 
236     {
237         if(bondFund > 0){
238             uint counter = 1;
239 
240             while (counter < nextAvailableBond) {
241 
242                 uint _distAmountLocal = SafeMath.div(SafeMath.mul(bondFund, bondPrice[counter]),totalBondValue);
243                 ownerAccounts[bondOwner[counter]] = SafeMath.add(ownerAccounts[bondOwner[counter]],_distAmountLocal);
244                 totalBondDivs[counter] = SafeMath.add(totalBondDivs[counter],_distAmountLocal);
245                 counter = counter + 1;
246             }
247             bondFund = 0;
248         }
249     }
250 
251     function extDistributeBondFund() public
252     onlyOwner()
253     {
254         if(bondFund > 0){
255             uint counter = 1;
256 
257             while (counter < nextAvailableBond) {
258 
259                 uint _distAmountLocal = SafeMath.div(SafeMath.mul(bondFund, bondPrice[counter]),totalBondValue);
260                 ownerAccounts[bondOwner[counter]] = SafeMath.add(ownerAccounts[bondOwner[counter]],_distAmountLocal);
261                 totalBondDivs[counter] = SafeMath.add(totalBondDivs[counter],_distAmountLocal);
262                 counter = counter + 1;
263             }
264             bondFund = 0;
265         }
266     }
267 
268 
269     function withdraw()
270 
271         public
272     {
273         address _customerAddress = msg.sender;
274         require(ownerAccounts[_customerAddress] > 0);
275         uint _dividends = ownerAccounts[_customerAddress];
276         ownerAccounts[_customerAddress] = 0;
277         _customerAddress.transfer(_dividends);
278         // fire event
279         emit onWithdraw(_customerAddress, _dividends);
280     }
281 
282     function withdrawPart(uint _amount)
283 
284         public
285         onlyOwner()
286     {
287         address _customerAddress = msg.sender;
288         require(ownerAccounts[_customerAddress] > 0);
289         require(_amount <= ownerAccounts[_customerAddress]);
290         ownerAccounts[_customerAddress] = SafeMath.sub(ownerAccounts[_customerAddress],_amount);
291         _customerAddress.transfer(_amount);
292         // fire event
293         emit onWithdraw(_customerAddress, _amount);
294     }
295 
296      // Fallback function: add funds to the addional distibution amount.   This is what will be contributed from the exchange
297      // and other contracts
298 
299     function()
300         payable
301         public
302     {
303         uint devAmount = SafeMath.div(SafeMath.mul(devDivRate,msg.value),100);
304         uint bondAmount = msg.value - devAmount;
305         bondFund = SafeMath.add(bondFund, bondAmount);
306         ownerAccounts[dev] = SafeMath.add(ownerAccounts[dev], devAmount);
307     }
308 
309     /**
310      * Transfer bond to another address
311      */
312     function transfer(address _to, uint _bond )
313 
314         public
315     {
316         require(bondOwner[_bond] == msg.sender);
317 
318         bondOwner[_bond] = _to;
319 
320         emit Transfer(msg.sender, _to, _bond);
321 
322     }
323 
324     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
325     /**
326 
327     /**
328      * If we want to rebrand, we can.
329      */
330     function setName(string _name)
331         onlyOwner()
332         public
333     {
334         name = _name;
335     }
336 
337     /**
338      * If we want to rebrand, we can.
339      */
340     function setSymbol(string _symbol)
341         onlyOwner()
342         public
343     {
344         symbol = _symbol;
345     }
346 
347     function setInitialPrice(uint _price)
348         onlyOwner()
349         public
350     {
351         initialPrice = _price;
352     }
353 
354     function setMaxbonds(uint _bond)
355         onlyOwner()
356         public
357     {
358         maxBonds = _bond;
359     }
360 
361     function setBondPrice(uint _bond, uint _price)   //Allow the changing of a bond price owner if the dev owns it
362         onlyOwner()
363         public
364     {
365         require(bondOwner[_bond] == dev);
366         bondPrice[_bond] = _price;
367     }
368 
369     function addNewbond(uint _price)
370         onlyOwner()
371         public
372     {
373         require(nextAvailableBond < maxBonds);
374         bondPrice[nextAvailableBond] = _price;
375         bondOwner[nextAvailableBond] = dev;
376         totalBondDivs[nextAvailableBond] = 0;
377         bondPreviousPrice[nextAvailableBond] = 0;
378         nextAvailableBond = nextAvailableBond + 1;
379         addTotalBondValue(_price, 0);
380 
381     }
382 
383     function setAllowReferral(bool _allowReferral)
384         onlyOwner()
385         public
386     {
387         allowReferral = _allowReferral;
388     }
389 
390     function setAutoNewbond(bool _autoNewBond)
391         onlyOwner()
392         public
393     {
394         allowAutoNewBond = _autoNewBond;
395     }
396 
397     /*----------  HELPERS AND CALCULATORS  ----------*/
398     /**
399      * Method to view the current Ethereum stored in the contract
400      * Example: totalEthereumBalance()
401      */
402 
403 
404     function getMyBalance()
405         public
406         view
407         returns(uint)
408     {
409         return ownerAccounts[msg.sender];
410     }
411 
412     function getOwnerBalance(address _bondOwner)
413         public
414         view
415         returns(uint)
416     {
417         require(msg.sender == dev);
418         return ownerAccounts[_bondOwner];
419     }
420 
421     function getBondPrice(uint _bond)
422         public
423         view
424         returns(uint)
425     {
426         require(_bond <= nextAvailableBond);
427         return bondPrice[_bond];
428     }
429 
430     function getBondOwner(uint _bond)
431         public
432         view
433         returns(address)
434     {
435         require(_bond <= nextAvailableBond);
436         return bondOwner[_bond];
437     }
438 
439     function gettotalBondDivs(uint _bond)
440         public
441         view
442         returns(uint)
443     {
444         require(_bond <= nextAvailableBond);
445         return totalBondDivs[_bond];
446     }
447 
448     function getTotalDivsProduced()
449         public
450         view
451         returns(uint)
452     {
453 
454         return totalDivsProduced;
455     }
456 
457     function getBondDivShare(uint _bond)
458     public
459     view
460     returns(uint)
461     {
462         require(_bond <= nextAvailableBond);
463         return SafeMath.div(SafeMath.mul(bondPrice[_bond],10000),totalBondValue);
464     }
465 
466     function getTotalBondValue()
467         public
468         view
469         returns(uint)
470     {
471 
472         return totalBondValue;
473     }
474 
475     function totalEthereumBalance()
476         public
477         view
478         returns(uint)
479     {
480         return address (this).balance;
481     }
482 
483     function getNextAvailableBond()
484         public
485         view
486         returns(uint)
487     {
488         return nextAvailableBond;
489     }
490 
491 }
492 
493 /**
494  * @title SafeMath
495  * @dev Math operations with safety checks that throw on error
496  */
497 library SafeMath {
498 
499     /**
500     * @dev Multiplies two numbers, throws on overflow.
501     */
502     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
503         if (a == 0) {
504             return 0;
505         }
506         uint256 c = a * b;
507         assert(c / a == b);
508         return c;
509     }
510 
511     /**
512     * @dev Integer division of two numbers, truncating the quotient.
513     */
514     function div(uint256 a, uint256 b) internal pure returns (uint256) {
515         // assert(b > 0); // Solidity automatically throws when dividing by 0
516         uint256 c = a / b;
517         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
518         return c;
519     }
520 
521     /**
522     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
523     */
524     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
525         assert(b <= a);
526         return a - b;
527     }
528 
529     /**
530     * @dev Adds two numbers, throws on overflow.
531     */
532     function add(uint256 a, uint256 b) internal pure returns (uint256) {
533         uint256 c = a + b;
534         assert(c >= a);
535         return c;
536     }
537 }