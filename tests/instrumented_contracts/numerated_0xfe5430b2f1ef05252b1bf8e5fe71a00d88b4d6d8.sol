1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.15;
3 pragma experimental ABIEncoderV2;
4 /*
5 
6 Bank of Tao
7 
8 https://t.me/bankoftao
9 
10 A new bank for generational wealth
11 
12 */
13 
14 abstract contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     constructor() {
20         _transferOwnership(msg.sender);
21     }
22     function owner() public view virtual returns (address) {
23         return _owner;
24     }
25     modifier onlyOwner() {
26         require(owner() == msg.sender, "Ownable: caller is not the owner");
27         _;
28     }
29 
30     function renounceOwnership() public virtual onlyOwner {
31         _transferOwnership(address(0));
32     }
33     function transferOwnership(address newOwner) public virtual onlyOwner {
34         require(newOwner != address(0), "Ownable: new owner is the zero address");
35         _transferOwnership(newOwner);
36     }
37     function _transferOwnership(address newOwner) internal virtual {
38         address oldOwner = _owner;
39         _owner = newOwner;
40         emit OwnershipTransferred(oldOwner, newOwner);
41     }
42 
43 }
44 
45 interface IERC20 {
46 
47     function balanceOf(address account) external view returns (uint256);
48     function totalSupply() external view returns (uint256);
49     function allowance(address owner, address spender) external view returns (uint256);
50     function transferFrom(
51         address sender,
52         address recipient,
53         uint256 amount
54     ) external returns (bool);
55     function approve(address spender, uint256 amount) external returns (bool);
56     function transfer(address recipient, uint256 amount) external returns (bool);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 interface IERC20Metadata is IERC20 {
62     function symbol() external view returns (string memory);
63     function name() external view returns (string memory);
64     function decimals() external view returns (uint8);
65 }
66 
67 contract ERC20 is IERC20, IERC20Metadata {
68     mapping(address => mapping(address => uint256)) private _allowances;
69     mapping(address => uint256) private _balances;
70     uint256 private _totalSupply;
71     string private _name;
72     string private _symbol;
73 
74     constructor(string memory name_, string memory symbol_) {
75         _symbol = symbol_;
76         _name = name_;
77     }
78     function symbol() public view virtual override returns (string memory) {
79         return _symbol;
80     }
81     function name() public view virtual override returns (string memory) {
82         return _name;
83     }
84     function decimals() public view virtual override returns (uint8) {
85         return 18;
86     }
87     function balanceOf(address account) public view virtual override returns (uint256) {
88         return _balances[account];
89     }
90     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
91         _transfer(msg.sender, recipient, amount);
92         return true;
93     }
94     function allowance(address owner, address spender) public view virtual override returns (uint256) {
95         return _allowances[owner][spender];
96     }
97     function totalSupply() public view virtual override returns (uint256) {
98         return _totalSupply;
99     }
100     function approve(address spender, uint256 amount) public virtual override returns (bool) {
101         _approve(msg.sender, spender, amount);
102         return true;
103     }
104     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
105         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
106         return true;
107     }
108     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
109         uint256 currentAllowance = _allowances[msg.sender][spender];
110         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
111         unchecked {
112             _approve(msg.sender, spender, currentAllowance - subtractedValue);
113         }
114 
115         return true;
116     }
117     function transferFrom(
118         address sender,
119         address recipient,
120         uint256 amount
121     ) public virtual override returns (bool) {
122         _transfer(sender, recipient, amount);
123 
124         uint256 currentAllowance = _allowances[sender][msg.sender];
125         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
126         unchecked {
127             _approve(sender, msg.sender, currentAllowance - amount);
128         }
129 
130         return true;
131     }
132     function _transfer(
133         address sender,
134         address recipient,
135         uint256 amount
136     ) internal virtual {
137         require(sender != address(0), "ERC20: transfer from the zero address");
138         require(recipient != address(0), "ERC20: transfer to the zero address");
139 
140         uint256 senderBalance = _balances[sender];
141         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
142         unchecked {
143             _balances[sender] = senderBalance - amount;
144         }
145         _balances[recipient] += amount;
146 
147         emit Transfer(sender, recipient, amount);
148 
149     }
150     function _mint(address account, uint256 amount) internal virtual {
151         require(account != address(0), "ERC20: mint to the zero address");
152 
153         _totalSupply += amount;
154         _balances[account] += amount;
155         emit Transfer(address(0), account, amount);
156     }
157 
158     function _approve(
159         address owner,
160         address spender,
161         uint256 amount
162     ) internal virtual {
163         require(owner != address(0), "ERC20: approve from the zero address");
164         require(spender != address(0), "ERC20: approve to the zero address");
165 
166         _allowances[owner][spender] = amount;
167         emit Approval(owner, spender, amount);
168     }
169 }
170 
171 interface IUniswapV2Factory {
172     function createPair(address tokenA, address tokenB) external returns (address pair);
173 }
174 
175 interface IUniswapV2Router02 {
176     function factory() external pure returns (address);
177     function WETH() external pure returns (address);
178 }
179 
180 contract BankOfTaoToken is ERC20, Ownable {
181 
182     uint256 public maxTransactionAmount;
183     uint256 public maxWallet;
184 
185     bool public limitsInEffect = true;
186 
187     mapping(address => bool) public isExcludedMaxTransactionAmount;
188     mapping(address => bool) public automatedMarketMakerPairs;
189 
190     constructor() ERC20("Bank of Tao", "BANKOFTAO") {
191         IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(
192             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
193         );
194 
195         isExcludedMaxTransactionAmount[address(uniswapV2Router)] = true;
196 
197         address uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
198         
199         isExcludedMaxTransactionAmount[uniswapV2Pair] = true;
200         automatedMarketMakerPairs[uniswapV2Pair] = true;
201 
202         uint256 totalSupply = 100_000_000 * 1e18;
203 
204         maxTransactionAmount = totalSupply * 5 / 1000;
205         maxWallet = totalSupply * 20 / 1000;
206 
207         isExcludedMaxTransactionAmount[owner()] = true;
208 
209         /*
210             _mint is an internal function in ERC20.sol that is only called here,
211             and CANNOT be called ever again
212         */
213         _mint(msg.sender, totalSupply);
214     }
215 
216     function removeLimits() external onlyOwner returns (bool) {
217         limitsInEffect = false;
218         return true;
219     }
220 
221     function _transfer(
222         address from,
223         address to,
224         uint256 amount
225     ) internal override {
226         require(from != address(0), "ERC20: transfer from the zero address");
227         require(to != address(0), "ERC20: transfer to the zero address");
228 
229         if (amount == 0) {
230             super._transfer(from, to, 0);
231             return;
232         }
233 
234         if (limitsInEffect) {
235             if (
236                 from != owner() &&
237                 to != owner()
238             ) {
239 
240                 if (
241                     automatedMarketMakerPairs[from] &&
242                     !isExcludedMaxTransactionAmount[to]
243                 ) {
244                     require(
245                         amount <= maxTransactionAmount,
246                         "!maxTransactionAmount."
247                     );
248                     require(
249                         amount + balanceOf(to) <= maxWallet,
250                         "!maxWallet"
251                     );
252                 }
253 
254                 else if (
255                     automatedMarketMakerPairs[to] &&
256                     !isExcludedMaxTransactionAmount[from]
257                 ) {
258                     require(
259                         amount <= maxTransactionAmount,
260                         "!maxTransactionAmount."
261                     );
262                 } else if (!isExcludedMaxTransactionAmount[to]) {
263                     require(
264                         amount + balanceOf(to) <= maxWallet,
265                         "!maxWallet"
266                     );
267                 }
268             }
269         }
270 
271         super._transfer(from, to, amount);
272     }
273 }