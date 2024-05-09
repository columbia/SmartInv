1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, June 6, 2019
3  (UTC) */
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Wednesday, June 5, 2019
7  (UTC) */
8 
9 pragma solidity ^0.4.9;
10 
11 contract SafeMath {
12   function safeMul(uint a, uint b) internal returns (uint) {
13     uint c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function safeSub(uint a, uint b) internal returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function safeAdd(uint a, uint b) internal returns (uint) {
24     uint c = a + b;
25     assert(c>=a && c>=b);
26     return c;
27   }
28 
29   function assert(bool assertion) internal {
30     if (!assertion) throw;
31   }
32 }
33 
34 contract Token {
35   /// @return total amount of tokens
36   function totalSupply() constant returns (uint256) {}
37 
38   /// @param _owner The address from which the balance will be retrieved
39   /// @return The balance
40   function balanceOf(address _owner) constant returns (uint256) {}
41 
42   /// @notice send `_value` token to `_to` from `msg.sender`
43   /// @param _to The address of the recipient
44   /// @param _value The amount of token to be transferred
45   /// @return Whether the transfer was successful or not
46   function transfer(address _to, uint256 _value) returns (bool success) {}
47 
48   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
49   /// @param _from The address of the sender
50   /// @param _to The address of the recipient
51   /// @param _value The amount of token to be transferred
52   /// @return Whether the transfer was successful or not
53   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
54 
55   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
56   /// @param _spender The address of the account able to transfer the tokens
57   /// @param _value The amount of wei to be approved for transfer
58   /// @return Whether the approval was successful or not
59   function approve(address _spender, uint256 _value) returns (bool success) {}
60 
61   /// @param _owner The address of the account owning tokens
62   /// @param _spender The address of the account able to transfer the tokens
63   /// @return Amount of remaining tokens allowed to spent
64   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
65 
66   event Transfer(address indexed _from, address indexed _to, uint256 _value);
67   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68 
69   uint public decimals;
70   string public name;
71 }
72 
73 contract StandardToken is Token {
74 
75   function transfer(address _to, uint256 _value) returns (bool success) {
76     //Default assumes totalSupply can't be over max (2^256 - 1).
77     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
78     //Replace the if with this one instead.
79     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
80     //if (balances[msg.sender] >= _value && _value > 0) {
81       balances[msg.sender] -= _value;
82       balances[_to] += _value;
83       Transfer(msg.sender, _to, _value);
84       return true;
85     } else { return false; }
86   }
87 
88   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
89     //same as above. Replace this line with the following if you want to protect against wrapping uints.
90     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
91     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
92       balances[_to] += _value;
93       balances[_from] -= _value;
94       allowed[_from][msg.sender] -= _value;
95       Transfer(_from, _to, _value);
96       return true;
97     } else { return false; }
98   }
99 
100   function balanceOf(address _owner) constant returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104   function approve(address _spender, uint256 _value) returns (bool success) {
105     allowed[msg.sender][_spender] = _value;
106     Approval(msg.sender, _spender, _value);
107     return true;
108   }
109 
110   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
111     return allowed[_owner][_spender];
112   }
113 
114   mapping(address => uint256) balances;
115 
116   mapping (address => mapping (address => uint256)) allowed;
117 
118   uint256 public totalSupply;
119 }
120 
121 contract ReserveToken is StandardToken, SafeMath {
122   address public minter;
123   function ReserveToken() {
124     minter = msg.sender;
125   }
126   function create(address account, uint amount) {
127     if (msg.sender != minter) throw;
128     balances[account] = safeAdd(balances[account], amount);
129     totalSupply = safeAdd(totalSupply, amount);
130   }
131   function destroy(address account, uint amount) {
132     if (msg.sender != minter) throw;
133     if (balances[account] < amount) throw;
134     balances[account] = safeSub(balances[account], amount);
135     totalSupply = safeSub(totalSupply, amount);
136   }
137 }
138 
139 contract AccountLevels {
140   //given a user, returns an account level
141   //0 = regular user (pays take fee and make fee)
142   //1 = market maker silver (pays take fee, no make fee, gets rebate)
143   //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
144   function accountLevel(address user) constant returns(uint) {}
145 }
146 
147 contract AccountLevelsTest is AccountLevels {
148   mapping (address => uint) public accountLevels;
149 
150   function setAccountLevel(address user, uint level) {
151     accountLevels[user] = level;
152   }
153 
154   function accountLevel(address user) constant returns(uint) {
155     return accountLevels[user];
156   }
157 }
158 
159 contract SWATX is SafeMath {
160   address public admin; //the admin address
161   address public feeAccount; //the account that will receive fees
162   address public accountLevelsAddr; //the address of the AccountLevels contract
163   uint public feeMake; //percentage times (1 ether)
164   uint public feeTake; //percentage times (1 ether)
165   uint public feeRebate; //percentage times (1 ether)
166   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
167   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
168   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
169 
170   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
171   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
172   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give, bytes32 r, bytes32 s);
173   event Deposit(address token, address user, uint amount, uint balance);
174   event Withdraw(address token, address user, uint amount, uint balance);
175 
176   function SWATX(address admin_, address feeAccount_, uint feeMake_, uint feeTake_, uint feeRebate_) {
177     admin = admin_;
178     feeAccount = feeAccount_;
179     accountLevelsAddr = 0x0;
180     feeMake = feeMake_;
181     feeTake = feeTake_;
182     feeRebate = feeRebate_;
183   }
184 
185   function() {
186     throw;
187   }
188 
189   function changeAdmin(address admin_) {
190     if (msg.sender != admin) throw;
191     admin = admin_;
192   }
193 
194   function changeAccountLevelsAddr(address accountLevelsAddr_) {
195     if (msg.sender != admin) throw;
196     accountLevelsAddr = accountLevelsAddr_;
197   }
198 
199   function changeFeeAccount(address feeAccount_) {
200     if (msg.sender != admin) throw;
201     feeAccount = feeAccount_;
202   }
203 
204   function changeFeeMake(uint feeMake_) {
205     if (msg.sender != admin) throw;
206     if (feeMake_ > feeMake) throw;
207     feeMake = feeMake_;
208   }
209 
210   function changeFeeTake(uint feeTake_) {
211     if (msg.sender != admin) throw;
212     if (feeTake_ > feeTake || feeTake_ < feeRebate) throw;
213     feeTake = feeTake_;
214   }
215 
216   function changeFeeRebate(uint feeRebate_) {
217     if (msg.sender != admin) throw;
218     if (feeRebate_ < feeRebate || feeRebate_ > feeTake) throw;
219     feeRebate = feeRebate_;
220   }
221 
222   function deposit() payable {
223     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
224     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
225   }
226 
227   function withdraw(uint amount) {
228     if (tokens[0][msg.sender] < amount) throw;
229     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
230     if (!msg.sender.call.value(amount)()) throw;
231     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
232   }
233 
234   function depositToken(address token, uint amount) {
235     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
236     if (token==0) throw;
237     if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
238     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
239     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
240   }
241 
242   function withdrawToken(address token, uint amount) {
243     if (token==0) throw;
244     if (tokens[token][msg.sender] < amount) throw;
245     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
246     if (!Token(token).transfer(msg.sender, amount)) throw;
247     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
248   }
249 
250   function balanceOf(address token, address user) constant returns (uint) {
251     return tokens[token][user];
252   }
253 
254   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {
255     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
256     orders[msg.sender][hash] = true;
257     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
258   }
259 
260   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
261     //amount is in amountGet terms
262     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
263     if (!(
264       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
265       block.number <= expires &&
266       safeAdd(orderFills[user][hash], amount) <= amountGet
267     )) throw;
268     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
269     orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
270     Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender, r, s);
271   }
272 
273   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
274     uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
275     uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
276     uint feeRebateXfer = 0;
277     if (accountLevelsAddr != 0x0) {
278       uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
279       if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);
280       if (accountLevel==2) feeRebateXfer = feeTakeXfer;
281     }
282     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
283     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
284     tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
285     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
286     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
287   }
288 
289   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {
290     if (!(
291       tokens[tokenGet][sender] >= amount &&
292       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
293     )) return false;
294     return true;
295   }
296 
297   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
298     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
299     if (!(
300       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
301       block.number <= expires
302     )) return 0;
303     uint available1 = safeSub(amountGet, orderFills[user][hash]);
304     uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
305     if (available1<available2) return available1;
306     return available2;
307   }
308 
309   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
310     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
311     return orderFills[user][hash];
312   }
313 
314   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
315     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
316     if (!(orders[msg.sender][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) throw;
317     orderFills[msg.sender][hash] = amountGet;
318     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
319   }
320 }