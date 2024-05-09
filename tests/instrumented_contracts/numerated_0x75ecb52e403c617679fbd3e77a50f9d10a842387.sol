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
21 pragma solidity ^0.5.2;
22 
23 library SafeMath {
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28 
29         uint256 c = a * b;
30         require(c / a == b);
31 
32         return c;
33     }
34 
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         require(b > 0);
37         uint256 c = a / b;
38 
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a);
52 
53         return c;
54     }
55 
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b != 0);
58         return a % b;
59     }
60 }
61 
62 pragma solidity ^0.5.2;
63 contract ERC20 is IERC20 {
64     using SafeMath for uint256;
65 
66     mapping (address => uint256) private _balances;
67 
68     mapping (address => mapping (address => uint256)) private _allowed;
69 
70     uint256 private _totalSupply;
71 
72     function totalSupply() public view returns (uint256) {
73         return _totalSupply;
74     }
75 
76     function balanceOf(address owner) public view returns (uint256) {
77         return _balances[owner];
78     }
79 
80     function allowance(address owner, address spender) public view returns (uint256) {
81         return _allowed[owner][spender];
82     }
83 
84     function transfer(address to, uint256 value) public returns (bool) {
85         _transfer(msg.sender, to, value);
86         return true;
87     }
88 
89     function approve(address spender, uint256 value) public returns (bool) {
90         _approve(msg.sender, spender, value);
91         return true;
92     }
93 
94     function transferFrom(address from, address to, uint256 value) public returns (bool) {
95         _transfer(from, to, value);
96         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
97         return true;
98     }
99 
100     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
101         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
102         return true;
103     }
104 
105     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
106         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
107         return true;
108     }
109 
110     function _transfer(address from, address to, uint256 value) internal {
111         require(to != address(0));
112 
113         _balances[from] = _balances[from].sub(value);
114         _balances[to] = _balances[to].add(value);
115         emit Transfer(from, to, value);
116     }
117 
118     function _mint(address account, uint256 value) internal {
119         require(account != address(0));
120 
121         _totalSupply = _totalSupply.add(value);
122         _balances[account] = _balances[account].add(value);
123         emit Transfer(address(0), account, value);
124     }
125 
126     function _burn(address account, uint256 value) internal {
127         require(account != address(0));
128 
129         _totalSupply = _totalSupply.sub(value);
130         _balances[account] = _balances[account].sub(value);
131         emit Transfer(account, address(0), value);
132     }
133 
134     function _approve(address owner, address spender, uint256 value) internal {
135         require(spender != address(0));
136         require(owner != address(0));
137 
138         _allowed[owner][spender] = value;
139         emit Approval(owner, spender, value);
140     }
141 
142     function _burnFrom(address account, uint256 value) internal {
143         _burn(account, value);
144         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
145     }
146 }
147 
148 pragma solidity ^0.5.2;
149 
150 contract Ownable {
151     address private _owner;
152 
153     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155     constructor () internal {
156         _owner = msg.sender;
157         emit OwnershipTransferred(address(0), _owner);
158     }
159 
160     function owner() public view returns (address) {
161         return _owner;
162     }
163 
164     modifier onlyOwner() {
165         require(isOwner());
166         _;
167     }
168 
169     function isOwner() public view returns (bool) {
170         return msg.sender == _owner;
171     }
172 
173     function renounceOwnership() public onlyOwner {
174         emit OwnershipTransferred(_owner, address(0));
175         _owner = address(0);
176     }
177 
178     function transferOwnership(address newOwner) public onlyOwner {
179         _transferOwnership(newOwner);
180     }
181 
182     function _transferOwnership(address newOwner) internal {
183         require(newOwner != address(0));
184         emit OwnershipTransferred(_owner, newOwner);
185         _owner = newOwner;
186     }
187 }
188 
189 pragma solidity ^0.5.2;
190 
191 contract ERC20Protected is ERC20 {
192     function () payable external {
193         revert();
194     }
195 
196     function transfer(address to, uint256 value) public returns (bool) {
197         require (to != address(this));
198         return super.transfer(to, value);
199     }
200 
201     function transferFrom(address from, address to, uint256 value) public returns (bool) {
202         require (to != address(this));
203         return super.transferFrom(from, to, value);
204     }
205 }
206 
207 pragma solidity ^0.5.2;
208 
209 contract ERC20DetailedChangeable is ERC20, Ownable {
210     string private _name;
211     string private _symbol;
212     uint8 private _decimals;
213 
214     event NameChanged(string oldName, string newName, address changer);
215     event SymbolChanged(string oldSymbol, string newSymbol, address changer);
216 
217     constructor (string memory name, string memory symbol, uint8 decimals) public {
218         _name = name;
219         _symbol = symbol;
220         _decimals = decimals;
221     }
222 
223     function name() public view returns (string memory) {
224         return _name;
225     }
226 
227     function symbol() public view returns (string memory) {
228         return _symbol;
229     }
230 
231     function decimals() public view returns (uint8) {
232         return _decimals;
233     }
234 
235     function setName(string memory newName) public onlyOwner {
236         emit NameChanged(_name, newName, msg.sender);
237         _name = newName;
238     }
239 
240     function setSymbol(string memory newSymbol) public onlyOwner {
241         emit SymbolChanged(_symbol, newSymbol, msg.sender);
242         _symbol = newSymbol;
243     }
244 }
245 
246 pragma solidity ^0.5.2;
247 
248 contract CSR is ERC20, Ownable, ERC20DetailedChangeable, ERC20Protected {
249     uint8 public constant DECIMALS = 18;
250     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(DECIMALS));
251 
252     constructor () public ERC20DetailedChangeable("CSR", "CSR", DECIMALS) {
253         _mint(msg.sender, INITIAL_SUPPLY);
254     }
255 
256     function renounceOwnership() public onlyOwner {
257         revert();
258     } 
259 }