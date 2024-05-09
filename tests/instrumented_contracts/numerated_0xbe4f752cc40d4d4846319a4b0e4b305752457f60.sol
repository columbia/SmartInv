1 // SPDX-License-Identifier: MIT
2 /*
3    ______   __    __   ______    ______   ______        ________   ______   __    __  ________  __    __ 
4  /      \ |  \  |  \ /      \  /      \ |      \      |        \ /      \ |  \  /  \|        \|  \  |  \
5 |  $$$$$$\| $$  | $$|  $$$$$$\|  $$$$$$\ \$$$$$$       \$$$$$$$$|  $$$$$$\| $$ /  $$| $$$$$$$$| $$\ | $$
6 | $$ __\$$| $$  | $$| $$   \$$| $$   \$$  | $$           | $$   | $$  | $$| $$/  $$ | $$__    | $$$\| $$
7 | $$|    \| $$  | $$| $$      | $$        | $$           | $$   | $$  | $$| $$  $$  | $$  \   | $$$$\ $$
8 | $$ \$$$$| $$  | $$| $$   __ | $$   __   | $$           | $$   | $$  | $$| $$$$$\  | $$$$$   | $$\$$ $$
9 | $$__| $$| $$__/ $$| $$__/  \| $$__/  \ _| $$_          | $$   | $$__/ $$| $$ \$$\ | $$_____ | $$ \$$$$
10  \$$    $$ \$$    $$ \$$    $$ \$$    $$|   $$ \         | $$    \$$    $$| $$  \$$\| $$     \| $$  \$$$
11   \$$$$$$   \$$$$$$   \$$$$$$   \$$$$$$  \$$$$$$          \$$     \$$$$$$  \$$   \$$ \$$$$$$$$ \$$   \$$
12 
13       Website: https://guccitoken.vip/
14       Twitter: https://twitter.com/Gucci_Ethereum/
15 
16 */
17 
18 pragma solidity ^0.8.0;
19 
20 // Importing required OpenZeppelin contracts
21 // Context.sol
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 // IERC20.sol
33 interface IERC20 {
34     function totalSupply() external view returns (uint256);
35 
36     function balanceOf(address account) external view returns (uint256);
37 
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     function approve(address spender, uint256 amount) external returns (bool);
43 
44     function transferFrom(
45         address sender,
46         address recipient,
47         uint256 amount
48     ) external returns (bool);
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 // IERC20Metadata.sol
56 interface IERC20Metadata is IERC20 {
57     function name() external view returns (string memory);
58 
59     function symbol() external view returns (string memory);
60 
61     function decimals() external view returns (uint8);
62 }
63 
64 // Ownable.sol
65 contract Ownable is Context {
66     address private _owner;
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     constructor() {
71         _setOwner(_msgSender());
72     }
73 
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         _setOwner(address(0));
85     }
86 
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         _setOwner(newOwner);
90     }
91 
92     function _setOwner(address newOwner) private {
93         address oldOwner = _owner;
94         _owner = newOwner;
95         emit OwnershipTransferred(oldOwner, newOwner);
96     }
97 }
98 
99 // ERC20.sol
100 contract ERC20 is Context, IERC20, IERC20Metadata {
101     mapping(address => uint256) private _balances;
102 
103     mapping(address => mapping(address => uint256)) private _allowances;
104 
105     uint256 private _totalSupply;
106 
107     string private _name;
108     string private _symbol;
109 
110     constructor(string memory name_, string memory symbol_) {
111         _name = name_;
112         _symbol = symbol_;
113     }
114 
115     function name() public view virtual override returns (string memory) {
116         return _name;
117     }
118 
119     function symbol() public view virtual override returns (string memory) {
120         return _symbol;
121     }
122 
123     function decimals() public view virtual override returns (uint8) {
124         return 18;
125     }
126 
127     function totalSupply() public view virtual override returns (uint256) {
128         return _totalSupply;
129     }
130 
131     function balanceOf(address account) public view virtual override returns (uint256) {
132         return _balances[account];
133     }
134 
135     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
136         _transfer(_msgSender(), recipient, amount);
137         return true;
138     }
139 
140     function allowance(address owner, address spender) public view virtual override returns (uint256) {
141         return _allowances[owner][spender];
142     }
143 
144     function approve(address spender, uint256 amount) public virtual override returns (bool) {
145         _approve(_msgSender(), spender, amount);
146         return true;
147     }
148 
149     function transferFrom(
150         address sender,
151         address recipient,
152         uint256 amount
153     ) public virtual override returns (bool) {
154         _transfer(sender, recipient, amount);
155 
156         uint256 currentAllowance = _allowances[sender][_msgSender()];
157         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
158         _approve(sender, _msgSender(), currentAllowance - amount);
159 
160         return true;
161     }
162 
163     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
164         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
165         return true;
166     }
167 
168     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
169         uint256 currentAllowance = _allowances[_msgSender()][spender];
170         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
171         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
172 
173         return true;
174     }
175 
176     function _transfer(
177         address sender,
178         address recipient,
179         uint256 amount
180     ) internal virtual {
181         require(sender != address(0), "ERC20: transfer from the zero address");
182         require(recipient != address(0), "ERC20: transfer to the zero address");
183 
184         _beforeTokenTransfer(sender, recipient, amount);
185 
186         uint256 senderBalance = _balances[sender];
187         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
188         _balances[sender] = senderBalance - amount;
189         _balances[recipient] += amount;
190 
191         emit Transfer(sender, recipient, amount);
192     }
193 
194     function _mint(address account, uint256 amount) internal virtual {
195         require(account != address(0), "ERC20: mint to the zero address");
196 
197         _beforeTokenTransfer(address(0), account, amount);
198 
199         _totalSupply += amount;
200         _balances[account] += amount;
201         emit Transfer(address(0), account, amount);
202     }
203 
204     function _burn(address account, uint256 amount) internal virtual {
205         require(account != address(0), "ERC20: burn from the zero address");
206 
207         _beforeTokenTransfer(account, address(0), amount);
208 
209         uint256 accountBalance = _balances[account];
210         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
211         _balances[account] = accountBalance - amount;
212         _totalSupply -= amount;
213 
214         emit Transfer(account, address(0), amount);
215     }
216 
217     function _approve(
218         address owner,
219         address spender,
220         uint256 amount
221     ) internal virtual {
222         require(owner != address(0), "ERC20: approve from the zero address");
223         require(spender != address(0), "ERC20: approve to the zero address");
224 
225         _allowances[owner][spender] = amount;
226         emit Approval(owner, spender, amount);
227     }
228 
229     function _beforeTokenTransfer(
230         address from,
231         address to,
232         uint256 amount
233     ) internal virtual {}
234 }
235 
236 // GucciToken
237 contract GucciToken is Ownable, ERC20 {
238     bool public limited;
239     uint256 public maxHoldingAmount;
240     uint256 public minHoldingAmount;
241     mapping(address => bool) public blacklists;
242     bool public blacklistEnabled;
243 
244     constructor(uint256 _totalSupply) ERC20("Gucci", "GUCCI") {
245         _mint(msg.sender, _totalSupply);
246     }
247 
248     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
249         blacklists[_address] = _isBlacklisting;
250     }
251 
252     function setRule(bool _limited, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
253         limited = _limited;
254         maxHoldingAmount = _maxHoldingAmount;
255         minHoldingAmount = _minHoldingAmount;
256     }
257 
258     function setBlacklistEnabled(bool _enabled) external onlyOwner {
259         blacklistEnabled = _enabled;
260     }
261 
262     function _beforeTokenTransfer(
263         address from,
264         address to,
265         uint256 amount
266     ) override internal virtual {
267         if (blacklistEnabled) {
268             require(!blacklists[to] && !blacklists[from], "Blacklisted");
269         }
270 
271         if (limited && from != owner()) {
272             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
273         }
274     }
275 
276     function burn(uint256 value) external {
277         _burn(msg.sender, value);
278     }
279 }