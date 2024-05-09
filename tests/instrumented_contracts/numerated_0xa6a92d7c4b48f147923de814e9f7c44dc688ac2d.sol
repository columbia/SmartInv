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
134  * First blood crowdsale ICO contract.
135  *
136  * Security criteria evaluated against http://ethereum.stackexchange.com/questions/8551/methodological-security-review-of-a-smart-contract
137  *
138  *
139  */
140 contract FirstBloodToken is StandardToken, SafeMath {
141 
142     string public name = "Googlier Token";
143     string public symbol = "googlier";
144     uint public decimals = 18;
145     uint public startBlock; //crowdsale start block (set in constructor)
146     uint public endBlock; //crowdsale end block (set in constructor)
147 
148     // Initial founder address (set in constructor)
149     // All deposited ETH will be instantly forwarded to this address.
150     // Address is a multisig wallet.
151     address public founder = 0x0e0b9d8c9930e7cff062dd4a2b26bce95a0defee;
152 
153     // signer address (for clickwrap agreement)
154     // see function() {} for comments
155     address public signer = 0x0e0b9d8c9930e7cff062dd4a2b26bce95a0defee;
156 
157     uint public etherCap = 500000 * 10**18; //max amount raised during crowdsale (5.5M USD worth of ether will be measured with market price at beginning of the crowdsale)
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
209      * Buy for the sender itself or buy on the behalf of somebody else (third party address).
210      *
211      * Security review
212      *
213      * - Integer math: ok - using SafeMath
214      *
215      * - halt flag added - ok
216      *
217      * Applicable tests:
218      *
219      * - Test halting, buying, and failing
220      * - Test buying on behalf of a recipient
221      * - Test buy
222      * - Test unhalting, buying, and succeeding
223      * - Test buying after the sale ends
224      *
225      */
226     function buyRecipient(address recipient, uint8 v, bytes32 r, bytes32 s) {
227         bytes32 hash = sha256(msg.sender);
228         if (ecrecover(hash,v,r,s) != signer) throw;
229         if (block.number<startBlock || block.number>endBlock || safeAdd(presaleEtherRaised,msg.value)>etherCap || halted) throw;
230         uint tokens = safeMul(msg.value, price());
231         balances[recipient] = safeAdd(balances[recipient], tokens);
232         totalSupply = safeAdd(totalSupply, tokens);
233         presaleEtherRaised = safeAdd(presaleEtherRaised, msg.value);
234 
235         // TODO: Is there a pitfall of forwarding message value like this
236         // TODO: Different address for founder deposits and founder operations (halt, unhalt)
237         // as founder opeations might be easier to perform from normal geth account
238         if (!founder.call.value(msg.value)()) throw; //immediately send Ether to founder address
239 
240         Buy(recipient, msg.value, tokens);
241     }
242 
243     /**
244      * Set up founder address token balance.
245      *
246      * allocateBountyAndEcosystemTokens() must be calld first.
247      *
248      * Security review
249      *
250      * - Integer math: ok - only called once with fixed parameters
251      *
252      * Applicable tests:
253      *
254      * - Test bounty and ecosystem allocation
255      * - Test bounty and ecosystem allocation twice
256      *
257      */
258     function allocateFounderTokens() {
259         if (msg.sender!=founder) throw;
260         if (block.number <= endBlock + founderLockup) throw;
261         if (founderAllocated) throw;
262         if (!bountyAllocated || !ecosystemAllocated) throw;
263         balances[founder] = safeAdd(balances[founder], presaleTokenSupply * founderAllocation / (1 ether));
264         totalSupply = safeAdd(totalSupply, presaleTokenSupply * founderAllocation / (1 ether));
265         founderAllocated = true;
266         AllocateFounderTokens(msg.sender);
267     }
268 
269     /**
270      * Set up founder address token balance.
271      *
272      * Set up bounty pool.
273      *
274      * Security review
275      *
276      * - Integer math: ok - only called once with fixed parameters
277      *
278      * Applicable tests:
279      *
280      * - Test founder token allocation too early
281      * - Test founder token allocation on time
282      * - Test founder token allocation twice
283      *
284      */
285     function allocateBountyAndEcosystemTokens() {
286         if (msg.sender!=founder) throw;
287         if (block.number <= endBlock) throw;
288         if (bountyAllocated || ecosystemAllocated) throw;
289         presaleTokenSupply = totalSupply;
290         balances[founder] = safeAdd(balances[founder], presaleTokenSupply * ecosystemAllocation / (1 ether));
291         totalSupply = safeAdd(totalSupply, presaleTokenSupply * ecosystemAllocation / (1 ether));
292         balances[founder] = safeAdd(balances[founder], bountyAllocation);
293         totalSupply = safeAdd(totalSupply, bountyAllocation);
294         bountyAllocated = true;
295         ecosystemAllocated = true;
296         AllocateBountyAndEcosystemTokens(msg.sender);
297     }
298 
299     /**
300      * Emergency Stop ICO.
301      *
302      *  Applicable tests:
303      *
304      * - Test unhalting, buying, and succeeding
305      */
306     function halt() {
307         if (msg.sender!=founder) throw;
308         halted = true;
309     }
310 
311     function unhalt() {
312         if (msg.sender!=founder) throw;
313         halted = false;
314     }
315 
316     /**
317      * Change founder address (where ICO ETH is being forwarded).
318      *
319      * Applicable tests:
320      *
321      * - Test founder change by hacker
322      * - Test founder change
323      * - Test founder token allocation twice
324      *
325     function changeFounder(address newFounder) {
326         if (msg.sender!=founder) throw;
327         founder = newFounder;
328     }
329 
330     /**
331      * ERC 20 Standard Token interface transfer function
332      *
333      * Prevent transfers until freeze period is over.
334      *
335      * Applicable tests:
336      *
337      * - Test restricted early transfer
338      * - Test transfer after restricted period
339      */
340     function transfer(address _to, uint256 _value) returns (bool success) {
341         if (block.number <= endBlock + transferLockup && msg.sender!=founder) throw;
342         return super.transfer(_to, _value);
343     }
344     /**
345      * ERC 20 Standard Token interface transfer function
346      *
347      * Prevent transfers until freeze period is over.
348      */
349     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
350         if (block.number <= endBlock + transferLockup && msg.sender!=founder) throw;
351         return super.transferFrom(_from, _to, _value);
352     }
353 
354     /**
355      * Do not allow direct deposits.
356      *
357      * All crowdsale depositors must have read the legal agreement.
358      * This is confirmed by having them signing the terms of service on the website.
359      * The give their crowdsale Ethereum source address on the website.
360      * Website signs this address using crowdsale private key (different from founders key).
361      * buy() takes this signature as input and rejects all deposits that do not have
362      * signature you receive after reading terms of service.
363      *
364      */
365     function() {
366         throw;
367     }
368 
369 }