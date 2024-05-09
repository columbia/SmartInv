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
131 contract AccountLevels {
132   //given a user, returns an account level
133   //0 = regular user (pays take fee and make fee)
134   //1 = market maker silver (pays take fee, no make fee, gets rebate)
135   //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
136   function accountLevel(address user) constant returns(uint) {}
137 }
138 
139 contract AccountLevelsTest is AccountLevels {
140   mapping (address => uint) public accountLevels;
141 
142   function setAccountLevel(address user, uint level) {
143     accountLevels[user] = level;
144   }
145 
146   function accountLevel(address user) constant returns(uint) {
147     return accountLevels[user];
148   }
149 }
150 
151 contract CreedExchange is SafeMath {
152   address public admin; //the admin address
153   address public feeAccount; //the account that will receive fees
154   address public accountLevelsAddr; //the address of the AccountLevels contract
155   uint public feeMake; //percentage times (1 ether)
156   uint public feeTake; //percentage times (1 ether)
157   uint public feeRebate; //percentage times (1 ether)
158   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
159   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
160   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
161 
162   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
163   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
164   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
165   event Deposit(address token, address user, uint amount, uint balance);
166   event Withdraw(address token, address user, uint amount, uint balance);
167 
168   function CreedExchange(address admin_, address feeAccount_, address accountLevelsAddr_, uint feeMake_, uint feeTake_, uint feeRebate_) {
169     admin = admin_;
170     feeAccount = feeAccount_;
171     accountLevelsAddr = accountLevelsAddr_;
172     feeMake = feeMake_;
173     feeTake = feeTake_;
174     feeRebate = feeRebate_;
175   }
176 
177   function() {
178     throw;
179   }
180 
181   function changeAdmin(address admin_) {
182     if (msg.sender != admin) throw;
183     admin = admin_;
184   }
185 
186   function changeAccountLevelsAddr(address accountLevelsAddr_) {
187     if (msg.sender != admin) throw;
188     accountLevelsAddr = accountLevelsAddr_;
189   }
190 
191   function changeFeeAccount(address feeAccount_) {
192     if (msg.sender != admin) throw;
193     feeAccount = feeAccount_;
194   }
195 
196   function changeFeeMake(uint feeMake_) {
197     if (msg.sender != admin) throw;
198     if (feeMake_ > feeMake) throw;
199     feeMake = feeMake_;
200   }
201 
202   function changeFeeTake(uint feeTake_) {
203     if (msg.sender != admin) throw;
204     if (feeTake_ > feeTake || feeTake_ < feeRebate) throw;
205     feeTake = feeTake_;
206   }
207 
208   function changeFeeRebate(uint feeRebate_) {
209     if (msg.sender != admin) throw;
210     if (feeRebate_ < feeRebate || feeRebate_ > feeTake) throw;
211     feeRebate = feeRebate_;
212   }
213 
214   function deposit() payable {
215     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
216     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
217   }
218 
219   function withdraw(uint amount) {
220     if (tokens[0][msg.sender] < amount) throw;
221     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
222     if (!msg.sender.call.value(amount)()) throw;
223     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
224   }
225 
226   function depositToken(address token, uint amount) {
227     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
228     if (token==0) throw;
229     if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
230     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
231     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
232   }
233 
234   function withdrawToken(address token, uint amount) {
235     if (token==0) throw;
236     if (tokens[token][msg.sender] < amount) throw;
237     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
238     if (!Token(token).transfer(msg.sender, amount)) throw;
239     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
240   }
241 
242   function balanceOf(address token, address user) constant returns (uint) {
243     return tokens[token][user];
244   }
245 
246   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {
247     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
248     orders[msg.sender][hash] = true;
249     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
250   }
251 
252   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
253     //amount is in amountGet terms
254     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
255     if (!(
256       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
257       block.number <= expires &&
258       safeAdd(orderFills[user][hash], amount) <= amountGet
259     )) throw;
260     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
261     orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
262     Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
263   }
264 
265   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
266     uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
267     uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
268     uint feeRebateXfer = 0;
269     if (accountLevelsAddr != 0x0) {
270       uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
271       if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);
272       if (accountLevel==2) feeRebateXfer = feeTakeXfer;
273     }
274     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
275     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
276     tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
277     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
278     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
279   }
280 
281   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {
282     if (!(
283       tokens[tokenGet][sender] >= amount &&
284       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
285     )) return false;
286     return true;
287   }
288 
289   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
290     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
291     if (!(
292       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
293       block.number <= expires
294     )) return 0;
295     uint available1 = safeSub(amountGet, orderFills[user][hash]);
296     uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
297     if (available1<available2) return available1;
298     return available2;
299   }
300 
301   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
302     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
303     return orderFills[user][hash];
304   }
305 
306   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
307     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
308     if (!(orders[msg.sender][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) throw;
309     orderFills[msg.sender][hash] = amountGet;
310     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
311   }
312 }