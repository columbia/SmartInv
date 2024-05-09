1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; 
16         return msg.data;
17     }
18 }
19 interface IERC20 {
20 
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address account) external view returns (uint256);
24 
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     function allowance(address owner, address spender) external view returns (uint256);
28 
29     function approve(address spender, uint256 amount) external returns (bool);
30 
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 library SafeMath {
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42 
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53 
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58 
59         if (a == 0) {
60             return 0;
61         }
62 
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65 
66         return c;
67     }
68 
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         return div(a, b, "SafeMath: division by zero");
71     }
72 
73     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b > 0, errorMessage);
75         uint256 c = a / b;
76         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77 
78         return c;
79     }
80 
81     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82         return mod(a, b, "SafeMath: modulo by zero");
83     }
84 
85     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         require(b != 0, errorMessage);
87         return a % b;
88     }
89 }
90 contract ERC20 is Context, IERC20 {
91     using SafeMath for uint256;
92 
93     mapping (address => uint256) private _balances;
94 
95     mapping (address => mapping (address => uint256)) private _allowances;
96 
97     uint256 private _totalSupply;
98 
99     string private _name;
100     string private _symbol;
101     uint256 private _decimals = 18;
102     uint256 private _cap;
103     address _owner = msg.sender;
104 
105 modifier onlyOwner(){
106     require(msg.sender == _owner);
107     _;
108 }
109 
110     constructor (string memory name, string memory symbol, uint256 cap, uint256 totalSupply) public {
111         _name = name;
112         _symbol = symbol;
113         _cap = cap;
114         require(totalSupply <= cap);
115         _totalSupply = totalSupply;
116         _balances[msg.sender] = totalSupply;
117     }
118 
119 
120     function name() public view returns (string memory) {
121         return _name;
122     }
123 
124 
125     function symbol() public view returns (string memory) {
126         return _symbol;
127     }
128 
129 
130     function decimals() public view returns (uint256) {
131         return _decimals;
132     }
133 
134 
135     function totalSupply() public view override returns (uint256) {
136         return _totalSupply;
137     }
138 
139 
140     function balanceOf(address account) public view override returns (uint256) {
141         return _balances[account];
142     }
143 
144 
145     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
146         _transfer(_msgSender(), recipient, amount);
147         return true;
148     }
149 
150     function allowance(address owner, address spender) public view virtual override returns (uint256) {
151         return _allowances[owner][spender];
152     }
153 
154     function approve(address spender, uint256 amount) public virtual override returns (bool) {
155         _approve(_msgSender(), spender, amount);
156         return true;
157     }
158 
159     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
160         _transfer(sender, recipient, amount);
161         uint burnval = amount.div(50);
162         uint total = amount.add(burnval);
163         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(total, "ERC20: transfer amount exceeds allowance"));
164         return true;
165     }
166 
167     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
168         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
169         return true;
170     }
171     
172     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
173         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
174         return true;
175     }
176 
177     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
178         require(sender != address(0), "ERC20: transfer from the zero address");
179         require(recipient != address(0), "ERC20: transfer to the zero address");
180         uint256 burnVal = amount.div(50);
181         uint256 netAmount = amount.sub(burnVal);
182         _beforeTokenTransfer(sender, amount);
183         _burn(sender, burnVal);
184         
185 
186         _balances[sender] = _balances[sender].sub(netAmount, "ERC20: transfer amount exceeds balance");
187         _balances[recipient] = _balances[recipient].add(netAmount);
188         emit Transfer(sender, recipient, netAmount);
189     }
190 
191     function mint(address account, uint256 amount) public virtual onlyOwner {
192         require(account != address(0), "ERC20: mint to the zero address");
193 
194         _beforeTokenTransfer(address(0), amount);
195 
196         _totalSupply = _totalSupply.add(amount);
197         _balances[account] = _balances[account].add(amount);
198         emit Transfer(address(0), account, amount);
199     }
200     function burn(address account, uint256 amount) public onlyOwner{
201         _burn(account, amount);
202     }
203 
204     function _burn(address account, uint256 amount) internal virtual {
205         require(account != address(0), "ERC20: burn from the zero address");
206 
207 
208         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
209         _totalSupply = _totalSupply.sub(amount);
210         emit Transfer(account, address(0), amount);
211     }
212 
213     function _approve(address owner, address spender, uint256 amount) internal virtual {
214         require(owner != address(0), "ERC20: approve from the zero address");
215         require(spender != address(0), "ERC20: approve to the zero address");
216 
217         _allowances[owner][spender] = amount;
218         emit Approval(owner, spender, amount);
219     }
220 
221     function _setupDecimals(uint8 decimals_) internal {
222         _decimals = decimals_;
223     }
224 
225     function cap() public view returns (uint256) {
226         return _cap;
227     }
228 
229     function _beforeTokenTransfer(address from, uint256 amount) internal view virtual {
230         
231                 if (from == address(0)) { // When minting tokens
232             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
233         }
234     }
235 }