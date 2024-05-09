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
109                 circulatingSupply = add(circulatingSupply, fees);
110             }
111 
112             balances[msg.sender] = add(balances[msg.sender], _tokenCount);
113             trancheTokens[maxTranche] = sub(trancheTokens[maxTranche], fees);
114             balances[feesAddr] = add(balances[feesAddr], fees);
115 
116             if(trancheOne) {
117                 trancheOneBalances[feesAddr] = add(trancheOneBalances[feesAddr], fees);
118             }
119 
120             Transfer(this, msg.sender, _tokenCount);
121             Transfer(this, feesAddr, fees);
122             loopCount = 0;
123         }
124     }
125 
126     function transfer(address _to, uint256 _value) public {
127         require(balances[msg.sender] >= _value);
128 
129         if(_to == address(this)) {
130             // WARNING: if you transfer tokens back to the contract you will lose them
131             balances[msg.sender] = sub(balances[msg.sender], _value);
132 
133             if(_value >= trancheOneBalances[msg.sender]) {
134                 trancheOneBalances[msg.sender] = 0;
135             }
136             else {
137                 trancheOneBalances[msg.sender] = sub(trancheOneBalances[msg.sender], _value);
138             }
139 
140             circulatingSupply = sub(circulatingSupply, _value);
141             Transfer(msg.sender, _to, _value);
142         }
143         else {
144             if(now >= trancheOneSaleTime) {
145                 balances[msg.sender] = sub(balances[msg.sender], _value);
146                 balances[_to] = add(balances[_to], _value);
147                 Transfer(msg.sender, _to, _value);
148             }
149             else {
150                 if(_value <= sub(balances[msg.sender],trancheOneBalances[msg.sender])) {
151                     balances[msg.sender] = sub(balances[msg.sender], _value);
152                     balances[_to] = add(balances[_to], _value);
153                     Transfer(msg.sender, _to, _value);
154                 }
155                 else revert();  // you can't transfer tranche1 tokens during the first 6 months
156             }
157         }
158     }
159 
160     function balanceOf(address _receiver) public constant returns (uint256) {
161         return balances[_receiver];
162     }
163 
164     function trancheOneBalanceOf(address _receiver) public constant returns (uint256) {
165         return trancheOneBalances[_receiver];
166     }
167 
168     function balanceInTranche() public constant returns (uint256) {
169         return trancheTokens[trancheLevel];
170     }
171 
172     function balanceInSpecificTranche(uint256 _tranche) public constant returns (uint256) {
173         return trancheTokens[_tranche];
174     }
175 
176     function rateOfSpecificTranche(uint256 _tranche) public constant returns (uint256) {
177         return trancheRate[_tranche];
178     }
179 
180     function changeFeesAddress(address _fees) public {
181         require(msg.sender == feesAddr);
182         feesAddr = _fees;
183     }
184 
185     function payFeesToggle() public {
186         require(msg.sender == owner);
187         if(payFees) {
188             payFees = false;
189         }
190         else {
191             payFees = true;
192         }
193     }
194 
195     // enables fee update - must be between 0 and 100 (%)
196     function updateFeeAmount(uint _newFee) public {
197         require(msg.sender == owner);
198         require((_newFee >= 0) && (_newFee <= 100));
199         feePercent = _newFee * 100;
200     }
201 
202     function changeOwner(address _recipient) public {
203         require(msg.sender == owner);
204         owner = _recipient;
205     }
206 
207     function changeTrancheAdmin(address _trancheAdmin) public {
208         require((msg.sender == owner) || (msg.sender == trancheAdmin));
209         trancheAdmin = _trancheAdmin;
210     }
211 
212     function toggleReceiveEth() public {
213         require(msg.sender == owner);
214         if(receiveEth == true) {
215             receiveEth = false;
216         }
217         else receiveEth = true;
218     }
219 
220     function otcPurchase(uint256 _tokens, address _recipient) public {
221         require(msg.sender == owner);
222         balances[_recipient] = add(balances[_recipient], _tokens);
223         circulatingSupply = add(circulatingSupply, _tokens);
224         Transfer(this, _recipient, _tokens);
225     }
226 
227     function otcPurchaseAndEscrow(uint256 _tokens, address _recipient) public {
228         require(msg.sender == owner);
229         balances[_recipient] = add(balances[_recipient], _tokens);
230         trancheOneBalances[_recipient] = add(trancheOneBalances[_recipient], _tokens);
231         circulatingSupply = add(circulatingSupply, _tokens);
232         Transfer(this, _recipient, _tokens);
233     }
234 
235     function safeWithdrawal(address _receiver, uint256 _value) public {
236         require(msg.sender == owner);
237         require(_value <= this.balance);
238         _receiver.transfer(_value);
239     }
240 
241     function addTrancheRateAndTokens(uint256 _tokens, uint256 _rate) public {
242         require(((msg.sender == owner) || (msg.sender == trancheAdmin)) && (addTranches == true));
243         require(add(_tokens, circulatingSupply) <= totalSupply);
244         maxTranche++;
245         trancheTokens[maxTranche] = _tokens;
246         trancheRate[maxTranche] = _rate;
247     }
248 
249     // enables adjustment based on ETH/EUR variation
250     function updateTrancheRate(uint256 _level, uint256 _rate) {
251         require(((msg.sender == owner) || (msg.sender == trancheAdmin)) && trancheRate[_level] > 0);
252         trancheRate[_level] = _rate;
253     }
254 
255     // when all tranches have been added to the contract trigger this to make adding more impossible
256     function closeTrancheAddition() public {
257         require(msg.sender == owner);
258         addTranches = false;
259     }
260 
261     function mul(uint256 a, uint256 b) internal pure returns (uint) {
262         uint c = a * b;
263         require(a == 0 || c / a == b);
264         return c;
265     }
266 
267     function div(uint256 a, uint256 b) internal pure returns (uint) {
268         // assert(b > 0); // Solidity automatically throws when dividing by 0
269         uint c = a / b;
270         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
271         return c;
272     }
273 
274     function sub(uint256 a, uint256 b) internal pure returns (uint) {
275         require(b <= a);
276         return a - b;
277     }
278 
279     function add(uint256 a, uint256 b) internal pure returns (uint) {
280         uint c = a + b;
281         require(c >= a);
282         return c;
283     }
284 
285     // ERC20 compliance
286     function transferFrom(address _from, address _to, uint256 _tokens) public returns (bool success) {
287         require(balances[_from] >= _tokens);
288         balances[_from] = sub(balances[_from],_tokens);
289         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender],_tokens);
290         balances[_to] = add(balances[_to],_tokens);
291         Transfer(_from, _to, _tokens);
292         return true;
293     }
294 
295     function approve(address _spender, uint256 _tokens) public returns (bool success) {
296         allowed[msg.sender][_spender] = _tokens;
297         Approval(msg.sender, _spender, _tokens);
298         return true;
299     }
300 
301     function allowance(address _tokenOwner, address _spender) public constant returns (uint256 remaining) {
302         return allowed[_tokenOwner][_spender];
303     }
304 }