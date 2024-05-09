1 pragma solidity ^0.4.23;
2 
3 // Exch v0.7.5
4 // Ethernity.live
5 
6 contract SafeMath {
7     function safeMul(uint a, uint b) internal pure returns (uint) {
8         uint c = a * b;
9         require(a == 0 || c / a == b);
10         return c;
11     }
12     function safeSub(uint a, uint b) internal pure returns (uint) {
13         require(b <= a);
14         return a - b;
15     }
16     function safeAdd(uint a, uint b) internal pure returns (uint) {
17         uint c = a + b;
18         require(c>=a && c>=b);
19         return c;
20     }
21 }
22 
23 
24 contract Token {
25     function totalSupply() public constant returns (uint256 supply);
26     function balanceOf(address _owner) public constant returns (uint256 balance);
27     function transfer(address _to, uint256 _value) public returns (bool success);
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
29     function approve(address _spender, uint256 _value) public returns (bool success);
30     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33     uint8 public decimals;
34     string public name;
35 }
36 
37 
38 contract AccountLevels {
39     //given a user, returns an account level
40     //0 = regular user (pays take fee and make fee)
41     //1 = market maker silver (pays take fee, no make fee, gets rebate)
42     //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
43     function accountLevel(address user) public constant returns(uint);
44 }
45 
46 
47 contract Exch is SafeMath {
48 
49     address public admin; //the admin address
50     address public feeAccount; //the account that will receive fees
51     address public accountLevelsAddr; //the address of the AccountLevels contract
52     uint public feeMake; //percentage times (1 ether)
53     uint public feeTake; //percentage times (1 ether)
54     uint public feeRebate; //percentage times (1 ether)
55     mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
56     mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
57     mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
58 
59     mapping (address => bool) public whiteListERC20;
60     mapping (address => bool) public whiteListERC223;
61 
62     event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
63     event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
64     event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
65     event Deposit(address token, address user, uint amount, uint balance);
66     event Withdraw(address token, address user, uint amount, uint balance);
67     
68     modifier onlyAdmin() {
69         require(msg.sender==admin);
70         _;
71     }
72 
73     // Constructor
74 
75     constructor(
76         address admin_, 
77         address feeAccount_, 
78         address accountLevelsAddr_, 
79         uint feeMake_, 
80         uint feeTake_, 
81         uint feeRebate_) public {
82 
83         admin = admin_;
84         feeAccount = feeAccount_;
85         accountLevelsAddr = accountLevelsAddr_;
86         feeMake = feeMake_;
87         feeTake = feeTake_;
88         feeRebate = feeRebate_;
89     }
90 
91     function() public {
92         revert();
93     }
94 
95     // Admin functions
96 
97     function changeAdmin(address admin_) public onlyAdmin {
98         admin = admin_;
99     }
100 
101     function changeAccountLevelsAddr(address accountLevelsAddr_) public onlyAdmin {
102         accountLevelsAddr = accountLevelsAddr_;
103     }
104 
105     function changeFeeAccount(address feeAccount_) public onlyAdmin {
106         feeAccount = feeAccount_;
107     }
108 
109     function changeFeeMake(uint feeMake_) public onlyAdmin {
110         feeMake = feeMake_;
111     }
112 
113     function changeFeeTake(uint feeTake_) public onlyAdmin {
114         if (feeTake_ < feeRebate) revert();
115         feeTake = feeTake_;
116     }
117 
118     function changeFeeRebate(uint feeRebate_) public onlyAdmin {
119         if (feeRebate_ > feeTake) revert();
120         feeRebate = feeRebate_;
121     }
122 
123     // Whitelists for ERC20 or ERC223 tokens
124 
125     function setBlackListERC20(address _token) public onlyAdmin {
126         whiteListERC20[_token] = false;
127     }
128     function setWhiteListERC20(address _token) public onlyAdmin {
129         whiteListERC20[_token] = true;
130     }
131     function setBlackListERC223(address _token) public onlyAdmin {
132         whiteListERC223[_token] = false;
133     }
134     function setWhiteListERC223(address _token) public onlyAdmin {
135         whiteListERC223[_token] = true;
136     }
137 
138     // Public functions
139 
140     function deposit() public payable { // Deposit Ethers
141         tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
142         emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
143     }
144 
145     function tokenFallback(address _from, uint _value, bytes _data) public { // Deposit ERC223 tokens
146         if (_value==0) revert();
147         require(whiteListERC223[msg.sender]);
148         tokens[msg.sender][_from] = safeAdd(tokens[msg.sender][_from], _value);
149         emit Deposit(msg.sender, _from, _value, tokens[msg.sender][_from]);
150      }
151 
152     function depositToken(address token, uint amount) public { // Deposit ERC20 tokens
153         if (amount==0) revert();
154         require(whiteListERC20[token]);
155         if (!Token(token).transferFrom(msg.sender, this, amount)) revert();
156         tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
157         emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
158     }
159 
160     function withdraw(uint amount) public { // Withdraw ethers
161         if (tokens[0][msg.sender] < amount) revert();
162         tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
163         msg.sender.transfer(amount);
164         emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
165     }
166 
167     function withdrawToken(address token, uint amount) public { // Withdraw tokens
168         require(whiteListERC20[token] || whiteListERC223[token]);
169         if (tokens[token][msg.sender] < amount) revert();
170         tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
171         require (Token(token).transfer(msg.sender, amount));
172         emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
173     }
174 
175     function balanceOf(address token, address user) public constant returns (uint) {
176         return tokens[token][user];
177     }
178 
179     // Exchange specific functions
180 
181     function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {
182         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
183         orders[msg.sender][hash] = true;
184         emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
185     }
186 
187     function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
188         //amount is in amountGet terms
189         require(whiteListERC20[tokenGet] || whiteListERC223[tokenGet]);
190         require(whiteListERC20[tokenGive] || whiteListERC223[tokenGive]);
191         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
192         if (!(
193             (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
194             block.number <= expires &&
195             safeAdd(orderFills[user][hash], amount) <= amountGet
196         )) revert();
197         tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
198         orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
199         emit Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
200     }
201 
202     function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
203         uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
204         uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
205         uint feeRebateXfer = 0;
206 
207         if (accountLevelsAddr != 0x0) {
208             uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
209             if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);
210             if (accountLevel==2) feeRebateXfer = feeTakeXfer;
211         }
212 
213         tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
214         tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
215         tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
216         tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
217         tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
218     }
219 
220     function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public constant returns(bool) {
221         if (!(
222             tokens[tokenGet][sender] >= amount &&
223             availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
224         )) return false;
225         return true;
226     }
227 
228     function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {
229         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
230         if (!(
231             (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
232             block.number <= expires
233         )) return 0;
234         uint available1 = safeSub(amountGet, orderFills[user][hash]);
235         uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
236         if (available1 < available2) return available1;
237         return available2;
238     }
239 
240     function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user) public constant returns(uint) {
241         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
242         return orderFills[user][hash];
243     }
244 
245     function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
246         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
247         if (!(orders[msg.sender][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) revert();
248         orderFills[msg.sender][hash] = amountGet;
249         emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
250     }
251     
252 }