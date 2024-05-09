1 pragma solidity ^0.4.18;
2 
3 /**
4  *
5  * @author  <chicocripto@protonmail.com>
6  *
7  * RDFDM - Riverdimes Fiat Donation Manager
8  * Version B
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
164     charities[charityCount].name = _name;
165     charities[charityCount].currency = _currency;
166     CharityModifiedEvent(_charity, _name, _currency);
167   }
168 
169 
170 
171   //======== basic operations
172 
173   function fiatCollected(uint _charity, uint _fiat, string _ref) public managerOnly {
174     require(_charity < charityCount);
175     charities[charityCount].fiatBalanceIn += _fiat;
176     charities[charityCount].fiatCollected += _fiat;
177     FiatCollectedEvent(_charity, _fiat, _ref);
178   }
179 
180   function fiatToEth(uint _charity, uint _fiat) public managerOnly payable {
181     require(token != 0);
182     require(_charity < charityCount);
183     //keep track of fiat to eth conversion price
184     charities[charityCount].fiatToEthPriceAccFiat += _fiat;
185     charities[charityCount].fiatToEthPriceAccEth += msg.value;
186     charities[charityCount].fiatBalanceIn -= _fiat;
187     uint _tokenCut = (msg.value * 4) / 100;
188     uint _operatorCut = (msg.value * 16) / 100;
189     uint _charityCredit = (msg.value - _operatorCut) - _tokenCut;
190     operatorFeeAcct.transfer(_operatorCut);
191     token.transfer(_tokenCut);
192     charities[charityCount].ethBalance += _charityCredit;
193     charities[charityCount].ethCredited += _charityCredit;
194     FiatToEthEvent(_charity, _fiat, msg.value);
195   }
196 
197   function ethToFiat(uint _charity, uint _eth, uint _fiat) public managerOnly {
198     require(_charity < charityCount);
199     require(charities[_charity].ethBalance >= _eth);
200     //keep track of fiat to eth conversion price
201     charities[charityCount].ethToFiatPriceAccFiat += _fiat;
202     charities[charityCount].ethToFiatPriceAccEth += _eth;
203     charities[charityCount].ethBalance -= _eth;
204     charities[charityCount].fiatBalanceOut += _fiat;
205     //withdraw funds to the caller
206     msg.sender.transfer(_eth);
207     EthToFiatEvent(_charity, _eth, _fiat);
208   }
209 
210   function fiatDelivered(uint _charity, uint _fiat, string _ref) public managerOnly {
211     require(_charity < charityCount);
212     require(charities[_charity].fiatBalanceOut >= _fiat);
213     charities[_charity].fiatBalanceOut -= _fiat;
214     charities[charityCount].fiatDelivered += _fiat;
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
227     charities[charityCount].ethDonated += _charityCredit;
228     charities[charityCount].ethBalance += _charityCredit;
229     charities[charityCount].ethCredited += _charityCredit;
230     EthDonationEvent(_charity, msg.value);
231   }
232 
233 
234   //======== combo operations
235   function fiatCollectedToEth(uint _charity, uint _fiat, string _ref) public managerOnly payable {
236     require(token != 0);
237     require(_charity < charityCount);
238     charities[charityCount].fiatCollected += _fiat;
239     //charities[charityCount].fiatBalanceIn does not change, since we immediately convert to eth
240     //keep track of fiat to eth conversion price
241     charities[charityCount].fiatToEthPriceAccFiat += _fiat;
242     charities[charityCount].fiatToEthPriceAccEth += msg.value;
243     uint _tokenCut = (msg.value * 4) / 100;
244     uint _operatorCut = (msg.value * 16) / 100;
245     uint _charityCredit = (msg.value - _operatorCut) - _tokenCut;
246     operatorFeeAcct.transfer(_operatorCut);
247     token.transfer(_tokenCut);
248     charities[charityCount].ethBalance += _charityCredit;
249     charities[charityCount].ethCredited += _charityCredit;
250     FiatCollectedEvent(_charity, _fiat, _ref);
251     FiatToEthEvent(_charity, _fiat, msg.value);
252   }
253 
254   function ethToFiatDelivered(uint _charity, uint _eth, uint _fiat, string _ref) public managerOnly {
255     require(_charity < charityCount);
256     require(charities[_charity].ethBalance >= _eth);
257     //keep track of fiat to eth conversion price
258     charities[charityCount].ethToFiatPriceAccFiat += _fiat;
259     charities[charityCount].ethToFiatPriceAccEth += _eth;
260     charities[charityCount].ethBalance -= _eth;
261     //charities[charityCount].fiatBalanceOut does not change, since we immediately deliver
262     //withdraw funds to the caller
263     msg.sender.transfer(_eth);
264     EthToFiatEvent(_charity, _eth, _fiat);
265     charities[charityCount].fiatDelivered += _fiat;
266     FiatDeliveredEvent(_charity, _fiat, _ref);
267   }
268 
269 
270   //note: contant fcn does not need safe math
271   function quickAuditEthCredited(uint _charity) public constant returns (uint _fiatCollected,
272                                                               uint _fiatToEthNotProcessed,
273                                                               uint _fiatToEthProcessed,
274                                                               uint _fiatToEthPricePerEth,
275                                                               uint _fiatToEthCreditedFinney,
276                                                               uint _fiatToEthAfterFeesFinney,
277                                                               uint _ethDonatedFinney,
278                                                               uint _ethDonatedAfterFeesFinney,
279                                                               uint _totalEthCreditedFinney,
280                                                                int _quickDiscrepancy) {
281     require(_charity < charityCount);
282     _fiatCollected = charities[charityCount].fiatCollected;                                                //eg. $450 = 45000
283     _fiatToEthNotProcessed = charities[charityCount].fiatBalanceIn;                                        //eg.            0
284     _fiatToEthProcessed = _fiatCollected - _fiatToEthNotProcessed;                                         //eg.        45000
285     if (charities[charityCount].fiatToEthPriceAccEth == 0) {
286       _fiatToEthPricePerEth = 0;
287       _fiatToEthCreditedFinney = 0;
288     } else {
289       _fiatToEthPricePerEth = (charities[charityCount].fiatToEthPriceAccFiat * (1 ether)) /                //eg. 45000 * 10^18 = 45 * 10^21
290                                charities[charityCount].fiatToEthPriceAccEth;                               //eg 1.5 ETH        = 15 * 10^17
291                                                                                                            //               --------------------
292                                                                                                            //                     3 * 10^4 (30000 cents per ether)
293       _fiatToEthCreditedFinney = _fiatToEthProcessed * (1 ether / 1 finney) / _fiatToEthPricePerEth;       //eg. 45000 * 1000 / 30000 = 1500 (finney)
294       _fiatToEthAfterFeesFinney = _fiatToEthCreditedFinney * 8 / 10;                                       //eg. 1500 * 8 / 10 = 1200 (finney)
295     }
296     _ethDonatedFinney = charities[charityCount].ethDonated / (1 finney);                                   //eg. 1 ETH = 1 * 10^18 / 10^15 = 1000 (finney)
297     _ethDonatedAfterFeesFinney = _ethDonatedFinney * 98 / 100;                                             //eg. 1000 * 98/100 = 980 (finney)
298     _totalEthCreditedFinney = _fiatToEthAfterFeesFinney + _ethDonatedAfterFeesFinney;                      //eg 1200 + 980 = 2180 (finney)
299     uint256 tecf = charities[charityCount].ethCredited * (1 ether / 1 finney);
300     _quickDiscrepancy = int256(_totalEthCreditedFinney) - int256(tecf);
301   }
302 
303 
304   //note: contant fcn does not need safe math
305   function quickAuditFiatDelivered(uint _charity) public constant returns (
306                                                               uint _totalEthCreditedFinney,
307                                                               uint _ethNotProcessedFinney,
308                                                               uint _processedEthCreditedFinney,
309                                                               uint _ethToFiatPricePerEth,
310                                                               uint _ethToFiatCreditedFiat,
311                                                               uint _ethToFiatNotProcessed,
312                                                               uint _ethToFiatProcessed,
313                                                               uint _fiatDelivered,
314                                                                int _quickDiscrepancy) {
315     require(_charity < charityCount);
316     _totalEthCreditedFinney = charities[charityCount].ethCredited * (1 ether / 1 finney);
317     _ethNotProcessedFinney = charities[charityCount].ethBalance / (1 finney);                              //eg. 1 ETH = 1 * 10^18 / 10^15 = 1000 (finney)
318     _processedEthCreditedFinney = _totalEthCreditedFinney - _ethNotProcessedFinney;                        //eg 1180 finney
319     if (charities[charityCount].ethToFiatPriceAccEth == 0) {
320       _ethToFiatPricePerEth = 0;
321       _ethToFiatCreditedFiat = 0;
322     } else {
323       _ethToFiatPricePerEth = (charities[charityCount].ethToFiatPriceAccFiat * (1 ether)) /                //eg. 29400 * 10^18 = 2940000 * 10^16
324                                charities[charityCount].ethToFiatPriceAccEth;                               //eg 0.980 ETH      =      98 * 10^16
325                                                                                                            //               --------------------
326                                                                                                            //                      30000 (30000 cents per ether)
327       _ethToFiatCreditedFiat = _processedEthCreditedFinney * _ethToFiatPricePerEth / (1 ether / 1 finney); //eg. 1180 * 30000 / 1000 = 35400
328     }
329     _ethToFiatNotProcessed = charities[_charity].fiatBalanceOut;
330     _ethToFiatProcessed = _ethToFiatCreditedFiat - _ethToFiatNotProcessed;
331     _fiatDelivered = charities[charityCount].fiatDelivered;
332     _quickDiscrepancy = int256(_ethToFiatProcessed) - int256(_fiatDelivered);
333   }
334 
335 
336   //
337   // default payable function.
338   //
339   function () public payable {
340     revert();
341   }
342 
343   //for debug
344   //only available before the contract is locked
345   function haraKiri() public ownerOnly unlockedOnly {
346     selfdestruct(owner);
347   }
348 
349 }