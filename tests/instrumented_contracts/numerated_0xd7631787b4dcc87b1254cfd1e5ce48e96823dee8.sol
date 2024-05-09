1 pragma solidity ^0.4.6;
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
17         if (msg.sender != owner) throw;
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
86     // Token starts if the locked state restricting transfers
87     bool public locked;
88 
89     // DCORP token balances
90     mapping (address => uint256) balances;
91 
92     // DCORP token allowances
93     mapping (address => mapping (address => uint256)) allowed;
94     
95 
96     /** 
97      * Get balance of `_owner` 
98      * 
99      * @param _owner The address from which the balance will be retrieved
100      * @return The balance
101      */
102     function balanceOf(address _owner) constant returns (uint256 balance) {
103         return balances[_owner];
104     }
105 
106 
107     /** 
108      * Send `_value` token to `_to` from `msg.sender`
109      * 
110      * @param _to The address of the recipient
111      * @param _value The amount of token to be transferred
112      * @return Whether the transfer was successful or not
113      */
114     function transfer(address _to, uint256 _value) returns (bool success) {
115 
116         // Unable to transfer while still locked
117         if (locked) {
118             throw;
119         }
120 
121         // Check if the sender has enough tokens
122         if (balances[msg.sender] < _value) { 
123             throw;
124         }        
125 
126         // Check for overflows
127         if (balances[_to] + _value < balances[_to])  { 
128             throw;
129         }
130 
131         // Transfer tokens
132         balances[msg.sender] -= _value;
133         balances[_to] += _value;
134 
135         // Notify listners
136         Transfer(msg.sender, _to, _value);
137         return true;
138     }
139 
140 
141     /** 
142      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
143      * 
144      * @param _from The address of the sender
145      * @param _to The address of the recipient
146      * @param _value The amount of token to be transferred
147      * @return Whether the transfer was successful or not
148      */
149     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
150 
151          // Unable to transfer while still locked
152         if (locked) {
153             throw;
154         }
155 
156         // Check if the sender has enough
157         if (balances[_from] < _value) { 
158             throw;
159         }
160 
161         // Check for overflows
162         if (balances[_to] + _value < balances[_to]) { 
163             throw;
164         }
165 
166         // Check allowance
167         if (_value > allowed[_from][msg.sender]) { 
168             throw;
169         }
170 
171         // Transfer tokens
172         balances[_to] += _value;
173         balances[_from] -= _value;
174 
175         // Update allowance
176         allowed[_from][msg.sender] -= _value;
177 
178         // Notify listners
179         Transfer(_from, _to, _value);
180         return true;
181     }
182 
183 
184     /** 
185      * `msg.sender` approves `_spender` to spend `_value` tokens
186      * 
187      * @param _spender The address of the account able to transfer the tokens
188      * @param _value The amount of tokens to be approved for transfer
189      * @return Whether the approval was successful or not
190      */
191     function approve(address _spender, uint256 _value) returns (bool success) {
192 
193         // Unable to approve while still locked
194         if (locked) {
195             throw;
196         }
197 
198         // Update allowance
199         allowed[msg.sender][_spender] = _value;
200 
201         // Notify listners
202         Approval(msg.sender, _spender, _value);
203         return true;
204     }
205 
206 
207     /** 
208      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
209      * 
210      * @param _owner The address of the account owning tokens
211      * @param _spender The address of the account able to transfer the tokens
212      * @return Amount of remaining tokens allowed to spent
213      */
214     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
215       return allowed[_owner][_spender];
216     }
217 }
218 
219 
220 /**
221  * @title SCL (Social) token
222  *
223  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 with the addition 
224  * of ownership, a lock and issuing.
225  *
226  * #created 05/03/2017
227  * #author Frank Bonnet
228  */
229 contract SCLToken is Owned, StandardToken {
230 
231     // Ethereum token standaard
232     string public standard = "Token 0.1";
233 
234     // Full name
235     string public name = "SOCIAL";        
236     
237     // Symbol
238     string public symbol = "SCL";
239 
240     // No decimal points
241     uint8 public decimals = 8;
242 
243 
244     /**
245      * Starts with a total supply of zero and the creator starts with 
246      * zero tokens (just like everyone else)
247      */
248     function SCLToken() {  
249         balances[msg.sender] = 0;
250         totalSupply = 0;
251         locked = true;
252     }
253 
254 
255     /**
256      * Unlocks the token irreversibly so that the transfering of value is enabled 
257      *
258      * @return Whether the unlocking was successful or not
259      */
260     function unlock() onlyOwner returns (bool success)  {
261         locked = false;
262         return true;
263     }
264 
265 
266     /**
267      * Issues `_value` new tokens to `_recipient` (_value < 0 guarantees that tokens are never removed)
268      *
269      * @param _recipient The address to which the tokens will be issued
270      * @param _value The amount of new tokens to issue
271      * @return Whether the approval was successful or not
272      */
273     function issue(address _recipient, uint256 _value) onlyOwner returns (bool success) {
274 
275         // Guarantee positive 
276         if (_value < 0) {
277             throw;
278         }
279 
280         // Create tokens
281         balances[_recipient] += _value;
282         totalSupply += _value;
283 
284         // Notify listners
285         Transfer(0, owner, _value);
286         Transfer(owner, _recipient, _value);
287 
288         return true;
289     }
290 
291 
292     /**
293      * Prevents accidental sending of ether
294      */
295     function () {
296         throw;
297     }
298 }