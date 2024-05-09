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
18         _;
19     }
20 
21     /**
22      * Transfer ownership to `_newOwner`
23      *
24      * @param _newOwner The address of the account that will become the new owner 
25      */
26     function transferOwnership(address _newOwner) onlyOwner {
27         owner = _newOwner;
28     }
29 }
30 
31 // Abstract contract for the full ERC 20 Token standard
32 // https://github.com/ethereum/EIPs/issues/20
33 contract Token {
34     /* This is a slight change to the ERC20 base standard.
35     function totalSupply() constant returns (uint256 supply);
36     is replaced with:
37     uint256 public totalSupply;
38     This automatically creates a getter function for the totalSupply.
39     This is moved to the base contract since public getter functions are not
40     currently recognised as an implementation of the matching abstract
41     function by the compiler.
42     */
43     /// total amount of tokens
44     uint256 public totalSupply;
45 
46     /// @param _owner The address from which the balance will be retrieved
47     /// @return The balance
48     function balanceOf(address _owner) constant returns (uint256 balance);
49 
50     /// @notice send `_value` token to `_to` from `msg.sender`
51     /// @param _to The address of the recipient
52     /// @param _value The amount of token to be transferred
53     /// @return Whether the transfer was successful or not
54     function transfer(address _to, uint256 _value) returns (bool success);
55 
56     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
57     /// @param _from The address of the sender
58     /// @param _to The address of the recipient
59     /// @param _value The amount of token to be transferred
60     /// @return Whether the transfer was successful or not
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
62 
63     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
64     /// @param _spender The address of the account able to transfer the tokens
65     /// @param _value The amount of tokens to be approved for transfer
66     /// @return Whether the approval was successful or not
67     function approve(address _spender, uint256 _value) returns (bool success);
68 
69     /// @param _owner The address of the account owning tokens
70     /// @param _spender The address of the account able to transfer the tokens
71     /// @return Amount of remaining tokens allowed to spent
72     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
73 
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 }
77 
78 /**
79  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
80  *
81  * Modified version of https://github.com/ConsenSys/Tokens that implements the 
82  * original Token contract, an abstract contract for the full ERC 20 Token standard
83  */
84 contract StandardToken is Token {
85 
86 
87     /**
88      * ERC20 Short Address Attack fix
89      */
90     modifier onlyPayloadSize(uint numArgs) {
91         assert(msg.data.length == numArgs * 32 + 4);
92         _;
93     }
94 
95 
96     // ZTT token balances
97     mapping (address => uint256) balances;
98 
99     // ZTT token allowances
100     mapping (address => mapping (address => uint256)) allowed;
101     
102 
103     /** 
104      * Get balance of `_owner` 
105      * 
106      * @param _owner The address from which the balance will be retrieved
107      * @return The balance
108      */
109     function balanceOf(address _owner) constant returns (uint256 balance) {
110         return balances[_owner];
111     }
112 
113 
114     /** 
115      * Send `_value` token to `_to` from `msg.sender`
116      * 
117      * @param _to The address of the recipient
118      * @param _value The amount of token to be transferred
119      * @return Whether the transfer was successful or not
120      */
121     function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool success) {
122 
123         // Check if the sender has enough tokens
124         require(balances[msg.sender] >= _value);   
125 
126         // Check for overflows
127         require(balances[_to] + _value > balances[_to]);
128 
129         // Transfer tokens
130         balances[msg.sender] -= _value;
131         balances[_to] += _value;
132 
133         // Notify listners
134         Transfer(msg.sender, _to, _value);
135         return true;
136     }
137 
138 
139     /** 
140      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
141      * 
142      * @param _from The address of the sender
143      * @param _to The address of the recipient
144      * @param _value The amount of token to be transferred
145      * @return Whether the transfer was successful or not
146      */
147     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool success) {
148 
149         // Check if the sender has enough
150         require(balances[_from] >= _value);
151 
152         // Check for overflows
153         require(balances[_to] + _value > balances[_to]);
154 
155         // Check allowance
156         require(_value <= allowed[_from][msg.sender]);
157 
158         // Transfer tokens
159         balances[_to] += _value;
160         balances[_from] -= _value;
161 
162         // Update allowance
163         allowed[_from][msg.sender] -= _value;
164 
165         // Notify listners
166         Transfer(_from, _to, _value);
167         return true;
168     }
169 
170 
171     /** 
172      * `msg.sender` approves `_spender` to spend `_value` tokens
173      * 
174      * @param _spender The address of the account able to transfer the tokens
175      * @param _value The amount of tokens to be approved for transfer
176      * @return Whether the approval was successful or not
177      */
178     function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success) {
179 
180         // Update allowance
181         allowed[msg.sender][_spender] = _value;
182 
183         // Notify listners
184         Approval(msg.sender, _spender, _value);
185         return true;
186     }
187 
188 
189     /** 
190      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
191      * 
192      * @param _owner The address of the account owning tokens
193      * @param _spender The address of the account able to transfer the tokens
194      * @return Amount of remaining tokens allowed to spent
195      */
196     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
197       return allowed[_owner][_spender];
198     }
199 }
200 
201 /**
202  * @title ZTT (ZeroTraffic) token
203  *
204  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 with the addition 
205  * of ownership, a lock and issuing.
206  *
207  * #created 29/08/2017
208  * #author Frank Bonnet
209  */
210 contract ZTToken is Owned, StandardToken {
211 
212     // Ethereum token standard
213     string public standard = "Token 0.2";
214 
215     // Full name
216     string public name = "ZeroTraffic";        
217     
218     // Symbol
219     string public symbol = "ZTT";
220 
221     // No decimal points
222     uint8 public decimals = 8;
223 
224     // Core team insentive distribution
225     bool public incentiveDistributed = false;
226     uint256 public incentiveDistributionDate = 0;
227     uint256 public incentiveDistributionInterval = 2 years;
228     
229     // Core team incentives
230     struct Incentive {
231         address recipient;
232         uint8 percentage;
233     }
234 
235     Incentive[] public incentives;
236     
237 
238     /**
239      * Starts with a total supply of zero and the creator starts with 
240      * zero tokens (just like everyone else)
241      */
242     function ZTToken() {  
243         balances[msg.sender] = 0;
244         totalSupply = 0;
245         incentiveDistributionDate = now + incentiveDistributionInterval;
246         incentives.push(Incentive(0x3cAf983aCCccc2551195e0809B7824DA6FDe4EC8, 1)); // 0.01 * 10^2 Frank Bonnet
247     }
248 
249 
250     /**
251      * Distributes incentives over the core team members as 
252      * described in the whitepaper
253      */
254     function withdrawIncentives() {
255         require(!incentiveDistributed);
256         require(now > incentiveDistributionDate);
257 
258         incentiveDistributed = true;
259 
260         uint256 totalSupplyToDate = totalSupply;
261         for (uint256 i = 0; i < incentives.length; i++) {
262 
263             // totalSupplyToDate * (percentage * 10^2) / 10^2 / denominator
264             uint256 amount = totalSupplyToDate * incentives[i].percentage / 10**2; 
265             address recipient = incentives[i].recipient;
266 
267             // Create tokens
268             balances[recipient] += amount;
269             totalSupply += amount;
270 
271             // Notify listners
272             Transfer(0, this, amount);
273             Transfer(this, recipient, amount);
274         }
275     }
276 
277 
278     /**
279      * Issues `_value` new tokens to `_recipient` (_value < 0 guarantees that tokens are never removed)
280      *
281      * @param _recipient The address to which the tokens will be issued
282      * @param _value The amount of new tokens to issue
283      * @return Whether the approval was successful or not
284      */
285     function issue(address _recipient, uint256 _value) onlyOwner onlyPayloadSize(2) returns (bool success) {
286 
287         // Guarantee positive 
288         require(_value > 0);
289 
290         // Create tokens
291         balances[_recipient] += _value;
292         totalSupply += _value;
293 
294         // Notify listners 
295         Transfer(0, owner, _value);
296         Transfer(owner, _recipient, _value);
297 
298         return true;
299     }
300 
301 
302     /**
303      * Prevents accidental sending of ether
304      */
305     function () {
306         revert();
307     }
308 }