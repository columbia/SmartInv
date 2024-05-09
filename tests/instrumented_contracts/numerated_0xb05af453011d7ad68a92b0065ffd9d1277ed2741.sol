1 // https://team.finance
2 
3 pragma solidity ^0.4.25;
4 
5 interface ERC20 {
6   function totalSupply() external view returns (uint256);
7   function balanceOf(address who) external view returns (uint256);
8   function allowance(address owner, address spender) external view returns (uint256);
9   function transfer(address to, uint256 value) external returns (bool);
10   function approve(address spender, uint256 value) external returns (bool);
11   function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
12   function transferFrom(address from, address to, uint256 value) external returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 interface ApproveAndCallFallBack {
18     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
19 }
20 
21 
22 contract Team is ERC20 {
23   using SafeMath for uint256;
24 
25   mapping (address => uint256) private balances;
26   mapping (address => mapping (address => uint256)) private allowed;
27   string public constant name  = "Team";
28   string public constant symbol = "TEAM";
29   uint8 public constant decimals = 18;
30 
31   address owner = msg.sender;
32 
33   uint256 _totalSupply = (10 ** 6) * (10 ** 18); // 1 million TEAM token supply
34 
35   constructor() public {
36     balances[msg.sender] = _totalSupply;
37     emit Transfer(address(0), msg.sender, _totalSupply);
38   }
39 
40   function totalSupply() public view returns (uint256) {
41     return _totalSupply;
42   }
43 
44   function balanceOf(address player) public view returns (uint256) {
45     return balances[player];
46   }
47 
48   function allowance(address player, address spender) public view returns (uint256) {
49     return allowed[player][spender];
50   }
51 
52 
53   function transfer(address to, uint256 value) public returns (bool) {
54     require(value <= balances[msg.sender]);
55     require(to != address(0));
56 
57     balances[msg.sender] = balances[msg.sender].sub(value);
58     balances[to] = balances[to].add(value);
59 
60     emit Transfer(msg.sender, to, value);
61     return true;
62   }
63 
64   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
65     for (uint256 i = 0; i < receivers.length; i++) {
66       transfer(receivers[i], amounts[i]);
67     }
68   }
69 
70   function approve(address spender, uint256 value) public returns (bool) {
71     require(spender != address(0));
72     allowed[msg.sender][spender] = value;
73     emit Approval(msg.sender, spender, value);
74     return true;
75   }
76 
77   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
78         allowed[msg.sender][spender] = tokens;
79         emit Approval(msg.sender, spender, tokens);
80         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
81         return true;
82     }
83 
84   function transferFrom(address from, address to, uint256 value) public returns (bool) {
85     require(value <= balances[from]);
86     require(value <= allowed[from][msg.sender]);
87     require(to != address(0));
88 
89     balances[from] = balances[from].sub(value);
90     balances[to] = balances[to].add(value);
91 
92     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
93 
94     emit Transfer(from, to, value);
95     return true;
96   }
97 
98 
99 }
100 
101 
102 
103 
104 library SafeMath {
105   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106     if (a == 0) {
107       return 0;
108     }
109     uint256 c = a * b;
110     require(c / a == b);
111     return c;
112   }
113 
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     uint256 c = a / b;
116     return c;
117   }
118 
119   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120     require(b <= a);
121     return a - b;
122   }
123 
124   function add(uint256 a, uint256 b) internal pure returns (uint256) {
125     uint256 c = a + b;
126     require(c >= a);
127     return c;
128   }
129 
130   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
131     uint256 c = add(a,m);
132     uint256 d = sub(c,1);
133     return mul(div(d,m),m);
134   }
135 }