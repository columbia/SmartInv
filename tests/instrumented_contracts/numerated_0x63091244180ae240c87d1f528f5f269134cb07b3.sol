1 pragma solidity ^0.4.6;
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
67 contract ExchangeWhitelist is Math, Owned {
68 
69   mapping (address => mapping (address => uint256)) public tokens; //mapping of token addresses to mapping of account balances
70 
71   struct Account {
72     bool authorized;
73     uint256 tier;
74     uint256 resetWithdrawal;
75     uint256 withdrawn;
76   }
77 
78   mapping (address => Account) public accounts;
79   mapping (address => bool) public whitelistAdmins;
80   mapping (address => bool) public admins;
81   //ether balances are held in the token=0 account
82   mapping (bytes32 => uint256) public orderFills;
83   address public feeAccount;
84   address public dvipAddress;
85   address public feeMakeExporter;
86   address public feeTakeExporter;
87   event Order(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);
88   event Cancel(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s);
89   event Trade(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, address get, address give, bytes32 hash);
90   event Deposit(address token, address user, uint256 amount, uint256 balance);
91   event Withdraw(address token, address user, uint256 amount, uint256 balance);
92 
93   function ExchangeWhitelist(address feeAccount_, address dvipAddress_) {
94     feeAccount = feeAccount_;
95     dvipAddress = dvipAddress_;
96     feeMakeExporter = 0x00000000000000000000000000000000000000f7;
97     feeTakeExporter = 0x00000000000000000000000000000000000000f8;
98   }
99 
100   function setFeeAccount(address feeAccount_) onlyOwner {
101     feeAccount = feeAccount_;
102   }
103 
104   function setDVIP(address dvipAddress_) onlyOwner {
105     dvipAddress = dvipAddress_;
106   }
107 
108   function setAdmin(address admin, bool isAdmin) onlyOwner {
109     admins[admin] = isAdmin;
110   }
111 
112   function setWhitelister(address whitelister, bool isWhitelister) onlyOwner {
113     whitelistAdmins[whitelister] = isWhitelister;
114   }
115 
116   modifier onlyWhitelister {
117     if (!whitelistAdmins[msg.sender]) throw;
118     _;
119   }
120 
121   modifier onlyAdmin {
122     if (msg.sender != owner && !admins[msg.sender]) throw;
123     _;
124   }
125   function setWhitelisted(address target, bool isWhitelisted) onlyWhitelister {
126     accounts[target].authorized = isWhitelisted;
127   }
128   modifier onlyWhitelisted {
129     if (!accounts[msg.sender].authorized) throw;
130     _;
131   }
132 
133   function() {
134     throw;
135   }
136 
137   function deposit(address token, uint256 amount) payable {
138     if (token == address(0)) {
139       tokens[address(0)][msg.sender] = safeAdd(tokens[address(0)][msg.sender], msg.value);
140     } else {
141       if (msg.value != 0) throw;
142       tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
143       if (!Token(token).transferFrom(msg.sender, this, amount)) throw;
144     }
145     Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
146   }
147 
148   function withdraw(address token, uint256 amount) {
149     if (tokens[token][msg.sender] < amount) throw;
150     tokens[token][msg.sender] = safeSub(tokens[token][msg.sender], amount);
151     if (token == address(0)) {
152       if (!msg.sender.send(amount)) throw;
153     } else {
154       if (!Token(token).transfer(msg.sender, amount)) throw;
155     }
156     Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
157   }
158 
159   function balanceOf(address token, address user) constant returns (uint256) {
160     return tokens[token][user];
161   }
162 
163   uint256 internal feeTake;
164   uint256 internal feeMake;
165   uint256 internal feeTerm;
166 
167   function trade(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s, uint256 amount) onlyWhitelisted {
168     //amount is in amountBuy terms
169     bytes32 hash = sha3(tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, user);
170     if (!(
171       ecrecover(hash,v,r,s) == user &&
172       block.number <= expires &&
173       safeAdd(orderFills[hash], amount) <= amountBuy &&
174       tokens[tokenBuy][msg.sender] >= amount &&
175       tokens[tokenSell][user] >= safeMul(amountSell, amount) / amountBuy
176     )) throw;
177     feeMake = DVIP(dvipAddress).feeFor(feeMakeExporter, msg.sender, 1 ether);
178     feeTake = DVIP(dvipAddress).feeFor(feeTakeExporter, user, 1 ether);
179     tokens[tokenBuy][msg.sender] = safeSub(tokens[tokenBuy][msg.sender], amount);
180     feeTerm = safeMul(amount, ((1 ether) - feeMake)) / (1 ether);
181     tokens[tokenBuy][user] = safeAdd(tokens[tokenBuy][user], feeTerm);
182     feeTerm = safeMul(amount, feeMake) / (1 ether);
183     tokens[tokenBuy][feeAccount] = safeAdd(tokens[tokenBuy][feeAccount], feeTerm);
184     feeTerm = safeMul(amountSell, amount) / amountBuy;
185     tokens[tokenSell][user] = safeSub(tokens[tokenSell][user], feeTerm);
186     feeTerm = safeMul(safeMul(((1 ether) - feeTake), amountSell), amount) / amountBuy / (1 ether);
187     tokens[tokenSell][msg.sender] = safeAdd(tokens[tokenSell][msg.sender], feeTerm);
188     feeTerm = safeMul(safeMul(feeTake, amountSell), amount) / amountBuy / (1 ether);
189     tokens[tokenSell][feeAccount] = safeAdd(tokens[tokenSell][feeAccount], feeTerm);
190     orderFills[hash] = safeAdd(orderFills[hash], amount);
191     Trade(tokenBuy, amount, tokenSell, amountSell * amount / amountBuy, user, msg.sender, hash);
192   }
193 
194   bytes32 internal testHash;
195   uint256 internal amountSelln;
196 
197   function testTrade(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, address user, uint8 v, bytes32 r, bytes32 s, uint256 amount, address sender) constant returns (uint8 code) {
198     testHash = sha3(tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, user);
199     if (tokens[tokenBuy][sender] < amount) return 1;
200     if (!accounts[sender].authorized) return 2; 
201     if (!accounts[user].authorized) return 3;
202     if (ecrecover(testHash, v, r, s) != user) return 4;
203     amountSelln = safeMul(amountSell, amount) / amountBuy;
204     if (tokens[tokenSell][user] < amountSelln) return 5;
205     if (block.number > expires) return 6;
206     if (safeAdd(orderFills[testHash], amount) > amountBuy) return 7;
207     return 0;
208   }
209   function cancelOrder(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, uint256 expires, uint256 nonce, uint8 v, bytes32 r, bytes32 s, address user) {
210     bytes32 hash = sha3(tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, user);
211     if (ecrecover(hash,v,r,s) != msg.sender) throw;
212     orderFills[hash] = amountBuy;
213     Cancel(tokenBuy, amountBuy, tokenSell, amountSell, expires, nonce, msg.sender, v, r, s);
214   }
215 }