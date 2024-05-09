1 contract UTU {
2     string public name = "Upgrade Token Utility";
3     uint8 public decimals = 18;
4     string public symbol = "UTU";
5 
6     address public owner;
7     address public feesAddr;
8     address trancheAdmin;
9 
10     uint256 public totalSupply = 50000000000000000000000000; // 50m e18
11     uint public trancheLevel = 1;
12     uint256 public circulatingSupply = 0;
13     uint maxTranche = 4;
14     uint loopCount = 0;
15     uint256 feePercent = 1500;  // the calculation expects % * 100 (so 10% is 1000)
16     uint256 public trancheOneSaleTime;
17     bool public receiveEth = true;
18     bool payFees = true;
19     bool addTranches = true;
20     bool trancheOne = true;
21 
22     // Storage
23     mapping (address => uint256) public balances;
24     mapping (address => uint256) public trancheOneBalances;
25     mapping (address => mapping (address => uint256)) allowed;
26 
27     // mining schedule
28     mapping(uint => uint256) public trancheTokens;
29     mapping(uint => uint256) public trancheRate;
30 
31     // events (ERC20)
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint _value);
34 
35     function UTU() {
36         owner = msg.sender;
37         feesAddr = msg.sender;
38         trancheAdmin = msg.sender;
39         trancheOneSaleTime = now + 182 days;    // 6 months
40         populateTrancheTokens();
41         populateTrancheRates();
42     }
43 
44     function populateTrancheTokens() internal {
45         trancheTokens[1] = 1E25;
46         trancheTokens[2] = 2E25;
47         trancheTokens[3] = 1E25;
48         trancheTokens[4] = 1E25;
49     }
50 
51     function populateTrancheRates() internal {
52         trancheRate[1] = 3.457E20;
53         trancheRate[2] = 8.643E19;
54         trancheRate[3] = 4.321E19;
55         trancheRate[4] = 2.161E19;
56     }
57 
58     function () payable public {
59         require((msg.value > 0) && (receiveEth));
60         allocateTokens(msg.value,0);
61     }
62 
63     function allocateTokens(uint256 _submitted, uint256 _tokenCount) internal {
64         uint256 _tokensAfforded = 0;
65         loopCount++;
66 
67         if((trancheLevel <= maxTranche) && (loopCount <= maxTranche)) {
68             _tokensAfforded = div(mul(_submitted, trancheRate[trancheLevel]), 1 ether);
69         }
70 
71         if((_tokensAfforded >= trancheTokens[trancheLevel]) && (loopCount <= maxTranche)) {
72             _submitted = sub(_submitted, div(mul(trancheTokens[trancheLevel], 1 ether), trancheRate[trancheLevel]));
73             _tokenCount = add(_tokenCount, trancheTokens[trancheLevel]);
74 
75             if(trancheLevel == 1) {
76                 // we need to record tranche1 purchases so we can stop sale/transfer of them during the first 6 mths
77                 trancheOneBalances[msg.sender] = add(trancheOneBalances[msg.sender], trancheTokens[trancheLevel]);
78             }
79 
80             circulatingSupply = add(circulatingSupply, _tokensAfforded);
81             trancheTokens[trancheLevel] = 0;
82 
83             trancheLevel++;
84 
85             if(trancheLevel == 2) {
86                 trancheOne = false;
87             }
88 
89             allocateTokens(_submitted, _tokenCount);
90         }
91         else if((trancheTokens[trancheLevel] >= _tokensAfforded) && (_tokensAfforded > 0) && (loopCount <= maxTranche)) {
92             trancheTokens[trancheLevel] = sub(trancheTokens[trancheLevel], _tokensAfforded);
93             _tokenCount = add(_tokenCount, _tokensAfforded);
94             circulatingSupply = add(circulatingSupply, _tokensAfforded);
95 
96             if(trancheLevel == 1) {
97                 // we need to record tranche1 purchases
98                 trancheOneBalances[msg.sender] = add(trancheOneBalances[msg.sender], _tokenCount);
99             }
100 
101             // we've spent up - go around again and issue tokens to recipient
102             allocateTokens(0, _tokenCount);
103         }
104         else {
105             // 15% of the purchased tokens amount is fees
106             uint256 fees = 0;
107             if(payFees) {
108                 fees = add(fees, ((_tokenCount * feePercent) / 10000));
109             }
110 
111             balances[msg.sender] = add(balances[msg.sender], _tokenCount);
112             trancheTokens[maxTranche] = sub(trancheTokens[maxTranche], fees);
113             balances[feesAddr] = add(balances[feesAddr], fees);
114 
115             if(trancheOne) {
116                 trancheOneBalances[feesAddr] = add(trancheOneBalances[feesAddr], fees);
117             }
118 
119             Transfer(this, msg.sender, _tokenCount);
120             Transfer(this, feesAddr, fees);
121             loopCount = 0;
122         }
123     }
124 
125     function transfer(address _to, uint256 _value) public {
126         require(balances[msg.sender] >= _value);
127 
128         if(_to == address(this)) {
129             // WARNING: if you transfer tokens back to the contract you will lose them
130             balances[msg.sender] = sub(balances[msg.sender], _value);
131 
132             if(_value >= trancheOneBalances[msg.sender]) {
133                 trancheOneBalances[msg.sender] = 0;
134             }
135             else {
136                 trancheOneBalances[msg.sender] = sub(trancheOneBalances[msg.sender], _value);
137             }
138 
139             circulatingSupply = sub(circulatingSupply, _value);
140             Transfer(msg.sender, _to, _value);
141         }
142         else {
143             if(now >= trancheOneSaleTime) {
144                 balances[msg.sender] = sub(balances[msg.sender], _value);
145                 balances[_to] = add(balances[_to], _value);
146                 Transfer(msg.sender, _to, _value);
147             }
148             else {
149                 if(_value <= sub(balances[msg.sender],trancheOneBalances[msg.sender])) {
150                     balances[msg.sender] = sub(balances[msg.sender], _value);
151                     balances[_to] = add(balances[_to], _value);
152                     Transfer(msg.sender, _to, _value);
153                 }
154                 else revert();  // you can't transfer tranche1 tokens during the first 6 months
155             }
156         }
157     }
158 
159     function balanceOf(address _receiver) public constant returns (uint256) {
160         return balances[_receiver];
161     }
162 
163     function trancheOneBalanceOf(address _receiver) public constant returns (uint256) {
164         return trancheOneBalances[_receiver];
165     }
166 
167     function balanceInTranche() public constant returns (uint256) {
168         return trancheTokens[trancheLevel];
169     }
170 
171     function balanceInSpecificTranche(uint256 _tranche) public constant returns (uint256) {
172         return trancheTokens[_tranche];
173     }
174 
175     function rateOfSpecificTranche(uint256 _tranche) public constant returns (uint256) {
176         return trancheRate[_tranche];
177     }
178 
179     function changeFeesAddress(address _fees) public {
180         require(msg.sender == feesAddr);
181         feesAddr = _fees;
182     }
183 
184     function payFeesToggle() public {
185         require(msg.sender == owner);
186         if(payFees) {
187             payFees = false;
188         }
189         else {
190             payFees = true;
191         }
192     }
193 
194     // enables fee update - must be between 0 and 100 (%)
195     function updateFeeAmount(uint _newFee) public {
196         require(msg.sender == owner);
197         require((_newFee >= 0) && (_newFee <= 100));
198         feePercent = _newFee * 100;
199     }
200 
201     function changeOwner(address _recipient) public {
202         require(msg.sender == owner);
203         owner = _recipient;
204     }
205 
206     function changeTrancheAdmin(address _trancheAdmin) public {
207         require((msg.sender == owner) || (msg.sender == trancheAdmin));
208         trancheAdmin = _trancheAdmin;
209     }
210 
211     function toggleReceiveEth() public {
212         require(msg.sender == owner);
213         if(receiveEth == true) {
214             receiveEth = false;
215         }
216         else receiveEth = true;
217     }
218 
219     function otcPurchase(uint256 _tokens, address _recipient) public {
220         require(msg.sender == owner);
221         balances[_recipient] = add(balances[_recipient], _tokens);
222         Transfer(this, _recipient, _tokens);
223     }
224 
225     function otcPurchaseAndEscrow(uint256 _tokens, address _recipient) public {
226         require(msg.sender == owner);
227         balances[_recipient] = add(balances[_recipient], _tokens);
228         trancheOneBalances[msg.sender] = add(trancheOneBalances[msg.sender], _tokens);
229         Transfer(this, _recipient, _tokens);
230     }
231 
232     function safeWithdrawal(address _receiver, uint256 _value) public {
233         require(msg.sender == owner);
234         require(_value <= this.balance);
235         _receiver.transfer(_value);
236     }
237 
238     function addTrancheRateAndTokens(uint256 _tokens, uint256 _rate) public {
239         require(((msg.sender == owner) || (msg.sender == trancheAdmin)) && (addTranches == true));
240         require(add(_tokens, circulatingSupply) <= totalSupply);
241         maxTranche++;
242         trancheTokens[maxTranche] = _tokens;
243         trancheRate[maxTranche] = _rate;
244     }
245 
246     // enables adjustment based on ETH/EUR variation
247     function updateTrancheRate(uint256 _level, uint256 _rate) {
248         require(((msg.sender == owner) || (msg.sender == trancheAdmin)) && trancheRate[_level] > 0);
249         trancheRate[_level] = _rate;
250     }
251 
252     // when all tranches have been added to the contract trigger this to make adding more impossible
253     function closeTrancheAddition() public {
254         require(msg.sender == owner);
255         addTranches = false;
256     }
257 
258     function mul(uint256 a, uint256 b) internal pure returns (uint) {
259         uint c = a * b;
260         require(a == 0 || c / a == b);
261         return c;
262     }
263 
264     function div(uint256 a, uint256 b) internal pure returns (uint) {
265         // assert(b > 0); // Solidity automatically throws when dividing by 0
266         uint c = a / b;
267         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
268         return c;
269     }
270 
271     function sub(uint256 a, uint256 b) internal pure returns (uint) {
272         require(b <= a);
273         return a - b;
274     }
275 
276     function add(uint256 a, uint256 b) internal pure returns (uint) {
277         uint c = a + b;
278         require(c >= a);
279         return c;
280     }
281 
282     // ERC20 compliance
283     function transferFrom(address _from, address _to, uint256 _tokens) public returns (bool success) {
284         require(balances[_from] >= _tokens);
285         balances[_from] = sub(balances[_from],_tokens);
286         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender],_tokens);
287         balances[_to] = add(balances[_to],_tokens);
288         Transfer(_from, _to, _tokens);
289         return true;
290     }
291 
292     function approve(address _spender, uint256 _tokens) public returns (bool success) {
293         allowed[msg.sender][_spender] = _tokens;
294         Approval(msg.sender, _spender, _tokens);
295         return true;
296     }
297 
298     function allowance(address _tokenOwner, address _spender) public constant returns (uint256 remaining) {
299         return allowed[_tokenOwner][_spender];
300     }
301 }