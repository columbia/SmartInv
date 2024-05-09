1 pragma solidity ^0.4.24;
2 
3 /* COOPEX Smart Contract */
4 /* This is the smart 'hotwallet' for the Cooperative Exchange. All Ethereum assets will be stored on this smart contract. This smart contract will be used while we work on a fully decentralized exchange. */
5 /* Visit us at https://coopex.market */
6 
7 contract Token {
8     bytes32 public standard;
9     bytes32 public name;
10     bytes32 public symbol;
11     uint256 public totalSupply;
12     uint8 public decimals;
13     bool public allowTransactions;
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16     function transfer(address _to, uint256 _value) returns (bool success);
17     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
18     function approve(address _spender, uint256 _value) returns (bool success);
19     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
20 }
21 
22 contract Exchange {
23     
24     
25 
26   function safeMul(uint a, uint b) internal pure returns (uint) {
27     uint c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function safeSub(uint a, uint b) internal pure returns (uint) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function safeAdd(uint a, uint b) internal pure returns (uint) {
38     uint c = a + b;
39     assert(c>=a && c>=b);
40     return c;
41   }
42   
43   constructor() {
44     owner = msg.sender;
45     locked = false;
46     secure = false;
47   }
48   
49   address public owner;
50   mapping (address => bool) public admins;
51   bool locked;
52   bool secure;
53   
54   event SetOwner(address indexed previousOwner, address indexed newOwner);
55   event Deposit(address token, address user, uint256 amount);
56   event Withdraw(address token, address user, uint256 amount);
57   event Lock(bool lock);
58   
59   modifier onlyOwner {
60     assert(msg.sender == owner);
61     _;
62   }
63   
64   modifier onlyAdmin {
65     require(msg.sender != owner && !admins[msg.sender]);
66     _;
67   }
68   
69   function setOwner(address newOwner) onlyOwner {
70     SetOwner(owner, newOwner);
71     owner = newOwner;
72   }
73   
74   function getOwner() view returns (address out) {
75     return owner;
76   }
77 
78   function setAdmin(address admin, bool isAdmin) onlyOwner {
79     admins[admin] = isAdmin;
80   }
81 
82 
83 
84   function() public payable {
85     Deposit(0, msg.sender, msg.value);
86   }
87 
88  
89 
90   function withdraw(address token, uint256 amount) onlyAdmin returns (bool success) {
91     require(!locked);
92     if (token == address(0)) {
93         if(msg.sender != owner && secure && (amount > this.balance / 3)){
94             locked = true;
95             Lock(true);
96         }
97         else{
98             require(msg.sender.send(amount));
99         }
100     } else {
101       require(amount <= Token(token).balanceOf(this));
102       require(Token(token).transfer(msg.sender, amount));
103     }
104     Withdraw(token, msg.sender, amount);
105     return true;
106   }
107 
108   function lock() onlyOwner{
109       locked = true;
110       Lock(true);
111   }
112   
113   function unlock() onlyOwner{
114       locked = false;
115       Lock(false);
116   }
117   
118   function secureMode() onlyOwner{
119       secure = true;
120   }
121   
122   function insecureMode() onlyOwner{
123       secure = false;
124   }
125   
126   function getBalance(address token) view returns (uint256 balance){
127       if(token == address(0)){
128           return this.balance;
129       }
130       else{
131           return Token(token).balanceOf(this);
132       }
133   }
134 
135 }