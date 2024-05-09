1 // SPDX-License-Identifier: MIT
2 
3 // Twitter: https://twitter.com/dipcoin_eth
4 // Website: https://www.dipcoin.io/ 
5 
6 pragma solidity 0.8.20;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         this;
15         return msg.data;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address account) external view returns (uint256);
23 
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     function allowance(address owner, address spender) external view returns (uint256);
27 
28     function approve(address spender, uint256 amount) external returns (bool);
29 
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 interface IERC20Metadata is IERC20 {
38     function name() external view returns (string memory);
39 
40     function symbol() external view returns (string memory);
41 
42     function decimals() external view returns (uint8);
43 }
44 
45 contract ERC20 is Context, IERC20, IERC20Metadata {
46     mapping(address => uint256) internal _balances;
47 
48     mapping(address => mapping(address => uint256)) internal _allowances;
49 
50     uint256 private _totalSupply;
51 
52     string private _name;
53     string private _symbol;
54 
55     constructor(string memory name_, string memory symbol_) {
56         _name = name_;
57         _symbol = symbol_;
58     }
59 
60     function name() public view virtual override returns (string memory) {
61         return _name;
62     }
63 
64     function symbol() public view virtual override returns (string memory) {
65         return _symbol;
66     }
67 
68     function decimals() public view virtual override returns (uint8) {
69         return 18;
70     }
71 
72     function totalSupply() public view virtual override returns (uint256) {
73         return _totalSupply;
74     }
75 
76     function balanceOf(address account) public view virtual override returns (uint256) {
77         return _balances[account];
78     }
79 
80     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
81         _transfer(_msgSender(), recipient, amount);
82         return true;
83     }
84 
85     function allowance(address owner, address spender) public view virtual override returns (uint256) {
86         return _allowances[owner][spender];
87     }
88 
89     function approve(address spender, uint256 amount) public virtual override returns (bool) {
90         _approve(_msgSender(), spender, amount);
91         return true;
92     }
93 
94     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
95         _transfer(sender, recipient, amount);
96 
97         uint256 currentAllowance = _allowances[sender][_msgSender()];
98         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
99         _approve(sender, _msgSender(), currentAllowance - amount);
100 
101         return true;
102     }
103 
104     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
105         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
106         return true;
107     }
108 
109     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
110         uint256 currentAllowance = _allowances[_msgSender()][spender];
111         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
112         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
113 
114         return true;
115     }
116 
117     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
118         require(sender != address(0), "ERC20: transfer from the zero address");
119         require(recipient != address(0), "ERC20: transfer to the zero address");
120 
121         _beforeTokenTransfer(sender, recipient, amount);
122 
123         uint256 senderBalance = _balances[sender];
124         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
125         _balances[sender] = senderBalance - amount;
126         _balances[recipient] += amount;
127 
128         emit Transfer(sender, recipient, amount);
129     }
130 
131     function _mint(address account, uint256 amount) internal virtual {
132         require(account != address(0), "ERC20: mint to the zero address");
133 
134         _beforeTokenTransfer(address(0), account, amount);
135 
136         _totalSupply += amount;
137         _balances[account] += amount;
138         emit Transfer(address(0), account, amount);
139     }
140 
141     function _burn(address account, uint256 amount) internal virtual {
142         require(account != address(0), "ERC20: burn from the zero address");
143 
144         _beforeTokenTransfer(account, address(0), amount);
145 
146         uint256 accountBalance = _balances[account];
147         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
148         _balances[account] = accountBalance - amount;
149         _totalSupply -= amount;
150 
151         emit Transfer(account, address(0), amount);
152     }
153 
154     function _approve(address owner, address spender, uint256 amount) internal virtual {
155         require(owner != address(0), "ERC20: approve from the zero address");
156         require(spender != address(0), "ERC20: approve to the zero address");
157 
158         _allowances[owner][spender] = amount;
159         emit Approval(owner, spender, amount);
160     }
161 
162     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
163 }
164 
165 library Address {
166     function sendValue(address payable recipient, uint256 amount) internal {
167         require(address(this).balance >= amount, "Address: insufficient balance");
168 
169         (bool success, ) = recipient.call{value: amount}("");
170         require(success, "Address: unable to send value, recipient may have reverted");
171     }
172 }
173 
174 abstract contract Ownable is Context {
175     address private _owner;
176 
177     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
178 
179     constructor() {
180         _setOwner(_msgSender());
181     }
182 
183     function owner() public view virtual returns (address) {
184         return _owner;
185     }
186 
187     modifier onlyOwner() {
188         require(owner() == _msgSender(), "Ownable: caller is not the owner");
189         _;
190     }
191 
192     function renounceOwnership() public virtual onlyOwner {
193         _setOwner(address(0));
194     }
195 
196     function transferOwnership(address newOwner) public virtual onlyOwner {
197         require(newOwner != address(0), "Ownable: new owner is the zero address");
198         _setOwner(newOwner);
199     }
200 
201     function _setOwner(address newOwner) private {
202         address oldOwner = _owner;
203         _owner = newOwner;
204         emit OwnershipTransferred(oldOwner, newOwner);
205     }
206 }
207 
208 interface IFactory {
209     function createPair(address tokenA, address tokenB) external returns (address pair);
210 }
211 
212 interface IRouter {
213     function factory() external pure returns (address);
214 
215     function WETH() external pure returns (address);
216 }
217 
218 contract Dipcoin is ERC20, Ownable {
219     using Address for address payable;
220 
221     IRouter public router;
222     address public pair;
223 
224     bool public tradingEnabled;
225     bool public maxApeEnabled;
226 
227     uint256 public genesis_block;
228     uint256 public deadblocks = 0;
229 
230     uint256 public maxTxAmount;
231     uint256 public maxWalletAmount;
232 
233     address public marketingWallet;
234     address public dipWallet = 0x1E006513E13F08BBbF3690Dd5c2f470cd26313cD;
235 
236     mapping(address => bool) public excludedFromFees;
237     mapping(address => bool) private isBot;
238 
239     constructor() ERC20("Dipcoin", "DIP") {
240         _mint(msg.sender, 20e9 * 10 ** decimals());
241         excludedFromFees[msg.sender] = true;
242 
243         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
244         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
245         marketingWallet = 0x12eF093Ae6ab6D281f05bf5e9550485C0371fdBA;
246 
247         router = _router;
248         pair = _pair;
249         excludedFromFees[address(this)] = true;
250         excludedFromFees[marketingWallet] = true;
251         excludedFromFees[dipWallet] = true;
252         maxApeEnabled = false;
253 
254         maxTxAmount = (totalSupply() * 1) / 100;
255         maxWalletAmount = (totalSupply() * 1) / 100;
256     }
257 
258     function _transfer(address sender, address recipient, uint256 amount) internal override {
259         require(amount > 0, "Transfer amount must be greater than zero");
260         require(!isBot[sender] && !isBot[recipient], "You can't transfer tokens");
261 
262         if (!excludedFromFees[sender] && !excludedFromFees[recipient]) {
263             require(tradingEnabled, "Trading not active yet");
264 
265             if(genesis_block + deadblocks > block.number){
266                 if(recipient != pair) isBot[recipient] = true;
267                 if(sender != pair) isBot[sender] = true;
268             }
269             
270             if (maxApeEnabled) {
271             require(amount <= maxTxAmount, "You are exceeding maxTxAmount");
272                 if(recipient != pair){
273                     require(balanceOf(recipient) + amount <= maxWalletAmount, "You are exceeding maxWalletAmount");
274                 }
275             }
276         }
277         super._transfer(sender, recipient, amount);
278     }
279 
280     function enableTrading(uint256 numOfDeadBlocks) external onlyOwner {
281         require(!tradingEnabled, "Trading already active");
282         tradingEnabled = true;
283         genesis_block = block.number;
284         deadblocks = numOfDeadBlocks;
285         maxApeEnabled = true;
286     }
287 
288     function updateMarketingWallet(address newWallet) external onlyOwner {
289         marketingWallet = newWallet;
290     }
291 
292     function updateRouterAndPair(IRouter _router, address _pair) external onlyOwner {
293         router = _router;
294         pair = _pair;
295     }
296 
297     function addBots(address[] memory isBot_) public onlyOwner {
298         for (uint i = 0; i < isBot_.length; i++) {
299             isBot[isBot_[i]] = true;
300         }
301     }
302 
303     function updateEnableMaxApe(bool _value) external onlyOwner {
304         maxApeEnabled = _value;
305     }
306 
307     function updateExcludedFromFees(address _address, bool state) external onlyOwner {
308         excludedFromFees[_address] = state;
309     }
310 
311     function updateMaxTxAmount(uint256 _percen) external onlyOwner {
312         maxTxAmount = (totalSupply() * _percen) / 100;
313     }
314 
315     function updateMaxWalletAmount(uint256 _percen) external onlyOwner {
316         maxWalletAmount = (totalSupply() * _percen) / 100;
317     }
318 
319     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner {
320         IERC20(tokenAddress).transfer(owner(), amount);
321     }
322 
323     function rescueETH(uint256 weiAmount) external onlyOwner {
324         payable(owner()).sendValue(weiAmount);
325     }
326 
327     // fallbacks
328     receive() external payable {}
329 }