1 pragma solidity ^0.4.21;
2 
3 contract Partner {
4     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens);
5 }
6 
7 contract Target {
8     function transfer(address _to, uint _value);
9 }
10 
11 contract MNY {
12 
13     string public name = "MNY by Monkey Capital";
14     uint8 public decimals = 18;
15     string public symbol = "MNY";
16 
17     address public owner;
18     address public exchangeAdmin;
19 
20     // used to store list of contracts MNY holds tokens in
21     mapping(uint256 => address) public exchangePartners;
22     mapping(address => uint256) public exchangeRates;
23 
24     uint tierLevel = 1;
25     uint maxTier = 30;
26     uint256 totalSupply = 1.698846726062230000E25;
27 
28     uint256 public mineableTokens = totalSupply;
29     uint256 public swappedTokens = 0;
30     uint256 circulatingSupply = 0;
31     uint contractCount = 0;
32 
33     // flags
34     bool swap = false;
35     bool distributionCalculated = false;
36     bool public initialTiers = false;
37     bool addTiers = true;
38 
39     // Storage
40     mapping (address => uint256) public balances;
41     mapping (address => uint256) public tokenBalances;
42     mapping (address => uint256) public tokenShare;
43 
44     // erc20 compliance
45     mapping (address => mapping (address => uint256)) allowed;
46 
47     // mining schedule
48     mapping(uint => uint256) public scheduleTokens;
49     mapping(uint => uint256) public scheduleRates;
50 
51     uint256 swapEndTime;
52 
53     // events (ERC20)
54     event Transfer(address indexed _from, address indexed _to, uint256 _value);
55     event Approval(address indexed _owner, address indexed _spender, uint _value);
56 
57     // events (custom)
58     event TokensExchanged(address indexed _sendingWallet, address indexed _sendingContract, uint256 _tokensIn);
59 
60     function MNY() {
61         owner = msg.sender;
62     }
63 
64     // tier pop
65     function populateTierTokens() public {
66         require((msg.sender == owner) && (initialTiers == false));
67         scheduleTokens[1] = 5.33696E18;
68         scheduleTokens[2] = 7.69493333E18;
69         scheduleTokens[3] = 4.75684324E18;
70         scheduleTokens[4] = 6.30846753E18;
71         scheduleTokens[5] = 6.21620513E18;
72         scheduleTokens[6] = 5.63157219E18;
73         scheduleTokens[7] = 5.80023669E18;
74         scheduleTokens[8] = 5.04458667E18;
75         scheduleTokens[9] = 4.58042767E18;
76         scheduleTokens[10] = 5E18;
77         scheduleTokens[11] = 5.59421053E18;
78         scheduleTokens[12] = 7.05050888E18;
79         scheduleTokens[13] = 1.93149011E19;
80         scheduleTokens[14] = 5.71055924E18;
81         scheduleTokens[15] = 1.087367665E19;
82         scheduleTokens[16] = 5.4685283E18;
83         scheduleTokens[17] = 7.58236145E18;
84         scheduleTokens[18] = 5.80773184E18;
85         scheduleTokens[19] = 4.74868639E18;
86         scheduleTokens[20] = 6.74810256E18;
87         scheduleTokens[21] = 5.52847682E18;
88         scheduleTokens[22] = 4.96611055E18;
89         scheduleTokens[23] = 5.45818182E18;
90         scheduleTokens[24] = 8.0597095E18;
91         scheduleTokens[25] = 1.459911381E19;
92         scheduleTokens[26] = 8.32598844E18;
93         scheduleTokens[27] = 4.555277509E19;
94         scheduleTokens[28] = 1.395674359E19;
95         scheduleTokens[29] = 9.78908515E18;
96         scheduleTokens[30] = 1.169045087E19;
97     }
98 
99     function populateTierRates() public {
100         require((msg.sender == owner) && (initialTiers == false));
101         scheduleRates[1] = 9E18;
102         scheduleRates[2] = 9E18;
103         scheduleRates[3] = 8E18;
104         scheduleRates[4] = 7E18;
105         scheduleRates[5] = 8E18;
106         scheduleRates[6] = 5E18;
107         scheduleRates[7] = 6E18;
108         scheduleRates[8] = 5E18;
109         scheduleRates[9] = 5E18;
110         scheduleRates[10] = 6E18;
111         scheduleRates[11] = 6E18;
112         scheduleRates[12] = 6E18;
113         scheduleRates[13] = 7E18;
114         scheduleRates[14] = 6E18;
115         scheduleRates[15] = 7E18;
116         scheduleRates[16] = 6E18;
117         scheduleRates[17] = 6E18;
118         scheduleRates[18] = 6E18;
119         scheduleRates[19] = 6E18;
120         scheduleRates[20] = 6E18;
121         scheduleRates[21] = 6E18;
122         scheduleRates[22] = 6E18;
123         scheduleRates[23] = 6E18;
124         scheduleRates[24] = 7E18;
125         scheduleRates[25] = 7E18;
126         scheduleRates[26] = 7E18;
127         scheduleRates[27] = 7E18;
128         scheduleRates[28] = 6E18;
129         scheduleRates[29] = 7E18;
130         scheduleRates[30] = 7E18;
131         initialTiers = true;
132     }
133     // eof tier pop
134 
135     function transfer(address _to, uint256 _value, bytes _data) public {
136         // sender must have enough tokens to transfer
137         require(balances[msg.sender] >= _value);
138 
139         if(_to == address(this)) {
140             if(swap == false) {
141                 // WARNING: if you transfer tokens back to the contract outside of the swap you will lose them
142                 // use the exchange function to exchange for tokens with approved partner contracts
143                 mineableTokens = add(mineableTokens, _value);
144                 circulatingSupply = sub(circulatingSupply, _value);
145                 if(circulatingSupply == 0) {
146                     swap = true;
147                     swapEndTime = now + 90 days;
148                 }
149                 scheduleTokens[maxTier] = add(scheduleTokens[maxTier], _value);
150                 balances[msg.sender] = sub(balanceOf(msg.sender), _value);
151                 Transfer(msg.sender, _to, _value);
152             }
153             else {
154                 if(distributionCalculated = false) {
155                     calculateHeldTokenDistribution();
156                 }
157                 swappedTokens = add(swappedTokens, _value);
158                 balances[msg.sender] = sub(balances[msg.sender], _value);
159                 shareStoredTokens(msg.sender, _value);
160             }
161         }
162         else {
163             // WARNING: if you transfer tokens to a contract address they will be lost unless the contract
164             // has been designed to handle incoming/holding tokens in other contracts
165             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
166             balances[_to] = add(balances[_to], _value);
167             Transfer(msg.sender, _to, _value);
168         }
169     }
170 
171     function allocateTokens(uint256 _submitted, uint256 _tokenCount, address _recipient) internal {
172         uint256 _tokensAfforded = 0;
173 
174         if(tierLevel <= maxTier) {
175             _tokensAfforded = div(_submitted, scheduleRates[tierLevel]);
176         }
177 
178         if(_tokensAfforded >= scheduleTokens[tierLevel]) {
179             _submitted = sub(_submitted, mul(scheduleTokens[tierLevel], scheduleRates[tierLevel]));
180             _tokenCount = add(_tokenCount, scheduleTokens[tierLevel]);
181             circulatingSupply = add(circulatingSupply, _tokensAfforded);
182             mineableTokens = sub(mineableTokens, _tokensAfforded);
183             scheduleTokens[tierLevel] = 0;
184             tierLevel++;
185             allocateTokens(_submitted, _tokenCount, _recipient);
186         }
187         else if((scheduleTokens[tierLevel] >= _tokensAfforded) && (_tokensAfforded > 0)) {
188             scheduleTokens[tierLevel] = sub(scheduleTokens[tierLevel], _tokensAfforded);
189             _tokenCount = add(_tokenCount, _tokensAfforded);
190             circulatingSupply = add(circulatingSupply, _tokensAfforded);
191             mineableTokens = sub(mineableTokens, _tokensAfforded);
192 
193             _submitted = sub(_submitted, mul(_tokensAfforded, scheduleRates[tierLevel]));
194             allocateTokens(_submitted, _tokenCount, _recipient);
195         }
196         else {
197             balances[_recipient] = add(balances[_recipient], _tokenCount);
198             Transfer(this, _recipient, _tokenCount);
199         }
200     }
201 
202     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _sentTokens) {
203         require(exchangeRates[msg.sender] > 0); // only approved contracts will satisfy this constraint
204         allocateTokens(mul(_sentTokens, exchangeRates[_source]), 0, _recipient);
205         TokensExchanged(_recipient, _source, _sentTokens);
206         maintainExternalContractTokenBalance(_source, _sentTokens);
207     }
208 
209     function addExchangePartnerAddressAndRate(address _partner, uint256 _rate) public {
210         require(msg.sender == owner);
211         // check that _partner is a contract address
212         uint codeLength;
213         assembly {
214             codeLength := extcodesize(_partner)
215         }
216         require(codeLength > 0);
217         exchangeRates[_partner] = _rate;
218 
219         bool isContract = existingContract(_partner);
220         if(isContract == false) {
221             contractCount++;
222             exchangePartners[contractCount] = _partner;
223         }
224     }
225 
226     function addTierRateAndTokens(uint256 _level, uint256 _tokens, uint256 _rate) public {
227         require(((msg.sender == owner) || (msg.sender == exchangeAdmin)) && (addTiers == true));
228         scheduleTokens[_level] = _tokens;
229         scheduleRates[_level] = _rate;
230         maxTier++;
231         if(maxTier > 2856) {
232             totalSupply = add(totalSupply, _tokens);
233         }
234     }
235 
236     function closeTierAddition() public {
237         require(msg.sender == owner);
238         addTiers = false;
239     }
240 
241     // public data retrieval funcs
242     function getTotalSupply() public constant returns (uint256) {
243         return totalSupply;
244     }
245 
246     function getMineableTokens() public constant returns (uint256) {
247         return mineableTokens;
248     }
249 
250     function getCirculatingSupply() public constant returns (uint256) {
251         return circulatingSupply;
252     }
253 
254     function balanceOf(address _receiver) public constant returns (uint256) {
255         return balances[_receiver];
256     }
257 
258     function balanceInTier() public constant returns (uint256) {
259         return scheduleTokens[tierLevel];
260     }
261 
262     function balanceInSpecificTier(uint256 _tier) public constant returns (uint256) {
263         return scheduleTokens[_tier];
264     }
265 
266     function rateInSpecificTier(uint256 _tier) public constant returns (uint256) {
267         return scheduleRates[_tier];
268     }
269 
270     function currentTier() public constant returns (uint256) {
271         return tierLevel;
272     }
273 
274     // NB: we use this to manually process tokens sent in from contracts not able to interact direct with MNY
275     function convertTransferredTokensToMny(uint256 _value, address _recipient, address _source, uint256 _originalTokenAmount) public {
276         // This allows tokens transferred in for exchange to be converted to MNY and distributed
277         // NOTE: COE is able to interact directly with the MNY contract - other exchange partners cannot unless designed ot do so
278         // Please contact us at 3@dunaton.com for details on designing a contract that *can* deal directly with MNY
279         require((msg.sender == owner) || (msg.sender == exchangeAdmin));
280         require(exchangeRates[_source] > 0);
281         allocateTokens(_value, 0, _recipient);
282         maintainExternalContractTokenBalance(_source, _originalTokenAmount);
283         TokensExchanged(_recipient, _source, _originalTokenAmount);
284     }
285 
286     function changeOwner(address _newOwner) public {
287         require(msg.sender == owner);
288         owner = _newOwner;
289     }
290 
291     function changeExchangeAdmin(address _newAdmin) public {
292         require(msg.sender == owner);
293         exchangeAdmin = _newAdmin;
294     }
295 
296     function maintainExternalContractTokenBalance(address _contract, uint256 _tokens) internal {
297         tokenBalances[_contract] = add(tokenBalances[_contract], _tokens);
298     }
299 
300     function getTokenBalance(address _contract) public constant returns (uint256) {
301         return tokenBalances[_contract];
302     }
303 
304     function calculateHeldTokenDistribution() public {
305         require(swap == true);
306         for(uint256 i=0; i<contractCount; i++) {
307             tokenShare[exchangePartners[i]] = div(tokenBalances[exchangePartners[i]], totalSupply);
308         }
309         distributionCalculated = true;
310     }
311 
312     function tokenShare(address _contract) public constant returns (uint256) {
313         return tokenShare[_contract];
314     }
315 
316     function shareStoredTokens(address _recipient, uint256 mny) internal {
317         Target t;
318         uint256 share = 0;
319         for(uint i=0; i<contractCount; i++) {
320             share = mul(mny, tokenShare[exchangePartners[i]]);
321 
322             t = Target(exchangePartners[i]);
323             t.transfer(_recipient, share);
324             tokenBalances[exchangePartners[i]] = sub(tokenBalances[exchangePartners[i]], share);
325         }
326     }
327 
328     // NOTE: this function is used to redistribute the swapped MNY after swap has ended
329     function distributeMnyAfterSwap(address _recipient, uint256 _tokens) public {
330         require(msg.sender == owner);
331         require(swappedTokens <= _tokens);
332         balances[_recipient] = add(balances[_recipient], _tokens);
333         Transfer(this, _recipient, _tokens);
334         swappedTokens = sub(totalSupply, _tokens);
335         circulatingSupply = add(circulatingSupply, _tokens);
336     }
337 
338     // we will use this to distribute tokens owned in other contracts
339     // e.g. if we have MNY irretrievably locked in contracts/forgotten wallets etc that cannot be returned.
340     // This function WILL ONLY be called fter fair notice and CANNOT be called until 90 days have
341     // passed since the swap started
342     function distributeOwnedTokensFromOtherContracts(address _contract, address _recipient, uint256 _tokens) {
343         require(now >= swapEndTime);
344         require(msg.sender == owner);
345 
346         require(tokenBalances[_contract] >= _tokens);
347         Target t = Target(_contract);
348         t.transfer(_recipient, _tokens);
349         tokenBalances[_contract] = sub(tokenBalances[_contract], _tokens);
350     }
351 
352     function existingContract(address _contract) internal returns (bool) {
353         for(uint i=0; i<=contractCount; i++) {
354             if(exchangePartners[i] == _contract) return true;
355         }
356         return false;
357     }
358 
359     function contractExchangeRate(address _contract) public constant returns (uint256) {
360         return exchangeRates[_contract];
361     }
362 
363     function mul(uint a, uint b) internal pure returns (uint) {
364         uint c = a * b;
365         require(a == 0 || c / a == b);
366         return c;
367     }
368 
369     function div(uint a, uint b) internal pure returns (uint) {
370         // assert(b > 0); // Solidity automatically throws when dividing by 0
371         uint c = a / b;
372         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
373         return c;
374     }
375 
376     function sub(uint a, uint b) internal pure returns (uint) {
377         require(b <= a);
378         return a - b;
379     }
380 
381     function add(uint a, uint b) internal pure returns (uint) {
382         uint c = a + b;
383         require(c >= a);
384         return c;
385     }
386 
387     // ERC20 compliance addition
388     function transferFrom(address _from, address _to, uint256 _tokens) public returns (bool success) {
389         require(balances[_from] >= _tokens);
390         balances[_from] = sub(balances[_from],_tokens);
391         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender],_tokens);
392         balances[_to] = add(balances[_to],_tokens);
393         Transfer(_from, _to, _tokens);
394         return true;
395     }
396 
397     function approve(address _spender, uint256 _tokens) public returns (bool success) {
398         allowed[msg.sender][_spender] = _tokens;
399         Approval(msg.sender, _spender, _tokens);
400         return true;
401     }
402 
403     function allowance(address _tokenOwner, address _spender) public constant returns (uint256 remaining) {
404         return allowed[_tokenOwner][_spender];
405     }
406 }