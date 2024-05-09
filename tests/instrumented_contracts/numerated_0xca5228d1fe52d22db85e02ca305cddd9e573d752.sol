1 pragma solidity ^0.4.17;
2 
3 /*
4   Copyright 2017, FastCashMoneyPlus.biz
5 
6   This is highly propriatary software. Under no circumstances is anyone, except for employees of
7   FastCashMoneyPlus.biz, authorized to modify, distribute, use, or otherwise profit from these
8   contracts. Anyone attempting to do so will be prosecuted under the full extent of the law.
9 */
10 
11 
12 // Set executive permissions of contract
13 contract FastCashMoneyPlusPermissions {
14   address public centralBanker;
15 
16   function FastCashMoneyPlusPermissions() public {
17     centralBanker = msg.sender;
18   }
19 
20   modifier onlyCentralBanker() {
21     require(msg.sender == centralBanker);
22     _;
23   }
24 
25   function setCentralBanker(address newCentralBanker) external onlyCentralBanker {
26     require(newCentralBanker != address(0));
27     centralBanker = newCentralBanker;
28   }
29 }
30 
31 // Set identifying information
32 contract FastCashMoneyPlusBase is FastCashMoneyPlusPermissions {
33   string public name = "FastCashMoneyPlus";
34   string public symbol = "FASTCASH";
35   uint8 public decimals = 18;
36 
37   function updateSymbol(string _newSymbol) external onlyCentralBanker returns (bool success) {
38     symbol = _newSymbol;
39     return true;
40   }
41 }
42 
43 // Describe the storage mechanism of the contract
44 // balanceOf refers to the standard mapping of eth address => balance
45 // routingCodes refer to a shorter, human-readable string (but stored as bytes)
46 // routingCodes are used primerally for referal fees, but can also be used to transfer FastCash
47 contract FastCashMoneyPlusStorage is FastCashMoneyPlusBase {
48   mapping (bytes32 => address) public routingCodeMap;
49   mapping (address => uint) public balanceOf;
50   bytes32[] public routingCodes;
51 
52   function FastCashMoneyPlusStorage() {
53     bytes32 centralBankerRoutingCode = "electricGOD_POWERvyS4xY69R3aR$";
54     routingCodes.push(centralBankerRoutingCode);
55     routingCodeMap[centralBankerRoutingCode] = msg.sender;
56   }
57 
58   function balanceOfRoutingCode(bytes32 routingCode) external returns (uint) {
59     address _address = routingCodeMap[routingCode];
60     return balanceOf[_address];
61   }
62 
63   function totalInvestors() external returns (uint) {
64     return routingCodes.length;
65   }
66 
67   function createRoutingCode(bytes32 _routingCode) public returns (bool success) {
68     require(routingCodeMap[_routingCode] == address(0));
69 
70     routingCodeMap[_routingCode] = msg.sender;
71     routingCodes.push(_routingCode);
72     return true;
73   }
74 }
75 
76 // Maintain ERC20 compliance -- allow other contracts to access accounts
77 contract FastCashMoneyPlusAccessControl is FastCashMoneyPlusStorage {
78   mapping (address => mapping (address => uint)) internal allowed;
79 
80   event Approval(address indexed _owner, address indexed _spender, uint _value);
81 
82   function approve(address _spender, uint _value) external returns (bool success) {
83     allowed[msg.sender][_spender] = _value;
84     Approval(msg.sender, _spender, _value);
85     return true;
86   }
87   function allowance(address _owner, address _spender) external constant returns (uint remaining) {
88     return allowed[_owner][_spender];
89   }
90 }
91 
92 /*
93 Handle all the logic for selling FastCash to the public
94   The total supply is 1000000 FastCash.
95   But, because solidity does not support floating point numbers, we create a "smallest denomination", equal to 10e-18 FastCash
96   This smallest denomination is called the "MoneyBuck"
97   Additionally, contracts do not support numbers larger than 2^256 (~1.15e77)
98 
99   The price of FastCash in WEI increases by 20% every week, up to week 71.
100   In order to keep the price consistent with USD, the ETH price is adjusted by the USDWEI rate (which the central banker may change).
101 
102   The USD/FASTCASH rate is then $0.25 * (1.2 ** weeksSinceStart)
103   Whereas, the ETH/FASTCASH rate is USD/FASTCASH * ETH/USD
104 
105   But, due to the decimal place restriction, we must multiply single decimal places by 10, and crypto amounts by 10^18, and only divide big numbers.
106   So, WEI/FASTCASH = WEI/USD * ( 4 / ((12 ** weeksSinceStart) / 10) )
107   (To maintain consistency with other currency exchange symbols, WEI/USD is referred to as USDWEI)
108   getExchangeRate uses algebra to adjust these numbers further, such that no point of the calculation refers to a number greater than 2^256.
109 
110 
111   Additionally, all purchases of FASTCASH going through the `buy` channel (which may have a routingCode as referal), credit the referrer with a FastCash bonus equal to 10% of the sale amount.
112 */
113 contract FastCashMoneyPlusSales is FastCashMoneyPlusAccessControl {
114   uint256 public totalSupply;
115   uint256 public fastCashBank;
116   uint public creationDate;
117   uint private constant oneWeek = 60 * 60 * 24 * 7;
118   uint public USDWEI = 760000000000000;
119   uint public referalBonus = 10;
120 
121   event Sale(address _address, uint _amount);
122 
123   function FastCashMoneyPlusSales() public {
124     totalSupply = 1000000 * 10 ** uint256(decimals);
125     fastCashBank = totalSupply;
126     creationDate = now;
127   }
128 
129   function updateUSDWEI(uint _wei) external onlyCentralBanker returns (bool success) {
130     USDWEI = _wei;
131     return true;
132   }
133 
134   function updateReferalBonus(uint _newBonus) external onlyCentralBanker returns (bool success) {
135     referalBonus = _newBonus;
136     return true;
137   }
138 
139   function weeksFromCreation() returns (uint) {
140     return (now - creationDate) / oneWeek;
141   }
142 
143   function getExchangeRate(uint _week, uint _value, uint _usdwei) public returns (uint) {
144     uint __week;
145     if (_week > 71) {
146       __week = 71;
147     } else {
148       __week = _week;
149     }
150 
151     uint extraAdj = 0;
152     if (__week > 50) {
153       extraAdj = __week - 50;
154     }
155 
156     uint minAdj = 10;
157     uint x = __week + decimals - (minAdj + extraAdj);
158 
159     uint n = _value * 4 * uint(10 ** x);
160     uint d = ( _usdwei / uint(10 ** minAdj) ) * (uint(12 ** __week) / uint(10 ** extraAdj));
161 
162     return n / d;
163   }
164 
165   function getCurrentExchangeRate() public returns (uint) {
166     uint _week = weeksFromCreation();
167     return getExchangeRate(_week, USDWEI, USDWEI);
168   }
169 
170   function _makeSale() private returns (uint) {
171     uint _week = weeksFromCreation();
172     uint _value = msg.value;
173 
174     uint moneyBucks = getExchangeRate(_week, _value, USDWEI);
175 
176     require(moneyBucks > 0);
177     require(fastCashBank >= moneyBucks);
178 
179     balanceOf[msg.sender] += moneyBucks;
180     fastCashBank -= moneyBucks;
181 
182     centralBanker.transfer(msg.value);
183     Sale(msg.sender, moneyBucks);
184     return moneyBucks;
185   }
186 
187   function buy(bytes32 _routingCode, bytes32 _referal) payable {
188     uint moneyBucks = _makeSale();
189 
190     if (routingCodeMap[_routingCode] == address(0)) {
191       bool routingCodeCreated = createRoutingCode(_routingCode);
192       require(routingCodeCreated);
193     }
194 
195     if (_referal[0] != 0) {
196       uint referalFee;
197       if (fastCashBank > (moneyBucks / referalBonus)) {
198         referalFee = moneyBucks / referalBonus;
199       } else {
200         referalFee = fastCashBank;
201       }
202       address reference = routingCodeMap[_referal];
203       if (reference != address(0)) {
204         balanceOf[reference] += referalFee;
205         fastCashBank -= referalFee;
206       }
207     }
208   }
209 
210   function () payable {
211     _makeSale();
212   }
213 }
214 
215 // Transfer FastCash between accounts by either ETH address or FastCash routingCode
216 contract FastCashMoneyPlusTransfer is FastCashMoneyPlusSales {
217   event Transfer(address indexed _from, address indexed _to, uint _value);
218 
219   function _transfer(
220     address _from,
221     address _to,
222     uint _amount
223   ) internal returns (bool success) {
224     require(_to != address(0));
225     require(_to != address(this));
226     require(_amount > 0);
227     require(balanceOf[_from] >= _amount);
228     require(balanceOf[_to] + _amount > balanceOf[_to]);
229 
230     balanceOf[_from] -= _amount;
231     balanceOf[_to] += _amount;
232 
233     Transfer(msg.sender, _to, _amount);
234 
235     return true;
236   }
237 
238   function transfer(address _to, uint _amount) external returns (bool success) {
239     return _transfer(msg.sender, _to, _amount);
240   }
241 
242   function transferFrom(address _from, address _to, uint _amount) external returns (bool success) {
243     require(allowed[_from][msg.sender] >= _amount);
244 
245     bool tranferSuccess = _transfer(_from, _to, _amount);
246     if (tranferSuccess) {
247       allowed[_from][msg.sender] -= _amount;
248     } else {
249       return false;
250     }
251   }
252 
253   function transferToAccount(bytes32 _toRoutingCode, uint _amount) external returns (bool success) {
254     return _transfer(msg.sender, routingCodeMap[_toRoutingCode], _amount);
255   }
256 
257   // need to play around with this to figure out some of the specifics
258   function transferRoutingCode(bytes32 _routingCode, address _to) external returns (bool success) {
259     address owner = routingCodeMap[_routingCode];
260     require(msg.sender == owner);
261 
262     routingCodeMap[_routingCode] = _to;
263     return true;
264   }
265 
266   function _transferFromBank(address _to, uint _amount) internal returns (bool success) {
267     require(_to != address(0));
268     require(_amount > 0);
269     require(fastCashBank >= _amount);
270     require(balanceOf[_to] + _amount > balanceOf[_to]);
271 
272     fastCashBank -= _amount;
273     balanceOf[_to] += _amount;
274 
275     Transfer(msg.sender, _to, _amount);
276 
277     return true;
278   }
279   function transferFromBank(address _to, uint _amount) external onlyCentralBanker returns (bool success) {
280     return _transferFromBank(_to, _amount);
281   }
282 
283   function transferFromBankToAccount(bytes32 _toRoutingCode, uint _amount) external onlyCentralBanker returns (bool success) {
284     return _transferFromBank(routingCodeMap[_toRoutingCode], _amount);
285   }
286 }
287 
288 contract FastCashMoneyPlus is FastCashMoneyPlusTransfer {
289 
290 }