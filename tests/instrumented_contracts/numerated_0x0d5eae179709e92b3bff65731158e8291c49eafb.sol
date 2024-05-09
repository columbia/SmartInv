1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeSub(uint a, uint b) internal returns (uint) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function safeAdd(uint a, uint b) internal returns (uint) {
16     uint c = a + b;
17     assert(c>=a && c>=b);
18     return c;
19   }
20 }
21 
22 contract Token {
23     bytes32 public standard;
24     bytes32 public name;
25     bytes32 public symbol;
26     uint256 public totalSupply;
27     uint8 public decimals;
28     bool public allowTransactions;
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31     function transfer(address _to, uint256 _value) returns (bool success);
32     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
33     function approve(address _spender, uint256 _value) returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35 }
36 
37 contract GaintDex is SafeMath {
38   address public admin; //the admin address
39   address public feeAccount; //the account that will receive fees
40   uint public feeMake; //percentage times (1 ether)
41   uint public feeTake; //percentage times (1 ether)
42   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
43   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
44   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
45 
46   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
47   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
48   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
49   event Deposit(address token, address user, uint amount, uint balance);
50   event Withdraw(address token, address user, uint amount, uint balance);
51 
52   constructor() {
53     admin = msg.sender;
54     feeAccount = msg.sender;
55     feeMake = 700000000000000;
56     feeTake = 700000000000000;
57   }
58 
59   function changeAdmin(address admin_) {
60     require(msg.sender == admin);
61     admin = admin_;
62   }
63 
64   function changeFeeAccount(address feeAccount_) {
65     require(msg.sender == admin);
66     feeAccount = feeAccount_;
67   }
68 
69   function changeFeeMake(uint feeMake_) {
70     require(msg.sender == admin);
71     feeMake = feeMake_;
72   }
73 
74   function changeFeeTake(uint feeTake_) {
75     require(msg.sender == admin);
76     feeTake = feeTake_;
77   }
78 
79   function deposit() payable {
80     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
81     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
82   }
83 
84   function withdraw(uint amount) {
85     require(tokens[0][msg.sender] >= amount);
86     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
87     require(msg.sender.call.value(amount)());
88     Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
89   }
90 
91   function depositToken(address token, uint amount) {
92     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
93     require(token != 0);
94     require(Token(token).transferFrom(msg.sender, this, amount));
95     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
96     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
97   }
98 
99   function withdrawToken(address token, uint amount) {
100     require(token !=0 );
101     require(tokens[token][msg.sender] >= amount);
102     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
103     require(Token(token).transfer(msg.sender, amount));
104     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
105   }
106 
107   function balanceOf(address token, address user) constant returns (uint) {
108     return tokens[token][user];
109   }
110 
111   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
112     //amount is in amountGet terms
113     bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
114     require((ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
115        block.number <= expires && safeAdd(orderFills[user][hash], amount) <= amountGet);
116     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
117     orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
118     Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
119   }
120 
121   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
122     uint feeMakeXfer = safeMul(amount, feeMake) / (1 ether);
123     uint feeTakeXfer = safeMul(amount, feeTake) / (1 ether);
124     
125     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], safeAdd(amount, feeTakeXfer));
126     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], safeSub(amount, feeMakeXfer));
127     tokens[tokenGet][feeAccount] = safeAdd(tokens[tokenGet][feeAccount], safeAdd(feeMakeXfer, feeTakeXfer));
128     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
129     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
130   }
131 
132   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) constant returns(bool) {
133     if (!(
134       tokens[tokenGet][sender] >= amount &&
135       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
136     )) return false;
137     return true;
138   }
139 
140   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
141     bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
142     if (!(
143       (ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) &&
144       block.number <= expires
145     )) return 0;
146     uint available1 = safeSub(amountGet, orderFills[user][hash]);
147     uint available2 = safeMul(tokens[tokenGive][user], amountGet) / amountGive;
148     if (available1<available2) return available1;
149     return available2;
150   }
151 
152   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) constant returns(uint) {
153     bytes32 hash = keccak256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
154     return orderFills[user][hash];
155   }
156 }