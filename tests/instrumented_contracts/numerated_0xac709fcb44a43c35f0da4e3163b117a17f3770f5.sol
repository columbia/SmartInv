1 /**
2  * Overflow aware uint math functions.
3  *
4  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
5  */
6 pragma solidity ^0.4.2;
7 
8 contract SafeMath {
9   //internals
10 
11   function safeMul(uint a, uint b) internal returns (uint) {
12     uint c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function safeSub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 
28   function assert(bool assertion) internal {
29     if (!assertion) throw;
30   }
31 }
32 
33 /**
34  * ERC 20 token
35  *
36  * https://github.com/ethereum/EIPs/issues/20
37  */
38 contract Token {
39 
40     /// @return total amount of tokens
41     function totalSupply() constant returns (uint256 supply) {}
42 
43     /// @param _owner The address from which the balance will be retrieved
44     /// @return The balance
45     function balanceOf(address _owner) constant returns (uint256 balance) {}
46 
47     /// @notice send `_value` token to `_to` from `msg.sender`
48     /// @param _to The address of the recipient
49     /// @param _value The amount of token to be transferred
50     /// @return Whether the transfer was successful or not
51     function transfer(address _to, uint256 _value) returns (bool success) {}
52 
53     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
54     /// @param _from The address of the sender
55     /// @param _to The address of the recipient
56     /// @param _value The amount of token to be transferred
57     /// @return Whether the transfer was successful or not
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
59 
60     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
61     /// @param _spender The address of the account able to transfer the tokens
62     /// @param _value The amount of wei to be approved for transfer
63     /// @return Whether the approval was successful or not
64     function approve(address _spender, uint256 _value) returns (bool success) {}
65 
66     /// @param _owner The address of the account owning tokens
67     /// @param _spender The address of the account able to transfer the tokens
68     /// @return Amount of remaining tokens allowed to spent
69     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 
74 }
75 
76 /**
77  * ERC 20 token
78  *
79  * https://github.com/ethereum/EIPs/issues/20
80  */
81 contract StandardToken is Token {
82 
83     /**
84      * Reviewed:
85      * - Interger overflow = OK, checked
86      */
87     function transfer(address _to, uint256 _value) returns (bool success) {
88         //Default assumes totalSupply can't be over max (2^256 - 1).
89         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
90         //Replace the if with this one instead.
91         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
92         //if (balances[msg.sender] >= _value && _value > 0) {
93             balances[msg.sender] -= _value;
94             balances[_to] += _value;
95             Transfer(msg.sender, _to, _value);
96             return true;
97         } else { return false; }
98     }
99 
100     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
101         //same as above. Replace this line with the following if you want to protect against wrapping uints.
102         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
103         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
104             balances[_to] += _value;
105             balances[_from] -= _value;
106             allowed[_from][msg.sender] -= _value;
107             Transfer(_from, _to, _value);
108             return true;
109         } else { return false; }
110     }
111 
112     function balanceOf(address _owner) constant returns (uint256 balance) {
113         return balances[_owner];
114     }
115 
116     function approve(address _spender, uint256 _value) returns (bool success) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
123       return allowed[_owner][_spender];
124     }
125 
126     mapping(address => uint256) balances;
127 
128     mapping (address => mapping (address => uint256)) allowed;
129 
130     uint256 public totalSupply;
131 
132 }
133 
134 
135 /**
136  * Arcade City crowdsale crowdsale contract.
137  *
138  * Security criteria evaluated against http://ethereum.stackexchange.com/questions/8551/methodological-security-review-of-a-smart-contract
139  *
140  *
141  */
142 contract ARCToken is StandardToken, SafeMath {
143 
144     string public name = "Arcade Token";
145     string public symbol = "ARC";
146     uint public decimals = 18;
147     uint public startBlock; //crowdsale start block (set in constructor)
148     uint public endBlock; //crowdsale end block (set in constructor)
149 
150     // Initial multisig address (set in constructor)
151     // All deposited ETH will be instantly forwarded to this address.
152     // Address is a multisig wallet.
153     address public multisig = 0x0;
154 
155     address public founder = 0x0;
156     address public developer = 0x0;
157     address public rewards = 0x0;
158     bool public rewardAddressesSet = false;
159 
160     address public owner = 0x0;
161     bool public marketactive = false;
162 
163     uint public etherCap = 672000 * 10**18; //max amount raised during crowdsale (8.5M USD worth of ether will be measured with a moving average market price at beginning of the crowdsale)
164     uint public rewardsAllocation = 2; //2% tokens allocated post-crowdsale for swarm rewards
165     uint public developerAllocation = 6 ; //6% of token supply allocated post-crowdsale for the developer fund
166     uint public founderAllocation = 8; //8% of token supply allocated post-crowdsale for the founder allocation
167     bool public allocated = false; //this will change to true when the rewards are allocated
168     uint public presaleTokenSupply = 0; //this will keep track of the token supply created during the crowdsale
169     uint public presaleEtherRaised = 0; //this will keep track of the Ether raised during the crowdsale
170     bool public halted = false; //the founder address can set this to true to halt the crowdsale due to emergency
171     event Buy(address indexed sender, uint eth, uint fbt);
172 
173     function ARCToken(address multisigInput, uint startBlockInput, uint endBlockInput) {
174         owner = msg.sender;
175         multisig = multisigInput;
176 
177         startBlock = startBlockInput;
178         endBlock = endBlockInput;
179     }
180 
181     function setRewardAddresses(address founderInput, address developerInput, address rewardsInput){
182         if (msg.sender != owner) throw;
183         if (rewardAddressesSet) throw;
184         founder = founderInput;
185         developer = developerInput;
186         rewards = rewardsInput;
187         rewardAddressesSet = true;
188     }
189 
190     function price() constant returns(uint) {
191         return testPrice(block.number);        
192     }
193 
194     // price() exposed for unit tests
195     function testPrice(uint blockNumber) constant returns(uint) {
196         if (blockNumber>=startBlock && blockNumber<startBlock+250) return 125; //power hour
197         if (blockNumber<startBlock || blockNumber>endBlock) return 75; //default price
198         return 75 + 4*(endBlock - blockNumber)/(endBlock - startBlock + 1)*34/4; //crowdsale price
199     }
200 
201     /**
202      * Main token buy function.
203      *
204      * Security review
205      *
206      * - Integer math: ok - using SafeMath
207      *
208      * - halt flag added - ok
209      *
210      * Applicable tests:
211      *
212      * - Test halting, buying, and failing
213      * - Test buying on behalf of a recipient
214      * - Test buy
215      * - Test unhalting, buying, and succeeding
216      * - Test buying after the sale ends
217      *
218      */
219     function buyRecipient(address recipient) {
220         if (block.number<startBlock || block.number>endBlock || safeAdd(presaleEtherRaised,msg.value)>etherCap || halted) throw;
221         uint tokens = safeMul(msg.value, price());
222         balances[recipient] = safeAdd(balances[recipient], tokens);
223         totalSupply = safeAdd(totalSupply, tokens);
224         presaleEtherRaised = safeAdd(presaleEtherRaised, msg.value);
225 
226         if (!multisig.send(msg.value)) throw; //immediately send Ether to multisig address
227 
228         // if etherCap is reached - activate the market
229         if (presaleEtherRaised == etherCap && !marketactive){
230             marketactive = true;
231         }
232 
233         Buy(recipient, msg.value, tokens);
234 
235     }
236 
237     /**
238      * Set up founder address token balance.
239      *
240      * allocateBountyAndEcosystemTokens() must be calld first.
241      *
242      * Security review
243      *
244      * - Integer math: ok - only called once with fixed parameters
245      *
246      * Applicable tests:
247      *
248      * - Test bounty and ecosystem allocation
249      * - Test bounty and ecosystem allocation twice
250      *
251      */
252     function allocateTokens() {
253         // make sure founder/developer/rewards addresses are configured
254         if(founder == 0x0 || developer == 0x0 || rewards == 0x0) throw;
255         // owner/founder/developer/rewards addresses can call this function
256         if (msg.sender != owner && msg.sender != founder && msg.sender != developer && msg.sender != rewards ) throw;
257         // it should only continue if endBlock has passed OR presaleEtherRaised has reached the cap
258         if (block.number <= endBlock && presaleEtherRaised < etherCap) throw;
259         if (allocated) throw;
260         presaleTokenSupply = totalSupply;
261         // total token allocations add up to 16% of total coins, so formula is reward=allocation_in_percent/84 .
262         balances[founder] = safeAdd(balances[founder], presaleTokenSupply * founderAllocation / 84 );
263         totalSupply = safeAdd(totalSupply, presaleTokenSupply * founderAllocation / 84);
264         
265         balances[developer] = safeAdd(balances[developer], presaleTokenSupply * developerAllocation / 84);
266         totalSupply = safeAdd(totalSupply, presaleTokenSupply * developerAllocation / 84);
267         
268         balances[rewards] = safeAdd(balances[rewards], presaleTokenSupply * rewardsAllocation / 84);
269         totalSupply = safeAdd(totalSupply, presaleTokenSupply * rewardsAllocation / 84);
270 
271         allocated = true;
272 
273     }
274 
275     /**
276      * Emergency Stop crowdsale.
277      *
278      *  Applicable tests:
279      *
280      * - Test unhalting, buying, and succeeding
281      */
282     function halt() {
283         if (msg.sender!=founder && msg.sender != developer) throw;
284         halted = true;
285     }
286 
287     function unhalt() {
288         if (msg.sender!=founder && msg.sender != developer) throw;
289         halted = false;
290     }
291 
292     /**
293      * ERC 20 Standard Token interface transfer function
294      *
295      * Prevent transfers until token sale is over.
296      *
297      * Applicable tests:
298      *
299      * - Test transfer after restricted period
300      * - Test transfer after market activated
301      */
302     function transfer(address _to, uint256 _value) returns (bool success) {
303         if (block.number <= endBlock && marketactive == false) throw;
304         return super.transfer(_to, _value);
305     }
306     /**
307      * ERC 20 Standard Token interface transfer function
308      *
309      * Prevent transfers until token sale is over.
310      */
311     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
312         if (block.number <= endBlock && marketactive == false) throw;
313         return super.transferFrom(_from, _to, _value);
314     }
315 
316     /**
317      * Direct deposits buys tokens
318      */
319     function() payable {
320         buyRecipient(msg.sender);
321     }
322 
323 }