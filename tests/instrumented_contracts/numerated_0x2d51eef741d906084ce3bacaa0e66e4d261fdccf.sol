1 pragma solidity ^0.4.18;
2 /**
3  * Overflow aware uint math functions.
4  *
5  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
6  */
7 contract SafeMath {
8   //internals
9 
10   function safeMul(uint a, uint b) internal returns (uint) {
11     uint c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function safeSub(uint a, uint b) internal returns (uint) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function safeAdd(uint a, uint b) internal returns (uint) {
22     uint c = a + b;
23     assert(c>=a && c>=b);
24     return c;
25   }
26 
27   function assert(bool assertion) internal {
28     if (!assertion) throw;
29   }
30 }
31 
32 /**
33  * ERC 20 token
34  *
35  * https://github.com/ethereum/EIPs/issues/20
36  */
37 contract Token {
38 
39     /// @return total amount of tokens
40     function totalSupply() constant returns (uint256 supply) {}
41 
42     /// @param _owner The address from which the balance will be retrieved
43     /// @return The balance
44     function balanceOf(address _owner) constant returns (uint256 balance) {}
45 
46     /// @notice send `_value` token to `_to` from `msg.sender`
47     /// @param _to The address of the recipient
48     /// @param _value The amount of token to be transferred
49     /// @return Whether the transfer was successful or not
50     function transfer(address _to, uint256 _value) returns (bool success) {}
51 
52     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
53     /// @param _from The address of the sender
54     /// @param _to The address of the recipient
55     /// @param _value The amount of token to be transferred
56     /// @return Whether the transfer was successful or not
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
58 
59     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
60     /// @param _spender The address of the account able to transfer the tokens
61     /// @param _value The amount of wei to be approved for transfer
62     /// @return Whether the approval was successful or not
63     function approve(address _spender, uint256 _value) returns (bool success) {}
64 
65     /// @param _owner The address of the account owning tokens
66     /// @param _spender The address of the account able to transfer the tokens
67     /// @return Amount of remaining tokens allowed to spent
68     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72 
73 }
74 
75 /**
76  * ERC 20 token
77  *
78  * https://github.com/ethereum/EIPs/issues/20
79  */
80 contract StandardToken is Token {
81 
82     /**
83      * Reviewed:
84      * - Interger overflow = OK, checked
85      */
86     function transfer(address _to, uint256 _value) returns (bool success) {
87         //Default assumes totalSupply can't be over max (2^256 - 1).
88         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
89         //Replace the if with this one instead.
90         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
91         //if (balances[msg.sender] >= _value && _value > 0) {
92             balances[msg.sender] -= _value;
93             balances[_to] += _value;
94             Transfer(msg.sender, _to, _value);
95             return true;
96         } else { return false; }
97     }
98 
99     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
100         //same as above. Replace this line with the following if you want to protect against wrapping uints.
101         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
102         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
103             balances[_to] += _value;
104             balances[_from] -= _value;
105             allowed[_from][msg.sender] -= _value;
106             Transfer(_from, _to, _value);
107             return true;
108         } else { return false; }
109     }
110 
111     function balanceOf(address _owner) constant returns (uint256 balance) {
112         return balances[_owner];
113     }
114 
115     function approve(address _spender, uint256 _value) returns (bool success) {
116         allowed[msg.sender][_spender] = _value;
117         Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
122       return allowed[_owner][_spender];
123     }
124 
125     mapping(address => uint256) balances;
126 
127     mapping (address => mapping (address => uint256)) allowed;
128 
129     uint256 public totalSupply;
130 
131 }
132 
133 
134 /**
135  * Automobile Cyberchain Token crowdsale ICO contract.
136  *
137  */
138 contract AutomobileCyberchainToken is StandardToken, SafeMath {
139 
140     string public name = "Automobile Cyberchain Token";
141     string public symbol = "AMCC";
142     uint public decimals = 18;
143     uint preSalePrice  = 32000;
144     uint crowSalePrice = 20000;
145     uint prePeriod = 256 * 24 * 30;// unit: block count, estimate: 30 days, May 16 0:00, UTC-7
146     uint totalPeriod = 256 * 24 * 95; // unit: block count, estimate: 95 days, July 20, 0:00, UTC-7
147     uint public startBlock = 5455280; //crowdsale start block (set in constructor), April 16 0:00 UTC-7
148     uint public endBlock = startBlock + totalPeriod; //crowdsale end block
149 
150 
151     // Initial founder address (set in constructor)
152     // All deposited ETH will be instantly forwarded to this address.
153     // Address is a multisig wallet.
154     address public founder = 0xfD16CDC79382F86303E2eE8693C7f50A4d8b937F;
155     uint256 public preEtherCap = 15625 * 10**18; // max amount raised during pre-ICO
156     uint256 public etherCap =    88125 * 10**18; //max amount raised during crowdsale
157     uint256 public bountyAllocation = 1050000000 * 10**18;
158     uint256 public maxToken = 3000000000 * 10**18;
159     // uint public transferLockup = 256 * 0; //transfers are locked for this many blocks after endBlock (assuming 14 second blocks)
160     // uint public founderLockup = 256 * 0; //founder allocation cannot be created until this many blocks after endBlock
161 
162     uint256 public presaleTokenSupply = 0; //this will keep track of the token supply created during the pre-crowdsale
163     uint256 public totalEtherRaised = 0;
164     bool public halted = false; //the founder address can set this to true to halt the crowdsale due to emergency
165 
166     event Buy(address indexed sender, uint eth, uint fbt);
167 
168 
169     function AutomobileCyberchainToken() {
170         balances[founder] = bountyAllocation;
171         totalSupply = bountyAllocation;
172         Transfer(address(0), founder, bountyAllocation);
173     }
174 
175 
176     function price() constant returns(uint) {
177         if (block.number<startBlock || block.number > endBlock) return 0; //this will not happen according to the buyToken block check, but still set it to 0.
178         else if (block.number>=startBlock && block.number<startBlock+prePeriod) return preSalePrice; //pre-ICO
179         else  return crowSalePrice; // default-ICO
180     }
181 
182    /**
183     * @dev fallback function ***DO NOT OVERRIDE***
184     */
185     function() public payable  {
186         buyToken(msg.sender, msg.value);
187     }
188 
189 
190     // Buy entry point
191     function buy(address recipient, uint256 value) public payable {
192         if (value> msg.value) throw;
193 
194         if (value < msg.value) {
195             require(msg.sender.call.value(msg.value - value)()); //refund the extra ether
196         }
197         buyToken(recipient, value);
198     }
199 
200 
201     function buyToken(address recipient, uint256 value) internal {
202         if (block.number<startBlock || block.number>endBlock || safeAdd(totalEtherRaised,value)>etherCap || halted) throw;
203         if (block.number>=startBlock && block.number<=startBlock+prePeriod && safeAdd(totalEtherRaised,value) > preEtherCap) throw; //preSale Cap limitation
204         uint tokens = safeMul(value, price());
205         balances[recipient] = safeAdd(balances[recipient], tokens);
206         totalSupply = safeAdd(totalSupply, tokens);
207         totalEtherRaised = safeAdd(totalEtherRaised, value);
208 
209         if (block.number<=startBlock+prePeriod) {
210             presaleTokenSupply = safeAdd(presaleTokenSupply, tokens);
211         }
212         Transfer(address(0), recipient, tokens); //Transaction record for token perchaise
213         if (!founder.call.value(value)()) throw; //immediately send Ether to founder address
214         Buy(recipient, value, tokens); //Buy event
215 
216     }
217 
218 
219     /**
220      * Emergency Stop ICO.
221      *
222      *  Applicable tests:
223      *
224      * - Test unhalting, buying, and succeeding
225      */
226     function halt() {
227         if (msg.sender!=founder) throw;
228         halted = true;
229     }
230 
231     function unhalt() {
232         if (msg.sender!=founder) throw;
233         halted = false;
234     }
235 
236     /**
237      * Change founder address (where ICO ETH is being forwarded).
238      *
239      * Applicable tests:
240      *
241      * - Test founder change by hacker
242      * - Test founder change
243      * - Test founder token allocation twice
244      *
245      */
246     function changeFounder(address newFounder) {
247         if (msg.sender!=founder) throw;
248         founder = newFounder;
249     }
250 
251     function withdrawExtraToken(address recipient) public {
252       require(msg.sender == founder && block.number > endBlock && totalSupply < maxToken);
253 
254       uint256 leftTokens = safeSub(maxToken, totalSupply);
255       balances[recipient] = safeAdd(balances[recipient], leftTokens);
256       totalSupply = maxToken;
257       Transfer(address(0), recipient, leftTokens);
258     }
259 
260 
261     /**
262      * ERC 20 Standard Token interface transfer function
263      *
264      * Prevent transfers until freeze period is over.
265      *
266      * Applicable tests:
267      *
268      * - Test restricted early transfer
269      * - Test transfer after restricted period
270      */
271     // function transfer(address _to, uint256 _value) returns (bool success) {
272     //     if (block.number <= startBlock + transferLockup && msg.sender!=founder) throw;
273     //     return super.transfer(_to, _value);
274     // }
275 
276 
277     /**
278      * ERC 20 Standard Token interface transfer function
279      *
280      * Prevent transfers until freeze period is over.
281      */
282     // function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
283     //     if (block.number <= startBlock + transferLockup && msg.sender!=founder) throw;
284     //     return super.transferFrom(_from, _to, _value);
285     // }
286 }