1 pragma solidity ^0.5.2;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b);
29 
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b > 0);
35         uint256 c = a / b;
36 
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a);
50 
51         return c;
52     }
53 
54     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
55         require(b != 0);
56         return a % b;
57     }
58 }
59 
60 contract ERC20 is IERC20 {
61     using SafeMath for uint256;
62 
63     mapping (address => uint256) private _balances;
64 
65     mapping (address => mapping (address => uint256)) private _allowed;
66 
67     uint256 private _totalSupply;
68 
69     function totalSupply() public view returns (uint256) {
70         return _totalSupply;
71     }
72 
73     function balanceOf(address owner) public view returns (uint256) {
74         return _balances[owner];
75     }
76 
77     function allowance(address owner, address spender) public view returns (uint256) {
78         return _allowed[owner][spender];
79     }
80 
81     function transfer(address to, uint256 value) public returns (bool) {
82         _transfer(msg.sender, to, value);
83         return true;
84     }
85 
86     function approve(address spender, uint256 value) public returns (bool) {
87         _approve(msg.sender, spender, value);
88         return true;
89     }
90 
91     function transferFrom(address from, address to, uint256 value) public returns (bool) {
92         _transfer(from, to, value);
93         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
94         return true;
95     }
96 
97     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
98         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
99         return true;
100     }
101 
102     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
103         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
104         return true;
105     }
106 
107     function _transfer(address from, address to, uint256 value) internal {
108         require(to != address(0));
109 
110         _balances[from] = _balances[from].sub(value);
111         _balances[to] = _balances[to].add(value);
112         emit Transfer(from, to, value);
113     }
114 
115     function _mint(address account, uint256 value) internal {
116         require(account != address(0));
117 
118         _totalSupply = _totalSupply.add(value);
119         _balances[account] = _balances[account].add(value);
120         emit Transfer(address(0), account, value);
121     }
122 
123     function _burn(address account, uint256 value) internal {
124         require(account != address(0));
125 
126         _totalSupply = _totalSupply.sub(value);
127         _balances[account] = _balances[account].sub(value);
128         emit Transfer(account, address(0), value);
129     }
130 
131     function _approve(address owner, address spender, uint256 value) internal {
132         require(spender != address(0));
133         require(owner != address(0));
134 
135         _allowed[owner][spender] = value;
136         emit Approval(owner, spender, value);
137     }
138 
139     function _burnFrom(address account, uint256 value) internal {
140         _burn(account, value);
141         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
142     }
143 }
144 
145 contract ERC20Detailed is IERC20 {
146     string private _name;
147     string private _symbol;
148     uint8 private _decimals;
149 
150     constructor (string memory name, string memory symbol, uint8 decimals) public {
151         _name = name;
152         _symbol = symbol;
153         _decimals = decimals;
154     }
155 
156     function name() public view returns (string memory) {
157         return _name;
158     }
159 
160     function symbol() public view returns (string memory) {
161         return _symbol;
162     }
163 
164     function decimals() public view returns (uint8) {
165         return _decimals;
166     }
167 }
168 
169 contract UOSToken is ERC20, ERC20Detailed {
170     uint8 public constant DECIMALS = 4;
171     uint256 public constant INITIAL_SUPPLY = 400000000 * (10 ** uint256(DECIMALS));
172 
173     /**
174      * @dev Constructor that gives msg.sender all of existing tokens.
175      */
176     constructor () public ERC20Detailed("UOSToken", "UOS", 4) {
177         _mint(msg.sender, INITIAL_SUPPLY);
178     }
179 }