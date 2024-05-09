1 // Telegram: https://t.me/BurnVaultFinance
2 // Website: BurnVault.finance
3 
4 
5 //Disclaimer:This a social experiment, Please do not invest more than you are comfortable with losing.
6 
7 
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
20 
21   event Transfer(address indexed from, address indexed to, uint256 value);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 interface ApproveAndCallFallBack {
26     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
27 }
28 
29 
30 contract BVF is ERC20 {
31   using SafeMath for uint256;
32 
33   mapping (address => uint256) private balances;
34   mapping (address => mapping (address => uint256)) private allowed;
35   string public constant name  = "Burn Vault";
36   string public constant symbol = "BVF";
37   uint8 public constant decimals = 18;
38   
39   address owner = msg.sender;
40 
41   uint256 _totalSupply = 13000 * (10 ** 18); 
42 
43   constructor() public {
44     balances[msg.sender] = _totalSupply;
45     emit Transfer(address(0), msg.sender, _totalSupply);
46   }
47 
48   function totalSupply() public view returns (uint256) {
49     return _totalSupply;
50   }
51 
52   function balanceOf(address player) public view returns (uint256) {
53     return balances[player];
54   }
55 
56   function allowance(address player, address spender) public view returns (uint256) {
57     return allowed[player][spender];
58   }
59 
60 
61   function transfer(address to, uint256 value) public returns (bool) {
62     require(value <= balances[msg.sender]);
63     require(to != address(0));
64 
65     balances[msg.sender] = balances[msg.sender].sub(value);
66     balances[to] = balances[to].add(value);
67 
68     emit Transfer(msg.sender, to, value);
69     return true;
70   }
71 
72   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
73     for (uint256 i = 0; i < receivers.length; i++) {
74       transfer(receivers[i], amounts[i]);
75     }
76   }
77 
78   function approve(address spender, uint256 value) public returns (bool) {
79     require(spender != address(0));
80     allowed[msg.sender][spender] = value;
81     emit Approval(msg.sender, spender, value);
82     return true;
83   }
84 
85   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
86         allowed[msg.sender][spender] = tokens;
87         emit Approval(msg.sender, spender, tokens);
88         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
89         return true;
90     }
91 
92   function transferFrom(address from, address to, uint256 value) public returns (bool) {
93     require(value <= balances[from]);
94     require(value <= allowed[from][msg.sender]);
95     require(to != address(0));
96     
97     balances[from] = balances[from].sub(value);
98     balances[to] = balances[to].add(value);
99     
100     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
101     
102     emit Transfer(from, to, value);
103     return true;
104   }
105 
106   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
107     require(spender != address(0));
108     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
109     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
110     return true;
111   }
112 
113   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
114     require(spender != address(0));
115     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
116     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
117     return true;
118   }
119 
120   function burn(uint256 amount) external {
121     require(amount != 0);
122     require(amount <= balances[msg.sender]);
123     _totalSupply = _totalSupply.sub(amount);
124     balances[msg.sender] = balances[msg.sender].sub(amount);
125     emit Transfer(msg.sender, address(0), amount);
126   }
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