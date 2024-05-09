1 pragma solidity ^0.4.22;
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
61 contract Ownable {
62 
63     // public variables
64     address public owner;
65 
66     // internal variables
67 
68     // events
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     // public functions
72     constructor() public {
73         owner = msg.sender;
74     }
75 
76     modifier onlyOwner() {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87     // internal functions
88 }
89 
90 contract StandardToken is ERC20, BasicToken {
91   // public variables
92 
93   // internal variables
94   mapping (address => mapping (address => uint256)) _allowances;
95 
96   // events
97 
98   // public functions
99   function transferFrom(address from, address to, uint256 value) public returns (bool) {
100     require(to != address(0));
101     require(value <= _balances[from]);
102     require(value <= _allowances[from][msg.sender]);
103 
104     _balances[from] = _balances[from].sub(value);
105     _balances[to] = _balances[to].add(value);
106     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
107     emit Transfer(from, to, value);
108     return true;
109   }
110 
111   function approve(address agent, uint256 value) public returns (bool) {
112     _allowances[msg.sender][agent] = value;
113     emit Approval(msg.sender, agent, value);
114     return true;
115   }
116 
117   function allowance(address owner, address agent) public view returns (uint256) {
118     return _allowances[owner][agent];
119   }
120 
121   function increaseApproval(address agent, uint value) public returns (bool) {
122     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
123     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
124     return true;
125   }
126 
127   function decreaseApproval(address agent, uint value) public returns (bool) {
128     uint allowanceValue = _allowances[msg.sender][agent];
129     if (value > allowanceValue) {
130       _allowances[msg.sender][agent] = 0;
131     } else {
132       _allowances[msg.sender][agent] = allowanceValue.sub(value);
133     }
134     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
135     return true;
136   }
137 
138   // internal functions
139 }
140 
141 
142 contract MPToken is StandardToken {
143     // public variables
144     string public name = "Mobile Phone Ad Chain";
145     string public symbol = "MP";
146     uint8 public decimals = 8;
147 
148     constructor() public {
149       _totalSupply = 20000000000 * (10 ** uint256(decimals));
150 
151       _balances[msg.sender] = _totalSupply;
152       emit Transfer(0x0, msg.sender, _totalSupply);
153     }
154 }
155 
156 library SafeMath {
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158       if (a == 0) {
159         return 0;
160       }
161       uint256 c = a * b;
162       assert(c / a == b);
163       return c;
164     }
165 
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167       // assert(b > 0); // Solidity automatically throws when dividing by 0
168       uint256 c = a / b;
169       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
170       return c;
171     }
172 
173     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174       assert(b <= a);
175       return a - b;
176     }
177 
178     function add(uint256 a, uint256 b) internal pure returns (uint256) {
179       uint256 c = a + b;
180       assert(c >= a);
181       return c;
182     }
183 }