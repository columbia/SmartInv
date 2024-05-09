1 /**
2 
3 https://t.me/ShibaInuErc20
4 
5 */
6 
7 pragma solidity ^0.4.25;
8 
9 interface ERC20 {
10   function totalSupply() external view returns (uint256);
11   function balanceOf(address who) external view returns (uint256);
12   function allowance(address owner, address spender) external view returns (uint256);
13   function transfer(address to, uint256 value) external returns (bool);
14   function approve(address spender, uint256 value) external returns (bool);
15   function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
16   function transferFrom(address from, address to, uint256 value) external returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 interface ApproveAndCallFallBack {
22     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
23 }
24 
25 
26 contract SHIBA_INU is ERC20 {
27   using SafeMath for uint256;
28 
29   mapping (address => uint256) private balances;
30   mapping (address => mapping (address => uint256)) private allowed;
31   string public constant name  = "SHIBA INU";
32   string public constant symbol = "SHIBA";
33   uint8 public constant decimals = 18;
34   
35   address owner = msg.sender;
36 
37   uint256 _totalSupply = 1000000000000 * (10 ** 18); 
38 
39   constructor() public {
40     balances[msg.sender] = _totalSupply;
41     emit Transfer(address(0), msg.sender, _totalSupply);
42   }
43 
44   function totalSupply() public view returns (uint256) {
45     return _totalSupply;
46   }
47 
48   function balanceOf(address player) public view returns (uint256) {
49     return balances[player];
50   }
51 
52   function allowance(address player, address spender) public view returns (uint256) {
53     return allowed[player][spender];
54   }
55 
56 
57   function transfer(address to, uint256 value) public returns (bool) {
58     require(value <= balances[msg.sender]);
59     require(to != address(0));
60 
61     balances[msg.sender] = balances[msg.sender].sub(value);
62     balances[to] = balances[to].add(value);
63 
64     emit Transfer(msg.sender, to, value);
65     return true;
66   }
67 
68   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
69     for (uint256 i = 0; i < receivers.length; i++) {
70       transfer(receivers[i], amounts[i]);
71     }
72   }
73 
74   function approve(address spender, uint256 value) public returns (bool) {
75     require(spender != address(0));
76     allowed[msg.sender][spender] = value;
77     emit Approval(msg.sender, spender, value);
78     return true;
79   }
80 
81   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
82         allowed[msg.sender][spender] = tokens;
83         emit Approval(msg.sender, spender, tokens);
84         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
85         return true;
86     }
87 
88   function transferFrom(address from, address to, uint256 value) public returns (bool) {
89     require(value <= balances[from]);
90     require(value <= allowed[from][msg.sender]);
91     require(to != address(0));
92     
93     balances[from] = balances[from].sub(value);
94     balances[to] = balances[to].add(value);
95     
96     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
97     
98     emit Transfer(from, to, value);
99     return true;
100   }
101 
102   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
103     require(spender != address(0));
104     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
105     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
106     return true;
107   }
108 
109   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
110     require(spender != address(0));
111     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
112     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
113     return true;
114   }
115 
116   function burn(uint256 amount) external {
117     require(amount != 0);
118     require(amount <= balances[msg.sender]);
119     _totalSupply = _totalSupply.sub(amount);
120     balances[msg.sender] = balances[msg.sender].sub(amount);
121     emit Transfer(msg.sender, address(0), amount);
122   }
123 
124 }
125 
126 
127 
128 
129 library SafeMath {
130   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
131     if (a == 0) {
132       return 0;
133     }
134     uint256 c = a * b;
135     require(c / a == b);
136     return c;
137   }
138 
139   function div(uint256 a, uint256 b) internal pure returns (uint256) {
140     uint256 c = a / b;
141     return c;
142   }
143 
144   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145     require(b <= a);
146     return a - b;
147   }
148 
149   function add(uint256 a, uint256 b) internal pure returns (uint256) {
150     uint256 c = a + b;
151     require(c >= a);
152     return c;
153   }
154 
155   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
156     uint256 c = add(a,m);
157     uint256 d = sub(c,1);
158     return mul(div(d,m),m);
159   }
160 }