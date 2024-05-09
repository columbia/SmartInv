1 pragma solidity ^0.4.6;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Owned {
34 
35     // The address of the account that is the current owner
36     address public owner;
37 
38     // The publiser is the inital owner
39     function Owned() {
40         owner = msg.sender;
41     }
42 
43     /**
44      * Restricted access to the current owner
45      */
46     modifier onlyOwner() {
47         if (msg.sender != owner) throw;
48         _;
49     }
50 
51     /**
52      * Transfer ownership to `_newOwner`
53      *
54      * @param _newOwner The address of the account that will become the new owner
55      */
56     function transferOwnership(address _newOwner) onlyOwner {
57         owner = _newOwner;
58     }
59 }
60 
61 // Abstract contract for the full ERC 20 Token standard
62 // https://github.com/ethereum/EIPs/issues/20
63 contract Token {
64     /// total amount of tokens
65     uint256 public totalSupply;
66 
67     /// @param _owner The address from which the balance will be retrieved
68     /// @return The balance
69     function balanceOf(address _owner) constant returns (uint256 balance);
70 
71     /// @notice send `_value` token to `_to` from `msg.sender`
72     /// @param _to The address of the recipient
73     /// @param _value The amount of token to be transferred
74     /// @return Whether the transfer was successful or not
75     function transfer(address _to, uint256 _value) returns (bool success);
76 
77     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
78     /// @param _from The address of the sender
79     /// @param _to The address of the recipient
80     /// @param _value The amount of token to be transferred
81     /// @return Whether the transfer was successful or not
82     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
83 
84     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
85     /// @param _spender The address of the account able to transfer the tokens
86     /// @param _value The amount of tokens to be approved for transfer
87     /// @return Whether the approval was successful or not
88     function approve(address _spender, uint256 _value) returns (bool success);
89 
90     /// @param _owner The address of the account owning tokens
91     /// @param _spender The address of the account able to transfer the tokens
92     /// @return Amount of remaining tokens allowed to spent
93     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
94 
95     event Transfer(address indexed _from, address indexed _to, uint256 _value);
96     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 }
98 
99 /**
100  * @title CryptoCopy token
101  *
102  * Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 with the addition
103  * of ownership, a lock and issuing.
104  *
105  */
106 contract CryptoCopyToken is Owned, Token {
107 
108     using SafeMath for uint256;
109 
110     // Ethereum token standaard
111     string public standard = "Token 0.2";
112 
113     // Full name
114     string public name = "CryptoCopy token";
115 
116     // Symbol
117     string public symbol = "CCOPY";
118 
119     // No decimal points
120     uint8 public decimals = 8;
121     
122     // No decimal points
123     uint256 public maxTotalSupply = 1000000 * 10 ** 8; // 1 million
124 
125     // Token starts if the locked state restricting transfers
126     bool public locked;
127 
128     mapping (address => uint256) balances;
129     mapping (address => mapping (address => uint256)) allowed;
130 
131     /**
132      * Get balance of `_owner`
133      *
134      * @param _owner The address from which the balance will be retrieved
135      * @return The balance
136      */
137     function balanceOf(address _owner) constant returns (uint256 balance) {
138         return balances[_owner];
139     }
140 
141     /**
142      * Send `_value` token to `_to` from `msg.sender`
143      *
144      * @param _to The address of the recipient
145      * @param _value The amount of token to be transferred
146      * @return Whether the transfer was successful or not
147      */
148     function transfer(address _to, uint256 _value) returns (bool success) {
149 
150         // Unable to transfer while still locked
151         if (locked) {
152             throw;
153         }
154 
155         // Check if the sender has enough tokens
156         if (balances[msg.sender] < _value) {
157             throw;
158         }
159 
160         // Check for overflows
161         if (balances[_to] + _value < balances[_to])  {
162             throw;
163         }
164 
165         // Transfer tokens
166         balances[msg.sender] -= _value;
167         balances[_to] += _value;
168 
169         // Notify listners
170         Transfer(msg.sender, _to, _value);
171 
172         return true;
173     }
174 
175     /**
176      * Send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
177      *
178      * @param _from The address of the sender
179      * @param _to The address of the recipient
180      * @param _value The amount of token to be transferred
181      * @return Whether the transfer was successful or not
182      */
183     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
184 
185          // Unable to transfer while still locked
186         if (locked) {
187             throw;
188         }
189 
190         // Check if the sender has enough
191         if (balances[_from] < _value) {
192             throw;
193         }
194 
195         // Check for overflows
196         if (balances[_to] + _value < balances[_to]) {
197             throw;
198         }
199 
200         // Check allowance
201         if (_value > allowed[_from][msg.sender]) {
202             throw;
203         }
204 
205         // Transfer tokens
206         balances[_to] += _value;
207         balances[_from] -= _value;
208 
209         // Update allowance
210         allowed[_from][msg.sender] -= _value;
211 
212         // Notify listners
213         Transfer(_from, _to, _value);
214         
215         return true;
216     }
217 
218     /**
219      * `msg.sender` approves `_spender` to spend `_value` tokens
220      *
221      * @param _spender The address of the account able to transfer the tokens
222      * @param _value The amount of tokens to be approved for transfer
223      * @return Whether the approval was successful or not
224      */
225     function approve(address _spender, uint256 _value) returns (bool success) {
226 
227         // Unable to approve while still locked
228         if (locked) {
229             throw;
230         }
231 
232         // Update allowance
233         allowed[msg.sender][_spender] = _value;
234 
235         // Notify listners
236         Approval(msg.sender, _spender, _value);
237         return true;
238     }
239 
240 
241     /**
242      * Get the amount of remaining tokens that `_spender` is allowed to spend from `_owner`
243      *
244      * @param _owner The address of the account owning tokens
245      * @param _spender The address of the account able to transfer the tokens
246      * @return Amount of remaining tokens allowed to spent
247      */
248     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
249       return allowed[_owner][_spender];
250     }
251 
252     /**
253      * Starts with a total supply of zero and the creator starts with
254      * zero tokens (just like everyone else)
255      */
256     function CryptoCopyToken() {
257         balances[msg.sender] = 0;
258         totalSupply = 0;
259         locked = false;
260     }
261 
262     /**
263      * Unlocks the token irreversibly so that the transfering of value is enabled
264      *
265      * @return Whether the unlocking was successful or not
266      */
267     function unlock() onlyOwner returns (bool success)  {
268         locked = false;
269         return true;
270     }
271 
272     /**
273      * Locks the token irreversibly so that the transfering of value is not enabled
274      *
275      * @return Whether the locking was successful or not
276      */
277     function lock() onlyOwner returns (bool success)  {
278         locked = true;
279         return true;
280     }
281     
282     /**
283      * Restricted access to the current owner
284      */
285     modifier onlyOwner() {
286         if (msg.sender != owner) throw;
287         _;
288     }
289     
290     /**
291      * Set max total supply
292      *
293      * @param _maxTotalSupply maximum total amount of tokens
294      */
295     function setMaxTotalSupply(uint256 _maxTotalSupply) {
296         maxTotalSupply = _maxTotalSupply;
297     }
298 
299     /**
300      * Issues `_value` new tokens to `_recipient`
301      *
302      * @param _recipient The address to which the tokens will be issued
303      * @param _value The amount of new tokens to issue
304      * @return Whether the approval was successful or not
305      */
306     function issue(address _recipient, uint256 _value) onlyOwner returns (bool success) {
307 
308         if (totalSupply + _value > maxTotalSupply) {
309             return;
310         }
311         
312         // Create tokens
313         balances[_recipient] += _value;
314         totalSupply += _value;
315 
316         return true;
317     }
318 
319     event Burn(address indexed burner, uint indexed value);
320 
321     /**
322      * Prevents accidental sending of ether
323      */
324     function () {
325         throw;
326     }
327 }