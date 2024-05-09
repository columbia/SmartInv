1 pragma solidity ^0.4.9;
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
20 
21   function assert(bool assertion) internal {
22     if (!assertion) throw;
23   }
24 }
25 
26 
27 contract Token {
28   /// @notice send `_value` token to `_to` from `msg.sender`
29   /// @param _to The address of the recipient
30   /// @param _value The amount of token to be transferred
31   /// @return Whether the transfer was successful or not
32   function transfer(address _to, uint256 _value) returns (bool success) {}
33 
34   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
35   /// @param _from The address of the sender
36   /// @param _to The address of the recipient
37   /// @param _value The amount of token to be transferred
38   /// @return Whether the transfer was successful or not
39   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
40 }
41 
42 
43 contract Excalibur is SafeMath {
44 
45   address public admin;
46   bool public tradeState;
47   string public message;
48 
49   mapping (address => mapping (address => uint)) public tokens; // mapping of token addresses to mapping of account balances (token=0 means Ether)
50   mapping (address => mapping (bytes32 => bool)) public orders; // mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
51   mapping (address => mapping (bytes32 => uint)) public orderFills; // mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
52 
53 
54   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, bytes32 hash);
55   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, bytes32 hash, string pair);
56   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give, bytes32 hash, string pair);
57   event Deposit(address token, address user, uint amount, uint balance);
58   event Withdraw(address token, address user, uint amount, uint balance);
59 
60 
61   function Excalibur() {
62       admin = msg.sender;
63       tradeState = true;
64   }
65 
66   modifier onlyAdmin {
67         if (msg.sender != admin) throw;
68         _;
69   }
70 
71   modifier tradeIsOpen {
72         if (!tradeState) throw;
73         _;
74   }
75 
76   function checkAdmin() onlyAdmin constant returns (bool) {
77     return true;
78   }
79 
80   function transferOwnership(address newAdmin) onlyAdmin {
81     admin = newAdmin;
82   }
83 
84   function systemMessage(string msg) onlyAdmin {
85     message = msg;
86   }
87 
88   function changeTradeState(bool state_) onlyAdmin {
89     tradeState = state_;
90   }
91 
92   function deposit() payable tradeIsOpen {
93     // 0x0000000000000000000000000000000000000000
94     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
95     Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
96   }
97 
98   function withdraw(uint amount) {
99     if (tokens[0][msg.sender] < amount) throw;
100     tokens[0][msg.sender] = safeSub(tokens[0][msg.sender], amount);
101     if (!msg.sender.call.value(amount)()) throw;
102     Withdraw(0x0000000000000000000000000000000000000000, msg.sender, amount, tokens[0][msg.sender]);
103   }
104 
105   function depositToken(address token, uint amount) tradeIsOpen {
106     // remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
107     if (token==0) throw;
108     if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
109     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
110     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
111   }
112 
113   function withdrawToken(address token, uint amount) {
114     if (token==0) throw;
115     if (tokens[token][msg.sender] < amount) throw;
116     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
117     if (!Token(token).transfer(msg.sender, amount)) throw;
118     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
119   }
120 
121   function balanceOf(address token, address user) constant returns (uint) {
122     return tokens[token][user];
123   }
124 
125   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) {
126     bytes32 hash = sha3(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
127     orders[msg.sender][hash] = true;
128     Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, hash);
129   }
130 
131   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, string pair) {
132     // amount is in amountGet terms
133     bytes32 hash = sha3(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
134     if (!( (orders[user][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user) && block.number <= expires && safeAdd(orderFills[user][hash], amount) <= amountGet)) throw;
135     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
136     orderFills[user][hash] = safeAdd(orderFills[user][hash], amount);
137     Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender, hash, pair);
138   }
139 
140   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
141     tokens[tokenGet][msg.sender] = safeSub(tokens[tokenGet][msg.sender], amount);
142     tokens[tokenGet][user] = safeAdd(tokens[tokenGet][user], amount);
143     tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
144     tokens[tokenGive][msg.sender] = safeAdd(tokens[tokenGive][msg.sender], safeMul(amountGive, amount) / amountGet);
145   }
146 
147   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s, string pair) {
148     bytes32 hash = sha3(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
149     if (!(orders[msg.sender][hash] || ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) == msg.sender)) throw;
150     orderFills[msg.sender][hash] = amountGet;
151     Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s, hash, pair);
152   }
153 }