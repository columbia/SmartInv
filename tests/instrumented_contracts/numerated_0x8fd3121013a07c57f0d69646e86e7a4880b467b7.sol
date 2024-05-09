1 pragma solidity ^0.4.11;
2 
3 // See the Github at https://github.com/airswap/contracts
4 
5 // Abstract contract for the full ERC 20 Token standard
6 // https://github.com/ethereum/EIPs/issues/20
7 
8 contract Token {
9     /* This is a slight change to the ERC20 base standard.
10     function totalSupply() constant returns (uint256 supply);
11     is replaced with:
12     uint256 public totalSupply;
13     This automatically creates a getter function for the totalSupply.
14     This is moved to the base contract since public getter functions are not
15     currently recognised as an implementation of the matching abstract
16     function by the compiler.
17     */
18     /// total amount of tokens
19     uint256 public totalSupply;
20 
21     /// @param _owner The address from which the balance will be retrieved
22     /// @return The balance
23     function balanceOf(address _owner) constant returns (uint256 balance);
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) returns (bool success);
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
37 
38     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of tokens to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) returns (bool success);
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
48 
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 }
52 
53 
54 /* Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 */
55 
56 contract ERC20 is Token {
57 
58     function transfer(address _to, uint256 _value) returns (bool success) {
59         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
60         balances[msg.sender] -= _value;
61         balances[_to] += _value;
62         Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
67         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
68         balances[_to] += _value;
69         balances[_from] -= _value;
70         allowed[_from][msg.sender] -= _value;
71         Transfer(_from, _to, _value);
72         return true;
73     }
74 
75     function balanceOf(address _owner) constant returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86       return allowed[_owner][_spender];
87     }
88 
89     mapping (address => uint256) public balances; // *added public
90     mapping (address => mapping (address => uint256)) public allowed; // *added public
91 }
92 
93 /** @title AirSwap exchange contract.
94   * Assumes makers and takers have approved this contract to access their balances.
95   */
96 contract AirSwapExchange {
97 
98     // Mapping of order hash to bool (true = already filled).
99     mapping (bytes32 => bool) public fills;
100 
101     // Events that are emitted in different scenarios.
102     event Filled(address indexed makerAddress, uint makerAmount, address indexed makerToken, address takerAddress, uint takerAmount, address indexed takerToken, uint256 expiration, uint256 nonce);
103     event Canceled(address indexed makerAddress, uint makerAmount, address indexed makerToken, address takerAddress, uint takerAmount, address indexed takerToken, uint256 expiration, uint256 nonce);
104 
105     /** Event thrown when a trade fails
106       * Error codes:
107       * 1 -> 'The makeAddress and takerAddress must be different',
108       * 2 -> 'The order has expired',
109       * 3 -> 'This order has already been filled',
110       * 4 -> 'The ether sent with this transaction does not match takerAmount',
111       * 5 -> 'No ether is required for a trade between tokens',
112       * 6 -> 'The sender of this transaction must match the takerAddress',
113       * 7 -> 'Order has already been cancelled or filled'
114       */
115     event Failed(uint code, address indexed makerAddress, uint makerAmount, address indexed makerToken, address takerAddress, uint takerAmount, address indexed takerToken, uint256 expiration, uint256 nonce);
116 
117     /** Fills an order by transferring tokens between (maker or escrow) and taker.
118       * maker is given tokenA to taker,
119       */
120     function fill(address makerAddress, uint makerAmount, address makerToken,
121                   address takerAddress, uint takerAmount, address takerToken,
122                   uint256 expiration, uint256 nonce, uint8 v, bytes32 r, bytes32 s) payable {
123 
124         if (makerAddress == takerAddress) {
125             msg.sender.transfer(msg.value);
126             Failed(1,
127             makerAddress, makerAmount, makerToken,
128             takerAddress, takerAmount, takerToken,
129             expiration, nonce);
130             return;
131         }
132 
133         // Check if this order has expired
134         if (expiration < now) {
135             msg.sender.transfer(msg.value);
136             Failed(2,
137                 makerAddress, makerAmount, makerToken,
138                 takerAddress, takerAmount, takerToken,
139                 expiration, nonce);
140             return;
141         }
142 
143         // Validate the message by signature.
144         bytes32 hash = validate(makerAddress, makerAmount, makerToken,
145             takerAddress, takerAmount, takerToken,
146             expiration, nonce, v, r, s);
147 
148         // Check if this order has already been filled
149         if (fills[hash]) {
150             msg.sender.transfer(msg.value);
151             Failed(3,
152                 makerAddress, makerAmount, makerToken,
153                 takerAddress, takerAmount, takerToken,
154                 expiration, nonce);
155             return;
156         }
157 
158         // Check to see if this an order for ether.
159         if (takerToken == address(0x0)) {
160 
161             // Check to make sure the message value is the order amount.
162             if (msg.value == takerAmount) {
163 
164                 // Mark order as filled to prevent reentrancy.
165                 fills[hash] = true;
166 
167                 // Perform the trade between makerAddress and takerAddress.
168                 // The transfer will throw if there's a problem.
169                 assert(transfer(makerAddress, takerAddress, makerAmount, makerToken));
170 
171                 // Transfer the ether received from sender to makerAddress.
172                 makerAddress.transfer(msg.value);
173 
174                 // Log an event to indicate completion.
175                 Filled(makerAddress, makerAmount, makerToken,
176                     takerAddress, takerAmount, takerToken,
177                     expiration, nonce);
178 
179             } else {
180                 msg.sender.transfer(msg.value);
181                 Failed(4,
182                     makerAddress, makerAmount, makerToken,
183                     takerAddress, takerAmount, takerToken,
184                     expiration, nonce);
185             }
186 
187         } else {
188             // This is an order trading two tokens
189             // Check that no ether has been sent accidentally
190             if (msg.value != 0) {
191                 msg.sender.transfer(msg.value);
192                 Failed(5,
193                     makerAddress, makerAmount, makerToken,
194                     takerAddress, takerAmount, takerToken,
195                     expiration, nonce);
196                 return;
197             }
198 
199             if (takerAddress == msg.sender) {
200 
201                 // Mark order as filled to prevent reentrancy.
202                 fills[hash] = true;
203 
204                 // Perform the trade between makerAddress and takerAddress.
205                 // The transfer will throw if there's a problem.
206                 // Assert should never fail
207                 assert(trade(makerAddress, makerAmount, makerToken,
208                     takerAddress, takerAmount, takerToken));
209 
210                 // Log an event to indicate completion.
211                 Filled(
212                     makerAddress, makerAmount, makerToken,
213                     takerAddress, takerAmount, takerToken,
214                     expiration, nonce);
215 
216             } else {
217                 Failed(6,
218                     makerAddress, makerAmount, makerToken,
219                     takerAddress, takerAmount, takerToken,
220                     expiration, nonce);
221             }
222         }
223     }
224 
225     /** Cancels an order by refunding escrow and adding it to the fills mapping.
226       * Will log an event if
227       * - order has been cancelled or
228       * - order has already been filled
229       * and will do nothing if the maker of the order in question is not the
230       * msg.sender
231       */
232     function cancel(address makerAddress, uint makerAmount, address makerToken,
233                     address takerAddress, uint takerAmount, address takerToken,
234                     uint256 expiration, uint256 nonce, uint8 v, bytes32 r, bytes32 s) {
235 
236         // Validate the message by signature.
237         bytes32 hash = validate(makerAddress, makerAmount, makerToken,
238             takerAddress, takerAmount, takerToken,
239             expiration, nonce, v, r, s);
240 
241         // Only the maker can cancel an order
242         if (msg.sender == makerAddress) {
243 
244             // Check that order has not already been filled/cancelled
245             if (fills[hash] == false) {
246 
247                 // Cancel the order by considering it filled.
248                 fills[hash] = true;
249 
250                 // Broadcast an event to the blockchain.
251                 Canceled(makerAddress, makerAmount, makerToken,
252                     takerAddress, takerAmount, takerToken,
253                     expiration, nonce);
254 
255             } else {
256                 Failed(7,
257                     makerAddress, makerAmount, makerToken,
258                     takerAddress, takerAmount, takerToken,
259                     expiration, nonce);
260             }
261         }
262     }
263 
264     /** Atomic trade of tokens between first party and second party.
265       * Throws if one of the trades does not go through.
266       */
267     function trade(address makerAddress, uint makerAmount, address makerToken,
268                    address takerAddress, uint takerAmount, address takerToken) private returns (bool) {
269         return (transfer(makerAddress, takerAddress, makerAmount, makerToken) &&
270         transfer(takerAddress, makerAddress, takerAmount, takerToken));
271     }
272 
273     /** Transfers tokens from first party to second party.
274       * Prior to a transfer being done by the contract, ensure that
275       * tokenVal.approve(this, amount, {from : address}) has been called
276       * throws if the transferFrom of the token returns false
277       * returns true if, the transfer went through
278       */
279     function transfer(address from, address to, uint amount, address token) private returns (bool) {
280         require(ERC20(token).transferFrom(from, to, amount));
281         return true;
282     }
283 
284     /** Validates order arguments for fill() and cancel() functions. */
285     function validate(address makerAddress, uint makerAmount, address makerToken,
286                       address takerAddress, uint takerAmount, address takerToken,
287                       uint256 expiration, uint256 nonce, uint8 v, bytes32 r, bytes32 s) private returns (bytes32) {
288 
289         // Hash arguments to identify the order.
290         bytes32 hashV = keccak256(makerAddress, makerAmount, makerToken,
291             takerAddress, takerAmount, takerToken,
292             expiration, nonce);
293 
294         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
295         bytes32 prefixedHash = sha3(prefix, hashV);
296 
297         require(ecrecover(prefixedHash, v, r, s) == makerAddress);
298 
299         return hashV;
300     }
301 }