1 pragma solidity ^0.5.0;
2 
3 /**
4  * 
5  * https://squirrel.finance
6  * 
7  */
8 
9 interface ERC20 {
10   function totalSupply() external view returns (uint256);
11   function balanceOf(address who) external view returns (uint256);
12   function allowance(address owner, address spender) external view returns (uint256);
13   function transfer(address to, uint256 value) external returns (bool);
14   function approve(address spender, uint256 value) external returns (bool);
15   function approveAndCall(address spender, uint tokens, bytes calldata data) external returns (bool success);
16   function transferFrom(address from, address to, uint256 value) external returns (bool);
17 
18   event Transfer(address indexed from, address indexed to, uint256 value);
19   event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 interface ApproveAndCallFallBack {
23     function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external;
24 }
25 
26 contract NUTS is ERC20 {
27     using SafeMath for uint256;
28     
29     mapping (address => uint256) private balances;
30     mapping (address => mapping (address => uint256)) private allowed;
31     string public constant name  = "Squirrel Finance";
32     string public constant symbol = "NUTS";
33     uint8 public constant decimals = 18;
34 
35     uint256 totalNuts = 1000000 * (10 ** 18);
36     address public currentGovernance;
37     
38     constructor() public {
39         balances[msg.sender] = totalNuts;
40         currentGovernance = msg.sender;
41         emit Transfer(address(0), msg.sender, totalNuts);
42     }
43     
44     function totalSupply() public view returns (uint256) {
45         return totalNuts;
46     }
47 
48     function balanceOf(address player) public view returns (uint256) {
49         return balances[player];
50     }
51 
52     function allowance(address player, address spender) public view returns (uint256) {
53         return allowed[player][spender];
54     }
55     
56     function transfer(address to, uint256 value) public returns (bool) {
57         require(value <= balances[msg.sender]);
58         require(to != address(0));
59     
60         balances[msg.sender] = balances[msg.sender].sub(value);
61         balances[to] = balances[to].add(value);
62     
63         emit Transfer(msg.sender, to, value);
64         return true;
65     }
66 
67     function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
68         for (uint256 i = 0; i < receivers.length; i++) {
69             transfer(receivers[i], amounts[i]);
70         }
71     }
72     
73     function approve(address spender, uint256 value) public returns (bool) {
74         require(spender != address(0));
75         allowed[msg.sender][spender] = value;
76         emit Approval(msg.sender, spender, value);
77         return true;
78     }
79 
80     function approveAndCall(address spender, uint256 tokens, bytes calldata data) external returns (bool) {
81         allowed[msg.sender][spender] = tokens;
82         emit Approval(msg.sender, spender, tokens);
83         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
84         return true;
85     }
86 
87     function transferFrom(address from, address to, uint256 value) public returns (bool) {
88         require(value <= balances[from]);
89         require(value <= allowed[from][msg.sender]);
90         require(to != address(0));
91         
92         balances[from] = balances[from].sub(value);
93         balances[to] = balances[to].add(value);
94         
95         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
96         
97         emit Transfer(from, to, value);
98         return true;
99     }
100     
101     function updateGovernance(address newGovernance) external {
102         require(msg.sender == currentGovernance);
103         currentGovernance = newGovernance;
104     }
105     
106     function mint(uint256 amount, address recipient) external {
107         require(msg.sender == currentGovernance);
108         balances[recipient] = balances[recipient].add(amount);
109         totalNuts = totalNuts.add(amount);
110         emit Transfer(address(0), recipient, amount);
111     }
112     
113     function burn(uint256 amount) external {
114         require(amount != 0);
115         require(amount <= balances[msg.sender]);
116         totalNuts = totalNuts.sub(amount);
117         balances[msg.sender] = balances[msg.sender].sub(amount);
118         emit Transfer(msg.sender, address(0), amount);
119     }
120 }
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