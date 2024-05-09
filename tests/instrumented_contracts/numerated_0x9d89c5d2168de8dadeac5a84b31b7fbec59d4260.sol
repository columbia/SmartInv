1 pragma solidity ^0.4.23;
2 
3 // London.Exchange v0.7.7
4 
5 contract SafeMath {
6     function safeMul(uint a, uint b) internal pure returns (uint) {
7         uint c = a * b;
8         require(a == 0 || c / a == b);
9         return c;
10     }
11     function safeSub(uint a, uint b) internal pure returns (uint) {
12         require(b <= a);
13         return a - b;
14     }
15     function safeAdd(uint a, uint b) internal pure returns (uint) {
16         uint c = a + b;
17         require(c>=a && c>=b);
18         return c;
19     }
20 }
21 
22 
23 contract Token {
24     function totalSupply() public constant returns (uint256 supply);
25     function balanceOf(address _owner) public constant returns (uint256 balance);
26     function transfer(address _to, uint256 _value) public returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28     function approve(address _spender, uint256 _value) public returns (bool success);
29     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32     uint8 public decimals;
33     string public name;
34 }
35 
36 
37 contract AccountLevels {
38     //given a user, returns an account level
39     //0 = regular user (pays take fee and make fee)
40     //1 = market maker silver (pays take fee, no make fee, gets rebate)
41     //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
42     function accountLevel(address user) public constant returns(uint);
43 }
44 
45 
46 contract Exch is SafeMath {
47 
48     address public admin; //the admin address
49     address public feeAccount; //the account that will receive fees
50     address public accountLevelsAddr; //the address of the AccountLevels contract
51     uint public feeMake; //percentage times (1 ether)
52     uint public feeTake; //percentage times (1 ether)
53     uint public feeRebate; //percentage times (1 ether)
54     bool private whiteListStatus;
55 
56     mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
57     mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
58     mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
59 
60     mapping (address => bool) public whiteListERC20;
61     mapping (address => bool) public whiteListERC223;
62 
63     event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
64     event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
65     event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
66     event Deposit(address token, address user, uint amount, uint balance);
67     event Withdraw(address token, address user, uint amount, uint balance);
68     
69     modifier onlyAdmin() {
70         require(msg.sender==admin);
71         _;
72     }
73 
74     // Constructor
75 
76     constructor(
77         address admin_, 
78         address feeAccount_, 
79         address accountLevelsAddr_, 
80         uint feeMake_, 
81         uint feeTake_, 
82         uint feeRebate_) public {
83 
84         admin = admin_;
85         feeAccount = feeAccount_;
86         accountLevelsAddr = accountLevelsAddr_;
87         feeMake = feeMake_;
88         feeTake = feeTake_;
89         feeRebate = feeRebate_;
90     }
91 
92     function() public {
93         revert();
94     }
95 
96     // Admin functions
97 
98     function changeAdmin(address admin_) public onlyAdmin {
99         admin = admin_;
100     }
101 
102     function changeAccountLevelsAddr(address accountLevelsAddr_) public onlyAdmin {
103         accountLevelsAddr = accountLevelsAddr_;
104     }
105 
106     function changeFeeAccount(address feeAccount_) public onlyAdmin {
107         feeAccount = feeAccount_;
108     }
109 
110     function changeFeeMake(uint feeMake_) public onlyAdmin {
111         feeMake = feeMake_;
112     }
113 
114     function changeFeeTake(uint feeTake_) public onlyAdmin {
115         if (feeTake_ < feeRebate) revert();
116         feeTake = feeTake_;
117     }
118 
119     function changeFeeRebate(uint feeRebate_) public onlyAdmin {
120         if (feeRebate_ > feeTake) revert();
121         feeRebate = feeRebate_;
122     }
123 
124     // Whitelists for ERC20 or ERC223 tokens
125 
126     function setBlackListERC20(address _token) public onlyAdmin {
127         whiteListERC20[_token] = false;
128     }
129     function setWhiteListERC20(address _token) public onlyAdmin {
130         whiteListERC20[_token] = true;
131     }
132     function setBlackListERC223(address _token) public onlyAdmin {
133         whiteListERC223[_token] = false;
134     }
135     function setWhiteListERC223(address _token) public onlyAdmin {
136         whiteListERC223[_token] = true;
137     }
138 
139     function setBulkWhite20(address[] adds) public onlyAdmin {
140         for (uint i = 0; i < adds.length; i++) {
141             whiteListERC20[adds[i]] = true;
142         }
143     }
144     function setBulkWhite223(address[] adds) public onlyAdmin {
145         for (uint i = 0; i < adds.length; i++) {
146             whiteListERC223[adds[i]] = true;
147         }
148     }
149     function setBulkBlack20(address[] adds) public onlyAdmin {
150         for (uint i = 0; i < adds.length; i++) {
151             whiteListERC20[adds[i]] = false;
152         }
153     }
154     function setBulkBlack223(address[] adds) public onlyAdmin {
155         for (uint i = 0; i < adds.length; i++) {
156             whiteListERC223[adds[i]] = false;
157         }
158     }
159 
160 
161     function activateWhitelist(bool activate) public onlyAdmin {
162         whiteListStatus = activate;
163     }
164     function isWhiteListActive() constant onlyAdmin returns(bool) {
165         return whiteListStatus;
166     }
167 
168 
169     // Public functions
170 
171     function deposit() public payable { // Deposit Ethers
172         tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
173         emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
174     }
175 
176     function tokenFallback(address _from, uint _value, bytes _data) public { // Deposit ERC223 tokens
177         if (_value==0) revert();
178         if (whiteListStatus) require(whiteListERC223[msg.sender]);
179         tokens[msg.sender][_from] = safeAdd(tokens[msg.sender][_from], _value);
180         emit Deposit(msg.sender, _from, _value, tokens[msg.sender][_from]);
181      }
182 
183     function depositToken(address token, uint amount) public { // Deposit ERC20 tokens
184         if (amount==0) revert();
185         if (whiteListStatus) require(whiteListERC20[token]);
186         if (!Token(token).transferFrom(msg.sender, this, amount)) revert();
187         tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
188         emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
189     }
190 
191     function withdraw(uint amount) public { // Withdraw ethers
192         if (tokens[0][msg.sender] < amount) revert();
193         tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
194         msg.sender.transfer(amount);
195         emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
196     }
197 
198     function withdrawToken(address token, uint amount) public { // Withdraw tokens
199         if (whiteListStatus) require(whiteListERC20[token] || whiteListERC223[token]);
200         if (tokens[token][msg.sender] < amount) revert();
201         tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
202         require (Token(token).transfer(msg.sender, amount));
203         emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
204     }
205 
206     function balanceOf(address token, address user) public constant returns (uint) {
207         return tokens[token][user];
208     }
209 
210     // Exchange specific functions
211 
212     function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {
213         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
214         orders[msg.sender][hash] = true;
215         emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
216     }
217 
218     function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
219         //amount is in amountGet terms
220         if (whiteListStatus) {
221             require(whiteListERC20[tokenGet] || whiteListERC223[tokenGet]);
222             require(whiteListERC20[tokenGive] || whiteListERC223[tokenGive]);
223         }
224         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
225         if (!(
226             (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
227             block.number <= expires &&
228             safeAdd(orderFills[user][hash], amount) <= amountGet
229         )) revert();
230         tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
231         orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
232         emit Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
233     }
234 
235     function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
236         uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
237         uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
238         uint feeRebateXfer = 0;
239 
240         if (accountLevelsAddr != 0x0) {
241             uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
242             if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);
243             if (accountLevel==2) feeRebateXfer = feeTakeXfer;
244         }
245 
246         tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
247         tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
248         tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
249         tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
250         tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
251     }
252 
253     function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public constant returns(bool) {
254         if (!(
255             tokens[tokenGet][sender] >= amount &&
256             availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
257         )) return false;
258         return true;
259     }
260 
261     function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {
262         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
263         if (!(
264             (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
265             block.number <= expires
266         )) return 0;
267         uint available1 = safeSub(amountGet, orderFills[user][hash]);
268         uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
269         if (available1 < available2) return available1;
270         return available2;
271     }
272 
273     function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user) public constant returns(uint) {
274         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
275         return orderFills[user][hash];
276     }
277 
278     function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
279         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
280         if (!(orders[msg.sender][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) revert();
281         orderFills[msg.sender][hash] = amountGet;
282         emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
283     }
284     
285 }