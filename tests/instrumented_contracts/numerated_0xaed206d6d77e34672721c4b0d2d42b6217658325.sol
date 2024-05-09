1 pragma solidity ^0.4.18;
2 
3 /**
4  *
5  * @author  <pratyush.bhatt@protonmail.com>
6  *
7  * RDFDM - Riverdimes Fiat Donation Manager
8  * Version E
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
74 contract RDFDM {
75 
76   //events relating to donation operations
77   //
78   event FiatCollectedEvent(uint indexed charity, uint usd, string ref);
79   event FiatToEthEvent(uint indexed charity, uint usd, uint eth);
80   event EthToFiatEvent(uint indexed charity, uint eth, uint usd);
81   event FiatDeliveredEvent(uint indexed charity, uint usd, string ref);
82   event EthDonationEvent(uint indexed charity, uint eth);
83 
84   //events relating to adding and deleting charities
85   //
86   event CharityAddedEvent(uint indexed charity, string name, uint8 currency);
87   event CharityModifiedEvent(uint indexed charity, string name, uint8 currency);
88 
89   //currencies
90   //
91   uint constant  CURRENCY_USD  = 0x01;
92   uint constant  CURRENCY_EURO = 0x02;
93   uint constant  CURRENCY_NIS  = 0x03;
94   uint constant  CURRENCY_YUAN = 0x04;
95 
96 
97   struct Charity {
98     uint fiatBalanceIn;           // funds in external acct, collected fbo charity
99     uint fiatBalanceOut;          // funds in external acct, pending delivery to charity
100     uint fiatCollected;           // total collected since dawn of creation
101     uint fiatDelivered;           // total delivered since dawn of creation
102     uint ethDonated;              // total eth donated since dawn of creation
103     uint ethCredited;             // total eth credited to this charity since dawn of creation
104     uint ethBalance;              // current eth balance of this charity
105     uint fiatToEthPriceAccEth;    // keep track of fiat to eth conversion price: total eth
106     uint fiatToEthPriceAccFiat;   // keep track of fiat to eth conversion price: total fiat
107     uint ethToFiatPriceAccEth;    // kkep track of eth to fiat conversion price: total eth
108     uint ethToFiatPriceAccFiat;   // kkep track of eth to fiat conversion price: total fiat
109     uint8 currency;               // fiat amounts are in smallest denomination of currency
110     string name;                  // eg. "Salvation Army"
111   }
112 
113   uint public charityCount;
114   address public owner;
115   address public manager;
116   address public token;           //token-holder fees sent to this address
117   address public operatorFeeAcct; //operations fees sent to this address
118   mapping (uint => Charity) public charities;
119   bool public isLocked;
120 
121   modifier ownerOnly {
122     require(msg.sender == owner);
123     _;
124   }
125 
126   modifier managerOnly {
127     require(msg.sender == owner || msg.sender == manager);
128     _;
129   }
130 
131   modifier unlockedOnly {
132     require(!isLocked);
133     _;
134   }
135 
136 
137   //
138   //constructor
139   //
140   function RDFDM() public {
141     owner = msg.sender;
142     manager = msg.sender;
143     token = msg.sender;
144     operatorFeeAcct = msg.sender;
145   }
146   function lock() public ownerOnly { isLocked = true; }
147   function setToken(address _token) public ownerOnly unlockedOnly { token = _token; }
148   function setOperatorFeeAcct(address _operatorFeeAcct) public ownerOnly { operatorFeeAcct = _operatorFeeAcct; }
149   function setManager(address _manager) public managerOnly { manager = _manager; }
150   function deleteManager() public managerOnly { manager = owner; }
151 
152 
153   function addCharity(string _name, uint8 _currency) public managerOnly {
154     charities[charityCount].name = _name;
155     charities[charityCount].currency = _currency;
156     CharityAddedEvent(charityCount, _name, _currency);
157     ++charityCount;
158   }
159 
160   function modifyCharity(uint _charity, string _name, uint8 _currency) public managerOnly {
161     require(_charity < charityCount);
162     charities[_charity].name = _name;
163     charities[_charity].currency = _currency;
164     CharityModifiedEvent(_charity, _name, _currency);
165   }
166 
167 
168 
169   //======== basic operations
170 
171   function fiatCollected(uint _charity, uint _fiat, string _ref) public managerOnly {
172     require(_charity < charityCount);
173     charities[_charity].fiatBalanceIn += _fiat;
174     charities[_charity].fiatCollected += _fiat;
175     FiatCollectedEvent(_charity, _fiat, _ref);
176   }
177 
178   function fiatToEth(uint _charity, uint _fiat) public managerOnly payable {
179     require(token != 0);
180     require(_charity < charityCount);
181     //keep track of fiat to eth conversion price
182     charities[_charity].fiatToEthPriceAccFiat += _fiat;
183     charities[_charity].fiatToEthPriceAccEth += msg.value;
184     charities[_charity].fiatBalanceIn -= _fiat;
185     uint _tokenCut = (msg.value * 4) / 100;
186     uint _operatorCut = (msg.value * 16) / 100;
187     uint _charityCredit = (msg.value - _operatorCut) - _tokenCut;
188     operatorFeeAcct.transfer(_operatorCut);
189     token.transfer(_tokenCut);
190     charities[_charity].ethBalance += _charityCredit;
191     charities[_charity].ethCredited += _charityCredit;
192     FiatToEthEvent(_charity, _fiat, msg.value);
193   }
194 
195   function ethToFiat(uint _charity, uint _eth, uint _fiat) public managerOnly {
196     require(_charity < charityCount);
197     require(charities[_charity].ethBalance >= _eth);
198     //keep track of fiat to eth conversion price
199     charities[_charity].ethToFiatPriceAccFiat += _fiat;
200     charities[_charity].ethToFiatPriceAccEth += _eth;
201     charities[_charity].ethBalance -= _eth;
202     charities[_charity].fiatBalanceOut += _fiat;
203     //withdraw funds to the caller
204     msg.sender.transfer(_eth);
205     EthToFiatEvent(_charity, _eth, _fiat);
206   }
207 
208   function fiatDelivered(uint _charity, uint _fiat, string _ref) public managerOnly {
209     require(_charity < charityCount);
210     require(charities[_charity].fiatBalanceOut >= _fiat);
211     charities[_charity].fiatBalanceOut -= _fiat;
212     charities[_charity].fiatDelivered += _fiat;
213     FiatDeliveredEvent(_charity, _fiat, _ref);
214   }
215 
216   //======== unrelated to round-up
217   function ethDonation(uint _charity) public payable {
218     require(token != 0);
219     require(_charity < charityCount);
220     uint _tokenCut = (msg.value * 1) / 200;
221     uint _operatorCut = (msg.value * 3) / 200;
222     uint _charityCredit = (msg.value - _operatorCut) - _tokenCut;
223     operatorFeeAcct.transfer(_operatorCut);
224     token.transfer(_tokenCut);
225     charities[_charity].ethDonated += _charityCredit;
226     charities[_charity].ethBalance += _charityCredit;
227     charities[_charity].ethCredited += _charityCredit;
228     EthDonationEvent(_charity, msg.value);
229   }
230 
231 
232   //======== combo operations
233   function fiatCollectedToEth(uint _charity, uint _fiat, string _ref) public managerOnly payable {
234     require(token != 0);
235     require(_charity < charityCount);
236     charities[_charity].fiatCollected += _fiat;
237     //charities[_charity].fiatBalanceIn does not change, since we immediately convert to eth
238     //keep track of fiat to eth conversion price
239     charities[_charity].fiatToEthPriceAccFiat += _fiat;
240     charities[_charity].fiatToEthPriceAccEth += msg.value;
241     uint _tokenCut = (msg.value * 4) / 100;
242     uint _operatorCut = (msg.value * 16) / 100;
243     uint _charityCredit = (msg.value - _operatorCut) - _tokenCut;
244     operatorFeeAcct.transfer(_operatorCut);
245     token.transfer(_tokenCut);
246     charities[_charity].ethBalance += _charityCredit;
247     charities[_charity].ethCredited += _charityCredit;
248     FiatCollectedEvent(_charity, _fiat, _ref);
249     FiatToEthEvent(_charity, _fiat, msg.value);
250   }
251 
252   function ethToFiatDelivered(uint _charity, uint _eth, uint _fiat, string _ref) public managerOnly {
253     require(_charity < charityCount);
254     require(charities[_charity].ethBalance >= _eth);
255     //keep track of fiat to eth conversion price
256     charities[_charity].ethToFiatPriceAccFiat += _fiat;
257     charities[_charity].ethToFiatPriceAccEth += _eth;
258     charities[_charity].ethBalance -= _eth;
259     //charities[_charity].fiatBalanceOut does not change, since we immediately deliver
260     //withdraw funds to the caller
261     msg.sender.transfer(_eth);
262     EthToFiatEvent(_charity, _eth, _fiat);
263     charities[_charity].fiatDelivered += _fiat;
264     FiatDeliveredEvent(_charity, _fiat, _ref);
265   }
266 
267 
268   //note: constant fcn does not need safe math
269   function divRound(uint256 _x, uint256 _y) pure internal returns (uint256) {
270     uint256 z = (_x + (_y / 2)) / _y;
271     return z;
272   }
273 
274   function quickAuditEthCredited(uint _charityIdx) public constant returns (uint _fiatCollected,
275                                                                             uint _fiatToEthNotProcessed,
276                                                                             uint _fiatToEthProcessed,
277                                                                             uint _fiatToEthPricePerEth,
278                                                                             uint _fiatToEthCreditedSzabo,
279                                                                             uint _fiatToEthAfterFeesSzabo,
280                                                                             uint _ethDonatedSzabo,
281                                                                             uint _ethDonatedAfterFeesSzabo,
282                                                                             uint _totalEthCreditedSzabo,
283                                                                             int _quickDiscrepancy) {
284     require(_charityIdx < charityCount);
285     Charity storage _charity = charities[_charityIdx];
286     _fiatCollected = _charity.fiatCollected;                                                   //eg. $450 = 45000
287     _fiatToEthNotProcessed = _charity.fiatBalanceIn;                                           //eg.            0
288     _fiatToEthProcessed = _fiatCollected - _fiatToEthNotProcessed;                             //eg.        45000
289     if (_charity.fiatToEthPriceAccEth == 0) {
290       _fiatToEthPricePerEth = 0;
291       _fiatToEthCreditedSzabo = 0;
292     } else {
293       _fiatToEthPricePerEth = divRound(_charity.fiatToEthPriceAccFiat * (1 ether),             //eg. 45000 * 10^18 = 45 * 10^21
294                                        _charity.fiatToEthPriceAccEth);                         //eg 1.5 ETH        = 15 * 10^17
295                                                                                                //               --------------------
296                                                                                                //                     3 * 10^4 (30000 cents per ether)
297       uint _szaboPerEth = 1 ether / 1 szabo;
298       _fiatToEthCreditedSzabo = divRound(_fiatToEthProcessed * _szaboPerEth,                  //eg. 45000 * 1,000,000 / 30000 = 1,500,000 (szabo)
299                                           _fiatToEthPricePerEth);
300       _fiatToEthAfterFeesSzabo = divRound(_fiatToEthCreditedSzabo * 8, 10);                   //eg. 1,500,000 * 8 / 10 = 1,200,000 (szabo)
301     }
302     _ethDonatedSzabo = divRound(_charity.ethDonated, 1 szabo);                                //eg. 1 ETH = 1 * 10^18 / 10^12 = 1,000,000 (szabo)
303     _ethDonatedAfterFeesSzabo = divRound(_ethDonatedSzabo * 98, 100);                         //eg. 1,000,000 * 98/100 = 980,000 (szabo)
304     _totalEthCreditedSzabo = _fiatToEthAfterFeesSzabo + _ethDonatedAfterFeesSzabo;            //eg  1,200,000 + 980,000 = 2,180,000 (szabo)
305     uint256 tecf = divRound(_charity.ethCredited, 1 szabo);                                   //eg. 2180000000000000000 * (10^-12) = 2,180,000
306     _quickDiscrepancy = int256(_totalEthCreditedSzabo) - int256(tecf);                        //eg. 0
307   }
308 
309 
310 
311 
312   //note: contant fcn does not need safe math
313   function quickAuditFiatDelivered(uint _charityIdx) public constant returns (uint _totalEthCreditedSzabo,
314                                                                               uint _ethNotProcessedSzabo,
315                                                                               uint _processedEthCreditedSzabo,
316                                                                               uint _ethToFiatPricePerEth,
317                                                                               uint _ethToFiatCreditedFiat,
318                                                                               uint _ethToFiatNotProcessed,
319                                                                               uint _ethToFiatProcessed,
320                                                                               uint _fiatDelivered,
321                                                                               int _quickDiscrepancy) {
322     require(_charityIdx < charityCount);
323     Charity storage _charity = charities[_charityIdx];
324     _totalEthCreditedSzabo = divRound(_charity.ethCredited, 1 szabo);                          //eg. 2180000000000000000 * (10^-12) = 2,180,000
325     _ethNotProcessedSzabo = divRound(_charity.ethBalance, 1 szabo);                            //eg. 1 ETH = 1 * 10^18 / 10^12 = 1,000,000 (szabo)
326     _processedEthCreditedSzabo = _totalEthCreditedSzabo - _ethNotProcessedSzabo;               //eg  1,180,000 szabo
327     if (_charity.ethToFiatPriceAccEth == 0) {
328       _ethToFiatPricePerEth = 0;
329       _ethToFiatCreditedFiat = 0;
330     } else {
331       _ethToFiatPricePerEth = divRound(_charity.ethToFiatPriceAccFiat * (1 ether),             //eg. 35400 * 10^18 = 3540000 * 10^16
332                                        _charity.ethToFiatPriceAccEth);                         //eg  1.180 ETH     =     118 * 10^16
333                                                                                                //               --------------------
334                                                                                                //                      30000 (30000 cents per ether)
335       uint _szaboPerEth = 1 ether / 1 szabo;
336       _ethToFiatCreditedFiat = divRound(_processedEthCreditedSzabo * _ethToFiatPricePerEth,    //eg. 1,180,000 * 30000 / 1,000,000 = 35400
337                                         _szaboPerEth);
338     }
339     _ethToFiatNotProcessed = _charity.fiatBalanceOut;
340     _ethToFiatProcessed = _ethToFiatCreditedFiat - _ethToFiatNotProcessed;
341     _fiatDelivered = _charity.fiatDelivered;
342     _quickDiscrepancy = int256(_ethToFiatProcessed) - int256(_fiatDelivered);
343   }
344 
345 
346   //
347   // default payable function.
348   //
349   function () public payable {
350     revert();
351   }
352 
353   //for debug
354   //only available before the contract is locked
355   function haraKiri() public ownerOnly unlockedOnly {
356     selfdestruct(owner);
357   }
358 
359 }