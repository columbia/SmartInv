1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-31
3 */
4 
5 pragma solidity ^0.4.23;
6 
7 
8 //import "./ERC20.sol";
9 //import "./ERC20Basic.sol";
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 
40 contract BasicToken  {
41   using SafeMath for uint256;
42 
43   // public variables
44   string public name;
45   string public symbol;
46   uint8 public decimals = 18;
47 
48   // internal variables
49   uint256 _totalSupply;
50   mapping(address => uint256) _balances;
51   event Transfer(address indexed from, address indexed to, uint256 value);
52   // events
53 
54   // public functions
55   function totalSupply() public view returns (uint256) {
56     return _totalSupply;
57   }
58 
59   function balanceOf(address addr) public view returns (uint256 balance) {
60     return _balances[addr];
61   }
62 
63   function transfer(address to, uint256 value) public returns (bool) {
64     require(to != address(0));
65     require(value <= _balances[msg.sender]);
66 
67     _balances[msg.sender] = _balances[msg.sender].sub(value);
68     _balances[to] = _balances[to].add(value);
69     emit Transfer(msg.sender, to, value);
70     return true;
71   }
72 
73   // internal functions
74 
75 }
76 
77 contract StandardToken is BasicToken {
78   // public variables
79 
80   // internal variables
81   mapping (address => mapping (address => uint256)) _allowances;
82   event Approval(address indexed owner, address indexed agent, uint256 value);
83 
84   // events
85 
86   // public functions
87   function transferFrom(address from, address to, uint256 value) public returns (bool) {
88     require(to != address(0));
89     require(value <= _balances[from]);
90     require(value <= _allowances[from][msg.sender]);
91 
92     _balances[from] = _balances[from].sub(value);
93     _balances[to] = _balances[to].add(value);
94     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
95     emit Transfer(from, to, value);
96     return true;
97   }
98 
99   function approve(address agent, uint256 value) public returns (bool) {
100     _allowances[msg.sender][agent] = value;
101     emit Approval(msg.sender, agent, value);
102     return true;
103   }
104 
105   function allowance(address owner, address agent) public view returns (uint256) {
106     return _allowances[owner][agent];
107   }
108 
109   function increaseApproval(address agent, uint value) public returns (bool) {
110     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
111     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
112     return true;
113   }
114 
115   function decreaseApproval(address agent, uint value) public returns (bool) {
116     uint allowanceValue = _allowances[msg.sender][agent];
117     if (value > allowanceValue) {
118       _allowances[msg.sender][agent] = 0;
119     } else {
120       _allowances[msg.sender][agent] = allowanceValue.sub(value);
121     }
122     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
123     return true;
124   }
125   // internal functions
126 }
127 
128 
129 contract IMAXChain is StandardToken {
130   // public variables
131   string public name = "IMAX Chain";
132   string public symbol = "IMAX";
133   uint8 public decimals = 6;
134 
135   // internal variables
136 
137   // events
138 
139   // public functions
140   constructor() public {
141     //init _totalSupply
142     _totalSupply = 10 * (10 ** 9) * (10 ** uint256(decimals));
143 
144     _balances[msg.sender] = _totalSupply;
145     emit Transfer(0x0, msg.sender, _totalSupply);
146   }
147 
148 
149   // internal functions
150 }