1 pragma solidity ^0.4.24;
2 
3 /*
4                                                                 _       
5   ___   _ __     __ _    ___    ___    ___    __ _   _ __    __| |  ___ 
6  / __| | '_ \   / _` |  / __|  / _ \  / __|  / _` | | '__|  / _` | / __|
7  \__ \ | |_) | | (_| | | (__  |  __/ | (__  | (_| | | |    | (_| | \__ \
8  |___/ | .__/   \__,_|  \___|  \___|  \___|  \__,_| |_|     \__,_| |___/
9        |_|                                                              
10                                                     _     
11       ___   _   _   _ __    __ _    ___       ___  | |__  
12      / __| | | | | | '__|  / _` |  / _ \     / __| | '_ \ 
13   _  \__ \ | |_| | | |    | (_| | |  __/  _  \__ \ | | | |
14  (_) |___/  \__,_| |_|     \__, |  \___| (_) |___/ |_| |_|
15                            |___/                          
16 
17 spacecards.surge.sh
18 A Card Flipping & Divs Earning Game!
19 */
20 
21 contract SpaceCards {
22     /*=================================
23     =        MODIFIERS        =
24     =================================*/
25 
26 
27 
28     modifier onlyOwner(){
29 
30         require(msg.sender == dev);
31         _;
32     }
33 
34 
35     /*==============================
36     =            EVENTS            =
37     ==============================*/
38     event oncardPurchase(
39         address customerAddress,
40         uint256 incomingEthereum,
41         uint256 card,
42         uint256 newPrice
43     );
44 
45     event onWithdraw(
46         address customerAddress,
47         uint256 ethereumWithdrawn
48     );
49 
50     // ERC20
51     event Transfer(
52         address from,
53         address to,
54         uint256 card
55     );
56 
57 
58     /*=====================================
59     =            CONFIGURABLES            =
60     =====================================*/
61     string public name = "SPACE CARDS";
62     string public symbol = "SPACECARDS";
63 
64     uint8 constant public cardsDivRate = 10;
65     uint8 constant public ownerDivRate = 50;
66     uint8 constant public distDivRate = 40;
67     uint8 constant public referralRate = 5;
68     uint8 constant public decimals = 18;
69     uint public totalCardValue = 11.1 ether; // Make sure this is sum of constructor values
70     uint public precisionFactor = 9;
71 
72 
73    /*================================
74     =            DATASETS            =
75     ================================*/
76 
77     mapping(uint => address) internal cardOwner;
78     mapping(uint => uint) public cardPrice;
79     mapping(uint => uint) internal cardPreviousPrice;
80     mapping(address => uint) internal ownerAccounts;
81     mapping(uint => uint) internal totalCardDivs;
82 
83     uint cardPriceIncrement = 110;
84     uint totalDivsProduced = 0;
85 
86     uint public totalCards;
87 
88     bool allowReferral = true;
89 
90     address dev;
91     address promoter;
92     address promoter2;
93     address promoter3;
94     address supporter1;
95     address ddtDivsAddr;
96 
97 
98     /*=======================================
99     =            PUBLIC FUNCTIONS            =
100     =======================================*/
101     /*
102     * -- APPLICATION ENTRY POINTS --
103     */
104     constructor()
105         public
106     {
107         dev = msg.sender;
108         promoter = 0xC4C3B0B3b829D529c812cb825426645BA97Bd40c;
109         ddtDivsAddr = 0xC4C3B0B3b829D529c812cb825426645BA97Bd40c;
110 
111         totalCards = 12;
112 
113         cardOwner[0] = dev;
114         cardPrice[0] = 4 ether;
115         cardPreviousPrice[0] = cardPrice[0];
116 
117         cardOwner[1] = dev;
118         cardPrice[1] = 3 ether;
119         cardPreviousPrice[1] = cardPrice[1];
120 
121         cardOwner[2] = dev;
122         cardPrice[2] = 2 ether;
123         cardPreviousPrice[2] = cardPrice[2];
124 
125         cardOwner[3] = dev;
126         cardPrice[3] = 1 ether;
127         cardPreviousPrice[3] = cardPrice[3];
128 
129         cardOwner[4] = dev;
130         cardPrice[4] = 0.4 ether;
131         cardPreviousPrice[4] = cardPrice[4];
132 
133         cardOwner[5] = dev;
134         cardPrice[5] = 0.3 ether;
135         cardPreviousPrice[5] = cardPrice[5];
136 
137         cardOwner[6] = dev;
138         cardPrice[6] = 0.2 ether;
139         cardPreviousPrice[6] = cardPrice[6];
140 
141         cardOwner[7] = dev;
142         cardPrice[7] = 0.1 ether;
143         cardPreviousPrice[7] = cardPrice[7];
144 
145         cardOwner[8] = dev;
146         cardPrice[8] = 0.04 ether;
147         cardPreviousPrice[8] = cardPrice[8];
148 
149         cardOwner[9] = dev;
150         cardPrice[9] = 0.03 ether;
151         cardPreviousPrice[9] = cardPrice[9];
152 
153         cardOwner[10] = dev;
154         cardPrice[10] = 0.02 ether;
155         cardPreviousPrice[10] = cardPrice[10];
156 
157         cardOwner[11] = dev;
158         cardPrice[11] = 0.01 ether;
159         cardPreviousPrice[11] = cardPrice[11];
160 
161     }
162 
163     function addtotalCardValue(uint _new, uint _old)
164     internal
165     {
166         uint newPrice = SafeMath.div(SafeMath.mul(_new,cardPriceIncrement),100);
167         totalCardValue = SafeMath.add(totalCardValue, SafeMath.sub(newPrice,_old));
168     }
169 
170     function buy(uint _card, address _referrer)
171         public
172         payable
173 
174     {
175         require(_card < totalCards);
176         require(msg.value == cardPrice[_card]);
177         require(msg.sender != cardOwner[_card]);
178 
179         addtotalCardValue(msg.value, cardPreviousPrice[_card]);
180 
181         uint _newPrice = SafeMath.div(SafeMath.mul(msg.value, cardPriceIncrement), 100);
182 
183          //Determine the total dividends
184         uint _baseDividends = SafeMath.sub(msg.value, cardPreviousPrice[_card]);
185 
186         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
187 
188         uint _cardsDividends = SafeMath.div(SafeMath.mul(_baseDividends, cardsDivRate),100);
189 
190         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends, ownerDivRate), 100);
191 
192         totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _ownerDividends);
193 
194         _ownerDividends = SafeMath.add(_ownerDividends, cardPreviousPrice[_card]);
195 
196         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends, distDivRate), 100);
197 
198         if (allowReferral && (_referrer != msg.sender) && (_referrer != 0x0000000000000000000000000000000000000000)) {
199 
200             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends, referralRate), 100);
201 
202             _distDividends = SafeMath.sub(_distDividends, _referralDividends);
203 
204             ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer], _referralDividends);
205         }
206 
207 
208         //distribute dividends to accounts
209         address _previousOwner = cardOwner[_card];
210         address _newOwner = msg.sender;
211 
212         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner], _ownerDividends);
213 
214         ddtDivsAddr.transfer(_cardsDividends);
215 
216         distributeDivs(_distDividends);
217 
218         //Increment the card Price
219         cardPreviousPrice[_card] = msg.value;
220         cardPrice[_card] = _newPrice;
221         cardOwner[_card] = _newOwner;
222 
223         emit oncardPurchase(msg.sender, msg.value, _card, SafeMath.div(SafeMath.mul(msg.value, cardPriceIncrement), 100));
224     }
225 
226 
227     function distributeDivs(uint _distDividends) internal{
228 
229             for (uint _card=0; _card < totalCards; _card++){
230 
231                 uint _divShare = SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
232                 uint _cardDivs = SafeMath.div(SafeMath.mul(_distDividends, _divShare), 10 ** precisionFactor);
233 
234                 ownerAccounts[cardOwner[_card]] += _cardDivs;
235 
236                 totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _cardDivs);
237             }
238         }
239 
240 
241     function withdraw()
242 
243         public
244     {
245         address _customerAddress = msg.sender;
246         require(ownerAccounts[_customerAddress] >= 0.001 ether);
247 
248         uint _dividends = ownerAccounts[_customerAddress];
249         ownerAccounts[_customerAddress] = 0;
250 
251         _customerAddress.transfer(_dividends);
252 
253         emit onWithdraw(_customerAddress, _dividends);
254     }
255 
256 
257 
258     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
259     function setName(string _name)
260         onlyOwner()
261         public
262     {
263         name = _name;
264     }
265 
266 
267     function setSymbol(string _symbol)
268         onlyOwner()
269         public
270     {
271         symbol = _symbol;
272     }
273 
274     function setcardPrice(uint _card, uint _price)   //Allow the changing of a card price owner if the dev owns it
275         onlyOwner()
276         public
277     {
278         require(cardOwner[_card] == dev);
279         cardPrice[_card] = _price;
280     }
281 
282     function addNewcard(uint _price)
283         onlyOwner()
284         public
285     {
286         cardPrice[totalCards-1] = _price;
287         cardOwner[totalCards-1] = dev;
288         totalCardDivs[totalCards-1] = 0;
289         totalCards = totalCards + 1;
290     }
291 
292     function setAllowReferral(bool _allowReferral)
293         onlyOwner()
294         public
295     {
296         allowReferral = _allowReferral;
297     }
298 
299 
300 
301     /*----------  HELPERS AND CALCULATORS  ----------*/
302     /**
303      * Method to view the current Ethereum stored in the contract
304      * Example: totalEthereumBalance()
305      */
306 
307 
308     function getMyBalance()
309         public
310         view
311         returns(uint)
312     {
313         return ownerAccounts[msg.sender];
314     }
315 
316     function getOwnerBalance(address _cardOwner)
317         public
318         view
319         returns(uint)
320     {
321         return ownerAccounts[_cardOwner];
322     }
323 
324     function getcardPrice(uint _card)
325         public
326         view
327         returns(uint)
328     {
329         require(_card < totalCards);
330         return cardPrice[_card];
331     }
332 
333     function getcardOwner(uint _card)
334         public
335         view
336         returns(address)
337     {
338         require(_card < totalCards);
339         return cardOwner[_card];
340     }
341 
342     function gettotalCardDivs(uint _card)
343         public
344         view
345         returns(uint)
346     {
347         require(_card < totalCards);
348         return totalCardDivs[_card];
349     }
350 
351     function getTotalDivsProduced()
352         public
353         view
354         returns(uint)
355     {
356         return totalDivsProduced;
357     }
358 
359     function getCardDivShare(uint _card)
360         public
361         view
362         returns(uint)
363     {
364         require(_card < totalCards);
365         return SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
366     }
367 
368     function getCardDivs(uint  _card, uint _amt)
369         public
370         view
371         returns(uint)
372     {
373         uint _share = getCardDivShare(_card);
374         return SafeMath.div(SafeMath.mul( _share, _amt), 10 ** precisionFactor);
375     }
376 
377     function gettotalCardValue()
378         public
379         view
380         returns(uint)
381     {
382 
383         return totalCardValue;
384     }
385 
386     function totalEthereumBalance()
387         public
388         view
389         returns(uint)
390     {
391         return address (this).balance;
392     }
393 
394     function gettotalCards()
395         public
396         view
397         returns(uint)
398     {
399         return totalCards;
400     }
401 
402 }
403 
404 /**
405  * @title SafeMath
406  * @dev Math operations with safety checks that throw on error
407  */
408 library SafeMath {
409 
410     /**
411     * @dev Multiplies two numbers, throws on overflow.
412     */
413     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
414         if (a == 0) {
415             return 0;
416         }
417         uint256 c = a * b;
418         assert(c / a == b);
419         return c;
420     }
421 
422     /**
423     * @dev Integer division of two numbers, truncating the quotient.
424     */
425     function div(uint256 a, uint256 b) internal pure returns (uint256) {
426         // assert(b > 0); // Solidity automatically throws when dividing by 0
427         uint256 c = a / b;
428         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
429         return c;
430     }
431 
432     /**
433     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
434     */
435     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
436         assert(b <= a);
437         return a - b;
438     }
439 
440     /**
441     * @dev Adds two numbers, throws on overflow.
442     */
443     function add(uint256 a, uint256 b) internal pure returns (uint256) {
444         uint256 c = a + b;
445         assert(c >= a);
446         return c;
447     }
448 }