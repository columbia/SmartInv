1 /**
2  *Submitted for verification at Etherscan.io on 2023-05-11
3 */
4 
5 /*
6        
7 print 
8 */
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity 0.8.17;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 library SafeMath {
25     
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61 
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         return mod(a, b, "SafeMath: modulo by zero");
64     }
65 
66     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b != 0, errorMessage);
68         return a % b;
69     }
70 }
71 
72 interface IERC20 {
73     function totalSupply() external view returns (uint256);
74     function balanceOf(address account) external view returns (uint256);
75     function transfer(address recipient, uint256 amount) external returns (bool); 
76     function allowance(address owner, address spender) external view returns (uint256);
77     function approve(address spender, uint256 amount) external returns (bool);
78     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
79     event Transfer(address indexed from, address indexed to, uint256 value);
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 interface IERC20Metadata is IERC20 {
84     function name() external view returns (string memory);
85     function symbol() external view returns (string memory);
86     function decimals() external view returns (uint8);
87 }
88 
89 contract ERC20 is Context, IERC20, IERC20Metadata{
90     using SafeMath for uint256;
91     mapping(address => uint256) private _balances;
92     mapping(address => mapping(address => uint256)) private _allowances;
93     uint256 internal _totalSupply;
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
111         return 18;
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
136     function transferFrom(address sender, address recipient, uint256 amount 
137     ) public virtual override returns (bool) {
138         _transfer(sender, recipient, amount);
139         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount,
140                 "BEP20: transfer amount exceeds allowance"));
141         return true;
142     }
143 
144     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
145         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
146         return true;
147     }
148 
149     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
150         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue,
151                 "BEP20: decreased allowance below zero"));
152         return true;
153     }
154 
155     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
156         require(sender != address(0), "BEP20: transfer from the zero address");
157         require(recipient != address(0), "BEP20: transfer to the zero address");
158 
159         _beforeTokenTransfer(sender, recipient, amount);
160 
161         _balances[sender] = _balances[sender].sub(amount,"BEP20: transfer amount exceeds balance");
162         _balances[recipient] = _balances[recipient].add(amount);
163         emit Transfer(sender, recipient, amount);
164     }
165 
166     function _mint(address account, uint256 amount) internal virtual {
167         require(account != address(0), "BEP20: mint to the zero address");
168 
169         _beforeTokenTransfer(address(0), account, amount);
170 
171         _totalSupply = _totalSupply.add(amount);
172         _balances[account] = _balances[account].add(amount);
173         emit Transfer(address(0), account, amount);
174     }
175 
176     function _approve(address owner, address spender, uint256 amount) internal virtual {
177         require(owner != address(0), "BEP20: approve from the zero address");
178         require(spender != address(0), "BEP20: approve to the zero address");
179 
180         _allowances[owner][spender] = amount;
181         emit Approval(owner, spender, amount);
182     }
183 
184     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
185 }
186 
187 abstract contract Ownable is Context {
188 
189     address private _owner;
190 
191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193     constructor() {
194         address msgSender = _msgSender();
195         _owner = msgSender;
196         emit OwnershipTransferred(address(0), msgSender);
197     }
198 
199     function owner() public view returns (address) {
200         return _owner;
201     }
202 
203     modifier onlyOwner() {
204         require(_owner == _msgSender(), "Ownable: caller is not the owner");
205         _;
206     }
207 
208     function renounceOwnership() public virtual onlyOwner {
209         emit OwnershipTransferred(_owner, address(0));
210         _owner = address(0);
211     }
212 
213     function transferOwnership(address newOwner) public virtual onlyOwner {
214         require(newOwner != address(0), "Ownable: new owner is the zero address");
215         emit OwnershipTransferred(_owner, newOwner);
216         _owner = newOwner;
217     }
218 }
219 
220 interface IERC721 {
221 
222 
223     function category() external view returns(uint256);
224 
225     function _owner() external view returns(address payable);
226 
227     function owner() external view returns(address);
228 
229     function nftOwner(uint256 _id) external view returns (address);
230 
231     function ownerOf(uint256 _id) external view returns (address);
232 
233     function balanceOf(address account) external view returns (uint256);
234 
235     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
236 
237     function totalSupply() external view returns (uint256);
238 
239     function maxSupply() external view returns (uint256);
240 
241     function getMintPrice() external view returns(uint256);
242     
243 
244     function safeBatchTransferFrom(
245         address from,
246         address to,
247         uint256[] calldata ids,
248         uint256[] calldata values,
249         bytes calldata data
250     ) external;
251 
252     function safeTransferFrom(
253         address from,
254         address to,
255         uint256 id,
256         uint256 value,
257         bytes calldata data
258     ) external;
259 
260     function transferFrom(
261         address from,
262         address to,
263         uint256 tokenId
264     ) external;
265 }
266 
267 contract LOYAL is ERC20, Ownable { 
268     using SafeMath for uint256;
269 
270     address public DEAD = 0x000000000000000000000000000000000000dEaD;
271     IERC20 private $psyop = IERC20(0xaa07810aE08575921c476Ff088bc949da43e4964);
272     IERC721 private $PPJC = IERC721(0xEF22676fb3506b8d139F7552A1b30d172cA21410);
273 
274     
275     bool public tradingEnabled = false;
276     bool public psyopHoldersEnabled = true;
277 
278     uint256 public MIN_PSYOPS = 69000000000000000000000000;
279     uint256 public MIN_PPJC = 1;
280 
281     
282     mapping(address => bool) private canTransferBeforeTradingIsEnabled;
283     mapping(address => bool) private isWhiteListed;
284 
285     uint256 public launchtimestamp; 
286 
287     event SetPreSaleWallet(address wallet);
288     event TradingEnabled();
289     event Airdrop(address holder, uint256 amount);
290 
291     constructor() ERC20("LOYAL by PPJC", "LOYAL") { 
292         uint256 totalSupply = (69_000_000_000) * (10**18); // TOTAL SUPPLY IS SET HERE
293         _mint(owner(), totalSupply); // only time internal mint function is ever called is to create supply
294         canTransferBeforeTradingIsEnabled[owner()] = true;
295         canTransferBeforeTradingIsEnabled[address(this)] = true;
296     }
297 
298     function decimals() public view virtual override returns (uint8) {
299         return 18;
300     }
301 
302     receive() external payable {}
303 
304     function enableTrading() external onlyOwner {
305         require(!tradingEnabled);
306 
307         tradingEnabled = true;
308         launchtimestamp = block.timestamp;
309         emit TradingEnabled();
310     }
311 
312     function psyopHoldersOnlyDisable(bool status) external onlyOwner {
313         require(!tradingEnabled, "LOYAL: Trading has not yet been enabled");          
314         psyopHoldersEnabled = status;
315     }
316 
317     function setCanTransferBefore(address wallet, bool enable) external onlyOwner {
318         canTransferBeforeTradingIsEnabled[wallet] = enable;
319     }
320 
321     function setLimits(uint256 minPsyop, uint256 minPPJC) external onlyOwner {
322         MIN_PSYOPS = minPsyop;
323         MIN_PPJC = minPPJC;
324     }
325 
326     function setWhiteLists(address[] memory wallets, bool allowed) external onlyOwner {
327         for(uint256 i; i < wallets.length; i++) {
328             isWhiteListed[wallets[i]] = allowed;
329         }
330     }
331 
332 
333     function Sweep() external onlyOwner {
334         uint256 amountETH = address(this).balance;
335         payable(msg.sender).transfer(amountETH);
336     }
337 
338 
339     function _transfer(address from, address to, uint256 amount) internal override {
340 
341         require(from != address(0), "IERC20: transfer from the zero address");
342         require(to != address(0), "IERC20: transfer to the zero address");
343 
344  
345 
346         if(psyopHoldersEnabled) {
347             if($psyop.balanceOf(to) >= MIN_PSYOPS || $PPJC.balanceOf(to) >= MIN_PPJC || isWhiteListed[to] == true || canTransferBeforeTradingIsEnabled[from]) {
348 
349             } else {
350                 require(tradingEnabled, "LOYAL: Trading has not yet been enabled");          
351             }
352         }
353      
354         if (amount == 0) {
355             super._transfer(from, to, 0);
356             return;
357         } 
358 
359         if (to == DEAD) {
360             super._transfer(from, to, amount);
361             _totalSupply = _totalSupply.sub(amount);
362             return;
363         }
364 
365         super._transfer(from, to, amount);
366     }
367 
368 
369     function airdropToWallets(
370         address[] memory airdropWallets,
371         uint256[] memory amount
372     ) external onlyOwner {
373         require(airdropWallets.length == amount.length, "Arrays must be the same length");
374         require(airdropWallets.length <= 200, "Wallets list length must be <= 200");
375         for (uint256 i = 0; i < airdropWallets.length; i++) {
376             address wallet = airdropWallets[i];
377             uint256 airdropAmount = amount[i] * (10**18);
378             super._transfer(msg.sender, wallet, airdropAmount);
379         }
380     }
381 }