1 pragma solidity ^0.4.20;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal pure returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeSub(uint a, uint b) internal pure returns (uint) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function safeAdd(uint a, uint b) internal pure returns (uint) {
16     uint c = a + b;
17     assert(c>=a && c>=b);
18     return c;
19   }
20 }
21 
22 contract Token {
23   /// @return total amount of tokens
24   function totalSupply() constant public returns (uint256);
25 
26   /// @param _owner The address from which the balance will be retrieved
27   /// @return The balance
28   function balanceOf(address _owner) constant public returns (uint256);
29 
30   /// @notice send `_value` token to `_to` from `msg.sender`
31   /// @param _to The address of the recipient
32   /// @param _value The amount of token to be transferred
33   /// @return Whether the transfer was successful or not
34   function transfer(address _to, uint256 _value) public returns (bool success);
35 
36   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
37   /// @param _from The address of the sender
38   /// @param _to The address of the recipient
39   /// @param _value The amount of token to be transferred
40   /// @return Whether the transfer was successful or not
41   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
42 
43   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
44   /// @param _spender The address of the account able to transfer the tokens
45   /// @param _value The amount of wei to be approved for transfer
46   /// @return Whether the approval was successful or not
47   function approve(address _spender, uint256 _value) public returns (bool success);
48 
49   /// @param _owner The address of the account owning tokens
50   /// @param _spender The address of the account able to transfer the tokens
51   /// @return Amount of remaining tokens allowed to spent
52   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
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
64     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
65       balances[msg.sender] -= _value;
66       balances[_to] += _value;
67       Transfer(msg.sender, _to, _value);
68       return true;
69     } else { return false; }
70   }
71 
72   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
74       balances[_to] += _value;
75       balances[_from] -= _value;
76       allowed[_from][msg.sender] -= _value;
77       Transfer(_from, _to, _value);
78       return true;
79     } else { return false; }
80   }
81 
82   function balanceOf(address _owner) public constant returns (uint256 balance) {
83     return balances[_owner];
84   }
85 
86   function approve(address _spender, uint256 _value) public returns (bool success) {
87     allowed[msg.sender][_spender] = _value;
88     Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
93     return allowed[_owner][_spender];
94   }
95 
96   mapping(address => uint256) balances;
97   mapping (address => mapping (address => uint256)) allowed;
98   uint256 public totalSupply;
99 }
100 
101 contract ReserveToken is StandardToken, SafeMath {
102   address public minter;
103   function ReserveToken() public {
104     minter = msg.sender;
105   }
106   function create(address account, uint amount) public {
107     require(msg.sender != minter);
108     balances[account] = safeAdd(balances[account], amount);
109     totalSupply = safeAdd(totalSupply, amount);
110   }
111   function destroy(address account, uint amount) public {
112     require(msg.sender != minter);
113     require(balances[account] < amount);
114     balances[account] = safeSub(balances[account], amount);
115     totalSupply = safeSub(totalSupply, amount);
116   }
117 }
118 
119 contract AccountLevels {
120   //given a user, returns an account level
121   //0 = regular user (pays take fee and make fee)
122   //1 = market maker silver (pays take fee, no make fee, gets rebate)
123   //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
124   mapping (address => uint) public accountLevels;
125   function accountLevel(address user) constant public returns(uint) {
126     return accountLevels[user];
127   }
128 }
129 
130 contract AccountLevelsTest is AccountLevels {
131   mapping (address => uint) public accountLevels;
132 
133   function setAccountLevel(address user, uint level) public {
134     accountLevels[user] = level;
135   }
136 
137   function accountLevel(address user) constant public returns(uint) {
138     return accountLevels[user];
139   }
140 }
141 
142 contract BitDex is SafeMath {
143   address public admin; //the admin address
144   address public feeAccount; //the account that will receive fees
145   address public accountLevelsAddr; //the address of the AccountLevels contract
146   uint public feeMake; //percentage times (1 ether)
147   uint public feeTake; //percentage times (1 ether)
148   uint public feeRebate; //percentage times (1 ether)
149   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
150   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
151   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
152 
153   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
154   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
155   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
156   event Deposit(address token, address user, uint amount, uint balance);
157   event Withdraw(address token, address user, uint amount, uint balance);
158 
159   function BitDex(address admin_, address feeAccount_, address accountLevelsAddr_, uint feeMake_, uint feeTake_, uint feeRebate_) public {
160     admin = admin_;
161     feeAccount = feeAccount_;
162     accountLevelsAddr = accountLevelsAddr_;
163     feeMake = feeMake_;
164     feeTake = feeTake_;
165     feeRebate = feeRebate_;
166   }
167 
168   function() public {
169     revert();
170   }
171 
172   function changeAdmin(address admin_) public {
173     require(msg.sender == admin);
174     admin = admin_;
175   }
176 
177   function changeAccountLevelsAddr(address accountLevelsAddr_) public {
178     require(msg.sender == admin);
179     accountLevelsAddr = accountLevelsAddr_;
180   }
181 
182   function changeFeeAccount(address feeAccount_) public {
183     require(msg.sender == admin);
184     feeAccount = feeAccount_;
185   }
186 
187   function changeFeeMake(uint feeMake_) public {
188     require(msg.sender == admin);
189     require(feeMake_ < feeMake);
190     feeMake = feeMake_;
191   }
192 
193   function changeFeeTake(uint feeTake_) public {
194     require(msg.sender == admin);
195     require(feeTake_ < feeTake);
196     require(feeTake_ > feeRebate);
197     feeTake = feeTake_;
198   }
199 
200   function changeFeeRebate(uint feeRebate_) public {
201     require(msg.sender == admin);
202     require(feeRebate_ > feeRebate);
203     require(feeRebate_ < feeTake);
204     feeRebate = feeRebate_;
205   }
206 
207   function deposit() payable public {
208     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
209     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
210   }
211 
212   function withdraw(uint amount) public {
213     require(tokens[0][msg.sender] > amount);
214     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
215     require(!msg.sender.call.value(amount)());
216     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
217   }
218 
219   function depositToken(address token, uint amount) public {
220     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
221     require(token > 0);
222     require(Token(token).transferFrom(msg.sender, this, amount));
223     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
224     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
225   }
226 
227   function withdrawToken(address token, uint amount) public {
228     require(token > 0);
229     require(tokens[token][msg.sender] > amount);
230     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
231     require(!Token(token).transfer(msg.sender, amount));
232     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
233   }
234 
235   function balanceOf(address token, address user) constant public returns (uint) {
236     return tokens[token][user];
237   }
238 
239   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {
240     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
241     orders[msg.sender][hash] = true;
242     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
243   }
244 
245   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
246     //amount is in amountGet terms
247     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
248     if (!(
249       (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
250       block.number <= expires &&
251       safeAdd(orderFills[user][hash], amount) <= amountGet
252     )) revert();
253     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
254     orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
255     Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
256   }
257 
258   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
259     uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
260     uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
261     uint feeRebateXfer = 0;
262     if (accountLevelsAddr != 0x0) {
263       uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
264       if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);
265       if (accountLevel==2) feeRebateXfer = feeTakeXfer;
266     }
267     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
268     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
269     tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
270     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
271     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
272   }
273 
274   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant public returns(bool) {
275     if (!(
276       tokens[tokenGet][sender] >= amount &&
277       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
278     )) return false;
279     return true;
280   }
281 
282   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant public returns(uint) {
283     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
284     if (!(
285       (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
286       block.number <= expires
287     )) return 0;
288     uint available1 = safeSub(amountGet, orderFills[user][hash]);
289     uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
290     if (available1<available2) return available1;
291     return available2;
292   }
293 
294   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant public returns(uint) {
295     bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
296     return orderFills[user][hash];
297   }
298 
299   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
300     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
301     if(!(orders[msg.sender][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) {
302         revert();        
303     }
304     orderFills[msg.sender][hash] = amountGet;
305     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
306   }
307 }