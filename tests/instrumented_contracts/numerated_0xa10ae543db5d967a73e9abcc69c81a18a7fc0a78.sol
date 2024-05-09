1 // BLOCKCLOUT is a social network for cryptocurrency enthusiasts 
2 // https://blockclout.com
3 // https://discord.gg/HDc2U5M
4 // https://t.me/blockcloutENG
5 // https://reddit.com/r/blockclout
6 // https://medium.com/@blockclout
7 
8 pragma solidity ^0.4.25;
9 
10 interface ERC20 {
11   function totalSupply() external view returns (uint256);
12   function balanceOf(address who) external view returns (uint256);
13   function allowance(address owner, address spender) external view returns (uint256);
14   function transfer(address to, uint256 value) external returns (bool);
15   function approve(address spender, uint256 value) external returns (bool);
16   function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
17   function transferFrom(address from, address to, uint256 value) external returns (bool);
18 
19   event Transfer(address indexed from, address indexed to, uint256 value);
20   event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 interface ApproveAndCallFallBack {
24     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
25 }
26 
27 
28 contract BlockClout is ERC20 {
29   using SafeMath for uint256;
30 
31   mapping (address => uint256) private balances;
32   mapping (address => mapping (address => uint256)) private allowed;
33   string public constant name  = "BLOCKCLOUT";
34   string public constant symbol = "CLOUT";
35   uint8 public constant decimals = 18;
36   
37   address owner = msg.sender;
38 
39   uint256 _totalSupply = 1000000000 * (10 ** 18); // 1 Billion Supply
40 
41   constructor() public {
42     balances[msg.sender] = _totalSupply;
43     emit Transfer(address(0), msg.sender, _totalSupply);
44   }
45 
46   function totalSupply() public view returns (uint256) {
47     return _totalSupply;
48   }
49 
50   function balanceOf(address player) public view returns (uint256) {
51     return balances[player];
52   }
53 
54   function allowance(address player, address spender) public view returns (uint256) {
55     return allowed[player][spender];
56   }
57 
58 
59   function transfer(address to, uint256 value) public returns (bool) {
60     require(value <= balances[msg.sender]);
61     require(to != address(0));
62 
63     balances[msg.sender] = balances[msg.sender].sub(value);
64     balances[to] = balances[to].add(value);
65 
66     emit Transfer(msg.sender, to, value);
67     return true;
68   }
69 
70   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
71     for (uint256 i = 0; i < receivers.length; i++) {
72       transfer(receivers[i], amounts[i]);
73     }
74   }
75 
76   function approve(address spender, uint256 value) public returns (bool) {
77     require(spender != address(0));
78     allowed[msg.sender][spender] = value;
79     emit Approval(msg.sender, spender, value);
80     return true;
81   }
82 
83   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
84         allowed[msg.sender][spender] = tokens;
85         emit Approval(msg.sender, spender, tokens);
86         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
87         return true;
88     }
89 
90   function transferFrom(address from, address to, uint256 value) public returns (bool) {
91     require(value <= balances[from]);
92     require(value <= allowed[from][msg.sender]);
93     require(to != address(0));
94     
95     balances[from] = balances[from].sub(value);
96     balances[to] = balances[to].add(value);
97     
98     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
99     
100     emit Transfer(from, to, value);
101     return true;
102   }
103 
104   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
105     require(spender != address(0));
106     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
107     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
108     return true;
109   }
110 
111   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
112     require(spender != address(0));
113     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
114     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
115     return true;
116   }
117 
118   function burn(uint256 amount) external {
119     require(amount != 0);
120     require(amount <= balances[msg.sender]);
121     _totalSupply = _totalSupply.sub(amount);
122     balances[msg.sender] = balances[msg.sender].sub(amount);
123     emit Transfer(msg.sender, address(0), amount);
124   }
125 
126 }
127 
128 
129 
130 
131 library SafeMath {
132   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133     if (a == 0) {
134       return 0;
135     }
136     uint256 c = a * b;
137     require(c / a == b);
138     return c;
139   }
140 
141   function div(uint256 a, uint256 b) internal pure returns (uint256) {
142     uint256 c = a / b;
143     return c;
144   }
145 
146   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147     require(b <= a);
148     return a - b;
149   }
150 
151   function add(uint256 a, uint256 b) internal pure returns (uint256) {
152     uint256 c = a + b;
153     require(c >= a);
154     return c;
155   }
156 
157   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
158     uint256 c = add(a,m);
159     uint256 d = sub(c,1);
160     return mul(div(d,m),m);
161   }
162 }