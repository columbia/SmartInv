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
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     require(c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a / b;
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     require(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     require(c >= a);
43     return c;
44   }
45 
46   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
47     uint256 c = add(a,m);
48     uint256 d = sub(c,1);
49     return mul(div(d,m),m);
50   }
51 }
52 
53 
54 contract IBK is ERC20 {
55   using SafeMath for uint256;
56 
57   mapping (address => uint256) private balances;
58   mapping (address => mapping (address => uint256)) private allowed;
59   string public constant name  = "Investigate Blue Kirby";
60   string public constant symbol = "IBK";
61   uint8 public constant decimals = 18;
62   
63   address owner = msg.sender;
64 
65   uint256 _totalSupply = 30000 * (10 ** 18); 
66 
67   constructor() public {
68     balances[msg.sender] = _totalSupply;
69     emit Transfer(address(0), msg.sender, _totalSupply);
70   }
71 
72   function totalSupply() public view returns (uint256) {
73     return _totalSupply;
74   }
75 
76   function balanceOf(address player) public view returns (uint256) {
77     return balances[player];
78   }
79 
80   function allowance(address player, address spender) public view returns (uint256) {
81     return allowed[player][spender];
82   }
83 
84 
85   function transfer(address to, uint256 value) public returns (bool) {
86     require(value <= balances[msg.sender]);
87     require(to != address(0));
88 
89     balances[msg.sender] = balances[msg.sender].sub(value);
90     balances[to] = balances[to].add(value);
91 
92     emit Transfer(msg.sender, to, value);
93     return true;
94   }
95 
96   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
97     for (uint256 i = 0; i < receivers.length; i++) {
98       transfer(receivers[i], amounts[i]);
99     }
100   }
101 
102   function approve(address spender, uint256 value) public returns (bool) {
103     require(spender != address(0));
104     allowed[msg.sender][spender] = value;
105     emit Approval(msg.sender, spender, value);
106     return true;
107   }
108 
109   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
110         allowed[msg.sender][spender] = tokens;
111         emit Approval(msg.sender, spender, tokens);
112         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
113         return true;
114     }
115 
116   function transferFrom(address from, address to, uint256 value) public returns (bool) {
117     require(value <= balances[from]);
118     require(value <= allowed[from][msg.sender]);
119     require(to != address(0));
120     
121     balances[from] = balances[from].sub(value);
122     balances[to] = balances[to].add(value);
123     
124     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
125     
126     emit Transfer(from, to, value);
127     return true;
128   }
129 
130   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
131     require(spender != address(0));
132     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
133     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
134     return true;
135   }
136 
137   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
138     require(spender != address(0));
139     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
140     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
141     return true;
142   }
143 
144   function burn(uint256 amount) external {
145     require(amount != 0);
146     require(amount <= balances[msg.sender]);
147     _totalSupply = _totalSupply.sub(amount);
148     balances[msg.sender] = balances[msg.sender].sub(amount);
149     emit Transfer(msg.sender, address(0), amount);
150   }
151 }