1 pragma solidity ^0.4.23;
2 
3 contract IMDEX {
4     bytes32 public standard;
5     bytes32 public name;
6     bytes32 public symbol;
7     uint256 public totalSupply;
8     uint8 public decimals;
9     bool public allowTransactions;
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     function transfer(address _to, uint256 _value)public returns (bool success);
14     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);
15     function approve(address _spender, uint256 _value) public returns (bool success);
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17 }
18 
19 contract SafeMath {
20 
21     function safeMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
22     if (a == 0) {
23       return 0;
24     }
25     c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30 
31   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return a / b;
36   }
37 
38   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 
49 }
50 
51 
52 contract IMDEXDexchange is SafeMath {
53 
54   address public owner;
55   address IMDEXtoken = 0x46705E8fef2E868FACAFeDc45F47114EC01c2EEd;
56   mapping (address => uint256) public invalidOrder;
57   event SetOwner(address indexed previousOwner, address indexed newOwner);
58   modifier onlyOwner {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   function IMDEXsetOwner(address newOwner)public onlyOwner {
64     emit SetOwner(owner, newOwner);
65     owner = newOwner;
66   }
67 
68   function IMDEXinvalidateOrdersBefore(address user, uint256 nonce) public onlyAdmin {
69     require(nonce > invalidOrder[user]);
70     invalidOrder[user] = nonce;
71   }
72 
73   mapping (address => mapping (address => uint256)) public tokens; //mapping of token addresses to mapping of account balances
74   mapping (address => bool) public admins;
75   mapping (address => uint256) public lastActiveTransaction;
76   address public feeAccount;
77   uint256 public inactivityReleasePeriod;
78   event Trade(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, address get, address give);
79   event Deposit(address token, address user, uint256 amount, uint256 balance);
80   event Withdraw(address token, address user, uint256 amount, uint256 balance);
81 
82   function IMDEXsetInactivityReleasePeriod(uint256 expiry) public onlyAdmin returns (bool success) {
83     require(expiry < 1000000);
84     inactivityReleasePeriod = expiry;
85     return true;
86   }
87 
88   constructor(address feeAccount_) public {
89     owner = msg.sender;
90     feeAccount = feeAccount_;
91     inactivityReleasePeriod = 100000;
92   }
93 
94   function IMDEXsetAdmin(address admin, bool isAdmin) public onlyOwner {
95     admins[admin] = isAdmin;
96   }
97 
98   modifier onlyAdmin {
99    require(msg.sender == owner && admins[msg.sender]);
100     _;
101   }
102 
103   function() external {
104     revert();
105   }
106 
107 
108 
109   function IMDEXdepositToken(address token, uint256 amount) public {
110     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
111     lastActiveTransaction[msg.sender] = block.number;
112     require(IMDEX(token).transferFrom(msg.sender, this, amount));
113     emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
114   }
115 
116   function IMDEXdeposit() public payable {
117     tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);
118     lastActiveTransaction[msg.sender] = block.number;
119     emit Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);
120   }
121 
122   function IMDEXwithdrawToken(address token, uint256 amount) public returns (bool) {
123     require(safeSub(block.number, lastActiveTransaction[msg.sender]) > inactivityReleasePeriod);
124     require(tokens[token][msg.sender] > amount);
125     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
126     if (token == address(0)) {
127       msg.sender.transfer(amount);
128     } else {
129       require(IMDEX(token).transfer(msg.sender, amount));
130     }
131     emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
132   }
133 
134   function IMDEXadminWithdraw(address token, uint256 amount, address user, uint256 feeWithdrawal) public onlyAdmin returns (bool) {
135     if (feeWithdrawal > 50 finney) feeWithdrawal = 50 finney;
136     require(tokens[token][user] > amount);
137     tokens[token][user] = safeSub(tokens[token][user], amount);
138     tokens[token][feeAccount] = safeAdd(tokens[token][feeAccount], safeMul(feeWithdrawal, amount) / 1 ether);
139     amount = safeMul((1 ether - feeWithdrawal), amount) / 1 ether;
140     if (token == address(0)) {
141       user.transfer(amount);
142     } else {
143       require(IMDEX(token).transfer(user, amount));
144     }
145     lastActiveTransaction[user] = block.number;
146     emit Withdraw(token, user, amount, tokens[token][user]);
147   }
148 
149   function balanceOf(address token, address user) public constant returns (uint256) {
150     return tokens[token][user];
151   }
152 
153   function IMDEXtrade(uint256[8] X, address[4] Y) public onlyAdmin returns (bool) {
154     /* amount is in amountBuy terms */
155     /* X
156        [0] amountBuy
157        [1] amountSell
158        [2] expires
159        [3] nonce
160        [4] amount
161        [5] tradeNonce
162        [6] feeMake
163        [7] feeTake
164      Y
165        [0] tokenBuy
166        [1] tokenSell
167        [2] maker
168        [3] taker
169      */
170     require(invalidOrder[Y[2]] < X[3]);
171     if (X[6] > 100 finney) X[6] = 100 finney;
172     if (X[7] > 100 finney) X[7] = 100 finney;
173     require(tokens[Y[0]][Y[3]] > X[4]);
174     require(tokens[Y[1]][Y[2]] > (safeMul(X[1], X[4]) / X[0]));
175     tokens[Y[0]][Y[3]] = safeSub(tokens[Y[0]][Y[3]], X[4]);
176     tokens[Y[0]][Y[2]] = safeAdd(tokens[Y[0]][Y[2]], safeMul(X[4], ((1 ether) - X[6])) / (1 ether));
177     tokens[Y[0]][feeAccount] = safeAdd(tokens[Y[0]][feeAccount], safeMul(X[4], X[6]) / (1 ether));
178     tokens[Y[1]][Y[2]] = safeSub(tokens[Y[1]][Y[2]], safeMul(X[1], X[4]) / X[0]);
179     tokens[Y[1]][Y[3]] = safeAdd(tokens[Y[1]][Y[3]], safeMul(safeMul(((1 ether) - X[7]), X[1]), X[4]) / X[0] / (1 ether));
180     tokens[Y[1]][feeAccount] = safeAdd(tokens[Y[1]][feeAccount], safeMul(safeMul(X[7], X[1]), X[4]) / X[0] / (1 ether));
181     lastActiveTransaction[Y[2]] = block.number;
182     lastActiveTransaction[Y[3]] = block.number;
183   }
184 }