1 pragma solidity >=0.4.22 <0.6.0;
2 
3 
4 interface IERC20 {
5     function transfer(address to, uint256 value) external returns (bool);
6 
7     function approve(address spender, uint256 value) external returns (bool);
8 
9     function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address who) external view returns (uint256);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 
23 library SafeMath {
24 
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29 
30         uint256 c = a * b;
31         require(c / a == b);
32 
33         return c;
34     }
35 
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b > 0);
38         uint256 c = a / b;
39 
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b <= a);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 
64 contract ERC20 is IERC20 {
65     using SafeMath for uint256;
66 
67     constructor (string memory name, string memory symbol, uint8 decimals) public {
68         _name = name;
69         _symbol = symbol;
70         _decimals = decimals;
71         
72         _balances[msg.sender] = _totalSupply;
73     }
74 
75     mapping (address => uint256) private _balances;
76 
77     mapping (address => mapping (address => uint256)) private _allowed;
78     
79     string private _name;
80     
81     string private _symbol;
82     
83     uint8 private _decimals;
84 
85     uint256 private _totalSupply = 1000000 * 10 ** uint256(_decimals);
86     
87     function name() public view returns (string memory) {
88         return _name;
89     }
90 
91     function symbol() public view returns (string memory) {
92         return _symbol;
93     }
94 
95     function decimals() public view returns (uint8) {
96         return _decimals;
97     }
98 
99     function totalSupply() public view returns (uint256) {
100         return _totalSupply;
101     }
102 
103     function balanceOf(address owner) public view returns (uint256) {
104         return _balances[owner];
105     }
106 
107     function allowance(address owner, address spender) public view returns (uint256) {
108         return _allowed[owner][spender];
109     }
110 
111     function transfer(address to, uint256 value) public returns (bool) {
112         _transfer(msg.sender, to, value);
113         return true;
114     }
115 
116     function approve(address spender, uint256 value) public returns (bool) {
117         _approve(msg.sender, spender, value);
118         return true;
119     }
120 
121     function transferFrom(address from, address to, uint256 value) public returns (bool) {
122         _transfer(from, to, value);
123         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
124         return true;
125     }
126 
127     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
128         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
129         return true;
130     }
131 
132     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
133         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
134         return true;
135     }
136 
137     function _transfer(address from, address to, uint256 value) internal {
138         require(to != address(0));
139 
140         _balances[from] = _balances[from].sub(value);
141         _balances[to] = _balances[to].add(value);
142         emit Transfer(from, to, value);
143     }
144 
145     function _approve(address owner, address spender, uint256 value) internal {
146         require(spender != address(0));
147         require(owner != address(0));
148 
149         _allowed[owner][spender] = value;
150         emit Approval(owner, spender, value);
151     }
152 }