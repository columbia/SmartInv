1 pragma solidity ^0.5.2;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
7         // benefit is lost if 'b' is also tested.
8         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
9         if (a == 0) {
10             return 0;
11         }
12 
13         uint256 c = a * b;
14         require(c / a == b);
15 
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // Solidity only automatically asserts when dividing by 0
21         require(b > 0);
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24 
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         require(b <= a);
30         uint256 c = a - b;
31 
32         return c;
33     }
34 
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a);
38 
39         return c;
40     }
41 
42     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b != 0);
44         return a % b;
45     }
46 }
47 
48 interface IERC20 {
49 
50     function transfer(address to, uint256 value) external returns (bool);
51 
52     function approve(address spender, uint256 value) external returns (bool);
53 
54     function transferFrom(address from, address to, uint256 value) external returns (bool);
55 
56     function totalSupply() external view returns (uint256);
57 
58     function balanceOf(address who) external view returns (uint256);
59 
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 contract ERC20 is IERC20 {
68 
69     using SafeMath for uint256;
70 
71     mapping (address => uint256) private _balances;
72 
73     mapping (address => mapping (address => uint256)) private _allowed;
74 
75     uint256 private _totalSupply;
76 
77     function totalSupply() public view returns (uint256) {
78         return _totalSupply;
79     }
80 
81     function balanceOf(address owner) public view returns (uint256) {
82         return _balances[owner];
83     }
84 
85     function allowance(address owner, address spender) public view returns (uint256) {
86         return _allowed[owner][spender];
87     }
88 
89     function transfer(address to, uint256 value) public returns (bool) {
90         _transfer(msg.sender, to, value);
91         return true;
92     }
93 
94     function approve(address spender, uint256 value) public returns (bool) {
95         require(spender != address(0));
96 
97         _allowed[msg.sender][spender] = value;
98         emit Approval(msg.sender, spender, value);
99         return true;
100     }
101 
102     function transferFrom(address from, address to, uint256 value) public returns (bool) {
103         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
104         _transfer(from, to, value);
105         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
106         return true;
107     }
108 
109     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
110         require(spender != address(0));
111 
112         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
113         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
114         return true;
115     }
116 
117     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
118         require(spender != address(0));
119 
120         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
121         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
122         return true;
123     }
124 
125     function _transfer(address from, address to, uint256 value) internal {
126         require(to != address(0));
127 
128         _balances[from] = _balances[from].sub(value);
129         _balances[to] = _balances[to].add(value);
130         emit Transfer(from, to, value);
131     }
132 
133     function _mint(address account, uint256 value) internal {
134         require(account != address(0));
135 
136         _totalSupply = _totalSupply.add(value);
137         _balances[account] = _balances[account].add(value);
138         emit Transfer(address(0), account, value);
139     }
140 
141     function _burn(address account, uint256 value) internal {
142         require(account != address(0));
143 
144         _totalSupply = _totalSupply.sub(value);
145         _balances[account] = _balances[account].sub(value);
146         emit Transfer(account, address(0), value);
147     }
148 
149     function _burnFrom(address account, uint256 value) internal {
150         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
151         _burn(account, value);
152         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
153     }
154 }
155 
156 contract ERC20Detailed is IERC20 {
157 
158     string private _name;
159     string private _symbol;
160     uint8 private _decimals;
161 
162     constructor (string memory name, string memory symbol, uint8 decimals) public {
163         _name = name;
164         _symbol = symbol;
165         _decimals = decimals;
166     }
167 
168     function name() public view returns (string memory) {
169         return _name;
170     }
171 
172     function symbol() public view returns (string memory) {
173         return _symbol;
174     }
175 
176     function decimals() public view returns (uint8) {
177         return _decimals;
178     }
179 }
180 
181 contract Full is ERC20, ERC20Detailed {
182     uint public INITIAL_SUPPLY = 1000000000e4;
183     constructor () public
184     ERC20Detailed("Vietnam Real Estate Crypto", "BDSVN", 4)
185     {
186         _mint(msg.sender, INITIAL_SUPPLY);
187     }
188 }