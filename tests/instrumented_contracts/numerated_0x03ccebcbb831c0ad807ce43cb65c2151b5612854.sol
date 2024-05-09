1 pragma solidity ^0.4.4;
2 
3  
4 
5 contract Token {
6 
7  
8 
9     /// @return total amount of tokens
10 
11     function totalSupply() constant returns (uint256 supply) {}
12 
13  
14 
15     /// @param _owner The address from which the balance will be retrieved
16 
17     /// @return The balance
18 
19     function balanceOf(address _owner) constant returns (uint256 balance) {}
20 
21  
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24 
25     /// @param _to The address of the recipient
26 
27     /// @param _value The amount of token to be transferred
28 
29     /// @return Whether the transfer was successful or not
30 
31     function transfer(address _to, uint256 _value) returns (bool success) {}
32 
33  
34 
35     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
36 
37     /// @param _from The address of the sender
38 
39     /// @param _to The address of the recipient
40 
41     /// @param _value The amount of token to be transferred
42 
43     /// @return Whether the transfer was successful or not
44 
45     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
46 
47  
48 
49     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
50 
51     /// @param _spender The address of the account able to transfer the tokens
52 
53     /// @param _value The amount of wei to be approved for transfer
54 
55     /// @return Whether the approval was successful or not
56 
57     function approve(address _spender, uint256 _value) returns (bool success) {}
58 
59  
60 
61     /// @param _owner The address of the account owning tokens
62 
63     /// @param _spender The address of the account able to transfer the tokens
64 
65     /// @return Amount of remaining tokens allowed to spent
66 
67     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
68 
69  
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72 
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74 
75  
76 
77 }
78 
79  
80 
81 contract StandardToken is Token {
82 
83  
84 
85     function transfer(address _to, uint256 _value) returns (bool success) {
86 
87         //Default assumes totalSupply can't be over max (2^256 - 1).
88 
89         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
90 
91         //Replace the if with this one instead.
92 
93         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
94 
95         if (balances[msg.sender] >= _value && _value > 0) {
96 
97             balances[msg.sender] -= _value;
98 
99             balances[_to] += _value;
100 
101             Transfer(msg.sender, _to, _value);
102 
103             return true;
104 
105         } else { return false; }
106 
107     }
108 
109  
110 
111     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
112 
113         //same as above. Replace this line with the following if you want to protect against wrapping uints.
114 
115         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
116 
117         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
118 
119             balances[_to] += _value;
120 
121             balances[_from] -= _value;
122 
123             allowed[_from][msg.sender] -= _value;
124 
125             Transfer(_from, _to, _value);
126 
127             return true;
128 
129         } else { return false; }
130 
131     }
132 
133  
134 
135     function balanceOf(address _owner) constant returns (uint256 balance) {
136 
137         return balances[_owner];
138 
139     }
140 
141  
142 
143     function approve(address _spender, uint256 _value) returns (bool success) {
144 
145         allowed[msg.sender][_spender] = _value;
146 
147         Approval(msg.sender, _spender, _value);
148 
149         return true;
150 
151     }
152 
153  
154 
155     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
156 
157       return allowed[_owner][_spender];
158 
159     }
160 
161  
162 
163     mapping (address => uint256) balances;
164 
165     mapping (address => mapping (address => uint256)) allowed;
166 
167     uint256 public totalSupply;
168 
169 }
170 
171  
172 
173 contract SitcomToken is StandardToken { // CHANGE THIS. Update the contract name.
174 
175  
176 
177     /* Public variables of the token */
178 
179  
180 
181     /*
182 
183     NOTE:
184 
185     The following variables are OPTIONAL vanities. One does not have to include them.
186 
187     They allow one to customise the token contract & in no way influences the core functionality.
188 
189     Some wallets/interfaces might not even bother to look at this information.
190 
191     */
192 
193     string public name;                   // Token Name
194 
195     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
196 
197     string public symbol;                 // An identifier: eg SBX, XPR etc..
198 
199     string public version = 'H1.0';
200 
201     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
202 
203     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here. 
204 
205     address public fundsWallet;           // Where should the raised ETH go?
206 
207     uint256 public totalSupply;
208 
209  
210 
211  
212 
213     // This is a constructor function
214 
215     // which means the following function name has to match the contract name declared above
216 
217     function SitcomToken() {
218 
219         balances[msg.sender] = 5000000000000000000000000000;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
220 
221         totalSupply = 5000000000000000000000000000;                        // Update total supply (1000 for example) (CHANGE THIS)
222 
223         name = "Sitcom Token";                                   // Set the name for display purposes (CHANGE THIS)
224 
225         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
226 
227         symbol = "STC";                                             // Set the symbol for display purposes (CHANGE THIS)
228 
229         unitsOneEthCanBuy = 22222222;                                      // Set the price of your token for the ICO (CHANGE THIS)
230 
231         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
232 
233     }
234 
235  
236 
237     function() payable{
238 
239         totalEthInWei = totalEthInWei + msg.value;
240 
241         uint256 amount = msg.value * unitsOneEthCanBuy;
242 
243        if (balances[fundsWallet] < amount) {
244 
245             return;
246 
247         }
248 
249  
250 
251         balances[fundsWallet] = balances[fundsWallet] - amount;
252 
253         balances[msg.sender] = balances[msg.sender] + amount;
254 
255  
256 
257         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
258 
259  
260 
261         //Transfer ether to fundsWallet
262 
263         fundsWallet.transfer(msg.value);                              
264 
265     }
266 
267  
268 
269     /* Approves and then calls the receiving contract */
270 
271     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
272 
273         allowed[msg.sender][_spender] = _value;
274 
275         Approval(msg.sender, _spender, _value);
276 
277  
278 
279         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
280 
281         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
282 
283         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
284 
285         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
286 
287         return true;
288 
289     }
290 
291 }