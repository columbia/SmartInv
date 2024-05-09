1 pragma solidity ^0.6.0;
2 
3 
4 /*
5 CR7Burn
6 
7 ***  !! No Minting
8 ***  !! No Dev Coins
9 ***  !! No Presale
10 
11 ***  Telegram : t.me/CR7_Burn
12 
13 ***  This is The Gem of 7
14 
15 ***  Total sup: 777777
16 ***  Liquidity: 7 ETH
17 ***  Burning: 7%
18 ***  Liquidity locked: 7*7 = 49h
19 
20 */
21 library SafeMath {
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26 
27         return c;
28     }
29 
30       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b <= a, errorMessage);
36         uint256 c = a - b;
37 
38         return c;
39     }
40 
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43 
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50 
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61 
62         return c;
63     }
64 
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         return mod(a, b, "SafeMath: modulo by zero");
67     }
68 
69     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b != 0, errorMessage);
71         return a % b;
72     }
73 }
74 
75 interface IERC20 {
76 
77     function totalSupply() external view returns (uint256);
78     function balanceOf(address account) external view returns (uint256);
79     function transfer(address recipient, uint256 amount) external returns (bool);
80     function allowance(address owner, address spender) external view returns (uint256);
81     function approve(address spender, uint256 amount) external returns (bool);
82     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 contract ERC20 is IERC20 {
89     using SafeMath for uint256;
90 
91     mapping (address => uint256) private _balances;
92 
93     mapping (address => mapping (address => uint256)) private _allowances;
94 
95     uint256 private _totalSupply;
96 
97     string private _name;
98     string private _symbol;
99     uint8 private _decimals;
100 
101 
102     constructor (string memory name, string memory symbol) public {
103         _name = name;
104         _symbol = symbol;
105         _decimals = 18;
106     }
107 
108       function name() public view returns (string memory) {
109         return _name;
110     }
111 
112       function symbol() public view returns (string memory) {
113         return _symbol;
114     }
115 
116 
117     function decimals() public view returns (uint8) {
118         return _decimals;
119     }
120 
121 
122     function totalSupply() public view override returns (uint256) {
123         return _totalSupply;
124     }
125 
126     function balanceOf(address account) public view override returns (uint256) {
127         return _balances[account];
128     }
129 
130     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
131         _transfer(msg.sender, recipient, amount);
132         return true;
133     }
134 
135     function allowance(address owner, address spender) public view virtual override returns (uint256) {
136         return _allowances[owner][spender];
137     }
138 
139     function approve(address spender, uint256 amount) public virtual override returns (bool) {
140         _approve(msg.sender, spender, amount);
141         return true;
142     }
143 
144 
145     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
146         _transfer(sender, recipient, amount);
147         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
148         return true;
149     }
150 
151 
152     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
153         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
154         return true;
155     }
156 
157 
158     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
159         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
160         return true;
161     }
162 
163     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
164         require(sender != address(0), "ERC20: transfer from the zero address");
165         require(recipient != address(0), "ERC20: transfer to the zero address");
166 
167         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
168         _balances[recipient] = _balances[recipient].add(amount);
169         emit Transfer(sender, recipient, amount);
170     }
171 
172     function _mint(address account, uint256 amount) internal virtual {
173         require(account != address(0), "ERC20: mint to the zero address");
174 
175         _totalSupply = _totalSupply.add(amount);
176         _balances[account] = _balances[account].add(amount);
177         emit Transfer(address(0), account, amount);
178     }
179 
180     function _burn(address account, uint256 amount) internal virtual {
181         require(account != address(0), "ERC20: burn from the zero address");
182 
183         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
184         _totalSupply = _totalSupply.sub(amount);
185         emit Transfer(account, address(0), amount);
186     }
187 
188 
189     function _approve(address owner, address spender, uint256 amount) internal virtual {
190         require(owner != address(0), "ERC20: approve from the zero address");
191         require(spender != address(0), "ERC20: approve to the zero address");
192 
193         _allowances[owner][spender] = amount;
194         emit Approval(owner, spender, amount);
195     }
196 
197     function _setupDecimals(uint8 decimals_) internal {
198         _decimals = decimals_;
199     }
200 
201 }
202 
203 /*   Total supply 777777 CR7B minted on contract creator adress  */
204 contract RC7Burn is ERC20 {
205 
206     constructor () public ERC20("https://t.me/CR7_Burn", "CR7B") {
207         _mint(msg.sender, 777777 * (10 ** uint256(decimals())));
208     }
209 
210     function transfer(address to, uint256 amount) public override returns (bool) {
211         return super.transfer(to, _partialBurn(amount));
212     }
213 
214     function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
215         return super.transferFrom(from, to, _partialBurnTransferFrom(from, amount));
216     }
217 
218     function _partialBurn(uint256 amount) internal returns (uint256) {
219         uint256 burnAmount = amount.div(14);
220 
221         if (burnAmount > 0) {
222             _burn(msg.sender, burnAmount);
223         }
224 
225         return amount.sub(burnAmount);
226     }
227 
228     function _partialBurnTransferFrom(address _originalSender, uint256 amount) internal returns (uint256) {
229         uint256 burnAmount = amount.div(14);
230 
231         if (burnAmount > 0) {
232             _burn(_originalSender, burnAmount);
233         }
234 
235         return amount.sub(burnAmount);
236     }
237 
238 }