1 // SPDX-License-Identifier: MIT
2 
3 /**
4 Coded with love <3 
5 
6 Telegram: https://t.me/ShitcoinCorp
7 Twitter: https://twitter.com/ShitcoinCorp
8 Website: https://www.shitcoincorp.xyz/
9 
10 Tokenomics:
11 85% liqudity
12 10% presale
13 5% team
14 
15 Liquidity permalocked until 26 May 2023!
16 
17 NO TAX!!!
18 
19 BOT PROTECTION!
20 */
21 
22 
23 pragma solidity ^0.8.0;
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 pragma solidity ^0.8.0;
36 
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     constructor() {
43         _transferOwnership(_msgSender());
44     }
45 
46     function owner() public view virtual returns (address) {
47         return _owner;
48     }
49 
50     modifier onlyOwner() {
51         require(owner() == _msgSender(), "Ownable: caller is not the owner");
52         _;
53     }
54     function renounceOwnership() public virtual onlyOwner {
55         _transferOwnership(address(0));
56     }
57 
58     function transferOwnership(address newOwner) public virtual onlyOwner {
59         require(newOwner != address(0), "Ownable: new owner is the zero address");
60         _transferOwnership(newOwner);
61     }
62 
63     function _transferOwnership(address newOwner) internal virtual {
64         address oldOwner = _owner;
65         _owner = newOwner;
66         emit OwnershipTransferred(oldOwner, newOwner);
67     }
68 }
69 
70 pragma solidity ^0.8.0;
71 
72 interface IERC20 {
73     function totalSupply() external view returns (uint256);
74     function balanceOf(address account) external view returns (uint256);
75     function transfer(address recipient, uint256 amount) external returns (bool);
76     function allowance(address owner, address spender) external view returns (uint256);
77     function approve(address spender, uint256 amount) external returns (bool);
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83     event Transfer(address indexed from, address indexed to, uint256 value);
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 pragma solidity ^0.8.0;
88 
89 interface IERC20Metadata is IERC20 {
90     function name() external view returns (string memory);
91     function symbol() external view returns (string memory);
92     function decimals() external view returns (uint8);
93 }
94 
95 pragma solidity ^0.8.0;
96 
97 contract ERC20 is Context, IERC20, IERC20Metadata {
98     mapping(address => uint256) private _balances;
99     mapping(address => mapping(address => uint256)) private _allowances;
100     uint256 private _totalSupply;
101     string private _name;
102     string private _symbol;
103 
104     constructor(string memory name_, string memory symbol_) {
105         _name = name_;
106         _symbol = symbol_;
107     }
108 
109     function name() public view virtual override returns (string memory) {
110         return _name;
111     }
112 
113     function symbol() public view virtual override returns (string memory) {
114         return _symbol;
115     }
116 
117     function decimals() public view virtual override returns (uint8) {
118         return 18;
119     }
120 
121     function totalSupply() public view virtual override returns (uint256) {
122         return _totalSupply;
123     }
124 
125     function balanceOf(address account) public view virtual override returns (uint256) {
126         return _balances[account];
127     }
128 
129     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
130         _transfer(_msgSender(), recipient, amount);
131         return true;
132     }
133 
134     function allowance(address owner, address spender) public view virtual override returns (uint256) {
135         return _allowances[owner][spender];
136     }
137 
138     function approve(address spender, uint256 amount) public virtual override returns (bool) {
139         _approve(_msgSender(), spender, amount);
140         return true;
141     }
142 
143     function transferFrom(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) public virtual override returns (bool) {
148         _transfer(sender, recipient, amount);
149         uint256 currentAllowance = _allowances[sender][_msgSender()];
150         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
151         unchecked {
152             _approve(sender, _msgSender(), currentAllowance - amount);
153         }
154         return true;
155     }
156 
157     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
158         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
159         return true;
160     }
161 
162     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
163         uint256 currentAllowance = _allowances[_msgSender()][spender];
164         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
165         unchecked {
166             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
167         }
168         return true;
169     }
170 
171     function _transfer(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) internal virtual {
176         require(sender != address(0), "ERC20: transfer from the zero address");
177         require(recipient != address(0), "ERC20: transfer to the zero address");
178         _beforeTokenTransfer(sender, recipient, amount);
179         uint256 senderBalance = _balances[sender];
180         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
181         unchecked {
182             _balances[sender] = senderBalance - amount;
183         }
184         _balances[recipient] += amount;
185         emit Transfer(sender, recipient, amount);
186         _afterTokenTransfer(sender, recipient, amount);
187     }
188 
189     function _mint(address account, uint256 amount) internal virtual {
190         require(account != address(0), "ERC20: mint to the zero address");
191         _beforeTokenTransfer(address(0), account, amount);
192         _totalSupply += amount;
193         _balances[account] += amount;
194         emit Transfer(address(0), account, amount);
195         _afterTokenTransfer(address(0), account, amount);
196     }
197 
198     function _burn(address account, uint256 amount) internal virtual {
199         require(account != address(0), "ERC20: burn from the zero address");
200         _beforeTokenTransfer(account, address(0), amount);
201         uint256 accountBalance = _balances[account];
202         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
203         unchecked {
204             _balances[account] = accountBalance - amount;
205         }
206         _totalSupply -= amount;
207         emit Transfer(account, address(0), amount);
208         _afterTokenTransfer(account, address(0), amount);
209     }
210 
211     function _approve(
212         address owner,
213         address spender,
214         uint256 amount
215     ) internal virtual {
216         require(owner != address(0), "ERC20: approve from the zero address");
217         require(spender != address(0), "ERC20: approve to the zero address");
218         _allowances[owner][spender] = amount;
219         emit Approval(owner, spender, amount);
220     }
221 
222     function _beforeTokenTransfer(
223         address from,
224         address to,
225         uint256 amount
226     ) internal virtual {}
227 
228     function _afterTokenTransfer(
229         address from,
230         address to,
231         uint256 amount
232     ) internal virtual {}
233 }
234 
235 pragma solidity ^0.8.0;
236 
237 contract ShitCoin is Ownable, ERC20 {
238     uint256 public maxHoldingAmount;
239     address public pair;
240     address public router;
241     bool public transferDelay;
242 
243     mapping(address => uint256) private _holderLastTransferTimestamp;
244 
245     constructor(uint256 _totalSupply) ERC20("ShitcoinCorp", "HIT") {
246         _mint(msg.sender, _totalSupply);
247         maxHoldingAmount = _totalSupply / 100;
248         transferDelay = true;
249         router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
250     }
251 
252     function setPair(address _pair) external onlyOwner {
253         pair = _pair;
254     }
255 
256     function setRouter(address _routerAddress) external onlyOwner {
257         router = _routerAddress;
258     }
259 
260     function setMaxWallet(uint256 _maxHoldingAmount) external onlyOwner {
261         maxHoldingAmount = _maxHoldingAmount;
262     }
263 
264     function disableTransferDelay() external onlyOwner {
265         transferDelay = false;
266     }
267 
268     function _beforeTokenTransfer(
269         address from,
270         address to,
271         uint256 amount
272     ) override internal virtual {
273         if (pair == address(0)) {
274             require(from == owner() || to == owner(), "are you stupid, you can't trade shit yet");
275             return;
276         }
277         if (from == router || from == pair) require(super.balanceOf(to) + amount <= maxHoldingAmount, "shit, you fat whale already");
278         if (transferDelay) {
279             if (
280                 to != owner() &&
281                 to != router &&
282                 to != pair
283             ) {
284                 require(
285                     _holderLastTransferTimestamp[tx.origin] + 2 <
286                         block.number,
287                     "_transfer: Shit, 1 purchase per 3 blocks allowed."
288                 );
289                 _holderLastTransferTimestamp[tx.origin] = block.number;
290             }
291         }
292     }
293 }