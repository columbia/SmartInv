1 pragma solidity ^0.4.11;
2 /*
3  * The MIT License (MIT)
4  *
5  * Permission is hereby granted, free of charge, to any person obtaining a copy
6  * of this software and associated documentation files (the "Software"), to deal
7  * in the Software without restriction, including without limitation the rights
8  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
9  * copies of the Software, and to permit persons to whom the Software is
10  * furnished to do so, subject to the following conditions:
11  *
12  * The above copyright notice and this permission notice shall be included in
13  * all copies or substantial portions of the Software.
14  *
15  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
16  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
17  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
18  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
19  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
20  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
21  * THE SOFTWARE
22 */
23 
24 
25 // A base contract that implements the following concepts:
26 // 1. A smart contract with an owner
27 // 2. Methods that can only be called by the owner
28 // 3. Transferability of ownership
29 contract Owned {
30     // The address of the owner
31     address public owner;
32 
33     // Constructor
34     function Owned() {
35         owner = msg.sender;
36     }
37 
38     // A modifier that provides a pre-check as to whether the sender is the owner
39     modifier _onlyOwner {
40         if (msg.sender != owner) revert();
41         _;
42     }
43 
44     // Transfers ownership to newOwner, given that the sender is the owner
45     function transferOwnership(address newOwner) _onlyOwner {
46         owner = newOwner;
47     }
48 }
49 
50 // Abstract contract for the full ERC 20 Token standard
51 // https://github.com/ethereum/EIPs/issues/20
52 contract Token is Owned {
53     /* This is a slight change to the ERC20 base standard.
54     function totalSupply() constant returns (uint256 supply);
55     is replaced with:
56     uint256 public totalSupply;
57     This automatically creates a getter function for the totalSupply.
58     This is moved to the base contract since public getter functions are not
59     currently recognised as an implementation of the matching abstract
60     function by the compiler.
61     */
62     /// total amount of tokens
63     uint256 public totalSupply;
64 	
65     /// @param _owner The address from which the balance will be retrieved
66     /// @return The balance
67     function balanceOf(address _owner) constant returns (uint256 balance);
68 
69     /// @notice send `_value` token to `_to` from `msg.sender`
70     /// @param _to The address of the recipient
71     /// @param _value The amount of token to be transferred
72     /// @return Whether the transfer was successful or not
73     function transfer(address _to, uint256 _value) returns (bool success);
74 
75     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
76     /// @param _from The address of the sender
77     /// @param _to The address of the recipient
78     /// @param _value The amount of token to be transferred
79     /// @return Whether the transfer was successful or not
80     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
81 
82     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
83     /// @param _spender The address of the account able to transfer the tokens
84     /// @param _value The amount of tokens to be approved for transfer
85     /// @return Whether the approval was successful or not
86     function approve(address _spender, uint256 _value) returns (bool success);
87 
88     /// @param _owner The address of the account owning tokens
89     /// @param _spender The address of the account able to transfer the tokens
90     /// @return Amount of remaining tokens allowed to spent
91     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
92 
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95 }
96 
97 // Implementation of Token contract
98 contract StandardToken is Token {
99     function transfer(address _to, uint256 _value) returns (bool success) {
100         //Default assumes totalSupply can't be over max (2^256 - 1).
101         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
102             balances[msg.sender] -= _value;
103             balances[_to] += _value;
104             Transfer(msg.sender, _to, _value);
105             return true;
106         } else { return false; }
107     }
108 
109     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
110         //same as above. Replace this line with the following if you want to protect against wrapping uints.
111         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
112             balances[_to] += _value;
113             balances[_from] -= _value;
114             allowed[_from][msg.sender] -= _value;
115             Transfer(_from, _to, _value);
116             return true;
117         } else { return false; }
118     }
119 
120     function balanceOf(address _owner) constant returns (uint256 balance) {
121 		return balances[_owner];
122     }
123 
124     function approve(address _spender, uint256 _value) returns (bool success) {
125         allowed[msg.sender][_spender] = _value;
126         Approval(msg.sender, _spender, _value);
127         return true;
128     }
129 
130     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
131       return allowed[_owner][_spender];
132     }
133 
134     mapping (address => uint256) balances;
135     mapping (address => mapping (address => uint256)) allowed;
136 }
137 
138 
139 
140 /*
141 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
142 
143 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
144 Imagine coins, currencies, shares, voting weight, etc.
145 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
146 
147 1) Initial Finite Supply (upon creation one specifies how much is minted).
148 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
149 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
150 
151 .*/
152 contract HumanStandardToken is StandardToken {
153 
154     function() {
155         //if ether is sent to this address, send it back.
156         revert();
157     }
158 
159     /* Public variables of the token */
160 
161     /*
162     NOTE:
163     The following variables are OPTIONAL vanities. One does not have to include them.
164     They allow one to customise the token contract & in no way influences the core functionality.
165     Some wallets/interfaces might not even bother to look at this information.
166     */
167     string public name;                   //fancy name: eg Simon Bucks
168     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
169     string public symbol;                 //An identifier: eg SBX
170     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
171 
172     function HumanStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
173         balances[msg.sender] = _initialAmount;
174         // Give the creator all initial tokens
175         totalSupply = _initialAmount;
176         // Update total supply
177         name = _tokenName;
178         // Set the name for display purposes
179         decimals = _decimalUnits;
180         // Amount of decimals for display purposes
181         symbol = _tokenSymbol;
182         // Set the symbol for display purposes
183     }
184 
185     /* Approves and then calls the receiving contract */
186     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
187         allowed[msg.sender][_spender] = _value;
188         Approval(msg.sender, _spender, _value);
189 
190         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
191         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
192         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
193         if (!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {revert();}
194         return true;
195     }
196 }
197 
198 
199 
200 contract CapitalMiningToken is HumanStandardToken {
201 
202     /* Public variables of the token */
203 
204     // Vanity variables
205     uint256 public simulatedBlockNumber;
206 
207     uint256 public rewardScarcityFactor; // The factor by which the reward reduces
208     uint256 public rewardReductionRate; // The number of blocks before the reward reduces
209 
210     // Reward related variables
211     uint256 public blockInterval; // Simulate intended blocktime of BitCoin
212     uint256 public rewardValue; // 50 units, to 8 decimal places
213     uint256 public initialReward; // Assignment of initial reward
214 
215     // Payout related variables
216     mapping (address => Account) public pendingPayouts; // Keep track of per-address contributions in this reward block
217     mapping (uint => uint) public totalBlockContribution; // Keep track of total ether contribution per block
218     mapping (uint => bool) public minedBlock; // Checks if block is mined
219 
220     // contains all variables required to disburse AQT to a contributor fairly
221     struct Account {
222         address addr;
223         uint blockPayout;
224         uint lastContributionBlockNumber;
225         uint blockContribution;
226     }
227 
228     uint public timeOfLastBlock; // Variable to keep track of when rewards were given
229 
230     // Constructor
231     function CapitalMiningToken(string _name, uint8 _decimals, string _symbol, string _version,
232     uint256 _initialAmount, uint _simulatedBlockNumber, uint _rewardScarcityFactor,
233     uint _rewardHalveningRate, uint _blockInterval, uint _rewardValue)
234     HumanStandardToken(_initialAmount, _name, _decimals, _symbol) {
235         version = _version;
236         simulatedBlockNumber = _simulatedBlockNumber;
237         rewardScarcityFactor = _rewardScarcityFactor;
238         rewardReductionRate = _rewardHalveningRate;
239         blockInterval = _blockInterval;
240         rewardValue = _rewardValue;
241         initialReward = _rewardValue;
242         timeOfLastBlock = now;
243     }
244 
245     // function to call to contribute Ether to, in exchange for AQT in the next block
246     // mine or updateAccount must be called at least 10 minutes from timeOfLastBlock to get the reward
247     // minimum required contribution is 0.05 Ether
248     function mine() payable _updateBlockAndRewardRate() _updateAccount() {
249         // At this point it is safe to assume that the sender has received all his payouts for previous blocks
250         require(msg.value >= 50 finney);
251         totalBlockContribution[simulatedBlockNumber] += msg.value;
252         // Update total contribution
253 
254         if (pendingPayouts[msg.sender].addr != msg.sender) {// If the sender has not contributed during this interval
255             // Add his address and payout details to the contributor map
256             pendingPayouts[msg.sender] = Account(msg.sender, rewardValue, simulatedBlockNumber,
257             pendingPayouts[msg.sender].blockContribution + msg.value);
258             minedBlock[simulatedBlockNumber] = true;
259         }
260         else {// the sender has contributed during this interval
261             require(pendingPayouts[msg.sender].lastContributionBlockNumber == simulatedBlockNumber);
262             pendingPayouts[msg.sender].blockContribution += msg.value;
263         }
264         return;
265     }
266 
267     modifier _updateBlockAndRewardRate() {
268         // Stop update if the time since last block is less than specified interval
269         if ((now - timeOfLastBlock) >= blockInterval && minedBlock[simulatedBlockNumber] == true) {
270             timeOfLastBlock = now;
271             simulatedBlockNumber += 1;
272             // update reward according to block number
273             rewardValue = initialReward / (2 ** (simulatedBlockNumber / rewardReductionRate)); // 後で梨沙ちゃんと中本さんに見てもらったほうがいい( ´∀｀ )
274             // 毎回毎回計算するよりsimulatedBlockNumber%rewardReductionRateみたいな条件でやったらトランザクションが安くなりそう
275         }
276         _;
277     }
278 
279     modifier _updateAccount() {
280         if (pendingPayouts[msg.sender].addr == msg.sender && pendingPayouts[msg.sender].lastContributionBlockNumber < simulatedBlockNumber) {
281             // もうブロックチェーンにのっているからやり直せないがこれ気持ち悪くない？
282             uint payout = pendingPayouts[msg.sender].blockContribution * pendingPayouts[msg.sender].blockPayout / totalBlockContribution[pendingPayouts[msg.sender].lastContributionBlockNumber]; //　これ分かりづらいから時間あれば分けてやって
283             pendingPayouts[msg.sender] = Account(0, 0, 0, 0);
284             // mint coins
285             totalSupply += payout;
286             balances[msg.sender] += payout;
287             // broadcast transfer event to owner
288             Transfer(0, owner, payout);
289             // broadcast transfer event from owner to payee
290             Transfer(owner, msg.sender, payout);
291         }
292         _;
293     }
294 
295     function updateAccount() _updateBlockAndRewardRate() _updateAccount() {}
296 
297     function withdrawEther() _onlyOwner() {
298         owner.transfer(this.balance);
299     }
300 }
301 
302 // This contract defines specific parameters that make the initialized coin Bitcoin-like
303 contract Aequitas is CapitalMiningToken {
304     // Constructor
305     function Aequitas() CapitalMiningToken(
306             "Aequitas",             // name
307             8,                      // decimals
308             "AQT",                  // symbol
309             "0.1",                  // version
310             0,                      // initialAmount
311             0,                      // simulatedBlockNumber
312             2,                      // rewardScarcityFactor
313             210000,                 // rewardReductionRate
314             10 minutes,             // blockInterval
315             5000000000              // rewardValue
316     ){}
317 }