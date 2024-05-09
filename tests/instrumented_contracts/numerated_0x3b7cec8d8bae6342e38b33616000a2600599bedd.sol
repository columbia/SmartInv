1 pragma solidity ^0.4.23;
2 
3 
4 contract SafeMath {
5     function safeMul(uint a, uint b) internal pure returns (uint) {
6         uint c = a * b;
7         require(a == 0 || c / a == b);
8         return c;
9     }
10     function safeSub(uint a, uint b) internal pure returns (uint) {
11         require(b <= a);
12         return a - b;
13     }
14     function safeAdd(uint a, uint b) internal pure returns (uint) {
15         uint c = a + b;
16         require(c>=a && c>=b);
17         return c;
18     }
19 }
20 
21 
22 contract Token {
23     function totalSupply() public constant returns (uint256 supply);
24     function balanceOf(address _owner) public constant returns (uint256 balance);
25     function transfer(address _to, uint256 _value) public returns (bool success);
26     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
27     function approve(address _spender, uint256 _value) public returns (bool success);
28     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
29     event Transfer(address indexed _from, address indexed _to, uint256 _value);
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31     uint8 public decimals;
32     string public name;
33 }
34 
35 
36 contract StandardToken is Token {
37 
38     mapping(address => uint256) balances;
39     mapping(address => mapping (address => uint256)) allowed;
40     uint256 public totalSupply;
41 
42     function transfer(address _to, uint256 _value) public returns (bool success) {
43         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
44             balances[msg.sender] -= _value;
45             balances[_to] += _value;
46             emit Transfer(msg.sender, _to, _value);
47             return true;
48         } else { return false; }
49     }
50 
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
52         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
53             balances[_to] += _value;
54             balances[_from] -= _value;
55             allowed[_from][msg.sender] -= _value;
56             emit Transfer(_from, _to, _value);
57             return true;
58         } else { return false; }
59     }
60 
61     function balanceOf(address _owner) public constant returns (uint256 balance) {
62         return balances[_owner];
63     }
64 
65     function approve(address _spender, uint256 _value) public returns (bool success) {
66         allowed[msg.sender][_spender] = _value;
67         emit Approval(msg.sender, _spender, _value);
68         return true;
69     }
70 
71     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
72         return allowed[_owner][_spender];
73     }
74 
75 }
76 
77 
78 contract ReserveToken is StandardToken, SafeMath {
79 
80     address public minter;
81 
82     constructor() public {
83         minter = msg.sender;
84     }
85 
86     function create(address account, uint amount) public {
87         if (msg.sender != minter) revert();
88         balances[account] = safeAdd(balances[account], amount);
89         totalSupply = safeAdd(totalSupply, amount);
90     }
91 
92     function destroy(address account, uint amount) public {
93         if (msg.sender != minter) revert();
94         if (balances[account] < amount) revert();
95         balances[account] = safeSub(balances[account], amount);
96         totalSupply = safeSub(totalSupply, amount);
97     }
98 }
99 
100 
101 contract AccountLevels {
102     //given a user, returns an account level
103     //0 = regular user (pays take fee and make fee)
104     //1 = market maker silver (pays take fee, no make fee, gets rebate)
105     //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
106     function accountLevel(address user) public constant returns(uint);
107 }
108 
109 
110 contract AccountLevelsTest is AccountLevels {
111 
112     mapping (address => uint) public accountLevels;
113 
114     function setAccountLevel(address user, uint level) public {
115         accountLevels[user] = level;
116     }
117 
118     function accountLevel(address user) public constant returns(uint) {
119         return accountLevels[user];
120     }
121 
122 }
123 
124 
125 contract GenevExch is SafeMath {
126 
127     address public admin; //the admin address
128     address public feeAccount; //the account that will receive fees
129     address public accountLevelsAddr; //the address of the AccountLevels contract
130     uint public feeMake; //percentage times (1 ether)
131     uint public feeTake; //percentage times (1 ether)
132     uint public feeRebate; //percentage times (1 ether)
133     mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
134     mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
135     mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
136 
137     mapping (address => bool) public whiteListERC20;
138     mapping (address => bool) public whiteListERC223;
139 
140     event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
141     event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
142     event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
143     event Deposit(address token, address user, uint amount, uint balance);
144     event Withdraw(address token, address user, uint amount, uint balance);
145     
146     modifier onlyAdmin() {
147         require(msg.sender==admin);
148         _;
149     }
150 
151     // Constructor
152 
153     constructor(
154         address admin_, 
155         address feeAccount_, 
156         address accountLevelsAddr_, 
157         uint feeMake_, 
158         uint feeTake_, 
159         uint feeRebate_) public {
160 
161         admin = admin_;
162         feeAccount = feeAccount_;
163         accountLevelsAddr = accountLevelsAddr_;
164         feeMake = feeMake_;
165         feeTake = feeTake_;
166         feeRebate = feeRebate_;
167     }
168 
169     function() public {
170         revert();
171     }
172 
173     // Admin functions
174 
175     function changeAdmin(address admin_) public onlyAdmin {
176         admin = admin_;
177     }
178 
179     function changeAccountLevelsAddr(address accountLevelsAddr_) public onlyAdmin {
180         accountLevelsAddr = accountLevelsAddr_;
181     }
182 
183     function changeFeeAccount(address feeAccount_) public onlyAdmin {
184         feeAccount = feeAccount_;
185     }
186 
187     function changeFeeMake(uint feeMake_) public onlyAdmin {
188         feeMake = feeMake_;
189     }
190 
191     function changeFeeTake(uint feeTake_) public onlyAdmin {
192         if (feeTake_ < feeRebate) revert();
193         feeTake = feeTake_;
194     }
195 
196     function changeFeeRebate(uint feeRebate_) public onlyAdmin {
197         if (feeRebate_ > feeTake) revert();
198         feeRebate = feeRebate_;
199     }
200 
201     // Whitelists for ERC20 or ERC223 tokens
202 
203     function setBlackListERC20(address _token) public onlyAdmin {
204         whiteListERC20[_token] = false;
205     }
206     function setWhiteListERC20(address _token) public onlyAdmin {
207         whiteListERC20[_token] = true;
208     }
209     function setBlackListERC223(address _token) public onlyAdmin {
210         whiteListERC223[_token] = false;
211     }
212     function setWhiteListERC223(address _token) public onlyAdmin {
213         whiteListERC223[_token] = true;
214     }
215 
216     // Public functions
217 
218     function deposit() public payable { // Deposit Ethers
219         tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
220         emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
221     }
222 
223     function tokenFallback(address _from, uint _value, bytes _data) public { // Deposit ERC223 tokens
224         if (_value==0) revert();
225         require(whiteListERC223[msg.sender]);
226         tokens[msg.sender][_from] = safeAdd(tokens[msg.sender][_from], _value);
227         emit Deposit(msg.sender, _from, _value, tokens[msg.sender][_from]);
228      }
229 
230     function depositToken(address token, uint amount) public { // Deposit ERC20 tokens
231         if (amount==0) revert();
232         require(whiteListERC20[token]);
233         if (!Token(token).transferFrom(msg.sender, this, amount)) revert();
234         tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
235         emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
236     }
237 
238     function withdraw(uint amount) public { // Withdraw ethers
239         if (tokens[0][msg.sender] < amount) revert();
240         tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
241         msg.sender.transfer(amount);
242         emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
243     }
244 
245     function withdrawToken(address token, uint amount) public { // Withdraw tokens
246         require(whiteListERC20[token] || whiteListERC223[token]);
247         if (tokens[token][msg.sender] < amount) revert();
248         tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
249         require (Token(token).transfer(msg.sender, amount));
250         emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
251     }
252 
253     function balanceOf(address token, address user) public constant returns (uint) {
254         return tokens[token][user];
255     }
256 
257     // Exchange specific functions
258 
259     function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {
260         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
261         orders[msg.sender][hash] = true;
262         emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
263     }
264 
265     function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
266         //amount is in amountGet terms
267         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
268         if (!(
269             (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
270             block.number <= expires &&
271             safeAdd(orderFills[user][hash], amount) <= amountGet
272         )) revert();
273         tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
274         orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
275         emit Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
276     }
277 
278     function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
279         uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
280         uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
281         uint feeRebateXfer = 0;
282 
283         if (accountLevelsAddr != 0x0) {
284             uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
285             if (accountLevel==1) feeRebateXfer = safeMul(amount, feeRebate) / (1 ether);
286             if (accountLevel==2) feeRebateXfer = feeTakeXfer;
287         }
288 
289         tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
290         tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(safeAdd(amount, feeRebateXfer), feeMakeXfer));
291         tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeSub(safeAdd(feeMakeXfer, feeTakeXfer), feeRebateXfer));
292         tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
293         tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
294     }
295 
296     function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public constant returns(bool) {
297         if (!(
298             tokens[tokenGet][sender] >= amount &&
299             availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
300         )) return false;
301         return true;
302     }
303 
304     function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {
305         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
306         if (!(
307             (orders[user][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
308             block.number <= expires
309         )) return 0;
310         uint available1 = safeSub(amountGet, orderFills[user][hash]);
311         uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
312         if (available1 < available2) return available1;
313         return available2;
314     }
315 
316     function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user) public constant returns(uint) {
317         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
318         return orderFills[user][hash];
319     }
320 
321     function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
322         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
323         if (!(orders[msg.sender][hash] || ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) revert();
324         orderFills[msg.sender][hash] = amountGet;
325         emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
326     }
327     
328 }