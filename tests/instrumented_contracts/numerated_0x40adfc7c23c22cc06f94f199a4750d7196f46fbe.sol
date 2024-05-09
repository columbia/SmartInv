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
34 contract BasicToken  {
35   using SafeMath for uint256;
36 
37   // public variables
38   string public name;
39   string public symbol;
40   uint8 public decimals = 18;
41 
42   // internal variables
43   uint256 _totalSupply;
44   mapping(address => uint256) _balances;
45   event Transfer(address indexed from, address indexed to, uint256 value);
46   // events
47 
48   // public functions
49   function totalSupply() public view returns (uint256) {
50     return _totalSupply;
51   }
52 
53   function balanceOf(address addr) public view returns (uint256 balance) {
54     return _balances[addr];
55   }
56 
57   function transfer(address to, uint256 value) public returns (bool) {
58     require(to != address(0));
59     require(value <= _balances[msg.sender]);
60 
61     _balances[msg.sender] = _balances[msg.sender].sub(value);
62     _balances[to] = _balances[to].add(value);
63     emit Transfer(msg.sender, to, value);
64     return true;
65   }
66 
67   // internal functions
68 
69 }
70 
71 contract StandardToken is BasicToken {
72   // public variables
73 
74   // internal variables
75   mapping (address => mapping (address => uint256)) _allowances;
76   event Approval(address indexed owner, address indexed agent, uint256 value);
77 
78   // events
79 
80   // public functions
81   function transferFrom(address from, address to, uint256 value) public returns (bool) {
82     require(to != address(0));
83     require(value <= _balances[from]);
84     require(value <= _allowances[from][msg.sender]);
85 
86     _balances[from] = _balances[from].sub(value);
87     _balances[to] = _balances[to].add(value);
88     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
89     emit Transfer(from, to, value);
90     return true;
91   }
92 
93   function approve(address agent, uint256 value) public returns (bool) {
94     _allowances[msg.sender][agent] = value;
95     emit Approval(msg.sender, agent, value);
96     return true;
97   }
98 
99   function allowance(address owner, address agent) public view returns (uint256) {
100     return _allowances[owner][agent];
101   }
102 
103   function increaseApproval(address agent, uint value) public returns (bool) {
104     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
105     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
106     return true;
107   }
108 
109   function decreaseApproval(address agent, uint value) public returns (bool) {
110     uint allowanceValue = _allowances[msg.sender][agent];
111     if (value > allowanceValue) {
112       _allowances[msg.sender][agent] = 0;
113     } else {
114       _allowances[msg.sender][agent] = allowanceValue.sub(value);
115     }
116     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
117     return true;
118   }
119   // internal functions
120 }
121 
122 
123 contract CoinchaseToken is StandardToken {
124   // public variables
125   string public name = "Coinchase Token";
126   string public symbol = "CCH";
127   uint8 public decimals = 6;
128 
129   // internal variables
130 
131   // events
132 
133   // public functions
134   constructor() public {
135     //init _totalSupply
136     _totalSupply = 10 * (10 ** 9) * (10 ** uint256(decimals));
137 
138     _balances[msg.sender] = _totalSupply;
139     emit Transfer(0x0, msg.sender, _totalSupply);
140   }
141 
142 
143   // internal functions
144 }