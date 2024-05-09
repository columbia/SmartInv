1 pragma solidity ^0.4.23;
2 
3 
4 //import "./ERC20.sol";
5 //import "./ERC20Basic.sol";
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 contract BasicToken  {
37   using SafeMath for uint256;
38 
39   // public variables
40   string public name;
41   string public symbol;
42   uint8 public decimals = 18;
43 
44   // internal variables
45   uint256 _totalSupply;
46   mapping(address => uint256) _balances;
47   event Transfer(address indexed from, address indexed to, uint256 value);
48   // events
49 
50   // public functions
51   function totalSupply() public view returns (uint256) {
52     return _totalSupply;
53   }
54 
55   function balanceOf(address addr) public view returns (uint256 balance) {
56     return _balances[addr];
57   }
58 
59   function transfer(address to, uint256 value) public returns (bool) {
60     require(to != address(0));
61     require(value <= _balances[msg.sender]);
62 
63     _balances[msg.sender] = _balances[msg.sender].sub(value);
64     _balances[to] = _balances[to].add(value);
65     emit Transfer(msg.sender, to, value);
66     return true;
67   }
68 
69   // internal functions
70 
71 }
72 
73 contract StandardToken is BasicToken {
74   // public variables
75 
76   // internal variables
77   mapping (address => mapping (address => uint256)) _allowances;
78   event Approval(address indexed owner, address indexed agent, uint256 value);
79 
80   // events
81 
82   // public functions
83   function transferFrom(address from, address to, uint256 value) public returns (bool) {
84     require(to != address(0));
85     require(value <= _balances[from]);
86     require(value <= _allowances[from][msg.sender]);
87 
88     _balances[from] = _balances[from].sub(value);
89     _balances[to] = _balances[to].add(value);
90     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
91     emit Transfer(from, to, value);
92     return true;
93   }
94 
95   function approve(address agent, uint256 value) public returns (bool) {
96     _allowances[msg.sender][agent] = value;
97     emit Approval(msg.sender, agent, value);
98     return true;
99   }
100 
101   function allowance(address owner, address agent) public view returns (uint256) {
102     return _allowances[owner][agent];
103   }
104 
105   function increaseApproval(address agent, uint value) public returns (bool) {
106     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
107     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
108     return true;
109   }
110 
111   function decreaseApproval(address agent, uint value) public returns (bool) {
112     uint allowanceValue = _allowances[msg.sender][agent];
113     if (value > allowanceValue) {
114       _allowances[msg.sender][agent] = 0;
115     } else {
116       _allowances[msg.sender][agent] = allowanceValue.sub(value);
117     }
118     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
119     return true;
120   }
121   // internal functions
122 }
123 
124 
125 contract DACCToken is StandardToken {
126   // public variables
127   string public name = "Decentralized Accessible Content Chain";
128   string public symbol = "DACC";
129   uint8 public decimals = 6;
130 
131   // internal variables
132 
133   // events
134 
135   // public functions
136   constructor() public {
137     //init _totalSupply
138     _totalSupply = 30 * (10 ** 9) * (10 ** uint256(decimals));
139 
140     _balances[msg.sender] = _totalSupply;
141     emit Transfer(0x0, msg.sender, _totalSupply);
142   }
143 
144 
145   // internal functions
146 }