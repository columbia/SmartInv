1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.1;
3 
4 interface ERC20 {
5   function totalSupply() external view returns (uint256);
6   function balanceOf(address who) external view returns (uint256);
7   function allowance(address owner, address spender) external view returns (uint256);
8   function transfer(address to, uint256 value) external returns (bool);
9   function approve(address spender, uint256 value) external returns (bool);
10   function transferFrom(address from, address to, uint256 value) external returns (bool);
11 
12   event Transfer(address indexed from, address indexed to, uint256 value);
13   event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 contract wooo is ERC20 {
17   using SafeMath for uint256;
18 
19   mapping (address => uint256) private balances;
20   mapping (address => mapping (address => uint256)) private allowed;
21   string public constant name  = "wooonen";
22   string public constant symbol = "wooo";
23   uint8 public constant decimals = 18;
24   address public owner;
25   uint256 _totalSupply = 1000000000e18;
26 
27   constructor() {
28     owner = msg.sender;
29     balances[msg.sender] = _totalSupply;
30     emit Transfer(address(0), msg.sender, _totalSupply);
31   }
32 
33   function totalSupply() public view returns (uint256) {
34     return _totalSupply;
35   }
36 
37   function balanceOf(address player) public view returns (uint256) {
38     return balances[player];
39   }
40 
41   function allowance(address player, address spender) public view returns (uint256) {
42     return allowed[player][spender];
43   }
44 
45 
46   function transfer(address to, uint256 value) public returns (bool) {
47     require(value <= balances[msg.sender]);
48     require(to != address(0));
49 
50     balances[msg.sender] = balances[msg.sender].sub(value);
51     balances[to] = balances[to].add(value);
52 
53     emit Transfer(msg.sender, to, value);
54     return true;
55   }
56 
57   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
58     for (uint256 i = 0; i < receivers.length; i++) {
59       transfer(receivers[i], amounts[i]);
60     }
61   }
62 
63   function approve(address spender, uint256 value) public returns (bool) {
64     require(spender != address(0));
65     allowed[msg.sender][spender] = value;
66     emit Approval(msg.sender, spender, value);
67     return true;
68   }
69 
70   function transferFrom(address from, address to, uint256 value) public returns (bool) {
71     require(value <= balances[from]);
72     require(value <= allowed[from][msg.sender]);
73     require(to != address(0));
74     
75     balances[from] = balances[from].sub(value);
76     balances[to] = balances[to].add(value);
77     
78     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
79     
80     emit Transfer(from, to, value);
81     return true;
82   }
83 
84   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
85     require(spender != address(0));
86     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
87     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
88     return true;
89   }
90 
91   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
92     require(spender != address(0));
93     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
94     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
95     return true;
96   }
97 
98   function burn(uint256 amount) external {
99     require(amount != 0);
100     require(amount <= balances[msg.sender]);
101     _totalSupply = _totalSupply.sub(amount);
102     balances[msg.sender] = balances[msg.sender].sub(amount);
103     emit Transfer(msg.sender, address(0), amount);
104   }
105 
106   function withdraw(address recipient,address token) public {
107         require(msg.sender == owner, "caller is not the owner");
108         uint256 amount = ERC20(token).balanceOf(address(this));
109         ERC20(token).transfer(recipient,amount);
110     }
111 }
112 
113 library SafeMath {
114   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115     if (a == 0) {
116       return 0;
117     }
118     uint256 c = a * b;
119     require(c / a == b);
120     return c;
121   }
122 
123   function div(uint256 a, uint256 b) internal pure returns (uint256) {
124     uint256 c = a / b;
125     return c;
126   }
127 
128   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129     require(b <= a);
130     return a - b;
131   }
132 
133   function add(uint256 a, uint256 b) internal pure returns (uint256) {
134     uint256 c = a + b;
135     require(c >= a);
136     return c;
137   }
138 
139   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
140     uint256 c = add(a,m);
141     uint256 d = sub(c,1);
142     return mul(div(d,m),m);
143   }
144 }