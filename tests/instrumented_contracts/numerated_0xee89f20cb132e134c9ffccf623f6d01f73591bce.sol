1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9 
10         uint256 c = a * b;
11         require(c / a == b);
12 
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         require(b > 0);
18         uint256 c = a / b;
19 
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a);
25         uint256 c = a - b;
26 
27         return c;
28     }
29 
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a);
34 
35         return c;
36     }
37 
38     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b != 0);
40         return a % b;
41     }
42 }
43 
44 interface IERC20 {
45     function transfer(address to, uint256 value) external returns (bool);
46 
47     function approve(address spender, uint256 value) external returns (bool);
48 
49     function transferFrom(address from, address to, uint256 value) external returns (bool);
50 
51     function totalSupply() external view returns (uint256);
52 
53     function balanceOf(address who) external view returns (uint256);
54 
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 contract ERC20 is IERC20 {
63     using SafeMath for uint256;
64 
65     mapping (address => uint256) private _balances;
66 
67     mapping (address => mapping (address => uint256)) private _allowed;
68 
69     uint256 private _totalSupply;
70 
71 
72     function totalSupply() public view returns (uint256) {
73         return _totalSupply;
74     }
75 
76 
77     function balanceOf(address owner) public view returns (uint256) {
78         return _balances[owner];
79     }
80 
81 
82     function allowance(address owner, address spender) public view returns (uint256) {
83         return _allowed[owner][spender];
84     }
85 
86     function transfer(address to, uint256 value) public returns (bool) {
87         _transfer(msg.sender, to, value);
88         return true;
89     }
90 
91     function approve(address spender, uint256 value) public returns (bool) {
92         require(spender != address(0));
93 
94         _allowed[msg.sender][spender] = value;
95         emit Approval(msg.sender, spender, value);
96         return true;
97     }
98 
99     function transferFrom(address from, address to, uint256 value) public returns (bool) {
100         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
101         _transfer(from, to, value);
102         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
103         return true;
104     }
105 
106     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
107         require(spender != address(0));
108 
109         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
110         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
111         return true;
112     }
113 
114 
115     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
116         require(spender != address(0));
117 
118         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
119         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
120         return true;
121     }
122 
123 
124     function _transfer(address from, address to, uint256 value) internal {
125         require(to != address(0));
126 
127         _balances[from] = _balances[from].sub(value);
128         _balances[to] = _balances[to].add(value);
129         emit Transfer(from, to, value);
130     }
131 
132 
133     function _mint(address account, uint256 value) internal {
134         require(account != address(0));
135 
136         _totalSupply = _totalSupply.add(value);
137         _balances[account] = _balances[account].add(value);
138         emit Transfer(address(0), account, value);
139     }
140 
141 
142     function _burn(address account, uint256 value) internal {
143         require(account != address(0));
144 
145         _totalSupply = _totalSupply.sub(value);
146         _balances[account] = _balances[account].sub(value);
147         emit Transfer(account, address(0), value);
148     }
149 
150 
151     function _burnFrom(address account, uint256 value) internal {
152         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
153         _burn(account, value);
154         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
155     }
156 }
157 
158 contract ERC20Detailed is IERC20 {
159     string private _name;
160     string private _symbol;
161     uint8 private _decimals;
162 
163     constructor (string memory name, string memory symbol, uint8 decimals) public {
164         _name = name;
165         _symbol = symbol;
166         _decimals = decimals;
167     }
168 
169     function name() public view returns (string memory) {
170         return _name;
171     }
172 
173 
174     function symbol() public view returns (string memory) {
175         return _symbol;
176     }
177 
178 
179     function decimals() public view returns (uint8) {
180         return _decimals;
181     }
182 }
183 
184 contract BitroomToken is ERC20, ERC20Detailed {
185     uint256 public burned;
186 
187     string private constant NAME = "Bitroom Token";
188     string private constant SYMBOL = "BMT";
189     uint8 private constant DECIMALS = 18;
190     uint256 private constant INITIAL_SUPPLY = 1 * 10**27;
191 
192     constructor () public ERC20Detailed(NAME, SYMBOL, DECIMALS) {
193         _mint(msg.sender, INITIAL_SUPPLY);
194     }
195 
196     function burn(uint256 value) public returns(bool) {
197         burned = burned.add(value);
198         _burn(msg.sender, value);
199         return true;
200     }
201 
202     function burnFrom(address from, uint256 value) public returns(bool) {
203         burned = burned.add(value);
204         _burnFrom(from, value);
205         return true;
206     }
207 }