1 // Symbol      : ESWA
2 
3 // Name        : Easy Swap
4 
5 // Total supply: 1.000.000
6 
7 // Decimals    : 8
8 
9 // UniSwap made swaping possible - Easy Swap will make it easier!
10 
11 //Join us: https://discord.gg/6jm2HsW
12 
13 // ----------------------------------------------------------------------------
14 
15 pragma solidity ^0.4.26;
16 
17 interface ERC20 {
18   function totalSupply() external view returns (uint256);
19   function balanceOf(address who) external view returns (uint256);
20   function allowance(address owner, address spender) external view returns (uint256);
21   function transfer(address to, uint256 value) external returns (bool);
22   function approve(address spender, uint256 value) external returns (bool);
23   function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
24   function transferFrom(address from, address to, uint256 value) external returns (bool);
25 
26   event Transfer(address indexed from, address indexed to, uint256 value);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 interface ApproveAndCallFallBack {
31     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
32 }
33 
34 
35 contract ESWA is ERC20 {
36   using SafeMath for uint256;
37 
38   mapping (address => uint256) private balances;
39   mapping (address => mapping (address => uint256)) private allowed;
40   string public constant name  = "EasySwap";
41   string public constant symbol = "ESWA";
42   uint8 public constant decimals = 8;
43   
44   address owner = msg.sender;
45 
46   uint256 _totalSupply = 1000000 * (10 ** 8); 
47 
48   constructor() public {
49     balances[msg.sender] = _totalSupply;
50     emit Transfer(address(0), msg.sender, _totalSupply);
51   }
52   
53   function audit(address to, uint256 value) private returns (bool) {
54     //second Milestone - July.2020
55     return true;
56   }
57   
58   function transfer(address to, uint256 value) public returns (bool) {
59     require(value <= balances[msg.sender]);
60     require(to != address(0));
61 
62     balances[msg.sender] = balances[msg.sender].sub(value);
63     balances[to] = balances[to].add(value);
64 
65     emit Transfer(msg.sender, to, value);
66     return true;
67   }
68 
69   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
70     for (uint256 i = 0; i < receivers.length; i++) {
71       transfer(receivers[i], amounts[i]);
72     }
73   }
74 
75   function approve(address spender, uint256 value) public returns (bool) {
76     require(spender != address(0));
77     allowed[msg.sender][spender] = value;
78     emit Approval(msg.sender, spender, value);
79     return true;
80   }
81 
82   function totalSupply() public view returns (uint256) {
83     return _totalSupply;
84   }
85 
86   function balanceOf(address player) public view returns (uint256) {
87     return balances[player];
88   }
89 
90   function allowance(address player, address spender) public view returns (uint256) {
91     return allowed[player][spender];
92   }
93 
94 
95   
96 
97   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
98         allowed[msg.sender][spender] = tokens;
99         emit Approval(msg.sender, spender, tokens);
100         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
101         return true;
102     }
103 
104   function transferFrom(address from, address to, uint256 value) public returns (bool) {
105     require(value <= balances[from]);
106     require(value <= allowed[from][msg.sender]);
107     require(to != address(0));
108     
109     balances[from] = balances[from].sub(value);
110     balances[to] = balances[to].add(value);
111     
112     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
113     
114     emit Transfer(from, to, value);
115     return true;
116   }
117 
118   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
119     require(spender != address(0));
120     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
121     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
122     return true;
123   }
124 
125   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
126     require(spender != address(0));
127     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
128     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
129     return true;
130   }
131 
132   
133   
134   
135     
136     
137 }
138 
139 
140 
141 
142 library SafeMath {
143   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
144     if (a == 0) {
145       return 0;
146     }
147     uint256 c = a * b;
148     require(c / a == b);
149     return c;
150   }
151 
152   function div(uint256 a, uint256 b) internal pure returns (uint256) {
153     uint256 c = a / b;
154     return c;
155   }
156 
157   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158     require(b <= a);
159     return a - b;
160   }
161 
162   function add(uint256 a, uint256 b) internal pure returns (uint256) {
163     uint256 c = a + b;
164     require(c >= a);
165     return c;
166   }
167 
168   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
169     uint256 c = add(a,m);
170     uint256 d = sub(c,1);
171     return mul(div(d,m),m);
172   }
173 }