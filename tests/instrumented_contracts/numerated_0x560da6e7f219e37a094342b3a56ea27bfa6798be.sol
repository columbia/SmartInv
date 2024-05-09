1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Token {
30 
31     /// @return total amount of tokens
32     function totalSupply() constant returns (uint256 supply) {}
33 
34     /// @param _owner The address from which the balance will be retrieved
35     /// @return The balance
36     function balanceOf(address _owner) constant returns (uint256 balance) {}
37 
38     /// @notice send `_value` token to `_to` from `msg.sender`
39     /// @param _to The address of the recipient
40     /// @param _value The amount of token to be transferred
41     /// @return Whether the transfer was successful or not
42     function transfer(address _to, uint256 _value) returns (bool success) {}
43 
44     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
45     /// @param _from The address of the sender
46     /// @param _to The address of the recipient
47     /// @param _value The amount of token to be transferred
48     /// @return Whether the transfer was successful or not
49     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
50 
51     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
52     /// @param _spender The address of the account able to transfer the tokens
53     /// @param _value The amount of wei to be approved for transfer
54     /// @return Whether the approval was successful or not
55     function approve(address _spender, uint256 _value) returns (bool success) {}
56 
57     /// @param _owner The address of the account owning tokens
58     /// @param _spender The address of the account able to transfer the tokens
59     /// @return Amount of remaining tokens allowed to spent
60     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
61 
62     event Transfer(address indexed _from, address indexed _to, uint256 _value);
63     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64     
65 }
66 
67 
68 
69 contract StandardToken is Token {
70 
71     function transfer(address _to, uint256 _value) returns (bool success) {
72         //Default assumes totalSupply can't be over max (2^256 - 1).
73         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
74         //Replace the if with this one instead.
75         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
76         if (balances[msg.sender] >= _value && _value > 0) {
77             balances[msg.sender] -= _value;
78             balances[_to] += _value;
79             Transfer(msg.sender, _to, _value);
80             return true;
81         } else { return false; }
82     }
83 
84     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
85         //same as above. Replace this line with the following if you want to protect against wrapping uints.
86         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
87         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
88             balances[_to] += _value;
89             balances[_from] -= _value;
90             allowed[_from][msg.sender] -= _value;
91             Transfer(_from, _to, _value);
92             return true;
93         } else { return false; }
94     }
95 
96     function balanceOf(address _owner) constant returns (uint256 balance) {
97         return balances[_owner];
98     }
99 
100     function approve(address _spender, uint256 _value) returns (bool success) {
101         allowed[msg.sender][_spender] = _value;
102         Approval(msg.sender, _spender, _value);
103         return true;
104     }
105 
106     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
107       return allowed[_owner][_spender];
108     }
109 
110     mapping (address => uint256) balances;
111     mapping (address => mapping (address => uint256)) allowed;
112     uint256 public totalSupply;
113 }
114 
115 
116 //name this contract whatever you'd like
117 contract FarmCoin is StandardToken {
118 
119    
120     /* Public variables of the token */
121 
122     /*
123     NOTE:
124     The following variables are OPTIONAL vanities. One does not have to include them.
125     They allow one to customise the token contract & in no way influences the core functionality.
126     Some wallets/interfaces might not even bother to look at this information.
127     */
128     string public name = 'FarmCoin';                   //fancy name: eg Simon Bucks
129     uint8 public decimals = 18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
130     string public symbol = 'FARM';                 //An identifier: eg SBX
131     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
132 
133 //
134 // CHANGE THESE VALUES FOR YOUR TOKEN
135 //
136 
137 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
138 
139     function FarmCoin(
140         ) {
141         balances[msg.sender] = 5000000000000000000000000;               // Give the creator all initial tokens (100000 for example)
142         totalSupply = 5000000000000000000000000;                        // Update total supply (100000 for example)
143         name = "FarmCoin";                                   // Set the name for display purposes
144         decimals = 18;                            // Amount of decimals for display purposes
145         symbol = "FARM";                               // Set the symbol for display purposes
146     }
147 
148     /* Approves and then calls the receiving contract */
149     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
150         allowed[msg.sender][_spender] = _value;
151         Approval(msg.sender, _spender, _value);
152 
153         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
154         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
155         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
156         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert; }
157         return true;
158     }
159 }
160 
161 contract FarmCoinSale is FarmCoin {
162 
163     uint256 public maxMintable;
164     uint256 public totalMinted;
165     uint256 public decimals = 18;
166     uint public endBlock;
167     uint public startBlock;
168     uint256 public exchangeRate;
169     uint public startTime;
170     bool public isFunding;
171     address public ETHWallet;
172     uint256 public heldTotal;
173 
174     bool private configSet;
175     address public creator;
176 
177     mapping (address => uint256) public heldTokens;
178     mapping (address => uint) public heldTimeline;
179 
180     event Contribution(address from, uint256 amount);
181     event ReleaseTokens(address from, uint256 amount);
182 
183 // start and end dates where crowdsale is allowed (both inclusive)
184   uint256 constant public START = 1517461200000; // +new Date(2018, 2, 1) / 1000
185   uint256 constant public END = 1522555200000; // +new Date(2018, 4, 1) / 1000
186 
187 // @return the rate in FARM per 1 ETH according to the time of the tx and the FARM pricing program.
188     // @Override
189   function getRate() constant returns (uint256 rate) {
190     if      (now < START)            return rate = 840; // presale, 40% bonus
191     else if (now <= START +  6 days) return rate = 810; // day 1 to 6, 35% bonus
192     else if (now <= START + 13 days) return rate = 780; // day 7 to 13, 30% bonus
193     else if (now <= START + 20 days) return rate = 750; // day 14 to 20, 25% bonus
194     else if (now <= START + 28 days) return rate = 720; // day 21 to 28, 20% bonus
195     return rate = 600; // no bonus
196   }
197 
198 
199     function FarmCoinSale() {
200         startBlock = block.number;
201         maxMintable = 5000000000000000000000000; // 3 million max sellable (18 decimals)
202         ETHWallet = 0x3b444fC8c2C45DCa5e6610E49dC54423c5Dcd86E;
203         isFunding = true;
204         
205         creator = msg.sender;
206         createHeldCoins();
207         startTime = 1517461200000;
208         exchangeRate= 600;
209         }
210 
211  
212     // setup function to be ran only 1 time
213     // setup token address
214     // setup end Block number
215     function setup(address TOKEN, uint endBlockTime) {
216         require(!configSet);
217         endBlock = endBlockTime;
218         configSet = true;
219     }
220 
221     function closeSale() external {
222       require(msg.sender==creator);
223       isFunding = false;
224     }
225 
226     // CONTRIBUTE FUNCTION
227     // converts ETH to TOKEN and sends new TOKEN to the sender
228     function contribute() external payable {
229         require(msg.value>0);
230         require(isFunding);
231         require(block.number <= endBlock);
232         uint256 amount = msg.value * exchangeRate;
233         uint256 total = totalMinted + amount;
234         require(total<=maxMintable);
235         totalMinted += total;
236         ETHWallet.transfer(msg.value);
237         Contribution(msg.sender, amount);
238     }
239 
240     function deposit() payable {
241       create(msg.sender);
242     }
243     function register(address sender) payable {
244     }
245     function () payable {
246     }
247   
248     function create(address _beneficiary) payable{
249     uint256 amount = msg.value;
250     /// 
251     }
252 
253      // Send `tokens` amount of tokens from address `from` to address `to`
254      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
255      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
256      // fees in sub-currencies; the command should fail unless the _from account has
257      // deliberately authorized the sender of the message via some mechanism; we propose
258      // these standardized APIs for approval:
259      function transferFrom(address from, address to, uint _value) public returns (bool success) {
260                  Transfer(from, to, _value);
261          return true;
262      }
263     // update the ETH/COIN rate
264     function updateRate(uint256 rate) external {
265         require(msg.sender==creator);
266         require(isFunding);
267         exchangeRate = rate;
268     }
269 
270     // change creator address
271     function changeCreator(address _creator) external {
272         require(msg.sender==creator);
273         creator = _creator;
274     }
275 
276     // change transfer status for FarmCoin token
277     function changeTransferStats(bool _allowed) external {
278         require(msg.sender==creator);
279      }
280 
281     // internal function that allocates a specific amount of ATYX at a specific block number.
282     // only ran 1 time on initialization
283     function createHeldCoins() internal {
284         // TOTAL SUPPLY = 5,000,000
285         createHoldToken(msg.sender, 1000);
286         createHoldToken(0xd9710D829fa7c36E025011b801664009E4e7c69D, 100000000000000000000000);
287         createHoldToken(0xd9710D829fa7c36E025011b801664009E4e7c69D, 100000000000000000000000);
288     }
289 
290     // function to create held tokens for developer
291     function createHoldToken(address _to, uint256 amount) internal {
292         heldTokens[_to] = amount;
293         heldTimeline[_to] = block.number + 0;
294         heldTotal += amount;
295         totalMinted += heldTotal;
296     }
297 
298     // function to release held tokens for developers
299     function releaseHeldCoins() external {
300         uint256 held = heldTokens[msg.sender];
301         uint heldBlock = heldTimeline[msg.sender];
302         require(!isFunding);
303         require(held >= 0);
304         require(block.number >= heldBlock);
305         heldTokens[msg.sender] = 0;
306         heldTimeline[msg.sender] = 0;
307         ReleaseTokens(msg.sender, held);
308     }
309 
310 
311 }