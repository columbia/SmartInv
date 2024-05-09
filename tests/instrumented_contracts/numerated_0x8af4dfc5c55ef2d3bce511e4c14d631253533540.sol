1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4 
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a && c >= b);
8     }
9 
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14 
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19 
20     function div(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 contract ERC20 {
27     function totalSupply() public constant returns (uint);
28 
29     function balanceOf(address tokenOwner) public constant returns (uint balance);
30 
31     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
32 
33     function transfer(address to, uint tokens) public returns (bool success);
34 
35     function approve(address spender, uint tokens) public returns (bool success);
36 
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 contract EtherDEX {
44     using SafeMath for uint;
45 
46     address public admin; //the admin address
47     address public feeAccount; //the account that will receive fees
48     uint public feeMake; //percentage times (1 ether)
49     uint public feeTake; //percentage times (1 ether)
50     mapping(address => mapping(address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
51     mapping(address => mapping(bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
52     mapping(address => mapping(bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
53 
54     address public previousContract;
55     address public nextContract;
56     bool public isContractDeprecated;
57     uint public contractVersion;
58 
59     event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
60     event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
61     event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
62     event Deposit(address token, address user, uint amount, uint balance);
63     event Withdraw(address token, address user, uint amount, uint balance);
64     event FundsMigrated(address user);
65 
66     modifier onlyAdmin() {
67         require(msg.sender == admin);
68         _;
69     }
70 
71     constructor(address admin_, address feeAccount_, uint feeMake_, uint feeTake_, address _previousContract) public {
72         admin = admin_;
73         feeAccount = feeAccount_;
74         feeMake = feeMake_;
75         feeTake = feeTake_;
76         previousContract = _previousContract;
77         isContractDeprecated = false;
78 
79         //count new contract version if it's not the first
80         if (previousContract != address(0)) {
81             contractVersion = EtherDEX(previousContract).contractVersion() + 1;
82         } else {
83             contractVersion = 1;
84         }
85     }
86 
87     function() public payable {
88         revert("Cannot send ETH directly to the Contract");
89     }
90 
91     function changeAdmin(address admin_) public onlyAdmin {
92         admin = admin_;
93     }
94 
95     function changeFeeAccount(address feeAccount_) public onlyAdmin {
96         require(feeAccount_ != address(0));
97         feeAccount = feeAccount_;
98     }
99 
100     function changeFeeMake(uint feeMake_) public onlyAdmin {
101         if (feeMake_ > feeMake) revert("New fee cannot be higher than the old one");
102         feeMake = feeMake_;
103     }
104 
105     function changeFeeTake(uint feeTake_) public onlyAdmin {
106         if (feeTake_ > feeTake) revert("New fee cannot be higher than the old one");
107         feeTake = feeTake_;
108     }
109 
110     function deprecate(bool deprecated_, address nextContract_) public onlyAdmin {
111         isContractDeprecated = deprecated_;
112         nextContract = nextContract_;
113     }
114 
115     function deposit() public payable {
116         tokens[0][msg.sender] = SafeMath.add(tokens[0][msg.sender], msg.value);
117         emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
118     }
119 
120     function withdraw(uint amount) public {
121         if (tokens[0][msg.sender] < amount) revert("Cannot withdraw more than you have");
122         tokens[0][msg.sender] = SafeMath.sub(tokens[0][msg.sender], amount);
123         msg.sender.transfer(amount);
124         //or .send() and check if https://ethereum.stackexchange.com/a/38642
125         emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
126     }
127 
128     function depositToken(address token, uint amount) public {
129         //remember to call ERC20Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
130         if (token == 0) revert("Cannot deposit ETH with depositToken method");
131         if (!ERC20(token).transferFrom(msg.sender, this, amount)) revert("You didn't call approve method on Token contract");
132         tokens[token][msg.sender] = SafeMath.add(tokens[token][msg.sender], amount);
133         emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
134     }
135 
136     function withdrawToken(address token, uint amount) public {
137         if (token == 0) revert("Cannot withdraw ETH with withdrawToken method");
138         if (tokens[token][msg.sender] < amount) revert("Cannot withdraw more than you have");
139         tokens[token][msg.sender] = SafeMath.sub(tokens[token][msg.sender], amount);
140         if (!ERC20(token).transfer(msg.sender, amount)) revert("Error while transfering tokens");
141         emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
142     }
143 
144     function balanceOf(address token, address user) public view returns (uint) {
145         return tokens[token][user];
146     }
147 
148     function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {
149         bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
150         orders[msg.sender][hash] = true;
151         emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
152     }
153 
154     function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
155         //amount is in amountGet terms
156         bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
157         if (!(
158         (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), v, r, s) == user) &&
159         block.number <= expires &&
160         SafeMath.add(orderFills[user][hash], amount) <= amountGet
161         ))  revert("Validation error or order expired or not enough volume to trade");
162         tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
163         orderFills[user][hash] = SafeMath.add(orderFills[user][hash], amount);
164         emit Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
165     }
166 
167     function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public view returns (bool) {
168         return (tokens[tokenGet][sender] >= amount && availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount);
169     }
170 
171     function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public view returns (uint) {
172         bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
173         if (!((orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), v, r, s) == user) && block.number <= expires)) return 0;
174         uint available1 = SafeMath.sub(amountGet, orderFills[user][hash]);
175         uint available2 = SafeMath.mul(tokens[tokenGive][user], amountGet) / amountGive;
176         if (available1 < available2) return available1;
177         return available2;
178     }
179 
180     function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user) public view returns (uint) {
181         bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
182         return orderFills[user][hash];
183     }
184 
185     function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
186         bytes32 hash = sha256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
187         if (!(orders[msg.sender][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), v, r, s) == msg.sender)) revert("Validation error");
188         orderFills[msg.sender][hash] = amountGet;
189         emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
190     }
191 
192     function migrateFunds(address[] tokens_) public {
193         // Get the latest successor in the chain
194         require(nextContract != address(0));
195         EtherDEX newExchange = findNewExchangeContract();
196 
197         // Ether
198         migrateEther(newExchange);
199 
200         // Tokens
201         migrateTokens(newExchange, tokens_);
202 
203         emit FundsMigrated(msg.sender);
204     }
205 
206     function depositEtherForUser(address _user) public payable {
207         require(!isContractDeprecated);
208         require(_user != address(0));
209         require(msg.value > 0);
210         EtherDEX caller = EtherDEX(msg.sender);
211         require(caller.contractVersion() > 0); // Make sure it's an exchange account
212         tokens[0][_user] = tokens[0][_user].add(msg.value);
213     }
214 
215     function depositTokenForUser(address _token, uint _amount, address _user) public {
216         require(!isContractDeprecated);
217         require(_token != address(0));
218         require(_user != address(0));
219         require(_amount > 0);
220         EtherDEX caller = EtherDEX(msg.sender);
221         require(caller.contractVersion() > 0); // Make sure it's an exchange account
222         if (!ERC20(_token).transferFrom(msg.sender, this, _amount)) {
223             revert();
224         }
225         tokens[_token][_user] = tokens[_token][_user].add(_amount);
226     }
227 
228     function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
229         uint feeMakeXfer = SafeMath.mul(amount, feeMake) / (1 ether);
230         uint feeTakeXfer = SafeMath.mul(amount, feeTake) / (1 ether);
231 
232         tokens[tokenGet][msg.sender] = SafeMath.sub(tokens[tokenGet][msg.sender], SafeMath.add(amount, feeTakeXfer));
233         tokens[tokenGet][user] = SafeMath.add(tokens[tokenGet][user], SafeMath.sub(amount, feeMakeXfer));
234         tokens[tokenGet][feeAccount] = SafeMath.add(tokens[tokenGet][feeAccount], SafeMath.add(feeMakeXfer, feeTakeXfer));
235         tokens[tokenGive][user] = SafeMath.sub(tokens[tokenGive][user], SafeMath.mul(amountGive, amount) / amountGet);
236         tokens[tokenGive][msg.sender] = SafeMath.add(tokens[tokenGive][msg.sender], SafeMath.mul(amountGive, amount) / amountGet);
237     }
238 
239     function findNewExchangeContract() private view returns (EtherDEX) {
240         EtherDEX newExchange = EtherDEX(nextContract);
241         for (uint16 n = 0; n < 20; n++) {// We will look past 20 contracts in the future
242             address nextContract_ = newExchange.nextContract();
243             if (nextContract_ == address(this)) {// Circular succession
244                 revert();
245             }
246             if (nextContract_ == address(0)) {// We reached the newest, stop
247                 break;
248             }
249             newExchange = EtherDEX(nextContract_);
250         }
251         return newExchange;
252     }
253 
254     function migrateEther(EtherDEX newExchange) private {
255         uint etherAmount = tokens[0][msg.sender];
256         if (etherAmount > 0) {
257             tokens[0][msg.sender] = 0;
258             newExchange.depositEtherForUser.value(etherAmount)(msg.sender);
259         }
260     }
261 
262     function migrateTokens(EtherDEX newExchange, address[] tokens_) private {
263         for (uint16 n = 0; n < tokens_.length; n++) {
264             address token = tokens_[n];
265             require(token != address(0));
266             // 0 = Ether, we handle it above
267             uint tokenAmount = tokens[token][msg.sender];
268             if (tokenAmount == 0) {
269                 continue;
270             }
271             if (!ERC20(token).approve(newExchange, tokenAmount)) {
272                 revert();
273             }
274             tokens[token][msg.sender] = 0;
275             newExchange.depositTokenForUser(token, tokenAmount, msg.sender);
276         }
277     }
278 }