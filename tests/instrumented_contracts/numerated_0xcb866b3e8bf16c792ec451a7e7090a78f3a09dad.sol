1 pragma solidity ^0.4.9;
2 
3 /******************************************************************
4  * AXNET Smart Contract * 
5  * ***************************************************************/
6 
7 contract SafeMath {
8   function safeMul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeSub(uint a, uint b) internal returns (uint) {
15     assert(b <= a);
16     return a - b;
17   }
18 
19   function safeAdd(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c>=a && c>=b);
22     return c;
23   }
24 
25   function assert(bool assertion) internal {
26     if (!assertion) throw;
27   }
28 }
29 
30 contract Token {
31   /// @return total amount of tokens
32   function totalSupply() constant returns (uint256 supply) {}
33 
34   /// @param _owner The address from which the balance will be retrieved
35   /// @return The balance
36   function balanceOf(address _owner) constant returns (uint256 balance) {}
37 
38   /// @notice send `_value` token to `_to` from `msg.sender`
39   /// @param _to The address of the recipient
40   /// @param _value The amount of token to be transferred
41   /// @return Whether the transfer was successful or not
42   function transfer(address _to, uint256 _value) returns (bool success) {}
43 
44   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
45   /// @param _from The address of the sender
46   /// @param _to The address of the recipient
47   /// @param _value The amount of token to be transferred
48   /// @return Whether the transfer was successful or not
49   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
50 
51   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
52   /// @param _spender The address of the account able to transfer the tokens
53   /// @param _value The amount of wei to be approved for transfer
54   /// @return Whether the approval was successful or not
55   function approve(address _spender, uint256 _value) returns (bool success) {}
56 
57   /// @param _owner The address of the account owning tokens
58   /// @param _spender The address of the account able to transfer the tokens
59   /// @return Amount of remaining tokens allowed to spent
60   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
61 
62   event Transfer(address indexed _from, address indexed _to, uint256 _value);
63   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64 
65   uint public decimals;
66   string public name;
67 }
68 
69 contract StandardToken is Token {
70 
71   function transfer(address _to, uint256 _value) returns (bool success) {
72     //Default assumes totalSupply can't be over max (2^256 - 1).
73     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
74     //Replace the if with this one instead.
75     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
76     //if (balances[msg.sender] >= _value && _value > 0) {
77       balances[msg.sender] -= _value;
78       balances[_to] += _value;
79       Transfer(msg.sender, _to, _value);
80       return true;
81     } else { return false; }
82   }
83 
84   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
85     //same as above. Replace this line with the following if you want to protect against wrapping uints.
86     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
87     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
88       balances[_to] += _value;
89       balances[_from] -= _value;
90       allowed[_from][msg.sender] -= _value;
91       Transfer(_from, _to, _value);
92       return true;
93     } else { return false; }
94   }
95 
96   function balanceOf(address _owner) constant returns (uint256 balance) {
97     return balances[_owner];
98   }
99 
100   function approve(address _spender, uint256 _value) returns (bool success) {
101     allowed[msg.sender][_spender] = _value;
102     Approval(msg.sender, _spender, _value);
103     return true;
104   }
105 
106   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
107     return allowed[_owner][_spender];
108   }
109 
110   mapping(address => uint256) balances;
111 
112   mapping (address => mapping (address => uint256)) allowed;
113 
114   uint256 public totalSupply;
115 }
116 
117 contract ReserveToken is StandardToken, SafeMath {
118   address public minter;
119   function ReserveToken() {
120     minter = msg.sender;
121   }
122   function create(address account, uint amount) {
123     if (msg.sender != minter) throw;
124     balances[account] = safeAdd(balances[account], amount);
125     totalSupply = safeAdd(totalSupply, amount);
126   }
127   function destroy(address account, uint amount) {
128     if (msg.sender != minter) throw;
129     if (balances[account] < amount) throw;
130     balances[account] = safeSub(balances[account], amount);
131     totalSupply = safeSub(totalSupply, amount);
132   }
133 }
134 
135 contract AccountLevels {
136   //given a user, returns an account level
137   //0 = regular user (pays take fee and make fee)
138   //1 = market maker silver (pays take fee, no make fee, gets rebate)
139   //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
140   function accountLevel(address user) constant returns(uint) {}
141 }
142 
143 contract AccountLevelsTest is AccountLevels {
144   mapping (address => uint) public accountLevels;
145 
146   function setAccountLevel(address user, uint level) {
147     accountLevels[user] = level;
148   }
149 
150   function accountLevel(address user) constant returns(uint) {
151     return accountLevels[user];
152   }
153 }
154 
155 contract AXNET is SafeMath {
156   address public admin; //the admin address
157   address public feeAccount; //the account that will receive fees
158   address public accountLevelsAddr; //the address of the AccountLevels contract
159   uint public feeMake; //percentage times (1 ether)
160   uint public feeTake; //percentage times (1 ether)
161   uint public feeRebate; //percentage times (1 ether)
162   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
163   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
164   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
165 
166   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
167   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
168   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
169   event Deposit(address token, address user, uint amount, uint balance);
170   event Withdraw(address token, address user, uint amount, uint balance);
171 
172   function AXNET() {
173     admin = msg.sender;
174     feeAccount = msg.sender;
175     accountLevelsAddr = 0x0000000000000000000000000000000000000000;
176     feeMake = 2000000000000000;
177     feeTake = 1000000000000000;
178     feeRebate = 0;
179   }
180 
181   function() {
182     throw;
183   }
184 
185   function changeAdmin(address admin_) {
186     if (msg.sender != admin) throw;
187     admin = admin_;
188   }
189 
190   function changeAccountLevelsAddr(address accountLevelsAddr_) {
191     if (msg.sender != admin) throw;
192     accountLevelsAddr = accountLevelsAddr_;
193   }
194 
195   function changeFeeAccount(address feeAccount_) {
196     if (msg.sender != admin) throw;
197     feeAccount = feeAccount_;
198   }
199 
200   function changeFeeMake(uint feeMake_) {
201     if (msg.sender != admin) throw;
202     if (feeMake_ > feeMake) throw;
203     feeMake = feeMake_;
204   }
205 
206   function changeFeeTake(uint feeTake_) {
207     if (msg.sender != admin) throw;
208     if (feeTake_ > feeTake || feeTake_ < feeRebate) throw;
209     feeTake = feeTake_;
210   }
211 
212   function changeFeeRebate(uint feeRebate_) {
213     if (msg.sender != admin) throw;
214     if (feeRebate_ < feeRebate || feeRebate_ > feeTake) throw;
215     feeRebate = feeRebate_;
216   }
217 
218   function deposit() payable {
219     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
220     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
221   }
222 
223   function withdraw(uint amount) {
224     if (tokens[0][msg.sender] < amount) throw;
225     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
226     if (!msg.sender.call.value(amount)()) throw;
227     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
228   }
229 
230   function depositToken(address token, uint amount) {
231     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
232     if (token==0) throw;
233     if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
234     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
235     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
236   }
237 
238   function withdrawToken(address token, uint amount) {
239     if (token==0) throw;
240     if (tokens[token][msg.sender] < amount) throw;
241     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
242     if (!Token(token).transfer(msg.sender, amount)) throw;
243     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
244   }
245 
246   function balanceOf(address token, address user) constant returns (uint) {
247     return tokens[token][user];
248   }
249 
250   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {
251     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
252     orders[msg.sender][hash] = true;
253     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
254   }
255 
256   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
257     //amount is in amountGet terms
258     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
259     if (!(
260       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
261       block.number <= expires &&
262       safeAdd(orderFills[user][hash], amount) <= amountGet
263     )) throw;
264     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
265     orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
266     Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
267   }
268 
269   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
270     uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
271     uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
272     uint feeRebateXfer = 0;
273     if (accountLevelsAddr != 0x0) {
274       uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
275       if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);
276       if (accountLevel==2) feeRebateXfer = feeTakeXfer;
277     }
278     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
279     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
280     tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
281     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
282     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
283   }
284 
285   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {
286     if (!(
287       tokens[tokenGet][sender] >= amount &&
288       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
289     )) return false;
290     return true;
291   }
292 
293   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
294     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
295     if (!(
296       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
297       block.number <= expires
298     )) return 0;
299     uint available1 = safeSub(amountGet, orderFills[user][hash]);
300     uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
301     if (available1<available2) return available1;
302     return available2;
303   }
304 
305   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
306     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
307     return orderFills[user][hash];
308   }
309 
310   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
311     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
312     if (!(orders[msg.sender][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) throw;
313     orderFills[msg.sender][hash] = amountGet;
314     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
315   }
316 }