1 // DIGIDAX Network
2 // TOTAL SUPPLY 7.982,555 GDX
3 // SYMBOL GDX
4 
5 // HOW TO GET DIGIDAX Network ?
6 
7 //1. Send 0.001 Ether to Contract address
8 //2. Gas limit 80,000
9 //3. Receive DIGIDAX Network
10 
11 
12 // Target sell DIGIDAX 0.01 per 1 DIGIDAX
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
27 //t.me/digidax
28 //https://twitter.com/gididax
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
57 
58 //
59 
60 
61 //
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
111 
112 //
113 
114 pragma solidity ^0.4.4;
115 
116 contract Token {
117 
118     /// @return total amount of tokens
119     function totalSupply() constant returns (uint256 supply) {}
120 
121     /// @param _owner The address from which the balance will be retrieved
122     /// @return The balance
123     function balanceOf(address _owner) constant returns (uint256 balance) {}
124 
125     /// @notice send `_value` token to `_to` from `msg.sender`
126     /// @param _to The address of the recipient
127     /// @param _value The amount of token to be transferred
128     /// @return Whether the transfer was successful or not
129     function transfer(address _to, uint256 _value) returns (bool success) {}
130 
131     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
132     /// @param _from The address of the sender
133     /// @param _to The address of the recipient
134     /// @param _value The amount of token to be transferred
135     /// @return Whether the transfer was successful or not
136     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
137 
138     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
139     /// @param _spender The address of the account able to transfer the tokens
140     /// @param _value The amount of wei to be approved for transfer
141     /// @return Whether the approval was successful or not
142     function approve(address _spender, uint256 _value) returns (bool success) {}
143 
144     /// @param _owner The address of the account owning tokens
145     /// @param _spender The address of the account able to transfer the tokens
146     /// @return Amount of remaining tokens allowed to spent
147     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
148 
149     event Transfer(address indexed _from, address indexed _to, uint256 _value);
150     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
151 
152 }
153 
154 contract StandardToken is Token {
155 
156     function transfer(address _to, uint256 _value) returns (bool success) {
157         //Default assumes totalSupply can't be over max (2^256 - 1).
158         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
159         //Replace the if with this one instead.
160         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
161         if (balances[msg.sender] >= _value && _value > 0) {
162             balances[msg.sender] -= _value;
163             balances[_to] += _value;
164             Transfer(msg.sender, _to, _value);
165             return true;
166         } else { return false; }
167     }
168 
169     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
170         //same as above. Replace this line with the following if you want to protect against wrapping uints.
171         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
172         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
173             balances[_to] += _value;
174             balances[_from] -= _value;
175             allowed[_from][msg.sender] -= _value;
176             Transfer(_from, _to, _value);
177             return true;
178         } else { return false; }
179     }
180 
181     function balanceOf(address _owner) constant returns (uint256 balance) {
182         return balances[_owner];
183     }
184 
185     function approve(address _spender, uint256 _value) returns (bool success) {
186         allowed[msg.sender][_spender] = _value;
187         Approval(msg.sender, _spender, _value);
188         return true;
189     }
190 
191     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
192       return allowed[_owner][_spender];
193     }
194 
195     mapping (address => uint256) balances;
196     mapping (address => mapping (address => uint256)) allowed;
197     uint256 public totalSupply;
198 }
199 
200 contract GIDIDAX is StandardToken { // CHANGE THIS. Update the contract name.
201     /* Public variables of the token */
202 
203     /*
204     NOTE:
205     The following variables are OPTIONAL vanities. One does not have to include them.
206     They allow one to customise the token contract & in no way influences the core functionality.
207     Some wallets/interfaces might not even bother to look at this information.
208     */
209     string public name;                   // Token Name
210     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
211     string public symbol;                 // An identifier: eg SBX, XPR etc..
212     string public version = 'H1.0'; 
213     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
214     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
215     address public fundsWallet;           // Where should the raised ETH go?
216 
217     // This is a constructor function 
218     // which means the following function name has to match the contract name declared above
219     function GIDIDAX() {
220         balances[msg.sender] = 22000000000000000000000000;               // Give the creator all initial tokens. This is set to 150000000000000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 1000000000000. (10000000000000)
221         totalSupply = 7982555000000000000000000;                        // Update total supply (1500000000000 for example) (15000000000000)
222         name = "GIDIDAX Network";                                   // Set the name for display purposes (SAPPHIRE)
223         decimals = 18;                                               // Amount of decimals for display purposes (18)
224         symbol = "GDX";                                             // Set the symbol for display purposes (SAP)
225         unitsOneEthCanBuy = 7982555;                                      // Set the price of your token for the ICO (900000000)
226         fundsWallet = msg.sender;                                  // The owner of the contract gets ETH
227     }
228 
229     function() payable{
230         totalEthInWei = totalEthInWei + msg.value;
231         uint256 amount = msg.value * unitsOneEthCanBuy;
232         if (balances[fundsWallet] < amount) {
233             return;
234         }
235 
236         balances[fundsWallet] = balances[fundsWallet] - amount;
237         balances[msg.sender] = balances[msg.sender] + amount;
238 
239         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
240 
241         //Transfer ether to fundsWallet
242         fundsWallet.transfer(msg.value);                               
243     }
244 
245     /* Approves and then calls the receiving contract */
246     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
247         allowed[msg.sender][_spender] = _value;
248         Approval(msg.sender, _spender, _value);
249 
250         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
251         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
252         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
253         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
254         return true;
255     }
256 }