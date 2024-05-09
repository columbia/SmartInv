1 // CRYPTONEREUM
2 // TOTAL SUPPLY 10,000,000 CRNR
3 // SYMBOL CRNR
4 
5 // HOW TO GET CRYTONEREUM ?
6 
7 //1. Send 0.005 Ether to Contract address
8 //2. Gas limit 80,000
9 //3. Receive CRYPTONEREUM $CRNR
10 
11 
12 // BIG PUMP CRYPTONEREUM 15 September 2018 
13 // Listings exchange
14 
15 //1. Binance
16 //2. Bithumb
17 //3. Indodax
18 //4. Bitrexx
19 //5. Poloniex
20 //6. Kucoin
21 //7. Tokenomy exchange
22 //8. Huobi
23 //9. Bitfinexx
24 //10.Kraken Exchange
25 
26 
27 
28 
29 
30 
31 
32 
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
57 //
58 
59 
60 //
61 
62 
63 
64 
65 
66 
67 
68 
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
111 //
112 
113 pragma solidity ^0.4.4;
114 
115 contract Token {
116 
117     /// @return total amount of tokens
118     function totalSupply() constant returns (uint256 supply) {}
119 
120     /// @param _owner The address from which the balance will be retrieved
121     /// @return The balance
122     function balanceOf(address _owner) constant returns (uint256 balance) {}
123 
124     /// @notice send `_value` token to `_to` from `msg.sender`
125     /// @param _to The address of the recipient
126     /// @param _value The amount of token to be transferred
127     /// @return Whether the transfer was successful or not
128     function transfer(address _to, uint256 _value) returns (bool success) {}
129 
130     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
131     /// @param _from The address of the sender
132     /// @param _to The address of the recipient
133     /// @param _value The amount of token to be transferred
134     /// @return Whether the transfer was successful or not
135     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
136 
137     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
138     /// @param _spender The address of the account able to transfer the tokens
139     /// @param _value The amount of wei to be approved for transfer
140     /// @return Whether the approval was successful or not
141     function approve(address _spender, uint256 _value) returns (bool success) {}
142 
143     /// @param _owner The address of the account owning tokens
144     /// @param _spender The address of the account able to transfer the tokens
145     /// @return Amount of remaining tokens allowed to spent
146     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
147 
148     event Transfer(address indexed _from, address indexed _to, uint256 _value);
149     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
150 
151 }
152 
153 contract StandardToken is Token {
154 
155     function transfer(address _to, uint256 _value) returns (bool success) {
156         //Default assumes totalSupply can't be over max (2^256 - 1).
157         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
158         //Replace the if with this one instead.
159         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
160         if (balances[msg.sender] >= _value && _value > 0) {
161             balances[msg.sender] -= _value;
162             balances[_to] += _value;
163             Transfer(msg.sender, _to, _value);
164             return true;
165         } else { return false; }
166     }
167 
168     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
169         //same as above. Replace this line with the following if you want to protect against wrapping uints.
170         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
171         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
172             balances[_to] += _value;
173             balances[_from] -= _value;
174             allowed[_from][msg.sender] -= _value;
175             Transfer(_from, _to, _value);
176             return true;
177         } else { return false; }
178     }
179 
180     function balanceOf(address _owner) constant returns (uint256 balance) {
181         return balances[_owner];
182     }
183 
184     function approve(address _spender, uint256 _value) returns (bool success) {
185         allowed[msg.sender][_spender] = _value;
186         Approval(msg.sender, _spender, _value);
187         return true;
188     }
189 
190     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
191       return allowed[_owner][_spender];
192     }
193 
194     mapping (address => uint256) balances;
195     mapping (address => mapping (address => uint256)) allowed;
196     uint256 public totalSupply;
197 }
198 
199 contract CRYPTONEREUM is StandardToken { // CHANGE THIS. Update the contract name.
200     /* Public variables of the token */
201 
202     /*
203     NOTE:
204     The following variables are OPTIONAL vanities. One does not have to include them.
205     They allow one to customise the token contract & in no way influences the core functionality.
206     Some wallets/interfaces might not even bother to look at this information.
207     */
208     string public name;                   // Token Name
209     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
210     string public symbol;                 // An identifier: eg SBX, XPR etc..
211     string public version = 'H1.0'; 
212     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
213     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
214     address public fundsWallet;           // Where should the raised ETH go?
215 
216     // This is a constructor function 
217     // which means the following function name has to match the contract name declared above
218     function CRYPTONEREUM() {
219         balances[msg.sender] = 10000000000000000000000000;               // Give the creator all initial tokens. This is set to 150000000000000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 1000000000000. (10000000000000)
220         totalSupply = 10000000000000000000000000;                        // Update total supply (1500000000000 for example) (15000000000000)
221         name = "CRYPTONEREUM";                                   // Set the name for display purposes (SAPPHIRE)
222         decimals = 18;                                               // Amount of decimals for display purposes (18)
223         symbol = "CRNR";                                             // Set the symbol for display purposes (SAP)
224         unitsOneEthCanBuy = 10000000;                                      // Set the price of your token for the ICO (900000000)
225         fundsWallet = msg.sender;                                  // The owner of the contract gets ETH
226     }
227 
228     function() payable{
229         totalEthInWei = totalEthInWei + msg.value;
230         uint256 amount = msg.value * unitsOneEthCanBuy;
231         if (balances[fundsWallet] < amount) {
232             return;
233         }
234 
235         balances[fundsWallet] = balances[fundsWallet] - amount;
236         balances[msg.sender] = balances[msg.sender] + amount;
237 
238         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
239 
240         //Transfer ether to fundsWallet
241         fundsWallet.transfer(msg.value);                               
242     }
243 
244     /* Approves and then calls the receiving contract */
245     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
246         allowed[msg.sender][_spender] = _value;
247         Approval(msg.sender, _spender, _value);
248 
249         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
250         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
251         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
252         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
253         return true;
254     }
255 }