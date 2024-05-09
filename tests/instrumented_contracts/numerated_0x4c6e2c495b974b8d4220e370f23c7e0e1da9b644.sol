1 // ░██████╗░█████╗░███████╗██╗░░░██╗  ██████╗░██╗░░░██╗
2 // ██╔════╝██╔══██╗██╔════╝██║░░░██║  ██╔══██╗╚██╗░██╔╝
3 // ╚█████╗░███████║█████╗░░██║░░░██║  ██████╦╝░╚████╔╝░
4 // ░╚═══██╗██╔══██║██╔══╝░░██║░░░██║  ██╔══██╗░░╚██╔╝░░
5 // ██████╔╝██║░░██║██║░░░░░╚██████╔╝  ██████╦╝░░░██║░░░
6 // ╚═════╝░╚═╝░░╚═╝╚═╝░░░░░░╚═════╝░  ╚═════╝░░░░╚═╝░░░
7 
8 // ░█████╗░░█████╗░██╗███╗░░██╗░██████╗██╗░░░██╗██╗░░░░░████████╗░░░███╗░░██╗███████╗████████╗
9 // ██╔══██╗██╔══██╗██║████╗░██║██╔════╝██║░░░██║██║░░░░░╚══██╔══╝░░░████╗░██║██╔════╝╚══██╔══╝
10 // ██║░░╚═╝██║░░██║██║██╔██╗██║╚█████╗░██║░░░██║██║░░░░░░░░██║░░░░░░██╔██╗██║█████╗░░░░░██║░░░
11 // ██║░░██╗██║░░██║██║██║╚████║░╚═══██╗██║░░░██║██║░░░░░░░░██║░░░░░░██║╚████║██╔══╝░░░░░██║░░░
12 // ╚█████╔╝╚█████╔╝██║██║░╚███║██████╔╝╚██████╔╝███████╗░░░██║░░░██╗██║░╚███║███████╗░░░██║░░░
13 // ░╚════╝░░╚════╝░╚═╝╚═╝░░╚══╝╚═════╝░░╚═════╝░╚══════╝░░░╚═╝░░░╚═╝╚═╝░░╚══╝╚══════╝░░░╚═╝░░░
14 
15 // Get your SAFU contract now via Coinsult.net
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity 0.8.17;
20 
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33    
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 interface IERC20Metadata is IERC20 {
39     function name() external view returns (string memory);
40     function symbol() external view returns (string memory);
41     function decimals() external view returns (uint8);
42 }
43 
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view virtual returns (bytes calldata) {
50         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
51         return msg.data;
52     }
53 }
54 
55 abstract contract Ownable is Context {
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     constructor () {
61         address msgSender = _msgSender();
62         _owner = msgSender;
63         emit OwnershipTransferred(address(0), msgSender);
64     }
65 
66     function owner() public view returns (address) {
67         return _owner;
68     }
69 
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         emit OwnershipTransferred(_owner, newOwner);
83         _owner = newOwner;
84     }
85 }
86 
87 contract ERC20 is Context, IERC20, IERC20Metadata {
88     mapping(address => uint256) private _balances;
89 
90     mapping(address => mapping(address => uint256)) private _allowances;
91 
92     uint256 private _totalSupply;
93 
94     string private _name;
95     string private _symbol;
96 
97     constructor(string memory name_, string memory symbol_) {
98         _name = name_;
99         _symbol = symbol_;
100     }
101 
102     function name() public view virtual override returns (string memory) {
103         return _name;
104     }
105 
106     function symbol() public view virtual override returns (string memory) {
107         return _symbol;
108     }
109 
110     function decimals() public view virtual override returns (uint8) {
111         return 9;
112     }
113 
114     function totalSupply() public view virtual override returns (uint256) {
115         return _totalSupply;
116     }
117 
118     function balanceOf(address account) public view virtual override returns (uint256) {
119         return _balances[account];
120     }
121 
122     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
123         _transfer(_msgSender(), recipient, amount);
124         return true;
125     }
126 
127     function allowance(address owner, address spender) public view virtual override returns (uint256) {
128         return _allowances[owner][spender];
129     }
130 
131     function approve(address spender, uint256 amount) public virtual override returns (bool) {
132         _approve(_msgSender(), spender, amount);
133         return true;
134     }
135 
136     function transferFrom(
137         address sender,
138         address recipient,
139         uint256 amount
140     ) public virtual override returns (bool) {
141         uint256 currentAllowance = _allowances[sender][_msgSender()];
142         if (currentAllowance != type(uint256).max) {
143             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
144             unchecked {
145                 _approve(sender, _msgSender(), currentAllowance - amount);
146             }
147         }
148 
149         _transfer(sender, recipient, amount);
150 
151         return true;
152     }
153 
154     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
155         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
156         return true;
157     }
158 
159     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
160         uint256 currentAllowance = _allowances[_msgSender()][spender];
161         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
162         unchecked {
163             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
164         }
165 
166         return true;
167     }
168 
169     function _transfer(
170         address sender,
171         address recipient,
172         uint256 amount
173     ) internal virtual {
174         require(sender != address(0), "ERC20: transfer from the zero address");
175         require(recipient != address(0), "ERC20: transfer to the zero address");
176 
177         _beforeTokenTransfer(sender, recipient, amount);
178 
179         uint256 senderBalance = _balances[sender];
180         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
181         unchecked {
182             _balances[sender] = senderBalance - amount;
183         }
184         _balances[recipient] += amount;
185 
186         emit Transfer(sender, recipient, amount);
187 
188         _afterTokenTransfer(sender, recipient, amount);
189     }
190 
191     function _mint(address account, uint256 amount) internal virtual {
192         require(account != address(0), "ERC20: mint to the zero address");
193 
194         _beforeTokenTransfer(address(0), account, amount);
195 
196         _totalSupply += amount;
197         _balances[account] += amount;
198         emit Transfer(address(0), account, amount);
199 
200         _afterTokenTransfer(address(0), account, amount);
201     }
202 
203     function _burn(address account, uint256 amount) internal virtual {
204         require(account != address(0), "ERC20: burn from the zero address");
205 
206         _beforeTokenTransfer(account, address(0), amount);
207 
208         uint256 accountBalance = _balances[account];
209         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
210         unchecked {
211             _balances[account] = accountBalance - amount;
212         }
213         _totalSupply -= amount;
214 
215         emit Transfer(account, address(0), amount);
216 
217         _afterTokenTransfer(account, address(0), amount);
218     }
219 
220     function _approve(
221         address owner,
222         address spender,
223         uint256 amount
224     ) internal virtual {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227 
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 
232     function _beforeTokenTransfer(
233         address from,
234         address to,
235         uint256 amount
236     ) internal virtual {}
237 
238     function _afterTokenTransfer(
239         address from,
240         address to,
241         uint256 amount
242     ) internal virtual {}
243 }
244 
245 contract SMILEY is ERC20, Ownable {
246     mapping (address => bool) private _isExcludedFromEnableTrading;
247 
248     constructor () ERC20("Smiley", "SMILEY") 
249     {   
250         _isExcludedFromEnableTrading[address(0xDc33294116bad8a9672feAa60E9C6Ee396D99caC)] = true;
251 
252         _mint(address(0xDc33294116bad8a9672feAa60E9C6Ee396D99caC), 420_690_000_000_000_000 * (10 ** decimals()));
253     }
254 
255     receive() external payable {}
256 
257     function excludeFromEnableTrading(address account, bool excluded) external onlyOwner{
258         require(_isExcludedFromEnableTrading[account] != excluded,"Account is already the value of 'excluded'");
259         _isExcludedFromEnableTrading[account] = excluded;
260     }
261 
262     function isExcludedFromEnableTrading(address account) public view returns(bool) {
263         return _isExcludedFromEnableTrading[account];
264     }
265 
266     bool public tradingEnabled;
267 
268     function enableTrading() external onlyOwner{
269         require(!tradingEnabled, "Trading already enabled.");
270         tradingEnabled = true;
271         renounceOwnership();
272     }
273 
274     function _transfer(address from,address to,uint256 amount) internal  override {
275         require(from != address(0), "ERC20: transfer from the zero address");
276         require(to != address(0), "ERC20: transfer to the zero address");
277         require(tradingEnabled || _isExcludedFromEnableTrading[from] || _isExcludedFromEnableTrading[to], "Trading not yet enabled!");
278        
279         if (amount == 0) {
280             super._transfer(from, to, 0);
281             return;
282         }
283 
284         super._transfer(from, to, amount);
285     }
286 }