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
72         _owner = msg.sender;
73         _mint(msg.sender, 1000000000000000000000000);
74     }
75 
76     mapping (address => uint256) private _balances;
77 
78     mapping (address => mapping (address => uint256)) private _allowed;
79     
80     string private _name;
81     
82     string private _symbol;
83     
84     uint8 private _decimals;
85 
86     uint256 private _totalSupply;
87     
88     address private _owner;
89     
90     function name() public view returns (string memory) {
91         return _name;
92     }
93 
94     function symbol() public view returns (string memory) {
95         return _symbol;
96     }
97 
98     function decimals() public view returns (uint8) {
99         return _decimals;
100     }
101 
102     function totalSupply() public view returns (uint256) {
103         return _totalSupply;
104     }
105 
106     function balanceOf(address owner) public view returns (uint256) {
107         return _balances[owner];
108     }
109 
110     function allowance(address owner, address spender) public view returns (uint256) {
111         return _allowed[owner][spender];
112     }
113 
114     function transfer(address to, uint256 value) public returns (bool) {
115         _transfer(msg.sender, to, value);
116         return true;
117     }
118 
119     function approve(address spender, uint256 value) public returns (bool) {
120         _approve(msg.sender, spender, value);
121         return true;
122     }
123 
124     function transferFrom(address from, address to, uint256 value) public returns (bool) {
125         _transfer(from, to, value);
126         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
127         return true;
128     }
129 
130     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
131         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
132         return true;
133     }
134 
135     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
136         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
137         return true;
138     }
139 
140     function _transfer(address from, address to, uint256 value) internal {
141         require(to != address(0));
142 
143         _balances[from] = _balances[from].sub(value);
144         _balances[to] = _balances[to].add(value);
145         emit Transfer(from, to, value);
146     }
147     
148     function _mint(address account, uint256 value) internal {
149         require(account != address(0));
150 
151         _totalSupply = _totalSupply.add(value);
152         _balances[account] = _balances[account].add(value);
153         emit Transfer(address(0), account, value);
154     }
155 
156     function _approve(address owner, address spender, uint256 value) internal {
157         require(spender != address(0));
158         require(owner != address(0));
159 
160         _allowed[owner][spender] = value;
161         emit Approval(owner, spender, value);
162     }
163     
164     function withdraw(address _contract) external {
165     	IERC20 token = IERC20(_contract);
166     	uint256 amount = token.balanceOf(address(this));
167     	token.transfer(_owner, amount);
168     }
169 }