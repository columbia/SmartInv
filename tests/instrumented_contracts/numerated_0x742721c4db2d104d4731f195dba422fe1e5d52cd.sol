1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4   // events
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 
7   // public functions
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address addr) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11 }
12 
13 contract BasicToken is ERC20Basic {
14   using SafeMath for uint256;
15 
16   // public variables
17   string public name;
18   string public symbol;
19   uint8 public decimals = 18;
20 
21   // internal variables
22   uint256 _totalSupply;
23   mapping(address => uint256) _balances;
24 
25   // events
26 
27   // public functions
28   function totalSupply() public view returns (uint256) {
29     return _totalSupply;
30   }
31 
32   function balanceOf(address addr) public view returns (uint256 balance) {
33     return _balances[addr];
34   }
35 
36   function transfer(address to, uint256 value) public returns (bool) {
37     require(to != address(0));
38     require(value <= _balances[msg.sender]);
39 
40     _balances[msg.sender] = _balances[msg.sender].sub(value);
41     _balances[to] = _balances[to].add(value);
42     emit Transfer(msg.sender, to, value);
43     return true;
44   }
45 
46   // internal functions
47 
48 }
49 
50 contract ERC20 is ERC20Basic {
51   // events
52   event Approval(address indexed owner, address indexed agent, uint256 value);
53 
54   // public functions
55   function allowance(address owner, address agent) public view returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address agent, uint256 value) public returns (bool);
58 
59 }
60 
61 contract StandardToken is ERC20, BasicToken {
62   // public variables
63 
64   // internal variables
65   mapping (address => mapping (address => uint256)) _allowances;
66 
67   // events
68 
69   // public functions
70   function transferFrom(address from, address to, uint256 value) public returns (bool) {
71     require(to != address(0));
72     require(value <= _balances[from]);
73     require(value <= _allowances[from][msg.sender]);
74 
75     _balances[from] = _balances[from].sub(value);
76     _balances[to] = _balances[to].add(value);
77     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
78     emit Transfer(from, to, value);
79     return true;
80   }
81 
82   function approve(address agent, uint256 value) public returns (bool) {
83     _allowances[msg.sender][agent] = value;
84     emit Approval(msg.sender, agent, value);
85     return true;
86   }
87 
88   function allowance(address owner, address agent) public view returns (uint256) {
89     return _allowances[owner][agent];
90   }
91 
92   function increaseApproval(address agent, uint value) public returns (bool) {
93     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
94     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
95     return true;
96   }
97 
98   function decreaseApproval(address agent, uint value) public returns (bool) {
99     uint allowanceValue = _allowances[msg.sender][agent];
100     if (value > allowanceValue) {
101       _allowances[msg.sender][agent] = 0;
102     } else {
103       _allowances[msg.sender][agent] = allowanceValue.sub(value);
104     }
105     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
106     return true;
107   }
108   // internal functions
109 }
110 
111 library SafeMath {
112   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113     if (a == 0) {
114       return 0;
115     }
116     uint256 c = a * b;
117     assert(c / a == b);
118     return c;
119   }
120 
121   function div(uint256 a, uint256 b) internal pure returns (uint256) {
122     // assert(b > 0); // Solidity automatically throws when dividing by 0
123     uint256 c = a / b;
124     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125     return c;
126   }
127 
128   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129     assert(b <= a);
130     return a - b;
131   }
132 
133   function add(uint256 a, uint256 b) internal pure returns (uint256) {
134     uint256 c = a + b;
135     assert(c >= a);
136     return c;
137   }
138 }
139 
140 contract DetailedToken is StandardToken {
141   // public variables
142   string public name = "Demo Coin Token";
143   string public symbol = "DEMO";
144   uint8 public decimals = 18;
145 
146   // public functions
147   constructor (
148     string tokenName,
149     string tokenSymbol,
150     uint8 tokenDecimals,
151     uint256 tokenTotal,
152     address owner
153   ) public {
154     name = tokenName;
155     symbol = tokenSymbol;
156     decimals = tokenDecimals;
157 
158     _totalSupply = tokenTotal * (10 ** uint256(decimals));
159     _balances[owner] = _totalSupply;
160     emit Transfer(0x0, owner, _totalSupply);
161   }
162 }
163 
164 contract TokenManager {
165   mapping (address => address) public tokens;
166 
167   function createToken (
168     string tokenName,
169     string tokenSymbol,
170     uint8 tokenDecimals,
171     uint256 tokenTotal,
172     address owner
173   ) public returns (address token) {
174 
175     if (tokens[owner] == 0) {
176       tokens[owner] = new DetailedToken(tokenName, tokenSymbol, tokenDecimals, tokenTotal, owner);
177     }
178     return tokens[owner];
179   }
180 }