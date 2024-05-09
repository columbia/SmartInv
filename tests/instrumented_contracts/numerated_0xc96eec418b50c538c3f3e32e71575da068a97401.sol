1 /**
2  *  _____             _   _                                   
3  * /  __ \           | | (_)                                  
4  * | /  \/ ___  _ __ | |_ _ _ __   __ _  ___ _ __   ___ _   _ 
5  * | |    / _ \| '_ \| __| | '_ \ / _` |/ _ \ '_ \ / __| | | |
6  * | \__/\ (_) | | | | |_| | | | | (_| |  __/ | | | (__| |_| |
7  *  \____/\___/|_| |_|\__|_|_| |_|\__, |\___|_| |_|\___|\__, |
8  *                                 __/ |                 __/ |
9  *                                |___/                 |___/ 
10  *
11  */
12 
13 /**
14  * Overflow aware uint math functions.
15  *
16  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
17  */
18 pragma solidity ^0.4.8;
19 contract SafeMath {
20   //internals
21 
22   function safeMul(uint a, uint b) internal returns (uint) {
23     uint c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function safeSub(uint a, uint b) internal returns (uint) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function safeAdd(uint a, uint b) internal returns (uint) {
34     uint c = a + b;
35     assert(c>=a && c>=b);
36     return c;
37   }
38 
39   function assert(bool assertion) internal {
40     if (!assertion) throw;
41   }
42 }
43 
44 /**
45  * ERC 20 token
46  *
47  * https://github.com/ethereum/EIPs/issues/20
48  */
49 contract Token {
50 
51     /// @return total amount of tokens
52     function totalSupply() constant returns (uint256 supply) {}
53 
54     /// @param _owner The address from which the balance will be retrieved
55     /// @return The balance
56     function balanceOf(address _owner) constant returns (uint256 balance) {}
57 
58     /// @notice send `_value` token to `_to` from `msg.sender`
59     /// @param _to The address of the recipient
60     /// @param _value The amount of token to be transferred
61     /// @return Whether the transfer was successful or not
62     function transfer(address _to, uint256 _value) returns (bool success) {}
63 
64     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
65     /// @param _from The address of the sender
66     /// @param _to The address of the recipient
67     /// @param _value The amount of token to be transferred
68     /// @return Whether the transfer was successful or not
69     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
70 
71     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
72     /// @param _spender The address of the account able to transfer the tokens
73     /// @param _value The amount of wei to be approved for transfer
74     /// @return Whether the approval was successful or not
75     function approve(address _spender, uint256 _value) returns (bool success) {}
76 
77     /// @param _owner The address of the account owning tokens
78     /// @param _spender The address of the account able to transfer the tokens
79     /// @return Amount of remaining tokens allowed to spent
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84 
85 }
86 
87 /**
88  * ERC 20 token
89  *
90  * https://github.com/ethereum/EIPs/issues/20
91  */
92 contract StandardToken is Token {
93 
94     /**
95      * Reviewed:
96      * - Interger overflow = OK, checked
97      */
98     function transfer(address _to, uint256 _value) returns (bool success) {
99         //Default assumes totalSupply can't be over max (2^256 - 1).
100         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
101         //Replace the if with this one instead.
102         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
103         //if (balances[msg.sender] >= _value && _value > 0) {
104             balances[msg.sender] -= _value;
105             balances[_to] += _value;
106             Transfer(msg.sender, _to, _value);
107             return true;
108         } else { return false; }
109     }
110 
111     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
112         //same as above. Replace this line with the following if you want to protect against wrapping uints.
113         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
114         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
115             balances[_to] += _value;
116             balances[_from] -= _value;
117             allowed[_from][msg.sender] -= _value;
118             Transfer(_from, _to, _value);
119             return true;
120         } else { return false; }
121     }
122 
123     function balanceOf(address _owner) constant returns (uint256 balance) {
124         return balances[_owner];
125     }
126 
127     function approve(address _spender, uint256 _value) returns (bool success) {
128         allowed[msg.sender][_spender] = _value;
129         Approval(msg.sender, _spender, _value);
130         return true;
131     }
132 
133     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
134       return allowed[_owner][_spender];
135     }
136 
137     mapping(address => uint256) balances;
138 
139     mapping (address => mapping (address => uint256)) allowed;
140 
141     uint256 public totalSupply;
142 
143 }
144 
145 
146 /**
147  * Contingency crowdsale crowdsale contract. Modified from FirstBlood crowdsale contract.
148  *
149  * Security criteria evaluated against http://ethereum.stackexchange.com/questions/8551/methodological-security-review-of-a-smart-contract
150  *
151  *
152  */
153 contract ContingencyToken is StandardToken, SafeMath {
154     /*
155         Modified version of the FirstBlood.io token and token sale
156     */
157     
158     string public name = "Contingency Token";
159     string public symbol = "CTY";
160     uint public decimals = 18;
161     uint public startBlock = 3100000; //crowdsale start block
162     uint public endBlock = 3272800; //crowdsale end block
163 
164     // Initial founder address
165     // All deposited ETH will be forwarded to this address.
166     address public founder = 0x4485f44aa1f99b43BD6400586C1B2A02ec263Ec0;
167 
168     uint public etherCap = 850000 * 10**18; //max amount raised during crowdsale (8.5M USD worth of ether will be measured with a moving average market price at beginning of the crowdsale)
169     uint public transferLockup = 370284; //transfers are locked for this many blocks after endBlock (assuming 14 second blocks, this is 2 months)
170     uint public founderLockup = 1126285; //founder allocation cannot be created until this many blocks after endBlock (assuming 14 second blocks, this is 6 months)
171 
172     uint public founderAllocation = 10 * 10**16; //10% of token supply allocated post-crowdsale for the founder allocation
173     bool public founderAllocated = false; //this will change to true when the founder fund is allocated
174     uint public presaleTokenSupply = 0; //this will keep track of the token supply created during the crowdsale
175     uint public presaleEtherRaised = 0; //this will keep track of the Ether raised during the crowdsale
176     bool public halted = false; //the founder address can set this to true to halt the crowdsale due to emergency
177     event Buy(address indexed sender, uint eth, uint fbt);
178     event Withdraw(address indexed sender, address to, uint eth);
179     event AllocateFounderTokens(address indexed sender);
180 
181     /**
182      * Security review
183      *
184      * - Integer overflow: does not apply, blocknumber can't grow that high
185      * - Division is the last operation and constant, should not cause issues
186      * - Price function plotted https://github.com/Firstbloodio/token/issues/2
187      */
188     function price() constant returns(uint) {
189         if (block.number>=startBlock && block.number<startBlock+250) return 170; //function() {
190         if (block.number<startBlock || block.number>endBlock) return 100; //default price
191         return 100 + 4*(endBlock - block.number)/(endBlock - startBlock + 1)*67/4; //crowdsale price
192     }
193 
194     // price() exposed for unit tests
195     function testPrice(uint blockNumber) constant returns(uint) {
196         if (blockNumber>=startBlock && blockNumber<startBlock+250) return 170; //hour one
197         if (blockNumber<startBlock || blockNumber>endBlock) return 100; //default price
198         return 100 + 4*(endBlock - blockNumber)/(endBlock - startBlock + 1)*67/4; //crowdsale price
199     }
200 
201     // Buy entry point
202     function() payable {
203         buyRecipient(msg.sender);
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
224     function buyRecipient(address recipient) payable {
225         if (block.number<startBlock || block.number>endBlock || safeAdd(presaleEtherRaised,msg.value)>etherCap || halted) throw;
226         uint tokens = safeMul(msg.value, price());
227         balances[recipient] = safeAdd(balances[recipient], tokens);
228         totalSupply = safeAdd(totalSupply, tokens);
229         presaleEtherRaised = safeAdd(presaleEtherRaised, msg.value);
230 
231         //if (!founder.send(msg.value)) throw; //immediately send Ether to founder address
232         //Due to Metamask not sending enough gas with this method, we send ether later with the function "founderWithdraw" below
233 
234         Buy(recipient, msg.value, tokens);
235     }
236     
237     function founderWithdraw(uint amount) {
238         // Founder to receive presale ether
239         if (msg.sender!=founder) throw;
240         if (!founder.send(amount)) throw;
241     }
242 
243     /**
244      * Set up founder address token balance.
245      *
246      * Security review
247      *
248      * - Integer math: ok - only called once with fixed parameters
249      *
250      * Applicable tests:
251      *
252      * - Test bounty and ecosystem allocation
253      * - Test bounty and ecosystem allocation twice
254      *
255      */
256     function allocateFounderTokens() {
257         if (msg.sender!=founder) throw;
258         if (block.number <= endBlock + founderLockup) throw;
259         if (founderAllocated) throw;
260         //if (!bountyAllocated || !ecosystemAllocated) throw; // Extra bounty or ecosystem allocation for founders disabled for contingency
261         balances[founder] = safeAdd(balances[founder], presaleTokenSupply * founderAllocation / (1 ether));
262         totalSupply = safeAdd(totalSupply, presaleTokenSupply * founderAllocation / (1 ether));
263         founderAllocated = true;
264         AllocateFounderTokens(msg.sender);
265     }
266 
267     /**
268      * Emergency Stop crowdsale.
269      *
270      *  Applicable tests:
271      *
272      * - Test unhalting, buying, and succeeding
273      */
274     function halt() {
275         if (msg.sender!=founder) throw;
276         halted = true;
277     }
278 
279     function unhalt() {
280         if (msg.sender!=founder) throw;
281         halted = false;
282     }
283 
284     /**
285      * Change founder address (where crowdsale ETH is being forwarded).
286      *
287      * Applicable tests:
288      *
289      * - Test founder change by hacker
290      * - Test founder change
291      * - Test founder token allocation twice
292      *
293      */
294 
295     function changeFounder(address newFounder) {
296         if (msg.sender!=founder) throw;
297         founder = newFounder;
298     }
299 
300     /**
301      * ERC 20 Standard Token interface transfer function
302      *
303      * Prevent transfers until freeze period is over.
304      *
305      * Applicable tests:
306      *
307      * - Test restricted early transfer
308      * - Test transfer after restricted period
309      */
310     function transfer(address _to, uint256 _value) returns (bool success) {
311         if (block.number <= endBlock + transferLockup && msg.sender!=founder) throw;
312         return super.transfer(_to, _value);
313     }
314     /**
315      * ERC 20 Standard Token interface transfer function
316      *
317      * Prevent transfers until freeze period is over.
318      */
319     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
320         if (block.number <= endBlock + transferLockup && msg.sender!=founder) throw;
321         return super.transferFrom(_from, _to, _value);
322     }
323 
324 }