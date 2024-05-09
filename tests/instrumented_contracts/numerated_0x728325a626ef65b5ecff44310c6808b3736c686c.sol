1 pragma solidity ^0.4.9;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeSub(uint a, uint b) internal returns (uint) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function safeAdd(uint a, uint b) internal returns (uint) {
16     uint c = a + b;
17     assert(c>=a && c>=b);
18     return c;
19   }
20 
21   function assert(bool assertion) internal {
22     if (!assertion) throw;
23   }
24 }
25 
26 contract Token {
27   /// @return total amount of tokens
28   function totalSupply() constant returns (uint256 supply) {}
29 
30   /// @param _owner The address from which the balance will be retrieved
31   /// @return The balance
32   function balanceOf(address _owner) constant returns (uint256 balance) {}
33 
34   /// @notice send `_value` token to `_to` from `msg.sender`
35   /// @param _to The address of the recipient
36   /// @param _value The amount of token to be transferred
37   /// @return Whether the transfer was successful or not
38   function transfer(address _to, uint256 _value) returns (bool success) {}
39 
40   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
41   /// @param _from The address of the sender
42   /// @param _to The address of the recipient
43   /// @param _value The amount of token to be transferred
44   /// @return Whether the transfer was successful or not
45   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
46 
47   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
48   /// @param _spender The address of the account able to transfer the tokens
49   /// @param _value The amount of wei to be approved for transfer
50   /// @return Whether the approval was successful or not
51   function approve(address _spender, uint256 _value) returns (bool success) {}
52 
53   /// @param _owner The address of the account owning tokens
54   /// @param _spender The address of the account able to transfer the tokens
55   /// @return Amount of remaining tokens allowed to spent
56   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
57 
58   event Transfer(address indexed _from, address indexed _to, uint256 _value);
59   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 
61   uint public decimals;
62   string public name;
63 }
64 
65 contract StandardToken is Token {
66 
67   function transfer(address _to, uint256 _value) returns (bool success) {
68     //Default assumes totalSupply can't be over max (2^256 - 1).
69     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
70     //Replace the if with this one instead.
71     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
72     //if (balances[msg.sender] >= _value && _value > 0) {
73       balances[msg.sender] -= _value;
74       balances[_to] += _value;
75       Transfer(msg.sender, _to, _value);
76       return true;
77     } else { return false; }
78   }
79 
80   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
81     //same as above. Replace this line with the following if you want to protect against wrapping uints.
82     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
83     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
84       balances[_to] += _value;
85       balances[_from] -= _value;
86       allowed[_from][msg.sender] -= _value;
87       Transfer(_from, _to, _value);
88       return true;
89     } else { return false; }
90   }
91 
92   function balanceOf(address _owner) constant returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96   function approve(address _spender, uint256 _value) returns (bool success) {
97     allowed[msg.sender][_spender] = _value;
98     Approval(msg.sender, _spender, _value);
99     return true;
100   }
101 
102   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
103     return allowed[_owner][_spender];
104   }
105 
106   mapping(address => uint256) balances;
107 
108   mapping (address => mapping (address => uint256)) allowed;
109 
110   uint256 public totalSupply;
111 }
112 
113 contract ReserveToken is StandardToken, SafeMath {
114   address public minter;
115   function ReserveToken() {
116     minter = msg.sender;
117   }
118   function create(address account, uint amount) {
119     if (msg.sender != minter) throw;
120     balances[account] = safeAdd(balances[account], amount);
121     totalSupply = safeAdd(totalSupply, amount);
122   }
123   function destroy(address account, uint amount) {
124     if (msg.sender != minter) throw;
125     if (balances[account] < amount) throw;
126     balances[account] = safeSub(balances[account], amount);
127     totalSupply = safeSub(totalSupply, amount);
128   }
129 }
130 
131 
132 
133 
134 contract MicroDex is SafeMath {
135 
136   bool locked;
137   //check account balances for this token; we do not use ether
138 
139 
140   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
141   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
142   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
143 
144   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
145   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
146   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
147   event Deposit(address token, address user, uint amount, uint balance);
148   event Withdraw(address token, address user, uint amount, uint balance);
149 
150   function MicroDex( ) {
151 
152     if(locked)revert();
153     locked = true;
154   }
155 
156   function() {
157     throw;
158   }
159 
160 
161 
162 
163    /**
164   * This function handles deposits of Ether into the contract.
165   * Emits a Deposit event.
166   * Note: With the payable modifier, this function accepts Ether.
167   */
168   function deposit() public payable {
169     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender],msg.value);
170     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
171   }
172 
173   /**
174   * This function handles withdrawals of Ether from the contract.
175   * Verifies that the user has enough funds to cover the withdrawal.
176   * Emits a Withdraw event.
177   * @param amount uint of the amount of Ether the user wishes to withdraw
178   */
179   function withdraw(uint amount) public {
180     require(tokens[0][msg.sender] >= amount);
181     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender],amount);
182     msg.sender.transfer(amount);
183     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
184   }
185 
186 
187 
188   //call this using ApproveAndCall
189   //allows for interacting with ether directly as token[0]
190   function depositToken(address from, address token, uint amount) {
191     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
192     if (token==0) throw;
193     if (!Token(token).transferFrom(from, this, amount)) throw;
194     tokens[token][from] = safeAdd(tokens[token][from], amount);
195     Deposit(token, from, amount, tokens[token][from]);
196   }
197 
198   function withdrawToken(address token, uint amount) {
199     if (token==0) throw;
200     if (tokens[token][msg.sender] < amount) throw;
201     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
202     if (!Token(token).transfer(msg.sender, amount)) throw;
203     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
204   }
205 
206   function balanceOf(address token, address user) constant returns (uint) {
207     return tokens[token][user];
208   }
209 
210   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {
211     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
212     orders[msg.sender][hash] = true;
213     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
214   }
215 
216   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
217     //amount is in amountGet terms
218     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
219     if (!(
220       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
221       block.number <= expires &&
222       safeAdd(orderFills[user][hash], amount) <= amountGet
223     )) throw;
224     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
225     orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
226     Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
227   }
228 
229   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
230   //  uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
231   //  uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
232   //  uint feeRebateXfer = 0;
233   //  if (accountLevelsAddr != 0x0) {
234   //    uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
235   //    if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);
236   //    if (accountLevel==2) feeRebateXfer = feeTakeXfer;
237   //  }
238     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], amount);
239     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], amount);
240   //  tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
241     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
242     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
243   }
244 
245   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {
246     if (!(
247       tokens[tokenGet][sender] >= amount &&
248       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
249     )) return false;
250     return true;
251   }
252 
253   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
254     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
255     if (!(
256       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
257       block.number <= expires
258     )) return 0;
259     uint available1 = safeSub(amountGet, orderFills[user][hash]);
260     uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
261     if (available1<available2) return available1;
262     return available2;
263   }
264 
265   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
266     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
267     return orderFills[user][hash];
268   }
269 
270   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
271     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
272     if (!(orders[msg.sender][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) throw;
273     orderFills[msg.sender][hash] = amountGet;
274     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
275   }
276 
277 
278 
279   /*
280     Receive approval to spend tokens and perform any action all in one transaction
281   */
282   function receiveApproval(address from, uint256 tokens, address token, bytes data) public returns (bool) {
283 
284     //parse the data:   first byte is for 'action_id'
285     byte action_id = data[0];
286 
287     if(action_id == 0x1)
288     {
289       depositToken(from, token, tokens );
290       return true;
291     }
292 
293     return false;
294 
295   }
296 
297 }