1 /**
2  *Submitted for verification at Etherscan.io on 2023-05-19
3 */
4 
5 pragma solidity ^0.4.25;
6 
7 interface ERC20 {
8   function totalSupply() external view returns (uint256);
9   function balanceOf(address who) external view returns (uint256);
10   function allowance(address owner, address spender) external view returns (uint256);
11   function transfer(address to, uint256 value) external returns (bool);
12   function approve(address spender, uint256 value) external returns (bool);
13   function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
14   function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16   event Transfer(address indexed from, address indexed to, uint256 value);
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 interface ApproveAndCallFallBack {
21     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
22 }
23 
24 
25 contract hope is ERC20 {
26   using SafeMath for uint256;
27 
28   mapping (address => uint256) private balances;
29   mapping (address => mapping (address => uint256)) private allowed;
30   string public constant name  = "hope";
31   string public constant symbol = "hope";
32   uint8 public constant decimals = 18;
33   
34   address owner = msg.sender;
35 
36   uint256 _totalSupply = 369369369369369 * (10 ** 18); 
37 
38   constructor() public {
39     balances[msg.sender] = _totalSupply;
40     emit Transfer(address(0), msg.sender, _totalSupply);
41   }
42 
43   function totalSupply() public view returns (uint256) {
44     return _totalSupply;
45   }
46 
47   function balanceOf(address player) public view returns (uint256) {
48     return balances[player];
49   }
50 
51   function allowance(address player, address spender) public view returns (uint256) {
52     return allowed[player][spender];
53   }
54 
55 
56   function transfer(address to, uint256 value) public returns (bool) {
57     require(value <= balances[msg.sender]);
58     require(to != address(0));
59 
60     balances[msg.sender] = balances[msg.sender].sub(value);
61     balances[to] = balances[to].add(value);
62 
63     emit Transfer(msg.sender, to, value);
64     return true;
65   }
66 
67   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
68     for (uint256 i = 0; i < receivers.length; i++) {
69       transfer(receivers[i], amounts[i]);
70     }
71   }
72 
73   function approve(address spender, uint256 value) public returns (bool) {
74     require(spender != address(0));
75     allowed[msg.sender][spender] = value;
76     emit Approval(msg.sender, spender, value);
77     return true;
78   }
79 
80   function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
81         allowed[msg.sender][spender] = tokens;
82         emit Approval(msg.sender, spender, tokens);
83         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
84         return true;
85     }
86 
87   function transferFrom(address from, address to, uint256 value) public returns (bool) {
88     require(value <= balances[from]);
89     require(value <= allowed[from][msg.sender]);
90     require(to != address(0));
91     
92     balances[from] = balances[from].sub(value);
93     balances[to] = balances[to].add(value);
94     
95     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
96     
97     emit Transfer(from, to, value);
98     return true;
99   }
100 
101   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
102     require(spender != address(0));
103     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
104     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
105     return true;
106   }
107 
108   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
109     require(spender != address(0));
110     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
111     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
112     return true;
113   }
114 
115   function burn(uint256 amount) external {
116     require(amount != 0);
117     require(amount <= balances[msg.sender]);
118     _totalSupply = _totalSupply.sub(amount);
119     balances[msg.sender] = balances[msg.sender].sub(amount);
120     emit Transfer(msg.sender, address(0), amount);
121   }
122 
123 }
124 
125 
126 
127 
128 library SafeMath {
129   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130     if (a == 0) {
131       return 0;
132     }
133     uint256 c = a * b;
134     require(c / a == b);
135     return c;
136   }
137 
138   function div(uint256 a, uint256 b) internal pure returns (uint256) {
139     uint256 c = a / b;
140     return c;
141   }
142 
143   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144     require(b <= a);
145     return a - b;
146   }
147 
148   function add(uint256 a, uint256 b) internal pure returns (uint256) {
149     uint256 c = a + b;
150     require(c >= a);
151     return c;
152   }
153 
154   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
155     uint256 c = add(a,m);
156     uint256 d = sub(c,1);
157     return mul(div(d,m),m);
158   }
159 }