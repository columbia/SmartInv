1 pragma solidity ^0.4.23;
2 
3 contract UTU {
4     string public name = "Upgrade Token Utility";
5     uint8 public decimals = 18;
6     string public symbol = "UTU";
7 
8     address public owner;
9     address public feesAddr;
10     address trancheAdmin;
11 
12     uint256 public totalSupply = 50000000000000000000000000; // 50m e18
13     uint public trancheLevel = 1;
14     uint256 public circulatingSupply = 0;
15     uint maxTranche = 4;
16     uint loopCount = 0;
17     uint256 feePercent = 1500;  // the calculation expects % * 100 (so 10% is 1000)
18     uint256 trancheOneSaleTime;
19     bool public receiveEth = true;
20     bool payFees = true;
21     bool addTranches = true;
22     bool public initialTranches = false;
23     bool trancheOne = true;
24 
25     // Storage
26     mapping (address => uint256) public balances;
27     mapping (address => uint256) public trancheOneBalances;
28     mapping(address => mapping (address => uint256)) allowed;
29 
30     // mining schedule
31     mapping(uint => uint256) public trancheTokens;
32     mapping(uint => uint256) public trancheRate;
33 
34     // events (ERC20)
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint _value);
37 
38     function UTU() {
39         owner = msg.sender;
40         feesAddr = msg.sender;
41         trancheAdmin = msg.sender;
42         trancheOneSaleTime = now + 182 days;    // 6 months
43         populateTrancheTokens();
44         populateTrancheRates();
45     }
46 
47     function populateTrancheTokens() internal {
48         trancheTokens[1] = 1E25;
49         trancheTokens[2] = 2E25;
50         trancheTokens[3] = 1E25;
51         trancheTokens[4] = 1E25;
52     }
53 
54     function populateTrancheRates() internal {
55         trancheRate[1] = 5E24;
56         trancheRate[2] = 8.643E19;
57         trancheRate[3] = 4.321E19;
58         trancheRate[4] = 2.161E19;
59         initialTranches = true;
60     }
61 
62     function () payable public {
63         require((msg.value > 0) && (receiveEth));
64         allocateTokens(msg.value,0);
65     }
66 
67     function allocateTokens(uint256 _submitted, uint256 _tokenCount) internal {
68         uint256 _tokensAfforded = 0;
69         loopCount++;
70 
71         if((trancheLevel <= maxTranche) && (loopCount <= maxTranche)) {
72             _tokensAfforded = div(mul(_submitted, trancheRate[trancheLevel]), 1 ether);
73         }
74 
75         if((_tokensAfforded >= trancheTokens[trancheLevel]) && (loopCount <= maxTranche)) {
76             _submitted = sub(_submitted, div(mul(trancheTokens[trancheLevel], 1 ether), trancheRate[trancheLevel]));
77             _tokenCount = add(_tokenCount, trancheTokens[trancheLevel]);
78 
79             if(trancheLevel == 1) {
80                 // we need to record tranche1 purchases so we can stop sale/transfer of them during the first 6 mths
81                 trancheOneBalances[msg.sender] = add(trancheOneBalances[msg.sender], trancheTokens[trancheLevel]);
82             }
83 
84             circulatingSupply = add(circulatingSupply, _tokensAfforded);
85             trancheTokens[trancheLevel] = 0;
86 
87             trancheLevel++;
88 
89             if(trancheLevel == 2) {
90                 trancheOne = false;
91             }
92 
93             allocateTokens(_submitted, _tokenCount);
94         }
95         else if((trancheTokens[trancheLevel] >= _tokensAfforded) && (_tokensAfforded > 0) && (loopCount <= maxTranche)) {
96             trancheTokens[trancheLevel] = sub(trancheTokens[trancheLevel], _tokensAfforded);
97             _tokenCount = add(_tokenCount, _tokensAfforded);
98             circulatingSupply = add(circulatingSupply, _tokensAfforded);
99 
100             if(trancheLevel == 1) {
101                 // we need to record tranche1 purchases
102                 trancheOneBalances[msg.sender] = add(trancheOneBalances[msg.sender], _tokenCount);
103             }
104 
105             // we've spent up - go around again and issue tokens to recipient
106             allocateTokens(0, _tokenCount);
107         }
108         else {
109             // 15% of the purchased tokens amount is fees
110             uint256 fees = 0;
111             if(payFees) {
112                 fees = add(fees, ((_tokenCount * feePercent) / 10000));
113             }
114 
115             balances[msg.sender] = add(balances[msg.sender], _tokenCount);
116             trancheTokens[maxTranche] = sub(trancheTokens[maxTranche], fees);
117             balances[feesAddr] = add(balances[feesAddr], fees);
118 
119             if(trancheOne) {
120                 trancheOneBalances[feesAddr] = add(trancheOneBalances[feesAddr], fees);
121             }
122 
123             Transfer(this, msg.sender, _tokenCount);
124             Transfer(this, feesAddr, fees);
125             loopCount = 0;
126         }
127     }
128 
129     function transfer(address _to, uint256 _value) public {
130         require(balances[msg.sender] >= _value);
131 
132         if(_to == address(this)) {
133             // WARNING: if you transfer tokens back to the contract you will lose them
134             balances[msg.sender] = sub(balances[msg.sender], _value);
135             circulatingSupply = sub(circulatingSupply, _value);
136             Transfer(msg.sender, _to, _value);
137         }
138         else {
139             if(now >= trancheOneSaleTime) {
140                 balances[msg.sender] = sub(balances[msg.sender], _value);
141                 balances[_to] = add(balances[_to], _value);
142                 Transfer(msg.sender, _to, _value);
143             }
144             else {
145                 if(_value <= sub(balances[msg.sender],trancheOneBalances[msg.sender])) {
146                     balances[msg.sender] = sub(balances[msg.sender], _value);
147                     balances[_to] = add(balances[_to], _value);
148                     Transfer(msg.sender, _to, _value);
149                 }
150                 else revert();  // you can't transfer tranche1 tokens during the first 6 months
151             }
152         }
153     }
154 
155     function balanceOf(address _receiver) public constant returns (uint256) {
156         return balances[_receiver];
157     }
158 
159     function trancheOneBalanceOf(address _receiver) public constant returns (uint256) {
160         return trancheOneBalances[_receiver];
161     }
162 
163     function balanceInTranche() public constant returns (uint256) {
164         return trancheTokens[trancheLevel];
165     }
166 
167     function balanceInSpecificTranche(uint256 _tranche) public constant returns (uint256) {
168         return trancheTokens[_tranche];
169     }
170 
171     function rateOfSpecificTranche(uint256 _tranche) public constant returns (uint256) {
172         return trancheRate[_tranche];
173     }
174 
175     function changeFeesAddress(address _devFees) public {
176         require(msg.sender == owner);
177         feesAddr = _devFees;
178     }
179 
180     function payFeesToggle() public {
181         require(msg.sender == owner);
182         if(payFees) {
183             payFees = false;
184         }
185         else {
186             payFees = true;
187         }
188     }
189 
190     // enables fee update - must be between 0 and 100 (%)
191     function updateFeeAmount(uint _newFee) public {
192         require(msg.sender == owner);
193         require((_newFee >= 0) && (_newFee <= 100));
194         feePercent = _newFee * 100;
195     }
196 
197     function changeOwner(address _recipient) public {
198         require(msg.sender == owner);
199         owner = _recipient;
200     }
201 
202     function changeTrancheAdmin(address _trancheAdmin) public {
203         require((msg.sender == owner) || (msg.sender == trancheAdmin));
204         trancheAdmin = _trancheAdmin;
205     }
206 
207     function toggleReceiveEth() public {
208         require(msg.sender == owner);
209         if(receiveEth == true) {
210             receiveEth = false;
211         }
212         else receiveEth = true;
213     }
214 
215     function otcPurchase(uint256 _tokens, address _recipient) public {
216         require(msg.sender == owner);
217         balances[_recipient] = add(balances[_recipient], _tokens);
218         Transfer(this, _recipient, _tokens);
219     }
220 
221     function otcPurchaseAndEscrow(uint256 _tokens, address _recipient) public {
222         require(msg.sender == owner);
223         balances[_recipient] = add(balances[_recipient], _tokens);
224         trancheOneBalances[msg.sender] = add(trancheOneBalances[msg.sender], _tokens);
225         Transfer(this, _recipient, _tokens);
226     }
227 
228     function safeWithdrawal(address _receiver, uint256 _value) public {
229         require(msg.sender == owner);
230         require(_value <= this.balance);
231         _receiver.transfer(_value);
232     }
233 
234     function addTrancheRateAndTokens(uint256 _level, uint256 _tokens, uint256 _rate) public {
235         require(((msg.sender == owner) || (msg.sender == trancheAdmin)) && (addTranches == true));
236         require(add(_tokens, circulatingSupply) <= totalSupply);
237         trancheTokens[_level] = _tokens;
238         trancheRate[_level] = _rate;
239         maxTranche++;
240     }
241 
242     function updateTrancheRate(uint256 _level, uint256 _rate) {
243         require((msg.sender == owner) || (msg.sender == trancheAdmin));
244         trancheRate[_level] = _rate;
245     }
246 
247     // when all tranches have been added to the contract
248     function closeTrancheAddition() public {
249         require(msg.sender == owner);
250         addTranches = false;
251     }
252 
253     function trancheOneSaleOpenTime() returns (uint256) {
254         return trancheOneSaleTime;
255     }
256 
257     function mul(uint256 a, uint256 b) internal pure returns (uint) {
258         uint c = a * b;
259         require(a == 0 || c / a == b);
260         return c;
261     }
262 
263     function div(uint256 a, uint256 b) internal pure returns (uint) {
264         // assert(b > 0); // Solidity automatically throws when dividing by 0
265         uint c = a / b;
266         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
267         return c;
268     }
269 
270     function sub(uint256 a, uint256 b) internal pure returns (uint) {
271         require(b <= a);
272         return a - b;
273     }
274 
275     function add(uint256 a, uint256 b) internal pure returns (uint) {
276         uint c = a + b;
277         require(c >= a);
278         return c;
279     }
280 
281     // ERC20 compliance
282     function transferFrom(address _from, address _to, uint256 _tokens) public returns (bool success) {
283         require(balances[_from] >= _tokens);
284         balances[_from] = sub(balances[_from],_tokens);
285         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender],_tokens);
286         balances[_to] = add(balances[_to],_tokens);
287         Transfer(_from, _to, _tokens);
288         return true;
289     }
290 
291     function approve(address _spender, uint256 _tokens) public returns (bool success) {
292         allowed[msg.sender][_spender] = _tokens;
293         Approval(msg.sender, _spender, _tokens);
294         return true;
295     }
296 
297     function allowance(address _tokenOwner, address _spender) public constant returns (uint256 remaining) {
298         return allowed[_tokenOwner][_spender];
299     }
300 }