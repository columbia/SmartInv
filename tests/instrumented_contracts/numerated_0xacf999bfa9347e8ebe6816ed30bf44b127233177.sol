1 pragma solidity ^0.4.23;
2 
3 /******************************************************************
4  * AXNET Decentralized Exchange Smart Contract * 
5  * ***************************************************************/
6 
7 contract SafeMath {
8   function safeMul(uint a, uint b) internal pure returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeSub(uint a, uint b) internal pure returns (uint) {
15     assert(b <= a);
16     return a - b;
17   }
18 
19   function safeAdd(uint a, uint b) internal pure returns (uint) {
20     uint c = a + b;
21     assert(c>=a && c>=b);
22     return c;
23   }
24 }
25 
26 // ----------------------------------------------------------------------------
27 // Owned contract
28 // ----------------------------------------------------------------------------
29 contract Owned {
30     address public owner;
31     address public newOwner;
32 
33     event OwnershipTransferred(address indexed _from, address indexed _to);
34 
35     constructor() public {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     function transferOwnership(address _newOwner) public onlyOwner {
45         newOwner = _newOwner;
46     }
47     
48     function acceptOwnership() public {
49         require(msg.sender == newOwner);
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52         newOwner = address(0);
53     }
54 }
55 
56 contract Token {
57     function totalSupply() public constant returns (uint);
58     function balanceOf(address _owner) public constant returns (uint);
59     function allowance(address _owner, address _spender) public constant returns (uint);
60     
61     function transfer(address _to, uint _value) public returns (bool success);
62     function approve(address _spender, uint _value) public returns (bool success);
63     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
64     
65     event Transfer(address indexed from, address indexed to, uint tokens);
66     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
67 
68     string public name;
69     string public symbol;
70     uint8 public decimals;  // 18 is the most common number of decimal places
71 }
72 
73 
74 contract AXNETDEX is SafeMath, Owned {
75   address public feeAccount; //the account that will receive fees
76 
77   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
78 
79   mapping (address => bool) public admins;  //admins who is responsible for trading
80   
81   //mapping of order hash to mapping of uints (amount of order that has been filled)
82   mapping (bytes32 => uint256) public orderFills;
83   
84   //to make sure withdraw and trade will be done only once
85   mapping (bytes32 => bool) public withdrawn;
86   mapping (bytes32 => bool) public traded;
87   
88   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
89   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
90   event Deposit(address token, address user, uint amount, uint balance);
91   event Withdraw(address token, address user, uint amount, uint balance);
92 
93  constructor() public {
94     feeAccount = msg.sender;
95   }
96 
97   function() public {
98     revert();
99   }
100   
101   function setAdmin(address admin, bool isAdmin) public onlyOwner {
102     admins[admin] = isAdmin;
103   }
104   
105   modifier onlyAdmin {
106     require(msg.sender == owner || admins[msg.sender]);
107     _;
108   }
109 
110   function changeFeeAccount(address feeAccount_) public onlyOwner {
111     feeAccount = feeAccount_;
112   }
113 
114   function deposit() payable public {
115     tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value);
116     emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
117   }
118 
119   function depositToken(address token, uint amount) public {
120     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
121     require(token!=0);
122     assert(Token(token).transferFrom(msg.sender, this, amount));
123     
124     tokens[token][msg.sender] = safeAdd(tokens[token][msg.sender], amount);
125     emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
126   }
127 
128   function adminWithdraw(address token, uint amount, address user, uint nonce, uint8 v, bytes32 r, bytes32 s, uint feeWithdrawal) public onlyAdmin {
129     bytes32 hash = sha256(this, token, amount, user, nonce);
130     require(!withdrawn[hash]);
131     withdrawn[hash] = true;
132     
133     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user);
134     
135     if (feeWithdrawal > 50 finney) feeWithdrawal = 50 finney;
136 
137     require(tokens[token][user] >= amount);
138     tokens[token][user] = safeSub(tokens[token][user], amount);
139     tokens[token][feeAccount] = safeAdd(tokens[token][feeAccount], safeMul(feeWithdrawal, amount) / 1 ether);
140     amount = safeMul((1 ether - feeWithdrawal), amount) / 1 ether;
141 
142     if (token == address(0)) {
143       assert(user.send(amount));
144     } else {
145       assert(Token(token).transfer(user, amount));
146     }
147     
148     emit Withdraw(token, user, amount, tokens[token][user]);
149   }
150 
151   function balanceOf(address token, address user)  public view returns (uint) {
152     return tokens[token][user];
153   }
154   
155     /* uint values
156          0:amountGet, 1:amountGive, 2:expires, 3:nonce, 4:amount, 5:tradeNonce, 6:feeMake, 7:feeTake
157        addressses
158          0:tokenGet, 1:tokenGive, 2:maker, 3:taker
159      signature binary
160        v[0] rs[0] rs[1] : signature for order
161        v[1] rs[2] rs[3] : signature for trade
162      */
163   function trade(uint[8] tradeValues, address[4] tradeAddresses, uint8[2] v, bytes32[4] rs) public onlyAdmin {
164     bytes32 orderHash = sha256(this, tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeValues[2], tradeValues[3], tradeAddresses[2]);
165     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", orderHash), v[0], rs[0], rs[1]) == tradeAddresses[2]);
166     bytes32 tradeHash = sha256(orderHash, tradeValues[4], tradeAddresses[3], tradeValues[5]);
167     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", tradeHash), v[1], rs[2], rs[3]) == tradeAddresses[3]);
168     
169     require(!traded[tradeHash]);
170     traded[tradeHash] = true;
171     
172     require(safeAdd(orderFills[orderHash], tradeValues[4]) <= tradeValues[0]);
173     require(tokens[tradeAddresses[0]][tradeAddresses[3]] >= tradeValues[4]);
174     require(tokens[tradeAddresses[1]][tradeAddresses[2]] >= (safeMul(tradeValues[1], tradeValues[4]) / tradeValues[0]));
175     
176     tokens[tradeAddresses[0]][tradeAddresses[3]] = safeSub(tokens[tradeAddresses[0]][tradeAddresses[3]], tradeValues[4]);
177     tokens[tradeAddresses[0]][tradeAddresses[2]] = safeAdd(tokens[tradeAddresses[0]][tradeAddresses[2]], safeMul(tradeValues[4], ((1 ether) - tradeValues[6])) / (1 ether));
178     tokens[tradeAddresses[0]][feeAccount] = safeAdd(tokens[tradeAddresses[0]][feeAccount], safeMul(tradeValues[4], tradeValues[6]) / (1 ether));
179     tokens[tradeAddresses[1]][tradeAddresses[2]] = safeSub(tokens[tradeAddresses[1]][tradeAddresses[2]], safeMul(tradeValues[1], tradeValues[4]) / tradeValues[0]);
180     tokens[tradeAddresses[1]][tradeAddresses[3]] = safeAdd(tokens[tradeAddresses[1]][tradeAddresses[3]], safeMul(safeMul(((1 ether) - tradeValues[7]), tradeValues[1]), tradeValues[4]) / tradeValues[0] / (1 ether));
181     tokens[tradeAddresses[1]][feeAccount] = safeAdd(tokens[tradeAddresses[1]][feeAccount], safeMul(safeMul(tradeValues[7], tradeValues[1]), tradeValues[4]) / tradeValues[0] / (1 ether));
182     orderFills[orderHash] = safeAdd(orderFills[orderHash], tradeValues[4]);
183   }
184 
185 
186   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s, address user) public onlyAdmin {
187     bytes32 hash = sha256(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, user);
188     assert(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s) == user);
189     orderFills[hash] = amountGet;
190     emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s);
191   }
192 }