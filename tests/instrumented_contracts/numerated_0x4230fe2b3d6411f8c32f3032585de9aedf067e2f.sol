1 contract Partner {
2     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens);
3 }
4 
5 contract Target {
6     function transfer(address _to, uint _value);
7 }
8 
9 contract COE {
10 
11     string public name = "Coeval by Monkey Capital";
12     uint8 public decimals = 18;
13     string public symbol = "COE";
14 
15     address public owner;
16     address public devFeesAddr = 0x36Bdc3B60dC5491fbc7d74a05709E94d5b554321;
17     address tierAdmin;
18 
19     uint256 public totalSupply = 100000000000000000000000;
20     uint public tierLevel = 1;
21     uint256 public fiatPerEth = 58332000000000000000000;
22     uint256 public circulatingSupply = 0;
23     uint maxTier = 132;
24     uint256 public devFees = 0;
25     uint256 fees = 10000;  // the calculation expects % * 100 (so 10% is 1000)
26 
27     bool public receiveEth = false;
28     bool payFees = true;
29     bool public canExchange = false;
30     bool addTiers = true;
31     bool public initialTiers = false;
32 
33     // Storage
34     mapping (address => uint256) public balances;
35     mapping (address => bool) public exchangePartners;
36 
37     // mining schedule
38     mapping(uint => uint256) public scheduleTokens;
39     mapping(uint => uint256) public scheduleRates;
40 
41     // events
42     event Transfer(address indexed _from, address indexed _to, uint _value);
43 
44     function COE() {
45         owner = msg.sender;
46         doPremine();
47     }
48 
49     function doPremine() internal {
50         require(msg.sender == owner);
51         balances[owner] = add(balances[owner],32664993546427000000000);
52         Transfer(this, owner, 32664993546427000000000);
53         circulatingSupply = add(circulatingSupply, 32664993546427000000000);
54         totalSupply = sub(totalSupply,32664993546427000000000);
55     }
56 
57     function populateTierTokens() public {
58         require((msg.sender == owner) && (initialTiers == false));
59         scheduleTokens[1] = 1E21;
60         scheduleTokens[2] = 9E20;
61         scheduleTokens[3] = 8E20;
62         scheduleTokens[4] = 7E20;
63         scheduleTokens[5] = 2.3E21;
64         scheduleTokens[6] = 6.5E21;
65         scheduleTokens[7] = 2E21;
66         scheduleTokens[8] = 1.2E21;
67         scheduleTokens[9] = 4.5E21;
68         scheduleTokens[10] = 7.5E19;
69         scheduleTokens[11] = 7.5E19;
70         scheduleTokens[12] = 7.5E19;
71         scheduleTokens[13] = 7.5E19;
72         scheduleTokens[14] = 7.5E19;
73         scheduleTokens[15] = 7.5E19;
74         scheduleTokens[16] = 7.5E19;
75         scheduleTokens[17] = 7.5E19;
76         scheduleTokens[18] = 5.6E21;
77         scheduleTokens[19] = 7.5E19;
78         scheduleTokens[20] = 7.5E19;
79         scheduleTokens[21] = 7.5E19;
80         scheduleTokens[22] = 7.5E19;
81         scheduleTokens[23] = 7.5E19;
82         scheduleTokens[24] = 8.2E21;
83         scheduleTokens[25] = 2.5E21;
84         scheduleTokens[26] = 1.45E22;
85         scheduleTokens[27] = 7.5E19;
86         scheduleTokens[28] = 7.5E19;
87         scheduleTokens[29] = 7.5E19;
88         scheduleTokens[30] = 7.5E19;
89         scheduleTokens[31] = 7.5E19;
90         scheduleTokens[32] = 7.5E19;
91         scheduleTokens[33] = 7.5E19;
92         scheduleTokens[34] = 7.5E19;
93         scheduleTokens[35] = 7.5E19;
94         scheduleTokens[36] = 7.5E19;
95         scheduleTokens[37] = 7.5E19;
96         scheduleTokens[38] = 7.5E19;
97         scheduleTokens[39] = 7.5E19;
98         scheduleTokens[40] = 7.5E19;
99         scheduleTokens[41] = 7.5E19;
100         scheduleTokens[42] = 7.5E19;
101         scheduleTokens[43] = 7.5E19;
102         scheduleTokens[44] = 7.5E19;
103         scheduleTokens[45] = 7.5E19;
104         scheduleTokens[46] = 7.5E19;
105         scheduleTokens[47] = 7.5E19;
106         scheduleTokens[48] = 7.5E19;
107         scheduleTokens[49] = 7.5E19;
108         scheduleTokens[50] = 7.5E19;
109     }
110 
111     function populateTierRates() public {
112         require((msg.sender == owner) && (initialTiers == false));
113         require(msg.sender == owner);
114         scheduleRates[1] = 3.85E23;
115         scheduleRates[2] = 6.1E23;
116         scheduleRates[3] = 4.15E23;
117         scheduleRates[4] = 5.92E23;
118         scheduleRates[5] = 9.47E23;
119         scheduleRates[6] = 1.1E24;
120         scheduleRates[7] = 1.123E24;
121         scheduleRates[8] = 1.115E24;
122         scheduleRates[9] = 1.135E24;
123         scheduleRates[10] = 1.013E24;
124         scheduleRates[11] = 8.48E23;
125         scheduleRates[12] = 8.17E23;
126         scheduleRates[13] = 7.3E23;
127         scheduleRates[14] = 9.8E23;
128         scheduleRates[15] = 1.007E24;
129         scheduleRates[16] = 1.45E24;
130         scheduleRates[17] = 1.242E24;
131         scheduleRates[18] = 1.383E24;
132         scheduleRates[19] = 1.442E24;
133         scheduleRates[20] = 2.048E24;
134         scheduleRates[21] = 1.358E24;
135         scheduleRates[22] = 1.245E24;
136         scheduleRates[23] = 9.94E23;
137         scheduleRates[24] = 1.14E24;
138         scheduleRates[25] = 1.253E24;
139         scheduleRates[26] = 1.29E24;
140         scheduleRates[27] = 1.126E24;
141         scheduleRates[28] = 1.173E24;
142         scheduleRates[29] = 1.074E24;
143         scheduleRates[30] = 1.127E24;
144         scheduleRates[31] = 1.223E24;
145         scheduleRates[32] = 1.145E24;
146         scheduleRates[33] = 1.199E24;
147         scheduleRates[34] = 1.319E24;
148         scheduleRates[35] = 1.312E24;
149         scheduleRates[36] = 1.287E24;
150         scheduleRates[37] = 1.175E24;
151         scheduleRates[38] = 1.175E24;
152         scheduleRates[39] = 1.146E24;
153         scheduleRates[40] = 1.098E24;
154         scheduleRates[41] = 1.058E24;
155         scheduleRates[42] = 9.97E23;
156         scheduleRates[43] = 9.32E23;
157         scheduleRates[44] = 8.44E23;
158         scheduleRates[45] = 8.33E23;
159         scheduleRates[46] = 7.8E23;
160         scheduleRates[47] = 7.67E23;
161         scheduleRates[48] = 8.37E23;
162         scheduleRates[49] = 1.011E24;
163         scheduleRates[50] = 9.79E23;
164         initialTiers = true;
165     }
166 
167     function () payable public {
168         require((msg.value > 0) && (receiveEth));
169 
170         if(payFees) {
171             devFees = add(devFees, ((msg.value * fees) / 10000));
172         }
173         allocateTokens(convertEthToCents(msg.value), 0);
174     }
175 
176     function convertEthToCents(uint256 _incoming) internal returns (uint256) {
177         return mul(_incoming, fiatPerEth);
178     }
179 
180     function allocateTokens(uint256 _submitted, uint256 tokenCount) internal {
181         uint256 _tokensAfforded = 0;
182         if((_submitted != 0) && (tierLevel <= maxTier)) {
183             _tokensAfforded = div(_submitted, scheduleRates[tierLevel]);
184         }
185 
186         if(scheduleTokens[tierLevel] <= _tokensAfforded) {
187             scheduleTokens[tierLevel] = sub(scheduleTokens[tierLevel], _tokensAfforded);
188             tokenCount = add(tokenCount, _tokensAfforded);
189             circulatingSupply = add(circulatingSupply, _tokensAfforded);
190             totalSupply = sub(totalSupply, _tokensAfforded);
191         }
192         else if(_tokensAfforded > 0) {
193             scheduleTokens[tierLevel] = sub(scheduleTokens[tierLevel], _tokensAfforded);
194             tokenCount = add(tokenCount, _tokensAfforded);
195             circulatingSupply = add(circulatingSupply, _tokensAfforded);
196             totalSupply = sub(totalSupply, _tokensAfforded);
197             tierLevel++;
198             uint256 stepOne = _submitted;
199             uint256 stepTwo = mul(_tokensAfforded, scheduleRates[tierLevel]);
200 
201             if(stepTwo <= stepOne) {
202                 _submitted = sub(stepOne, stepTwo);
203             }
204             else _submitted = 0;
205 
206             allocateTokens(_submitted, tokenCount);
207         }
208         else {
209             balances[msg.sender] = add(balances[msg.sender], tokenCount);
210             Transfer(this, msg.sender, tokenCount);
211         }
212     }
213 
214     function transfer(address _to, uint _value) public {
215         require(balances[msg.sender] >= _value);
216 
217         if(_to == address(this)) {
218             // WARNING: if you transfer tokens back to the contract you will lose them
219             // use the exchange function to exchange for tokens with approved partner contracts
220             balances[msg.sender] = sub(balances[msg.sender], _value);
221             Transfer(msg.sender, _to, _value);
222         }
223         else {
224             uint codeLength;
225 
226             assembly {
227                 codeLength := extcodesize(_to)
228             }
229 
230             if(codeLength != 0) {
231                 if(canExchange == true) {
232                     if(exchangePartners[_to]) {
233                         // WARNING: exchanging COE into MNY costs more Gas than a normal transfer as we interact directly
234                         // with the MNY contract - suggest doubling the recommended gas limit
235                         exchange(_to, _value);
236                     }
237                     else {
238                         // WARNING: if you transfer to a contract that cannot handle incoming tokens you may lose them
239                         balances[msg.sender] = sub(balances[msg.sender], _value);
240                         balances[_to] = add(balances[_to], _value);
241                         Transfer(msg.sender, _to, _value);
242                     }
243                 }
244             }
245             else {
246                 balances[msg.sender] = sub(balances[msg.sender], _value);
247                 balances[_to] = add(balances[_to], _value);
248                 Transfer(msg.sender, _to, _value);
249             }
250         }
251     }
252 
253     function exchange(address _partner, uint _amount) internal {
254         require(exchangePartners[_partner]);
255         requestTokensFromOtherContract(_partner, this, msg.sender, _amount);
256         balances[msg.sender] = sub(balanceOf(msg.sender), _amount);
257         circulatingSupply = sub(circulatingSupply, _amount);
258         totalSupply = add(totalSupply, _amount);
259         Transfer(msg.sender, this, _amount);
260     }
261 
262     function requestTokensFromOtherContract(address _targetContract, address _sourceContract, address _recipient, uint256 _value) internal returns (bool){
263         Partner p = Partner(_targetContract);
264         p.exchangeTokensFromOtherContract(_sourceContract, _recipient, _value);
265         return true;
266     }
267 
268     function balanceOf(address _receiver) public constant returns (uint256) {
269         return balances[_receiver];
270     }
271 
272     function balanceInTier() public constant returns (uint256) {
273         return scheduleTokens[tierLevel];
274     }
275 
276     function balanceInSpecificTier(uint256 _tier) public constant returns (uint256) {
277         return scheduleTokens[_tier];
278     }
279 
280     function rateOfSpecificTier(uint256 _tier) public constant returns (uint256) {
281         return scheduleRates[_tier];
282     }
283 
284     function setFiatPerEthRate(uint256 _newRate) public {
285         require(msg.sender == owner);
286         fiatPerEth = _newRate;
287     }
288 
289     function addExchangePartnerTargetAddress(address _partner) public {
290         require(msg.sender == owner);
291         exchangePartners[_partner] = true;
292     }
293 
294     function canContractExchange(address _contract) public constant returns (bool) {
295         return exchangePartners[_contract];
296     }
297 
298     function removeExchangePartnerTargetAddress(address _partner) public {
299         require(msg.sender == owner);
300         exchangePartners[_partner] = false;
301     }
302 
303     function withdrawDevFees() public {
304         require(payFees);
305         devFeesAddr.transfer(devFees);
306         devFees = 0;
307     }
308 
309     function changeDevFees(address _devFees) public {
310         require(msg.sender == owner);
311         devFeesAddr = _devFees;
312     }
313 
314     function payFeesToggle() public {
315         require(msg.sender == owner);
316         if(payFees) {
317             payFees = false;
318         }
319         else {
320             payFees = true;
321         }
322     }
323 
324     function safeWithdrawal(address _receiver, uint256 _value) public {
325         require(msg.sender == owner);
326         withdrawDevFees();
327         require(_value <= this.balance);
328         _receiver.transfer(_value);
329     }
330 
331     // enables fee update - must be between 0 and 100 (%)
332     function updateFeeAmount(uint _newFee) public {
333         require(msg.sender == owner);
334         require((_newFee >= 0) && (_newFee <= 100));
335         fees = _newFee * 100;
336     }
337 
338     function handleTokensFromOtherContracts(address _contract, address _recipient, uint256 _tokens) public {
339         require(msg.sender == owner);
340         Target t;
341         t = Target(_contract);
342         t.transfer(_recipient, _tokens);
343     }
344 
345     function changeOwner(address _recipient) public {
346         require(msg.sender == owner);
347         owner = _recipient;
348     }
349 
350     function changeTierAdmin(address _tierAdmin) public {
351         require((msg.sender == owner) || (msg.sender == tierAdmin));
352         tierAdmin = _tierAdmin;
353     }
354 
355     function toggleReceiveEth() public {
356         require(msg.sender == owner);
357         if(receiveEth == true) {
358             receiveEth = false;
359         }
360         else receiveEth = true;
361     }
362 
363     function toggleTokenExchange() public {
364         require(msg.sender == owner);
365         if(canExchange == true) {
366             canExchange = false;
367         }
368         else canExchange = true;
369     }
370 
371     function addTierRateAndTokens(uint256 _rate, uint256 _tokens, uint256 _level) public {
372         require(((msg.sender == owner) || (msg.sender == tierAdmin)) && (addTiers == true));
373         scheduleTokens[_level] = _tokens;
374         scheduleRates[_level] = _rate;
375     }
376 
377     // not really needed as we fix the max tiers on contract creation but just for completeness' sake we'll call this
378     // when all tiers have been added to the contract (not possible to deploy with all of them)
379     function closeTierAddition() public {
380         require(msg.sender == owner);
381         addTiers = false;
382     }
383 
384 
385     function mul(uint256 a, uint256 b) internal pure returns (uint) {
386         uint c = a * b;
387         require(a == 0 || c / a == b);
388         return c;
389     }
390 
391     function div(uint256 a, uint256 b) internal pure returns (uint) {
392         // assert(b > 0); // Solidity automatically throws when dividing by 0
393         uint c = a / b;
394         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
395         return c;
396     }
397 
398     function sub(uint256 a, uint256 b) internal pure returns (uint) {
399         require(b <= a);
400         return a - b;
401     }
402 
403     function add(uint256 a, uint256 b) internal pure returns (uint) {
404         uint c = a + b;
405         require(c >= a);
406         return c;
407     }
408 }