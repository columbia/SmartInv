1 pragma solidity ^0.4.25;
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
20 
21   function assertz(bool assertion) internal pure {
22     require (assertion);
23   }
24 }
25 
26 contract Token {
27   /// @return total amount of tokens
28   function totalSupply() view public returns (uint256 supply);
29 
30   /// @param _owner The address from which the balance will be retrieved
31   /// @return The balance
32   function balanceOf(address _owner) view public returns (uint256 balance);
33 
34   /// @notice send `_value` token to `_to` from `msg.sender`
35   /// @param _to The address of the recipient
36   /// @param _value The amount of token to be transferred
37   /// @return Whether the transfer was successful or not
38   function transfer(address _to, uint256 _value) public returns (bool success);
39 
40   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
41   /// @param _from The address of the sender
42   /// @param _to The address of the recipient
43   /// @param _value The amount of token to be transferred
44   /// @return Whether the transfer was successful or not
45   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
46 
47   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
48   /// @param _spender The address of the account able to transfer the tokens
49   /// @param _value The amount of wei to be approved for transfer
50   /// @return Whether the approval was successful or not
51   function approve(address _spender, uint256 _value) public returns (bool success);
52 
53   /// @param _owner The address of the account owning tokens
54   /// @param _spender The address of the account able to transfer the tokens
55   /// @return Amount of remaining tokens allowed to spent
56   function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
57 
58   event Transfer(address indexed _from, address indexed _to, uint256 _value);
59   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 
61   uint public decimals;
62   string public name;
63 }
64 
65 contract AccountLevels {
66   //given a user, returns an account level
67   //0 = regular user (pays take fee and make fee)
68   //1 = market maker silver (pays take fee, no make fee, gets rebate)
69   //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
70   function accountLevel(address user) view public returns(uint);
71 }
72 
73 contract AccountLevelsTest is AccountLevels {
74   mapping (address => uint) public accountLevels;
75 
76   function setAccountLevel(address user, uint level) public{
77     accountLevels[user] = level;
78   }
79 
80   function accountLevel(address user) view public returns(uint) {
81     return accountLevels[user];
82   }
83 }
84 
85 contract EtherDelta is SafeMath {
86   address public admin; //the admin address
87   address public feeAccount; //the account that will receive fees
88   address public accountLevelsAddr; //the address of the AccountLevels contract
89   uint public feeMake; //percentage times (1 ether)
90   uint public feeTake; //percentage times (1 ether)
91   uint public feeRebate; //percentage times (1 ether)
92   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
93   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
94   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
95 
96   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user,uint singleTokenValue, string orderType, uint blockNo);
97   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user,string orderId);
98   event Trade(address tokenGet, uint amountGet,uint amountReceived, address tokenGive, uint amountGive,uint amountSent, address get, address give,string orderId,uint orderFills);
99   event Deposit(address token, address user, uint amount, uint balance);
100   event Withdraw(address token, address user, uint amount, uint balance);
101 
102   constructor(address admin_, address feeAccount_, address accountLevelsAddr_, uint feeMake_, uint feeTake_, uint feeRebate_) public{
103     admin = admin_;
104     feeAccount = feeAccount_;
105     accountLevelsAddr = accountLevelsAddr_;
106     feeMake = feeMake_;
107     feeTake = feeTake_;
108     feeRebate = feeRebate_;
109   }
110 
111   function() public{
112     require(false);
113   }
114 
115   function changeAdmin(address admin_) public{
116     require (msg.sender == admin);
117     admin = admin_;
118   }
119 
120   function changeAccountLevelsAddr(address accountLevelsAddr_) public{
121     require (msg.sender == admin);
122     accountLevelsAddr = accountLevelsAddr_;
123   }
124 
125   function changeFeeAccount(address feeAccount_) public{
126     require (msg.sender == admin);
127     feeAccount = feeAccount_;
128   }
129 
130   function changeFeeMake(uint feeMake_) public{
131     require (msg.sender == admin);
132     require (feeMake_ < feeMake);
133     feeMake = feeMake_;
134   }
135 
136   function changeFeeTake(uint feeTake_) public{
137     require (msg.sender == admin);
138     require (feeTake_ < feeTake && feeTake_ > feeRebate);
139     feeTake = feeTake_;
140   }
141 
142   function changeFeeRebate(uint feeRebate_) public{
143     require (msg.sender == admin);
144     require (feeRebate_ > feeRebate && feeRebate_ < feeTake) ;
145     feeRebate = feeRebate_;
146   }
147 
148   function deposit() payable public{
149     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
150     emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
151   }
152 
153   function withdraw(uint amount)public {
154     require (tokens[0][msg.sender] >= amount);
155     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
156     require (msg.sender.call.value(amount)()) ;
157     emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
158   }
159 
160   function depositToken(address token, uint amount) public{
161     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
162     require (token!=0) ;
163     require (Token(token).transferFrom(msg.sender, this, amount));
164     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
165     emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
166   }
167 
168   function withdrawToken(address token, uint amount) public {
169     require (token!=0) ;
170     require (tokens[token][msg.sender] >= amount) ;
171     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
172     require (Token(token).transfer(msg.sender, amount)) ;
173     emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
174   }
175 
176   function balanceOf(address token, address user) view public returns (uint) {
177     return tokens[token][user];
178   }
179 
180   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, 
181       uint expires, uint nonce,uint singleTokenValue, string orderType) public{
182     bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
183     orders[msg.sender][hash] = true;
184     emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender,singleTokenValue,orderType,block.number);
185   }
186 
187   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, 
188             uint amount, uint oldBlockNumber,string orderId) public {
189     //amount is in amountGet terms
190     bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
191  
192     require (orders[user][hash] && block.number <= (oldBlockNumber + expires) && safeAdd(orderFills[user][hash], amount) <= amountGet);
193     
194     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
195     orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
196     uint orderFilled = orderFills[user][hash];
197     uint amountSent = (amountGive * amount / amountGet);
198     emit Trade(tokenGet, amountGet, amount, tokenGive, amountGive, amountSent, user, msg.sender, orderId, orderFilled);
199     // anjali
200   }
201 
202   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
203     uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
204     uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
205     uint feeRebateXfer = 0;
206     if (accountLevelsAddr != 0x0) {
207       uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
208       if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);
209       if (accountLevel==2) feeRebateXfer = feeTakeXfer;
210     }
211     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
212     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
213     tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
214     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
215     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
216   }
217 
218   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) view public returns(bool) {
219     if (!(
220       tokens[tokenGet][sender] >= amount &&
221       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
222     )) return false;
223     return true;
224   }
225 
226   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) view public returns(uint) {
227     bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
228     if (!(
229       (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
230       block.number <= expires
231     )) return 0;
232     uint available1 = safeSub(amountGet, orderFills[user][hash]);
233     uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
234     if (available1<available2) return available1;
235     return available2;
236   }
237 
238   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user) view public returns(uint) {
239     bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
240     return orderFills[user][hash];
241   }
242 
243   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, string orderId) public{
244     bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
245     require (orders[msg.sender][hash]);
246     orderFills[msg.sender][hash] = amountGet;
247     emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender,orderId);
248   }
249 }