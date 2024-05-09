1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 * https://mobstreet.me/bosses
6 *     
7 *       ____                   _____
8 *     ██████╗  ██████╗ ███████╗███████╗       
9 *     ██╔══██╗██╔═══██╗██╔════╝██╔════╝       
10 *     ██████╔╝██║   ██║███████╗███████╗       
11 *     ██╔══██╗██║   ██║╚════██║╚════██║       
12 *     ██████╔╝╚██████╔╝███████║███████║       
13 *     ╚═════╝  ╚═════╝ ╚══════╝╚══════╝       
14 *                                             
15 *      ██████╗ █████╗ ██████╗ ██████╗ ███████╗
16 *     ██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔════╝
17 *     ██║     ███████║██████╔╝██║  ██║███████╗
18 *     ██║     ██╔══██║██╔══██╗██║  ██║╚════██║
19 *     ╚██████╗██║  ██║██║  ██║██████╔╝███████║
20 *      ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝
21 *                                            
22 *
23 * https://mobstreet.me/bosses
24 *
25 */
26 
27 contract BossCards {
28     /*=================================
29     =        MODIFIERS        =
30     =================================*/
31 
32 
33 
34     modifier onlyOwner(){
35 
36         require(msg.sender == dev);
37         _;
38     }
39 
40 
41     /*==============================
42     =            EVENTS            =
43     ==============================*/
44     event oncardPurchase(
45         address customerAddress,
46         uint256 incomingEthereum,
47         uint256 card,
48         uint256 newPrice
49     );
50 
51     event onWithdraw(
52         address customerAddress,
53         uint256 ethereumWithdrawn
54     );
55 
56     // ERC20
57     event Transfer(
58         address from,
59         address to,
60         uint256 card
61     );
62 
63 
64     /*=====================================
65     =            CONFIGURABLES            =
66     =====================================*/
67     string public name = "FOUNDER CARDS";
68     string public symbol = "MOBCARD";
69 
70     uint8 constant public mobDivRate = 10;
71     uint8 constant public ownerDivRate = 50;
72     uint8 constant public distDivRate = 40;
73     uint8 constant public referralRate = 5;
74     uint8 constant public decimals = 18;
75     uint public totalCardValue = 7.25 ether; // Make sure this is sum of constructor values
76     uint public precisionFactor = 9;
77 
78 
79    /*================================
80     =            DATASETS            =
81     ================================*/
82 
83     mapping(uint => address) internal cardOwner;
84     mapping(uint => uint) public cardPrice;
85     mapping(uint => uint) internal cardPreviousPrice;
86     mapping(address => uint) internal ownerAccounts;
87     mapping(uint => uint) internal totalCardDivs;
88 
89     uint cardPriceIncrement = 110;
90     uint totalDivsProduced = 0;
91 
92     uint public totalCards;
93 
94     bool allowReferral = true;
95 
96     address dev;
97     address bossman;
98     address mobDivsAddr;
99 
100 
101     /*=======================================
102     =            PUBLIC FUNCTIONS            =
103     =======================================*/
104     /*
105     * -- APPLICATION ENTRY POINTS --
106     */
107     constructor()
108         public
109     {
110         dev = msg.sender;
111         bossman = 0x41FE3738B503cBaFD01C1Fd8DD66b7fE6Ec11b01;
112         mobDivsAddr = 0x5E38C0BD4E0dDB71E67B6693Ddc4c7D7b4f26b49;
113 
114         totalCards = 12;
115 
116         cardOwner[0] = bossman;
117         cardPrice[0] = 2 ether;
118         cardPreviousPrice[0] = cardPrice[0];
119 
120         cardOwner[1] = dev;
121         cardPrice[1] = 1.5 ether;
122         cardPreviousPrice[1] = cardPrice[1];
123 
124         cardOwner[2] = dev;
125         cardPrice[2] = 1 ether;
126         cardPreviousPrice[2] = cardPrice[2];
127 
128         cardOwner[3] = dev;
129         cardPrice[3] = 0.9 ether;
130         cardPreviousPrice[3] = cardPrice[3];
131 
132         cardOwner[4] = dev;
133         cardPrice[4] = 0.75 ether;
134         cardPreviousPrice[4] = cardPrice[4];
135 
136         cardOwner[5] = dev;
137         cardPrice[5] = 0.50 ether;
138         cardPreviousPrice[5] = cardPrice[5];
139 
140         cardOwner[6] = dev;
141         cardPrice[6] = 0.25 ether;
142         cardPreviousPrice[6] = cardPrice[6];
143 
144         cardOwner[7] = dev;
145         cardPrice[7] = 0.12 ether;
146         cardPreviousPrice[7] = cardPrice[7];
147 
148         cardOwner[8] = dev;
149         cardPrice[8] = 0.08 ether;
150         cardPreviousPrice[8] = cardPrice[8];
151 
152         cardOwner[9] = dev;
153         cardPrice[9] = 0.05 ether;
154         cardPreviousPrice[9] = cardPrice[9];
155 
156         cardOwner[10] = dev;
157         cardPrice[10] = 0.05 ether;
158         cardPreviousPrice[10] = cardPrice[10];
159 
160         cardOwner[11] = dev;
161         cardPrice[11] = 0.05 ether;
162         cardPreviousPrice[11] = cardPrice[11];
163 
164     }
165 
166     function addtotalCardValue(uint _new, uint _old)
167     internal
168     {
169         uint newPrice = SafeMath.div(SafeMath.mul(_new,cardPriceIncrement),100);
170         totalCardValue = SafeMath.add(totalCardValue, SafeMath.sub(newPrice,_old));
171     }
172 
173     function buy(uint _card, address _referrer)
174         public
175         payable
176 
177     {
178         require(_card < totalCards);
179         require(msg.value == cardPrice[_card]);
180         require(msg.sender != cardOwner[_card]);
181 
182         addtotalCardValue(msg.value, cardPreviousPrice[_card]);
183 
184         uint _newPrice = SafeMath.div(SafeMath.mul(msg.value, cardPriceIncrement), 100);
185 
186          //Determine the total dividends
187         uint _baseDividends = SafeMath.sub(msg.value, cardPreviousPrice[_card]);
188 
189         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
190 
191         uint _mobDividends = SafeMath.div(SafeMath.mul(_baseDividends, mobDivRate),100);
192 
193         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends, ownerDivRate), 100);
194 
195         totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _ownerDividends);
196 
197         _ownerDividends = SafeMath.add(_ownerDividends, cardPreviousPrice[_card]);
198 
199         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends, distDivRate), 100);
200 
201         if (allowReferral && (_referrer != msg.sender) && (_referrer != 0x0000000000000000000000000000000000000000)) {
202 
203             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends, referralRate), 100);
204 
205             _distDividends = SafeMath.sub(_distDividends, _referralDividends);
206 
207             ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer], _referralDividends);
208         }
209 
210 
211         //distribute dividends to accounts
212         address _previousOwner = cardOwner[_card];
213         address _newOwner = msg.sender;
214 
215         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner], _ownerDividends);
216 
217         mobDivsAddr.transfer(_mobDividends);
218 
219         distributeDivs(_distDividends);
220 
221         //Increment the card Price
222         cardPreviousPrice[_card] = msg.value;
223         cardPrice[_card] = _newPrice;
224         cardOwner[_card] = _newOwner;
225 
226         emit oncardPurchase(msg.sender, msg.value, _card, SafeMath.div(SafeMath.mul(msg.value, cardPriceIncrement), 100));
227     }
228 
229 
230     function distributeDivs(uint _distDividends) internal{
231 
232             for (uint _card=0; _card < totalCards; _card++){
233 
234                 uint _divShare = SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
235                 uint _cardDivs = SafeMath.div(SafeMath.mul(_distDividends, _divShare), 10 ** precisionFactor);
236 
237                 ownerAccounts[cardOwner[_card]] += _cardDivs;
238 
239                 totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _cardDivs);
240             }
241         }
242 
243 
244     function withdraw()
245 
246         public
247     {
248         address _customerAddress = msg.sender;
249         require(ownerAccounts[_customerAddress] >= 0.001 ether);
250 
251         uint _dividends = ownerAccounts[_customerAddress];
252         ownerAccounts[_customerAddress] = 0;
253 
254         _customerAddress.transfer(_dividends);
255 
256         emit onWithdraw(_customerAddress, _dividends);
257     }
258 
259 
260 
261     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
262     function setName(string _name)
263         onlyOwner()
264         public
265     {
266         name = _name;
267     }
268 
269 
270     function setSymbol(string _symbol)
271         onlyOwner()
272         public
273     {
274         symbol = _symbol;
275     }
276 
277     function setcardPrice(uint _card, uint _price)   //Allow the changing of a card price owner if the dev owns it
278         onlyOwner()
279         public
280     {
281         require(cardOwner[_card] == dev);
282         cardPrice[_card] = _price;
283     }
284 
285     function addNewcard(uint _price)
286         onlyOwner()
287         public
288     {
289         cardPrice[totalCards-1] = _price;
290         cardOwner[totalCards-1] = dev;
291         totalCardDivs[totalCards-1] = 0;
292         totalCards = totalCards + 1;
293     }
294 
295     function setAllowReferral(bool _allowReferral)
296         onlyOwner()
297         public
298     {
299         allowReferral = _allowReferral;
300     }
301 
302 
303 
304     /*----------  HELPERS AND CALCULATORS  ----------*/
305     /**
306      * Method to view the current Ethereum stored in the contract
307      * Example: totalEthereumBalance()
308      */
309 
310 
311     function getMyBalance()
312         public
313         view
314         returns(uint)
315     {
316         return ownerAccounts[msg.sender];
317     }
318 
319     function getOwnerBalance(address _cardOwner)
320         public
321         view
322         returns(uint)
323     {
324         return ownerAccounts[_cardOwner];
325     }
326 
327     function getcardPrice(uint _card)
328         public
329         view
330         returns(uint)
331     {
332         require(_card < totalCards);
333         return cardPrice[_card];
334     }
335 
336     function getcardOwner(uint _card)
337         public
338         view
339         returns(address)
340     {
341         require(_card < totalCards);
342         return cardOwner[_card];
343     }
344 
345     function gettotalCardDivs(uint _card)
346         public
347         view
348         returns(uint)
349     {
350         require(_card < totalCards);
351         return totalCardDivs[_card];
352     }
353 
354     function getTotalDivsProduced()
355         public
356         view
357         returns(uint)
358     {
359         return totalDivsProduced;
360     }
361 
362     function getCardDivShare(uint _card)
363         public
364         view
365         returns(uint)
366     {
367         require(_card < totalCards);
368         return SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
369     }
370 
371     function getCardDivs(uint  _card, uint _amt)
372         public
373         view
374         returns(uint)
375     {
376         uint _share = getCardDivShare(_card);
377         return SafeMath.div(SafeMath.mul( _share, _amt), 10 ** precisionFactor);
378     }
379 
380     function gettotalCardValue()
381         public
382         view
383         returns(uint)
384     {
385 
386         return totalCardValue;
387     }
388 
389     function totalEthereumBalance()
390         public
391         view
392         returns(uint)
393     {
394         return address (this).balance;
395     }
396 
397     function gettotalCards()
398         public
399         view
400         returns(uint)
401     {
402         return totalCards;
403     }
404 
405 }
406 
407 /**
408  * @title SafeMath
409  * @dev Math operations with safety checks that throw on error
410  */
411 library SafeMath {
412 
413     /**
414     * @dev Multiplies two numbers, throws on overflow.
415     */
416     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
417         if (a == 0) {
418             return 0;
419         }
420         uint256 c = a * b;
421         assert(c / a == b);
422         return c;
423     }
424 
425     /**
426     * @dev Integer division of two numbers, truncating the quotient.
427     */
428     function div(uint256 a, uint256 b) internal pure returns (uint256) {
429         // assert(b > 0); // Solidity automatically throws when dividing by 0
430         uint256 c = a / b;
431         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
432         return c;
433     }
434 
435     /**
436     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
437     */
438     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
439         assert(b <= a);
440         return a - b;
441     }
442 
443     /**
444     * @dev Adds two numbers, throws on overflow.
445     */
446     function add(uint256 a, uint256 b) internal pure returns (uint256) {
447         uint256 c = a + b;
448         assert(c >= a);
449         return c;
450     }
451 }