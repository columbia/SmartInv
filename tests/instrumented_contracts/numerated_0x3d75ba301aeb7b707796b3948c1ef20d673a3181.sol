1 pragma solidity ^0.4.9;
2 
3 // ----------------------------------------------------------------------------
4 // 'Datodex.com' DEX contract
5 //
6 // Admin       : 0x50b16167821eFAbdbC991eDd2d166BbA4BCA63B2
7 // fees        : 0.08%
8 //
9 //
10 // 
11 // In God we Trust
12 // ----------------------------------------------------------------------------
13 
14 
15 contract SafeMath {
16   function safeMul(uint a, uint b) internal returns (uint) {
17     uint c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function safeSub(uint a, uint b) internal returns (uint) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function safeAdd(uint a, uint b) internal returns (uint) {
28     uint c = a + b;
29     assert(c>=a && c>=b);
30     return c;
31   }
32 
33   function assert(bool assertion) internal {
34     if (!assertion) throw;
35   }
36 }
37 
38 contract Token {
39   /// @return total amount of tokens
40   function totalSupply() constant returns (uint256 supply) {}
41 
42   /// @param _owner The address from which the balance will be retrieved
43   /// @return The balance
44   function balanceOf(address _owner) constant returns (uint256 balance) {}
45 
46   /// @notice send `_value` token to `_to` from `msg.sender`
47   /// @param _to The address of the recipient
48   /// @param _value The amount of token to be transferred
49   /// @return Whether the transfer was successful or not
50   function transfer(address _to, uint256 _value) returns (bool success) {}
51 
52   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
53   /// @param _from The address of the sender
54   /// @param _to The address of the recipient
55   /// @param _value The amount of token to be transferred
56   /// @return Whether the transfer was successful or not
57   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
58 
59   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
60   /// @param _spender The address of the account able to transfer the tokens
61   /// @param _value The amount of wei to be approved for transfer
62   /// @return Whether the approval was successful or not
63   function approve(address _spender, uint256 _value) returns (bool success) {}
64 
65   /// @param _owner The address of the account owning tokens
66   /// @param _spender The address of the account able to transfer the tokens
67   /// @return Amount of remaining tokens allowed to spent
68   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
69 
70   event Transfer(address indexed _from, address indexed _to, uint256 _value);
71   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72 
73   uint public decimals;
74   string public name;
75 }
76 
77 contract StandardToken is Token {
78 
79   function transfer(address _to, uint256 _value) returns (bool success) {
80     //Default assumes totalSupply can't be over max (2^256 - 1).
81     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
82     //Replace the if with this one instead.
83     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
84     //if (balances[msg.sender] >= _value && _value > 0) {
85       balances[msg.sender] -= _value;
86       balances[_to] += _value;
87       Transfer(msg.sender, _to, _value);
88       return true;
89     } else { return false; }
90   }
91 
92   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
93     //same as above. Replace this line with the following if you want to protect against wrapping uints.
94     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
95     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
96       balances[_to] += _value;
97       balances[_from] -= _value;
98       allowed[_from][msg.sender] -= _value;
99       Transfer(_from, _to, _value);
100       return true;
101     } else { return false; }
102   }
103 
104   function balanceOf(address _owner) constant returns (uint256 balance) {
105     return balances[_owner];
106   }
107 
108   function approve(address _spender, uint256 _value) returns (bool success) {
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
115     return allowed[_owner][_spender];
116   }
117 
118   mapping(address => uint256) balances;
119 
120   mapping (address => mapping (address => uint256)) allowed;
121 
122   uint256 public totalSupply;
123 }
124 
125 contract ReserveToken is StandardToken, SafeMath {
126   address public minter;
127   function ReserveToken() {
128     minter = msg.sender;
129   }
130   function create(address account, uint amount) {
131     if (msg.sender != minter) throw;
132     balances[account] = safeAdd(balances[account], amount);
133     totalSupply = safeAdd(totalSupply, amount);
134   }
135   function destroy(address account, uint amount) {
136     if (msg.sender != minter) throw;
137     if (balances[account] < amount) throw;
138     balances[account] = safeSub(balances[account], amount);
139     totalSupply = safeSub(totalSupply, amount);
140   }
141 }
142 
143 contract AccountLevels {
144   //given a user, returns an account level
145   //0 = regular user (pays take fee and make fee)
146   //1 = market maker silver (pays take fee, no make fee, gets rebate)
147   //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
148   function accountLevel(address user) constant returns(uint) {}
149 }
150 
151 contract AccountLevelsTest is AccountLevels {
152   mapping (address => uint) public accountLevels;
153 
154   function setAccountLevel(address user, uint level) {
155     accountLevels[user] = level;
156   }
157 
158   function accountLevel(address user) constant returns(uint) {
159     return accountLevels[user];
160   }
161 }
162 
163 contract DatoDEX is SafeMath {
164   address public admin; //the admin address
165   address public feeAccount; //the account that will receive fees
166   address public accountLevelsAddr; //the address of the AccountLevels contract
167   uint public feeMake; //percentage times (1 ether)
168   uint public feeTake; //percentage times (1 ether)
169   uint public feeRebate; //percentage times (1 ether)
170   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
171   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
172   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
173 
174   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
175   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
176   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
177   event Deposit(address token, address user, uint amount, uint balance);
178   event Withdraw(address token, address user, uint amount, uint balance);
179 
180   function DatoDEX(address admin_, address feeAccount_, address accountLevelsAddr_, uint feeMake_, uint feeTake_, uint feeRebate_) {
181     admin = admin_;
182     feeAccount = feeAccount_;
183     accountLevelsAddr = accountLevelsAddr_;
184     feeMake = feeMake_;
185     feeTake = feeTake_;
186     feeRebate = feeRebate_;
187   }
188 
189   function() {
190     throw;
191   }
192 
193   function changeAdmin(address admin_) {
194     if (msg.sender != admin) throw;
195     admin = admin_;
196   }
197 
198   function changeAccountLevelsAddr(address accountLevelsAddr_) {
199     if (msg.sender != admin) throw;
200     accountLevelsAddr = accountLevelsAddr_;
201   }
202 
203   function changeFeeAccount(address feeAccount_) {
204     if (msg.sender != admin) throw;
205     feeAccount = feeAccount_;
206   }
207 
208   function changeFeeMake(uint feeMake_) {
209     if (msg.sender != admin) throw;
210     if (feeMake_ > feeMake) throw;
211     feeMake = feeMake_;
212   }
213 
214   function changeFeeTake(uint feeTake_) {
215     if (msg.sender != admin) throw;
216     if (feeTake_ > feeTake || feeTake_ < feeRebate) throw;
217     feeTake = feeTake_;
218   }
219 
220   function changeFeeRebate(uint feeRebate_) {
221     if (msg.sender != admin) throw;
222     if (feeRebate_ < feeRebate || feeRebate_ > feeTake) throw;
223     feeRebate = feeRebate_;
224   }
225 
226   function deposit() payable {
227     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
228     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
229   }
230 
231   function withdraw(uint amount) {
232     if (tokens[0][msg.sender] < amount) throw;
233     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
234     if (!msg.sender.call.value(amount)()) throw;
235     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
236   }
237 
238   function depositToken(address token, uint amount) {
239     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
240     if (token==0) throw;
241     if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
242     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
243     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
244   }
245 
246   function withdrawToken(address token, uint amount) {
247     if (token==0) throw;
248     if (tokens[token][msg.sender] < amount) throw;
249     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
250     if (!Token(token).transfer(msg.sender, amount)) throw;
251     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
252   }
253 
254   function balanceOf(address token, address user) constant returns (uint) {
255     return tokens[token][user];
256   }
257 
258   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {
259     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
260     orders[msg.sender][hash] = true;
261     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
262   }
263 
264   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
265     //amount is in amountGet terms
266     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
267     if (!(
268       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
269       block.number <= expires &&
270       safeAdd(orderFills[user][hash], amount) <= amountGet
271     )) throw;
272     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
273     orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
274     Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
275   }
276 
277   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
278     uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
279     uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
280     uint feeRebateXfer = 0;
281     if (accountLevelsAddr != 0x0) {
282       uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
283       if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);
284       if (accountLevel==2) feeRebateXfer = feeTakeXfer;
285     }
286     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
287     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
288     tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
289     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
290     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
291   }
292 
293   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {
294     if (!(
295       tokens[tokenGet][sender] >= amount &&
296       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
297     )) return false;
298     return true;
299   }
300 
301   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
302     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
303     if (!(
304       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
305       block.number <= expires
306     )) return 0;
307     uint available1 = safeSub(amountGet, orderFills[user][hash]);
308     uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
309     if (available1<available2) return available1;
310     return available2;
311   }
312 
313   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
314     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
315     return orderFills[user][hash];
316   }
317 
318   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
319     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
320     if (!(orders[msg.sender][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) throw;
321     orderFills[msg.sender][hash] = amountGet;
322     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
323   }
324 }