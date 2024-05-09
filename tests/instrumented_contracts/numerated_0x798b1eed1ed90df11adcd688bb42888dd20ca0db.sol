1 pragma solidity ^0.5.2;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal pure returns (uint) {
5     if (a == 0) {
6       return 0;
7     }
8     uint c = a * b;
9     require(c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal pure returns (uint) {
14     require(b > 0);
15     uint c = a / b;
16     return c;
17   }
18 
19   function sub(uint a, uint b) internal pure returns (uint) {
20   require(b <= a);
21     uint c = a - b;
22     return c;
23   }
24 
25   function add(uint a, uint b) internal pure returns (uint) {
26     uint c = a + b;
27     require(c >= a);
28     return c;
29   }
30 }
31 
32 contract Token {
33   function totalSupply() public returns (uint supply) {}
34   function balanceOf(address _owner) public returns (uint balance) {}
35   function transfer(address _to, uint _value) public returns (bool success) {}
36   function transferFrom(address _from, address _to, uint _value) public  returns (bool success) {}
37   function approve(address _spender, uint _value) public returns (bool success) {}
38   function allowance(address _owner, address _spender) public returns (uint remaining) {}
39   event Transfer(address indexed _from, address indexed _to, uint _value);
40   event Approval(address indexed _owner, address indexed _spender, uint _value);
41   uint public decimals;
42   string public name;
43   string public symbol;
44 }
45 
46 contract DEX_Orgon {
47   using SafeMath for uint;
48 
49   address public admin; //the admin address
50   address public feeAccount; //the account that will receive fees
51   mapping (address => uint) public feeMake; //percentage times (1 ether) (sell fee)
52   mapping (address => uint) public feeTake; //percentage times (1 ether) (buy fee)
53   mapping (address => uint) public feeDeposit; //percentage times (1 ether)
54   mapping (address => uint) public feeWithdraw; //percentage times (1 ether)
55   
56   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
57   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
58   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
59   mapping (address => bool) public activeTokens;
60   mapping (address => uint) public tokensMinAmountBuy;
61   mapping (address => uint) public tokensMinAmountSell;
62 
63   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
64   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
65   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
66   event Deposit(address token, address user, uint amount, uint balance);
67   event Withdraw(address token, address user, uint amount, uint balance);
68   event ActivateToken(address token, string symbol);
69   event DeactivateToken(address token, string symbol);
70 
71   constructor (address admin_, address feeAccount_) public {
72     admin = admin_;
73     feeAccount = feeAccount_;
74   }
75 
76   function changeAdmin(address admin_) public {
77     require (msg.sender == admin);
78     admin = admin_;
79   }
80 
81   function changeFeeAccount(address feeAccount_) public {
82     require (msg.sender == admin);
83     feeAccount = feeAccount_;
84   }
85 
86   function deposit() public payable {
87     uint feeDepositXfer = msg.value.mul(feeDeposit[address(0)]) / (1 ether);
88     uint depositAmount = msg.value.sub(feeDepositXfer);
89     tokens[address(0)][msg.sender] = tokens[address(0)][msg.sender].add(depositAmount);
90     tokens[address(0)][feeAccount] = tokens[address(0)][feeAccount].add(feeDepositXfer);
91     emit Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);
92   }
93 
94   function withdraw(uint amount) public {
95     require (tokens[address(0)][msg.sender] >= amount);
96     uint feeWithdrawXfer = amount.mul(feeWithdraw[address(0)]) / (1 ether);
97     uint withdrawAmount = amount.sub(feeWithdrawXfer);
98     tokens[address(0)][msg.sender] = tokens[address(0)][msg.sender].sub(amount);
99     tokens[address(0)][feeAccount] = tokens[address(0)][feeAccount].add(feeWithdrawXfer);
100     msg.sender.transfer(withdrawAmount);
101     emit Withdraw(address(0), msg.sender, amount, tokens[address(0)][msg.sender]);
102   }
103 
104   function depositToken(address token, uint amount) public {
105     require (token != address(0));
106     require (isTokenActive(token));
107     require(Token(token).transferFrom(msg.sender, address(this), amount));
108     uint feeDepositXfer = amount.mul(feeDeposit[token]) / (1 ether);
109     uint depositAmount = amount.sub(feeDepositXfer);
110     tokens[token][msg.sender] = tokens[token][msg.sender].add(depositAmount);
111     tokens[token][feeAccount] = tokens[token][feeAccount].add(feeDepositXfer);
112     emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
113   }
114 
115   function withdrawToken(address token, uint amount) public {
116     require (token != address(0));
117     require (tokens[token][msg.sender] >= amount);
118     uint feeWithdrawXfer = amount.mul(feeWithdraw[token]) / (1 ether);
119     uint withdrawAmount = amount.sub(feeWithdrawXfer);
120     tokens[token][msg.sender] = tokens[token][msg.sender].sub(amount);
121     tokens[token][feeAccount] = tokens[token][feeAccount].add(feeWithdrawXfer);
122     require (Token(token).transfer(msg.sender, withdrawAmount));
123     emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
124   }
125 
126   function balanceOf(address token, address user) view public returns (uint) {
127     return tokens[token][user];
128   }
129 
130   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {
131     require (isTokenActive(tokenGet) && isTokenActive(tokenGive));
132     require (amountGet >= tokensMinAmountBuy[tokenGet]) ;
133     require (amountGive >= tokensMinAmountSell[tokenGive]) ;
134     bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
135     orders[msg.sender][hash] = true;
136     emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
137   }
138 
139   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
140     require (isTokenActive(tokenGet) && isTokenActive(tokenGive));
141     //amount is in amountGet terms
142     bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
143     require (
144       (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
145       block.number <= expires &&
146       orderFills[user][hash].add(amount) <= amountGet
147     );
148     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
149     orderFills[user][hash] = orderFills[user][hash].add(amount);
150     emit Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
151   }
152 
153   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
154     uint feeMakeXfer = amount.mul(feeMake[tokenGet]) / (1 ether);
155     uint feeTakeXfer = amount.mul(feeTake[tokenGet]) / (1 ether);
156     tokens[tokenGet][msg.sender] = tokens[tokenGet][msg.sender].sub(amount.add(feeTakeXfer));
157     tokens[tokenGet][user] = tokens[tokenGet][user].add(amount.sub(feeMakeXfer));
158     tokens[tokenGet][feeAccount] = tokens[tokenGet][feeAccount].add(feeMakeXfer.add(feeTakeXfer));
159     tokens[tokenGive][user] = tokens[tokenGive][user].sub(amountGive.mul(amount).div(amountGet));
160     tokens[tokenGive][msg.sender] = tokens[tokenGive][msg.sender].add(amountGive.mul(amount).div(amountGet));
161   }
162 
163   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) view public returns(bool) {
164     if (!isTokenActive(tokenGet) || !isTokenActive(tokenGive)) return false;
165     if (!(
166       tokens[tokenGet][sender] >= amount &&
167       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
168     )) return false;
169     return true;
170   }
171 
172   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) view public returns(uint) {
173     bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
174     if (!(
175       (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
176       block.number <= expires
177     )) return 0;
178     return available(amountGet,  tokenGive,  amountGive, user, hash);
179   }
180   
181   function available(uint amountGet, address tokenGive, uint amountGive, address user, bytes32 hash) view private  returns(uint) {
182     uint available1 = available1(user, amountGet, hash);
183     uint available2 = available2(user, tokenGive, amountGet, amountGive);
184     if (available1 < available2) return available1;
185     return available2;
186   }
187   
188   
189   function available1(address user, uint amountGet, bytes32 orderHash) view private returns(uint) {
190     return  amountGet.sub(orderFills[user][orderHash]);
191   }
192 
193   function available2(address user, address tokenGive, uint amountGet, uint amountGive) view private returns(uint) {
194     return tokens[tokenGive][user].mul(amountGet).div(amountGive);
195   }
196 
197   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user) view public returns(uint) {
198     bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
199     return orderFills[user][hash];
200   }
201 
202   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
203     bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
204     require (orders[msg.sender][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == msg.sender);
205     orderFills[msg.sender][hash] = amountGet;
206     emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
207   }
208 
209   function activateToken(address token) public {
210     require (msg.sender == admin);
211     activeTokens[token] = true;
212     emit ActivateToken(token, Token(token).symbol());
213   }
214 
215   function deactivateToken(address token) public {
216     require (msg.sender == admin);
217     activeTokens[token] = false;
218     emit DeactivateToken(token, Token(token).symbol());
219   }
220 
221   function isTokenActive(address token) view public returns(bool) {
222     if (token == address(0))
223       return true; // eth is always active
224     return activeTokens[token];
225   }
226   
227   function setTokenMinAmountBuy(address token, uint amount) public  {
228     require (msg.sender == admin);
229     tokensMinAmountBuy[token] = amount;
230   }
231 
232   function setTokenMinAmountSell(address token, uint amount) public {
233     require (msg.sender == admin);
234     tokensMinAmountSell[token] = amount;
235   }
236   
237   function setTokenFeeMake(address token, uint feeMake_) public {
238     require (msg.sender == admin);
239     feeMake[token] = feeMake_;
240   }
241 
242   function setTokenFeeTake(address token, uint feeTake_) public {
243     require (msg.sender == admin);
244     feeTake[token] = feeTake_;
245   }
246 
247   function setTokenFeeDeposit(address token, uint feeDeposit_) public {
248     require (msg.sender == admin);
249     feeDeposit[token] = feeDeposit_;
250   }
251 
252   function setTokenFeeWithdraw(address token, uint feeWithdraw_) public {
253     require (msg.sender == admin);
254     feeWithdraw[token] = feeWithdraw_;
255   }
256 }