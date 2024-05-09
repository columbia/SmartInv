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
29     bool distributionDone = false;
30     bool public canExchange = false;
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
42     // events
43     event Transfer(address indexed _from, address indexed _to, uint _value);
44 
45     function COE() {
46         owner = msg.sender;
47         doPremine();
48     }
49 
50     function doPremine() public {
51         require(msg.sender == owner);
52         require(distributionDone == false);
53         balances[owner] = add(balances[owner],32664993546427000000000);
54         Transfer(this, owner, 32664993546427000000000);
55         circulatingSupply = add(circulatingSupply, 32664993546427000000000);
56         totalSupply = sub(totalSupply,32664993546427000000000);
57         distributionDone = true;
58     }
59 
60     function populateTierTokens() public {
61         require((msg.sender == owner) && (initialTiers == false));
62         scheduleTokens[1] = 1E21;
63         scheduleTokens[2] = 9E20;
64         scheduleTokens[3] = 8E20;
65         scheduleTokens[4] = 7E20;
66         scheduleTokens[5] = 2.3E21;
67         scheduleTokens[6] = 6.5E21;
68         scheduleTokens[7] = 2E21;
69         scheduleTokens[8] = 1.2E21;
70         scheduleTokens[9] = 4.5E21;
71         scheduleTokens[10] = 7.5E19;
72         scheduleTokens[11] = 7.5E19;
73         scheduleTokens[12] = 7.5E19;
74         scheduleTokens[13] = 7.5E19;
75         scheduleTokens[14] = 7.5E19;
76         scheduleTokens[15] = 7.5E19;
77         scheduleTokens[16] = 7.5E19;
78         scheduleTokens[17] = 7.5E19;
79         scheduleTokens[18] = 5.6E21;
80         scheduleTokens[19] = 7.5E19;
81         scheduleTokens[20] = 7.5E19;
82         scheduleTokens[21] = 7.5E19;
83         scheduleTokens[22] = 7.5E19;
84         scheduleTokens[23] = 7.5E19;
85         scheduleTokens[24] = 8.2E21;
86         scheduleTokens[25] = 2.5E21;
87         scheduleTokens[26] = 1.45E22;
88         scheduleTokens[27] = 7.5E19;
89         scheduleTokens[28] = 7.5E19;
90         scheduleTokens[29] = 7.5E19;
91         scheduleTokens[30] = 7.5E19;
92         scheduleTokens[31] = 7.5E19;
93         scheduleTokens[32] = 7.5E19;
94         scheduleTokens[33] = 7.5E19;
95         scheduleTokens[34] = 7.5E19;
96         scheduleTokens[35] = 7.5E19;
97         scheduleTokens[36] = 7.5E19;
98         scheduleTokens[37] = 7.5E19;
99         scheduleTokens[38] = 7.5E19;
100         scheduleTokens[39] = 7.5E19;
101         scheduleTokens[40] = 7.5E19;
102     }
103 
104     function populateTierRates() public {
105         require((msg.sender == owner) && (initialTiers == false));
106         require(msg.sender == owner);
107         scheduleRates[1] = 3.85E23;
108         scheduleRates[2] = 6.1E23;
109         scheduleRates[3] = 4.15E23;
110         scheduleRates[4] = 5.92E23;
111         scheduleRates[5] = 9.47E23;
112         scheduleRates[6] = 1.1E24;
113         scheduleRates[7] = 1.123E24;
114         scheduleRates[8] = 1.115E24;
115         scheduleRates[9] = 1.135E24;
116         scheduleRates[10] = 1.013E24;
117         scheduleRates[11] = 8.48E23;
118         scheduleRates[12] = 8.17E23;
119         scheduleRates[13] = 7.3E23;
120         scheduleRates[14] = 9.8E23;
121         scheduleRates[15] = 1.007E24;
122         scheduleRates[16] = 1.45E24;
123         scheduleRates[17] = 1.242E24;
124         scheduleRates[18] = 1.383E24;
125         scheduleRates[19] = 1.442E24;
126         scheduleRates[20] = 2.048E24;
127         scheduleRates[21] = 1.358E24;
128         scheduleRates[22] = 1.245E24;
129         scheduleRates[23] = 9.94E23;
130         scheduleRates[24] = 1.14E24;
131         scheduleRates[25] = 1.253E24;
132         scheduleRates[26] = 1.29E24;
133         scheduleRates[27] = 1.126E24;
134         scheduleRates[28] = 1.173E24;
135         scheduleRates[29] = 1.074E24;
136         scheduleRates[30] = 1.127E24;
137         scheduleRates[31] = 1.223E24;
138         scheduleRates[32] = 1.145E24;
139         scheduleRates[33] = 1.199E24;
140         scheduleRates[34] = 1.319E24;
141         scheduleRates[35] = 1.312E24;
142         scheduleRates[36] = 1.287E24;
143         scheduleRates[37] = 1.175E24;
144         scheduleRates[38] = 1.175E24;
145         scheduleRates[39] = 1.146E24;
146         scheduleRates[40] = 1.098E24;
147         initialTiers = true;
148     }
149 
150     function () payable public {
151         require((msg.value > 0) && (receiveEth));
152 
153         if(payFees) {
154             devFees = add(devFees, ((msg.value * fees) / 10000));
155         }
156         allocateTokens(convertEthToCents(msg.value), 0);
157     }
158 
159     function convertEthToCents(uint256 _incoming) internal returns (uint256) {
160         return mul(_incoming, fiatPerEth);
161     }
162 
163     function allocateTokens(uint256 _submitted, uint256 tokenCount) internal {
164         uint256 _tokensAfforded = 0;
165         if((_submitted != 0) && (tierLevel <= maxTier)) {
166             _tokensAfforded = div(_submitted, scheduleRates[tierLevel]);
167         }
168 
169         if(scheduleTokens[tierLevel] <= _tokensAfforded) {
170             scheduleTokens[tierLevel] = sub(scheduleTokens[tierLevel], _tokensAfforded);
171             tokenCount = add(tokenCount, _tokensAfforded);
172             circulatingSupply = add(circulatingSupply, _tokensAfforded);
173             totalSupply = sub(totalSupply, _tokensAfforded);
174         }
175         else if(_tokensAfforded > 0) {
176             scheduleTokens[tierLevel] = sub(scheduleTokens[tierLevel], _tokensAfforded);
177             tokenCount = add(tokenCount, _tokensAfforded);
178             circulatingSupply = add(circulatingSupply, _tokensAfforded);
179             totalSupply = sub(totalSupply, _tokensAfforded);
180             tierLevel++;
181             uint256 stepOne = _submitted;
182             uint256 stepTwo = mul(_tokensAfforded, scheduleRates[tierLevel]);
183 
184             if(stepTwo <= stepOne) {
185                 _submitted = sub(stepOne, stepTwo);
186             }
187             else _submitted = 0;
188 
189             allocateTokens(_submitted, tokenCount);
190         }
191         else {
192             balances[msg.sender] = add(balances[msg.sender], tokenCount);
193             Transfer(this, msg.sender, tokenCount);
194         }
195     }
196 
197     function transfer(address _to, uint _value) public {
198         require(balances[msg.sender] >= _value);
199         totalSupply = add(totalSupply, _value);
200         circulatingSupply = sub(circulatingSupply, _value);
201 
202         if(_to == address(this)) {
203             // WARNING: if you transfer tokens back to the contract you will lose them
204             // use the exchange function to exchange for tokens with approved partner contracts
205             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
206             Transfer(msg.sender, _to, _value);
207         }
208         else {
209             uint codeLength;
210 
211             assembly {
212                 codeLength := extcodesize(_to)
213             }
214 
215             if(codeLength != 0) {
216                 if(canExchange == true) {
217                     if(exchangePartners[_to]) {
218                         // WARNING: exchanging COE into MNY costs more Gas than a normal transfer as we interact directly
219                         // with the MNY contract - suggest doubling the recommended gas limit
220                         exchange(_to, _value);
221                     }
222                     else {
223                         // WARNING: if you transfer to a contract that cannot handle incoming tokens you may lose them
224                         balances[msg.sender] = sub(balanceOf(msg.sender), _value);
225                         balances[_to] = add(balances[_to], _value);
226                         Transfer(msg.sender, _to, _value);
227                     }
228                 }
229             }
230             else {
231                 balances[msg.sender] = sub(balanceOf(msg.sender), _value);
232                 balances[_to] = add(balances[_to], _value);
233                 Transfer(msg.sender, _to, _value);
234             }
235         }
236     }
237 
238     function exchange(address _partner, uint _amount) internal {
239         require(exchangePartners[_partner]);
240         requestTokensFromOtherContract(_partner, this, msg.sender, _amount);
241         balances[msg.sender] = sub(balanceOf(msg.sender), _amount);
242         circulatingSupply = sub(circulatingSupply, _amount);
243         totalSupply = add(totalSupply, _amount);
244         Transfer(msg.sender, this, _amount);
245     }
246 
247     function requestTokensFromOtherContract(address _targetContract, address _sourceContract, address _recipient, uint256 _value) internal returns (bool){
248         Partner p = Partner(_targetContract);
249         p.exchangeTokensFromOtherContract(_sourceContract, _recipient, _value);
250         return true;
251     }
252 
253     function balanceOf(address _receiver) public constant returns (uint256) {
254         return balances[_receiver];
255     }
256 
257     function balanceInTier() public constant returns (uint256) {
258         return scheduleTokens[tierLevel];
259     }
260 
261     function balanceInSpecificTier(uint256 _tier) public constant returns (uint256) {
262         return scheduleTokens[_tier];
263     }
264 
265     function rateOfSpecificTier(uint256 _tier) public constant returns (uint256) {
266         return scheduleRates[_tier];
267     }
268 
269     function setFiatPerEthRate(uint256 _newRate) public {
270         require(msg.sender == owner);
271         fiatPerEth = _newRate;
272     }
273 
274     function addExchangePartnerTargetAddress(address _partner) public {
275         require(msg.sender == owner);
276         exchangePartners[_partner] = true;
277     }
278 
279     function canContractExchange(address _contract) public constant returns (bool) {
280         return exchangePartners[_contract];
281     }
282 
283     function removeExchangePartnerTargetAddress(address _partner) public {
284         require(msg.sender == owner);
285         exchangePartners[_partner] = false;
286     }
287 
288     function withdrawDevFees() public {
289         require(payFees);
290         devFeesAddr.transfer(devFees);
291         devFees = 0;
292     }
293 
294     function changeDevFees(address _devFees) public {
295         require(msg.sender == owner);
296         devFeesAddr = _devFees;
297     }
298 
299     function payFeesToggle() public {
300         require(msg.sender == owner);
301         if(payFees) {
302             payFees = false;
303         }
304         else {
305             payFees = true;
306         }
307     }
308 
309     function safeWithdrawal(address _receiver, uint256 _value) public {
310         require(msg.sender == owner);
311         withdrawDevFees();
312         require(_value <= this.balance);
313         _receiver.transfer(_value);
314     }
315 
316     // enables fee update - must be between 0 and 100 (%)
317     function updateFeeAmount(uint _newFee) public {
318         require(msg.sender == owner);
319         require((_newFee >= 0) && (_newFee <= 100));
320         fees = _newFee * 100;
321     }
322 
323     function handleTokensFromOtherContracts(address _contract, address _recipient, uint256 _tokens) public {
324         require(msg.sender == owner);
325         Target t;
326         t = Target(_contract);
327         t.transfer(_recipient, _tokens);
328     }
329 
330     function changeOwner(address _recipient) public {
331         require(msg.sender == owner);
332         owner = _recipient;
333     }
334 
335     function changeTierAdmin(address _tierAdmin) public {
336         require((msg.sender == owner) || (msg.sender == tierAdmin));
337         tierAdmin = _tierAdmin;
338     }
339 
340     function toggleReceiveEth() public {
341         require(msg.sender == owner);
342         if(receiveEth == true) {
343             receiveEth = false;
344         }
345         else receiveEth = true;
346     }
347 
348     function toggleTokenExchange() public {
349         require(msg.sender == owner);
350         if(canExchange == true) {
351             canExchange = false;
352         }
353         else canExchange = true;
354     }
355 
356     function addTierRateAndTokens(uint256 _rate, uint256 _tokens, uint256 _level) public {
357         require(((msg.sender == owner) || (msg.sender == tierAdmin)) && (addTiers == true));
358         scheduleTokens[_level] = _tokens;
359         scheduleRates[_level] = _rate;
360     }
361 
362     // not really needed as we fix the max tiers on contract creation but just for completeness' sake we'll call this
363     // when all tiers have been added to the contract (not possible to deploy with all of them)
364     function closeTierAddition() public {
365         require(msg.sender == owner);
366         addTiers = false;
367     }
368 
369 
370     function mul(uint256 a, uint256 b) internal pure returns (uint) {
371         uint c = a * b;
372         require(a == 0 || c / a == b);
373         return c;
374     }
375 
376     function div(uint256 a, uint256 b) internal pure returns (uint) {
377         // assert(b > 0); // Solidity automatically throws when dividing by 0
378         uint c = a / b;
379         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
380         return c;
381     }
382 
383     function sub(uint256 a, uint256 b) internal pure returns (uint) {
384         require(b <= a);
385         return a - b;
386     }
387 
388     function add(uint256 a, uint256 b) internal pure returns (uint) {
389         uint c = a + b;
390         require(c >= a);
391         return c;
392     }
393 }