1 contract Partner {
2     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens);
3 }
4 
5 contract Target {
6     function transfer(address _to, uint _value);
7 }
8 
9 contract PRECOE {
10 
11     string public name = "Premined Coeval";
12     uint8 public decimals = 18;
13     string public symbol = "PRECOE";
14 
15     address public owner;
16     address public devFeesAddr = 0x36Bdc3B60dC5491fbc7d74a05709E94d5b554321;
17     address tierAdmin;
18 
19     uint256 public totalSupply = 71433000000000000000000;
20     uint256 public mineableTokens = totalSupply;
21     uint public tierLevel = 1;
22     uint256 public fiatPerEth = 3.85E25;
23     uint256 public circulatingSupply = 0;
24     uint maxTier = 132;
25     uint256 public devFees = 0;
26     uint256 fees = 10000;  // the calculation expects % * 100 (so 10% is 1000)
27 
28     bool public receiveEth = false;
29     bool payFees = true;
30     bool public canExchange = true;
31     bool addTiers = true;
32     bool public initialTiers = false;
33 
34     // Storage
35     mapping (address => uint256) public balances;
36     mapping (address => bool) public exchangePartners;
37 
38     // mining schedule
39     mapping(uint => uint256) public scheduleTokens;
40     mapping(uint => uint256) public scheduleRates;
41 
42     // events (ERC20)
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint _value);
45 
46     // events (custom)
47     event TokensExchanged(address indexed _owningWallet, address indexed _with, uint256 _value);
48 
49     function PRECOE() {
50         owner = msg.sender;
51         // premine
52         balances[owner] = add(balances[owner],4500000000000000000000);
53         Transfer(this, owner, 4500000000000000000000);
54         circulatingSupply = add(circulatingSupply, 4500000000000000000000);
55         mineableTokens = sub(mineableTokens,4500000000000000000000);
56     }
57 
58     function populateTierTokens() public {
59         require((msg.sender == owner) && (initialTiers == false));
60         scheduleTokens[1] = 1E20;
61         scheduleTokens[2] = 1E20;
62         scheduleTokens[3] = 1E20;
63         scheduleTokens[4] = 1E20;
64         scheduleTokens[5] = 1E20;
65         scheduleTokens[6] = 1E20;
66         scheduleTokens[7] = 1E20;
67         scheduleTokens[8] = 1E20;
68         scheduleTokens[9] = 1E20;
69         scheduleTokens[10] = 1E20;
70         scheduleTokens[11] = 1E20;
71         scheduleTokens[12] = 1E20;
72         scheduleTokens[13] = 1E20;
73         scheduleTokens[14] = 1E20;
74         scheduleTokens[15] = 1E20;
75         scheduleTokens[16] = 1E20;
76         scheduleTokens[17] = 1E20;
77         scheduleTokens[18] = 1E20;
78         scheduleTokens[19] = 1E20;
79         scheduleTokens[20] = 1E20;
80         scheduleTokens[21] = 1E20;
81         scheduleTokens[22] = 1E20;
82         scheduleTokens[23] = 1E20;
83         scheduleTokens[24] = 1E20;
84         scheduleTokens[25] = 1E20;
85         scheduleTokens[26] = 1E20;
86         scheduleTokens[27] = 1E20;
87         scheduleTokens[28] = 1E20;
88         scheduleTokens[29] = 1E20;
89         scheduleTokens[30] = 3E20;
90         scheduleTokens[31] = 3E20;
91         scheduleTokens[32] = 3E20;
92         scheduleTokens[33] = 3E20;
93         scheduleTokens[34] = 3E20;
94         scheduleTokens[35] = 3E20;
95         scheduleTokens[36] = 3E20;
96         scheduleTokens[37] = 3E20;
97         scheduleTokens[38] = 3E20;
98         scheduleTokens[39] = 3E20;
99         scheduleTokens[40] = 3E20;
100     }
101 
102     function populateTierRates() public {
103         //require((msg.sender == owner) && (initialTiers == false));
104         //require(msg.sender == owner);
105         scheduleRates[1] = 3.85E23;
106         scheduleRates[2] = 6.1E23;
107         scheduleRates[3] = 4.15E23;
108         scheduleRates[4] = 5.92E23;
109         scheduleRates[5] = 9.47E23;
110         scheduleRates[6] = 1.1E24;
111         scheduleRates[7] = 1.123E24;
112         scheduleRates[8] = 1.15E24;
113         scheduleRates[9] = 1.135E24;
114         scheduleRates[10] = 1.013E24;
115         scheduleRates[11] = 8.48E23;
116         scheduleRates[12] = 8.17E23;
117         scheduleRates[13] = 7.3E23;
118         scheduleRates[14] = 9.8E23;
119         scheduleRates[15] = 1.07E23;
120         scheduleRates[16] = 1.45E24;
121         scheduleRates[17] = 1.242E24;
122         scheduleRates[18] = 1.383E24;
123         scheduleRates[19] = 1.442E24;
124         scheduleRates[20] = 4.8E22;
125         scheduleRates[21] = 1.358E24;
126         scheduleRates[22] = 1.25E23;
127         scheduleRates[23] = 9.94E24;
128         scheduleRates[24] = 1.14E24;
129         scheduleRates[25] = 1.253E24;
130         scheduleRates[26] = 1.29E24;
131         scheduleRates[27] = 1.126E24;
132         scheduleRates[28] = 1.173E24;
133         scheduleRates[29] = 1.074E24;
134         scheduleRates[30] = 1.127E24;
135         scheduleRates[31] = 1.223E24;
136         scheduleRates[32] = 1.145E24;
137         scheduleRates[33] = 1.199E24;
138         scheduleRates[34] = 1.319E24;
139         scheduleRates[35] = 1.312E24;
140         scheduleRates[36] = 1.287E24;
141         scheduleRates[37] = 1.175E24;
142         scheduleRates[38] = 1.15E23;
143         scheduleRates[39] = 1.146E24;
144         scheduleRates[40] = 1.098E24;
145         initialTiers = true;
146     }
147 
148     function () payable public {
149         require((msg.value > 0) && (receiveEth));
150 
151         if(payFees) {
152             devFees = add(devFees, ((msg.value * fees) / 10000));
153         }
154         allocateTokens(convertEthToCents(msg.value),0);
155     }
156 
157     function convertEthToCents(uint256 _incoming) internal returns (uint256) {
158         return mul(_incoming, fiatPerEth);
159     }
160 
161     function allocateTokens(uint256 _submitted, uint256 _tokenCount) internal {
162         uint256 _tokensAfforded = 0;
163 
164         if(tierLevel <= maxTier) {
165             _tokensAfforded = div(_submitted, scheduleRates[tierLevel]);
166         }
167 
168         if(_tokensAfforded >= scheduleTokens[tierLevel]) {
169             _submitted = sub(_submitted, mul(scheduleTokens[tierLevel], scheduleRates[tierLevel]));
170             _tokenCount = add(_tokenCount, scheduleTokens[tierLevel]);
171             circulatingSupply = add(circulatingSupply, _tokensAfforded);
172             mineableTokens = sub(mineableTokens, _tokensAfforded);
173             scheduleTokens[tierLevel] = 0;
174             tierLevel++;
175             allocateTokens(_submitted, _tokenCount);
176         }
177         else if((scheduleTokens[tierLevel] >= _tokensAfforded) && (_tokensAfforded > 0)) {
178             scheduleTokens[tierLevel] = sub(scheduleTokens[tierLevel], _tokensAfforded);
179             _tokenCount = add(_tokenCount, _tokensAfforded);
180             circulatingSupply = add(circulatingSupply, _tokensAfforded);
181             mineableTokens = sub(mineableTokens, _tokensAfforded);
182             _submitted = sub(_submitted, mul(_tokensAfforded, scheduleRates[tierLevel]));
183             allocateTokens(_submitted, _tokenCount);
184         }
185         else {
186             balances[msg.sender] = add(balances[msg.sender], _tokenCount);
187             Transfer(this, msg.sender, _tokenCount);
188         }
189     }
190 
191     function transfer(address _to, uint _value) public {
192         require(balances[msg.sender] >= _value);
193 
194         if(_to == address(this)) {
195             // WARNING: if you transfer tokens back to the contract you will lose them
196             // use the exchange function to exchange for tokens with approved partner contracts
197             balances[msg.sender] = sub(balances[msg.sender], _value);
198             Transfer(msg.sender, _to, _value);
199         }
200         else {
201             uint codeLength;
202 
203             assembly {
204                 codeLength := extcodesize(_to)
205             }
206 
207             if(codeLength != 0) {
208                 if(canExchange == true) {
209                     if(exchangePartners[_to]) {
210                         // WARNING: exchanging COE into MNY costs more Gas than a normal transfer as we interact directly
211                         // with the MNY contract - suggest doubling the recommended gas limit
212                         exchange(_to, _value);
213                     }
214                     else {
215                         // WARNING: if you transfer to a contract that cannot handle incoming tokens you may lose them
216                         balances[msg.sender] = sub(balances[msg.sender], _value);
217                         balances[_to] = add(balances[_to], _value);
218                         Transfer(msg.sender, _to, _value);
219                     }
220                 }
221             }
222             else {
223                 balances[msg.sender] = sub(balances[msg.sender], _value);
224                 balances[_to] = add(balances[_to], _value);
225                 Transfer(msg.sender, _to, _value);
226             }
227         }
228     }
229 
230     function exchange(address _partner, uint256 _amount) internal {
231         require(exchangePartners[_partner]);
232         requestTokensFromOtherContract(_partner, this, msg.sender, _amount);
233         balances[msg.sender] = sub(balanceOf(msg.sender), _amount);
234         circulatingSupply = sub(circulatingSupply, _amount);
235         Transfer(msg.sender, this, _amount);
236         TokensExchanged(msg.sender, _partner, _amount);
237     }
238 
239     function requestTokensFromOtherContract(address _targetContract, address _sourceContract, address _recipient, uint256 _value) internal returns (bool){
240         Partner p = Partner(_targetContract);
241         p.exchangeTokensFromOtherContract(_sourceContract, _recipient, _value);
242         return true;
243     }
244 
245     function balanceOf(address _receiver) public constant returns (uint256) {
246         return balances[_receiver];
247     }
248 
249     function balanceInTier() public constant returns (uint256) {
250         return scheduleTokens[tierLevel];
251     }
252 
253     function balanceInSpecificTier(uint256 _tier) public constant returns (uint256) {
254         return scheduleTokens[_tier];
255     }
256 
257     function rateOfSpecificTier(uint256 _tier) public constant returns (uint256) {
258         return scheduleRates[_tier];
259     }
260 
261     function setFiatPerEthRate(uint256 _newRate) public {
262         require(msg.sender == owner);
263         fiatPerEth = _newRate;
264     }
265 
266     function addExchangePartnerTargetAddress(address _partner) public {
267         require(msg.sender == owner);
268         exchangePartners[_partner] = true;
269     }
270 
271     function canContractExchange(address _contract) public constant returns (bool) {
272         return exchangePartners[_contract];
273     }
274 
275     function removeExchangePartnerTargetAddress(address _partner) public {
276         require(msg.sender == owner);
277         exchangePartners[_partner] = false;
278     }
279 
280     function withdrawDevFees() public {
281         require(payFees);
282         devFeesAddr.transfer(devFees);
283         devFees = 0;
284     }
285 
286     function changeDevFees(address _devFees) public {
287         require(msg.sender == owner);
288         devFeesAddr = _devFees;
289     }
290 
291     function payFeesToggle() public {
292         require(msg.sender == owner);
293         if(payFees) {
294             payFees = false;
295         }
296         else {
297             payFees = true;
298         }
299     }
300 
301     function safeWithdrawal(address _receiver, uint256 _value) public {
302         require(msg.sender == owner);
303         withdrawDevFees();
304         require(_value <= this.balance);
305         _receiver.transfer(_value);
306     }
307 
308     // enables fee update - must be between 0 and 100 (%)
309     function updateFeeAmount(uint _newFee) public {
310         require(msg.sender == owner);
311         require((_newFee >= 0) && (_newFee <= 100));
312         fees = _newFee * 100;
313     }
314 
315     function handleTokensFromOtherContracts(address _contract, address _recipient, uint256 _tokens) public {
316         require(msg.sender == owner);
317         Target t;
318         t = Target(_contract);
319         t.transfer(_recipient, _tokens);
320     }
321 
322     function changeOwner(address _recipient) public {
323         require(msg.sender == owner);
324         owner = _recipient;
325     }
326 
327     function changeTierAdmin(address _tierAdmin) public {
328         require((msg.sender == owner) || (msg.sender == tierAdmin));
329         tierAdmin = _tierAdmin;
330     }
331 
332     function toggleReceiveEth() public {
333         require(msg.sender == owner);
334         if(receiveEth == true) {
335             receiveEth = false;
336         }
337         else receiveEth = true;
338     }
339 
340     function toggleTokenExchange() public {
341         require(msg.sender == owner);
342         if(canExchange == true) {
343             canExchange = false;
344         }
345         else canExchange = true;
346     }
347 
348     function addTierRateAndTokens(uint256 _level, uint256 _tokens, uint256 _rate) public {
349         require(((msg.sender == owner) || (msg.sender == tierAdmin)) && (addTiers == true));
350         scheduleTokens[_level] = _tokens;
351         scheduleRates[_level] = _rate;
352     }
353 
354     // not really needed as we fix the max tiers on contract creation but just for completeness' sake we'll call this
355     // when all tiers have been added to the contract (not possible to deploy with all of them)
356     function closeTierAddition() public {
357         require(msg.sender == owner);
358         addTiers = false;
359     }
360 
361 
362     function mul(uint256 a, uint256 b) internal pure returns (uint) {
363         uint c = a * b;
364         require(a == 0 || c / a == b);
365         return c;
366     }
367 
368     function div(uint256 a, uint256 b) internal pure returns (uint) {
369         // assert(b > 0); // Solidity automatically throws when dividing by 0
370         uint c = a / b;
371         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
372         return c;
373     }
374 
375     function sub(uint256 a, uint256 b) internal pure returns (uint) {
376         require(b <= a);
377         return a - b;
378     }
379 
380     function add(uint256 a, uint256 b) internal pure returns (uint) {
381         uint c = a + b;
382         require(c >= a);
383         return c;
384     }
385 }