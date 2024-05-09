1 //  ______ __  __  ____       _ _____ 
2 // |  ____|  \/  |/ __ \     | |_   _|   _____  
3 // | |__  | \  / | |  | |    | | | |    /     \ 
4 // |  __| | |\/| | |  | |_   | | | |   |   ^_^ |
5 // | |____| |  | | |__| | |__| |_| |_  |  \___/ 
6 // |______|_|  |_|\____/ \____/|_____|  \_____/
7 
8 // Twitter: https://twitter.com/emojicoineth
9 // Telegram: https://t.me/emoji_meme
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity ^0.8.6;
14 pragma experimental ABIEncoderV2;
15 
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30     
31     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
32         unchecked {
33             uint256 c = a + b;
34             if (c < a) return (false, 0);
35             return (true, c);
36         }
37     }
38 
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b > a) return (false, 0);
42             return (true, a - b);
43         }
44     }
45 
46     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             if (a == 0) return (true, 0);
49             uint256 c = a * b;
50             if (c / a != b) return (false, 0);
51             return (true, c);
52         }
53     }
54 
55     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
56         unchecked {
57             if (b == 0) return (false, 0);
58             return (true, a / b);
59         }
60     }
61 
62     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         unchecked {
64             if (b == 0) return (false, 0);
65             return (true, a % b);
66         }
67     }
68 
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         return a + b;
71     }
72 
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return a - b;
75     }
76 
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         return a * b;
79     }
80 
81     function div(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a / b;
83     }
84 
85     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86         return a % b;
87     }
88 
89     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         unchecked {
91             require(b <= a, errorMessage);
92             return a - b;
93         }
94     }
95 
96     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         unchecked {
98             require(b > 0, errorMessage);
99             return a / b;
100         }
101     }
102 
103     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         unchecked {
105             require(b > 0, errorMessage);
106             return a % b;
107         }
108     }
109 }
110 
111 abstract contract Context {
112     function _msgSender() internal view virtual returns (address) {
113         return msg.sender;
114     }
115 
116     function _msgData() internal view virtual returns (bytes calldata) {
117         return msg.data;
118     }
119 }
120 
121 abstract contract Ownable is Context {
122     address private _owner;
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125     constructor() {
126         _setOwner(_msgSender());
127     }
128 
129     function owner() public view virtual returns (address) {
130         return _owner;
131     }
132 
133     modifier onlyOwner() {
134         require(owner() == _msgSender(), "Ownable: caller is not the owner");
135         _;
136     }
137 
138     function renounceOwnership() public virtual onlyOwner {
139         _setOwner(address(0));
140     }
141 
142     function transferOwnership(address newOwner) public virtual onlyOwner {
143         require(newOwner != address(0), "Ownable: new owner is the zero address");
144         _setOwner(newOwner);
145     }
146 
147     function _setOwner(address newOwner) private {
148         address oldOwner = _owner;
149         _owner = newOwner;
150         emit OwnershipTransferred(oldOwner, newOwner);
151     }
152 }
153 
154 interface IUniswapV2Factory {
155     function createPair(address tokenA, address tokenB)
156         external
157         returns (address pair);
158 }
159 
160 interface IUniswapV2Router02 {
161     function factory() external pure returns (address);
162     function WETH() external pure returns (address);
163 
164 }
165 
166 contract Emoji is Context, IERC20, Ownable {
167     using SafeMath for uint256;
168 
169     mapping (address => uint256) private _tOwned;
170     mapping (address => mapping (address => uint256)) private _allowances;
171     mapping (address => bool) private isExcluded;
172     mapping(address => bool) public ammPairs;
173     mapping (uint256 => uint256) public tradingCount;
174    
175     uint8 private _decimals = 18;
176     uint256 private _tTotal;
177     uint256 public supply = 366400000000000 * (10 ** 18);
178 
179     string private _name = "Emoji";
180     string private _symbol = "Emoji";
181 
182     address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
183     address public initPoolAddress;
184 
185     uint256 launchedBlock;
186     bool openTransaction;
187     uint256 private firstBlock = 1;
188     uint256 private secondBlock = 4;
189     uint256 private thirdBlock = 150;
190 
191     uint256 tradingCountLimit = 7;
192     uint256 firstTradingAmountLimit = 256480000000 * (10 ** 18);
193     uint256 secondTradingAmountLimit = 732800000000 * (10 ** 18);
194     uint256 tradingAmountLimit = 1832000000000 * (10 ** 18);
195     uint256 holdingAmountLimit = 3664000000000 * (10 ** 18);
196     
197     constructor () {
198         initPoolAddress = owner();
199         _tOwned[initPoolAddress] = supply;
200         _tTotal = supply;
201 
202         isExcluded[address(msg.sender)] = true;
203         isExcluded[initPoolAddress] = true;
204         
205         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
206 
207         address ethPair = IUniswapV2Factory(_uniswapV2Router.factory())
208             .createPair(address(this), _uniswapV2Router.WETH());
209         ammPairs[ethPair] = true;
210 
211         emit Transfer(address(0), initPoolAddress, _tTotal);
212     }
213 
214     function name() public view returns (string memory) {
215         return _name;
216     }
217 
218     function symbol() public view returns (string memory) {
219         return _symbol;
220     }
221 
222     function decimals() public view returns (uint8) {
223         return _decimals;
224     }
225 
226     function totalSupply() public view override returns (uint256) {
227         return _tTotal;
228     }
229 
230     function balanceOf(address account) public view override returns (uint256) {
231         return _tOwned[account];
232     }
233 
234     function transfer(address recipient, uint256 amount) public override returns (bool) {
235         _transfer(_msgSender(), recipient, amount);
236         return true;
237     }
238 
239     function allowance(address owner, address spender) public view override returns (uint256) {
240         return _allowances[owner][spender];
241     }
242 
243     function approve(address spender, uint256 amount) public override returns (bool) {
244         _approve(_msgSender(), spender, amount);
245         return true;
246     }
247 
248     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
249         _transfer(sender, recipient, amount);
250         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "Emoji: transfer amount exceeds allowance"));
251         return true;
252     }
253 
254     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
255         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
256         return true;
257     }
258 
259     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
260         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "Emoji: decreased allowance below zero"));
261         return true;
262     }
263 
264     receive() external payable {}
265 
266     function _approve(address owner, address spender, uint256 amount) private {
267         require(owner != address(0), "Emoji: approve from the zero address");
268         require(spender != address(0), "Emoji: approve to the zero address");
269 
270         _allowances[owner][spender] = amount;
271         emit Approval(owner, spender, amount);
272     }
273 
274     function _transfer(
275         address from,
276         address to,
277         uint256 amount
278     ) private {
279         require(from != address(0), "Emoji: transfer from the zero address");
280         require(amount > 0, "Emoji: transfer amount must be greater than zero");
281 
282         uint256 fee;
283 
284         if(ammPairs[to] && IERC20(to).totalSupply() == 0){
285             require(from == initPoolAddress,"Emoji: Permission denied");
286         }
287 
288         if(isExcluded[from] || isExcluded[to]){
289             return _tokenTransfer(from,to,amount,fee); 
290         }
291 
292         require(openTransaction,"Emoji: Not open");
293 
294         uint256 currentBlock = block.number;
295 
296         if (ammPairs[from]) {
297             if (currentBlock - launchedBlock < firstBlock + 1) {
298                 fee = amount.mul(95).div(100);
299             } else if (currentBlock - launchedBlock < secondBlock + 1) {
300                 tradingCount[currentBlock] = tradingCount[currentBlock] + 1;
301                 if (tradingCount[currentBlock] > tradingCountLimit) {
302                     fee = amount.mul(95).div(100);
303                 }
304             }
305             if (currentBlock - launchedBlock < secondBlock + 1) {
306                 require(amount <= firstTradingAmountLimit, "Emoji: Trading limit");
307             } else if (currentBlock - launchedBlock < thirdBlock) {
308                 require(amount <= secondTradingAmountLimit, "Emoji: Trading limit");
309             } else {
310                 require(amount <= tradingAmountLimit, "Emoji: Trading limit");
311             }
312         }
313 
314         if (!ammPairs[to]) {
315             require(balanceOf(to).add(amount.sub(fee)) <= holdingAmountLimit, "Emoji: Holding limit");
316         }
317 
318         _tokenTransfer(from,to,amount,fee);
319     }
320 
321     function _tokenTransfer(address sender, address recipient, uint256 tAmount, uint256 fee) private {
322         _tOwned[sender] = _tOwned[sender].sub(tAmount);
323         _tOwned[recipient] = _tOwned[recipient].add(tAmount.sub(fee));
324         emit Transfer(sender, recipient, tAmount.sub(fee));
325         
326         if (fee > 0) {
327             _tOwned[address(this)] = _tOwned[address(this)].add(fee);
328             emit Transfer(sender, address(this), fee);
329         }
330     }
331 
332     function setOpenTransaction() external onlyOwner {
333         require(openTransaction == false, "Emoji: Already opened");
334         openTransaction = true;
335         launchedBlock = block.number;
336     }
337 
338     function muliSetExclude(address[] calldata users, bool _isExclude) external onlyOwner {
339         for (uint i = 0; i < users.length; i++) {
340             isExcluded[users[i]] = _isExclude;
341         }
342     }
343 
344 }