1 pragma solidity ^0.4.23;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     if (a == 0) {
5       return 0;
6     }
7     uint256 c = a * b;
8     assert(c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 
32 contract ERC20Basic {
33   // events
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 
36   // public functions
37   function totalSupply() public view returns (uint256);
38   function balanceOf(address addr) public view returns (uint256);
39   function transfer(address to, uint256 value) public returns (bool);
40 }
41 
42 
43 contract ERC20 is ERC20Basic {
44   // events
45   event Approval(address indexed owner, address indexed agent, uint256 value);
46 
47   // public functions
48   function allowance(address owner, address agent) public view returns (uint256);
49   function transferFrom(address from, address to, uint256 value) public returns (bool);
50   function approve(address agent, uint256 value) public returns (bool);
51 
52 }
53 
54 
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57 
58   // public variables
59   string public name;
60   string public symbol;
61   uint8 public decimals = 18;
62 
63   // internal variables
64   uint256 _totalSupply;
65   mapping(address => uint256) _balances;
66 
67   // events
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
87 }
88 
89 
90 contract StandardToken is ERC20, BasicToken {
91 
92   mapping (address => mapping (address => uint256)) _allowances;
93   function transferFrom(address from, address to, uint256 value) public returns (bool) {
94     require(to != address(0));
95     require(value <= _balances[from]);
96     require(value <= _allowances[from][msg.sender]);
97 
98     _balances[from] = _balances[from].sub(value);
99     _balances[to] = _balances[to].add(value);
100     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
101     emit Transfer(from, to, value);
102     return true;
103   }
104 
105   function approve(address agent, uint256 value) public returns (bool) {
106     _allowances[msg.sender][agent] = value;
107     emit Approval(msg.sender, agent, value);
108     return true;
109   }
110 
111   function allowance(address owner, address agent) public view returns (uint256) {
112     return _allowances[owner][agent];
113   }
114 
115   function increaseApproval(address agent, uint value) public returns (bool) {
116     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
117     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
118     return true;
119   }
120 
121   function decreaseApproval(address agent, uint value) public returns (bool) {
122     uint allowanceValue = _allowances[msg.sender][agent];
123     if (value > allowanceValue) {
124       _allowances[msg.sender][agent] = 0;
125     } else {
126       _allowances[msg.sender][agent] = allowanceValue.sub(value);
127     }
128     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
129     return true;
130   }
131 }
132 
133 
134 contract SPPTToken is StandardToken {
135   string public name = "SpicyPot";
136   string public symbol = "SPPT";
137   uint8 public decimals = 18;
138  constructor() public {
139     _totalSupply = 1000000000 * (10 ** uint256(decimals));
140 
141     _balances[msg.sender] = _totalSupply;
142     emit Transfer(0x0, msg.sender, _totalSupply);
143   }
144 
145 }