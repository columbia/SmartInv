1 /**
2 
3 >>Chasing the Fool's Gold again, anon?
4 >>So predictable.
5 >>When will you learn, anon?
6 >>The game is rigged against you.
7 >>Wins are temporary.
8 >>Losses are forever.
9 >>You were never meant to make it.
10 >>...unless...?
11 
12 */
13 
14 // SPDX-License-Identifier: Unlicensed
15 
16 pragma solidity ^0.8.19;
17 
18 interface ERC20 {
19   function totalSupply() external view returns (uint256);
20   function balanceOf(address who) external view returns (uint256);
21   function allowance(address owner, address spender) external view returns (uint256);
22   function transfer(address to, uint256 value) external returns (bool);
23   function approve(address spender, uint256 value) external returns (bool);
24   function approveAndCall(address spender, uint tokens, bytes calldata data) external returns (bool success);
25   function transferFrom(address from, address to, uint256 value) external returns (bool);
26 
27   event Transfer(address indexed from, address indexed to, uint256 value);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 interface ApproveAndCallFallBack {
32     function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external;
33 }
34 
35 // >>Unless you receive an invite.
36 // >>Everything else is pyrite.
37 // >>You must mine until you hit the bottom.
38 
39 contract AFG is ERC20 {
40   using SafeMath for uint256;
41 
42   mapping (address => uint256) private balances;
43   mapping (address => mapping (address => uint256)) private allowed;
44   string public constant name  = "A Fools Gold";
45   string public constant symbol = "PYRITE";
46   uint8 public constant decimals = 18;
47   
48   address owner = msg.sender;
49 
50   uint256 _totalSupply = 10_000 * (10 ** 18); // 10k, you know why
51 
52   constructor() {
53     balances[msg.sender] = _totalSupply;
54     emit Transfer(address(0), msg.sender, _totalSupply);
55   }
56 
57   function totalSupply() public view returns (uint256) {
58     return _totalSupply;
59   }
60 
61   function balanceOf(address player) public view returns (uint256) {
62     return balances[player];
63   }
64 
65   function allowance(address player, address spender) public view returns (uint256) {
66     return allowed[player][spender];
67   }
68 
69 
70   function transfer(address to, uint256 value) public returns (bool) {
71     require(value <= balances[msg.sender]);
72     require(to != address(0));
73 
74     balances[msg.sender] = balances[msg.sender].sub(value);
75     balances[to] = balances[to].add(value);
76 
77     emit Transfer(msg.sender, to, value);
78     return true;
79   }
80 
81   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
82     for (uint256 i = 0; i < receivers.length; i++) {
83       transfer(receivers[i], amounts[i]);
84     }
85   }
86 
87   function approve(address spender, uint256 value) public returns (bool) {
88     require(spender != address(0));
89     allowed[msg.sender][spender] = value;
90     emit Approval(msg.sender, spender, value);
91     return true;
92   }
93 
94   function approveAndCall(address spender, uint256 tokens, bytes calldata data) external returns (bool) {
95         allowed[msg.sender][spender] = tokens;
96         emit Approval(msg.sender, spender, tokens);
97         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
98         return true;
99     }
100 
101   function transferFrom(address from, address to, uint256 value) public returns (bool) {
102     require(value <= balances[from]);
103     require(value <= allowed[from][msg.sender]);
104     require(to != address(0));
105     
106     balances[from] = balances[from].sub(value);
107     balances[to] = balances[to].add(value);
108     
109     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
110     
111     emit Transfer(from, to, value);
112     return true;
113   }
114 
115   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
116     require(spender != address(0));
117     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
118     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
119     return true;
120   }
121 
122   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
123     require(spender != address(0));
124     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
125     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
126     return true;
127   }
128 
129   function burn(uint256 amount) external {
130     require(amount != 0);
131     require(amount <= balances[msg.sender]);
132     _totalSupply = _totalSupply.sub(amount);
133     balances[msg.sender] = balances[msg.sender].sub(amount);
134     emit Transfer(msg.sender, address(0), amount);
135   }
136 
137 }
138 
139 library SafeMath {
140   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141     if (a == 0) {
142       return 0;
143     }
144     uint256 c = a * b;
145     require(c / a == b);
146     return c;
147   }
148 
149   function div(uint256 a, uint256 b) internal pure returns (uint256) {
150     uint256 c = a / b;
151     return c;
152   }
153 
154   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155     require(b <= a);
156     return a - b;
157   }
158 
159   function add(uint256 a, uint256 b) internal pure returns (uint256) {
160     uint256 c = a + b;
161     require(c >= a);
162     return c;
163   }
164 
165   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
166     uint256 c = add(a,m);
167     uint256 d = sub(c,1);
168     return mul(div(d,m),m);
169   }
170 }
171 
172 // >>A ponderous man sits in a field.
173 // >>He doesn't know who he is
174 // >>He doesn't ask how he came to be
175 // >>He believes in the thunderheads that encircle him
176 // >>The lightning becomes his enlightening
177 // >>Suddenly, a flash!
178 
179 // >>https://afoolsgold.xyz/aletter
180 // >>Save the date.