1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 * 
6 */
7 
8 contract CryptoCards {
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
78     address ddtDivsAddr;
79 
80 
81     /*=======================================
82     =            PUBLIC FUNCTIONS            =
83     =======================================*/
84     /*
85     * -- APPLICATION ENTRY POINTS --
86     */
87     constructor()
88         public
89     {
90         dev = msg.sender;
91         ddtDivsAddr = 0xC4C3B0B3b829D529c812cb825426645BA97Bd40c;
92 
93         totalCards = 12;
94 
95         cardOwner[0] = dev;
96         cardPrice[0] = 4 ether;
97         cardPreviousPrice[0] = cardPrice[0];
98 
99         cardOwner[1] = dev;
100         cardPrice[1] = 2 ether;
101         cardPreviousPrice[1] = cardPrice[1];
102 
103         cardOwner[2] = dev;
104         cardPrice[2] = 1 ether;
105         cardPreviousPrice[2] = cardPrice[2];
106 
107         cardOwner[3] = dev;
108         cardPrice[3] = 0.9 ether;
109         cardPreviousPrice[3] = cardPrice[3];
110 
111         cardOwner[4] = dev;
112         cardPrice[4] = 0.75 ether;
113         cardPreviousPrice[4] = cardPrice[4];
114 
115         cardOwner[5] = dev;
116         cardPrice[5] = 0.50 ether;
117         cardPreviousPrice[5] = cardPrice[5];
118 
119         cardOwner[6] = dev;
120         cardPrice[6] = 0.25 ether;
121         cardPreviousPrice[6] = cardPrice[6];
122 
123         cardOwner[7] = dev;
124         cardPrice[7] = 0.12 ether;
125         cardPreviousPrice[7] = cardPrice[7];
126 
127         cardOwner[8] = dev;
128         cardPrice[8] = 0.08 ether;
129         cardPreviousPrice[8] = cardPrice[8];
130 
131         cardOwner[9] = dev;
132         cardPrice[9] = 0.05 ether;
133         cardPreviousPrice[9] = cardPrice[9];
134 
135         cardOwner[10] = dev;
136         cardPrice[10] = 0.05 ether;
137         cardPreviousPrice[10] = cardPrice[10];
138 
139         cardOwner[11] = dev;
140         cardPrice[11] = 0.05 ether;
141         cardPreviousPrice[11] = cardPrice[11];
142 
143     }
144 
145     function addtotalCardValue(uint _new, uint _old)
146     internal
147     {
148         uint newPrice = SafeMath.div(SafeMath.mul(_new,cardPriceIncrement),100);
149         totalCardValue = SafeMath.add(totalCardValue, SafeMath.sub(newPrice,_old));
150     }
151 
152     function buy(uint _card, address _referrer)
153         public
154         payable
155 
156     {
157         require(_card < totalCards);
158         require(msg.value == cardPrice[_card]);
159         require(msg.sender != cardOwner[_card]);
160 
161         addtotalCardValue(msg.value, cardPreviousPrice[_card]);
162 
163         uint _newPrice = SafeMath.div(SafeMath.mul(msg.value, cardPriceIncrement), 100);
164 
165          //Determine the total dividends
166         uint _baseDividends = SafeMath.sub(msg.value, cardPreviousPrice[_card]);
167 
168         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
169 
170         uint _cardsDividends = SafeMath.div(SafeMath.mul(_baseDividends, cardsDivRate),100);
171 
172         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends, ownerDivRate), 100);
173 
174         totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _ownerDividends);
175 
176         _ownerDividends = SafeMath.add(_ownerDividends, cardPreviousPrice[_card]);
177 
178         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends, distDivRate), 100);
179 
180         if (allowReferral && (_referrer != msg.sender) && (_referrer != 0x0000000000000000000000000000000000000000)) {
181 
182             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends, referralRate), 100);
183 
184             _distDividends = SafeMath.sub(_distDividends, _referralDividends);
185 
186             ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer], _referralDividends);
187         }
188 
189 
190         //distribute dividends to accounts
191         address _previousOwner = cardOwner[_card];
192         address _newOwner = msg.sender;
193 
194         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner], _ownerDividends);
195 
196         ddtDivsAddr.transfer(_cardsDividends);
197 
198         distributeDivs(_distDividends);
199 
200         //Increment the card Price
201         cardPreviousPrice[_card] = msg.value;
202         cardPrice[_card] = _newPrice;
203         cardOwner[_card] = _newOwner;
204 
205         emit oncardPurchase(msg.sender, msg.value, _card, SafeMath.div(SafeMath.mul(msg.value, cardPriceIncrement), 100));
206     }
207 
208 
209     function distributeDivs(uint _distDividends) internal{
210 
211             for (uint _card=0; _card < totalCards; _card++){
212 
213                 uint _divShare = SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
214                 uint _cardDivs = SafeMath.div(SafeMath.mul(_distDividends, _divShare), 10 ** precisionFactor);
215 
216                 ownerAccounts[cardOwner[_card]] += _cardDivs;
217 
218                 totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _cardDivs);
219             }
220         }
221 
222 
223     function withdraw()
224 
225         public
226     {
227         address _customerAddress = msg.sender;
228         require(ownerAccounts[_customerAddress] >= 0.001 ether);
229 
230         uint _dividends = ownerAccounts[_customerAddress];
231         ownerAccounts[_customerAddress] = 0;
232 
233         _customerAddress.transfer(_dividends);
234 
235         emit onWithdraw(_customerAddress, _dividends);
236     }
237 
238 
239 
240     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
241     function setName(string _name)
242         onlyOwner()
243         public
244     {
245         name = _name;
246     }
247 
248 
249     function setSymbol(string _symbol)
250         onlyOwner()
251         public
252     {
253         symbol = _symbol;
254     }
255 
256     function setcardPrice(uint _card, uint _price)   //Allow the changing of a card price owner if the dev owns it
257         onlyOwner()
258         public
259     {
260         require(cardOwner[_card] == dev);
261         cardPrice[_card] = _price;
262     }
263 
264     function addNewcard(uint _price)
265         onlyOwner()
266         public
267     {
268         cardPrice[totalCards-1] = _price;
269         cardOwner[totalCards-1] = dev;
270         totalCardDivs[totalCards-1] = 0;
271         totalCards = totalCards + 1;
272     }
273 
274     function setAllowReferral(bool _allowReferral)
275         onlyOwner()
276         public
277     {
278         allowReferral = _allowReferral;
279     }
280 
281 
282 
283     /*----------  HELPERS AND CALCULATORS  ----------*/
284     /**
285      * Method to view the current Ethereum stored in the contract
286      * Example: totalEthereumBalance()
287      */
288 
289 
290     function getMyBalance()
291         public
292         view
293         returns(uint)
294     {
295         return ownerAccounts[msg.sender];
296     }
297 
298     function getOwnerBalance(address _cardOwner)
299         public
300         view
301         returns(uint)
302     {
303         return ownerAccounts[_cardOwner];
304     }
305 
306     function getcardPrice(uint _card)
307         public
308         view
309         returns(uint)
310     {
311         require(_card < totalCards);
312         return cardPrice[_card];
313     }
314 
315     function getcardOwner(uint _card)
316         public
317         view
318         returns(address)
319     {
320         require(_card < totalCards);
321         return cardOwner[_card];
322     }
323 
324     function gettotalCardDivs(uint _card)
325         public
326         view
327         returns(uint)
328     {
329         require(_card < totalCards);
330         return totalCardDivs[_card];
331     }
332 
333     function getTotalDivsProduced()
334         public
335         view
336         returns(uint)
337     {
338         return totalDivsProduced;
339     }
340 
341     function getCardDivShare(uint _card)
342         public
343         view
344         returns(uint)
345     {
346         require(_card < totalCards);
347         return SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
348     }
349 
350     function getCardDivs(uint  _card, uint _amt)
351         public
352         view
353         returns(uint)
354     {
355         uint _share = getCardDivShare(_card);
356         return SafeMath.div(SafeMath.mul( _share, _amt), 10 ** precisionFactor);
357     }
358 
359     function gettotalCardValue()
360         public
361         view
362         returns(uint)
363     {
364 
365         return totalCardValue;
366     }
367 
368     function totalEthereumBalance()
369         public
370         view
371         returns(uint)
372     {
373         return address (this).balance;
374     }
375 
376     function gettotalCards()
377         public
378         view
379         returns(uint)
380     {
381         return totalCards;
382     }
383 
384 }
385 
386 /**
387  * @title SafeMath
388  * @dev Math operations with safety checks that throw on error
389  */
390 library SafeMath {
391 
392     /**
393     * @dev Multiplies two numbers, throws on overflow.
394     */
395     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
396         if (a == 0) {
397             return 0;
398         }
399         uint256 c = a * b;
400         assert(c / a == b);
401         return c;
402     }
403 
404     /**
405     * @dev Integer division of two numbers, truncating the quotient.
406     */
407     function div(uint256 a, uint256 b) internal pure returns (uint256) {
408         // assert(b > 0); // Solidity automatically throws when dividing by 0
409         uint256 c = a / b;
410         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
411         return c;
412     }
413 
414     /**
415     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
416     */
417     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
418         assert(b <= a);
419         return a - b;
420     }
421 
422     /**
423     * @dev Adds two numbers, throws on overflow.
424     */
425     function add(uint256 a, uint256 b) internal pure returns (uint256) {
426         uint256 c = a + b;
427         assert(c >= a);
428         return c;
429     }
430 }