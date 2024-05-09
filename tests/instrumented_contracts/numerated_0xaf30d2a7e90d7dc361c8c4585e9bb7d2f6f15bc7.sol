1 /**
2  * Overflow aware uint math functions.
3  *
4  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
5  */
6 contract SafeMath {
7   //internals
8 
9   function safeMul(uint a, uint b) internal returns (uint) {
10     uint c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function safeSub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function safeAdd(uint a, uint b) internal returns (uint) {
21     uint c = a + b;
22     assert(c>=a && c>=b);
23     return c;
24   }
25 
26   function assert(bool assertion) internal {
27     if (!assertion) throw;
28   }
29 }
30 
31 /**
32  * ERC 20 token
33  *
34  * https://github.com/ethereum/EIPs/issues/20
35  */
36 contract Token {
37 
38     /// @return total amount of tokens
39     function totalSupply() constant returns (uint256 supply) {}
40 
41     /// @param _owner The address from which the balance will be retrieved
42     /// @return The balance
43     function balanceOf(address _owner) constant returns (uint256 balance) {}
44 
45     /// @notice send `_value` token to `_to` from `msg.sender`
46     /// @param _to The address of the recipient
47     /// @param _value The amount of token to be transferred
48     /// @return Whether the transfer was successful or not
49     function transfer(address _to, uint256 _value) returns (bool success) {}
50 
51     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
52     /// @param _from The address of the sender
53     /// @param _to The address of the recipient
54     /// @param _value The amount of token to be transferred
55     /// @return Whether the transfer was successful or not
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
57 
58     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
59     /// @param _spender The address of the account able to transfer the tokens
60     /// @param _value The amount of wei to be approved for transfer
61     /// @return Whether the approval was successful or not
62     function approve(address _spender, uint256 _value) returns (bool success) {}
63 
64     /// @param _owner The address of the account owning tokens
65     /// @param _spender The address of the account able to transfer the tokens
66     /// @return Amount of remaining tokens allowed to spent
67     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
68 
69     event Transfer(address indexed _from, address indexed _to, uint256 _value);
70     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71 
72 }
73 
74 /**
75  * ERC 20 token
76  *
77  * https://github.com/ethereum/EIPs/issues/20
78  */
79 contract StandardToken is Token {
80 
81     /**
82      * Reviewed:
83      * - Interger overflow = OK, checked
84      */
85     function transfer(address _to, uint256 _value) returns (bool success) {
86         //Default assumes totalSupply can't be over max (2^256 - 1).
87         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
88         //Replace the if with this one instead.
89         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
90         //if (balances[msg.sender] >= _value && _value > 0) {
91             balances[msg.sender] -= _value;
92             balances[_to] += _value;
93             Transfer(msg.sender, _to, _value);
94             return true;
95         } else { return false; }
96     }
97 
98     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
99         //same as above. Replace this line with the following if you want to protect against wrapping uints.
100         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
101         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
102             balances[_to] += _value;
103             balances[_from] -= _value;
104             allowed[_from][msg.sender] -= _value;
105             Transfer(_from, _to, _value);
106             return true;
107         } else { return false; }
108     }
109 
110     function balanceOf(address _owner) constant returns (uint256 balance) {
111         return balances[_owner];
112     }
113 
114     function approve(address _spender, uint256 _value) returns (bool success) {
115         allowed[msg.sender][_spender] = _value;
116         Approval(msg.sender, _spender, _value);
117         return true;
118     }
119 
120     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
121       return allowed[_owner][_spender];
122     }
123 
124     mapping(address => uint256) balances;
125 
126     mapping (address => mapping (address => uint256)) allowed;
127 
128     uint256 public totalSupply;
129 
130 }
131 
132 
133 /**
134  * First blood crowdsale crowdsale contract.
135  *
136  * Security criteria evaluated against http://ethereum.stackexchange.com/questions/8551/methodological-security-review-of-a-smart-contract
137  *
138  *
139  */
140 contract FirstBloodToken is StandardToken, SafeMath {
141 
142     string public name = "FirstBlood Token";
143     string public symbol = "1ST";
144     uint public decimals = 18;
145     uint public startBlock; //crowdsale start block (set in constructor)
146     uint public endBlock; //crowdsale end block (set in constructor)
147 
148     // Initial founder address (set in constructor)
149     // All deposited ETH will be instantly forwarded to this address.
150     // Address is a multisig wallet.
151     address public founder = 0x0;
152 
153     // signer address (for clickwrap agreement)
154     // see function() {} for comments
155     address public signer = 0x0;
156 
157     uint public etherCap = 465313 * 10**18; //max amount raised during crowdsale (5.5M USD worth of ether will be measured with a moving average market price at beginning of the crowdsale)
158     uint public transferLockup = 370285; //transfers are locked for this many blocks after endBlock (assuming 14 second blocks, this is 2 months)
159     uint public founderLockup = 2252571; //founder allocation cannot be created until this many blocks after endBlock (assuming 14 second blocks, this is 1 year)
160     uint public bountyAllocation = 2500000 * 10**18; //2.5M tokens allocated post-crowdsale for the bounty fund
161     uint public ecosystemAllocation = 5 * 10**16; //5% of token supply allocated post-crowdsale for the ecosystem fund
162     uint public founderAllocation = 10 * 10**16; //10% of token supply allocated post-crowdsale for the founder allocation
163     bool public bountyAllocated = false; //this will change to true when the bounty fund is allocated
164     bool public ecosystemAllocated = false; //this will change to true when the ecosystem fund is allocated
165     bool public founderAllocated = false; //this will change to true when the founder fund is allocated
166     uint public presaleTokenSupply = 0; //this will keep track of the token supply created during the crowdsale
167     uint public presaleEtherRaised = 0; //this will keep track of the Ether raised during the crowdsale
168     bool public halted = false; //the founder address can set this to true to halt the crowdsale due to emergency
169     event Buy(address indexed sender, uint eth, uint fbt);
170     event Withdraw(address indexed sender, address to, uint eth);
171     event AllocateFounderTokens(address indexed sender);
172     event AllocateBountyAndEcosystemTokens(address indexed sender);
173 
174     function FirstBloodToken(address founderInput, address signerInput, uint startBlockInput, uint endBlockInput) {
175         founder = founderInput;
176         signer = signerInput;
177         startBlock = startBlockInput;
178         endBlock = endBlockInput;
179     }
180 
181     /**
182      * Security review
183      *
184      * - Integer overflow: does not apply, blocknumber can't grow that high
185      * - Division is the last operation and constant, should not cause issues
186      * - Price function plotted https://github.com/Firstbloodio/token/issues/2
187      */
188     function price() constant returns(uint) {
189         if (block.number>=startBlock && block.number<startBlock+250) return 170; //power hour
190         if (block.number<startBlock || block.number>endBlock) return 100; //default price
191         return 100 + 4*(endBlock - block.number)/(endBlock - startBlock + 1)*67/4; //crowdsale price
192     }
193 
194     // price() exposed for unit tests
195     function testPrice(uint blockNumber) constant returns(uint) {
196         if (blockNumber>=startBlock && blockNumber<startBlock+250) return 170; //power hour
197         if (blockNumber<startBlock || blockNumber>endBlock) return 100; //default price
198         return 100 + 4*(endBlock - blockNumber)/(endBlock - startBlock + 1)*67/4; //crowdsale price
199     }
200 
201     // Buy entry point
202     function buy(uint8 v, bytes32 r, bytes32 s) {
203         buyRecipient(msg.sender, v, r, s);
204     }
205 
206     /**
207      * Main token buy function.
208      *
209      * Security review
210      *
211      * - Integer math: ok - using SafeMath
212      *
213      * - halt flag added - ok
214      *
215      * Applicable tests:
216      *
217      * - Test halting, buying, and failing
218      * - Test buying on behalf of a recipient
219      * - Test buy
220      * - Test unhalting, buying, and succeeding
221      * - Test buying after the sale ends
222      *
223      */
224     function buyRecipient(address recipient, uint8 v, bytes32 r, bytes32 s) {
225         bytes32 hash = sha256(msg.sender);
226         if (ecrecover(hash,v,r,s) != signer) throw;
227         if (block.number<startBlock || block.number>endBlock || safeAdd(presaleEtherRaised,msg.value)>etherCap || halted) throw;
228         uint tokens = safeMul(msg.value, price());
229         balances[recipient] = safeAdd(balances[recipient], tokens);
230         totalSupply = safeAdd(totalSupply, tokens);
231         presaleEtherRaised = safeAdd(presaleEtherRaised, msg.value);
232 
233         if (!founder.call.value(msg.value)()) throw; //immediately send Ether to founder address
234 
235         Buy(recipient, msg.value, tokens);
236     }
237 
238     /**
239      * Set up founder address token balance.
240      *
241      * allocateBountyAndEcosystemTokens() must be calld first.
242      *
243      * Security review
244      *
245      * - Integer math: ok - only called once with fixed parameters
246      *
247      * Applicable tests:
248      *
249      * - Test bounty and ecosystem allocation
250      * - Test bounty and ecosystem allocation twice
251      *
252      */
253     function allocateFounderTokens() {
254         if (msg.sender!=founder) throw;
255         if (block.number <= endBlock + founderLockup) throw;
256         if (founderAllocated) throw;
257         if (!bountyAllocated || !ecosystemAllocated) throw;
258         balances[founder] = safeAdd(balances[founder], presaleTokenSupply * founderAllocation / (1 ether));
259         totalSupply = safeAdd(totalSupply, presaleTokenSupply * founderAllocation / (1 ether));
260         founderAllocated = true;
261         AllocateFounderTokens(msg.sender);
262     }
263 
264     /**
265      * Set up founder address token balance.
266      *
267      * Set up bounty pool.
268      *
269      * Security review
270      *
271      * - Integer math: ok - only called once with fixed parameters
272      *
273      * Applicable tests:
274      *
275      * - Test founder token allocation too early
276      * - Test founder token allocation on time
277      * - Test founder token allocation twice
278      *
279      */
280     function allocateBountyAndEcosystemTokens() {
281         if (msg.sender!=founder) throw;
282         if (block.number <= endBlock) throw;
283         if (bountyAllocated || ecosystemAllocated) throw;
284         presaleTokenSupply = totalSupply;
285         balances[founder] = safeAdd(balances[founder], presaleTokenSupply * ecosystemAllocation / (1 ether));
286         totalSupply = safeAdd(totalSupply, presaleTokenSupply * ecosystemAllocation / (1 ether));
287         balances[founder] = safeAdd(balances[founder], bountyAllocation);
288         totalSupply = safeAdd(totalSupply, bountyAllocation);
289         bountyAllocated = true;
290         ecosystemAllocated = true;
291         AllocateBountyAndEcosystemTokens(msg.sender);
292     }
293 
294     /**
295      * Emergency Stop crowdsale.
296      *
297      *  Applicable tests:
298      *
299      * - Test unhalting, buying, and succeeding
300      */
301     function halt() {
302         if (msg.sender!=founder) throw;
303         halted = true;
304     }
305 
306     function unhalt() {
307         if (msg.sender!=founder) throw;
308         halted = false;
309     }
310 
311     /**
312      * Change founder address (where crowdsale ETH is being forwarded).
313      *
314      * Applicable tests:
315      *
316      * - Test founder change by hacker
317      * - Test founder change
318      * - Test founder token allocation twice
319      *
320      */
321 
322     function changeFounder(address newFounder) {
323         if (msg.sender!=founder) throw;
324         founder = newFounder;
325     }
326 
327     /**
328      * ERC 20 Standard Token interface transfer function
329      *
330      * Prevent transfers until freeze period is over.
331      *
332      * Applicable tests:
333      *
334      * - Test restricted early transfer
335      * - Test transfer after restricted period
336      */
337     function transfer(address _to, uint256 _value) returns (bool success) {
338         if (block.number <= endBlock + transferLockup && msg.sender!=founder) throw;
339         return super.transfer(_to, _value);
340     }
341     /**
342      * ERC 20 Standard Token interface transfer function
343      *
344      * Prevent transfers until freeze period is over.
345      */
346     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
347         if (block.number <= endBlock + transferLockup && msg.sender!=founder) throw;
348         return super.transferFrom(_from, _to, _value);
349     }
350 
351     /**
352      * Do not allow direct deposits.
353      *
354      * All crowdsale depositors must have read the legal agreement.
355      * This is confirmed by having them signing the terms of service on the website.
356      * They give their crowdsale Ethereum source address on the website.
357      * Website signs this address using crowdsale private key (different from founders key).
358      * buy() takes this signature as input and rejects all deposits that do not have
359      * signature you receive after reading terms of service.
360      *
361      */
362     function() {
363         throw;
364     }
365 
366 }