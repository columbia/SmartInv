1 pragma solidity ^0.4.18;
2 
3 /**
4  *
5  * @author  <pratyush.bhatt@protonmail.com>
6  *
7  * RDFDM - Riverdimes Fiat Donation Manager
8  * Version D
9  *
10  * Overview:
11  * four basic round-up operations are supported:
12  *
13  * A) fiatCollected: Record Fiat Donation (collection)
14  *    inputs:        charity (C), fiat amount ($XX.XX),
15  *    summary:       creates a log of a fiat donation to a specified charity, C.
16  *    message:       $XX.XX collected FBO Charity C, internal document #ABC
17  *    - add $XX.XX to chariy's fiatBalanceIn, fiatCollected
18  *
19  * B) fiatToEth:     Fiat Converted to ETH
20  *    inputs:        charity (C), fiat amount ($XX.XX), ETH amount (Z), document reference (ABC)
21  *    summary:       deduct $XX.XX from charity C's fiatBalanceIn; credit charity C's ethBalanceIn. this operation is invoked
22  *                   when fiat donations are converted to ETH. it includes a deposit of Z ETH.
23  *    message(s):    On behalf of Charity C, $XX.XX used to purchase Z ETH
24  *    - $XX.XX deducted from charity C's fiatBalanceIn
25  *    - skims 4% of Z for RD Token holders, and 16% for operational overhead
26  *    - credits charity C with 80% of Z ETH (ethBalance)
27  *
28  * C) ethToFiat:     ETH Converted to Fiat
29  *    inputs:        charity (C), ETH amount (Z), fiat amount ($XX.XX), document reference (ABC)
30  *    summary:       withdraw ETH from and convert to fiat
31  *    message(s):    Z ETH converted to $XX.XX FBO Charity C
32  *    - deducts Z ETH from charity C's ethBalance
33  *    - adds $XX.XX to charity C's fiatBalanceOut
34  *
35  * D) fiatDelivered: Record Fiat Delivery to Specified Charity
36  *    inputs:        charity (C), fiat amount ($XX.XX), document reference (ABC)
37  *    summary:       creates a log of a fiat delivery to a specified charity, C:
38  *    message:       $XX.XX delivered to Charity C, internal document #ABC
39  *    - deducts the dollar amount, $XX.XX from charity's fiatBalanceOut
40  *    - add $XX.XX to charity's totalDelivered
41  *
42  * one basic operation, unrelated to round-up
43  *
44  * A) ethDonation:        Direct ETH Donation to Charity
45  *    inputs:             charity (C), ETH amount (Z), document reference (ABC)
46  *    summary:            ETH donation to a specified charity, crediting charity's ethBalance. ETH in transaction.
47  *    messages:           Z ETH donated to Charity C, internal document #ABC
48  *    - add Z ETH to chariy's ethDonated
49  *    - skims 0.5% of Z for RD Token holders, and 1.5% for operational overhead
50  *    - credits charity C with 98% of Z ETH (ethBalance)
51  *
52  * in addition there are shortcut operations (related to round-up):
53  *
54  * A) fiatCollectedToEth: Record Fiat Donation (collection) and convert to ETH
55  *    inputs:             charity (C), fiat amount ($XX.XX), ETH amount (Z), document reference (ABC)
56  *    summary:            creates a log of a fiat donation to a specified charity, C; fiat donation is immediately converted to
57  *                        ETH, crediting charity C's ethBalance. the transaction includes a deposit of Z ETH.
58  *    messages:           $XX.XX collected FBO Charity C, internal document #ABC
59  *                        On behalf of Charity C, $XX.XX used to purchase Z ETH
60  *    - add $XX.XX to chariy's fiatCollected
61  *    - skims 4% of Z for RD Token holders, and 16% for operational overhead
62  *    - credits charity C with 80% of Z ETH (ethBalance)
63  *
64  * B) ethToFiatDelivered: Record ETH Conversion to Fiat; and Fiat Delivery to Specified Charity
65  *    inputs:             charity (C), ETH amount (Z), fiat amount ($XX.XX), document reference (ABC)
66  *    summary:            withdraw ETH from charity C's ethBalance and convert to fiat; log fiat delivery of $XX.XX.
67  *    messages:           Z ETH converted to $XX.XX FBO Charity C
68  *                        $XX.XX delivered to Charity C, internal document #ABC
69  *    - deducts Z ETH from charity C's ethBalance
70  *    - add $XX.XX to charity's totalDelivered
71  *
72  */
73 
74 //import './SafeMath.sol';
75 //contract RDFDM is SafeMath
76 contract RDFDM {
77 
78   //events relating to donation operations
79   //
80   event FiatCollectedEvent(uint indexed charity, uint usd, string ref);
81   event FiatToEthEvent(uint indexed charity, uint usd, uint eth);
82   event EthToFiatEvent(uint indexed charity, uint eth, uint usd);
83   event FiatDeliveredEvent(uint indexed charity, uint usd, string ref);
84   event EthDonationEvent(uint indexed charity, uint eth);
85 
86   //events relating to adding and deleting charities
87   //
88   event CharityAddedEvent(uint indexed charity, string name, uint8 currency);
89   event CharityModifiedEvent(uint indexed charity, string name, uint8 currency);
90 
91   //currencies
92   //
93   uint constant  CURRENCY_USD  = 0x01;
94   uint constant  CURRENCY_EURO = 0x02;
95   uint constant  CURRENCY_NIS  = 0x03;
96   uint constant  CURRENCY_YUAN = 0x04;
97 
98 
99   struct Charity {
100     uint fiatBalanceIn;           // funds in external acct, collected fbo charity
101     uint fiatBalanceOut;          // funds in external acct, pending delivery to charity
102     uint fiatCollected;           // total collected since dawn of creation
103     uint fiatDelivered;           // total delivered since dawn of creation
104     uint ethDonated;              // total eth donated since dawn of creation
105     uint ethCredited;             // total eth credited to this charity since dawn of creation
106     uint ethBalance;              // current eth balance of this charity
107     uint fiatToEthPriceAccEth;    // keep track of fiat to eth conversion price: total eth
108     uint fiatToEthPriceAccFiat;   // keep track of fiat to eth conversion price: total fiat
109     uint ethToFiatPriceAccEth;    // kkep track of eth to fiat conversion price: total eth
110     uint ethToFiatPriceAccFiat;   // kkep track of eth to fiat conversion price: total fiat
111     uint8 currency;               // fiat amounts are in smallest denomination of currency
112     string name;                  // eg. "Salvation Army"
113   }
114 
115   uint public charityCount;
116   address public owner;
117   address public manager;
118   address public token;           //token-holder fees sent to this address
119   address public operatorFeeAcct; //operations fees sent to this address
120   mapping (uint => Charity) public charities;
121   bool public isLocked;
122 
123   modifier ownerOnly {
124     require(msg.sender == owner);
125     _;
126   }
127 
128   modifier managerOnly {
129     require(msg.sender == owner || msg.sender == manager);
130     _;
131   }
132 
133   modifier unlockedOnly {
134     require(!isLocked);
135     _;
136   }
137 
138 
139   //
140   //constructor
141   //
142   function RDFDM() public {
143     owner = msg.sender;
144     manager = msg.sender;
145     token = msg.sender;
146     operatorFeeAcct = msg.sender;
147   }
148   function lock() public ownerOnly { isLocked = true; }
149   function setToken(address _token) public ownerOnly unlockedOnly { token = _token; }
150   function setOperatorFeeAcct(address _operatorFeeAcct) public ownerOnly { operatorFeeAcct = _operatorFeeAcct; }
151   function setManager(address _manager) public managerOnly { manager = _manager; }
152   function deleteManager() public managerOnly { manager = owner; }
153 
154 
155   function addCharity(string _name, uint8 _currency) public managerOnly {
156     charities[charityCount].name = _name;
157     charities[charityCount].currency = _currency;
158     CharityAddedEvent(charityCount, _name, _currency);
159     ++charityCount;
160   }
161 
162   function modifyCharity(uint _charity, string _name, uint8 _currency) public managerOnly {
163     require(_charity < charityCount);
164     charities[_charity].name = _name;
165     charities[_charity].currency = _currency;
166     CharityModifiedEvent(_charity, _name, _currency);
167   }
168 
169 
170 
171   //======== basic operations
172 
173   function fiatCollected(uint _charity, uint _fiat, string _ref) public managerOnly {
174     require(_charity < charityCount);
175     charities[_charity].fiatBalanceIn += _fiat;
176     charities[_charity].fiatCollected += _fiat;
177     FiatCollectedEvent(_charity, _fiat, _ref);
178   }
179 
180   function fiatToEth(uint _charity, uint _fiat) public managerOnly payable {
181     require(token != 0);
182     require(_charity < charityCount);
183     //keep track of fiat to eth conversion price
184     charities[_charity].fiatToEthPriceAccFiat += _fiat;
185     charities[_charity].fiatToEthPriceAccEth += msg.value;
186     charities[_charity].fiatBalanceIn -= _fiat;
187     uint _tokenCut = (msg.value * 4) / 100;
188     uint _operatorCut = (msg.value * 16) / 100;
189     uint _charityCredit = (msg.value - _operatorCut) - _tokenCut;
190     operatorFeeAcct.transfer(_operatorCut);
191     token.transfer(_tokenCut);
192     charities[_charity].ethBalance += _charityCredit;
193     charities[_charity].ethCredited += _charityCredit;
194     FiatToEthEvent(_charity, _fiat, msg.value);
195   }
196 
197   function ethToFiat(uint _charity, uint _eth, uint _fiat) public managerOnly {
198     require(_charity < charityCount);
199     require(charities[_charity].ethBalance >= _eth);
200     //keep track of fiat to eth conversion price
201     charities[_charity].ethToFiatPriceAccFiat += _fiat;
202     charities[_charity].ethToFiatPriceAccEth += _eth;
203     charities[_charity].ethBalance -= _eth;
204     charities[_charity].fiatBalanceOut += _fiat;
205     //withdraw funds to the caller
206     msg.sender.transfer(_eth);
207     EthToFiatEvent(_charity, _eth, _fiat);
208   }
209 
210   function fiatDelivered(uint _charity, uint _fiat, string _ref) public managerOnly {
211     require(_charity < charityCount);
212     require(charities[_charity].fiatBalanceOut >= _fiat);
213     charities[_charity].fiatBalanceOut -= _fiat;
214     charities[_charity].fiatDelivered += _fiat;
215     FiatDeliveredEvent(_charity, _fiat, _ref);
216   }
217 
218   //======== unrelated to round-up
219   function ethDonation(uint _charity) public payable {
220     require(token != 0);
221     require(_charity < charityCount);
222     uint _tokenCut = (msg.value * 1) / 200;
223     uint _operatorCut = (msg.value * 3) / 200;
224     uint _charityCredit = (msg.value - _operatorCut) - _tokenCut;
225     operatorFeeAcct.transfer(_operatorCut);
226     token.transfer(_tokenCut);
227     charities[_charity].ethDonated += _charityCredit;
228     charities[_charity].ethBalance += _charityCredit;
229     charities[_charity].ethCredited += _charityCredit;
230     EthDonationEvent(_charity, msg.value);
231   }
232 
233 
234   //======== combo operations
235   function fiatCollectedToEth(uint _charity, uint _fiat, string _ref) public managerOnly payable {
236     require(token != 0);
237     require(_charity < charityCount);
238     charities[_charity].fiatCollected += _fiat;
239     //charities[_charity].fiatBalanceIn does not change, since we immediately convert to eth
240     //keep track of fiat to eth conversion price
241     charities[_charity].fiatToEthPriceAccFiat += _fiat;
242     charities[_charity].fiatToEthPriceAccEth += msg.value;
243     uint _tokenCut = (msg.value * 4) / 100;
244     uint _operatorCut = (msg.value * 16) / 100;
245     uint _charityCredit = (msg.value - _operatorCut) - _tokenCut;
246     operatorFeeAcct.transfer(_operatorCut);
247     token.transfer(_tokenCut);
248     charities[_charity].ethBalance += _charityCredit;
249     charities[_charity].ethCredited += _charityCredit;
250     FiatCollectedEvent(_charity, _fiat, _ref);
251     FiatToEthEvent(_charity, _fiat, msg.value);
252   }
253 
254   function ethToFiatDelivered(uint _charity, uint _eth, uint _fiat, string _ref) public managerOnly {
255     require(_charity < charityCount);
256     require(charities[_charity].ethBalance >= _eth);
257     //keep track of fiat to eth conversion price
258     charities[_charity].ethToFiatPriceAccFiat += _fiat;
259     charities[_charity].ethToFiatPriceAccEth += _eth;
260     charities[_charity].ethBalance -= _eth;
261     //charities[_charity].fiatBalanceOut does not change, since we immediately deliver
262     //withdraw funds to the caller
263     msg.sender.transfer(_eth);
264     EthToFiatEvent(_charity, _eth, _fiat);
265     charities[_charity].fiatDelivered += _fiat;
266     FiatDeliveredEvent(_charity, _fiat, _ref);
267   }
268 
269 
270   //note: constant fcn does not need safe math
271   function divRound(uint256 _x, uint256 _y) pure internal returns (uint256) {
272     uint256 z = (_x + (_y / 2)) / _y;
273     return z;
274   }
275 
276   function quickAuditEthCredited(uint _charityIdx) public constant returns (uint _fiatCollected,
277                                                                             uint _fiatToEthNotProcessed,
278                                                                             uint _fiatToEthProcessed,
279                                                                             uint _fiatToEthPricePerEth,
280                                                                             uint _fiatToEthCreditedFinney,
281                                                                             uint _fiatToEthAfterFeesFinney,
282                                                                             uint _ethDonatedFinney,
283                                                                             uint _ethDonatedAfterFeesFinney,
284                                                                             uint _totalEthCreditedFinney,
285                                                                             int _quickDiscrepancy) {
286     require(_charityIdx < charityCount);
287     Charity storage _charity = charities[_charityIdx];
288     _fiatCollected = _charity.fiatCollected;                                                   //eg. $450 = 45000
289     _fiatToEthNotProcessed = _charity.fiatBalanceIn;                                           //eg.            0
290     _fiatToEthProcessed = _fiatCollected - _fiatToEthNotProcessed;                                        //eg.        45000
291     if (_charity.fiatToEthPriceAccEth == 0) {
292       _fiatToEthPricePerEth = 0;
293       _fiatToEthCreditedFinney = 0;
294     } else {
295       _fiatToEthPricePerEth = divRound(_charity.fiatToEthPriceAccFiat * (1 ether),              //eg. 45000 * 10^18 = 45 * 10^21
296                                        _charity.fiatToEthPriceAccEth);                          //eg 1.5 ETH        = 15 * 10^17
297                                                                                                 //               --------------------
298                                                                                                 //                     3 * 10^4 (30000 cents per ether)
299       uint _finneyPerEth = 1 ether / 1 finney;
300       _fiatToEthCreditedFinney = divRound(_fiatToEthProcessed * _finneyPerEth,                  //eg. 45000 * 1000 / 30000 = 1500 (finney)
301                                           _fiatToEthPricePerEth);
302       _fiatToEthAfterFeesFinney = divRound(_fiatToEthCreditedFinney * 8, 10);                   //eg. 1500 * 8 / 10 = 1200 (finney)
303     }
304     _ethDonatedFinney = divRound(_charity.ethDonated, 1 finney);                                //eg. 1 ETH = 1 * 10^18 / 10^15 = 1000 (finney)
305     _ethDonatedAfterFeesFinney = divRound(_ethDonatedFinney * 98, 100);                         //eg. 1000 * 98/100 = 980 (finney)
306     _totalEthCreditedFinney = _fiatToEthAfterFeesFinney + _ethDonatedAfterFeesFinney;           //eg 1200 + 980 = 2180 (finney)
307     uint256 tecf = divRound(_charity.ethCredited, 1 finney);                                    //eg. 2180000000000000000 * (10^-15) = 2180
308     _quickDiscrepancy = int256(_totalEthCreditedFinney) - int256(tecf);
309   }
310 
311 
312 
313 
314   //note: contant fcn does not need safe math
315   function quickAuditFiatDelivered(uint _charityIdx) public constant returns (uint _totalEthCreditedFinney,
316                                                                               uint _ethNotProcessedFinney,
317                                                                               uint _processedEthCreditedFinney,
318                                                                               uint _ethToFiatPricePerEth,
319                                                                               uint _ethToFiatCreditedFiat,
320                                                                               uint _ethToFiatNotProcessed,
321                                                                               uint _ethToFiatProcessed,
322                                                                               uint _fiatDelivered,
323                                                                               int _quickDiscrepancy) {
324     require(_charityIdx < charityCount);
325     Charity storage _charity = charities[_charityIdx];
326     _totalEthCreditedFinney = divRound(_charity.ethCredited, 1 finney);                      //eg. 2180000000000000000 * (10^-15) = 2180
327     _ethNotProcessedFinney = divRound(_charity.ethBalance, 1 finney);                        //eg. 1 ETH = 1 * 10^18 / 10^15 = 1000 (finney)
328     _processedEthCreditedFinney = _totalEthCreditedFinney - _ethNotProcessedFinney;          //eg 1180 finney
329     if (_charity.ethToFiatPriceAccEth == 0) {
330       _ethToFiatPricePerEth = 0;
331       _ethToFiatCreditedFiat = 0;
332     } else {
333       _ethToFiatPricePerEth = divRound(_charity.ethToFiatPriceAccFiat * (1 ether),           //eg. 29400 * 10^18 = 2940000 * 10^16
334                                        _charity.ethToFiatPriceAccEth);                       //eg 0.980 ETH      =      98 * 10^16
335                                                                                              //               --------------------
336                                                                                              //                      30000 (30000 cents per ether)
337       uint _finneyPerEth = 1 ether / 1 finney;
338       _ethToFiatCreditedFiat = divRound(_processedEthCreditedFinney * _ethToFiatPricePerEth, //eg. 1180 * 30000 / 1000 = 35400
339                                         _finneyPerEth);
340     }
341     _ethToFiatNotProcessed = _charity.fiatBalanceOut;
342     _ethToFiatProcessed = _ethToFiatCreditedFiat - _ethToFiatNotProcessed;
343     _fiatDelivered = _charity.fiatDelivered;
344     _quickDiscrepancy = int256(_ethToFiatProcessed) - int256(_fiatDelivered);
345   }
346 
347 
348   //
349   // default payable function.
350   //
351   function () public payable {
352     revert();
353   }
354 
355   //for debug
356   //only available before the contract is locked
357   function haraKiri() public ownerOnly unlockedOnly {
358     selfdestruct(owner);
359   }
360 
361 }