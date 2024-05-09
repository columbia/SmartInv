1 pragma solidity ^0.4.22;
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
63   string public symbol;
64 }
65 
66 contract TradexOne is SafeMath {
67   address public admin; //the admin address
68   address public feeAccount; //the account that will receive fees
69   mapping (address => uint) public feeMake; //percentage times (1 ether) (sell fee)
70   mapping (address => uint) public feeTake; //percentage times (1 ether) (buy fee)
71   mapping (address => uint) public feeDeposit; //percentage times (1 ether)
72   mapping (address => uint) public feeWithdraw; //percentage times (1 ether)
73   
74   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
75   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
76   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
77   mapping (address => bool) public activeTokens;
78   mapping (address => uint) public tokensMinAmountBuy;
79   mapping (address => uint) public tokensMinAmountSell;
80 
81   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
82   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
83   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
84   event Deposit(address token, address user, uint amount, uint balance);
85   event Withdraw(address token, address user, uint amount, uint balance);
86   event ActivateToken(address token, string symbol);
87   event DeactivateToken(address token, string symbol);
88 
89   function TradexOne(address admin_, address feeAccount_) {
90     admin = admin_;
91     feeAccount = feeAccount_;
92   }
93 
94   function() {
95     throw;
96   }
97   
98   
99   function activateToken(address token) {
100     if (msg.sender != admin) throw;
101     activeTokens[token] = true;
102     ActivateToken(token, Token(token).symbol());
103   }
104   function deactivateToken(address token) {
105     if (msg.sender != admin) throw;
106     activeTokens[token] = false;
107     DeactivateToken(token, Token(token).symbol());
108   }
109   function isTokenActive(address token) constant returns(bool) {
110     if (token == 0)
111       return true; // eth is always active
112     return activeTokens[token];
113   }
114   
115   function setTokenMinAmountBuy(address token, uint amount) {
116     if (msg.sender != admin) throw;
117     tokensMinAmountBuy[token] = amount;
118   }
119   function setTokenMinAmountSell(address token, uint amount) {
120     if (msg.sender != admin) throw;
121     tokensMinAmountSell[token] = amount;
122   }
123   
124   function setTokenFeeMake(address token, uint feeMake_) {
125     if (msg.sender != admin) throw;
126     feeMake[token] = feeMake_;
127   }
128   function setTokenFeeTake(address token, uint feeTake_) {
129     if (msg.sender != admin) throw;
130     feeTake[token] = feeTake_;
131   }
132   function setTokenFeeDeposit(address token, uint feeDeposit_) {
133     if (msg.sender != admin) throw;
134     feeDeposit[token] = feeDeposit_;
135   }
136   function setTokenFeeWithdraw(address token, uint feeWithdraw_) {
137     if (msg.sender != admin) throw;
138     feeWithdraw[token] = feeWithdraw_;
139   }
140   
141   
142   function changeAdmin(address admin_) {
143     if (msg.sender != admin) throw;
144     admin = admin_;
145   }
146 
147   function changeFeeAccount(address feeAccount_) {
148     if (msg.sender != admin) throw;
149     feeAccount = feeAccount_;
150   }
151 
152   function deposit() payable {
153     uint feeDepositXfer = safeMul(msg.value, feeDeposit[0]) / (1 ether);
154     uint depositAmount = safeSub(msg.value, feeDepositXfer);
155     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], depositAmount);
156     tokens[0][feeAccount] = safeAdd(tokens[0][feeAccount], feeDepositXfer);
157     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
158   }
159 
160   function withdraw(uint amount) {
161     if (tokens[0][msg.sender] < amount) throw;
162     uint feeWithdrawXfer = safeMul(amount, feeWithdraw[0]) / (1 ether);
163     uint withdrawAmount = safeSub(amount, feeWithdrawXfer);
164     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
165     tokens[0][feeAccount] = safeAdd(tokens[0][feeAccount], feeWithdrawXfer);
166     if (!msg.sender.call.value(withdrawAmount)()) throw;
167     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
168   }
169 
170   function depositToken(address token, uint amount) {
171     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
172     if (token==0) throw;
173     if (!isTokenActive(token)) throw;
174     if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
175     uint feeDepositXfer = safeMul(amount, feeDeposit[token]) / (1 ether);
176     uint depositAmount = safeSub(amount, feeDepositXfer);
177     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], depositAmount);
178     tokens[token][feeAccount] = safeAdd(tokens[token][feeAccount], feeDepositXfer);
179     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
180   }
181 
182   function withdrawToken(address token, uint amount) {
183     if (token==0) throw;
184     if (tokens[token][msg.sender] < amount) throw;
185     uint feeWithdrawXfer = safeMul(amount, feeWithdraw[token]) / (1 ether);
186     uint withdrawAmount = safeSub(amount, feeWithdrawXfer);
187     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
188     tokens[token][feeAccount] = safeAdd(tokens[token][feeAccount], feeWithdrawXfer);
189     if (!Token(token).transfer(msg.sender, withdrawAmount)) throw;
190     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
191   }
192 
193   function balanceOf(address token, address user) constant returns (uint) {
194     return tokens[token][user];
195   }
196 
197   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {
198     if (!isTokenActive(tokenGet) || !isTokenActive(tokenGive)) throw;
199     if (amountGet < tokensMinAmountBuy[tokenGet]) throw;
200     if (amountGive < tokensMinAmountSell[tokenGive]) throw;
201     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
202     orders[msg.sender][hash] = true;
203     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
204   }
205 
206   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
207     if (!isTokenActive(tokenGet) || !isTokenActive(tokenGive)) throw;
208     //amount is in amountGet terms
209     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
210     if (!(
211       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
212       block.number <= expires &&
213       safeAdd(orderFills[user][hash], amount) <= amountGet
214     )) throw;
215     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
216     orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
217     Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
218   }
219 
220   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
221     uint feeMakeXfer = safeMul(amount, feeMake[tokenGet]) / (1 ether);
222     uint feeTakeXfer = safeMul(amount, feeTake[tokenGet]) / (1 ether);
223     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
224     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(amount, feeMakeXfer));
225     tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeAdd(feeMakeXfer, feeTakeXfer));
226     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
227     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
228   }
229 
230   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {
231     if (!isTokenActive(tokenGet) || !isTokenActive(tokenGive)) return false;
232     if (!(
233       tokens[tokenGet][sender] >= amount &&
234       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
235     )) return false;
236     return true;
237   }
238 
239   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
240     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
241     if (!(
242       (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
243       block.number <= expires
244     )) return 0;
245     uint available1 = safeSub(amountGet, orderFills[user][hash]);
246     uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
247     if (available1<available2) return available1;
248     return available2;
249   }
250 
251   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
252     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
253     return orderFills[user][hash];
254   }
255 
256   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
257     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
258     if (!(orders[msg.sender][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) throw;
259     orderFills[msg.sender][hash] = amountGet;
260     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
261   }
262 }