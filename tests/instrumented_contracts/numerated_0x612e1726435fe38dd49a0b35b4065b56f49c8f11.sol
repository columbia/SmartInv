1 /** 
2 	   _____                  _         _____           _    __      _____  
3 	  / ____|                | |       / ____|         | |   \ \    / /__ \ 
4 	 | |     _ __ _   _ _ __ | |_ ___ | |     __ _ _ __| |_   \ \  / /   ) |
5 	 | |    | '__| | | | '_ \| __/ _ \| |    / _` | '__| __|   \ \/ /   / / 
6 	 | |____| |  | |_| | |_) | || (_) | |___| (_| | |  | |_     \  /   / /_ 
7 	  \_____|_|   \__, | .__/ \__\___/ \_____\__,_|_|   \__|     \/   |____|
8 				   __/ | |                                                  
9 				  |___/|_|                                                  
10                                                           
11    #CryptoCart V2
12    
13    Great features:
14    -2% fee auto moved to vault address
15 
16    1,000,000 total supply
17 
18 */
19 
20 
21 // SPDX-License-Identifier: Unlicensed
22 
23 pragma solidity ^0.8.9;
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address payable) {
27         return payable(msg.sender);
28     }
29 
30     function _msgData() internal view virtual returns (bytes memory) {
31         this;
32         return msg.data;
33     }
34 }
35 
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     constructor () {
42         address msgSender = _msgSender();
43         _owner = msgSender;
44         emit OwnershipTransferred(address(0), msgSender);
45     }
46     
47     function owner() public view virtual returns (address) {
48         return _owner;
49     }
50 
51     modifier onlyOwner() {
52         require(owner() == _msgSender(), "Ownable: caller is not the owner");
53         _;
54     }
55 
56     function renounceOwnership() public virtual onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 	
61     function transferOwnership(address newOwner) public virtual onlyOwner {
62         require(newOwner != address(0), "Ownable: new owner is the zero address");
63         emit OwnershipTransferred(_owner, newOwner);
64         _owner = newOwner;
65     }
66 }
67 
68 abstract contract Editor is Context {
69     address private _editor;
70 
71     event EditorRoleTransferred(address indexed previousEditor, address indexed newEditor);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _editor = msgSender;
76         emit EditorRoleTransferred(address(0), msgSender);
77     }
78     
79     function editors() public view virtual returns (address) {
80         return _editor;
81     }
82 
83     modifier onlyEditor() {
84         require(editors() == _msgSender(), "caller is not the editors");
85         _;
86     }
87 	
88     function transferEditorRole(address newEditor) public virtual onlyEditor {
89         require(newEditor != address(0), "new editor is the zero address");
90         emit EditorRoleTransferred(_editor, newEditor);
91         _editor = newEditor;
92     }
93 }
94 
95 interface IERC20 {
96    
97     function totalSupply() external view returns (uint256);
98 
99     function balanceOf(address account) external view returns (uint256);
100 
101     function transfer(address recipient, uint256 amount) external returns (bool);
102 
103     function allowance(address owner, address spender) external view returns (uint256);
104 
105     function approve(address spender, uint256 amount) external returns (bool);
106 
107     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
108 
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 contract ERC20 is Context, IERC20 {
115     using SafeMath for uint256;
116 
117     mapping (address => uint256) private _balances;
118 
119     mapping (address => mapping (address => uint256)) private _allowances;
120 
121     uint256 private _totalSupply;
122 
123     string private _name;
124     string private _symbol;
125     uint8 private _decimals;
126 
127     constructor (string memory name_, string memory symbol_) {
128         _name = name_;
129         _symbol = symbol_;
130         _decimals = 18;
131     }
132 
133     function name() public view virtual returns (string memory) {
134         return _name;
135     }
136 
137     function symbol() public view virtual returns (string memory) {
138         return _symbol;
139     }
140 
141     function decimals() public view virtual returns (uint8) {
142         return _decimals;
143     }
144 
145     function totalSupply() public view virtual override returns (uint256) {
146         return _totalSupply;
147     }
148 
149     function balanceOf(address account) public view virtual override returns (uint256) {
150         return _balances[account];
151     }
152 
153     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
154         _transfer(_msgSender(), recipient, amount);
155         return true;
156     }
157 	
158     function allowance(address owner, address spender) public view virtual override returns (uint256) {
159         return _allowances[owner][spender];
160     }
161 
162     function approve(address spender, uint256 amount) public virtual override returns (bool) {
163         _approve(_msgSender(), spender, amount);
164         return true;
165     }
166 
167     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
168         _transfer(sender, recipient, amount);
169         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
170         return true;
171     }
172 
173     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
174         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
175         return true;
176     }
177 
178     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
179         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
180         return true;
181     }
182 
183     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
184         require(sender != address(0), "ERC20: transfer from the zero address");
185         require(recipient != address(0), "ERC20: transfer to the zero address");
186         _beforeTokenTransfer(sender, recipient, amount);
187         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
188         _balances[recipient] = _balances[recipient].add(amount);
189         emit Transfer(sender, recipient, amount);
190     }
191 
192     function _mint(address account, uint256 amount) internal virtual {
193         require(account != address(0), "ERC20: mint to the zero address");
194         _beforeTokenTransfer(address(0), account, amount);
195         _totalSupply = _totalSupply.add(amount);
196         _balances[account] = _balances[account].add(amount);
197         emit Transfer(address(0), account, amount);
198     }
199 	
200     function _approve(address owner, address spender, uint256 amount) internal virtual {
201         require(owner != address(0), "ERC20: approve from the zero address");
202         require(spender != address(0), "ERC20: approve to the zero address");
203         _allowances[owner][spender] = amount;
204         emit Approval(owner, spender, amount);
205     }
206 	
207     function _setupDecimals(uint8 decimals_) internal virtual {
208         _decimals = decimals_;
209     }
210 	
211     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
212 }
213 
214 interface IUniswapV2Factory {
215     function createPair(address tokenA, address tokenB) external returns (address pair);
216 }
217 
218 interface IUniswapV2Router01 {
219 	function factory() external pure returns (address);
220 	function WETH() external pure returns (address);
221 	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
222 }
223 
224 interface IUniswapV2Router02 is IUniswapV2Router01 {
225     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
226 }
227 
228 library SafeMath {
229     function add(uint256 a, uint256 b) internal pure returns (uint256) {
230         uint256 c = a + b;
231         require(c >= a, "SafeMath: addition overflow");
232         return c;
233     }
234 	
235     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
236         require(b <= a, "SafeMath: subtraction overflow");
237         return a - b;
238     }
239 	
240     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
241         if (a == 0) return 0;
242         uint256 c = a * b;
243         require(c / a == b, "SafeMath: multiplication overflow");
244         return c;
245     }
246 	
247     function div(uint256 a, uint256 b) internal pure returns (uint256) {
248         require(b > 0, "SafeMath: division by zero");
249         return a / b;
250     }
251 	
252     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
253         require(b > 0, "SafeMath: modulo by zero");
254         return a % b;
255     }
256 	
257     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b <= a, errorMessage);
259         return a - b;
260     }
261 	
262     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b > 0, errorMessage);
264         return a / b;
265     }
266 	
267     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         require(b > 0, errorMessage);
269         return a % b;
270     }
271 }
272 
273 contract CryptoCartV2 is ERC20, Ownable, Editor {
274     using SafeMath for uint256;
275 	
276     IUniswapV2Router02 public immutable uniswapV2Router;
277     address public immutable uniswapV2Pair;
278 
279     bool private swapping;
280 	
281 	address public immutable vaultAddress;
282 	uint8 public immutable vaultFee = 200;
283 	
284     mapping (address => bool) public _isExcludedFromFees;
285     mapping (address => bool) public automatedMarketMakerPairs;
286     
287     event ExcludeFromFees(address indexed account, bool isExcluded);
288     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
289     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
290 	
291     constructor(address payable _vaultAddress) ERC20("CryptoCart V2", "CCv2") {
292 	    vaultAddress = _vaultAddress;
293 		
294         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
295 		
296         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
297 
298         uniswapV2Router = _uniswapV2Router;
299         uniswapV2Pair   = _uniswapV2Pair;
300 		
301         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
302 
303         excludeFromFees(address(this), true);
304 		excludeFromFees(owner(), true);
305         _mint(owner(), 1000000 * (10**18));
306     }
307 
308     receive() external payable {
309   	}
310 
311     function _setAutomatedMarketMakerPair(address pair, bool value) private {
312         require(automatedMarketMakerPairs[pair] != value, "CCv2: Automated market maker pair is already set to that value");
313         automatedMarketMakerPairs[pair] = value;
314         emit SetAutomatedMarketMakerPair(pair, value);
315     }
316 		
317     function excludeFromFees(address account, bool excluded) public OwnerOrEditor{
318         require(_isExcludedFromFees[account] != excluded, "CCv2: Account is already the value of 'excluded'");
319         _isExcludedFromFees[account] = excluded;
320         emit ExcludeFromFees(account, excluded);
321     }
322 		
323 	function _transfer(address from, address to, uint256 amount) internal override {
324         require(from != address(0), "ERC20: transfer from the zero address");
325         require(to != address(0), "ERC20: transfer to the zero address");
326 		
327 		if(automatedMarketMakerPairs[to])
328 		{
329 			bool takeFee = true;
330 			
331 			if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
332 				takeFee = false;
333 			}
334 			
335 			if(takeFee) 
336 			{
337 				uint256 vfees = amount.div(10000).mul(vaultFee);
338 				if(vfees > 0) {
339 				   super._transfer(from, vaultAddress, vfees);
340 				}
341 				amount = amount.sub(vfees);
342 			}
343         }
344         super._transfer(from, to, amount);
345     }
346 	
347 	modifier OwnerOrEditor() {
348         require(_msgSender() == owner() || _msgSender() == editors(), "caller is not the owner or editor");
349         _;
350     }
351 }