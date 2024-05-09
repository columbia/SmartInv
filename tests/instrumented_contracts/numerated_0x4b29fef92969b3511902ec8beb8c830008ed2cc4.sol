1 /**⠀      ⣿⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
2 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡟⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡟⢁⠿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⢹⡉⢠⠟⢷⡀⢀⣴⣿⣦⣀⣴⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⣿⡀⠀⠈⡏⠁⣠⡿⠛⠉⠁⢀⡼⡻⠛⡞⡷⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠚⢯⠟⠂⠀⢹⣞⡟⠁⡠⠔⢒⡾⡼⠁⠀⡇⣇⠀⠙⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠸⠀⠀⢠⡼⠻⡇⢸⢀⣴⣿⣱⠁⠀⢀⠇⡏⠑⢄⠀⠙⢧⣀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⣠⡴⠋⠀⠀⠳⢌⣾⡷⠀⠁⠀⠀⡼⢀⣧⡀⠈⢣⡀⡼⠉⣷⡄⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⣠⡾⠋⠀⠀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠉⢳⠤⠴⠟⠁⣰⣿⠛⢶⡄⠀⠀⠀⠀
10 ⠀⠀⠀⢀⣤⠞⠉⠀⠀⢀⣾⡋⣻⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣦⣠⣴⡾⡟⠉⠣⡀⠹⡄⠀⠀⠀
11 ⠀⣠⠞⠋⣽⠀⠀⠀⠀⠘⣿⣿⣿⣾⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⢸⠀⡇⠀⠀⣇⠀⢿⠀⠀⠀
12 ⢰⠏⢿⡆⠸⡄⠀⠀⠀⠀⠈⠛⠛⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡜⢀⡞⣰⢧⡀⠀⢸⠀⠸⣆⣴⡆
13 ⢸⠀⠀⠀⠀⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠿⢴⠿⠚⢇⠀⠳⣄⡀⠳⠤⢤⡾⠃
14 ⠘⢧⡀⠀⠀⢸⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣄⠀⠈⠢⣄⡀⠉⠙⢻⠛⣧⠀
15 ⠀⠀⠙⠒⠦⠼⠗⠒⠲⠦⢤⣀⠀⠀⠀⣀⣠⣶⠇⠀⠀⠀⠀⠀⠀⠀⠘⣦⣀⠀⠀⠉⢦⠀⢸⠀⢸⡆
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⣰⠃⠀⠀⠀⠀⠀⠀⠀⠀⣠⠇⠈⢳⣄⠀⢸⢀⣾⠀⢸⠃
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡏⠀⠀⠀⠀⠀⠀⢴⣴⣚⡁⣀⡠⠊⣨⣧⡾⢫⠃⢀⡟⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⡾⠓⢲⠋⠉⠁⠀⡎⢀⡾⠁⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⠀⡎⠀⠀⠀⠀⢇⣼⠀⠀⠀
20 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⠀⢣⠀⠀⠀⠀⠀⠉⣹⠇⠀
21 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢷⡀⠀⠓⠤⣀⣀⠤⣶⠟⠀⠀
22 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠓⠒⠒⠒⠒⠒⠒⠚⠋⠙⠲⠦⠤⠤⠶⠛⠁⠀⠀⠀
23 ‧₊˚ ☁️⋅♡𓂃 ִֶָ࣪.ִֶָ☾  🦄
24 
25 **/
26 
27 // SPDX-License-Identifier: MIT
28 
29 pragma solidity ^0.8.17;
30 
31 interface IERC20 {
32     function totalSupply() external view returns (uint256);
33     function balanceOf(address account) external view returns (uint256);
34     function transfer(address recipient, uint256 amount) external returns (bool);
35     function allowance(address owner, address spender) external view returns (uint256);
36     function approve(address spender, uint256 amount) external returns (bool);
37     function transferFrom(
38         address sender,
39         address recipient,
40         uint256 amount
41     ) external returns (bool);
42    
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 interface IERC20Metadata is IERC20 {
48     function name() external view returns (string memory);
49     function symbol() external view returns (string memory);
50     function decimals() external view returns (uint8);
51 }
52 
53 abstract contract Context {
54     function _msgSender() internal view virtual returns (address) {
55         return msg.sender;
56     }
57 
58     function _msgData() internal view virtual returns (bytes calldata) {
59         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
60         return msg.data;
61     }
62 }
63 
64 abstract contract Ownable is Context {
65     address private _owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor () {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 }
90 
91 contract ERC20 is Context, IERC20, IERC20Metadata {
92     mapping(address => uint256) private _balances;
93 
94     mapping(address => mapping(address => uint256)) private _allowances;
95 
96     uint256 private _totalSupply;
97 
98     string private _name;
99     string private _symbol;
100 
101     constructor(string memory name_, string memory symbol_) {
102         _name = name_;
103         _symbol = symbol_;
104     }
105 
106     function name() public view virtual override returns (string memory) {
107         return _name;
108     }
109 
110     function symbol() public view virtual override returns (string memory) {
111         return _symbol;
112     }
113 
114     function decimals() public view virtual override returns (uint8) {
115         return 18;
116     }
117 
118     function totalSupply() public view virtual override returns (uint256) {
119         return _totalSupply;
120     }
121 
122     function balanceOf(address account) public view virtual override returns (uint256) {
123         return _balances[account];
124     }
125 
126     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
127         _transfer(_msgSender(), recipient, amount);
128         return true;
129     }
130 
131     function allowance(address owner, address spender) public view virtual override returns (uint256) {
132         return _allowances[owner][spender];
133     }
134 
135     function approve(address spender, uint256 amount) public virtual override returns (bool) {
136         _approve(_msgSender(), spender, amount);
137         return true;
138     }
139 
140     function transferFrom(
141         address sender,
142         address recipient,
143         uint256 amount
144     ) public virtual override returns (bool) {
145         uint256 currentAllowance = _allowances[sender][_msgSender()];
146         if (currentAllowance != type(uint256).max) {
147             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
148             unchecked {
149                 _approve(sender, _msgSender(), currentAllowance - amount);
150             }
151         }
152 
153         _transfer(sender, recipient, amount);
154 
155         return true;
156     }
157 
158     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
159         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
160         return true;
161     }
162 
163     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
164         uint256 currentAllowance = _allowances[_msgSender()][spender];
165         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
166         unchecked {
167             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
168         }
169 
170         return true;
171     }
172 
173     function _transfer(
174         address sender,
175         address recipient,
176         uint256 amount
177     ) internal virtual {
178         require(sender != address(0), "ERC20: transfer from the zero address");
179         require(recipient != address(0), "ERC20: transfer to the zero address");
180 
181         _beforeTokenTransfer(sender, recipient, amount);
182 
183         uint256 senderBalance = _balances[sender];
184         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
185         unchecked {
186             _balances[sender] = senderBalance - amount;
187         }
188         _balances[recipient] += amount;
189 
190         emit Transfer(sender, recipient, amount);
191 
192         _afterTokenTransfer(sender, recipient, amount);
193     }
194 
195     function _mint(address account, uint256 amount) internal virtual {
196         require(account != address(0), "ERC20: mint to the zero address");
197 
198         _beforeTokenTransfer(address(0), account, amount);
199 
200         _totalSupply += amount;
201         _balances[account] += amount;
202         emit Transfer(address(0), account, amount);
203 
204         _afterTokenTransfer(address(0), account, amount);
205     }
206 
207     function _burn(address account, uint256 amount) internal virtual {
208         require(account != address(0), "ERC20: burn from the zero address");
209 
210         _beforeTokenTransfer(account, address(0), amount);
211 
212         uint256 accountBalance = _balances[account];
213         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
214         unchecked {
215             _balances[account] = accountBalance - amount;
216         }
217         _totalSupply -= amount;
218 
219         emit Transfer(account, address(0), amount);
220 
221         _afterTokenTransfer(account, address(0), amount);
222     }
223 
224     function _approve(
225         address owner,
226         address spender,
227         uint256 amount
228     ) internal virtual {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231 
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236     function _beforeTokenTransfer(
237         address from,
238         address to,
239         uint256 amount
240     ) internal virtual {}
241 
242     function _afterTokenTransfer(
243         address from,
244         address to,
245         uint256 amount
246     ) internal virtual {}
247 }
248 
249 contract UNISWAP is ERC20, Ownable {
250 
251     constructor () ERC20("UniswapEthereumVitalik.eth", "UNISWAP") 
252     {   
253         _mint(owner(), 21_000_000_000 * (10 ** 18));
254     }
255 
256     receive() external payable {
257 
258   	}
259 }