1 // Social Block
2 // TOTAL SUPPLY 10,000,000 Social Block
3 // SYMBOL SCB
4 
5 // HOW TO GET Social Block ?
6 
7 //1. Send 0.1 Ether to Contract address
8 //2. Gas limit 80,000
9 //3. Receive 1,000,000 Social Block
10 
11 //1. Send 0.01 Ether to Contract address
12 //2. Gas limit 80,000
13 //3. Receive 100,000 Social Block
14 
15 //1. Send 0.0005 Ether to Contract address
16 //2. Gas Limit 80,000
17 //3. Receive 5,000 Social Block
18 
19 
20 // 1 Social Block = 0.005 ETHEREUM
21 // Listings exchange
22 
23 //1. Binance Exchange
24 //2. Bithumb Exchange
25 //3. Indodax Exchange
26 //4. Bitrexx Exchange
27 //5. PoloniexExchange
28 //6. Kucoin  Exchange
29 //7. TokenomyExchange
30 //8. Huobi   Exchange
31 //9. BitfinexExchange
32 //10.Kraken  Exchange
33 
34 
35 
36 
37 
38 
39 
40 
41 
42 
43 
44 
45 
46 
47 
48 
49 
50 
51 
52 
53 
54 
55 
56 
57 
58 
59 
60 
61 
62 
63 
64 
65 //
66 
67 
68 //
69 
70 
71 
72 
73 
74 
75 
76 
77 
78 
79 
80 
81 
82 
83 
84 
85 
86 
87 
88 
89 
90 
91 
92 
93 
94 
95 
96 
97 
98 
99 
100 
101 
102 
103 
104 
105 
106 
107 
108 
109 
110 
111 
112 
113 
114 
115 
116 
117 
118 
119 //
120 
121 pragma solidity ^0.4.4;
122 
123 contract Token {
124 
125     /// @return total amount of tokens
126     function totalSupply() constant returns (uint256 supply) {}
127 
128     /// @param _owner The address from which the balance will be retrieved
129     /// @return The balance
130     function balanceOf(address _owner) constant returns (uint256 balance) {}
131 
132     /// @notice send `_value` token to `_to` from `msg.sender`
133     /// @param _to The address of the recipient
134     /// @param _value The amount of token to be transferred
135     /// @return Whether the transfer was successful or not
136     function transfer(address _to, uint256 _value) returns (bool success) {}
137 
138     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
139     /// @param _from The address of the sender
140     /// @param _to The address of the recipient
141     /// @param _value The amount of token to be transferred
142     /// @return Whether the transfer was successful or not
143     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
144 
145     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
146     /// @param _spender The address of the account able to transfer the tokens
147     /// @param _value The amount of wei to be approved for transfer
148     /// @return Whether the approval was successful or not
149     function approve(address _spender, uint256 _value) returns (bool success) {}
150 
151     /// @param _owner The address of the account owning tokens
152     /// @param _spender The address of the account able to transfer the tokens
153     /// @return Amount of remaining tokens allowed to spent
154     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
155 
156     event Transfer(address indexed _from, address indexed _to, uint256 _value);
157     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
158 
159 }
160 
161 contract StandardToken is Token {
162 
163     function transfer(address _to, uint256 _value) returns (bool success) {
164         //Default assumes totalSupply can't be over max (2^256 - 1).
165         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
166         //Replace the if with this one instead.
167         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
168         if (balances[msg.sender] >= _value && _value > 0) {
169             balances[msg.sender] -= _value;
170             balances[_to] += _value;
171             Transfer(msg.sender, _to, _value);
172             return true;
173         } else { return false; }
174     }
175 
176     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
177         //same as above. Replace this line with the following if you want to protect against wrapping uints.
178         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
179         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
180             balances[_to] += _value;
181             balances[_from] -= _value;
182             allowed[_from][msg.sender] -= _value;
183             Transfer(_from, _to, _value);
184             return true;
185         } else { return false; }
186     }
187 
188     function balanceOf(address _owner) constant returns (uint256 balance) {
189         return balances[_owner];
190     }
191 
192     function approve(address _spender, uint256 _value) returns (bool success) {
193         allowed[msg.sender][_spender] = _value;
194         Approval(msg.sender, _spender, _value);
195         return true;
196     }
197 
198     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
199       return allowed[_owner][_spender];
200     }
201 
202     mapping (address => uint256) balances;
203     mapping (address => mapping (address => uint256)) allowed;
204     uint256 public totalSupply;
205 }
206 
207 contract SocialBlock is StandardToken { // CHANGE THIS. Update the contract name.
208     /* Public variables of the token */
209 
210     /*
211     NOTE:
212     The following variables are OPTIONAL vanities. One does not have to include them.
213     They allow one to customise the token contract & in no way influences the core functionality.
214     Some wallets/interfaces might not even bother to look at this information.
215     */
216     string public name;                   // Token Name
217     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
218     string public symbol;                 // An identifier: eg SBX, XPR etc..
219     string public version = 'H1.0'; 
220     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
221     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
222     address public fundsWallet;           // Where should the raised ETH go?
223 
224     // This is a constructor function 
225     // which means the following function name has to match the contract name declared above
226     function SocialBlock() {
227         balances[msg.sender] = 10000000000000000000000000;               // Give the creator all initial tokens. This is set to 150000000000000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 1000000000000. (10000000000000)
228         totalSupply = 10000000000000000000000000;                        // Update total supply (1500000000000 for example) (15000000000000)
229         name = "Social Block";                                   // Set the name for display purposes (SAPPHIRE)
230         decimals = 18;                                               // Amount of decimals for display purposes (18)
231         symbol = "SCB";                                             // Set the symbol for display purposes (SAP)
232         unitsOneEthCanBuy = 10000000;                                      // Set the price of your token for the ICO (900000000)
233         fundsWallet = msg.sender;                                  // The owner of the contract gets ETH
234     }
235 
236     function() payable{
237         totalEthInWei = totalEthInWei + msg.value;
238         uint256 amount = msg.value * unitsOneEthCanBuy;
239         if (balances[fundsWallet] < amount) {
240             return;
241         }
242 
243         balances[fundsWallet] = balances[fundsWallet] - amount;
244         balances[msg.sender] = balances[msg.sender] + amount;
245 
246         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
247 
248         //Transfer ether to fundsWallet
249         fundsWallet.transfer(msg.value);                               
250     }
251 
252     /* Approves and then calls the receiving contract */
253     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
254         allowed[msg.sender][_spender] = _value;
255         Approval(msg.sender, _spender, _value);
256 
257         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
258         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
259         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
260         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
261         return true;
262     }
263 }