1 //testing some uniswap V3 functionality, DO NOT INTERACT WITH THIS COIN!!!!
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
13 
14   event Transfer(address indexed from, address indexed to, uint256 value);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 interface ApproveAndCallFallBack {
19     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
20 }
21 
22 
23 contract DNB is ERC20 {
24   using SafeMath for uint256;
25 
26   mapping (address => uint256) private balances;
27   mapping (address => mapping (address => uint256)) private allowed;
28   string public constant name  = "DO NOT BUY";
29   string public constant symbol = "DNB";
30   uint8 public constant decimals = 18;
31   
32   address owner = msg.sender;
33 
34   uint256 _totalSupply = 1000000000 * (10 ** 18); 
35 
36   constructor() public {
37     balances[msg.sender] = _totalSupply;
38     emit Transfer(address(0), msg.sender, _totalSupply);
39   }
40 
41   function totalSupply() public view returns (uint256) {
42     return _totalSupply;
43   }
44 
45   function balanceOf(address player) public view returns (uint256) {
46     return balances[player];
47   }
48 
49   function allowance(address player, address spender) public view returns (uint256) {
50     return allowed[player][spender];
51   }
52 
53 
54   function transfer(address to, uint256 value) public returns (bool) {
55     require(value <= balances[msg.sender]);
56     require(to != address(0));
57 
58     balances[msg.sender] = balances[msg.sender].sub(value);
59     balances[to] = balances[to].add(value);
60 
61     emit Transfer(msg.sender, to, value);
62     return true;
63   }
64 
65   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
66     for (uint256 i = 0; i < receivers.length; i++) {
67       transfer(receivers[i], amounts[i]);
68     }
69   }
70 
71   function approve(address spender, uint256 value) public returns (bool) {
72     require(spender != address(0));
73     allowed[msg.sender][spender] = value;
74     emit Approval(msg.sender, spender, value);
75     return true;
76   }
77 
78   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
79         allowed[msg.sender][spender] = tokens;
80         emit Approval(msg.sender, spender, tokens);
81         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
82         return true;
83     }
84 
85   function transferFrom(address from, address to, uint256 value) public returns (bool) {
86     require(value <= balances[from]);
87     require(value <= allowed[from][msg.sender]);
88     require(to != address(0));
89     
90     balances[from] = balances[from].sub(value);
91     balances[to] = balances[to].add(value);
92     
93     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
94     
95     emit Transfer(from, to, value);
96     return true;
97   }
98 
99   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
100     require(spender != address(0));
101     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
102     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
103     return true;
104   }
105 
106   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
107     require(spender != address(0));
108     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
109     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
110     return true;
111   }
112 
113   function burn(uint256 amount) external {
114     require(amount != 0);
115     require(amount <= balances[msg.sender]);
116     _totalSupply = _totalSupply.sub(amount);
117     balances[msg.sender] = balances[msg.sender].sub(amount);
118     emit Transfer(msg.sender, address(0), amount);
119   }
120 
121 }
122 
123 
124 
125 
126 library SafeMath {
127   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128     if (a == 0) {
129       return 0;
130     }
131     uint256 c = a * b;
132     require(c / a == b);
133     return c;
134   }
135 
136   function div(uint256 a, uint256 b) internal pure returns (uint256) {
137     uint256 c = a / b;
138     return c;
139   }
140 
141   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142     require(b <= a);
143     return a - b;
144   }
145 
146   function add(uint256 a, uint256 b) internal pure returns (uint256) {
147     uint256 c = a + b;
148     require(c >= a);
149     return c;
150   }
151 
152   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
153     uint256 c = add(a,m);
154     uint256 d = sub(c,1);
155     return mul(div(d,m),m);
156   }
157 }