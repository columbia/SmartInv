1 pragma solidity ^0.4.15;
2 
3 
4 contract SafeMath {
5     function safeMul(uint a, uint b) internal returns (uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeSub(uint a, uint b) internal returns (uint) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     function safeAdd(uint a, uint b) internal returns (uint) {
17         uint c = a + b;
18         assert(c>=a && c>=b);
19         return c;
20     }
21 }
22 
23 
24 contract Token {
25   function totalSupply() constant returns (uint256 supply) {}
26   function balanceOf(address _owner) constant returns (uint256 balance) {}
27   function transfer(address _to, uint256 _value) returns (bool success) {}
28   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
29   function approve(address _spender, uint256 _value) returns (bool success) {}
30   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
31 
32   event Transfer(address indexed _from, address indexed _to, uint256 _value);
33   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 
35   uint public decimals;
36   string public name;
37 }
38 
39 contract TokenLab is SafeMath {
40     address public admin;
41     address public feeAccount;
42     uint public feeMake;
43     uint public feeTake;
44     mapping (address => mapping (address => uint)) public tokens;
45     mapping (address => mapping (bytes32 => bool)) public orders;
46     mapping (address => mapping (bytes32 => uint)) public orderFills;
47 
48     event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
49     event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
50     event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
51     event Deposit(address token, address user, uint amount, uint balance);
52     event Withdraw(address token, address user, uint amount, uint balance);
53 
54     function TokenLab(address feeAccount_, uint feeMake_, uint feeTake_) {
55         admin = msg.sender;
56         feeAccount = feeAccount_;
57         feeMake = feeMake_;
58         feeTake = feeTake_;
59     }
60 
61     modifier onlyAdmin () {
62         require(msg.sender == admin);
63         _;
64     }
65 
66     function changeAdmin(address admin_) onlyAdmin {
67         admin = admin_;
68     }
69 
70     function changeFeeAccount(address feeAccount_) onlyAdmin {
71         feeAccount = feeAccount_;
72     }
73 
74     function changeFeeMake(uint feeMake_) onlyAdmin {
75         require (feeMake_ <= feeMake);
76         feeMake = feeMake_;
77     }
78 
79     function changeFeeTake(uint feeTake_) onlyAdmin {
80         require (feeTake_ <= feeTake);
81         feeTake = feeTake_;
82     }
83 
84     function deposit() payable {
85         tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
86         Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
87     }
88 
89     function withdraw(uint amount) {
90         require(tokens[0][msg.sender] >= amount);
91         tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
92         require(msg.sender.call.value(amount)());
93         Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
94     }
95 
96     function depositToken(address token, uint amount) {
97         require (token!=0);
98         require (Token(token).transferFrom(msg.sender, this, amount));
99         tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
100         Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
101     }
102 
103     function withdrawToken(address token, uint amount) {
104         require (token!=0);
105         require (tokens[token][msg.sender] >= amount);
106         tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
107         require (Token(token).transfer(msg.sender, amount));
108         Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
109     }
110 
111     function balanceOf(address token, address user) constant returns (uint) {
112         return tokens[token][user];
113     }
114 
115     function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {
116         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
117         orders[msg.sender][hash] = true;
118         Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
119     }
120 
121     function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
122         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
123         require ((
124         (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
125         block.number <= expires &&
126         safeAdd(orderFills[user][hash], amount) <= amountGet
127         ));
128         tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
129         orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
130         Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
131     }
132 
133     function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
134         uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
135         uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
136         tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
137         tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(amount, feeMakeXfer));
138         tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeAdd(feeMakeXfer, feeTakeXfer));
139         tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
140         tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
141     }
142 
143     function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {
144         if (!(
145         tokens[tokenGet][sender] >= amount &&
146         availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
147         )) return false;
148         return true;
149     }
150 
151     function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
152         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
153         if (!(
154         (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
155         block.number <= expires
156         )) return 0;
157         uint available1 = safeSub(amountGet, orderFills[user][hash]);
158         uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
159         if (available1<available2) return available1;
160         return available2;
161     }
162 
163     function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user) constant returns(uint) {
164         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
165         return orderFills[user][hash];
166     }
167 
168     function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) {
169         bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
170         require ((orders[msg.sender][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender));
171         orderFills[msg.sender][hash] = amountGet;
172         Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
173     }
174 }