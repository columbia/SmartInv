1 pragma solidity ^0.4.25;
2 
3 interface ERC20 {
4   function totalSupply() external view returns (uint256);
5   function balanceOf(address who) external view returns (uint256);
6   function allowance(address owner, address spender) external view returns (uint256);
7   function transfer(address to, uint256 value) external returns (bool);
8   function approve(address spender, uint256 value) external returns (bool);
9   function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
10   function transferFrom(address from, address to, uint256 value) external returns (bool);
11 
12   event Transfer(address indexed from, address indexed to, uint256 value);
13   event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 interface ApproveAndCallFallBack {
17     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
18 }
19 
20 
21 contract KICKBACK is ERC20 {
22   using SafeMath for uint256;
23 
24   mapping (address => uint256) private balances;
25   mapping (address => mapping (address => uint256)) private allowed;
26   string public constant name  = "Kickback";
27   string public constant symbol = "KICK";
28   uint8 public constant decimals = 18;
29   
30   address owner = msg.sender;
31 
32   uint256 _totalSupply = 1000000000000 * (10 ** 18); // 1 trillion supply
33 
34   constructor() public {
35     balances[msg.sender] = _totalSupply;
36     emit Transfer(address(0), msg.sender, _totalSupply);
37   }
38 
39   function totalSupply() public view returns (uint256) {
40     return _totalSupply;
41   }
42 
43   function balanceOf(address player) public view returns (uint256) {
44     return balances[player];
45   }
46 
47   function allowance(address player, address spender) public view returns (uint256) {
48     return allowed[player][spender];
49   }
50 
51 
52   function transfer(address to, uint256 value) public returns (bool) {
53     require(value <= balances[msg.sender]);
54     require(to != address(0));
55 
56     balances[msg.sender] = balances[msg.sender].sub(value);
57     balances[to] = balances[to].add(value);
58 
59     emit Transfer(msg.sender, to, value);
60     return true;
61   }
62 
63   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
64     for (uint256 i = 0; i < receivers.length; i++) {
65       transfer(receivers[i], amounts[i]);
66     }
67   }
68 
69   function approve(address spender, uint256 value) public returns (bool) {
70     require(spender != address(0));
71     allowed[msg.sender][spender] = value;
72     emit Approval(msg.sender, spender, value);
73     return true;
74   }
75 
76   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
77         allowed[msg.sender][spender] = tokens;
78         emit Approval(msg.sender, spender, tokens);
79         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
80         return true;
81     }
82 
83   function transferFrom(address from, address to, uint256 value) public returns (bool) {
84     require(value <= balances[from]);
85     require(value <= allowed[from][msg.sender]);
86     require(to != address(0));
87     
88     balances[from] = balances[from].sub(value);
89     balances[to] = balances[to].add(value);
90     
91     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
92     
93     emit Transfer(from, to, value);
94     return true;
95   }
96 
97   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
98     require(spender != address(0));
99     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
100     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
101     return true;
102   }
103 
104   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
105     require(spender != address(0));
106     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
107     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
108     return true;
109   }
110 
111   function burn(uint256 amount) external {
112     require(amount != 0);
113     require(amount <= balances[msg.sender]);
114     _totalSupply = _totalSupply.sub(amount);
115     balances[msg.sender] = balances[msg.sender].sub(amount);
116     emit Transfer(msg.sender, address(0), amount);
117   }
118 
119 }
120 
121 
122 
123 
124 library SafeMath {
125   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126     if (a == 0) {
127       return 0;
128     }
129     uint256 c = a * b;
130     require(c / a == b);
131     return c;
132   }
133 
134   function div(uint256 a, uint256 b) internal pure returns (uint256) {
135     uint256 c = a / b;
136     return c;
137   }
138 
139   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140     require(b <= a);
141     return a - b;
142   }
143 
144   function add(uint256 a, uint256 b) internal pure returns (uint256) {
145     uint256 c = a + b;
146     require(c >= a);
147     return c;
148   }
149 
150   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
151     uint256 c = add(a,m);
152     uint256 d = sub(c,1);
153     return mul(div(d,m),m);
154   }
155 }