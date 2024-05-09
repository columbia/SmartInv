1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 * 
6 */
7 
8 contract DividendFacialCardGame {
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
48     string public name = "DIVIDEND FACIAL CARDS";
49     string public symbol = "DFC";
50 
51     uint8 constant public cardsDivRate = 10;
52     uint8 constant public ownerDivRate = 50;
53     uint8 constant public distDivRate = 40;
54     uint8 constant public referralRate = 5;
55     uint8 constant public decimals = 18;
56     uint public totalCardValue = 7.25 ether; // Make sure this is sum of constructor values
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
80     address dftDivsAddr;
81 
82 
83     /*=======================================
84     =            PUBLIC FUNCTIONS            =
85     =======================================*/
86     /*
87     * -- APPLICATION ENTRY POINTS --
88     */
89     constructor()
90         public
91     {
92         dev = msg.sender;
93         promoter = 0x260BB292817c668caF44Eb4c7A281A1ef3DDbbf3;
94         promoter2 = 0xc7F15d0238d207e19cce6bd6C0B85f343896F046;
95         dftDivsAddr = 0x5e4b7b9365bce0bebb7d22790cc3470edcdcf980;
96 
97         totalCards = 12;
98 
99         cardOwner[0] = dev;
100         cardPrice[0] = 2 ether;
101         cardPreviousPrice[0] = cardPrice[0];
102 
103         cardOwner[1] = dev;
104         cardPrice[1] = 1.5 ether;
105         cardPreviousPrice[1] = cardPrice[1];
106 
107         cardOwner[2] = promoter;
108         cardPrice[2] = 1 ether;
109         cardPreviousPrice[2] = cardPrice[2];
110 
111         cardOwner[3] = promoter2;
112         cardPrice[3] = 0.9 ether;
113         cardPreviousPrice[3] = cardPrice[3];
114 
115         cardOwner[4] = dev;
116         cardPrice[4] = 0.75 ether;
117         cardPreviousPrice[4] = cardPrice[4];
118 
119         cardOwner[5] = dev;
120         cardPrice[5] = 0.50 ether;
121         cardPreviousPrice[5] = cardPrice[5];
122 
123         cardOwner[6] = dev;
124         cardPrice[6] = 0.25 ether;
125         cardPreviousPrice[6] = cardPrice[6];
126 
127         cardOwner[7] = dev;
128         cardPrice[7] = 0.12 ether;
129         cardPreviousPrice[7] = cardPrice[7];
130 
131         cardOwner[8] = promoter;
132         cardPrice[8] = 0.08 ether;
133         cardPreviousPrice[8] = cardPrice[8];
134 
135         cardOwner[9] = dev;
136         cardPrice[9] = 0.05 ether;
137         cardPreviousPrice[9] = cardPrice[9];
138 
139         cardOwner[10] = promoter2;
140         cardPrice[10] = 0.05 ether;
141         cardPreviousPrice[10] = cardPrice[10];
142 
143         cardOwner[11] = promoter;
144         cardPrice[11] = 0.05 ether;
145         cardPreviousPrice[11] = cardPrice[11];
146 
147     }
148 
149     function addtotalCardValue(uint _new, uint _old)
150     internal
151     {
152         uint newPrice = SafeMath.div(SafeMath.mul(_new,cardPriceIncrement),100);
153         totalCardValue = SafeMath.add(totalCardValue, SafeMath.sub(newPrice,_old));
154     }
155 
156     function buy(uint _card, address _referrer)
157         public
158         payable
159 
160     {
161         require(_card < totalCards);
162         require(msg.value == cardPrice[_card]);
163         require(msg.sender != cardOwner[_card]);
164 
165         addtotalCardValue(msg.value, cardPreviousPrice[_card]);
166 
167         uint _newPrice = SafeMath.div(SafeMath.mul(msg.value, cardPriceIncrement), 100);
168 
169          //Determine the total dividends
170         uint _baseDividends = SafeMath.sub(msg.value, cardPreviousPrice[_card]);
171 
172         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
173 
174         uint _cardsDividends = SafeMath.div(SafeMath.mul(_baseDividends, cardsDivRate),100);
175 
176         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends, ownerDivRate), 100);
177 
178         totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _ownerDividends);
179 
180         _ownerDividends = SafeMath.add(_ownerDividends, cardPreviousPrice[_card]);
181 
182         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends, distDivRate), 100);
183 
184         if (allowReferral && (_referrer != msg.sender) && (_referrer != 0x0000000000000000000000000000000000000000)) {
185 
186             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends, referralRate), 100);
187 
188             _distDividends = SafeMath.sub(_distDividends, _referralDividends);
189 
190             ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer], _referralDividends);
191         }
192 
193 
194         //distribute dividends to accounts
195         address _previousOwner = cardOwner[_card];
196         address _newOwner = msg.sender;
197 
198         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner], _ownerDividends);
199 
200         dftDivsAddr.transfer(_cardsDividends);
201 
202         distributeDivs(_distDividends);
203 
204         //Increment the card Price
205         cardPreviousPrice[_card] = msg.value;
206         cardPrice[_card] = _newPrice;
207         cardOwner[_card] = _newOwner;
208 
209         emit oncardPurchase(msg.sender, msg.value, _card, SafeMath.div(SafeMath.mul(msg.value, cardPriceIncrement), 100));
210     }
211 
212 
213     function distributeDivs(uint _distDividends) internal{
214 
215             for (uint _card=0; _card < totalCards; _card++){
216 
217                 uint _divShare = SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
218                 uint _cardDivs = SafeMath.div(SafeMath.mul(_distDividends, _divShare), 10 ** precisionFactor);
219 
220                 ownerAccounts[cardOwner[_card]] += _cardDivs;
221 
222                 totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _cardDivs);
223             }
224         }
225 
226 
227     function withdraw()
228 
229         public
230     {
231         address _customerAddress = msg.sender;
232         require(ownerAccounts[_customerAddress] >= 0.001 ether);
233 
234         uint _dividends = ownerAccounts[_customerAddress];
235         ownerAccounts[_customerAddress] = 0;
236 
237         _customerAddress.transfer(_dividends);
238 
239         emit onWithdraw(_customerAddress, _dividends);
240     }
241 
242 
243 
244     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
245     function setName(string _name)
246         onlyOwner()
247         public
248     {
249         name = _name;
250     }
251 
252 
253     function setSymbol(string _symbol)
254         onlyOwner()
255         public
256     {
257         symbol = _symbol;
258     }
259 
260     function setcardPrice(uint _card, uint _price)   //Allow the changing of a card price owner if the dev owns it
261         onlyOwner()
262         public
263     {
264         require(cardOwner[_card] == dev);
265         cardPrice[_card] = _price;
266     }
267 
268     function addNewcard(uint _price)
269         onlyOwner()
270         public
271     {
272         cardPrice[totalCards-1] = _price;
273         cardOwner[totalCards-1] = dev;
274         totalCardDivs[totalCards-1] = 0;
275         totalCards = totalCards + 1;
276     }
277 
278     function setAllowReferral(bool _allowReferral)
279         onlyOwner()
280         public
281     {
282         allowReferral = _allowReferral;
283     }
284 
285 
286 
287     /*----------  HELPERS AND CALCULATORS  ----------*/
288     /**
289      * Method to view the current Ethereum stored in the contract
290      * Example: totalEthereumBalance()
291      */
292 
293 
294     function getMyBalance()
295         public
296         view
297         returns(uint)
298     {
299         return ownerAccounts[msg.sender];
300     }
301 
302     function getOwnerBalance(address _cardOwner)
303         public
304         view
305         returns(uint)
306     {
307         return ownerAccounts[_cardOwner];
308     }
309 
310     function getcardPrice(uint _card)
311         public
312         view
313         returns(uint)
314     {
315         require(_card < totalCards);
316         return cardPrice[_card];
317     }
318 
319     function getcardOwner(uint _card)
320         public
321         view
322         returns(address)
323     {
324         require(_card < totalCards);
325         return cardOwner[_card];
326     }
327 
328     function gettotalCardDivs(uint _card)
329         public
330         view
331         returns(uint)
332     {
333         require(_card < totalCards);
334         return totalCardDivs[_card];
335     }
336 
337     function getTotalDivsProduced()
338         public
339         view
340         returns(uint)
341     {
342         return totalDivsProduced;
343     }
344 
345     function getCardDivShare(uint _card)
346         public
347         view
348         returns(uint)
349     {
350         require(_card < totalCards);
351         return SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
352     }
353 
354     function getCardDivs(uint  _card, uint _amt)
355         public
356         view
357         returns(uint)
358     {
359         uint _share = getCardDivShare(_card);
360         return SafeMath.div(SafeMath.mul( _share, _amt), 10 ** precisionFactor);
361     }
362 
363     function gettotalCardValue()
364         public
365         view
366         returns(uint)
367     {
368 
369         return totalCardValue;
370     }
371 
372     function totalEthereumBalance()
373         public
374         view
375         returns(uint)
376     {
377         return address (this).balance;
378     }
379 
380     function gettotalCards()
381         public
382         view
383         returns(uint)
384     {
385         return totalCards;
386     }
387 
388 }
389 
390 /**
391  * @title SafeMath
392  * @dev Math operations with safety checks that throw on error
393  */
394 library SafeMath {
395 
396     /**
397     * @dev Multiplies two numbers, throws on overflow.
398     */
399     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
400         if (a == 0) {
401             return 0;
402         }
403         uint256 c = a * b;
404         assert(c / a == b);
405         return c;
406     }
407 
408     /**
409     * @dev Integer division of two numbers, truncating the quotient.
410     */
411     function div(uint256 a, uint256 b) internal pure returns (uint256) {
412         // assert(b > 0); // Solidity automatically throws when dividing by 0
413         uint256 c = a / b;
414         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
415         return c;
416     }
417 
418     /**
419     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
420     */
421     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
422         assert(b <= a);
423         return a - b;
424     }
425 
426     /**
427     * @dev Adds two numbers, throws on overflow.
428     */
429     function add(uint256 a, uint256 b) internal pure returns (uint256) {
430         uint256 c = a + b;
431         assert(c >= a);
432         return c;
433     }
434 }