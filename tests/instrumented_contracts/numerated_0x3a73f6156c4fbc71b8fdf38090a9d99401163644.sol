1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-12
3 */
4 
5 pragma solidity ^0.6.2;
6 
7 
8 // SPDX-License-Identifier: UNLICENSED
9 
10 library SafeMath {
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a + b;
13         require(c >= a, "SafeMath: addition overflow");
14 
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         return sub(a, b, "SafeMath: subtraction overflow");
20     }
21 
22     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
23         require(b <= a, errorMessage);
24         uint256 c = a - b;
25         return c;
26     }
27 
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         if (a == 0) {
30             return 0;
31         }
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34         return c;
35     }
36 
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40 
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b > 0, errorMessage);
43         uint256 c = a / b;
44         return c;
45     }
46 
47     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
48         return mod(a, b, "SafeMath: modulo by zero");
49     }
50 
51     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b != 0, errorMessage);
53         return a % b;
54     }
55 }
56 
57 contract Context {
58     constructor () internal { }
59 
60     function _msgSender() internal view virtual returns (address payable) {
61         return msg.sender;
62     }
63 
64     function _msgData() internal view virtual returns (bytes memory) {
65         this;
66         return msg.data;
67     }
68 }
69 
70 
71 library Address {
72     function isContract(address account) internal view returns (bool) {
73         bytes32 codehash;
74         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
75 
76         assembly { codehash := extcodehash(account) }
77         return (codehash != accountHash && codehash != 0x0);
78     }
79 
80     function sendValue(address payable recipient, uint256 amount) internal {
81         require(address(this).balance >= amount, "Address: insufficient balance");
82 
83         (bool success, ) = recipient.call{ value: amount }("");
84         require(success, "Address: unable to send value, recipient may have reverted");
85     }
86 }
87 
88 interface IERC20 {
89     function totalSupply() external view returns (uint256);
90 
91     function balanceOf(address account) external view returns (uint256);
92 
93     function transfer(address recipient, uint256 amount) external returns (bool);
94 
95     function allowance(address owner, address spender) external view returns (uint256);
96 
97     function approve(address spender, uint256 amount) external returns (bool);
98 
99     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
100 
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 
107 contract ERC20 is Context, IERC20 {
108     using SafeMath for uint256;
109     using Address for address;
110 
111     mapping (address => uint256) private _balances;
112 
113     mapping (address => mapping (address => uint256)) private _allowances;
114 
115     uint256 private _totalSupply;
116 
117     string private _name;
118     string private _symbol;
119     uint8 private _decimals;
120 
121     constructor (string memory name, string memory symbol) public {
122         _name = name;
123         _symbol = symbol;
124         _decimals = 18;
125     }
126 
127     function name() public view returns (string memory) {
128         return _name;
129     }
130 
131     function symbol() public view returns (string memory) {
132         return _symbol;
133     }
134 
135     function decimals() public view returns (uint8) {
136         return _decimals;
137     }
138 
139     function totalSupply() public view override returns (uint256) {
140         return _totalSupply;
141     }
142 
143     function balanceOf(address account) public view override returns (uint256) {
144         return _balances[account];
145     }
146 
147     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
148         _transfer(_msgSender(), recipient, amount);
149         return true;
150     }
151 
152     function allowance(address owner, address spender) public view virtual override returns (uint256) {
153         return _allowances[owner][spender];
154     }
155 
156     function approve(address spender, uint256 amount) public virtual override returns (bool) {
157         _approve(_msgSender(), spender, amount);
158         return true;
159     }
160 
161     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
162         _transfer(sender, recipient, amount);
163         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
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
180 
181         _beforeTokenTransfer(sender, recipient, amount);
182 
183         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
184         _balances[recipient] = _balances[recipient].add(amount);
185         emit Transfer(sender, recipient, amount);
186     }
187 
188     function _mint(address account, uint256 amount) internal virtual {
189         require(account != address(0), "ERC20: mint to the zero address");
190 
191         _beforeTokenTransfer(address(0), account, amount);
192 
193         _totalSupply = _totalSupply.add(amount);
194         _balances[account] = _balances[account].add(amount);
195         emit Transfer(address(0), account, amount);
196     }
197 
198     function _burn(address account, uint256 amount) internal virtual {
199         require(account != address(0), "ERC20: burn from the zero address");
200 
201         _beforeTokenTransfer(account, address(0), amount);
202 
203         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
204         _totalSupply = _totalSupply.sub(amount);
205         emit Transfer(account, address(0), amount);
206     }
207 
208     function _approve(address owner, address spender, uint256 amount) internal virtual {
209         require(owner != address(0), "ERC20: approve from the zero address");
210         require(spender != address(0), "ERC20: approve to the zero address");
211 
212         _allowances[owner][spender] = amount;
213         emit Approval(owner, spender, amount);
214     }
215 
216     function _setupDecimals(uint8 decimals_) internal {
217         _decimals = decimals_;
218     }
219 
220     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
221 }
222 
223 contract LNTToken is ERC20 {
224     constructor() public ERC20("Lotto Nation Token", "LNT") {
225         _mint(msg.sender, 400000000 * (10 ** uint(decimals())));
226     }
227 }