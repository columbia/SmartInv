1 pragma solidity ^0.4.20;
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
20 }
21 
22 contract Token {
23   /// @return total amount of tokens
24   function totalSupply() constant public returns (uint256 supply) {}
25 
26   /// @param _owner The address from which the balance will be retrieved
27   /// @return The balance
28   function balanceOf(address _owner) constant public returns (uint256 balance) {}
29 
30   /// @notice send `_value` token to `_to` from `msg.sender`
31   /// @param _to The address of the recipient
32   /// @param _value The amount of token to be transferred
33   /// @return Whether the transfer was successful or not
34   function transfer(address _to, uint256 _value) public returns (bool success) {}
35 
36   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
37   /// @param _from The address of the sender
38   /// @param _to The address of the recipient
39   /// @param _value The amount of token to be transferred
40   /// @return Whether the transfer was successful or not
41   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
42 
43   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
44   /// @param _spender The address of the account able to transfer the tokens
45   /// @param _value The amount of wei to be approved for transfer
46   /// @return Whether the approval was successful or not
47   function approve(address _spender, uint256 _value) public returns (bool success) {}
48 
49   /// @param _owner The address of the account owning tokens
50   /// @param _spender The address of the account able to transfer the tokens
51   /// @return Amount of remaining tokens allowed to spent
52   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {}
53 
54   event Transfer(address indexed _from, address indexed _to, uint256 _value);
55   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
56 
57   uint public decimals;
58   string public name;
59 }
60 
61 contract StandardToken is Token {
62 
63   function transfer(address _to, uint256 _value) public returns (bool success) {
64     //Default assumes totalSupply can't be over max (2^256 - 1).
65     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
66     //Replace the if with this one instead.
67     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68     //if (balances[msg.sender] >= _value && _value > 0) {
69       balances[msg.sender] -= _value;
70       balances[_to] += _value;
71       emit Transfer(msg.sender, _to, _value);
72       return true;
73     } else { return false; }
74   }
75 
76   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77     //same as above. Replace this line with the following if you want to protect against wrapping uints.
78     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
79     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
80       balances[_to] += _value;
81       balances[_from] -= _value;
82       allowed[_from][msg.sender] -= _value;
83       emit Transfer(_from, _to, _value);
84       return true;
85     } else { return false; }
86   }
87 
88   function balanceOf(address _owner) constant public returns (uint256 balance) {
89     return balances[_owner];
90   }
91 
92   function approve(address _spender, uint256 _value) public returns (bool success) {
93     allowed[msg.sender][_spender] = _value;
94     emit Approval(msg.sender, _spender, _value);
95     return true;
96   }
97 
98   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
99     return allowed[_owner][_spender];
100   }
101 
102   mapping(address => uint256) balances;
103 
104   mapping (address => mapping (address => uint256)) allowed;
105 
106   uint256 public totalSupply;
107 }
108 
109 contract ReserveToken is StandardToken, SafeMath {
110   address public minter;
111   function ReserveToken() public {
112     minter = msg.sender;
113   }
114   function create(address account, uint amount) public {
115     if (msg.sender != minter) revert();
116     balances[account] = safeAdd(balances[account], amount);
117     totalSupply = safeAdd(totalSupply, amount);
118   }
119   function destroy(address account, uint amount) public {
120     if (msg.sender != minter) revert();
121     if (balances[account] < amount) revert();
122     balances[account] = safeSub(balances[account], amount);
123     totalSupply = safeSub(totalSupply, amount);
124   }
125 }
126 
127 contract AccountLevels {
128   //given a user, returns an account level
129   //0 = regular user (pays take fee and make fee)
130   //1 = market maker silver (pays take fee, no make fee, gets rebate)
131   //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
132   function accountLevel(address user) constant public returns(uint) {}
133 }
134 
135 contract AccountLevelsTest is AccountLevels {
136   mapping (address => uint) public accountLevels;
137 
138   function setAccountLevel(address user, uint level) public {
139     accountLevels[user] = level;
140   }
141 
142   function accountLevel(address user) constant public returns(uint) {
143     return accountLevels[user];
144   }
145 }
146 
147 contract PolarisDEX is SafeMath {
148   address public admin; //the admin address
149   address public feeAccount; //the account that will receive fees
150   address public accountLevelsAddr; //the address of the AccountLevels contract
151   uint public feeMake; //percentage times (1 ether)
152   uint public feeTake; //percentage times (1 ether)
153   uint public feeRebate; //percentage times (1 ether)
154   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
155   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
156   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
157 
158   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
159   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
160   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
161   event Deposit(address token, address user, uint amount, uint balance);
162   event Withdraw(address token, address user, uint amount, uint balance);
163 
164   function PolarisDEX(address admin_, address feeAccount_, address accountLevelsAddr_, uint feeMake_, uint feeTake_, uint feeRebate_) public {
165     admin = admin_;
166     feeAccount = feeAccount_;
167     accountLevelsAddr = accountLevelsAddr_;
168     feeMake = feeMake_;
169     feeTake = feeTake_;
170     feeRebate = feeRebate_;
171   }
172 
173   function () public {
174     revert();
175   }
176 
177   function changeAdmin(address admin_) public {
178     if (msg.sender != admin) revert();
179     admin = admin_;
180   }
181 
182   function changeAccountLevelsAddr(address accountLevelsAddr_) public {
183     if (msg.sender != admin) revert();
184     accountLevelsAddr = accountLevelsAddr_;
185   }
186 
187   function changeFeeAccount(address feeAccount_) public {
188     if (msg.sender != admin) revert();
189     feeAccount = feeAccount_;
190   }
191 
192   function changeFeeMake(uint feeMake_) public {
193     if (msg.sender != admin) revert();
194     if (feeMake_ > feeMake) revert();
195     feeMake = feeMake_;
196   }
197 
198   function changeFeeTake(uint feeTake_) public {
199     if (msg.sender != admin) revert();
200     if (feeTake_ > feeTake || feeTake_ < feeRebate) revert();
201     feeTake = feeTake_;
202   }
203 
204   function changeFeeRebate(uint feeRebate_) public {
205     if (msg.sender != admin) revert();
206     if (feeRebate_ < feeRebate || feeRebate_ > feeTake) revert();
207     feeRebate = feeRebate_;
208   }
209 
210   function deposit() payable public {
211     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
212     emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
213   }
214 
215   function withdraw(uint amount) public {
216     if (tokens[0][msg.sender] < amount) revert();
217     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
218     if (!msg.sender.call.value(amount)()) revert();
219     emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
220   }
221 
222   function depositToken(address token, uint amount) public {
223     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
224     if (token==0) revert();
225     if (!Token(token).transferFrom(msg.sender, this, amount)) revert();
226     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
227     emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
228   }
229 
230   function withdrawToken(address token, uint amount) public {
231     if (token==0) revert();
232     if (tokens[token][msg.sender] < amount) revert();
233     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
234     if (!Token(token).transfer(msg.sender, amount)) revert();
235     emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
236   }
237 
238   function balanceOf(address token, address user) constant public returns (uint) {
239     return tokens[token][user];
240   }
241 
242   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {
243     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
244     orders[msg.sender][hash] = true;
245     emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
246   }
247 
248   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
249     //amount is in amountGet terms
250     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
251     if (!(
252       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
253       block.number <= expires &&
254       safeAdd(orderFills[user][hash], amount) <= amountGet
255     )) revert();
256     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
257     orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
258     emit Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
259   }
260 
261   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
262     uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
263     uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
264     uint feeRebateXfer = 0;
265     if (accountLevelsAddr != 0x0) {
266       uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
267       if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);
268       if (accountLevel==2) feeRebateXfer = feeTakeXfer;
269     }
270     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
271     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
272     tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
273     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
274     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
275   }
276 
277   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant public returns(bool) {
278     if (!(
279       tokens[tokenGet][sender] >= amount &&
280       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
281     )) return false;
282     return true;
283   }
284 
285   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant public returns(uint) {
286     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
287     if (!(
288       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
289       block.number <= expires
290     )) return 0;
291     uint available1 = safeSub(amountGet, orderFills[user][hash]);
292     uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
293     if (available1<available2) return available1;
294     return available2;
295   }
296 
297   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant public returns(uint) {
298     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
299     return orderFills[user][hash];
300   }
301 
302   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
303     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
304     if (!(orders[msg.sender][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) revert();
305     orderFills[msg.sender][hash] = amountGet;
306     emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
307   }
308 }