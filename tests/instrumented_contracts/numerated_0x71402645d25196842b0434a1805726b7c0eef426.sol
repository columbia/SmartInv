1 pragma solidity ^0.4.24;
2 
3 /*
4 *    ___ _                ___ _     _           
5 *   / __\ |_   _  ___    / __\ |__ (_)_ __  ___ 
6 *  /__\// | | | |/ _ \  / /  | '_ \| | '_ \/ __|
7 * / \/  \ | |_| |  __/ / /___| | | | | |_) \__ \
8 * \_____/_|\__,_|\___| \____/|_| |_|_| .__/|___/
9 *                                    |_|        
10 *                                            
11 * https://bluechip.fund/
12 * https://bluechip.fund/bluechips
13 * https://bluechip.fund/exchange
14 * 
15 * https://discord.gg/aee8BjR
16 * https://t.me/bluechipfund
17 *
18 */
19 
20 contract BlueChips {
21     /*=================================
22     =        MODIFIERS        =
23     =================================*/
24     modifier onlyOwner(){
25         require(msg.sender == dev);
26         _;
27     }
28 
29     /*==============================
30     =            EVENTS            =
31     ==============================*/
32     event oncardPurchase(
33         address customerAddress,
34         uint256 incomingEthereum,
35         uint256 card,
36         uint256 newPrice
37     );
38 
39     event onWithdraw(
40         address customerAddress,
41         uint256 ethereumWithdrawn
42     );
43 
44     // ERC20
45     event Transfer(
46         address from,
47         address to,
48         uint256 card
49     );
50 
51 
52     /*=====================================
53     =            CONFIGURABLES            =
54     =====================================*/
55     string public name = "Blue Chips";
56     string public symbol = "CHIP";
57 
58     uint8 constant public blueDivRate = 20;
59     uint8 constant public ownerDivRate = 40;
60     uint8 constant public distDivRate = 40;
61     uint8 constant public referralRate = 5;
62     uint8 constant public decimals = 18;
63     uint public totalCardValue = 3.8 ether; // Make sure this is sum of constructor values
64     uint public precisionFactor = 9;
65 
66 
67    /*================================
68     =            DATASETS            =
69     ================================*/
70 
71     mapping(uint => address) internal cardOwner;
72     mapping(uint => uint) public cardPrice;
73     mapping(uint => uint) internal cardPreviousPrice;
74     mapping(address => uint) internal ownerAccounts;
75     mapping(uint => uint) internal totalCardDivs;
76 
77     uint cardPriceIncrement = 110;
78     uint totalDivsProduced = 0;
79 
80     uint public totalCards;
81 
82     uint ACTIVATION_TIME = 1570572000;
83 
84     address dev;
85     address blueDividendAddr;
86 
87     /*=======================================
88     =            PUBLIC FUNCTIONS            =
89     =======================================*/
90     /*
91     * -- APPLICATION ENTRY POINTS --
92     */
93     constructor()
94         public
95     {
96         dev = msg.sender;
97         blueDividendAddr = 0xB40b8e3C726155FF1c6EEBD22067436D0e2669dd;
98 
99         totalCards = 12;
100 
101         cardOwner[0] = dev;
102         cardPrice[0] = 1 ether;
103         cardPreviousPrice[0] = cardPrice[0];
104 
105         cardOwner[1] = dev;
106         cardPrice[1] = 0.75 ether;
107         cardPreviousPrice[1] = cardPrice[1];
108 
109         cardOwner[2] = dev;
110         cardPrice[2] = 0.5 ether;
111         cardPreviousPrice[2] = cardPrice[2];
112 
113         cardOwner[3] = dev;
114         cardPrice[3] = 0.4 ether;
115         cardPreviousPrice[3] = cardPrice[3];
116 
117         cardOwner[4] = dev;
118         cardPrice[4] = 0.3 ether;
119         cardPreviousPrice[4] = cardPrice[4];
120 
121         cardOwner[5] = dev;
122         cardPrice[5] = 0.25 ether;
123         cardPreviousPrice[5] = cardPrice[5];
124 
125         cardOwner[6] = dev;
126         cardPrice[6] = 0.2 ether;
127         cardPreviousPrice[6] = cardPrice[6];
128 
129         cardOwner[7] = dev;
130         cardPrice[7] = 0.15 ether;
131         cardPreviousPrice[7] = cardPrice[7];
132 
133         cardOwner[8] = dev;
134         cardPrice[8] = 0.1 ether;
135         cardPreviousPrice[8] = cardPrice[8];
136 
137         cardOwner[9] = dev;
138         cardPrice[9] = 0.08 ether;
139         cardPreviousPrice[9] = cardPrice[9];
140 
141         cardOwner[10] = dev;
142         cardPrice[10] = 0.05 ether;
143         cardPreviousPrice[10] = cardPrice[10];
144 
145         cardOwner[11] = dev;
146         cardPrice[11] = 0.02 ether;
147         cardPreviousPrice[11] = cardPrice[11];
148 
149     }
150 
151     function addtotalCardValue(uint _new, uint _old)
152     internal
153     {
154         uint newPrice = SafeMath.div(SafeMath.mul(_new,cardPriceIncrement),100);
155         totalCardValue = SafeMath.add(totalCardValue, SafeMath.sub(newPrice,_old));
156     }
157 
158     function buy(uint _card, address _referrer)
159         public
160         payable
161 
162     {
163         require(_card < totalCards);
164         require(now >= ACTIVATION_TIME);
165         require(msg.value >= cardPrice[_card]);
166         require(msg.sender != cardOwner[_card]);
167 
168         // Return excess ether if buyer overpays
169         if (msg.value > cardPrice[_card]){
170             uint _excess = SafeMath.sub(msg.value, cardPrice[_card]);
171             ownerAccounts[msg.sender] += _excess;
172         }
173 
174         addtotalCardValue(cardPrice[_card], cardPreviousPrice[_card]);
175 
176         uint _newPrice = SafeMath.div(SafeMath.mul(cardPrice[_card], cardPriceIncrement), 100);
177 
178          //Determine the total dividends
179         uint _baseDividends = SafeMath.sub(cardPrice[_card], cardPreviousPrice[_card]);
180 
181         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
182 
183         uint _blueDividends = SafeMath.div(SafeMath.mul(_baseDividends, blueDivRate),100);
184 
185         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends, ownerDivRate), 100);
186 
187         totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _ownerDividends);
188 
189         _ownerDividends = SafeMath.add(_ownerDividends, cardPreviousPrice[_card]);
190 
191         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends, distDivRate), 100);
192 
193         // If referrer is left blank,send to BLUE address
194         if (_referrer != msg.sender) {
195 
196             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends, referralRate), 100);
197 
198             _distDividends = SafeMath.sub(_distDividends, _referralDividends);
199 
200             if (_referrer == 0x0) {
201                 blueDividendAddr.transfer(_referralDividends);
202             }
203 
204             else {
205                 ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer], _referralDividends);
206             }
207         }
208 
209         //distribute dividends to accounts
210         address _previousOwner = cardOwner[_card];
211         address _newOwner = msg.sender;
212 
213         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner], _ownerDividends);
214 
215         blueDividendAddr.transfer(_blueDividends);
216 
217         distributeDivs(_distDividends);
218 
219         //Increment the card Price
220         cardPreviousPrice[_card] = cardPrice[_card];
221         cardPrice[_card] = _newPrice;
222         cardOwner[_card] = _newOwner;
223 
224         emit oncardPurchase(msg.sender, cardPreviousPrice[_card], _card, _newPrice);
225     }
226 
227 
228     function distributeDivs(uint _distDividends) internal{
229 
230             for (uint _card=0; _card < totalCards; _card++){
231 
232                 uint _divShare = SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
233                 uint _cardDivs = SafeMath.div(SafeMath.mul(_distDividends, _divShare), 10 ** precisionFactor);
234 
235                 ownerAccounts[cardOwner[_card]] += _cardDivs;
236 
237                 totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _cardDivs);
238             }
239         }
240 
241 
242     function withdraw()
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
292 
293     /*----------  HELPERS AND CALCULATORS  ----------*/
294     /**
295      * Method to view the current Ethereum stored in the contract
296      * Example: totalEthereumBalance()
297      */
298 
299 
300     function getMyBalance()
301         public
302         view
303         returns(uint)
304     {
305         return ownerAccounts[msg.sender];
306     }
307 
308     function getOwnerBalance(address _cardOwner)
309         public
310         view
311         returns(uint)
312     {
313         return ownerAccounts[_cardOwner];
314     }
315 
316     function getcardPrice(uint _card)
317         public
318         view
319         returns(uint)
320     {
321         require(_card < totalCards);
322         return cardPrice[_card];
323     }
324 
325     function getcardOwner(uint _card)
326         public
327         view
328         returns(address)
329     {
330         require(_card < totalCards);
331         return cardOwner[_card];
332     }
333 
334     function gettotalCardDivs(uint _card)
335         public
336         view
337         returns(uint)
338     {
339         require(_card < totalCards);
340         return totalCardDivs[_card];
341     }
342 
343     function getTotalDivsProduced()
344         public
345         view
346         returns(uint)
347     {
348         return totalDivsProduced;
349     }
350 
351     function getCardDivShare(uint _card)
352         public
353         view
354         returns(uint)
355     {
356         require(_card < totalCards);
357         return SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
358     }
359 
360     function getCardDivs(uint  _card, uint _amt)
361         public
362         view
363         returns(uint)
364     {
365         uint _share = getCardDivShare(_card);
366         return SafeMath.div(SafeMath.mul( _share, _amt), 10 ** precisionFactor);
367     }
368 
369     function gettotalCardValue()
370         public
371         view
372         returns(uint)
373     {
374 
375         return totalCardValue;
376     }
377 
378     function totalEthereumBalance()
379         public
380         view
381         returns(uint)
382     {
383         return address (this).balance;
384     }
385 
386     function gettotalCards()
387         public
388         view
389         returns(uint)
390     {
391         return totalCards;
392     }
393 
394 }
395 
396 /**
397  * @title SafeMath
398  * @dev Math operations with safety checks that throw on error
399  */
400 library SafeMath {
401 
402     /**
403     * @dev Multiplies two numbers, throws on overflow.
404     */
405     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
406         if (a == 0) {
407             return 0;
408         }
409         uint256 c = a * b;
410         assert(c / a == b);
411         return c;
412     }
413 
414     /**
415     * @dev Integer division of two numbers, truncating the quotient.
416     */
417     function div(uint256 a, uint256 b) internal pure returns (uint256) {
418         // assert(b > 0); // Solidity automatically throws when dividing by 0
419         uint256 c = a / b;
420         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
421         return c;
422     }
423 
424     /**
425     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
426     */
427     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
428         assert(b <= a);
429         return a - b;
430     }
431 
432     /**
433     * @dev Adds two numbers, throws on overflow.
434     */
435     function add(uint256 a, uint256 b) internal pure returns (uint256) {
436         uint256 c = a + b;
437         assert(c >= a);
438         return c;
439     }
440 }