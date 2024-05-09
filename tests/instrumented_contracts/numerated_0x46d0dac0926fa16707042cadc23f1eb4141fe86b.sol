1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8     function _msgData() internal view virtual returns (bytes memory) {
9         this;
10         return msg.data;
11     }
12 }
13 
14 library SafeMath {
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         return sub(a, b, "SafeMath: subtraction overflow");
23     }
24 
25     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
26         require(b <= a, errorMessage);
27         uint256 c = a - b;
28         return c;
29     }
30 
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         if (a == 0) {
33             return 0;
34         }
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37         return c;
38     }
39 
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         return div(a, b, "SafeMath: division by zero");
42     }
43 
44     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b > 0, errorMessage);
46         uint256 c = a / b;
47         return c;
48     }
49 
50     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51         return mod(a, b, "SafeMath: modulo by zero");
52     }
53 
54     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b != 0, errorMessage);
56         return a % b;
57     }
58 }
59 
60 interface IERC20 {
61     function totalSupply() external view returns (uint256);
62     function balanceOf(address account) external view returns (uint256);
63     function transfer(address recipient, uint256 amount) external returns (bool);
64     function allowance(address owner, address spender) external view returns (uint256);
65     function approve(address spender, uint256 amount) external returns (bool);
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract ERC20 is Context, IERC20 {
72     using SafeMath for uint256;
73 
74     mapping (address => uint256) private _balances;
75 
76     mapping (address => mapping (address => uint256)) private _allowances;
77 
78     uint256 private _totalSupply;
79 
80     string private _name;
81     string private _symbol;
82     uint8 private _decimals;
83 
84     constructor (string memory name, string memory symbol) public {
85         _name = name;
86         _symbol = symbol;
87         _decimals = 18;
88     }
89 
90     function name() public view returns (string memory) {
91         return _name;
92     }
93 
94     function symbol() public view returns (string memory) {
95         return _symbol;
96     }
97 
98     function decimals() public view returns (uint8) {
99         return _decimals;
100     }
101 
102     function totalSupply() public view override returns (uint256) {
103         return _totalSupply;
104     }
105 
106     function balanceOf(address account) public view override returns (uint256) {
107         return _balances[account];
108     }
109 
110     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
111         _transfer(_msgSender(), recipient, amount);
112         return true;
113     }
114 
115     function allowance(address owner, address spender) public view virtual override returns (uint256) {
116         return _allowances[owner][spender];
117     }
118 
119     function approve(address spender, uint256 amount) public virtual override returns (bool) {
120         _approve(_msgSender(), spender, amount);
121         return true;
122     }
123 
124     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
125         _transfer(sender, recipient, amount);
126         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
127         return true;
128     }
129 
130     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
131         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
132         return true;
133     }
134 
135     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
136         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
137         return true;
138     }
139 
140     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
141         require(sender != address(0), "ERC20: transfer from the zero address");
142         require(recipient != address(0), "ERC20: transfer to the zero address");
143 
144         _beforeTokenTransfer(sender, recipient, amount);
145 
146         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
147         _balances[recipient] = _balances[recipient].add(amount);
148         emit Transfer(sender, recipient, amount);
149     }
150 
151     function _mint(address account, uint256 amount) internal virtual {
152         require(account != address(0), "ERC20: mint to the zero address");
153 
154         _beforeTokenTransfer(address(0), account, amount);
155 
156         _totalSupply = _totalSupply.add(amount);
157         _balances[account] = _balances[account].add(amount);
158         emit Transfer(address(0), account, amount);
159     }
160 
161     function _burn(address account, uint256 amount) internal virtual {
162         require(account != address(0), "ERC20: burn from the zero address");
163 
164         _beforeTokenTransfer(account, address(0), amount);
165 
166         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
167         _totalSupply = _totalSupply.sub(amount);
168         emit Transfer(account, address(0), amount);
169     }
170 
171     function _approve(address owner, address spender, uint256 amount) internal virtual {
172         require(owner != address(0), "ERC20: approve from the zero address");
173         require(spender != address(0), "ERC20: approve to the zero address");
174 
175         _allowances[owner][spender] = amount;
176         emit Approval(owner, spender, amount);
177     }
178     function _setupDecimals(uint8 decimals_) internal {
179         _decimals = decimals_;
180     }
181 
182     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
183 }
184 
185 contract Ownable is Context {
186     address private _owner;
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190     constructor () internal {
191         address msgSender = _msgSender();
192         _owner = msgSender;
193         emit OwnershipTransferred(address(0), msgSender);
194     }
195 
196     function owner() public view returns (address) {
197         return _owner;
198     }
199 
200     modifier onlyOwner() {
201         require(_owner == _msgSender(), "Ownable: caller is not the owner");
202         _;
203     }
204 
205     function renounceOwnership() public virtual onlyOwner {
206         emit OwnershipTransferred(_owner, address(0));
207         _owner = address(0);
208     }
209 
210     function transferOwnership(address newOwner) public virtual onlyOwner {
211         require(newOwner != address(0), "Ownable: new owner is the zero address");
212         emit OwnershipTransferred(_owner, newOwner);
213         _owner = newOwner;
214     }
215 }
216 
217 contract SONM is ERC20("SONM", "SNM"), Ownable {
218     // initial supply
219     uint256 supply = 44400000 * 1e18;
220 
221     constructor() public {
222         _mint(msg.sender, supply);
223     }
224 
225     function mint(address _to, uint256 _amount) public onlyOwner {
226         _mint(_to, _amount);
227     }
228 
229     function burn(uint256 _amount) public {
230         _burn(msg.sender, _amount);
231     }
232 }