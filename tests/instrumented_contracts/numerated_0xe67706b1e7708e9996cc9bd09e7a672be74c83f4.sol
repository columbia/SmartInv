1 pragma solidity ^0.5.2;
2 
3 
4 
5 
6 interface IERC20 {
7     function transfer(address to, uint256 value) external returns (bool);
8 
9     function approve(address spender, uint256 value) external returns (bool);
10 
11     function transferFrom(address from, address to, uint256 value) external returns (bool);
12 
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address who) external view returns (uint256);
16 
17     function allowance(address owner, address spender) external view returns (uint256);
18     
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 
25 
26 
27 
28 
29 
30 
31 contract ERC20Detailed is IERC20 {
32     string private _name;
33     string private _symbol;
34     uint8 private _decimals;
35 
36     constructor (string memory name, string memory symbol, uint8 decimals) public {
37         _name = name;
38         _symbol = symbol;
39         _decimals = decimals;
40     }
41 
42     function name() public view returns (string memory) {
43         return _name;
44     }
45 
46     function symbol() public view returns (string memory) {
47         return _symbol;
48     }
49 
50     function decimals() public view returns (uint8) {
51         return _decimals;
52     }
53 }
54 
55 
56 
57 
58 
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 
74 
75 
76 
77 
78 
79 library SafeMath {
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b);
88 
89         return c;
90     }
91 
92     function div(uint256 a, uint256 b) internal pure returns (uint256) {
93         require(b > 0);
94         uint256 c = a / b;
95         return c;
96     }
97 
98 
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b <= a);
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     function add(uint256 a, uint256 b) internal pure returns (uint256) {
107         uint256 c = a + b;
108         require(c >= a);
109 
110         return c;
111     }
112 
113     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
114         require(b != 0);
115         return a % b;
116     }
117 }
118 
119 
120 
121 
122 
123 
124 
125 
126 
127 contract ERC20 is IERC20 {
128     using SafeMath for uint256;
129 
130     mapping (address => uint256) private _balances;
131 
132     mapping (address => mapping (address => uint256)) private _allowed;
133 
134     uint256 private _totalSupply;
135 
136     function totalSupply() public view returns (uint256) {
137         return _totalSupply;
138     }
139     function balanceOf(address owner) public view returns (uint256) {
140         return _balances[owner];
141     }
142     function allowance(address owner, address spender) public view returns (uint256) {
143         return _allowed[owner][spender];
144     }
145     function transfer(address to, uint256 value) public returns (bool) {
146         _transfer(msg.sender, to, value);
147         return true;
148     }
149     function approve(address spender, uint256 value) public returns (bool) {
150         _approve(msg.sender, spender, value);
151         return true;
152     }
153     function transferFrom(address from, address to, uint256 value) public returns (bool) {
154         _transfer(from, to, value);
155         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
156         return true;
157     }
158     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
159         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
160         return true;
161     }
162     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
163         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
164         return true;
165     }
166     function _transfer(address from, address to, uint256 value) internal {
167         require(to != address(0));
168 
169         _balances[from] = _balances[from].sub(value);
170         _balances[to] = _balances[to].add(value);
171         emit Transfer(from, to, value);
172     }
173     function _mint(address account, uint256 value) internal {
174         require(account != address(0));
175 
176         _totalSupply = _totalSupply.add(value);
177         _balances[account] = _balances[account].add(value);
178         emit Transfer(address(0), account, value);
179     }
180     function _burn(address account, uint256 value) internal {
181         require(account != address(0));
182 
183         _totalSupply = _totalSupply.sub(value);
184         _balances[account] = _balances[account].sub(value);
185         emit Transfer(account, address(0), value);
186     }
187     function _approve(address owner, address spender, uint256 value) internal {
188         require(spender != address(0));
189         require(owner != address(0));
190 
191         _allowed[owner][spender] = value;
192         emit Approval(owner, spender, value);
193     }
194     function _burnFrom(address account, uint256 value) internal {
195         _burn(account, value);
196         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
197     }
198 }
199 
200 
201 
202 
203 
204 
205 
206 
207 
208 
209 
210 contract ERC20Burnable is ERC20 {
211 
212     function burn(uint256 value) public {
213         _burn(msg.sender, value);
214     }
215 
216     function burnFrom(address from, uint256 value) public {
217         _burnFrom(from, value);
218     }
219 }
220 
221 
222 
223 
224 
225 
226 
227 
228 
229 
230 contract SimpleToken is ERC20, ERC20Detailed {
231     uint8 public constant DECIMALS = 18;
232     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(DECIMALS));
233 
234     constructor () public ERC20Detailed("Infini", "INFI", DECIMALS) {
235         _mint(msg.sender, INITIAL_SUPPLY);
236     }
237 }