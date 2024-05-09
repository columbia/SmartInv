1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 *
6 */
7 
8 contract DailyRoiCardGame {
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
21     modifier senderVerify() {
22         require (msg.sender == tx.origin);
23         _;
24     }
25 
26 
27     /*==============================
28     =            EVENTS            =
29     ==============================*/
30     event oncardPurchase(
31         address customerAddress,
32         uint256 incomingEthereum,
33         uint256 card,
34         uint256 newPrice
35     );
36 
37     event onWithdraw(
38         address customerAddress,
39         uint256 ethereumWithdrawn
40     );
41 
42     // ERC20
43     event Transfer(
44         address from,
45         address to,
46         uint256 card
47     );
48 
49 
50     /*=====================================
51     =            CONFIGURABLES            =
52     =====================================*/
53     string public name = "DailyRoi CARDS";
54     string public symbol = "DROICARD";
55 
56     uint8 constant public cardsDivRate = 10;
57     uint8 constant public ownerDivRate = 50;
58     uint8 constant public distDivRate = 40;
59     uint8 constant public referralRate = 5;
60     uint8 constant public decimals = 18;
61     uint public totalCardValue = 14.51 ether; // Make sure this is sum of constructor values
62     uint public precisionFactor = 9;
63 
64 
65    /*================================
66     =            DATASETS            =
67     ================================*/
68 
69     mapping(uint => address) internal cardOwner;
70     mapping(uint => uint) public cardPrice;
71     mapping(uint => uint) internal cardPreviousPrice;
72     mapping(address => uint) internal ownerAccounts;
73     mapping(uint => uint) internal totalCardDivs;
74 
75     uint cardPriceIncrement = 110;
76     uint totalDivsProduced = 0;
77 
78     uint public totalCards;
79 
80     bool allowReferral = true;
81 
82     address dev;
83     address promoter;
84     address promoter2;
85     address dailyRoiDivsAddr;
86 
87 
88 
89     uint ACTIVATION_TIME = 1537912800;
90 
91 
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
103         promoter = 0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01;
104         promoter2 = 0xEafE863757a2b2a2c5C3f71988b7D59329d09A78;
105         dailyRoiDivsAddr = 0x9F0a1bcD44f522318900e70A2617C0056378BB2D;
106 
107         totalCards = 16;
108 
109         cardOwner[0] = dev;
110         cardPrice[0] = 4 ether;
111         cardPreviousPrice[0] = cardPrice[0];
112 
113         cardOwner[1] = promoter2;
114         cardPrice[1] = 3 ether;
115         cardPreviousPrice[1] = cardPrice[1];
116 
117         cardOwner[2] = promoter2;
118         cardPrice[2] = 2 ether;
119         cardPreviousPrice[2] = cardPrice[2];
120 
121         cardOwner[3] = dev;
122         cardPrice[3] = 1.5 ether;
123         cardPreviousPrice[3] = cardPrice[3];
124 
125         cardOwner[4] = promoter;
126         cardPrice[4] = 1 ether;
127         cardPreviousPrice[4] = cardPrice[4];
128 
129         cardOwner[5] = dev;
130         cardPrice[5] = 0.8 ether;
131         cardPreviousPrice[5] = cardPrice[5];
132 
133         cardOwner[6] = dev;
134         cardPrice[6] = 0.6 ether;
135         cardPreviousPrice[6] = cardPrice[6];
136 
137         cardOwner[7] = dev;
138         cardPrice[7] = 0.5 ether;
139         cardPreviousPrice[7] = cardPrice[7];
140 
141         cardOwner[8] = dev;
142         cardPrice[8] = 0.4 ether;
143         cardPreviousPrice[8] = cardPrice[8];
144 
145         cardOwner[9] = dev;
146         cardPrice[9] = 0.3 ether;
147         cardPreviousPrice[9] = cardPrice[9];
148 
149         cardOwner[10] = dev;
150         cardPrice[10] = 0.2 ether;
151         cardPreviousPrice[10] = cardPrice[10];
152 
153         cardOwner[11] = dev;
154         cardPrice[11] = 0.1 ether;
155         cardPreviousPrice[11] = cardPrice[11];
156 
157         cardOwner[12] = dev;
158         cardPrice[12] = 0.05 ether;
159         cardPreviousPrice[12] = cardPrice[12];
160 
161         cardOwner[13] = dev;
162         cardPrice[13] = 0.03 ether;
163         cardPreviousPrice[13] = cardPrice[13];
164 
165         cardOwner[14] = dev;
166         cardPrice[14] = 0.02 ether;
167         cardPreviousPrice[14] = cardPrice[14];
168 
169         cardOwner[15] = dev;
170         cardPrice[15] = 0.01 ether;
171         cardPreviousPrice[15] = cardPrice[15];
172     }
173 
174     function addtotalCardValue(uint _new, uint _old)
175     internal
176     {
177         uint newPrice = SafeMath.div(SafeMath.mul(_new,cardPriceIncrement),100);
178         totalCardValue = SafeMath.add(totalCardValue, SafeMath.sub(newPrice,_old));
179     }
180 
181     function buy(uint _card, address _referrer)
182         senderVerify()
183         public
184         payable
185     {
186         require(_card < totalCards);
187         require(now >= ACTIVATION_TIME);
188         require(msg.value == cardPrice[_card]);
189         require(msg.sender != cardOwner[_card]);
190 
191         addtotalCardValue(msg.value, cardPreviousPrice[_card]);
192 
193         uint _newPrice = SafeMath.div(SafeMath.mul(msg.value, cardPriceIncrement), 100);
194 
195          //Determine the total dividends
196         uint _baseDividends = SafeMath.sub(msg.value, cardPreviousPrice[_card]);
197 
198         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
199 
200         uint _cardsDividends = SafeMath.div(SafeMath.mul(_baseDividends, cardsDivRate),100);
201 
202         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends, ownerDivRate), 100);
203 
204         totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _ownerDividends);
205 
206         _ownerDividends = SafeMath.add(_ownerDividends, cardPreviousPrice[_card]);
207 
208         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends, distDivRate), 100);
209 
210         if (allowReferral && (_referrer != msg.sender) && (_referrer != 0x0000000000000000000000000000000000000000)) {
211 
212             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends, referralRate), 100);
213 
214             _distDividends = SafeMath.sub(_distDividends, _referralDividends);
215 
216             ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer], _referralDividends);
217         }
218 
219 
220         //distribute dividends to accounts
221         address _previousOwner = cardOwner[_card];
222         address _newOwner = msg.sender;
223 
224         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner], _ownerDividends);
225 
226         dailyRoiDivsAddr.transfer(_cardsDividends);
227 
228         distributeDivs(_distDividends);
229 
230         //Increment the card Price
231         cardPreviousPrice[_card] = msg.value;
232         cardPrice[_card] = _newPrice;
233         cardOwner[_card] = _newOwner;
234 
235         emit oncardPurchase(msg.sender, msg.value, _card, SafeMath.div(SafeMath.mul(msg.value, cardPriceIncrement), 100));
236     }
237 
238 
239     function distributeDivs(uint _distDividends) internal{
240 
241             for (uint _card=0; _card < totalCards; _card++){
242 
243                 uint _divShare = SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
244                 uint _cardDivs = SafeMath.div(SafeMath.mul(_distDividends, _divShare), 10 ** precisionFactor);
245 
246                 ownerAccounts[cardOwner[_card]] += _cardDivs;
247 
248                 totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _cardDivs);
249             }
250         }
251 
252 
253     function withdraw()
254 
255         public
256     {
257         address _customerAddress = msg.sender;
258         require(ownerAccounts[_customerAddress] >= 0.001 ether);
259 
260         uint _dividends = ownerAccounts[_customerAddress];
261         ownerAccounts[_customerAddress] = 0;
262 
263         _customerAddress.transfer(_dividends);
264 
265         emit onWithdraw(_customerAddress, _dividends);
266     }
267 
268     /**
269    * Transfer bond to another address
270    */
271    function transfer(address _to, uint _card )
272 
273       public
274     {
275         require(cardOwner[_card] == msg.sender);
276 
277         cardOwner[_card] = _to;
278 
279         emit Transfer(msg.sender, _to, _card);
280 
281     }
282 
283 
284 
285     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
286     function setName(string _name)
287         onlyOwner()
288         public
289     {
290         name = _name;
291     }
292 
293 
294     function setSymbol(string _symbol)
295         onlyOwner()
296         public
297     {
298         symbol = _symbol;
299     }
300 
301     function setcardPrice(uint _card, uint _price)   //Allow the changing of a card price owner if the dev owns it
302         onlyOwner()
303         public
304     {
305         require(cardOwner[_card] == dev);
306         cardPrice[_card] = _price;
307     }
308 
309     function addNewcard(uint _price)
310         onlyOwner()
311         public
312     {
313         cardPrice[totalCards-1] = _price;
314         cardOwner[totalCards-1] = dev;
315         totalCardDivs[totalCards-1] = 0;
316         totalCards = totalCards + 1;
317     }
318 
319     function setAllowReferral(bool _allowReferral)
320         onlyOwner()
321         public
322     {
323         allowReferral = _allowReferral;
324     }
325 
326 
327 
328     /*----------  HELPERS AND CALCULATORS  ----------*/
329     /**
330      * Method to view the current Ethereum stored in the contract
331      * Example: totalEthereumBalance()
332      */
333 
334 
335     /* function getCardDivShare(uint _card)
336         public
337         view
338         returns(uint)
339     {
340         require(_card < totalCards);
341         return SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
342     }
343 
344     function getCardDivs(uint  _card, uint _amt)
345         public
346         view
347         returns(uint)
348     {
349         uint _share = getCardDivShare(_card);
350         return SafeMath.div(SafeMath.mul( _share, _amt), 10 ** precisionFactor);
351     } */
352 
353 
354 
355     function getMyBalance()
356         public
357         view
358         returns(uint)
359     {
360         return ownerAccounts[msg.sender];
361     }
362 
363     function getOwnerBalance(address _cardOwner)
364         public
365         view
366         returns(uint)
367     {
368         return ownerAccounts[_cardOwner];
369     }
370 
371     function getcardPrice(uint _card)
372         public
373         view
374         returns(uint)
375     {
376         require(_card < totalCards);
377         return cardPrice[_card];
378     }
379 
380     function getcardOwner(uint _card)
381         public
382         view
383         returns(address)
384     {
385         require(_card < totalCards);
386         return cardOwner[_card];
387     }
388 
389     function gettotalCardDivs(uint _card)
390         public
391         view
392         returns(uint)
393     {
394         require(_card < totalCards);
395         return totalCardDivs[_card];
396     }
397 
398     function getTotalDivsProduced()
399         public
400         view
401         returns(uint)
402     {
403         return totalDivsProduced;
404     }
405 
406     function gettotalCardValue()
407         public
408         view
409         returns(uint)
410     {
411 
412         return totalCardValue;
413     }
414 
415     function totalEthereumBalance()
416         public
417         view
418         returns(uint)
419     {
420         return address (this).balance;
421     }
422 
423     function gettotalCards()
424         public
425         view
426         returns(uint)
427     {
428         return totalCards;
429     }
430 
431 }
432 
433 /**
434  * @title SafeMath
435  * @dev Math operations with safety checks that throw on error
436  */
437 library SafeMath {
438 
439     /**
440     * @dev Multiplies two numbers, throws on overflow.
441     */
442     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
443         if (a == 0) {
444             return 0;
445         }
446         uint256 c = a * b;
447         assert(c / a == b);
448         return c;
449     }
450 
451     /**
452     * @dev Integer division of two numbers, truncating the quotient.
453     */
454     function div(uint256 a, uint256 b) internal pure returns (uint256) {
455         // assert(b > 0); // Solidity automatically throws when dividing by 0
456         uint256 c = a / b;
457         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
458         return c;
459     }
460 
461     /**
462     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
463     */
464     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
465         assert(b <= a);
466         return a - b;
467     }
468 
469     /**
470     * @dev Adds two numbers, throws on overflow.
471     */
472     function add(uint256 a, uint256 b) internal pure returns (uint256) {
473         uint256 c = a + b;
474         assert(c >= a);
475         return c;
476     }
477 }