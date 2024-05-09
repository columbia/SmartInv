1 pragma solidity ^0.4.2;
2 
3 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
4 /// @title Abstract token contract - Functions to be implemented by token contracts.
5 
6 contract AbstractToken {
7     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
8     function totalSupply() constant returns (uint256 supply) {}
9     function balanceOf(address owner) constant returns (uint256 balance);
10     function transfer(address to, uint256 value) returns (bool success);
11     function transferFrom(address from, address to, uint256 value) returns (bool success);
12     function approve(address spender, uint256 value) returns (bool success);
13     function allowance(address owner, address spender) constant returns (uint256 remaining);
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17     event Issuance(address indexed to, uint256 value);
18 }
19 
20 contract StandardToken is AbstractToken {
21 
22     /*
23      *  Data structures
24      */
25     mapping (address => uint256) balances;
26     mapping (address => mapping (address => uint256)) allowed;
27     uint256 public totalSupply;
28 
29     /*
30      *  Read and write storage functions
31      */
32     /// @dev Transfers sender's tokens to a given address. Returns success.
33     /// @param _to Address of token receiver.
34     /// @param _value Number of tokens to transfer.
35     function transfer(address _to, uint256 _value) returns (bool success) {
36         if (balances[msg.sender] >= _value && _value > 0) {
37             balances[msg.sender] -= _value;
38             balances[_to] += _value;
39             Transfer(msg.sender, _to, _value);
40             return true;
41         }
42         else {
43             return false;
44         }
45     }
46 
47     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
48     /// @param _from Address from where tokens are withdrawn.
49     /// @param _to Address to where tokens are sent.
50     /// @param _value Number of tokens to transfer.
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
52         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
53             balances[_to] += _value;
54             balances[_from] -= _value;
55             allowed[_from][msg.sender] -= _value;
56             Transfer(_from, _to, _value);
57             return true;
58         }
59         else {
60             return false;
61         }
62     }
63 
64     /// @dev Returns number of tokens owned by given address.
65     /// @param _owner Address of token owner.
66     function balanceOf(address _owner) constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70     /// @dev Sets approved amount of tokens for spender. Returns success.
71     /// @param _spender Address of allowed account.
72     /// @param _value Number of approved tokens.
73     function approve(address _spender, uint256 _value) returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     /*
80      * Read storage functions
81      */
82     /// @dev Returns number of allowed tokens for given address.
83     /// @param _owner Address of token owner.
84     /// @param _spender Address of token spender.
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86       return allowed[_owner][_spender];
87     }
88 
89 }
90 
91 
92 /// @title Token contract - Implements Standard Token Interface with HumaniQ features.
93 /// @author EtherionLab team, https://etherionlab.com
94 contract HumaniqToken is StandardToken {
95 
96     /*
97      * External contracts
98      */
99     address public emissionContractAddress = 0x0;
100 
101     /*
102      * Token meta data
103      */
104     string constant public name = "HumaniQ";
105     string constant public symbol = "HMQ";
106     uint8 constant public decimals = 8;
107 
108     address public founder = 0x0;
109     bool locked = true;
110     /*
111      * Modifiers
112      */
113     modifier onlyFounder() {
114         // Only founder is allowed to do this action.
115         if (msg.sender != founder) {
116             throw;
117         }
118         _;
119     }
120 
121     modifier isCrowdfundingContract() {
122         // Only emission address is allowed to proceed.
123         if (msg.sender != emissionContractAddress) {
124             throw;
125         }
126         _;
127     }
128 
129     modifier unlocked() {
130         // Only when transferring coins is enabled.
131         if (locked == true) {
132             throw;
133         }
134         _;
135     }
136 
137     /*
138      * Contract functions
139      */
140 
141     /// @dev Crowdfunding contract issues new tokens for address. Returns success.
142     /// @param _for Address of receiver.
143     /// @param tokenCount Number of tokens to issue.
144     function issueTokens(address _for, uint tokenCount)
145         external
146         payable
147         isCrowdfundingContract
148         returns (bool)
149     {
150         if (tokenCount == 0) {
151             return false;
152         }
153         balances[_for] += tokenCount;
154         totalSupply += tokenCount;
155         Issuance(_for, tokenCount);
156         return true;
157     }
158 
159     function transfer(address _to, uint256 _value)
160         unlocked
161         returns (bool success)
162     {
163         return super.transfer(_to, _value);
164     }
165 
166     function transferFrom(address _from, address _to, uint256 _value)
167         unlocked
168         returns (bool success)
169     {
170         return super.transferFrom(_from, _to, _value);
171     }
172 
173     /// @dev Function to change address that is allowed to do emission.
174     /// @param newAddress Address of new emission contract.
175     function changeEmissionContractAddress(address newAddress)
176         external
177         onlyFounder
178         returns (bool)
179     {
180         emissionContractAddress = newAddress;
181     }
182 
183     /// @dev Function that locks/unlocks transfers of token.
184     /// @param value True/False
185     function lock(bool value)
186         external
187         onlyFounder
188     {
189         locked = value;
190     }
191 
192     /// @dev Contract constructor function sets initial token balances.
193     /// @param _founder Address of the founder of HumaniQ.
194     function HumaniqToken(address _founder)
195     {
196         totalSupply = 0;
197         founder = _founder;
198     }
199 }
200 
201 
202 /// @title HumaniqICO contract - Takes funds from users and issues tokens.
203 /// @author Evgeny Yurtaev - <evgeny@etherionlab.com>
204 contract HumaniqICO {
205 
206     /*
207      * External contracts
208      */
209     HumaniqToken public humaniqToken;
210 
211     /*
212      * Crowdfunding parameters
213      */
214     uint constant public CROWDFUNDING_PERIOD = 3 weeks;
215 
216     /*
217      *  Storage
218      */
219     address public founder;
220     address public multisig;
221     uint public startDate = 0;
222     uint public icoBalance = 0;
223     uint public coinsIssued = 0;
224     uint public baseTokenPrice = 1 finney; // 0.001 ETH
225     uint public discountedPrice = baseTokenPrice;
226     bool public isICOActive = false;
227 
228     // participant address => value in Wei
229     mapping (address => uint) public investments;
230 
231     /*
232      *  Modifiers
233      */
234     modifier onlyFounder() {
235         // Only founder is allowed to do this action.
236         if (msg.sender != founder) {
237             throw;
238         }
239         _;
240     }
241 
242     modifier minInvestment() {
243         // User has to send at least the ether value of one token.
244         if (msg.value < baseTokenPrice) {
245             throw;
246         }
247         _;
248     }
249 
250     modifier icoActive() {
251         if (isICOActive == false) {
252             throw;
253         }
254         _;
255     }
256 
257     /// @dev Returns current bonus
258     function getCurrentBonus()
259         public
260         constant
261         returns (uint)
262     {
263         return getBonus(now);
264     }
265 
266     /// @dev Returns bonus for the specific moment
267     /// @param timestamp Time of investment (in seconds)
268     function getBonus(uint timestamp)
269         public
270         constant
271         returns (uint)
272     {
273 
274         if (startDate == 0) {
275             return 1499; // 49.9%
276         }
277 
278         uint icoDuration = timestamp - startDate;
279         if (icoDuration >= 16 days) {
280             return 1000;  // 0%
281         } else if (icoDuration >= 9 days) {
282             return 1125;  // 12.5%
283         } else if (icoDuration >= 2 days) {
284             return 1250;  // 25%
285         } else {
286             return 1499;  // 49.9%
287         }
288     }
289 
290     function calculateTokens(uint investment, uint timestamp)
291         public
292         constant
293         returns (uint)
294     {
295         // calculate discountedPrice
296         discountedPrice = (baseTokenPrice * 1000) / getBonus(timestamp);
297 
298         // Token count is rounded down. Sent ETH should be multiples of baseTokenPrice.
299         return investment / discountedPrice;
300     }
301 
302     /// @dev Issues tokens
303     /// @param beneficiary Address the tokens will be issued to.
304     /// @param investment Invested amount in Wei
305     /// @param timestamp Time of investment (in seconds)
306     /// @param sendToFounders Whether to send received ethers to multisig address or not
307     function issueTokens(address beneficiary, uint investment, uint timestamp, bool sendToFounders)
308         private
309         returns (uint)
310     {
311         uint tokenCount = calculateTokens(investment, timestamp);
312 
313         // Ether spent by user.
314         uint roundedInvestment = tokenCount * discountedPrice;
315 
316         // Send change back to user.
317         if (sendToFounders && investment > roundedInvestment && !beneficiary.send(investment - roundedInvestment)) {
318             throw;
319         }
320 
321         // Update fund's and user's balance and total supply of tokens.
322         icoBalance += investment;
323         coinsIssued += tokenCount;
324         investments[beneficiary] += roundedInvestment;
325 
326         // Send funds to founders if investment was made
327         if (sendToFounders && !multisig.send(roundedInvestment)) {
328             // Could not send money
329             throw;
330         }
331 
332         if (!humaniqToken.issueTokens(beneficiary, tokenCount)) {
333             // Tokens could not be issued.
334             throw;
335         }
336 
337         return tokenCount;
338     }
339 
340     /// @dev Allows user to create tokens if token creation is still going
341     /// and cap was not reached. Returns token count.
342     function fund()
343         public
344         icoActive
345         minInvestment
346         payable
347         returns (uint)
348     {
349         return issueTokens(msg.sender, msg.value, now, true);
350     }
351 
352     /// @dev Issues tokens for users who made BTC purchases.
353     /// @param beneficiary Address the tokens will be issued to.
354     /// @param investment Invested amount in Wei
355     /// @param timestamp Time of investment (in seconds)
356     function fixInvestment(address beneficiary, uint investment, uint timestamp)
357         external
358         icoActive
359         onlyFounder
360         returns (uint)
361     {
362         if (timestamp == 0) {
363             return issueTokens(beneficiary, investment, now, false);
364         }
365 
366         return issueTokens(beneficiary, investment, timestamp, false);
367     }
368 
369     /// @dev If ICO has successfully finished sends the money to multisig
370     /// wallet.
371     function finishCrowdsale()
372         external
373         onlyFounder
374         returns (bool)
375     {
376         if (isICOActive == true) {
377             isICOActive = false;
378             // Founders receive 14% of all created tokens.
379              uint founderBonus = (coinsIssued * 14) / 86;
380              if (!humaniqToken.issueTokens(multisig, founderBonus)) {
381                  // Tokens could not be issued.
382                  throw;
383              }
384         }
385     }
386 
387     /// @dev Sets token value in Wei.
388     /// @param valueInWei New value.
389     function changeBaseTokenPrice(uint valueInWei)
390         external
391         onlyFounder
392         returns (bool)
393     {
394         baseTokenPrice = valueInWei;
395         return true;
396     }
397 
398     function changeTokenAddress(address token_address) 
399         public
400         onlyFounder
401     {
402          humaniqToken = HumaniqToken(token_address);
403     }
404 
405     function changeFounder(address _founder) 
406         public
407         onlyFounder
408     {
409         founder = _founder;
410     }
411 
412     /// @dev Function that activates ICO.
413     function startICO()
414         external
415         onlyFounder
416     {
417         if (isICOActive == false && startDate == 0) {
418           // Start ICO
419           isICOActive = true;
420           // Set start-date of token creation
421           startDate = now;
422         }
423     }
424 
425     /// @dev Contract constructor function sets founder and multisig addresses.
426     function HumaniqICO(address _founder, address _multisig, address token_address) {
427         // Set founder address
428         founder = _founder;
429         // Set multisig address
430         multisig = _multisig;
431         // Set token address
432         humaniqToken = HumaniqToken(token_address);
433     }
434 
435     /// @dev Fallback function. Calls fund() function to create tokens.
436     function () payable {
437         fund();
438     }
439 }