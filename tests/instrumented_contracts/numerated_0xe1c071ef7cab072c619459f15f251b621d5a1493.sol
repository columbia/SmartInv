1 /**
2  
3  https://t.me/ReturnCommunity
4  https://returncoin.pro/
5  https://x.com/returntokeneth
6 
7 */
8 
9 
10 pragma solidity ^0.4.25;
11 
12 interface ERC20 {
13   function totalSupply() external view returns (uint256);
14   function balanceOf(address who) external view returns (uint256);
15   function allowance(address owner, address spender) external view returns (uint256);
16   function transfer(address to, uint256 value) external returns (bool);
17   function approve(address spender, uint256 value) external returns (bool);
18   function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
19   function transferFrom(address from, address to, uint256 value) external returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 interface ApproveAndCallFallBack {
25     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
26 }
27 
28 
29 contract RETURN is ERC20 {
30   using SafeMath for uint256;
31 
32   mapping (address => uint256) private balances;
33   mapping (address => mapping (address => uint256)) private allowed;
34   string public constant name  = "RETURN";
35   string public constant symbol = "RTN";
36   uint8 public constant decimals = 18;
37   
38   address owner = msg.sender;
39 
40   uint256 _totalSupply = 1000000000000 * (10 ** 18); 
41 
42   constructor() public {
43     balances[msg.sender] = _totalSupply;
44     emit Transfer(address(0), msg.sender, _totalSupply);
45   }
46 
47   function totalSupply() public view returns (uint256) {
48     return _totalSupply;
49   }
50 
51   function balanceOf(address player) public view returns (uint256) {
52     return balances[player];
53   }
54 
55   function allowance(address player, address spender) public view returns (uint256) {
56     return allowed[player][spender];
57   }
58 
59 
60   function transfer(address to, uint256 value) public returns (bool) {
61     require(value <= balances[msg.sender]);
62     require(to != address(0));
63 
64     balances[msg.sender] = balances[msg.sender].sub(value);
65     balances[to] = balances[to].add(value);
66 
67     emit Transfer(msg.sender, to, value);
68     return true;
69   }
70 
71   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
72     for (uint256 i = 0; i < receivers.length; i++) {
73       transfer(receivers[i], amounts[i]);
74     }
75   }
76 
77   function approve(address spender, uint256 value) public returns (bool) {
78     require(spender != address(0));
79     allowed[msg.sender][spender] = value;
80     emit Approval(msg.sender, spender, value);
81     return true;
82   }
83 
84   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
85         allowed[msg.sender][spender] = tokens;
86         emit Approval(msg.sender, spender, tokens);
87         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
88         return true;
89     }
90 
91   function transferFrom(address from, address to, uint256 value) public returns (bool) {
92     require(value <= balances[from]);
93     require(value <= allowed[from][msg.sender]);
94     require(to != address(0));
95     
96     balances[from] = balances[from].sub(value);
97     balances[to] = balances[to].add(value);
98     
99     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
100     
101     emit Transfer(from, to, value);
102     return true;
103   }
104 
105   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
106     require(spender != address(0));
107     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
108     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
109     return true;
110   }
111 
112   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
113     require(spender != address(0));
114     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
115     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
116     return true;
117   }
118 
119   function burn(uint256 amount) external {
120     require(amount != 0);
121     require(amount <= balances[msg.sender]);
122     _totalSupply = _totalSupply.sub(amount);
123     balances[msg.sender] = balances[msg.sender].sub(amount);
124     emit Transfer(msg.sender, address(0), amount);
125   }
126 
127 }
128 
129 
130 
131 
132 library SafeMath {
133   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134     if (a == 0) {
135       return 0;
136     }
137     uint256 c = a * b;
138     require(c / a == b);
139     return c;
140   }
141 
142   function div(uint256 a, uint256 b) internal pure returns (uint256) {
143     uint256 c = a / b;
144     return c;
145   }
146 
147   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148     require(b <= a);
149     return a - b;
150   }
151 
152   function add(uint256 a, uint256 b) internal pure returns (uint256) {
153     uint256 c = a + b;
154     require(c >= a);
155     return c;
156   }
157 
158   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
159     uint256 c = add(a,m);
160     uint256 d = sub(c,1);
161     return mul(div(d,m),m);
162   }
163 }