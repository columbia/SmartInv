1 pragma solidity ^0.4.24;
2 
3 /*
4 *
5 * https://fundingsecured.me/founders/
6 *
7 *  ███████╗ ██████╗ ██╗   ██╗███╗   ██╗██████╗ ███████╗██████╗
8 *  ██╔════╝██╔═══██╗██║   ██║████╗  ██║██╔══██╗██╔════╝██╔══██╗
9 *  █████╗  ██║   ██║██║   ██║██╔██╗ ██║██║  ██║█████╗  ██████╔╝
10 *  ██╔══╝  ██║   ██║██║   ██║██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗
11 *  ██║     ╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝███████╗██║  ██║
12 *  ╚═╝      ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚═╝
13 *
14 *   ██████╗ █████╗ ██████╗ ██████╗ ███████╗
15 *  ██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔════╝
16 *  ██║     ███████║██████╔╝██║  ██║███████╗
17 *  ██║     ██╔══██║██╔══██╗██║  ██║╚════██║
18 *  ╚██████╗██║  ██║██║  ██║██████╔╝███████║
19 *   ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝
20 *
21 * https://fundingsecured.me/founders/
22 *
23 */
24 
25 contract FounderCards {
26     /*=================================
27     =        MODIFIERS        =
28     =================================*/
29     modifier onlyOwner(){
30         require(msg.sender == dev);
31         _;
32     }
33 
34     /*==============================
35     =            EVENTS            =
36     ==============================*/
37     event oncardPurchase(
38         address customerAddress,
39         uint256 incomingEthereum,
40         uint256 card,
41         uint256 newPrice
42     );
43 
44     event onWithdraw(
45         address customerAddress,
46         uint256 ethereumWithdrawn
47     );
48 
49     // ERC20
50     event Transfer(
51         address from,
52         address to,
53         uint256 card
54     );
55 
56 
57     /*=====================================
58     =            CONFIGURABLES            =
59     =====================================*/
60     string public name = "FOUNDER CARDS";
61     string public symbol = "FOUNDERS";
62 
63     uint8 constant public fsDivRate = 10;
64     uint8 constant public ownerDivRate = 50;
65     uint8 constant public distDivRate = 40;
66     uint8 constant public referralRate = 5;
67     uint8 constant public decimals = 18;
68     uint public totalCardValue = 6 ether; // Make sure this is sum of starting card values
69     uint public precisionFactor = 9;
70 
71 
72    /*================================
73     =            DATASETS            =
74     ================================*/
75 
76     mapping(uint => address) internal cardOwner;
77     mapping(uint => uint) public cardPrice;
78     mapping(uint => uint) internal cardPreviousPrice;
79     mapping(address => uint) internal ownerAccounts;
80     mapping(uint => uint) internal totalCardDivs;
81 
82     uint cardPriceIncrement = 110;
83     uint totalDivsProduced = 0;
84 
85     uint public totalCards;
86 
87     uint ACTIVATION_TIME = 1537916399;
88 
89     address dev;
90     address cs;
91     address cf;
92     address fundsDividendAddr;
93 
94     // Raffle Winners
95     address w1;
96     address w2;
97     address w3;
98 
99     /*=======================================
100     =            PUBLIC FUNCTIONS            =
101     =======================================*/
102     /*
103     * -- APPLICATION ENTRY POINTS --
104     */
105     constructor()
106         public
107     {
108         dev = msg.sender;
109         fundsDividendAddr = 0xd529ADaE263048f495A05B858c8E7C077F047813;
110 
111         cs = 0xEafE863757a2b2a2c5C3f71988b7D59329d09A78;
112         cf = 0x0A49857F69919AEcddbA77136364Bb19108B4891;
113 
114         w1 = 0xb563aca579753750980d45cd65673ff38c43a577;
115         w2 = 0x38602d1446fe063444B04C3CA5eCDe0cbA104240;
116         w3 = 0x190a2409fc6434483d4c2cab804e75e3bc5ebfa6;
117 
118         totalCards = 12;
119 
120         cardOwner[0] = w1;
121         cardPrice[0] = 1.2 ether;
122         cardPreviousPrice[0] = cardPrice[0];
123 
124         cardOwner[1] = w2;
125         cardPrice[1] = 1 ether;
126         cardPreviousPrice[1] = cardPrice[1];
127 
128         cardOwner[2] = w3;
129         cardPrice[2] = 0.8 ether;
130         cardPreviousPrice[2] = cardPrice[2];
131 
132         cardOwner[3] = cf;
133         cardPrice[3] = 0.7 ether;
134         cardPreviousPrice[3] = cardPrice[3];
135 
136         cardOwner[4] = cf;
137         cardPrice[4] = 0.6 ether;
138         cardPreviousPrice[4] = cardPrice[4];
139 
140         cardOwner[5] = cf;
141         cardPrice[5] = 0.5 ether;
142         cardPreviousPrice[5] = cardPrice[5];
143 
144         cardOwner[6] = cs;
145         cardPrice[6] = 0.4 ether;
146         cardPreviousPrice[6] = cardPrice[6];
147 
148         cardOwner[7] = cs;
149         cardPrice[7] = 0.3 ether;
150         cardPreviousPrice[7] = cardPrice[7];
151 
152         cardOwner[8] = cs;
153         cardPrice[8] = 0.25 ether;
154         cardPreviousPrice[8] = cardPrice[8];
155 
156         cardOwner[9] = dev;
157         cardPrice[9] = 0.13 ether;
158         cardPreviousPrice[9] = cardPrice[9];
159 
160         cardOwner[10] = dev;
161         cardPrice[10] = 0.07 ether;
162         cardPreviousPrice[10] = cardPrice[10];
163 
164         cardOwner[11] = dev;
165         cardPrice[11] = 0.05 ether;
166         cardPreviousPrice[11] = cardPrice[11];
167     }
168 
169     function addtotalCardValue(uint _new, uint _old)
170     internal
171     {
172         uint newPrice = SafeMath.div(SafeMath.mul(_new,cardPriceIncrement),100);
173         totalCardValue = SafeMath.add(totalCardValue, SafeMath.sub(newPrice,_old));
174     }
175 
176     function buy(uint _card, address _referrer)
177         public
178         payable
179 
180     {
181         require(_card < totalCards);
182         require(now >= ACTIVATION_TIME);
183         require(msg.value >= cardPrice[_card]);
184         require(msg.sender != cardOwner[_card]);
185 
186         // Return excess ether if buyer overpays
187         if (msg.value > cardPrice[_card]){
188             uint _excess = SafeMath.sub(msg.value, cardPrice[_card]);
189             ownerAccounts[msg.sender] += _excess;
190         }
191 
192         addtotalCardValue(cardPrice[_card], cardPreviousPrice[_card]);
193 
194         uint _newPrice = SafeMath.div(SafeMath.mul(cardPrice[_card], cardPriceIncrement), 100);
195 
196          //Determine the total dividends
197         uint _baseDividends = SafeMath.sub(cardPrice[_card], cardPreviousPrice[_card]);
198 
199         totalDivsProduced = SafeMath.add(totalDivsProduced, _baseDividends);
200 
201         uint _fsDividends = SafeMath.div(SafeMath.mul(_baseDividends, fsDivRate),100);
202 
203         uint _ownerDividends = SafeMath.div(SafeMath.mul(_baseDividends, ownerDivRate), 100);
204 
205         totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _ownerDividends);
206 
207         _ownerDividends = SafeMath.add(_ownerDividends, cardPreviousPrice[_card]);
208 
209         uint _distDividends = SafeMath.div(SafeMath.mul(_baseDividends, distDivRate), 100);
210 
211         // If referrer is left blank,send to FUND address
212         if (_referrer != msg.sender) {
213 
214             uint _referralDividends = SafeMath.div(SafeMath.mul(_baseDividends, referralRate), 100);
215 
216             _distDividends = SafeMath.sub(_distDividends, _referralDividends);
217 
218             if (_referrer == 0x0) {
219                 fundsDividendAddr.transfer(_referralDividends);
220             }
221 
222             else {
223                 ownerAccounts[_referrer] = SafeMath.add(ownerAccounts[_referrer], _referralDividends);
224             }
225         }
226 
227         //distribute dividends to accounts
228         address _previousOwner = cardOwner[_card];
229         address _newOwner = msg.sender;
230 
231         ownerAccounts[_previousOwner] = SafeMath.add(ownerAccounts[_previousOwner], _ownerDividends);
232 
233         fundsDividendAddr.transfer(_fsDividends);
234 
235         distributeDivs(_distDividends);
236 
237         //Increment the card Price
238         cardPreviousPrice[_card] = cardPrice[_card];
239         cardPrice[_card] = _newPrice;
240         cardOwner[_card] = _newOwner;
241 
242         emit oncardPurchase(msg.sender, cardPreviousPrice[_card], _card, _newPrice);
243     }
244 
245 
246     function distributeDivs(uint _distDividends) internal{
247 
248             for (uint _card=0; _card < totalCards; _card++){
249 
250                 uint _divShare = SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
251                 uint _cardDivs = SafeMath.div(SafeMath.mul(_distDividends, _divShare), 10 ** precisionFactor);
252 
253                 ownerAccounts[cardOwner[_card]] += _cardDivs;
254 
255                 totalCardDivs[_card] = SafeMath.add(totalCardDivs[_card], _cardDivs);
256             }
257         }
258 
259 
260     function withdraw()
261         public
262     {
263         address _customerAddress = msg.sender;
264         require(ownerAccounts[_customerAddress] >= 0.001 ether);
265 
266         uint _dividends = ownerAccounts[_customerAddress];
267         ownerAccounts[_customerAddress] = 0;
268 
269         _customerAddress.transfer(_dividends);
270 
271         emit onWithdraw(_customerAddress, _dividends);
272     }
273 
274 
275 
276     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
277     function setName(string _name)
278         onlyOwner()
279         public
280     {
281         name = _name;
282     }
283 
284 
285     function setSymbol(string _symbol)
286         onlyOwner()
287         public
288     {
289         symbol = _symbol;
290     }
291 
292     function setcardPrice(uint _card, uint _price)   //Allow the changing of a card price owner if the dev owns it
293         onlyOwner()
294         public
295     {
296         require(cardOwner[_card] == dev);
297         cardPrice[_card] = _price;
298     }
299 
300     function addNewcard(uint _price)
301         onlyOwner()
302         public
303     {
304         cardPrice[totalCards-1] = _price;
305         cardOwner[totalCards-1] = dev;
306         totalCardDivs[totalCards-1] = 0;
307         totalCards = totalCards + 1;
308     }
309 
310 
311     /*----------  HELPERS AND CALCULATORS  ----------*/
312     /**
313      * Method to view the current Ethereum stored in the contract
314      * Example: totalEthereumBalance()
315      */
316 
317 
318     function getMyBalance()
319         public
320         view
321         returns(uint)
322     {
323         return ownerAccounts[msg.sender];
324     }
325 
326     function getOwnerBalance(address _cardOwner)
327         public
328         view
329         returns(uint)
330     {
331         return ownerAccounts[_cardOwner];
332     }
333 
334     function getcardPrice(uint _card)
335         public
336         view
337         returns(uint)
338     {
339         require(_card < totalCards);
340         return cardPrice[_card];
341     }
342 
343     function getcardOwner(uint _card)
344         public
345         view
346         returns(address)
347     {
348         require(_card < totalCards);
349         return cardOwner[_card];
350     }
351 
352     function gettotalCardDivs(uint _card)
353         public
354         view
355         returns(uint)
356     {
357         require(_card < totalCards);
358         return totalCardDivs[_card];
359     }
360 
361     function getTotalDivsProduced()
362         public
363         view
364         returns(uint)
365     {
366         return totalDivsProduced;
367     }
368 
369     function getCardDivShare(uint _card)
370         public
371         view
372         returns(uint)
373     {
374         require(_card < totalCards);
375         return SafeMath.div(SafeMath.div(SafeMath.mul(cardPreviousPrice[_card], 10 ** (precisionFactor + 1)), totalCardValue) + 5, 10);
376     }
377 
378     function getCardDivs(uint  _card, uint _amt)
379         public
380         view
381         returns(uint)
382     {
383         uint _share = getCardDivShare(_card);
384         return SafeMath.div(SafeMath.mul( _share, _amt), 10 ** precisionFactor);
385     }
386 
387     function gettotalCardValue()
388         public
389         view
390         returns(uint)
391     {
392 
393         return totalCardValue;
394     }
395 
396     function totalEthereumBalance()
397         public
398         view
399         returns(uint)
400     {
401         return address (this).balance;
402     }
403 
404     function gettotalCards()
405         public
406         view
407         returns(uint)
408     {
409         return totalCards;
410     }
411 
412 }
413 
414 /**
415  * @title SafeMath
416  * @dev Math operations with safety checks that throw on error
417  */
418 library SafeMath {
419 
420     /**
421     * @dev Multiplies two numbers, throws on overflow.
422     */
423     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
424         if (a == 0) {
425             return 0;
426         }
427         uint256 c = a * b;
428         assert(c / a == b);
429         return c;
430     }
431 
432     /**
433     * @dev Integer division of two numbers, truncating the quotient.
434     */
435     function div(uint256 a, uint256 b) internal pure returns (uint256) {
436         // assert(b > 0); // Solidity automatically throws when dividing by 0
437         uint256 c = a / b;
438         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
439         return c;
440     }
441 
442     /**
443     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
444     */
445     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
446         assert(b <= a);
447         return a - b;
448     }
449 
450     /**
451     * @dev Adds two numbers, throws on overflow.
452     */
453     function add(uint256 a, uint256 b) internal pure returns (uint256) {
454         uint256 c = a + b;
455         assert(c >= a);
456         return c;
457     }
458 }