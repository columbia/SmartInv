1 pragma solidity ^0.4.25;
2 
3 contract Payiza {
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
52 contract PayizaDex is SafeMath {
53 
54   address public owner;
55   mapping (address => uint256) public invalidOrder;
56   event SetOwner(address indexed previousOwner, address indexed newOwner);
57   modifier onlyOwner {
58     require(msg.sender == owner);
59     _;
60   }
61 
62   function setOwner(address newOwner)public onlyOwner {
63     emit SetOwner(owner, newOwner);
64     owner = newOwner;
65   }
66 
67   function invalidateOrdersBefore(address user, uint256 nonce) public onlyAdmin {
68     require(nonce > invalidOrder[user]);
69     invalidOrder[user] = nonce;
70   }
71 
72   mapping (address => mapping (address => uint256)) public tokens; //mapping of token addresses to mapping of account balances
73   mapping (address => bool) public admins;
74   mapping (address => uint256) public lastActiveTransaction;
75   address public feeAccount;
76   uint256 public inactivityReleasePeriod;
77   event Trade(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, address get, address give);
78   event Deposit(address token, address user, uint256 amount, uint256 balance);
79   event Withdraw(address token, address user, uint256 amount, uint256 balance);
80 
81   function setInactivityReleasePeriod(uint256 expiry) public onlyAdmin returns (bool success) {
82     require(expiry < 1000000);
83     inactivityReleasePeriod = expiry;
84     return true;
85   }
86 
87   constructor(address feeAccount_) public {
88     owner = msg.sender;
89     feeAccount = feeAccount_;
90     inactivityReleasePeriod = 100000;
91   }
92 
93   function setAdmin(address admin, bool isAdmin) public onlyOwner {
94     admins[admin] = isAdmin;
95   }
96 
97   modifier onlyAdmin {
98    require(msg.sender == owner && admins[msg.sender]);
99     _;
100   }
101 
102   function() external {
103     revert();
104   }
105 
106 
107 
108   function depositToken(address token, uint256 amount) public {
109     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
110     lastActiveTransaction[msg.sender] = block.number;
111     require(Payiza(token).transferFrom(msg.sender, this, amount));
112     emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
113   }
114 
115   function deposit() public payable {
116     tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);
117     lastActiveTransaction[msg.sender] = block.number;
118     emit Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);
119   }
120 
121 function withdrawToken(address token, uint256 amount) public returns (bool) {
122     require(safeSub(block.number, lastActiveTransaction[msg.sender]) > inactivityReleasePeriod);
123     require(tokens[token][msg.sender] > amount);
124     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
125     if (token == address(0)) {
126       msg.sender.transfer(amount);
127     } else {
128       require(Payiza(token).transfer(msg.sender, amount));
129     }
130     emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
131   }
132 
133   function withdraw(address token, uint256 amount, address user, uint256 feeWithdrawal) public onlyAdmin returns (bool) {
134     if (feeWithdrawal > 50 finney) feeWithdrawal = 50 finney;
135     require(tokens[token][user] > amount);
136     tokens[token][user] = safeSub(tokens[token][user], amount);
137     tokens[token][feeAccount] = safeAdd(tokens[token][feeAccount], safeMul(feeWithdrawal, amount) / 1 ether);
138     amount = safeMul((1 ether - feeWithdrawal), amount) / 1 ether;
139     if (token == address(0)) {
140       user.transfer(amount);
141     } else {
142       require(Payiza(token).transfer(user, amount));
143     }
144     lastActiveTransaction[user] = block.number;
145     emit Withdraw(token, user, amount, tokens[token][user]);
146   }
147 
148   function balanceOf(address token, address user) public constant returns (uint256) {
149     return tokens[token][user];
150   }
151 
152   function trade(uint256[8] X, address[4] Y) public onlyAdmin returns (bool) {
153     /* amount is in amountBuy terms */
154     /* X
155        [0] amountBuy
156        [1] amountSell
157        [2] expires
158        [3] nonce
159        [4] amount
160        [5] tradeNonce
161        [6] feeMake
162        [7] feeTake
163      Y
164        [0] tokenBuy
165        [1] tokenSell
166        [2] maker
167        [3] taker
168      */
169     require(invalidOrder[Y[2]] < X[3]);
170     if (X[6] > 100 finney) X[6] = 100 finney;
171     if (X[7] > 100 finney) X[7] = 100 finney;
172     require(tokens[Y[0]][Y[3]] > X[4]);
173     require(tokens[Y[1]][Y[2]] > (safeMul(X[1], X[4]) / X[0]));
174     tokens[Y[0]][Y[3]] = safeSub(tokens[Y[0]][Y[3]], X[4]);
175     tokens[Y[0]][Y[2]] = safeAdd(tokens[Y[0]][Y[2]], safeMul(X[4], ((1 ether) - X[6])) / (1 ether));
176     tokens[Y[0]][feeAccount] = safeAdd(tokens[Y[0]][feeAccount], safeMul(X[4], X[6]) / (1 ether));
177     tokens[Y[1]][Y[2]] = safeSub(tokens[Y[1]][Y[2]], safeMul(X[1], X[4]) / X[0]);
178     tokens[Y[1]][Y[3]] = safeAdd(tokens[Y[1]][Y[3]], safeMul(safeMul(((1 ether) - X[7]), X[1]), X[4]) / X[0] / (1 ether));
179     tokens[Y[1]][feeAccount] = safeAdd(tokens[Y[1]][feeAccount], safeMul(safeMul(X[7], X[1]), X[4]) / X[0] / (1 ether));
180     lastActiveTransaction[Y[2]] = block.number;
181     lastActiveTransaction[Y[3]] = block.number;
182   }
183 }