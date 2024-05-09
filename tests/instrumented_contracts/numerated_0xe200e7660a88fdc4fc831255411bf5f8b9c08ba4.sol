1 pragma solidity ^0.4.15;
2 
3 contract Owned {
4 
5     // The address of the account that is the current owner 
6     address public owner;
7 
8     // The publiser is the inital owner
9     function Owned() {
10         owner = msg.sender;
11     }
12 
13     /**
14      * Access is restricted to the current owner
15      */
16     modifier onlyOwner() {
17         require(msg.sender == owner);
18 
19         _;
20     }
21 
22     /**
23      * Transfer ownership to `_newOwner`
24      *
25      * @param _newOwner The address of the account that will become the new owner 
26      */
27     function transferOwnership(address _newOwner) onlyOwner {
28         owner = _newOwner;
29     }
30 }
31 
32 // Abstract contract for the full ERC 20 Token standard
33 // https://github.com/ethereum/EIPs/issues/20
34 contract Token {
35     /* This is a slight change to the ERC20 base standard.
36     function totalSupply() constant returns (uint256 supply);
37     is replaced with:
38     uint256 public totalSupply;
39     This automatically creates a getter function for the totalSupply.
40     This is moved to the base contract since public getter functions are not
41     currently recognised as an implementation of the matching abstract
42     function by the compiler.
43     */
44     /// total amount of tokens
45     uint256 public totalSupply;
46 
47     /// @param _owner The address from which the balance will be retrieved
48     /// @return The balance
49     function balanceOf(address _owner) constant returns (uint256 balance);
50 
51     /// @notice send `_value` token to `_to` from `msg.sender`
52     /// @param _to The address of the recipient
53     /// @param _value The amount of token to be transferred
54     /// @return Whether the transfer was successful or not
55     function transfer(address _to, uint256 _value) returns (bool success);
56 
57     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
58     /// @param _from The address of the sender
59     /// @param _to The address of the recipient
60     /// @param _value The amount of token to be transferred
61     /// @return Whether the transfer was successful or not
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
63 
64     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
65     /// @param _spender The address of the account able to transfer the tokens
66     /// @param _value The amount of tokens to be approved for transfer
67     /// @return Whether the approval was successful or not
68     function approve(address _spender, uint256 _value) returns (bool success);
69 
70     /// @param _owner The address of the account owning tokens
71     /// @param _spender The address of the account able to transfer the tokens
72     /// @return Amount of remaining tokens allowed to spent
73     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
74 
75     event Transfer(address indexed _from, address indexed _to, uint256 _value);
76     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77 }
78 
79 /**
80  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
81  *
82  * Modified version of https://github.com/ConsenSys/Tokens that implements the 
83  * original Token contract, an abstract contract for the full ERC 20 Token standard
84  */
85 contract StandardToken is Token {
86     
87     // Token starts if the locked state restricting transfers
88     bool public locked;
89 
90     // DCORP token balances
91     mapping (address => uint256) balances;
92 
93     // DCORP token allowances
94     mapping (address => mapping (address => uint256)) allowed;
95 
96 
97     /**
98      * ERC20 Short Address Attack fix
99      */
100     modifier onlyPayloadSize(uint numArgs) {
101         assert(msg.data.length >= numArgs * 32 + 4);
102         _;
103     }
104     
105 
106     /** 
107      * Get balance of `_owner` 
108      * 
109      * @param _owner The address from which the balance will be retrieved
110      * @return The balance
111      */
112     function balanceOf(address _owner) constant returns (uint256 balance) {
113         return balances[_owner];
114     }
115 
116 
117     /** 
118      * Send `_value` token to `_to` from `msg.sender`
119      * 
120      * @param _to The address of the recipient
121      * @param _value The amount of token to be transferred
122      * @return Whether the transfer was successful or not
123      */
124     function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool success) {
125 
126         // Unable to transfer while still locked
127         require(!locked);
128 
129         // Check if the sender has enough tokens
130         require(balances[msg.sender] >= _value);   
131 
132         // Check for overflows
133         require(balances[_to] + _value > balances[_to]);
134 
135         // Transfer tokens
136         balances[msg.sender] -= _value;
137         balances[_to] += _value;
138 
139         // Notify listners
140         Transfer(msg.sender, _to, _value);
141         return true;
142     }
143 
144 
145     /** 
146      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
147      * 
148      * @param _from The address of the sender
149      * @param _to The address of the recipient
150      * @param _value The amount of token to be transferred
151      * @return Whether the transfer was successful or not
152      */
153     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool success) {
154 
155         // Unable to transfer while still locked
156         require(!locked);
157 
158         // Check if the sender has enough
159         require(balances[_from] >= _value);
160 
161         // Check for overflows
162         require(balances[_to] + _value > balances[_to]);
163 
164         // Check allowance
165         require(_value <= allowed[_from][msg.sender]);
166 
167         // Transfer tokens
168         balances[_to] += _value;
169         balances[_from] -= _value;
170 
171         // Update allowance
172         allowed[_from][msg.sender] -= _value;
173 
174         // Notify listners
175         Transfer(_from, _to, _value);
176         return true;
177     }
178 
179 
180     /** 
181      * `msg.sender` approves `_spender` to spend `_value` tokens
182      * 
183      * @param _spender The address of the account able to transfer the tokens
184      * @param _value The amount of tokens to be approved for transfer
185      * @return Whether the approval was successful or not
186      */
187     function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success) {
188 
189         // Unable to approve while still locked
190         require(!locked);
191 
192         // Update allowance
193         allowed[msg.sender][_spender] = _value;
194 
195         // Notify listners
196         Approval(msg.sender, _spender, _value);
197         return true;
198     }
199 
200 
201     /** 
202      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
203      * 
204      * @param _owner The address of the account owning tokens
205      * @param _spender The address of the account able to transfer the tokens
206      * @return Amount of remaining tokens allowed to spent
207      */
208     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
209       return allowed[_owner][_spender];
210     }
211 }
212 
213 /**
214  * @title CNR (Coinoor) token
215  *
216  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 with the addition 
217  * of ownership, a lock and issuing.
218  *
219  * #created 13/09/2017
220  * #author Frank Bonnet
221  */
222 contract CNRToken is Owned, StandardToken {
223 
224     // Ethereum token standard
225     string public standard = "Token 0.2";
226 
227     // Full name
228     string public name = "Coinoor";        
229     
230     // Symbol
231     string public symbol = "CNR";
232 
233     // No decimal points
234     uint8 public decimals = 8;
235 
236 
237     /**
238      * Starts with a total supply of zero and the creator starts with 
239      * zero tokens (just like everyone else)
240      */
241     function CNRToken() {  
242         balances[msg.sender] = 0;
243         totalSupply = 0;
244         locked = true;
245     }
246 
247 
248     /**
249      * Unlocks the token irreversibly so that the transfering of value is enabled 
250      *
251      * @return Whether the unlocking was successful or not
252      */
253     function unlock() onlyOwner returns (bool success)  {
254         locked = false;
255         return true;
256     }
257 
258 
259      /**
260      * Issues `_value` new tokens to `_recipient` (_value < 0 guarantees that tokens are never removed)
261      *
262      * @param _recipient The address to which the tokens will be issued
263      * @param _value The amount of new tokens to issue
264      * @return Whether the approval was successful or not
265      */
266     function issue(address _recipient, uint256 _value) onlyOwner onlyPayloadSize(2) returns (bool success) {
267 
268         // Guarantee positive 
269         require(_value > 0);
270 
271         // Create tokens
272         balances[_recipient] += _value;
273         totalSupply += _value;
274 
275         // Notify listners 
276         Transfer(0, owner, _value);
277         Transfer(owner, _recipient, _value);
278 
279         return true;
280     }
281 
282 
283     /**
284      * Prevents accidental sending of ether
285      */
286     function () payable {
287         revert();
288     }
289 }