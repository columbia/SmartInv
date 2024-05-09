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
69   // events
70 
71   // public functions
72   function totalSupply() public view returns (uint256) {
73     return _totalSupply;
74   }
75 
76   function balanceOf(address addr) public view returns (uint256 balance) {
77     return _balances[addr];
78   }
79 
80   function transfer(address to, uint256 value) public returns (bool) {
81     require(to != address(0));
82     require(value <= _balances[msg.sender]);
83 
84     _balances[msg.sender] = _balances[msg.sender].sub(value);
85     _balances[to] = _balances[to].add(value);
86     emit Transfer(msg.sender, to, value);
87     return true;
88   }
89 
90   // internal functions
91 
92 }
93 
94 
95 contract StandardToken is ERC20, BasicToken {
96   // public variables
97 
98   // internal variables
99   mapping (address => mapping (address => uint256)) _allowances;
100 
101   // events
102 
103   // public functions
104   function transferFrom(address from, address to, uint256 value) public returns (bool) {
105     require(to != address(0));
106     require(value <= _balances[from]);
107     require(value <= _allowances[from][msg.sender]);
108 
109     _balances[from] = _balances[from].sub(value);
110     _balances[to] = _balances[to].add(value);
111     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
112     emit Transfer(from, to, value);
113     return true;
114   }
115 
116   function approve(address agent, uint256 value) public returns (bool) {
117     _allowances[msg.sender][agent] = value;
118     emit Approval(msg.sender, agent, value);
119     return true;
120   }
121 
122   function allowance(address owner, address agent) public view returns (uint256) {
123     return _allowances[owner][agent];
124   }
125 
126   function increaseApproval(address agent, uint value) public returns (bool) {
127     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
128     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
129     return true;
130   }
131 
132   function decreaseApproval(address agent, uint value) public returns (bool) {
133     uint allowanceValue = _allowances[msg.sender][agent];
134     if (value > allowanceValue) {
135       _allowances[msg.sender][agent] = 0;
136     } else {
137       _allowances[msg.sender][agent] = allowanceValue.sub(value);
138     }
139     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
140     return true;
141   }
142   // internal functions
143 }
144 
145 
146 contract BSSToken is StandardToken {
147   // public variables
148   string public name = "BitStar";
149   string public symbol = "BSS";
150   uint8 public decimals = 8;
151 
152   // internal variables
153 
154   // events
155 
156   // public functions
157   constructor() public {
158     //init _totalSupply
159     _totalSupply = 200000000 * (10 ** uint256(decimals));
160 
161     _balances[msg.sender] = _totalSupply;
162     emit Transfer(0x0, msg.sender, _totalSupply);
163   }
164 
165 
166   // internal functions
167 }