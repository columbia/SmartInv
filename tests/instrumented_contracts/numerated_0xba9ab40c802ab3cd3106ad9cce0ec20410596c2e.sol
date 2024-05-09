1 pragma solidity ^0.5.8;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5     function approve(address spender, uint256 value) external returns (bool);
6     function transferFrom(address from, address to, uint256 value) external returns (bool);
7     function totalSupply() external view returns (uint256);
8     function balanceOf(address who) external view returns (uint256);
9     function allowance(address owner, address spender) external view returns (uint256);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 library SafeMath {
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b > 0);
27         uint256 c = a / b;
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b <= a);
33         uint256 c = a - b;
34         return c;
35     }
36 
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a);
40         return c;
41     }
42 
43     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b != 0);
45         return a % b;
46     }
47 }
48 
49 contract ERC20 is IERC20 {
50     using SafeMath for uint256;
51 
52     mapping (address => uint256) private _balances;
53     mapping (address => mapping (address => uint256)) private _allowed;
54 
55     uint256 private _totalSupply;
56 
57     function totalSupply() public view returns (uint256) {
58         return _totalSupply;
59     }
60 
61     function balanceOf(address owner) public view returns (uint256) {
62         return _balances[owner];
63     }
64 
65     function allowance(address owner, address spender) public view returns (uint256) {
66         return _allowed[owner][spender];
67     }
68 
69     function transfer(address to, uint256 value) public returns (bool) {
70         _transfer(msg.sender, to, value);
71         return true;
72     }
73 
74     function approve(address spender, uint256 value) public returns (bool) {
75         _approve(msg.sender, spender, value);
76         return true;
77     }
78 
79     function transferFrom(address from, address to, uint256 value) public returns (bool) {
80         _transfer(from, to, value);
81         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
82         return true;
83     }
84 
85     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
86         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
87         return true;
88     }
89 
90     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
91         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
92         return true;
93     }
94 
95     function _transfer(address from, address to, uint256 value) internal {
96         require(to != address(0));
97 
98         _balances[from] = _balances[from].sub(value);
99         _balances[to] = _balances[to].add(value);
100         emit Transfer(from, to, value);
101     }
102 
103     function _mint(address account, uint256 value) internal {
104         require(account != address(0));
105 
106         _totalSupply = _totalSupply.add(value);
107         _balances[account] = _balances[account].add(value);
108         emit Transfer(address(0), account, value);
109     }
110 
111     function _burn(address account, uint256 value) internal {
112         require(account != address(0));
113 
114         _totalSupply = _totalSupply.sub(value);
115         _balances[account] = _balances[account].sub(value);
116         emit Transfer(account, address(0), value);
117     }
118 
119     function _approve(address owner, address spender, uint256 value) internal {
120         require(spender != address(0));
121         require(owner != address(0));
122 
123         _allowed[owner][spender] = value;
124         emit Approval(owner, spender, value);
125     }
126 
127     function _burnFrom(address account, uint256 value) internal {
128         _burn(account, value);
129         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
130     }
131 }
132 
133 contract ERC20Detailed is IERC20 {
134     string private _name;
135     string private _symbol;
136     uint8 private _decimals;
137 
138     constructor (string memory name, string memory symbol, uint8 decimals) public {
139         _name = name;
140         _symbol = symbol;
141         _decimals = decimals;
142     }
143 
144     function name() public view returns (string memory) {
145         return _name;
146     }
147 
148     function symbol() public view returns (string memory) {
149         return _symbol;
150     }
151 
152     function decimals() public view returns (uint8) {
153         return _decimals;
154     }
155 }
156 
157 contract TeiyoCoin is ERC20, ERC20Detailed {
158     uint8 public constant DECIMALS = 18;
159 	uint256 public constant INITIAL_SUPPLY = 1000 * 10000 * 10000 * (10 ** uint256(DECIMALS));
160 
161     constructor()
162 	    ERC20Detailed("Teiyo Coin", "TYC", DECIMALS)
163 		public
164 	{
165         _mint(msg.sender, INITIAL_SUPPLY);
166     }
167 }