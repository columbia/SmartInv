1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8 
9         uint256 c = a * b;
10         require(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         require(b > 0);
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b <= a);
22         uint256 c = a - b;
23         return c;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a);
29         return c;
30     }
31 
32     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b != 0);
34         return a % b;
35     }
36 }
37 
38 interface IERC20 {
39     function transfer(address to, uint256 value) external returns (bool);
40 
41     function approve(address spender, uint256 value) external returns (bool);
42 
43     function transferFrom(address from, address to, uint256 value) external returns (bool);
44 
45     function totalSupply() external view returns (uint256);
46 
47     function balanceOf(address who) external view returns (uint256);
48 
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 contract ERC20 is IERC20 {
57     using SafeMath for uint256;
58 
59     mapping (address => uint256) private _balances;
60 
61     mapping (address => mapping (address => uint256)) private _allowed;
62 
63     uint256 private _totalSupply;
64 
65     function totalSupply() public view returns (uint256) {
66         return _totalSupply;
67     }
68 
69     function balanceOf(address owner) public view returns (uint256) {
70         return _balances[owner];
71     }
72 
73     function allowance(address owner, address spender) public view returns (uint256) {
74         return _allowed[owner][spender];
75     }
76 
77     function transfer(address to, uint256 value) public returns (bool) {
78         _transfer(msg.sender, to, value);
79         return true;
80     }
81 
82     function approve(address spender, uint256 value) public returns (bool) {
83         require(spender != address(0));
84 
85         _allowed[msg.sender][spender] = value;
86         emit Approval(msg.sender, spender, value);
87         return true;
88     }
89 
90     function transferFrom(address from, address to, uint256 value) public returns (bool) {
91         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
92         _transfer(from, to, value);
93         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
94         return true;
95     }
96 
97     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
98         require(spender != address(0));
99 
100         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
101         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
102         return true;
103     }
104 
105     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
106         require(spender != address(0));
107 
108         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
109         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
110         return true;
111     }
112 
113     function _transfer(address from, address to, uint256 value) internal {
114         require(to != address(0));
115 
116         _balances[from] = _balances[from].sub(value);
117         _balances[to] = _balances[to].add(value);
118         emit Transfer(from, to, value);
119     }
120 
121     function _mint(address account, uint256 value) internal {
122         require(account != address(0));
123 
124         _totalSupply = _totalSupply.add(value);
125         _balances[account] = _balances[account].add(value);
126         emit Transfer(address(0), account, value);
127     }
128 
129     function _burn(address account, uint256 value) internal {
130         require(account != address(0));
131 
132         _totalSupply = _totalSupply.sub(value);
133         _balances[account] = _balances[account].sub(value);
134         emit Transfer(account, address(0), value);
135     }
136 
137     function _burnFrom(address account, uint256 value) internal {
138         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
139         _burn(account, value);
140         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
141     }
142 }
143 
144 contract ERC20Detailed is IERC20 {
145     string private _name;
146     string private _symbol;
147     uint8 private _decimals;
148 
149     constructor (string memory name, string memory symbol, uint8 decimals) public {
150         _name = name;
151         _symbol = symbol;
152         _decimals = decimals;
153     }
154 
155     function name() public view returns (string memory) {
156         return _name;
157     }
158 
159     function symbol() public view returns (string memory) {
160         return _symbol;
161     }
162 
163     function decimals() public view returns (uint8) {
164         return _decimals;
165     }
166 }
167 
168 contract OG_Token is ERC20, ERC20Detailed {
169     uint256 public burned;
170 
171     string private constant NAME = "One Genesis";
172     string private constant SYMBOL = "OG";
173     uint8 private constant DECIMALS = 18;
174     uint256 private constant INITIAL_SUPPLY = 9500000000 * 10**18;
175 
176     constructor () public ERC20Detailed(NAME, SYMBOL, DECIMALS) {
177         _mint(msg.sender, INITIAL_SUPPLY);
178     }
179 
180     function burn(uint256 value) public returns(bool) {
181         burned = burned.add(value);
182         _burn(msg.sender, value);
183         return true;
184     }
185 
186     function burnFrom(address from, uint256 value) public returns(bool) {
187         burned = burned.add(value);
188         _burnFrom(from, value);
189         return true;
190     }
191 }