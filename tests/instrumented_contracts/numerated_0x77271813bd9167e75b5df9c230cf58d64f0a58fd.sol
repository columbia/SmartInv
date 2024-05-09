1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23 
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 library SafeMath {
34     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         uint256 c = a + b;
36         if (c < a) return (false, 0);
37         return (true, c);
38     }
39 
40     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
41         if (b > a) return (false, 0);
42         return (true, a - b);
43     }
44 
45     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
49         if (a == 0) return (true, 0);
50         uint256 c = a * b;
51         if (c / a != b) return (false, 0);
52         return (true, c);
53     }
54 
55     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
56         if (b == 0) return (false, 0);
57         return (true, a / b);
58     }
59 
60     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
61         if (b == 0) return (false, 0);
62         return (true, a % b);
63     }
64 
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68         return c;
69     }
70 
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b <= a, "SafeMath: subtraction overflow");
73         return a - b;
74     }
75 
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         if (a == 0) return 0;
78         uint256 c = a * b;
79         require(c / a == b, "SafeMath: multiplication overflow");
80         return c;
81     }
82 
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b > 0, "SafeMath: division by zero");
85         return a / b;
86     }
87 
88     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
89         require(b > 0, "SafeMath: modulo by zero");
90         return a % b;
91     }
92 
93     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         require(b <= a, errorMessage);
95         return a - b;
96     }
97 
98     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99         require(b > 0, errorMessage);
100         return a / b;
101     }
102 
103     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         return a % b;
106     }
107 }
108 
109 
110 contract ERC20 is Context, IERC20 {
111     using SafeMath for uint256;
112 
113     mapping (address => uint256) private _balances;
114 
115     mapping (address => mapping (address => uint256)) private _allowances;
116 
117     uint256 private _totalSupply;
118 
119     string private _name;
120     string private _symbol;
121     uint8 private _decimals;
122 
123     constructor (string memory name_, string memory symbol_) public {
124         _name = name_;
125         _symbol = symbol_;
126         _decimals = 18;
127     }
128 
129     function name() public view virtual returns (string memory) {
130         return _name;
131     }
132 
133     function symbol() public view virtual returns (string memory) {
134         return _symbol;
135     }
136 
137     function decimals() public view virtual returns (uint8) {
138         return _decimals;
139     }
140 
141     function totalSupply() public view virtual override returns (uint256) {
142         return _totalSupply;
143     }
144 
145     function balanceOf(address account) public view virtual override returns (uint256) {
146         return _balances[account];
147     }
148 
149     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
150         _transfer(_msgSender(), recipient, amount);
151         return true;
152     }
153 
154     function allowance(address owner, address spender) public view virtual override returns (uint256) {
155         return _allowances[owner][spender];
156     }
157 
158     function approve(address spender, uint256 amount) public virtual override returns (bool) {
159         _approve(_msgSender(), spender, amount);
160         return true;
161     }
162 
163     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
164         _transfer(sender, recipient, amount);
165         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
166         return true;
167     }
168 
169     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
170         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
171         return true;
172     }
173 
174     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
175         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
176         return true;
177     }
178 
179     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
180         require(sender != address(0), "ERC20: transfer from the zero address");
181         require(recipient != address(0), "ERC20: transfer to the zero address");
182 
183         _beforeTokenTransfer(sender, recipient, amount);
184 
185         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
186         _balances[recipient] = _balances[recipient].add(amount);
187         emit Transfer(sender, recipient, amount);
188     }
189 
190     function _mint(address account, uint256 amount) internal virtual {
191         require(account != address(0), "ERC20: mint to the zero address");
192 
193         _beforeTokenTransfer(address(0), account, amount);
194 
195         _totalSupply = _totalSupply.add(amount);
196         _balances[account] = _balances[account].add(amount);
197         emit Transfer(address(0), account, amount);
198     }
199 
200     function _burn(address account, uint256 amount) internal virtual {
201         require(account != address(0), "ERC20: burn from the zero address");
202 
203         _beforeTokenTransfer(account, address(0), amount);
204 
205         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
206         _totalSupply = _totalSupply.sub(amount);
207         emit Transfer(account, address(0), amount);
208     }
209 
210     function _approve(address owner, address spender, uint256 amount) internal virtual {
211         require(owner != address(0), "ERC20: approve from the zero address");
212         require(spender != address(0), "ERC20: approve to the zero address");
213 
214         _allowances[owner][spender] = amount;
215         emit Approval(owner, spender, amount);
216     }
217 
218     function _setupDecimals(uint8 decimals_) internal virtual {
219         _decimals = decimals_;
220     }
221 
222     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
223 }
224 
225 
226 contract BalkariToken is ERC20 {
227     uint8 private DECIMAL = 18;
228     uint256 private MAX_TOKEN_COUNT = 100e8;
229     uint256 private MAX_SUPPLY =  MAX_TOKEN_COUNT * ( 10 ** uint256(DECIMAL) );
230     uint256 public INITIAL_SUPPLY = MAX_SUPPLY;
231 
232     constructor() public
233     ERC20("Balkari Token", "BKR")
234     {
235         _mint(0xAbb97baf2E6e76913E7bc51864e7B64dC0c951fb, INITIAL_SUPPLY);
236     }
237 
238 }