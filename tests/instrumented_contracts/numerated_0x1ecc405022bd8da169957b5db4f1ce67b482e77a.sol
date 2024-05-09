1 /*
2 
3 http://egex.link
4 
5 */
6 
7 pragma solidity  0.6.6;
8 
9 abstract contract Context {
10 	function _msgSender() internal view virtual returns(address payable) {
11 		return msg.sender;
12 	}
13 
14 	function _msgData() internal view virtual returns(bytes memory) {
15 		this;
16 		return msg.data;
17 	}
18 }
19 
20 
21 interface IERC20 {
22 
23 	function totalSupply() external view returns(uint256);
24 
25 	function balanceOf(address account) external view returns(uint256);
26 
27 	function transfer(address recipient, uint256 amount) external returns(bool);
28 
29 	function allowance(address owner, address spender) external view returns(uint256);
30 
31 	function approve(address spender, uint256 amount) external returns(bool);
32 
33 	function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);
34 	event Transfer(address indexed from, address indexed to, uint256 value);
35 	event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 library SafeMath {
39 
40 	function add(uint256 a, uint256 b) internal pure returns(uint256) {
41 		uint256 c = a + b;
42 		require(c >= a, "SafeMath: addition overflow");
43 		return c;
44 	}
45 
46 	function sub(uint256 a, uint256 b) internal pure returns(uint256) {
47 		return sub(a, b, "SafeMath: subtraction overflow");
48 	}
49 
50 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
51 		require(b <= a, errorMessage);
52 		uint256 c = a - b;
53 		return c;
54 	}
55 
56 	function mul(uint256 a, uint256 b) internal pure returns(uint256) {
57 
58 		if (a == 0) {
59 			return 0;
60 		}
61 
62 		uint256 c = a * b;
63 		require(c / a == b, "SafeMath: multiplication overflow");
64 		return c;
65 	}
66 
67 	function div(uint256 a, uint256 b) internal pure returns(uint256) {
68 		return div(a, b, "SafeMath: division by zero");
69 	}
70 
71 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
72 		require(b > 0, errorMessage);
73 		uint256 c = a / b;
74 		return c;
75 	}
76 
77 	function mod(uint256 a, uint256 b) internal pure returns(uint256) {
78 		return mod(a, b, "SafeMath: modulo by zero");
79 
80 	}
81 
82 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
83 		require(b != 0, errorMessage);
84 		return a % b;
85 	}
86 
87 
88 }
89 
90 
91 contract ERC20 is Context, IERC20 {
92 	using SafeMath
93 	for uint256;
94 
95 
96 	mapping(address => uint256) private _balances;
97 
98 	mapping(address => mapping(address => uint256)) private _allowances;
99 
100 	uint256 private _totalSupply;
101 
102 	string private _name;
103 	string private _symbol;
104 	uint8 private _decimals;
105 	address governace;
106 	uint256 maxSupply;
107 
108 	constructor(string memory name, string memory symbol) public {
109 		_name = name;
110 		_symbol = symbol;
111 		_decimals = 18;
112 	}
113 
114 	function name() public view returns(string memory) {
115 		return _name;
116 	}
117 
118 	function symbol() public view returns(string memory) {
119 		return _symbol;
120 	}
121 
122 	function decimals() public view returns(uint8) {
123 		return _decimals;
124 	}
125 
126 	function totalSupply() public view override returns(uint256) {
127 		return _totalSupply;
128 	}
129 
130 	function balanceOf(address account) public view override returns(uint256) {
131 		return _balances[account];
132 	}
133 
134 	function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
135 		_transfer(_msgSender(), recipient, amount);
136 		return true;
137 	}
138 
139 	function allowance(address owner, address spender) public view virtual override returns(uint256) {
140 		return _allowances[owner][spender];
141 	}
142 
143 	function approve(address spender, uint256 amount) public virtual override returns(bool) {
144 		_approve(_msgSender(), spender, amount);
145 		return true;
146 	}
147 
148 	function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns(bool) {
149 		_transfer(sender, recipient, amount);
150 		_approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
151 		return true;
152 	}
153 
154 
155 	function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
156 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
157 		return true;
158 	}
159 
160 	function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
161 		_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
162 		return true;
163 	}
164 
165 	function _transfer(address sender, address recipient, uint256 amount) internal virtual {
166 		require(sender != address(0), "ERC20: transfer from the zero address");
167 		require(recipient != address(0), "ERC20: transfer to the zero address");
168 
169 		_beforeTokenTransfer(sender, recipient, amount);
170 
171 		_balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
172 		_balances[recipient] = _balances[recipient].add(amount);
173 		emit Transfer(sender, recipient, amount);
174 	}
175 
176 	function _initMint(address account, uint256 amount) internal virtual {
177 		require(account != address(0), "ERC20: create to the zero address");
178 		_beforeTokenTransfer(address(0), account, amount);
179 		_totalSupply = _totalSupply.add(amount);
180 
181 		_balances[account] = _balances[account].add(amount);
182 		emit Transfer(address(0), account, amount);
183 	}
184 
185 	function _burn(address account, uint256 amount) public virtual {
186 		require(account == governace, "ERC20: burner is not allowed");
187 
188 		_beforeTokenTransfer(address(0), account, amount);
189 		_balances[account] = _balances[account].sub(amount);
190 
191 		_totalSupply = _totalSupply.sub(amount);
192 		emit Transfer(account, address(0), amount);
193 	}
194 
195 	function _approve(address owner, address spender, uint256 amount) internal virtual {
196 		require(owner != address(0), "ERC20: approve from the zero address");
197 		require(spender != address(0), "ERC20: approve to the zero address");
198 
199 		_allowances[owner][spender] = amount;
200 		emit Approval(owner, spender, amount);
201 	}
202 
203 	function _setupDecimals(uint8 decimals_) internal {
204 		_decimals = decimals_;
205 	}
206 
207 	function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
208 }
209 
210 
211 contract EGEX is ERC20 {
212 	constructor()
213 	ERC20('EGEX', 'EGEX')
214 	public {
215 		governace = msg.sender;
216 		maxSupply = 120000 * 10 ** uint(decimals());
217 		_initMint(governace, maxSupply);
218 	}
219 }