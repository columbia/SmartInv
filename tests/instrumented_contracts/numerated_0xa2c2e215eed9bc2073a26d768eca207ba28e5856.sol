1 pragma solidity ^0.5.1;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6 
7         if (a == 0) {
8             return 0;
9         }
10 
11         uint256 c = a * b;
12         require(c / a == b);
13 
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18      
19         require(b > 0);
20         uint256 c = a / b;
21    
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b <= a);
27         uint256 c = a - b;
28 
29         return c;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a);
35 
36         return c;
37     }
38 
39     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b != 0);
41         return a % b;
42     }
43 }
44 
45 interface IERC20 {
46     function totalSupply() external view returns (uint256);
47     
48     function balanceOf(address who) external view returns (uint256);
49       
50     function transfer(address to, uint256 value) external returns (bool);
51 
52     function transferFrom(address from, address to, uint256 value) external returns (bool);
53 
54     function approve(address spender, uint256 value) external returns (bool);
55 
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58 
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(address indexed owner, address indexed spender, uint256 value);
61     event Burn(address indexed from, uint256 value);
62 }
63 
64 
65 contract ERC20 is IERC20 {
66     
67     using SafeMath for uint256;
68     uint8 constant DECIMALS = 18;
69     uint256 private _totalSupply;
70     string private _name;
71     string private _symbol;
72     
73     mapping (address => uint256) private _balances;
74     mapping (address => mapping (address => uint256)) private _allowed;
75 
76 
77     function totalSupply() public view returns (uint256) {
78         return _totalSupply;
79     }
80 
81     function balanceOf(address owner) public view returns (uint256) {
82         return _balances[owner];
83     }
84 
85     function transfer(address to, uint256 value) public returns (bool) {
86         _transfer(msg.sender, to, value);
87         return true;
88     }
89 
90     function transferFrom(address from, address to, uint256 value) public returns (bool) {
91          _transfer(from, to, value);
92          _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
93          return true;
94     }
95 
96     function approve(address spender, uint256 value) public returns (bool) {
97         _approve(msg.sender, spender, value);
98         return true;
99     }
100     
101     function allowance(address owner, address spender) public view returns (uint256) {
102         return _allowed[owner][spender];
103     }
104     
105     function burn(uint256 value) public {
106         _burn(msg.sender, value);
107     }
108     
109     function _mint(address account, uint256 value) internal {
110         require(account != address(0));
111         _totalSupply = _totalSupply.add(value);
112         _balances[account] = _balances[account].add(value);
113         emit Transfer(address(0), account, value);
114     }
115     
116     function _transfer(address from, address to, uint256 value) internal {
117         require(to != address(0));
118 
119         _balances[from] = _balances[from].sub(value);
120         _balances[to] = _balances[to].add(value);
121         emit Transfer(from, to, value);
122       
123     }
124 
125     function _approve(address owner, address spender, uint256 value) internal {
126         require(spender != address(0));
127         require(owner != address(0));
128 
129         _allowed[owner][spender] = value;
130         emit Approval(owner, spender, value);
131     }
132     
133     function _burn(address account, uint256 value) internal {
134         require(account != address(0));
135     
136         _totalSupply = _totalSupply.sub(value);
137         _balances[account] = _balances[account].sub(value);
138         emit Transfer(account, address(0), value);
139     }
140 }
141 
142 contract ERC20Detailed is IERC20 {
143     string private _name;
144     string private _symbol;
145     uint8 private _decimals;
146 
147     constructor (string memory name, string memory symbol, uint8 decimals) public {
148         _name = name;
149         _symbol = symbol;
150         _decimals = decimals;
151     }
152 
153     /**
154      * @return the name of the token.
155      */
156     function name() public view returns (string memory) {
157         return _name;
158     }
159 
160     /**
161      * @return the symbol of the token.
162      */
163     function symbol() public view returns (string memory) {
164         return _symbol;
165     }
166 
167     /**
168      * @return the number of decimals of the token.
169      */
170     function decimals() public view returns (uint8) {
171         return _decimals;
172     }
173 }
174 
175 contract SaveWon is ERC20, ERC20Detailed {
176     uint8 public constant DECIMALS = 18;
177     uint256 public constant INITIAL_SUPPLY = 50000000000 * (10 ** uint256(DECIMALS));
178 
179     /**
180      * @dev Constructor that gives msg.sender all of existing tokens.
181      */
182     constructor () public ERC20Detailed("SaveWon", "SVW", DECIMALS) {
183         _mint(msg.sender, INITIAL_SUPPLY);
184     }
185 }