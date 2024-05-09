1 //IMSWallet
2 //Single Platform for Crypto Trading and Community Interactions
3 
4 pragma solidity ^0.4.25;
5 
6 interface ERC20 {
7   function totalSupply() external view returns (uint256);
8   function balanceOf(address who) external view returns (uint256);
9   function allowance(address owner, address spender) external view returns (uint256);
10   function transfer(address to, uint256 value) external returns (bool);
11   function approve(address spender, uint256 value) external returns (bool);
12   function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
13   function transferFrom(address from, address to, uint256 value) external returns (bool);
14 
15   event Transfer(address indexed from, address indexed to, uint256 value);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 interface ApproveAndCallFallBack {
20     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
21 }
22 
23 
24 contract IMSWallet is ERC20 {
25   using SafeMath for uint256;
26 
27   mapping (address => uint256) private balances;
28   mapping (address => mapping (address => uint256)) private allowed;
29   string public constant name  = "IMSWallet";
30   string public constant symbol = "IMS";
31   uint8 public constant decimals = 18;
32 
33   address owner = msg.sender;
34 
35   uint256 _totalSupply = (30000000) * (10 ** 18); // 30 million supply
36 
37   constructor() public {
38     balances[msg.sender] = _totalSupply;
39     emit Transfer(address(0), msg.sender, _totalSupply);
40   }
41 
42   function totalSupply() public view returns (uint256) {
43     return _totalSupply;
44   }
45 
46   function balanceOf(address holder) public view returns (uint256) {
47     return balances[holder];
48   }
49 
50   function allowance(address holder, address spender) public view returns (uint256) {
51     return allowed[holder][spender];
52   }
53 
54 
55   function transfer(address to, uint256 value) public returns (bool) {
56     require(value <= balances[msg.sender]);
57     require(to != address(0));
58 
59     balances[msg.sender] = balances[msg.sender].sub(value);
60     balances[to] = balances[to].add(value);
61 
62     emit Transfer(msg.sender, to, value);
63     return true;
64   }
65 
66   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
67     for (uint256 i = 0; i < receivers.length; i++) {
68       transfer(receivers[i], amounts[i]);
69     }
70   }
71 
72   function approve(address spender, uint256 value) public returns (bool) {
73     require(spender != address(0));
74     allowed[msg.sender][spender] = value;
75     emit Approval(msg.sender, spender, value);
76     return true;
77   }
78 
79   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
80         allowed[msg.sender][spender] = tokens;
81         emit Approval(msg.sender, spender, tokens);
82         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
83         return true;
84     }
85 
86   function transferFrom(address from, address to, uint256 value) public returns (bool) {
87     require(value <= balances[from]);
88     require(value <= allowed[from][msg.sender]);
89     require(to != address(0));
90 
91     balances[from] = balances[from].sub(value);
92     balances[to] = balances[to].add(value);
93 
94     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
95 
96     emit Transfer(from, to, value);
97     return true;
98   }
99 
100   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
101     require(spender != address(0));
102     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
103     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
104     return true;
105   }
106 
107   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
108     require(spender != address(0));
109     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
110     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
111     return true;
112   }
113 
114   function burn(uint256 amount) external {
115     require(amount != 0);
116     require(amount <= balances[msg.sender]);
117     _totalSupply = _totalSupply.sub(amount);
118     balances[msg.sender] = balances[msg.sender].sub(amount);
119     emit Transfer(msg.sender, address(0), amount);
120   }
121 
122 }
123 
124 
125 
126 
127 library SafeMath {
128   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
129     if (a == 0) {
130       return 0;
131     }
132     uint256 c = a * b;
133     require(c / a == b);
134     return c;
135   }
136 
137   function div(uint256 a, uint256 b) internal pure returns (uint256) {
138     uint256 c = a / b;
139     return c;
140   }
141 
142   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143     require(b <= a);
144     return a - b;
145   }
146 
147   function add(uint256 a, uint256 b) internal pure returns (uint256) {
148     uint256 c = a + b;
149     require(c >= a);
150     return c;
151   }
152 
153   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
154     uint256 c = add(a,m);
155     uint256 d = sub(c,1);
156     return mul(div(d,m),m);
157   }
158 }