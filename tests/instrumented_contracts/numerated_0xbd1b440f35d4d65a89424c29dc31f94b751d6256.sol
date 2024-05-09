1 pragma solidity >=0.4.22 <0.6.0;
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
49     function transfer(address to, uint256 value) external returns (bool);
50 
51     function approve(address spender, uint256 value) external returns (bool);
52 
53     function transferFrom(address from, address to, uint256 value) external returns (bool);
54 
55     function totalSupply() external view returns (uint256);
56 
57     function balanceOf(address who) external view returns (uint256);
58 
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     event Transfer(address indexed from, address indexed to, uint256 value);
62 
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract ERC20 is IERC20 {
67     using SafeMath for uint256;
68 
69     mapping (address => uint256) private _balances;
70 
71     mapping (address => mapping (address => uint256)) private _allowed;
72 
73     uint256 private _totalSupply;
74 
75     function totalSupply() public view returns (uint256) {
76         return _totalSupply;
77     }
78 
79     function balanceOf(address owner) public view returns (uint256) {
80         return _balances[owner];
81     }
82 
83     function allowance(address owner, address spender) public view returns (uint256) {
84         return _allowed[owner][spender];
85     }
86 
87     function transfer(address to, uint256 value) public returns (bool) {
88         _transfer(msg.sender, to, value);
89         return true;
90     }
91 
92     function approve(address spender, uint256 value) public returns (bool) {
93         require(spender != address(0));
94 
95         _allowed[msg.sender][spender] = value;
96         emit Approval(msg.sender, spender, value);
97         return true;
98     }
99 
100     function transferFrom(address from, address to, uint256 value) public returns (bool) {
101         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
102         _transfer(from, to, value);
103         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
104         return true;
105     }
106 
107     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
108         require(spender != address(0));
109 
110         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
111         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
112         return true;
113     }
114 
115     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
116         require(spender != address(0));
117 
118         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
119         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
120         return true;
121     }
122 
123     function _transfer(address from, address to, uint256 value) internal {
124         require(to != address(0));
125 
126         _balances[from] = _balances[from].sub(value);
127         _balances[to] = _balances[to].add(value);
128         emit Transfer(from, to, value);
129     }
130 
131     function _mint(address account, uint256 value) internal {
132         require(account != address(0));
133 
134         _totalSupply = _totalSupply.add(value);
135         _balances[account] = _balances[account].add(value);
136         emit Transfer(address(0), account, value);
137     }
138 
139     function _burn(address account, uint256 value) internal {
140         require(account != address(0));
141 
142         _totalSupply = _totalSupply.sub(value);
143         _balances[account] = _balances[account].sub(value);
144         emit Transfer(account, address(0), value);
145     }
146 
147     function _burnFrom(address account, uint256 value) internal {
148         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
149         _burn(account, value);
150         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
151     }
152 }
153 
154 contract ERC20Detailed is IERC20 {
155     string private _name;
156     string private _symbol;
157     uint8 private _decimals;
158 
159     constructor (string memory name, string memory symbol, uint8 decimals) public {
160         _name = name;
161         _symbol = symbol;
162         _decimals = decimals;
163     }
164 
165     function name() public view returns (string memory) {
166         return _name;
167     }
168 
169     function symbol() public view returns (string memory) {
170         return _symbol;
171     }
172 
173     function decimals() public view returns (uint8) {
174         return _decimals;
175     }
176 }
177 
178 contract STBCToken is ERC20, ERC20Detailed {
179   uint8 public constant DECIMALS = 18;
180   uint public constant INITIAL_SUPPLY = 8000000000000000000000006;
181 
182   constructor() public ERC20Detailed("STBCToken", "STBC", DECIMALS){
183     _mint(msg.sender, INITIAL_SUPPLY);
184   }
185 }