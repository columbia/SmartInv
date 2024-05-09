1 pragma solidity ^0.4.11;
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
18 
19 contract DVIP {
20   function feeFor(address from, address to, uint256 amount) constant external returns (uint256 value);
21 }
22 
23 contract Assertive {
24   function assert(bool assertion) {
25     if (!assertion) throw;
26   }
27 }
28 
29 contract Owned is Assertive {
30   address internal owner;
31   event SetOwner(address indexed previousOwner, address indexed newOwner);
32   function Owned () {
33     owner = msg.sender;
34   }
35   modifier onlyOwner {
36     assert(msg.sender == owner);
37     _;
38   }
39   function setOwner(address newOwner) onlyOwner {
40     SetOwner(owner, newOwner);
41     owner = newOwner;
42   }
43   function getOwner() returns (address out) {
44     return owner;
45   }
46 }
47 
48 contract Math is Assertive {
49   function safeMul(uint a, uint b) internal returns (uint) {
50     uint c = a * b;
51     assert(a == 0 || c / a == b);
52     return c;
53   }
54 
55   function safeSub(uint a, uint b) internal returns (uint) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function safeAdd(uint a, uint b) internal returns (uint) {
61     uint c = a + b;
62     assert(c>=a && c>=b);
63     return c;
64   }
65 }
66 
67 contract Exchange is Math, Owned {
68 
69   mapping (address => mapping (address => uint256)) public tokens;
70 
71   mapping (bytes32 => uint256) public orderFills;
72   address public feeAccount;
73   address public dvipAddress;
74   address public feeMakeExporter;
75   address public feeTakeExporter;
76   event Order(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);
77   event Cancel(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);
78   event Trade(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, address get, address give, bytes32 hash);
79   event Deposit(address token, address user, uint256 amount, uint256 balance);
80   event Withdraw(address token, address user, uint256 amount, uint256 balance);
81 
82   function Exchange(address feeAccount_, address dvipAddress_) {
83     feeAccount = feeAccount_;
84     dvipAddress = dvipAddress_;
85     feeMakeExporter = 0x00000000000000000000000000000000000000f7;
86     feeTakeExporter = 0x00000000000000000000000000000000000000f8;
87   }
88 
89   function setFeeAccount(address feeAccount_) onlyOwner {
90     feeAccount = feeAccount_;
91   }
92 
93   function setDVIP(address dvipAddress_) onlyOwner {
94     dvipAddress = dvipAddress_;
95   }
96 
97   function() {
98     throw;
99   }
100 
101   function deposit(address token, uint256 amount) payable {
102     if (token == address(0)) {
103       tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);
104     } else {
105       if (msg.value != 0) throw;
106       tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
107       if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
108     }
109     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
110   }
111 
112   function withdraw(address token, uint256 amount) {
113     if (tokens[token][msg.sender] < amount) throw;
114     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
115     if (token == address(0)) {
116       if (!msg.sender.send(amount)) throw;
117     } else {
118       if (!Token(token).transfer(msg.sender, amount)) throw;
119     }
120     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
121   }
122 
123   function balanceOf(address token, address user) constant returns (uint256) {
124     return tokens[token][user];
125   }
126 
127   uint256 internal feeTake;
128   uint256 internal feeMake;
129   uint256 internal feeTerm;
130   bytes32 internal tradeHash;
131 
132   function trade(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s, uint256 amount) {
133     //amount is in amountBuy terms
134     tradeHash = sha3(this, tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, user);
135     if (!(
136       ecrecover(sha3("\x19Ethereum Signed Message:\n32", tradeHash),v,r,s) == user &&
137       block.number <= expires &&
138       safeAdd(orderFills[tradeHash], amount) <= amountBuy &&
139       tokens[tokenBuy][msg.sender] >= amount &&
140       tokens[tokenSell][user] >= safeMul(amountSell, amount) / amountBuy
141     )) throw;
142     feeMake = DVIP(dvipAddress).feeFor(feeMakeExporter, msg.sender, 1 ether);
143     feeTake = DVIP(dvipAddress).feeFor(feeTakeExporter, user, 1 ether);
144     tokens[tokenBuy][msg.sender] = safeSub(tokens[tokenBuy][msg.sender], amount);
145     feeTerm = safeMul(amount, ((1 ether) - feeMake)) / (1 ether);
146     tokens[tokenBuy][user] = safeAdd(tokens[tokenBuy][user], feeTerm);
147     feeTerm = safeMul(amount, feeMake) / (1 ether);
148     tokens[tokenBuy][feeAccount] = safeAdd(tokens[tokenBuy][feeAccount], feeTerm);
149     feeTerm = safeMul(amountSell, amount) / amountBuy;
150     tokens[tokenSell][user] = safeSub(tokens[tokenSell][user], feeTerm);
151     feeTerm = safeMul(safeMul(((1 ether) - feeTake), amountSell), amount) / amountBuy / (1 ether);
152     tokens[tokenSell][msg.sender] = safeAdd(tokens[tokenSell][msg.sender], feeTerm);
153     feeTerm = safeMul(safeMul(feeTake, amountSell), amount) / amountBuy / (1 ether);
154     tokens[tokenSell][feeAccount] = safeAdd(tokens[tokenSell][feeAccount], feeTerm);
155     orderFills[tradeHash] = safeAdd(orderFills[tradeHash], amount);
156     Trade(tokenBuy, amount, tokenSell, amountSell * amount / amountBuy, user, msg.sender, tradeHash);
157   }
158 
159   bytes32 internal testHash;
160   uint256 internal amountSelln;
161 
162   function testTrade(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s, uint256 amount, address sender) constant returns (uint8 code) {
163     testHash = sha3(this, tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, user);
164     if (tokens[tokenBuy][sender] < amount) return 1;
165     if (ecrecover(sha3("\x19Ethereum Signed Message:\n32", testHash), v, r, s) != user) return 4;
166     amountSelln = safeMul(amountSell, amount) / amountBuy;
167     if (tokens[tokenSell][user] < amountSelln) return 5;
168     if (block.number > expires) return 6;
169     if (safeAdd(orderFills[testHash], amount) > amountBuy) return 7;
170     return 0;
171   }
172   function cancelOrder(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, uint8 v, bytes32 r, bytes32 s, address user) {
173     bytes32 hash = sha3(this, tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, user);
174     if (ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash),v,r,s) != msg.sender) throw;
175     orderFills[hash] = amountBuy;
176     Cancel(tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, msg.sender, v, r, s);
177   }
178 }