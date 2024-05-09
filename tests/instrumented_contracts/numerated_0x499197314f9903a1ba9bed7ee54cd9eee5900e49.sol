1 pragma solidity ^0.4.24;
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
23   function totalSupply() public returns (uint256);
24   function balanceOf(address) public returns (uint256) ;
25   function transfer(address, uint256) public returns (bool);
26   function transferFrom(address, address, uint256) public returns (bool);
27   function approve(address, uint256) public returns (bool);
28   function allowance(address, address) public returns (uint256);
29 
30   event Transfer(address indexed _from, address indexed _to, uint256 _value);
31   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 
33   uint public decimals;
34   string public name;
35 }
36 
37 contract StandardToken is Token {
38 
39   function transfer(address _to, uint256 _value) public returns (bool) {
40     //Default assumes totalSupply can't be over max (2^256 - 1).
41     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
42     //Replace the if with this one instead.
43     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
44     //if (balances[msg.sender] >= _value && _value > 0) {
45       balances[msg.sender] -= _value;
46       balances[_to] += _value;
47       emit Transfer(msg.sender, _to, _value);
48       return true;
49     } else { return false; }
50   }
51 
52   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
53     //same as above. Replace this line with the following if you want to protect against wrapping uints.
54     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
55     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
56       balances[_to] += _value;
57       balances[_from] -= _value;
58       allowed[_from][msg.sender] -= _value;
59       emit Transfer(_from, _to, _value);
60       return true;
61     } else { return false; }
62   }
63 
64   function balanceOf(address _owner) public returns (uint256) {
65     return balances[_owner];
66   }
67 
68   function approve(address _spender, uint256 _value) public returns (bool) {
69     allowed[msg.sender][_spender] = _value;
70     emit Approval(msg.sender, _spender, _value);
71     return true;
72   }
73 
74   function allowance(address _owner, address _spender) public returns (uint256) {
75     return allowed[_owner][_spender];
76   }
77 
78   mapping(address => uint256) balances;
79 
80   mapping (address => mapping (address => uint256)) allowed;
81 
82   uint256 public totalSupply;
83 }
84 
85 contract ReserveToken is StandardToken, SafeMath {
86   address public minter;
87   constructor(ReserveToken) public {
88     minter = msg.sender;
89   }
90   function create(address account, uint amount) public {
91     if (msg.sender != minter) revert();
92     balances[account] = safeAdd(balances[account], amount);
93     totalSupply = safeAdd(totalSupply, amount);
94   }
95   function destroy(address account, uint amount) public {
96     if (msg.sender != minter) revert();
97     if (balances[account] < amount) revert();
98     balances[account] = safeSub(balances[account], amount);
99     totalSupply = safeSub(totalSupply, amount);
100   }
101 }
102 
103 contract AccountLevels {
104   //given a user, returns an account level
105   //0 = regular user (pays take fee and make fee)
106   //1 = market maker silver (pays take fee, no make fee, gets rebate)
107   //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
108   function accountLevel(address) public returns(uint); 
109 }
110 
111 contract AccountLevelsTest is AccountLevels {
112   mapping (address => uint) public accountLevels;
113 
114   function setAccountLevel(address user, uint level) public {
115     accountLevels[user] = level;
116   }
117 
118   function accountLevel(address user) public returns(uint) {
119     return accountLevels[user];
120   }
121 }
122 
123 contract Ethernext is SafeMath {
124   address public admin; //the admin address
125   address public feeAccount; //the account that will receive fees
126   address public accountLevelsAddr; //the address of the AccountLevels contract
127   uint public feeMake; //percentage times (1 ether)
128   uint public feeTake; //percentage times (1 ether)
129   uint public feeRebate; //percentage times (1 ether)
130   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
131   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
132   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
133 
134   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
135   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
136   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
137   event Deposit(address token, address user, uint amount, uint balance);
138   event Withdraw(address token, address user, uint amount, uint balance);
139 
140   constructor(address admin_, address feeAccount_, address accountLevelsAddr_, uint feeMake_, uint feeTake_, uint feeRebate_) public {
141     admin = admin_;
142     feeAccount = feeAccount_;
143     accountLevelsAddr = accountLevelsAddr_;
144     feeMake = feeMake_;
145     feeTake = feeTake_;
146     feeRebate = feeRebate_;
147   }
148 
149   function() public {
150     revert();
151   }
152 
153   function changeAdmin(address admin_) public {
154     if (msg.sender != admin) revert();
155     admin = admin_;
156   }
157 
158   function changeAccountLevelsAddr(address accountLevelsAddr_) public {
159     if (msg.sender != admin) revert();
160     accountLevelsAddr = accountLevelsAddr_;
161   }
162 
163   function changeFeeAccount(address feeAccount_) public {
164     if (msg.sender != admin) revert();
165     feeAccount = feeAccount_;
166   }
167 
168   function changeFeeMake(uint feeMake_) public {
169     if (msg.sender != admin) revert();
170     if (feeMake_ > feeMake) revert();
171     feeMake = feeMake_;
172   }
173 
174   function changeFeeTake(uint feeTake_) public {
175     if (msg.sender != admin) revert();
176     if (feeTake_ > feeTake || feeTake_ < feeRebate) revert();
177     feeTake = feeTake_;
178   }
179 
180   function changeFeeRebate(uint feeRebate_) public {
181     if (msg.sender != admin) revert();
182     if (feeRebate_ < feeRebate || feeRebate_ > feeTake) revert();
183     feeRebate = feeRebate_;
184   }
185 
186   function deposit() payable public {
187     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
188     emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
189   }
190 
191   function withdraw(uint amount) public{
192     if (tokens[0][msg.sender] < amount) revert();
193     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
194     if (!msg.sender.send(amount)) revert();
195     emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
196   }
197 
198   function depositToken(address token, uint amount) public {
199     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
200     if (token==0) revert();
201     if (!Token(token).transferFrom(msg.sender, this, amount)) revert();
202     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
203     emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
204   }
205 
206   function withdrawToken(address token, uint amount) public {
207     if (token==0) revert();
208     if (tokens[token][msg.sender] < amount) revert();
209     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
210     if (!Token(token).transfer(msg.sender, amount)) revert();
211     emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
212   }
213 
214   function balanceOf(address token, address user) public constant returns (uint) {
215     return tokens[token][user];
216   }
217 
218   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {
219     bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
220     orders[msg.sender][hash] = true;
221     emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
222   }
223 
224   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
225     //amount is in amountGet terms
226     bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
227     if (!(
228       (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
229       block.number <= expires &&
230       safeAdd(orderFills[user][hash], amount) <= amountGet
231     )) revert();
232     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
233     orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
234     emit Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
235   }
236 
237   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
238     uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
239     uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
240     uint feeRebateXfer = 0;
241     if (accountLevelsAddr != 0x0) {
242       uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
243       if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);
244       if (accountLevel==2) feeRebateXfer = feeTakeXfer;
245     }
246     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
247     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
248     tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
249     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
250     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
251   }
252 
253   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public constant returns(bool) {
254     if (!(
255       tokens[tokenGet][sender] >= amount &&
256       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
257     )) return false;
258     return true;
259   }
260 
261   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {
262     bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
263     if (!(
264       (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
265       block.number <= expires
266     )) return 0;
267     uint available1 = safeSub(amountGet, orderFills[user][hash]);
268     uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
269     if (available1<available2) return available1;
270     return available2;
271   }
272 
273   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8, bytes32, bytes32) public constant returns(uint) {
274     bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
275     return orderFills[user][hash];
276   }
277 
278   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
279     bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
280     if (!(orders[msg.sender][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == msg.sender)) revert();
281     orderFills[msg.sender][hash] = amountGet;
282     emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
283   }
284 }