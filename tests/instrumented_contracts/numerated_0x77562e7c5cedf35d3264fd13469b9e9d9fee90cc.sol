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
16     address public devFeesAddr = 0xF772464393Ac87a1b7C628bF79090e014d931A23;
17     address tierAdmin;
18 
19     uint256 public totalSupply = 100000000000000000000000;
20     uint tierLevel = 1;
21     uint fiatPerEth = 385000000000000000000000;
22     uint256 circulatingSupply = 0;
23     uint maxTier = 132;
24     uint256 public devFees = 0;
25     uint256 fees = 10000;  // the calculation expects % * 100 (so 10% is 1000)
26 
27     // flags
28     bool public receiveEth = false;
29     bool payFees = true;
30     bool distributionDone = false;
31     bool canExchange = false;
32     bool addTiers = true;
33     bool public initialTiers = false;
34 
35     // Storage
36     mapping (address => uint256) public balances;
37     mapping (address => bool) public exchangePartners;
38 
39     // mining schedule
40     mapping(uint => uint256) public scheduleTokens;
41     mapping(uint => uint256) public scheduleRates;
42 
43     // events
44     event Transfer(address indexed _from, address indexed _to, uint _value);
45 
46     function COE() {
47         owner = msg.sender;
48         doPremine();
49     }
50 
51     function doPremine() public {
52         require(msg.sender == owner);
53         require(distributionDone == false);
54         balances[owner] = add(balances[owner],32664993546427000000000);
55         Transfer(this, owner, 32664993546427000000000);
56         circulatingSupply = add(circulatingSupply, 32664993546427000000000);
57         totalSupply = sub(totalSupply,32664993546427000000000);
58         distributionDone = true;
59     }
60 
61     function populateTierTokens() public {
62         require((msg.sender == owner) && (initialTiers == false));
63         scheduleTokens[1] = 1E21;
64         scheduleTokens[2] = 9E20;
65         scheduleTokens[3] = 8E20;
66         scheduleTokens[4] = 7E20;
67         scheduleTokens[5] = 2.3E21;
68         scheduleTokens[6] = 6.5E21;
69         scheduleTokens[7] = 2E21;
70         scheduleTokens[8] = 1.2E21;
71         scheduleTokens[9] = 4.5E21;
72         scheduleTokens[10] = 7.5E19;
73         scheduleTokens[11] = 7.5E19;
74         scheduleTokens[12] = 7.5E19;
75         scheduleTokens[13] = 7.5E19;
76         scheduleTokens[14] = 7.5E19;
77         scheduleTokens[15] = 7.5E19;
78         scheduleTokens[16] = 7.5E19;
79         scheduleTokens[17] = 7.5E19;
80         scheduleTokens[18] = 5.6E21;
81         scheduleTokens[19] = 7.5E19;
82         scheduleTokens[20] = 7.5E19;
83         scheduleTokens[21] = 7.5E19;
84         scheduleTokens[22] = 7.5E19;
85         scheduleTokens[23] = 7.5E19;
86         scheduleTokens[24] = 8.2E21;
87         scheduleTokens[25] = 2.5E21;
88         scheduleTokens[26] = 1.45E22;
89         scheduleTokens[27] = 7.5E19;
90         scheduleTokens[28] = 7.5E19;
91         scheduleTokens[29] = 7.5E19;
92         scheduleTokens[30] = 7.5E19;
93         scheduleTokens[31] = 7.5E19;
94         scheduleTokens[32] = 7.5E19;
95         scheduleTokens[33] = 7.5E19;
96         scheduleTokens[34] = 7.5E19;
97         scheduleTokens[35] = 7.5E19;
98         scheduleTokens[36] = 7.5E19;
99         scheduleTokens[37] = 7.5E19;
100         scheduleTokens[38] = 7.5E19;
101         scheduleTokens[39] = 7.5E19;
102         scheduleTokens[40] = 7.5E19;
103         scheduleTokens[41] = 7.5E19;
104         scheduleTokens[42] = 7.5E19;
105         scheduleTokens[43] = 7.5E19;
106         scheduleTokens[44] = 7.5E19;
107         scheduleTokens[45] = 7.5E19;
108         scheduleTokens[46] = 7.5E19;
109         scheduleTokens[47] = 7.5E19;
110         scheduleTokens[48] = 7.5E19;
111         scheduleTokens[49] = 7.5E19;
112         scheduleTokens[50] = 7.5E19;
113     }
114 
115     function populateTierRates() public {
116         require((msg.sender == owner) && (initialTiers == false));
117         require(msg.sender == owner);
118         scheduleRates[1] = 3.85E23;
119         scheduleRates[2] = 6.1E23;
120         scheduleRates[3] = 4.15E23;
121         scheduleRates[4] = 5.92E23;
122         scheduleRates[5] = 9.47E23;
123         scheduleRates[6] = 1.1E24;
124         scheduleRates[7] = 1.123E24;
125         scheduleRates[8] = 1.115E24;
126         scheduleRates[9] = 1.135E24;
127         scheduleRates[10] = 1.013E24;
128         scheduleRates[11] = 8.48E23;
129         scheduleRates[12] = 8.17E23;
130         scheduleRates[13] = 7.3E23;
131         scheduleRates[14] = 9.8E23;
132         scheduleRates[15] = 1.007E24;
133         scheduleRates[16] = 1.45E24;
134         scheduleRates[17] = 1.242E24;
135         scheduleRates[18] = 1.383E24;
136         scheduleRates[19] = 1.442E24;
137         scheduleRates[20] = 2.048E24;
138         scheduleRates[21] = 1.358E24;
139         scheduleRates[22] = 1.245E24;
140         scheduleRates[23] = 9.94E23;
141         scheduleRates[24] = 1.14E24;
142         scheduleRates[25] = 1.253E24;
143         scheduleRates[26] = 1.29E24;
144         scheduleRates[27] = 1.126E24;
145         scheduleRates[28] = 1.173E24;
146         scheduleRates[29] = 1.074E24;
147         scheduleRates[30] = 1.127E24;
148         scheduleRates[31] = 1.223E24;
149         scheduleRates[32] = 1.145E24;
150         scheduleRates[33] = 1.199E24;
151         scheduleRates[34] = 1.319E24;
152         scheduleRates[35] = 1.312E24;
153         scheduleRates[36] = 1.287E24;
154         scheduleRates[37] = 1.175E24;
155         scheduleRates[38] = 1.175E24;
156         scheduleRates[39] = 1.146E24;
157         scheduleRates[40] = 1.098E24;
158         scheduleRates[41] = 1.058E24;
159         scheduleRates[42] = 9.97E23;
160         scheduleRates[43] = 9.32E23;
161         scheduleRates[44] = 8.44E23;
162         scheduleRates[45] = 8.33E23;
163         scheduleRates[46] = 7.8E23;
164         scheduleRates[47] = 7.67E23;
165         scheduleRates[48] = 8.37E23;
166         scheduleRates[49] = 1.011E24;
167         scheduleRates[50] = 9.79E23;
168         initialTiers = true;
169     }
170 
171     function () payable public {
172         require((msg.value > 0) && (receiveEth));
173 
174         if(payFees) {
175             devFees = add(devFees, ((msg.value * fees) / 10000));
176         }
177         allocateTokens(convertEthToCents(msg.value));
178     }
179 
180     function convertEthToCents(uint256 _incoming) internal returns (uint256) {
181         return mul(_incoming, fiatPerEth);
182     }
183 
184     function allocateTokens(uint256 _submitted) internal {
185         uint256 _availableInTier = mul(scheduleTokens[tierLevel], scheduleRates[tierLevel]);
186         uint256 _allocation = 0;
187 
188         if(_submitted >= _availableInTier) {
189             _allocation = scheduleTokens[tierLevel];
190             scheduleTokens[tierLevel] = 0;
191             tierLevel++;
192             _submitted = sub(_submitted, _availableInTier);
193         }
194         else {
195             uint256 _tokens = div(div(mul(_submitted, 1 ether), scheduleRates[tierLevel]), 1 ether);
196             _allocation = add(_allocation, _tokens);
197             scheduleTokens[tierLevel] = sub(scheduleTokens[tierLevel], _tokens);
198             _submitted = sub(_submitted, mul(_tokens, scheduleRates[tierLevel]));
199         }
200 
201         balances[msg.sender] = add(balances[msg.sender],_allocation);
202         circulatingSupply = add(circulatingSupply, _allocation);
203         totalSupply = sub(totalSupply, _allocation);
204 
205         if((_submitted != 0) && (tierLevel <= maxTier)) {
206             allocateTokens(_submitted);
207         }
208         else {
209             Transfer(this, msg.sender, balances[msg.sender]);
210         }
211     }
212 
213     function transfer(address _to, uint _value) public {
214         require(balances[msg.sender] >= _value);
215         totalSupply = add(totalSupply, _value);
216         circulatingSupply = sub(circulatingSupply, _value);
217 
218         if(_to == address(this)) {
219             // WARNING: if you transfer tokens back to the contract you will lose them
220             // use the exchange function to exchange for tokens with approved partner contracts
221             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
222             Transfer(msg.sender, _to, _value);
223         }
224         else {
225             uint codeLength;
226 
227             assembly {
228                 codeLength := extcodesize(_to)
229             }
230 
231             if(codeLength != 0) {
232                 if(canExchange == true) {
233                     if(exchangePartners[_to]) {
234                         // WARNING: exchanging COE into MNY costs more Gas than a normal transfer as we interact directly
235                         // with the MNY contract - suggest doubling the recommended gas limit
236                         exchange(_to, _value);
237                     }
238                     else {
239                         // WARNING: if you transfer to a contract that cannot handle incoming tokens you may lose them
240                         balances[msg.sender] = sub(balanceOf(msg.sender), _value);
241                         balances[_to] = add(balances[_to], _value);
242                         Transfer(msg.sender, _to, _value);
243                     }
244                 }
245             }
246             else {
247                 balances[msg.sender] = sub(balanceOf(msg.sender), _value);
248                 balances[_to] = add(balances[_to], _value);
249                 Transfer(msg.sender, _to, _value);
250             }
251         }
252     }
253 
254     function exchange(address _partner, uint _amount) internal {
255         require(exchangePartners[_partner]);
256         requestTokensFromOtherContract(_partner, this, msg.sender, _amount);
257         balances[msg.sender] = sub(balanceOf(msg.sender), _amount);
258         circulatingSupply = sub(circulatingSupply, _amount);
259         totalSupply = add(totalSupply, _amount);
260         Transfer(msg.sender, this, _amount);
261     }
262 
263     function requestTokensFromOtherContract(address _targetContract, address _sourceContract, address _recipient, uint256 _value) internal returns (bool){
264         Partner p = Partner(_targetContract);
265         p.exchangeTokensFromOtherContract(_sourceContract, _recipient, _value);
266         return true;
267     }
268 
269     function balanceOf(address _receiver) public constant returns (uint256) {
270         return balances[_receiver];
271     }
272 
273     function balanceInTier() public constant returns (uint256) {
274         return scheduleTokens[tierLevel];
275     }
276 
277     function currentTier() public constant returns (uint256) {
278         return tierLevel;
279     }
280 
281     function balanceInSpecificTier(uint256 _tier) public constant returns (uint256) {
282         return scheduleTokens[_tier];
283     }
284 
285     function rateOfSpecificTier(uint256 _tier) public constant returns (uint256) {
286         return scheduleRates[_tier];
287     }
288 
289     function setFiatPerEthRate(uint256 _newRate) public {
290         require(msg.sender == owner);
291         fiatPerEth = _newRate;
292     }
293 
294     function addExchangePartnerTargetAddress(address _partner) public {
295         require(msg.sender == owner);
296         exchangePartners[_partner] = true;
297     }
298 
299     function canContractExchange(address _contract) public constant returns (bool) {
300         return exchangePartners[_contract];
301     }
302 
303     function removeExchangePartnerTargetAddress(address _partner) public {
304         require(msg.sender == owner);
305         exchangePartners[_partner] = false;
306     }
307 
308     function withdrawDevFees() public {
309         require(payFees);
310         devFeesAddr.transfer(devFees);
311         devFees = 0;
312     }
313 
314     function changeDevFees(address _devFees) public {
315         require(msg.sender == owner);
316         devFeesAddr = _devFees;
317     }
318 
319     function payFeesToggle() public {
320         require(msg.sender == owner);
321         if(payFees) {
322             payFees = false;
323         }
324         else {
325             payFees = true;
326         }
327     }
328 
329     function safeWithdrawal(address _receiver, uint256 _value) public {
330         require(msg.sender == owner);
331         // check balance before transferring
332         withdrawDevFees();
333         require(_value <= this.balance);
334         _receiver.transfer(_value);
335     }
336 
337     // enables fee update - must be between 0 and 100 (%)
338     function updateFeeAmount(uint _newFee) public {
339         require(msg.sender == owner);
340         require((_newFee >= 0) && (_newFee <= 100));
341         fees = _newFee * 100;
342     }
343 
344     function handleTokensFromOtherContracts(address _contract, address _recipient, uint256 _tokens) {
345         require(msg.sender == owner);
346         Target t;
347         t = Target(_contract);
348         t.transfer(_recipient, _tokens);
349     }
350 
351     function changeOwner(address _recipient) public {
352         require(msg.sender == owner);
353         owner = _recipient;
354     }
355 
356     function changeTierAdmin(address _tierAdmin) public {
357         require((msg.sender == owner) || (msg.sender == tierAdmin));
358         tierAdmin = _tierAdmin;
359     }
360 
361     function toggleReceiveEth() public {
362         require(msg.sender == owner);
363         if(receiveEth == true) {
364             receiveEth = false;
365         }
366         else receiveEth = true;
367     }
368 
369     function toggleTokenExchange() public {
370         require(msg.sender == owner);
371         if(canExchange == true) {
372             canExchange = false;
373         }
374         else canExchange = true;
375     }
376 
377     function addTierRateAndTokens(uint256 _rate, uint256 _tokens, uint256 _level) public {
378         require(((msg.sender == owner) || (msg.sender == tierAdmin)) && (addTiers == true));
379         scheduleTokens[_level] = _tokens;
380         scheduleRates[_level] = _rate;
381     }
382 
383     // not really needed as we fix the max tiers on contract creation but just for completeness' sake
384     function closeTierAddition() public {
385         require(msg.sender == owner);
386         addTiers = false;
387     }
388 
389 
390     function mul(uint a, uint b) internal pure returns (uint) {
391         uint c = a * b;
392         require(a == 0 || c / a == b);
393         return c;
394     }
395 
396     function div(uint a, uint b) internal pure returns (uint) {
397         // assert(b > 0); // Solidity automatically throws when dividing by 0
398         uint c = a / b;
399         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
400         return c;
401     }
402 
403     function sub(uint a, uint b) internal pure returns (uint) {
404         require(b <= a);
405         return a - b;
406     }
407 
408     function add(uint a, uint b) internal pure returns (uint) {
409         uint c = a + b;
410         require(c >= a);
411         return c;
412     }
413 }