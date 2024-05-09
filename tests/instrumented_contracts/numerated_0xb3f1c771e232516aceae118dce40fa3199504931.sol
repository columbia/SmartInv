1 pragma solidity ^0.4.6;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 contract SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function assert(bool assertion) internal {
33     if (!assertion) {
34       throw;
35     }
36   }
37 }
38 
39 
40 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
41 /// @title Abstract token contract - Functions to be implemented by token contracts.
42 contract AbstractToken {
43     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
44     function totalSupply() constant returns (uint256 supply) {}
45     function balanceOf(address owner) constant returns (uint256 balance);
46     function transfer(address to, uint256 value) returns (bool success);
47     function transferFrom(address from, address to, uint256 value) returns (bool success);
48     function approve(address spender, uint256 value) returns (bool success);
49     function allowance(address owner, address spender) constant returns (uint256 remaining);
50 
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53     event Issuance(address indexed to, uint256 value);
54 }
55 
56 
57 contract StandardToken is AbstractToken {
58 
59     /*
60      *  Data structures
61      */
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64     uint256 public totalSupply;
65 
66     /*
67      *  Read and write storage functions
68      */
69     /// @dev Transfers sender's tokens to a given address. Returns success.
70     /// @param _to Address of token receiver.
71     /// @param _value Number of tokens to transfer.
72     function transfer(address _to, uint256 _value) returns (bool success) {
73         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
74             balances[msg.sender] -= _value;
75             balances[_to] += _value;
76             Transfer(msg.sender, _to, _value);
77             return true;
78         }
79         else {
80             return false;
81         }
82     }
83 
84     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
85     /// @param _from Address from where tokens are withdrawn.
86     /// @param _to Address to where tokens are sent.
87     /// @param _value Number of tokens to transfer.
88     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
89       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
90             balances[_to] += _value;
91             balances[_from] -= _value;
92             allowed[_from][msg.sender] -= _value;
93             Transfer(_from, _to, _value);
94             return true;
95         }
96         else {
97             return false;
98         }
99     }
100 
101     /// @dev Returns number of tokens owned by given address.
102     /// @param _owner Address of token owner.
103     function balanceOf(address _owner) constant returns (uint256 balance) {
104         return balances[_owner];
105     }
106 
107     /// @dev Sets approved amount of tokens for spender. Returns success.
108     /// @param _spender Address of allowed account.
109     /// @param _value Number of approved tokens.
110     function approve(address _spender, uint256 _value) returns (bool success) {
111         allowed[msg.sender][_spender] = _value;
112         Approval(msg.sender, _spender, _value);
113         return true;
114     }
115 
116     /*
117      * Read storage functions
118      */
119     /// @dev Returns number of allowed tokens for given address.
120     /// @param _owner Address of token owner.
121     /// @param _spender Address of token spender.
122     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
123       return allowed[_owner][_spender];
124     }
125 
126 }
127 
128 
129 /// @title Token contract - Implements Standard Token Interface with HumaniQ features.
130 /// @author Evgeny Yurtaev - <evgeny@etherionlab.com>
131 /// @author Alexey Bashlykov - <alexey@etherionlab.com>
132 contract HumaniqToken is StandardToken, SafeMath {
133 
134     /*
135      * External contracts
136      */
137     address public minter;
138 
139     /*
140      * Token meta data
141      */
142     string constant public name = "Humaniq";
143     string constant public symbol = "HMQ";
144     uint8 constant public decimals = 8;
145 
146     // Address of the founder of Humaniq.
147     address public founder = 0xc890b1f532e674977dfdb791cafaee898dfa9671;
148 
149     // Multisig address of the founders
150     address public multisig = 0xa2c9a7578e2172f32a36c5c0e49d64776f9e7883;
151 
152     // Address where all tokens created during ICO stage initially allocated
153     address constant public allocationAddressICO = 0x1111111111111111111111111111111111111111;
154 
155     // Address where all tokens created during preICO stage initially allocated
156     address constant public allocationAddressPreICO = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
157 
158     // 31 820 314 tokens were minted during preICO
159     uint constant public preICOSupply = mul(31820314, 100000000);
160 
161     // 131 038 286 tokens were minted during ICO
162     uint constant public ICOSupply = mul(131038286, 100000000);
163 
164     // Max number of tokens that can be minted
165     uint public maxTotalSupply;
166 
167     /*
168      * Modifiers
169      */
170     modifier onlyFounder() {
171         // Only founder is allowed to do this action.
172         if (msg.sender != founder) {
173             throw;
174         }
175         _;
176     }
177 
178     modifier onlyMinter() {
179         // Only minter is allowed to proceed.
180         if (msg.sender != minter) {
181             throw;
182         }
183         _;
184     }
185 
186     /*
187      * Contract functions
188      */
189 
190     /// @dev Crowdfunding contract issues new tokens for address. Returns success.
191     /// @param _for Address of receiver.
192     /// @param tokenCount Number of tokens to issue.
193     function issueTokens(address _for, uint tokenCount)
194         external
195         payable
196         onlyMinter
197         returns (bool)
198     {
199         if (tokenCount == 0) {
200             return false;
201         }
202 
203         if (add(totalSupply, tokenCount) > maxTotalSupply) {
204             throw;
205         }
206 
207         totalSupply = add(totalSupply, tokenCount);
208         balances[_for] = add(balances[_for], tokenCount);
209         Issuance(_for, tokenCount);
210         return true;
211     }
212 
213     /// @dev Function to change address that is allowed to do emission.
214     /// @param newAddress Address of new emission contract.
215     function changeMinter(address newAddress)
216         public
217         onlyFounder
218         returns (bool)
219     {   
220         // Forbid previous emission contract to distribute tokens minted during ICO stage
221         delete allowed[allocationAddressICO][minter];
222 
223         minter = newAddress;
224 
225         // Allow emission contract to distribute tokens minted during ICO stage
226         allowed[allocationAddressICO][minter] = balanceOf(allocationAddressICO);
227     }
228 
229     /// @dev Function to change founder address.
230     /// @param newAddress Address of new founder.
231     function changeFounder(address newAddress)
232         public
233         onlyFounder
234         returns (bool)
235     {   
236         founder = newAddress;
237     }
238 
239     /// @dev Function to change multisig address.
240     /// @param newAddress Address of new multisig.
241     function changeMultisig(address newAddress)
242         public
243         onlyFounder
244         returns (bool)
245     {
246         multisig = newAddress;
247     }
248 
249     /// @dev Contract constructor function sets initial token balances.
250     function HumaniqToken(address founderAddress)
251     {   
252         // Set founder address
253         founder = founderAddress;
254 
255         // Allocate all created tokens during ICO stage to allocationAddressICO.
256         balances[allocationAddressICO] = ICOSupply;
257 
258         // Allocate all created tokens during preICO stage to allocationAddressPreICO.
259         balances[allocationAddressPreICO] = preICOSupply;
260 
261         // Allow founder to distribute tokens minted during preICO stage
262         allowed[allocationAddressPreICO][founder] = preICOSupply;
263 
264         // Give 14 percent of all tokens to founders.
265         balances[multisig] = div(mul(ICOSupply, 14), 86);
266 
267         // Set correct totalSupply and limit maximum total supply.
268         totalSupply = add(ICOSupply, balances[multisig]);
269         totalSupply = add(totalSupply, preICOSupply);
270         maxTotalSupply = mul(totalSupply, 5);
271     }
272 }
273 
274 /// @title HumaniqICO contract - Takes funds from users and issues tokens.
275 /// @author Evgeny Yurtaev - <evgeny@etherionlab.com>
276 /// @author Alexey Bashlykov - <alexey@etherionlab.com>
277 contract HumaniqICO is SafeMath {
278 
279     /*
280      * External contracts
281      */
282     HumaniqToken public humaniqToken;
283 
284     // Address of the founder of Humaniq.
285     address public founder = 0xc890b1f532e674977dfdb791cafaee898dfa9671;
286 
287     // Address where all tokens created during ICO stage initially allocated
288     address public allocationAddress = 0x1111111111111111111111111111111111111111;
289 
290     // Start date of the ICO
291     uint public startDate = 1491433200;  // 2017-04-05 23:00:00 UTC
292 
293     // End date of the ICO
294     uint public endDate = 1493247600;  // 2017-04-26 23:00:00 UTC
295 
296     // Token price without discount during the ICO stage
297     uint public baseTokenPrice = 10000000; // 0.001 ETH, considering 8 decimal places
298 
299     // Number of tokens distributed to investors
300     uint public tokensDistributed = 0;
301 
302     /*
303      *  Modifiers
304      */
305     modifier onlyFounder() {
306         // Only founder is allowed to do this action.
307         if (msg.sender != founder) {
308             throw;
309         }
310         _;
311     }
312 
313     modifier minInvestment(uint investment) {
314         // User has to send at least the ether value of one token.
315         if (investment < baseTokenPrice) {
316             throw;
317         }
318         _;
319     }
320 
321     /// @dev Returns current bonus
322     function getCurrentBonus()
323         public
324         constant
325         returns (uint)
326     {
327         return getBonus(now);
328     }
329 
330     /// @dev Returns bonus for the specific moment
331     /// @param timestamp Time of investment (in seconds)
332     function getBonus(uint timestamp)
333         public
334         constant
335         returns (uint)
336     {   
337         if (timestamp > endDate) {
338             throw;
339         }
340 
341         if (startDate > timestamp) {
342             return 1499;  // 49.9%
343         }
344 
345         uint icoDuration = timestamp - startDate;
346         if (icoDuration >= 16 days) {
347             return 1000;  // 0%
348         } else if (icoDuration >= 9 days) {
349             return 1125;  // 12.5%
350         } else if (icoDuration >= 2 days) {
351             return 1250;  // 25%
352         } else {
353             return 1499;  // 49.9%
354         }
355     }
356 
357     function calculateTokens(uint investment, uint timestamp)
358         public
359         constant
360         returns (uint)
361     {
362         // calculate discountedPrice
363         uint discountedPrice = div(mul(baseTokenPrice, 1000), getBonus(timestamp));
364 
365         // Token count is rounded down. Sent ETH should be multiples of baseTokenPrice.
366         return div(investment, discountedPrice);
367     }
368 
369 
370     /// @dev Issues tokens for users who made BTC purchases.
371     /// @param beneficiary Address the tokens will be issued to.
372     /// @param investment Invested amount in Wei
373     /// @param timestamp Time of investment (in seconds)
374     function fixInvestment(address beneficiary, uint investment, uint timestamp)
375         external
376         onlyFounder
377         minInvestment(investment)
378         returns (uint)
379     {   
380 
381         // Calculate number of tokens to mint
382         uint tokenCount = calculateTokens(investment, timestamp);
383 
384         // Update fund's and user's balance and total supply of tokens.
385         tokensDistributed = add(tokensDistributed, tokenCount);
386 
387         // Distribute tokens.
388         if (!humaniqToken.transferFrom(allocationAddress, beneficiary, tokenCount)) {
389             // Tokens could not be issued.
390             throw;
391         }
392 
393         return tokenCount;
394     }
395 
396     /// @dev Contract constructor
397     function HumaniqICO(address tokenAddress, address founderAddress) {
398         // Set token address
399         humaniqToken = HumaniqToken(tokenAddress);
400 
401         // Set founder address
402         founder = founderAddress;
403     }
404 
405     /// @dev Fallback function
406     function () payable {
407         throw;
408     }
409 }