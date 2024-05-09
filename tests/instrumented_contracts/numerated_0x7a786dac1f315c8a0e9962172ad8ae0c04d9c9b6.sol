1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return payable(msg.sender);
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this;
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     constructor() {
21         _transferOwnership(_msgSender());
22     }
23 
24     modifier onlyOwner() {
25         _checkOwner();
26         _;
27     }
28 
29     function owner() public view virtual returns (address) {
30         return _owner;
31     }
32 
33     function _checkOwner() internal view virtual {
34         require(owner() == _msgSender(), "Ownable: caller is not the owner");
35     }
36 
37     function renounceOwnership() public virtual onlyOwner {
38         _transferOwnership(address(0));
39     }
40 
41     function transferOwnership(address newOwner) public virtual onlyOwner {
42         require(newOwner != address(0), "Ownable: new owner is the zero address");
43         _transferOwnership(newOwner);
44     }
45 
46     function _transferOwnership(address newOwner) internal virtual {
47         address oldOwner = _owner;
48         _owner = newOwner;
49         emit OwnershipTransferred(oldOwner, newOwner);
50     }
51 }
52 
53 interface IERC20 {
54     function totalSupply() external view returns (uint256);
55     function balanceOf(address account) external view returns (uint256);
56     function transfer(address recipient, uint256 amount) external returns (bool);
57     function allowance(address owner, address spender) external view returns (uint256);
58     function approve(address spender, uint256 amount) external returns (bool);
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 library SafeMath {
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68         return c;
69     }
70 
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78         return c;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
95         require(b > 0, errorMessage);
96         uint256 c = a / b;
97         return c;
98     }
99 
100     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
101         return mod(a, b, "SafeMath: modulo by zero");
102     }
103 
104     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b != 0, errorMessage);
106         uint256 c = a % b;
107         return c;
108     }
109 }
110 
111 contract ERC20 is Context, IERC20 {
112     using SafeMath for uint256;
113 
114     mapping (address => uint256) private _balances;
115     mapping (address => mapping (address => uint256)) private _allowances;
116 
117     uint256 private _totalSupply;
118 
119     string private _name;
120     string private _symbol;
121 
122     constructor (string memory name_, string memory symbol_) {
123         _name = name_;
124         _symbol = symbol_;
125     }
126 
127     function name() public view virtual returns (string memory) {
128         return _name;
129     }
130 
131     function symbol() public view virtual returns (string memory) {
132         return _symbol;
133     }
134 
135     function decimals() public view virtual returns (uint8) {
136         return 18;
137     }
138 
139     function totalSupply() public view virtual override returns (uint256) {
140         return _totalSupply;
141     }
142 
143     function balanceOf(address account) public view virtual override returns (uint256) {
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
198     function _approve(address owner, address spender, uint256 amount) internal virtual {
199         require(owner != address(0), "ERC20: approve from the zero address");
200         require(spender != address(0), "ERC20: approve to the zero address");
201 
202         _allowances[owner][spender] = amount;
203         emit Approval(owner, spender, amount);
204     }
205 
206     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
207 }
208 
209 contract MEMDToken is ERC20, Ownable {
210     uint256 public preventSniperBlock;
211     uint256 public maxPurchaseBlock;
212     uint256 public maxPurchaseAmount;
213 
214     address public uniswapV2PairAddress;
215 
216     bool public isTradeEnabled;
217 
218     mapping(address => bool) public prevented;
219     mapping(address => uint) public lastTxBlockNumber;
220 
221     constructor(uint256 _launchBlock, uint256 _maxPurchaseBlock, uint256 _maxPurchaseAmount) ERC20("MemeDAO", "MEMD") {
222         _mint(msg.sender, 420690000000000 * (10 ** 18));
223         
224         preventSniperBlock = _launchBlock;
225         maxPurchaseBlock = _maxPurchaseBlock;
226         maxPurchaseAmount = _maxPurchaseAmount * (10 ** 18);
227         isTradeEnabled = false;
228     }
229 
230     function _transfer(address sender, address recipient, uint256 amount) internal override {
231         require(isTradeEnabled || sender == owner(), "Trading is not enabled yet");
232         require(!prevented[sender], "This address is prevented");
233         require(lastTxBlockNumber[sender] < block.number, "Only one transaction per block is allowed");
234 
235         if (sender == uniswapV2PairAddress) {
236             lastTxBlockNumber[recipient] = block.number;
237 
238             if (block.number < preventSniperBlock) {
239                 prevented[recipient] = true;
240             }
241         }
242 
243         if (block.number < maxPurchaseBlock && sender == uniswapV2PairAddress && amount > maxPurchaseAmount) {
244             revert("Purchase amount exceeds the maximum limit");
245         }
246 
247         super._transfer(sender, recipient, amount);
248     }
249 
250     function setUniswapV2PairAddress(address _uniswapV2PairAddress) external onlyOwner {
251         uniswapV2PairAddress = _uniswapV2PairAddress;
252     }
253 
254     function enableTrading() external onlyOwner {
255         isTradeEnabled = true;
256     }
257 
258     function preventSniper(address _address) external onlyOwner {
259         prevented[_address] = true;
260     }
261 
262     function releaseSniper(address _address) external onlyOwner {
263         prevented[_address] = false;
264     }
265 }