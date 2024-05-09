1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 * 
6 */
7 
8 contract DailyDivsCardGame {
9     /*=================================
10     =        MODIFIERS        =
11     =================================*/
12 
13 
14 
15     modifier onlyOwner(){
16 
17         require(msg.sender == dev);
18         _;
19     }
20 
21 
22     /*==============================
23     =            EVENTS            =
24     ==============================*/
25     event oncardPurchase(
26         address customerAddress,
27         uint256 incomingEthereum,
28         uint256 card,
29         uint256 newPrice
30     );
31 
32     event onWithdraw(
33         address customerAddress,
34         uint256 ethereumWithdrawn
35     );
36 
37     // ERC20
38     event Transfer(
39         address from,
40         address to,
41         uint256 card
42     );
43 
44 
45     /*=====================================
46     =            CONFIGURABLES            =
47     =====================================*/
48     string public name = "DIVIDEND CARDS";
49     string public symbol = "DIVCARD";
50 
51     uint8 constant public cardsDivRate = 10;
52     uint8 constant public ownerDivRate = 50;
53     uint8 constant public distDivRate = 40;
54     uint8 constant public referralRate = 5;
55     uint8 constant public decimals = 18;
56     uint public totalCardValue = 9.75 ether; // Make sure this is sum of constructor values
57     uint public precisionFactor = 9;
58 
59 
60    /*================================
61     =            DATASETS            =
62     ================================*/
63 
64     mapping(uint => address) internal cardOwner;
65     mapping(uint => uint) public cardPrice;
66     mapping(uint => uint) internal cardPreviousPrice;
67     mapping(address => uint) internal ownerAccounts;
68     mapping(uint => uint) internal totalCardDivs;
69 
70     uint cardPriceIncrement = 110;
71     uint totalDivsProduced = 0;
72 
73     uint public totalCards;
74 
75     bool allowReferral = true;
76 
77     address dev;
78     address promoter;
79     address promoter2;
80     address promoter3;
81     address supporter1;
82     address ddtDivsAddr;
83 
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
95         promoter = 0x3C0119B400834a5e9c24b6B654B85bF77283f9e5;
96         promoter2 = 0x642e0ce9ae8c0d8007e0acaf82c8d716ff8c74c1;
97         promoter3 = 0x4A42500b817439cF9B10b4d3edf68bb63Ed0A89B;
98         supporter1 = 0x12b353d1a2842d2272ab5a18c6814d69f4296873;
99         ddtDivsAddr = 0x93c5371707D2e015aEB94DeCBC7892eC1fa8dd80;
100 
101         totalCards = 12;
102 
103         cardOwner[0] = dev;
104         cardPrice[0] = 4 ether;
105         cardPreviousPrice[0] = cardPrice[0];
106 
107         cardOwner[1] = dev;
108         cardPrice[1] = 2 ether;
109         cardPreviousPrice[1] = cardPrice[1];
110 
111         cardOwner[2] = promoter3;
112         cardPrice[2] = 1 ether;
113         cardPreviousPrice[2] = cardPrice[2];
114 
115         cardOwner[3] = promoter2;
116         cardPrice[3] = 0.9 ether;
117         cardPreviousPrice[3] = cardPrice[3];
118 
119         cardOwner[4] = dev;
120         cardPrice[4] = 0.75 ether;
121         cardPreviousPrice[4] = cardPrice[4];
122 
123         cardOwner[5] = promoter;
124         cardPrice[5] = 0.50 ether;
125         cardPreviousPrice[5] = cardPrice[5];
126 
127         cardOwner[6] = supporter1;
128         cardPrice[6] = 0.25 ether;
129         cardPreviousPrice[6] = cardPrice[6];
130 
131         cardOwner[7] = dev;
132         cardPrice[7] = 0.12 ether;
133         cardPreviousPrice[7] = cardPrice[7];
134 
135         cardOwner[8] = dev;
136         cardPrice[8] = 0.08 ether;
137         cardPreviousPrice[8] = cardPrice[8];
138 
139         cardOwner[9] = dev;
140         cardPrice[9] = 0.05 ether;
141         cardPreviousPrice[9] = cardPrice[9];
142 
143         cardOwner[10] = dev;
144         cardPrice[10] = 0.05 ether;
145         cardPreviousPrice[10] = cardPrice[10];
146 
147         cardOwner[11] = dev;
148         cardPrice[11] = 0.05 ether;
149         cardPreviousPrice[11] = cardPrice[11];
150 
151     }
152 
153     function addtotalCardValue(uint _new, uint _old)
154     internal
155     {
156         uint newPrice = SafeMath.div(SafeMath.mul(_new,cardPriceIncrement),100);
157         totalCardValue = SafeMath.add(totalCardValue, SafeMath.sub(newPrice,_old));
158     }
159 
160     function buy(uint _card, address _referrer)
161         public
162         payable
163 
164     {
165         require(_card < totalCards);
166         require(msg.value == cardPrice[_card]);
167         require(msg.sender != cardOwner[_card]);
168 
169         addtotalCardValue(msg.value, cardPreviousPrice[_card]);
170 
171         uint _newPrice = SafeMath.div(SafeMath.mul(msg.value, cardPriceIncrement), 100);
172 
173          //Determine the total dividends
174         uint _baseDividends = SafeMath.sub(msg.value, cardPreviousPrice[_card]);
175 
176         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
177 
178         uint _cardsDividends = SafeMath.div(SafeMath.mul(_baseDividends, cardsDivRate),100);
179 
180         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends, ownerDivRate), 100);
181 
182         totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _ownerDividends);
183 
184         _ownerDividends = SafeMath.add(_ownerDividends, cardPreviousPrice[_card]);
185 
186         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends, distDivRate), 100);
187 
188         if (allowReferral && (_referrer != msg.sender) && (_referrer != 0x0000000000000000000000000000000000000000)) {
189 
190             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends, referralRate), 100);
191 
192             _distDividends = SafeMath.sub(_distDividends, _referralDividends);
193 
194             ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer], _referralDividends);
195         }
196 
197 
198         //distribute dividends to accounts
199         address _previousOwner = cardOwner[_card];
200         address _newOwner = msg.sender;
201 
202         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner], _ownerDividends);
203 
204         ddtDivsAddr.transfer(_cardsDividends);
205 
206         distributeDivs(_distDividends);
207 
208         //Increment the card Price
209         cardPreviousPrice[_card] = msg.value;
210         cardPrice[_card] = _newPrice;
211         cardOwner[_card] = _newOwner;
212 
213         emit oncardPurchase(msg.sender, msg.value, _card, SafeMath.div(SafeMath.mul(msg.value, cardPriceIncrement), 100));
214     }
215 
216 
217     function distributeDivs(uint _distDividends) internal{
218 
219             for (uint _card=0; _card < totalCards; _card++){
220 
221                 uint _divShare = SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
222                 uint _cardDivs = SafeMath.div(SafeMath.mul(_distDividends, _divShare), 10 ** precisionFactor);
223 
224                 ownerAccounts[cardOwner[_card]] += _cardDivs;
225 
226                 totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _cardDivs);
227             }
228         }
229 
230 
231     function withdraw()
232 
233         public
234     {
235         address _customerAddress = msg.sender;
236         require(ownerAccounts[_customerAddress] >= 0.001 ether);
237 
238         uint _dividends = ownerAccounts[_customerAddress];
239         ownerAccounts[_customerAddress] = 0;
240 
241         _customerAddress.transfer(_dividends);
242 
243         emit onWithdraw(_customerAddress, _dividends);
244     }
245 
246 
247 
248     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
249     function setName(string _name)
250         onlyOwner()
251         public
252     {
253         name = _name;
254     }
255 
256 
257     function setSymbol(string _symbol)
258         onlyOwner()
259         public
260     {
261         symbol = _symbol;
262     }
263 
264     function setcardPrice(uint _card, uint _price)   //Allow the changing of a card price owner if the dev owns it
265         onlyOwner()
266         public
267     {
268         require(cardOwner[_card] == dev);
269         cardPrice[_card] = _price;
270     }
271 
272     function addNewcard(uint _price)
273         onlyOwner()
274         public
275     {
276         cardPrice[totalCards-1] = _price;
277         cardOwner[totalCards-1] = dev;
278         totalCardDivs[totalCards-1] = 0;
279         totalCards = totalCards + 1;
280     }
281 
282     function setAllowReferral(bool _allowReferral)
283         onlyOwner()
284         public
285     {
286         allowReferral = _allowReferral;
287     }
288 
289 
290 
291     /*----------  HELPERS AND CALCULATORS  ----------*/
292     /**
293      * Method to view the current Ethereum stored in the contract
294      * Example: totalEthereumBalance()
295      */
296 
297 
298     function getMyBalance()
299         public
300         view
301         returns(uint)
302     {
303         return ownerAccounts[msg.sender];
304     }
305 
306     function getOwnerBalance(address _cardOwner)
307         public
308         view
309         returns(uint)
310     {
311         return ownerAccounts[_cardOwner];
312     }
313 
314     function getcardPrice(uint _card)
315         public
316         view
317         returns(uint)
318     {
319         require(_card < totalCards);
320         return cardPrice[_card];
321     }
322 
323     function getcardOwner(uint _card)
324         public
325         view
326         returns(address)
327     {
328         require(_card < totalCards);
329         return cardOwner[_card];
330     }
331 
332     function gettotalCardDivs(uint _card)
333         public
334         view
335         returns(uint)
336     {
337         require(_card < totalCards);
338         return totalCardDivs[_card];
339     }
340 
341     function getTotalDivsProduced()
342         public
343         view
344         returns(uint)
345     {
346         return totalDivsProduced;
347     }
348 
349     function getCardDivShare(uint _card)
350         public
351         view
352         returns(uint)
353     {
354         require(_card < totalCards);
355         return SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
356     }
357 
358     function getCardDivs(uint  _card, uint _amt)
359         public
360         view
361         returns(uint)
362     {
363         uint _share = getCardDivShare(_card);
364         return SafeMath.div(SafeMath.mul( _share, _amt), 10 ** precisionFactor);
365     }
366 
367     function gettotalCardValue()
368         public
369         view
370         returns(uint)
371     {
372 
373         return totalCardValue;
374     }
375 
376     function totalEthereumBalance()
377         public
378         view
379         returns(uint)
380     {
381         return address (this).balance;
382     }
383 
384     function gettotalCards()
385         public
386         view
387         returns(uint)
388     {
389         return totalCards;
390     }
391 
392 }
393 
394 /**
395  * @title SafeMath
396  * @dev Math operations with safety checks that throw on error
397  */
398 library SafeMath {
399 
400     /**
401     * @dev Multiplies two numbers, throws on overflow.
402     */
403     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
404         if (a == 0) {
405             return 0;
406         }
407         uint256 c = a * b;
408         assert(c / a == b);
409         return c;
410     }
411 
412     /**
413     * @dev Integer division of two numbers, truncating the quotient.
414     */
415     function div(uint256 a, uint256 b) internal pure returns (uint256) {
416         // assert(b > 0); // Solidity automatically throws when dividing by 0
417         uint256 c = a / b;
418         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
419         return c;
420     }
421 
422     /**
423     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
424     */
425     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
426         assert(b <= a);
427         return a - b;
428     }
429 
430     /**
431     * @dev Adds two numbers, throws on overflow.
432     */
433     function add(uint256 a, uint256 b) internal pure returns (uint256) {
434         uint256 c = a + b;
435         assert(c >= a);
436         return c;
437     }
438 }