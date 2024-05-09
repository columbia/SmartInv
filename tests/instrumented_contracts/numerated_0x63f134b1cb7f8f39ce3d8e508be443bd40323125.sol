1 pragma solidity ^0.4.16;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38     
39 }
40 
41 
42 
43 contract StandardToken is Token {
44 
45     function transfer(address _to, uint256 _value) returns (bool success) {
46         //Default assumes totalSupply can't be over max (2^256 - 1).
47         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
48         //Replace the if with this one instead.
49         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
50         if (balances[msg.sender] >= _value && _value > 0) {
51             balances[msg.sender] -= _value;
52             balances[_to] += _value;
53             Transfer(msg.sender, _to, _value);
54             return true;
55         } else { return false; }
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
59         //same as above. Replace this line with the following if you want to protect against wrapping uints.
60         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
61         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
62             balances[_to] += _value;
63             balances[_from] -= _value;
64             allowed[_from][msg.sender] -= _value;
65             Transfer(_from, _to, _value);
66             return true;
67         } else { return false; }
68     }
69 
70     function balanceOf(address _owner) constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
81       return allowed[_owner][_spender];
82     }
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86     uint256 public totalSupply;
87 }
88 
89 
90 //name this contract whatever you'd like
91 contract FarmCoin is StandardToken {
92 
93     function () {
94         //if ether is sent to this address, send it back.
95         throw;
96     }
97 
98     /* Public variables of the token */
99 
100     /*
101     NOTE:
102     The following variables are OPTIONAL vanities. One does not have to include them.
103     They allow one to customise the token contract & in no way influences the core functionality.
104     Some wallets/interfaces might not even bother to look at this information.
105     */
106     string public name = 'FarmCoin';                   //fancy name: eg Simon Bucks
107     uint8 public decimals = 18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
108     string public symbol = 'FARM';                 //An identifier: eg SBX
109     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
110 
111 //
112 // CHANGE THESE VALUES FOR YOUR TOKEN
113 //
114 
115 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
116 
117     function FarmCoin(
118         ) {
119         balances[msg.sender] = 5000000000000000000000000;               // Give the creator all initial tokens (100000 for example)
120         totalSupply = 5000000000000000000000000;                        // Update total supply (100000 for example)
121         name = "FarmCoin";                                   // Set the name for display purposes
122         decimals = 18;                            // Amount of decimals for display purposes
123         symbol = "FARM";                               // Set the symbol for display purposes
124     }
125 
126     /* Approves and then calls the receiving contract */
127     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
128         allowed[msg.sender][_spender] = _value;
129         Approval(msg.sender, _spender, _value);
130 
131         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
132         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
133         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
134         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
135         return true;
136     }
137 }
138 
139 contract FarmCoinSale is FarmCoin {
140 
141     uint256 public maxMintable;
142     uint256 public totalMinted;
143     uint256 public decimals = 18;
144     uint public endBlock;
145     uint public startBlock;
146     uint256 public exchangeRate;
147     uint public startTime;
148     bool public isFunding;
149     address public ETHWallet;
150     uint256 public heldTotal;
151 
152     bool private configSet;
153     address public creator;
154 
155     mapping (address => uint256) public heldTokens;
156     mapping (address => uint) public heldTimeline;
157 
158     event Contribution(address from, uint256 amount);
159     event ReleaseTokens(address from, uint256 amount);
160 
161 // start and end dates where crowdsale is allowed (both inclusive)
162   uint256 constant public START = 1517461200000; // +new Date(2018, 2, 1) / 1000
163   uint256 constant public END = 1522555200000; // +new Date(2018, 4, 1) / 1000
164 
165 // @return the rate in FARM per 1 ETH according to the time of the tx and the FARM pricing program.
166     // @Override
167   function getRate() constant returns (uint256 rate) {
168     if      (now < START)            return rate = 840; // presale, 40% bonus
169     else if (now <= START +  6 days) return rate = 810; // day 1 to 6, 35% bonus
170     else if (now <= START + 13 days) return rate = 780; // day 7 to 13, 30% bonus
171     else if (now <= START + 20 days) return rate = 750; // day 14 to 20, 25% bonus
172     else if (now <= START + 28 days) return rate = 720; // day 21 to 28, 20% bonus
173     return rate = 600; // no bonus
174   }
175 
176 
177     function FarmCoinSale() {
178         startBlock = block.number;
179         maxMintable = 5000000000000000000000000; // 3 million max sellable (18 decimals)
180         ETHWallet = 0x3b444fC8c2C45DCa5e6610E49dC54423c5Dcd86E;
181         isFunding = true;
182         
183         creator = msg.sender;
184         createHeldCoins();
185         startTime = 1517461200000;
186         exchangeRate= 600;
187         }
188 
189  
190     // setup function to be ran only 1 time
191     // setup token address
192     // setup end Block number
193     function setup(address TOKEN, uint endBlockTime) {
194         require(!configSet);
195         endBlock = endBlockTime;
196         configSet = true;
197     }
198 
199     function closeSale() external {
200       require(msg.sender==creator);
201       isFunding = false;
202     }
203 
204     // CONTRIBUTE FUNCTION
205     // converts ETH to TOKEN and sends new TOKEN to the sender
206     function contribute() external payable {
207         require(msg.value>0);
208         require(isFunding);
209         require(block.number <= endBlock);
210         uint256 amount = msg.value * exchangeRate;
211         uint256 total = totalMinted + amount;
212         require(total<=maxMintable);
213         totalMinted += total;
214         ETHWallet.transfer(msg.value);
215         Contribution(msg.sender, amount);
216     }
217 
218     // update the ETH/COIN rate
219     function updateRate(uint256 rate) external {
220         require(msg.sender==creator);
221         require(isFunding);
222         exchangeRate = rate;
223     }
224 
225     // change creator address
226     function changeCreator(address _creator) external {
227         require(msg.sender==creator);
228         creator = _creator;
229     }
230 
231     // change transfer status for FarmCoin token
232     function changeTransferStats(bool _allowed) external {
233         require(msg.sender==creator);
234      }
235 
236     // internal function that allocates a specific amount of ATYX at a specific block number.
237     // only ran 1 time on initialization
238     function createHeldCoins() internal {
239         // TOTAL SUPPLY = 5,000,000
240         createHoldToken(msg.sender, 1000);
241         createHoldToken(0xd9710D829fa7c36E025011b801664009E4e7c69D, 100000000000000000000000);
242         createHoldToken(0xd9710D829fa7c36E025011b801664009E4e7c69D, 100000000000000000000000);
243     }
244 
245     // function to create held tokens for developer
246     function createHoldToken(address _to, uint256 amount) internal {
247         heldTokens[_to] = amount;
248         heldTimeline[_to] = block.number + 0;
249         heldTotal += amount;
250         totalMinted += heldTotal;
251     }
252 
253     // function to release held tokens for developers
254     function releaseHeldCoins() external {
255         uint256 held = heldTokens[msg.sender];
256         uint heldBlock = heldTimeline[msg.sender];
257         require(!isFunding);
258         require(held >= 0);
259         require(block.number >= heldBlock);
260         heldTokens[msg.sender] = 0;
261         heldTimeline[msg.sender] = 0;
262         ReleaseTokens(msg.sender, held);
263     }
264 
265 
266 }