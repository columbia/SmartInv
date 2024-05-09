1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this;
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 interface IYZYVault {
28     function balanceOf(address account) external view returns (uint256);
29     function addTaxFee(uint256 amount) external returns (bool);
30 }
31 
32 abstract contract Ownable is Context {
33     address private _owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     constructor () {
38         address msgSender = _msgSender();
39         _owner = msgSender;
40         emit OwnershipTransferred(address(0), msgSender);
41     }
42 
43     function owner() public view returns (address) {
44         return _owner;
45     }
46 
47     modifier onlyOwner() {
48         require(_owner == _msgSender(), "Ownable: caller is not the owner");
49         _;
50     }
51 
52     function renounceOwnership() public virtual onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         emit OwnershipTransferred(_owner, newOwner);
60         _owner = newOwner;
61     }
62 }
63 
64 library SafeMath {
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68 
69         return c;
70     }
71 
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97 
98     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99         require(b > 0, errorMessage);
100         uint256 c = a / b;
101         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102 
103         return c;
104     }
105 
106     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
107         return mod(a, b, "SafeMath: modulo by zero");
108     }
109 
110     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
111         require(b != 0, errorMessage);
112         return a % b;
113     }
114 }
115 
116 /**
117  * 'YZY' token contract
118  *
119  * Name        : YZY DAO
120  * Symbol      : YZY
121  * Total supply: 11,000 (11 thousands)
122  * Decimals    : 18
123  *
124  * ERC20 Token, with the Burnable, Pausable and Ownable from OpenZeppelin
125  */
126 contract YZYToken is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128 
129     mapping(address => uint256) private _balances;
130     mapping(address => mapping(address => uint256)) private _allowances;
131 
132     uint256 private _totalSupply;
133 
134     string private _name;
135     string private _symbol;
136     uint8 private _decimals;
137 
138     uint16 public _taxFee;
139     address public _vault;
140     address private _vaultTokenOwner;
141     address private _uniswapTokenOwner;
142     address private _presaleTokenOwner;
143     address private _uniswapV2Router;
144 
145     uint8 private _initialMaxTransfers;
146     uint256 private _initialMaxTransferAmount;
147 
148     modifier onlyVault() {
149         require(
150             _vault == _msgSender(),
151             "Ownable: caller is not vault"
152         );
153         _;
154     }
155 
156     event ChangedTaxFee(address indexed owner, uint16 fee);
157     event ChangedVault(address indexed owner, address indexed oldAddress, address indexed newAddress);
158     event ChangedInitialMaxTransfers(address indexed owner, uint8 count);
159 
160     constructor(address uniswapTokenOwner, address presaleTokenOwner, address vaultTokenOwner) {
161         _name = "YZY DAO";
162         _symbol = "YZY";
163         _decimals = 18;
164 
165         _uniswapTokenOwner = uniswapTokenOwner;
166         _presaleTokenOwner = presaleTokenOwner;
167         _vaultTokenOwner = vaultTokenOwner;
168         _uniswapV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
169 
170         // set initial tax fee(transfer) fee as 2%
171         // It is allow 2 digits under point
172         _taxFee = 200;
173         _initialMaxTransfers = 50;
174         _initialMaxTransferAmount = 17e17; // initial around  0.2 eth(1.7 YZY)
175 
176         // Uniswap pool 100
177         _mint(_uniswapTokenOwner, 100E18);
178         // Farming 9900
179         _mint(_vaultTokenOwner, 9900E18);
180         // presale 1000
181         _mint(_presaleTokenOwner, 1000E18);
182     }
183 
184     function name() public view returns (string memory) {
185         return _name;
186     }
187 
188     function symbol() public view returns (string memory) {
189         return _symbol;
190     }
191 
192     function decimals() public view returns (uint8) {
193         return _decimals;
194     }
195 
196     function totalSupply() public view override returns (uint256) {
197         return _totalSupply;
198     }
199 
200     function balanceOf(address account) public view override returns (uint256) {
201         return _balances[account];
202     }
203 
204     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
205         if (_checkWithoutFee()) {
206             _transfer(_msgSender(), recipient, amount);
207         } else {
208             uint256 taxAmount = amount.mul(uint256(_taxFee)).div(10000);
209             uint256 leftAmount = amount.sub(taxAmount);
210             _transfer(_msgSender(), _vault, taxAmount);
211             _transfer(_msgSender(), recipient, leftAmount);
212 
213             IYZYVault(_vault).addTaxFee(taxAmount);
214         }
215 
216         return true;
217     }
218 
219     function allowance(address owner, address spender) public view virtual override returns (uint256) {
220         return _allowances[owner][spender];
221     }
222 
223     function approve(address spender, uint256 amount) public virtual override returns (bool) {
224         _approve(_msgSender(), spender, amount);
225         return true;
226     }
227 
228     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
229         if (_checkWithoutFee()) {
230             _transfer(sender, recipient, amount);
231         } else {
232             uint256 feeAmount = amount.mul(uint256(_taxFee)).div(10000);
233             uint256 leftAmount = amount.sub(feeAmount);
234 
235             _transfer(sender, _vault, feeAmount);
236             _transfer(sender, recipient, leftAmount);
237             IYZYVault(_vault).addTaxFee(feeAmount);
238         }
239         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
240 
241         return true;
242     }
243 
244     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
245         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
246         return true;
247     }
248 
249     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
250         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
251         return true;
252     }
253 
254     function setTaxFee(uint16 fee) external onlyOwner {
255         _taxFee = fee;
256         emit ChangedTaxFee(_msgSender(), fee);
257     }
258 
259     function setVault(address vault) external onlyOwner {
260         require(vault != address(0), "Invalid vault contract address");
261         address oldAddress = _vault;
262         _vault = vault;
263         emit ChangedVault(_msgSender(), oldAddress, _vault);
264     }
265 
266     function setInitialMaxTransfers(uint8 count) external onlyOwner {
267         _initialMaxTransfers = count;
268         emit ChangedInitialMaxTransfers(_msgSender(), count);
269     }
270 
271     function burnFromVault(uint256 amount) external onlyVault returns (bool) {
272         _burn(_vault, amount);
273         return true;
274     }
275 
276     function _burn(address account, uint256 amount) internal virtual {
277         require(account != address(0), "ERC20: burn from the zero address");
278 
279         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
280         _totalSupply = _totalSupply.sub(amount);
281         emit Transfer(account, address(0), amount);
282     }
283 
284     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
285         require(sender != address(0), "ERC20: transfer from the zero address");
286         require(recipient != address(0), "ERC20: transfer to the zero address");
287 
288         if (recipient != _vault) { // for anti-bot
289             if (sender != _vault && sender != _uniswapTokenOwner && sender != _presaleTokenOwner && sender != _vaultTokenOwner) {
290                 if (_initialMaxTransfers != 0) {
291                     require(amount <= _initialMaxTransferAmount, "Can't transfer more than 1.7 YZY for initial 50 times.");
292                     _initialMaxTransfers--;
293                 }
294             }
295         }
296 
297         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
298         _balances[recipient] = _balances[recipient].add(amount);
299         emit Transfer(sender, recipient, amount);
300     }
301 
302     function _mint(address account, uint256 amount) internal virtual {
303         require(account != address(0), "ERC20: mint to the zero address");
304 
305         _totalSupply = _totalSupply.add(amount);
306         _balances[account] = _balances[account].add(amount);
307         emit Transfer(address(0), account, amount);
308     }
309 
310     function _approve(address owner, address spender, uint256 amount) internal virtual {
311         require(owner != address(0), "ERC20: approve from the zero address");
312         require(spender != address(0), "ERC20: approve to the zero address");
313 
314         _allowances[owner][spender] = amount;
315         emit Approval(owner, spender, amount);
316     }
317 
318     function _checkWithoutFee() internal view returns (bool) {
319         if (_msgSender() == _vault || _msgSender() == _presaleTokenOwner ||
320             _msgSender() == _uniswapTokenOwner || _msgSender() == _vaultTokenOwner) {
321             return true;
322         } else {
323             return false;
324         }
325     }
326 }