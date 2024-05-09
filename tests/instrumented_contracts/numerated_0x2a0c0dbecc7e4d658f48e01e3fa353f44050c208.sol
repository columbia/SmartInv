1 pragma solidity ^0.4.16;
2 
3 contract Token {
4     bytes32 public standard;
5     bytes32 public name;
6     bytes32 public symbol;
7     uint256 public totalSupply;
8     uint8 public decimals;
9     bool public allowTransactions;
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12     function transfer(address _to, uint256 _value) returns (bool success);
13     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
14     function approve(address _spender, uint256 _value) returns (bool success);
15     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
16 }
17 
18 contract Exchange {
19   function assert(bool assertion) {
20     if (!assertion) throw;
21   }
22   function safeMul(uint a, uint b) returns (uint) {
23     uint c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function safeSub(uint a, uint b) returns (uint) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function safeAdd(uint a, uint b) returns (uint) {
34     uint c = a + b;
35     assert(c>=a && c>=b);
36     return c;
37   }
38   address public owner;
39   mapping (address => uint256) public invalidOrder;
40   event SetOwner(address indexed previousOwner, address indexed newOwner);
41   modifier onlyOwner {
42     assert(msg.sender == owner);
43     _;
44   }
45   function setOwner(address newOwner) onlyOwner {
46     SetOwner(owner, newOwner);
47     owner = newOwner;
48   }
49   function getOwner() returns (address out) {
50     return owner;
51   }
52   function invalidateOrdersBefore(address user, uint256 nonce) onlyAdmin {
53     if (nonce < invalidOrder[user]) throw;
54     invalidOrder[user] = nonce;
55   }
56 
57   mapping (address => mapping (address => uint256)) public tokens; //mapping of token addresses to mapping of account balances
58 
59   mapping (address => bool) public admins;
60   mapping (address => uint256) public lastActiveTransaction;
61   mapping (bytes32 => uint256) public orderFills;
62   address public feeAccount;
63   uint256 public inactivityReleasePeriod;
64   mapping (bytes32 => bool) public traded;
65   mapping (bytes32 => bool) public withdrawn;
66   event Order(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);
67   event Cancel(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);
68   event Trade(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, address get, address give);
69   event Deposit(address token, address user, uint256 amount, uint256 balance);
70   event Withdraw(address token, address user, uint256 amount, uint256 balance);
71 
72   function setInactivityReleasePeriod(uint256 expiry) onlyAdmin returns (bool success) {
73     if (expiry > 1000000) throw;
74     inactivityReleasePeriod = expiry;
75     return true;
76   }
77 
78   function Exchange(address feeAccount_) {
79     owner = msg.sender;
80     feeAccount = feeAccount_;
81     inactivityReleasePeriod = 100000;
82   }
83 
84   function setAdmin(address admin, bool isAdmin) onlyOwner {
85     admins[admin] = isAdmin;
86   }
87 
88   modifier onlyAdmin {
89     if (msg.sender != owner && !admins[msg.sender]) throw;
90     _;
91   }
92 
93   function() external {
94     throw;
95   }
96 
97   function depositToken(address token, uint256 amount) {
98     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
99     lastActiveTransaction[msg.sender] = block.number;
100     if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
101     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
102   }
103 
104   function deposit() payable {
105     tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);
106     lastActiveTransaction[msg.sender] = block.number;
107     Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);
108   }
109 
110   function withdraw(address token, uint256 amount) returns (bool success) {
111     if (safeSub(block.number, lastActiveTransaction[msg.sender]) < inactivityReleasePeriod) throw;
112     if (tokens[token][msg.sender] < amount) throw;
113     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
114     if (token == address(0)) {
115       if (!msg.sender.send(amount)) throw;
116     } else {
117       if (!Token(token).transfer(msg.sender, amount)) throw;
118     }
119     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
120   }
121 
122   function adminWithdraw(address token, uint256 amount, address user, uint256 nonce, uint8 v, bytes32 r, bytes32 s, uint256 feeWithdrawal) onlyAdmin returns (bool success) {
123     bytes32 hash = keccak256(this, token, amount, user, nonce);
124     if (withdrawn[hash]) throw;
125     withdrawn[hash] = true;
126     if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) != user) throw;
127     if (feeWithdrawal > 50 finney) feeWithdrawal = 50 finney;
128     if (tokens[token][user] < amount) throw;
129     tokens[token][user] = safeSub(tokens[token][user], amount);
130     tokens[token][feeAccount] = safeAdd(tokens[token][feeAccount], safeMul(feeWithdrawal, amount) / 1 ether);
131     amount = safeMul((1 ether - feeWithdrawal), amount) / 1 ether;
132     if (token == address(0)) {
133       if (!user.send(amount)) throw;
134     } else {
135       if (!Token(token).transfer(user, amount)) throw;
136     }
137     lastActiveTransaction[user] = block.number;
138     Withdraw(token, user, amount, tokens[token][user]);
139   }
140 
141   function balanceOf(address token, address user) constant returns (uint256) {
142     return tokens[token][user];
143   }
144 
145   function trade(uint256[8] tradeValues, address[4] tradeAddresses, uint8[2] v, bytes32[4] rs) onlyAdmin returns (bool success) {
146     /* amount is in amountBuy terms */
147     /* tradeValues
148        [0] amountBuy
149        [1] amountSell
150        [2] expires
151        [3] nonce
152        [4] amount
153        [5] tradeNonce
154        [6] feeMake
155        [7] feeTake
156      tradeAddressses
157        [0] tokenBuy
158        [1] tokenSell
159        [2] maker
160        [3] taker
161      */
162     if (invalidOrder[tradeAddresses[2]] > tradeValues[3]) throw;
163     bytes32 orderHash = keccak256(this, tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeValues[2], tradeValues[3], tradeAddresses[2]);
164     if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", orderHash), v[0], rs[0], rs[1]) != tradeAddresses[2]) throw;
165     bytes32 tradeHash = keccak256(orderHash, tradeValues[4], tradeAddresses[3], tradeValues[5]); 
166     if (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", tradeHash), v[1], rs[2], rs[3]) != tradeAddresses[3]) throw;
167     if (traded[tradeHash]) throw;
168     traded[tradeHash] = true;
169     if (tradeValues[6] > 100 finney) tradeValues[6] = 100 finney;
170     if (tradeValues[7] > 100 finney) tradeValues[7] = 100 finney;
171     if (safeAdd(orderFills[orderHash], tradeValues[4]) > tradeValues[0]) throw;
172     if (tokens[tradeAddresses[0]][tradeAddresses[3]] < tradeValues[4]) throw;
173     if (tokens[tradeAddresses[1]][tradeAddresses[2]] < (safeMul(tradeValues[1], tradeValues[4]) / tradeValues[0])) throw;
174     tokens[tradeAddresses[0]][tradeAddresses[3]] = safeSub(tokens[tradeAddresses[0]][tradeAddresses[3]], tradeValues[4]);
175     tokens[tradeAddresses[0]][tradeAddresses[2]] = safeAdd(tokens[tradeAddresses[0]][tradeAddresses[2]], safeMul(tradeValues[4], ((1 ether) - tradeValues[6])) / (1 ether));
176     tokens[tradeAddresses[0]][feeAccount] = safeAdd(tokens[tradeAddresses[0]][feeAccount], safeMul(tradeValues[4], tradeValues[6]) / (1 ether));
177     tokens[tradeAddresses[1]][tradeAddresses[2]] = safeSub(tokens[tradeAddresses[1]][tradeAddresses[2]], safeMul(tradeValues[1], tradeValues[4]) / tradeValues[0]);
178     tokens[tradeAddresses[1]][tradeAddresses[3]] = safeAdd(tokens[tradeAddresses[1]][tradeAddresses[3]], safeMul(safeMul(((1 ether) - tradeValues[7]), tradeValues[1]), tradeValues[4]) / tradeValues[0] / (1 ether));
179     tokens[tradeAddresses[1]][feeAccount] = safeAdd(tokens[tradeAddresses[1]][feeAccount], safeMul(safeMul(tradeValues[7], tradeValues[1]), tradeValues[4]) / tradeValues[0] / (1 ether));
180     orderFills[orderHash] = safeAdd(orderFills[orderHash], tradeValues[4]);
181     lastActiveTransaction[tradeAddresses[2]] = block.number;
182     lastActiveTransaction[tradeAddresses[3]] = block.number;
183   }
184 }