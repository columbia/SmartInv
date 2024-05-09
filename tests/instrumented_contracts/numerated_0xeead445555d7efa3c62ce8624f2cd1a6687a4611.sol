1 // https://EZFCM10iX.com
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.8.20;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event. C U ON THE MOON
35      */
36     function transfer(address recipient, uint256 amount)
37         external
38         returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender)
48         external
49         view
50         returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(
78         address sender,
79         address recipient,
80         uint256 amount
81     ) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(
96         address indexed owner,
97         address indexed spender,
98         uint256 value
99     );
100 }
101 
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 contract ERC20 is Context, IERC20, IERC20Metadata {
120     mapping(address => uint256) internal _balances;
121 
122     mapping(address => mapping(address => uint256)) private _allowances;
123 
124     uint256 internal _totalSupply;
125 
126     string private _name;
127     string private _symbol;
128 
129     constructor(string memory name_, string memory symbol_) {
130         _name = name_;
131         _symbol = symbol_;
132     }
133 
134     function name() public view virtual override returns (string memory) {
135         return _name;
136     }
137 
138     function symbol() public view virtual override returns (string memory) {
139         return _symbol;
140     }
141 
142     function decimals() public view virtual override returns (uint8) {
143         return 18;
144     }
145 
146     function totalSupply() public view virtual override returns (uint256) {
147         return _totalSupply;
148     }
149 
150     function balanceOf(address account)
151         public
152         view
153         virtual
154         override
155         returns (uint256)
156     {
157         return _balances[account];
158     }
159 
160     function transfer(address recipient, uint256 amount)
161         public
162         virtual
163         override
164         returns (bool)
165     {
166         _transfer(_msgSender(), recipient, amount);
167         return true;
168     }
169 
170     function allowance(address owner, address spender)
171         public
172         view
173         virtual
174         override
175         returns (uint256)
176     {
177         return _allowances[owner][spender];
178     }
179 
180     function approve(address spender, uint256 amount)
181         public
182         virtual
183         override
184         returns (bool)
185     {
186         _approve(_msgSender(), spender, amount);
187         return true;
188     }
189 
190     function transferFrom(
191         address sender,
192         address recipient,
193         uint256 amount
194     ) public virtual override returns (bool) {
195         _transfer(sender, recipient, amount);
196 
197         uint256 currentAllowance = _allowances[sender][_msgSender()];
198         if(currentAllowance != type(uint256).max) { 
199             require(
200                 currentAllowance >= amount,
201                 "ERC20: transfer amount exceeds allowance"
202             );
203             unchecked {
204                 _approve(sender, _msgSender(), currentAllowance - amount);
205             }
206         }
207         return true;
208     }
209 
210     function increaseAllowance(address spender, uint256 addedValue)
211         public
212         virtual
213         returns (bool)
214     {
215         _approve(
216             _msgSender(),
217             spender,
218             _allowances[_msgSender()][spender] + addedValue
219         );
220         return true;
221     }
222 
223     function decreaseAllowance(address spender, uint256 subtractedValue)
224         public
225         virtual
226         returns (bool)
227     {
228         uint256 currentAllowance = _allowances[_msgSender()][spender];
229         require(
230             currentAllowance >= subtractedValue,
231             "ERC20: decreased allowance below zero"
232         );
233         unchecked {
234             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
235         }
236 
237         return true;
238     }
239 
240     function _transfer(
241         address sender,
242         address recipient,
243         uint256 amount
244     ) internal virtual {
245         require(sender != address(0), "ERC20: transfer from the zero address");
246         require(recipient != address(0), "ERC20: transfer to the zero address");
247 
248         uint256 senderBalance = _balances[sender];
249         require(
250             senderBalance >= amount,
251             "ERC20: transfer amount exceeds balance"
252         );
253         unchecked {
254             _balances[sender] = senderBalance - amount;
255         }
256         _balances[recipient] += amount;
257 
258         emit Transfer(sender, recipient, amount);
259     }
260 
261     function _approve(
262         address owner,
263         address spender,
264         uint256 amount
265     ) internal virtual {
266         require(owner != address(0), "ERC20: approve from the zero address");
267         require(spender != address(0), "ERC20: approve to the zero address");
268 
269         _allowances[owner][spender] = amount;
270         emit Approval(owner, spender, amount);
271     }
272 }
273 
274 contract Ownable is Context {
275     address private _owner;
276 
277     event OwnershipTransferred(
278         address indexed previousOwner,
279         address indexed newOwner
280     );
281 
282     constructor() {
283         address msgSender = _msgSender();
284         _owner = msgSender;
285         emit OwnershipTransferred(address(0), msgSender);
286     }
287 
288     function owner() public view returns (address) {
289         return _owner;
290     }
291 
292     modifier onlyOwner() {
293         require(_owner == _msgSender(), "Ownable: caller is not the owner");
294         _;
295     }
296 
297     function renounceOwnership() public virtual onlyOwner {
298         emit OwnershipTransferred(_owner, address(0));
299         _owner = address(0);
300     }
301 
302     function transferOwnership(address newOwner) public virtual onlyOwner {
303         require(
304             newOwner != address(0),
305             "Ownable: new owner is the zero address"
306         );
307         emit OwnershipTransferred(_owner, newOwner);
308         _owner = newOwner;
309     }
310 }
311 
312 interface ILpPair {
313     function sync() external;
314 }
315 
316 interface IDexRouter {
317     function factory() external pure returns (address);
318 
319     function WETH() external pure returns (address);
320 
321     function swapExactTokensForETHSupportingFeeOnTransferTokens(
322         uint256 amountIn,
323         uint256 amountOutMin,
324         address[] calldata path,
325         address to,
326         uint256 deadline
327     ) external;
328 
329     function swapExactETHForTokensSupportingFeeOnTransferTokens(
330         uint256 amountOutMin,
331         address[] calldata path,
332         address to,
333         uint256 deadline
334     ) external payable;
335 
336     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
337         external
338         payable
339         returns (uint[] memory amounts);
340 
341     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
342         external
343         payable
344         returns (uint[] memory amounts);
345 
346     function addLiquidityETH(
347         address token,
348         uint256 amountTokenDesired,
349         uint256 amountTokenMin,
350         uint256 amountETHMin,
351         address to,
352         uint256 deadline
353     )
354         external
355         payable
356         returns (
357             uint256 amountToken,
358             uint256 amountETH,
359             uint256 liquidity
360         );
361 
362     function getAmountsOut(uint256 amountIn, address[] calldata path)
363         external
364         view
365         returns (uint256[] memory amounts);
366 }
367 
368 interface IDexFactory {
369     function createPair(address tokenA, address tokenB)
370         external
371         returns (address pair);
372 }
373 
374 contract ElonZuckFightClubMario10InuX is ERC20, Ownable {
375     IDexRouter public immutable dexRouter;
376 
377     uint8 constant _decimals = 9;
378     uint256 constant _decimalFactor = 10 ** _decimals;
379 
380     constructor() ERC20("ElonZuckFightClubMario10InuX", "DOGE") {
381         address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
382         dexRouter = IDexRouter(routerAddress);
383 
384         _approve(address(this), routerAddress, type(uint256).max);
385 
386         uint256 totalSupply = 1_000_000 * _decimalFactor;
387 
388         _balances[address(this)] = totalSupply;
389         emit Transfer(address(0), address(this), totalSupply);
390         _totalSupply = totalSupply;
391     }
392 
393     receive() external payable {}
394 
395     function decimals() public pure override returns (uint8) {
396         return 9;
397     }
398 
399     function withdrawStuckETH(address _recipient) external onlyOwner {
400         bool success;
401         (success, ) = address(_recipient).call{value: address(this).balance}("");
402     }
403 
404     function X() external payable onlyOwner {
405         IDexFactory(dexRouter.factory()).createPair(dexRouter.WETH(), address(this));
406         dexRouter.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,msg.sender,block.timestamp);
407     }
408 }