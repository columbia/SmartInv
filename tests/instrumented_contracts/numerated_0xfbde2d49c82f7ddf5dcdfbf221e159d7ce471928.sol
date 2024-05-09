1 pragma solidity ^0.4.15;
2 
3 /**
4  *
5  * @author  <chicocripto@protonmail.com>
6  *
7  * RDFDM - Riverdimes Fiat Donation Manager
8  * Version 20171027a
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
42  * one basic operation, unrelayed to round-up
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
80   event FiatCollectedEvent(uint indexed charity, uint usd, uint ref);
81   event FiatToEthEvent(uint indexed charity, uint usd, uint eth);
82   event EthToFiatEvent(uint indexed charity, uint eth, uint usd);
83   event FiatDeliveredEvent(uint indexed charity, uint usd, uint ref);
84   event EthDonationEvent(uint indexed charity, uint eth);
85 
86   //events relating to adding and deleting charities
87   //
88   event CharityAddedEvent(uint indexed charity, string name, uint8 currency);
89 
90   //currencies
91   //
92   uint constant  CURRENCY_USD  = 0x01;
93   uint constant  CURRENCY_EURO = 0x02;
94   uint constant  CURRENCY_NIS  = 0x03;
95   uint constant  CURRENCY_YUAN = 0x04;
96 
97 
98   struct Charity {
99     uint fiatBalanceIn;          // funds in external acct, collected fbo charity
100     uint fiatBalanceOut;         // funds in external acct, pending delivery to charity
101     uint fiatCollected;          // total collected since dawn of creation
102     uint fiatDelivered;          // total delivered since dawn of creation
103     uint ethDonated;             // total eth donated since dawn of creation
104     uint ethCredited;            // total eth credited to this charity since dawn of creation
105     uint ethBalance;             // current eth balance of this charity
106     uint fiatToEthPriceAccEth;   // keep track of fiat to eth conversion price: total eth
107     uint fiatToEthPriceAccFiat;  // keep track of fiat to eth conversion price: total fiat
108     uint ethToFiatPriceAccEth;   // kkep track of eth to fiat conversion price: total eth
109     uint ethToFiatPriceAccFiat;  // kkep track of eth to fiat conversion price: total fiat
110     uint8 currency;              // fiat amounts are in smallest denomination of currency
111     string name;                 // eg. "Salvation Army"
112   }
113 
114   uint public charityCount;
115   address public owner;
116   address public manager;
117   address public operator;       //operations fees sent to this address
118   address public token;          //token-holder fees sent to this address
119   mapping (uint => Charity) public charities;
120   bool public isLocked;
121 
122   modifier ownerOnly {
123     require(msg.sender == owner);
124     _;
125   }
126 
127   modifier managerOnly {
128     require(msg.sender == owner || msg.sender == manager);
129     _;
130   }
131 
132   modifier unlockedOnly {
133     require(!isLocked);
134     _;
135   }
136 
137 
138   //
139   //constructor
140   //
141   function RDFDM() {
142     owner = msg.sender;
143     manager = msg.sender;
144   }
145   function lock() public ownerOnly {
146     isLocked = true;
147   }
148   function setOperator(address _operator) public ownerOnly { operator = _operator; }
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
160 
161 
162   //======== basic operations
163 
164   function fiatCollected(uint _charity, uint _fiat, uint _ref) public managerOnly {
165     require(_charity < charityCount);
166     charities[charityCount].fiatBalanceIn += _fiat;
167     charities[charityCount].fiatCollected += _fiat;
168     FiatCollectedEvent(_charity, _fiat, _ref);
169   }
170 
171   function fiatToEth(uint _charity, uint _fiat) public managerOnly payable {
172     require(_charity < charityCount);
173     //keep track of fiat to eth conversion price
174     charities[charityCount].fiatToEthPriceAccFiat += _fiat;
175     charities[charityCount].fiatToEthPriceAccEth += msg.value;
176     charities[charityCount].fiatBalanceIn -= _fiat;
177     uint _tokenCut = (msg.value * 4) / 100;
178     uint _operatorCut = (msg.value * 16) / 100;
179     uint _charityCredit = (msg.value - _operatorCut) - _tokenCut;
180     operator.transfer(_operatorCut);
181     token.transfer(_tokenCut);
182     charities[charityCount].ethBalance += _charityCredit;
183     charities[charityCount].ethCredited += _charityCredit;
184     FiatToEthEvent(_charity, _fiat, msg.value);
185   }
186 
187   function ethToFiat(uint _charity, uint _eth, uint _fiat) public managerOnly {
188     require(_charity < charityCount);
189     require(charities[_charity].ethBalance >= _eth);
190     //keep track of fiat to eth conversion price
191     charities[charityCount].ethToFiatPriceAccFiat += _fiat;
192     charities[charityCount].ethToFiatPriceAccEth += _eth;
193     charities[charityCount].ethBalance -= _eth;
194     charities[charityCount].fiatBalanceOut += _fiat;
195     //withdraw funds to the caller
196     msg.sender.transfer(_eth);
197     EthToFiatEvent(_charity, _eth, _fiat);
198   }
199 
200   function fiatDelivered(uint _charity, uint _fiat, uint _ref) public managerOnly {
201     require(_charity < charityCount);
202     require(charities[_charity].fiatBalanceOut >= _fiat);
203     charities[_charity].fiatBalanceOut -= _fiat;
204     charities[charityCount].fiatDelivered += _fiat;
205     FiatDeliveredEvent(_charity, _fiat, _ref);
206   }
207 
208   //======== unrelated to round-up
209   function ethDonation(uint _charity) public payable {
210     require(_charity < charityCount);
211     uint _tokenCut = (msg.value * 1) / 200;
212     uint _operatorCut = (msg.value * 3) / 200;
213     uint _charityCredit = (msg.value - _operatorCut) - _tokenCut;
214     operator.transfer(_operatorCut);
215     token.transfer(_tokenCut);
216     charities[charityCount].ethDonated += _charityCredit;
217     charities[charityCount].ethBalance += _charityCredit;
218     charities[charityCount].ethCredited += _charityCredit;
219     EthDonationEvent(_charity, msg.value);
220   }
221 
222 
223   //======== combo operations
224   function fiatCollectedToEth(uint _charity, uint _fiat, uint _ref) public managerOnly payable {
225     require(token != 0);
226     require(_charity < charityCount);
227     charities[charityCount].fiatCollected += _fiat;
228     //charities[charityCount].fiatBalanceIn does not change, since we immediately convert to eth
229     //keep track of fiat to eth conversion price
230     charities[charityCount].fiatToEthPriceAccFiat += _fiat;
231     charities[charityCount].fiatToEthPriceAccEth += msg.value;
232     uint _tokenCut = (msg.value * 4) / 100;
233     uint _operatorCut = (msg.value * 16) / 100;
234     uint _charityCredit = (msg.value - _operatorCut) - _tokenCut;
235     operator.transfer(_operatorCut);
236     token.transfer(_tokenCut);
237     charities[charityCount].ethBalance += _charityCredit;
238     charities[charityCount].ethCredited += _charityCredit;
239     FiatCollectedEvent(_charity, _fiat, _ref);
240     FiatToEthEvent(_charity, _fiat, msg.value);
241   }
242 
243   function ethToFiatDelivered(uint _charity, uint _eth, uint _fiat, uint _ref) public managerOnly {
244     require(_charity < charityCount);
245     require(charities[_charity].ethBalance >= _eth);
246     //keep track of fiat to eth conversion price
247     charities[charityCount].ethToFiatPriceAccFiat += _fiat;
248     charities[charityCount].ethToFiatPriceAccEth += _eth;
249     charities[charityCount].ethBalance -= _eth;
250     //charities[charityCount].fiatBalanceOut does not change, since we immediately deliver
251     //withdraw funds to the caller
252     msg.sender.transfer(_eth);
253     EthToFiatEvent(_charity, _eth, _fiat);
254     charities[charityCount].fiatDelivered += _fiat;
255     FiatDeliveredEvent(_charity, _fiat, _ref);
256   }
257 
258 
259   //note: contant fcn does not need safe math
260   function quickAuditEthCredited(uint _charity) public constant returns (uint _fiatCollected,
261                                                               uint _fiatToEthNotProcessed,
262                                                               uint _fiatToEthProcessed,
263                                                               uint _fiatToEthPricePerEth,
264                                                               uint _fiatToEthCreditedFinney,
265                                                               uint _fiatToEthAfterFeesFinney,
266                                                               uint _ethDonatedFinney,
267                                                               uint _ethDonatedAfterFeesFinney,
268                                                               uint _totalEthCreditedFinney,
269                                                                int _quickDiscrepancy) {
270     require(_charity < charityCount);
271     _fiatCollected = charities[charityCount].fiatCollected;                                                //eg. $450 = 45000
272     _fiatToEthNotProcessed = charities[charityCount].fiatBalanceIn;                                        //eg.            0
273     _fiatToEthProcessed = _fiatCollected - _fiatToEthNotProcessed;                                         //eg.        45000
274     if (charities[charityCount].fiatToEthPriceAccEth == 0) {
275       _fiatToEthPricePerEth = 0;
276       _fiatToEthCreditedFinney = 0;
277     } else {
278       _fiatToEthPricePerEth = (charities[charityCount].fiatToEthPriceAccFiat * (1 ether)) /                //eg. 45000 * 10^18 = 45 * 10^21
279                                charities[charityCount].fiatToEthPriceAccEth;                               //eg 1.5 ETH        = 15 * 10^17
280                                                                                                            //               --------------------
281                                                                                                            //                     3 * 10^4 (30000 cents per ether)
282       _fiatToEthCreditedFinney = _fiatToEthProcessed * (1 ether / 1 finney) / _fiatToEthPricePerEth;       //eg. 45000 * 1000 / 30000 = 1500 (finney)
283       _fiatToEthAfterFeesFinney = _fiatToEthCreditedFinney * 8 / 10;                                       //eg. 1500 * 8 / 10 = 1200 (finney)
284     }
285     _ethDonatedFinney = charities[charityCount].ethDonated / (1 finney);                                   //eg. 1 ETH = 1 * 10^18 / 10^15 = 1000 (finney)
286     _ethDonatedAfterFeesFinney = _ethDonatedFinney * 98 / 100;                                             //eg. 1000 * 98/100 = 980 (finney)
287     _totalEthCreditedFinney = _fiatToEthAfterFeesFinney + _ethDonatedAfterFeesFinney;                      //eg 1200 + 980 = 2180 (finney)
288     uint256 tecf = charities[charityCount].ethCredited * (1 ether / 1 finney);
289     _quickDiscrepancy = int256(_totalEthCreditedFinney) - int256(tecf);
290   }
291 
292 
293   //note: contant fcn does not need safe math
294   function quickAuditFiatDelivered(uint _charity) public constant returns (
295                                                               uint _totalEthCreditedFinney,
296                                                               uint _ethNotProcessedFinney,
297                                                               uint _processedEthCreditedFinney,
298                                                               uint _ethToFiatPricePerEth,
299                                                               uint _ethToFiatCreditedFiat,
300                                                               uint _ethToFiatNotProcessed,
301                                                               uint _ethToFiatProcessed,
302                                                               uint _fiatDelivered,
303                                                                int _quickDiscrepancy) {
304     require(_charity < charityCount);
305     _totalEthCreditedFinney = charities[charityCount].ethCredited * (1 ether / 1 finney);
306     _ethNotProcessedFinney = charities[charityCount].ethBalance / (1 finney);                              //eg. 1 ETH = 1 * 10^18 / 10^15 = 1000 (finney)
307     _processedEthCreditedFinney = _totalEthCreditedFinney - _ethNotProcessedFinney;                        //eg 1180 finney
308     if (charities[charityCount].ethToFiatPriceAccEth == 0) {
309       _ethToFiatPricePerEth = 0;
310       _ethToFiatCreditedFiat = 0;
311     } else {
312       _ethToFiatPricePerEth = (charities[charityCount].ethToFiatPriceAccFiat * (1 ether)) /                //eg. 29400 * 10^18 = 2940000 * 10^16
313                                charities[charityCount].ethToFiatPriceAccEth;                               //eg 0.980 ETH      =      98 * 10^16
314                                                                                                            //               --------------------
315                                                                                                            //                      30000 (30000 cents per ether)
316       _ethToFiatCreditedFiat = _processedEthCreditedFinney * _ethToFiatPricePerEth / (1 ether / 1 finney); //eg. 1180 * 30000 / 1000 = 35400
317     }
318     _ethToFiatNotProcessed = charities[_charity].fiatBalanceOut;
319     _ethToFiatProcessed = _ethToFiatCreditedFiat - _ethToFiatNotProcessed;
320     _fiatDelivered = charities[charityCount].fiatDelivered;
321     _quickDiscrepancy = int256(_ethToFiatProcessed) - int256(_fiatDelivered);
322   }
323 
324 
325   //
326   // default payable function.
327   //
328   function () payable {
329     revert();
330   }
331 
332   //for debug
333   //only available before the contract is locked
334   function haraKiri() ownerOnly unlockedOnly {
335     selfdestruct(owner);
336   }
337 
338 }