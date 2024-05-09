1 pragma solidity ^0.4.23;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 contract ERC20Basic {
35   // events
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 
38   // public functions
39   function totalSupply() public view returns (uint256);
40   function balanceOf(address addr) public view returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42 }
43 
44 
45 contract ERC20 is ERC20Basic {
46   // events
47   event Approval(address indexed owner, address indexed agent, uint256 value);
48 
49   // public functions
50   function allowance(address owner, address agent) public view returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address agent, uint256 value) public returns (bool);
53 
54 }
55 
56 
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   // public variables
61   string public name;
62   string public symbol;
63   uint8 public decimals = 18;
64 
65   // internal variables
66   uint256 _totalSupply;
67   mapping(address => uint256) _balances;
68 
69   // public functions
70   function totalSupply() public view returns (uint256) {
71     return _totalSupply;
72   }
73 
74   function balanceOf(address addr) public view returns (uint256 balance) {
75     return _balances[addr];
76   }
77 
78   function transfer(address to, uint256 value) public returns (bool) {
79     require(to != address(0));
80     require(value <= _balances[msg.sender]);
81 
82     _balances[msg.sender] = _balances[msg.sender].sub(value);
83     _balances[to] = _balances[to].add(value);
84     emit Transfer(msg.sender, to, value);
85     return true;
86   }
87 
88 
89 }
90 
91 
92 contract StandardToken is ERC20, BasicToken {
93 
94   mapping (address => mapping (address => uint256)) _allowances;
95 
96   function transferFrom(address from, address to, uint256 value) public returns (bool) {
97     require(to != address(0));
98     require(value <= _balances[from]);
99     require(value <= _allowances[from][msg.sender]);
100 
101     _balances[from] = _balances[from].sub(value);
102     _balances[to] = _balances[to].add(value);
103     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
104     emit Transfer(from, to, value);
105     return true;
106   }
107 
108   function approve(address agent, uint256 value) public returns (bool) {
109     _allowances[msg.sender][agent] = value;
110     emit Approval(msg.sender, agent, value);
111     return true;
112   }
113 
114   function allowance(address owner, address agent) public view returns (uint256) {
115     return _allowances[owner][agent];
116   }
117 
118   function increaseApproval(address agent, uint value) public returns (bool) {
119     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
120     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
121     return true;
122   }
123 
124   function decreaseApproval(address agent, uint value) public returns (bool) {
125     uint allowanceValue = _allowances[msg.sender][agent];
126     if (value > allowanceValue) {
127       _allowances[msg.sender][agent] = 0;
128     } else {
129       _allowances[msg.sender][agent] = allowanceValue.sub(value);
130     }
131     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
132     return true;
133   }
134   // internal functions
135 }
136 
137 
138 contract XTrust is StandardToken {
139   // public variables
140   string public name = "XTrust";
141   string public symbol = "XT";
142   uint8 public decimals = 18;
143 
144   // public functions
145   constructor() public {
146     //init _totalSupply
147     _totalSupply = 100000000000 * (10 ** uint256(decimals));
148 
149     _balances[msg.sender] = _totalSupply;
150     emit Transfer(0x0, msg.sender, _totalSupply);
151   }
152 
153 
154   // internal functions
155 }