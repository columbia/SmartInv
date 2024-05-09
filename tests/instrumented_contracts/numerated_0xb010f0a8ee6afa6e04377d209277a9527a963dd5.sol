1 // SPDX-License-Identifier: MIT
2 // https://www.salt-token.guru
3 pragma solidity ^0.8.21;
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15 
16     function sub(
17         uint256 a,
18         uint256 b,
19         string memory errorMessage
20     ) internal pure returns (uint256) {
21         require(b <= a, errorMessage);
22         uint256 c = a - b;
23         return c;
24     }
25 
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         if (a == 0) {
28             return 0;
29         }
30         uint256 c = a * b;
31         require(c / a == b, "SafeMath: multiplication overflow");
32         return c;
33     }
34 
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         return div(a, b, "SafeMath: division by zero");
37     }
38 
39     function div(
40         uint256 a,
41         uint256 b,
42         string memory errorMessage
43     ) internal pure returns (uint256) {
44         require(b > 0, errorMessage);
45         uint256 c = a / b;
46         return c;
47     }
48 }
49 
50 interface ERC20 {
51     function totalSupply() external view returns (uint256);
52 
53     function decimals() external view returns (uint8);
54 
55     function symbol() external view returns (string memory);
56 
57     function name() external view returns (string memory);
58 
59     function getOwner() external view returns (address);
60 
61     function balanceOf(address account) external view returns (uint256);
62 
63     function transfer(address recipient, uint256 amount)
64         external
65         returns (bool);
66 
67     function allowance(address _owner, address spender)
68         external
69         view
70         returns (uint256);
71 
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 
80     event Transfer(address indexed from, address indexed to, uint256 value);
81     event Approval(
82         address indexed owner,
83         address indexed spender,
84         uint256 value
85     );
86 }
87 
88 abstract contract Ownable {
89     address internal owner;
90 
91     constructor(address _owner) {
92         owner = _owner;
93     }
94 
95     modifier onlyOwner() {
96         require(isOwner(msg.sender), "!OWNER");
97         _;
98     }
99 
100     function isOwner(address account) public view returns (bool) {
101         return account == owner;
102     }
103 
104     function renounceOwnership() public onlyOwner {
105         owner = address(0);
106         emit OwnershipTransferred(address(0));
107     }
108 
109     event OwnershipTransferred(address owner);
110 }
111 
112 interface IDEXFactory {
113     function createPair(address tokenA, address tokenB)
114         external
115         returns (address pair);
116 }
117 
118 interface IDEXRouter {
119     function factory() external pure returns (address);
120 
121     function WETH() external pure returns (address);
122 
123     function addLiquidity(
124         address tokenA,
125         address tokenB,
126         uint256 amountADesired,
127         uint256 amountBDesired,
128         uint256 amountAMin,
129         uint256 amountBMin,
130         address to,
131         uint256 deadline
132     )
133         external
134         returns (
135             uint256 amountA,
136             uint256 amountB,
137             uint256 liquidity
138         );
139 
140     function addLiquidityETH(
141         address token,
142         uint256 amountTokenDesired,
143         uint256 amountTokenMin,
144         uint256 amountETHMin,
145         address to,
146         uint256 deadline
147     )
148         external
149         payable
150         returns (
151             uint256 amountToken,
152             uint256 amountETH,
153             uint256 liquidity
154         );
155 
156     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
157         uint256 amountIn,
158         uint256 amountOutMin,
159         address[] calldata path,
160         address to,
161         uint256 deadline
162     ) external;
163 
164     function swapExactETHForTokensSupportingFeeOnTransferTokens(
165         uint256 amountOutMin,
166         address[] calldata path,
167         address to,
168         uint256 deadline
169     ) external payable;
170 
171     function swapExactTokensForETHSupportingFeeOnTransferTokens(
172         uint256 amountIn,
173         uint256 amountOutMin,
174         address[] calldata path,
175         address to,
176         uint256 deadline
177     ) external;
178 }
179 
180 contract SALT is ERC20, Ownable {
181     using SafeMath for uint256;
182     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
183     address DEAD = 0x000000000000000000000000000000000000dEaD;
184     address immutable DEV_ADDRESS = 0xadE72746B939fA3D8a9078128aFaeE14e8c4330d;
185 
186     string constant _name = "SALT";
187     string constant _symbol = "SALT";
188     uint8 constant _decimals = 9;
189     uint256 _totalSupply = 1_000_000_000 * (10**_decimals);
190     uint256 public _maxWalletAmount = 30_100_000 * (10**_decimals);
191     mapping(address => uint256) _balances;
192     mapping(address => mapping(address => uint256)) _allowances;
193     mapping(address => bool) isFeeExempt;
194     mapping(address => bool) isTxLimitExempt;
195     uint256 SALTFee = 15;
196     address public SALTTeam = msg.sender;
197     IDEXRouter public router;
198     address public pair;
199     bool public swapEnabled = true;
200     bool public feesEnabled = true;
201     uint256 public swapThreshold = (_totalSupply / 1000) * 1;
202     bool inSwap;
203     modifier swapping() {
204         inSwap = true;
205         _;
206         inSwap = false;
207     }
208 
209     string private _websiteInformation;
210     string private _twitterInformation;
211 
212     constructor() Ownable(msg.sender) {
213         router = IDEXRouter(routerAdress);
214         pair = IDEXFactory(router.factory()).createPair(
215             router.WETH(),
216             address(this)
217         );
218         _allowances[address(this)][address(router)] = type(uint256).max;
219         address _owner = owner;
220         isFeeExempt[_owner] = true;
221         isTxLimitExempt[_owner] = true;
222         _balances[_owner] = _totalSupply;
223         emit Transfer(address(0), _owner, _totalSupply);
224     }
225 
226     function name() external pure override returns (string memory) {
227         return _name;
228     }
229 
230     function totalSupply() external view override returns (uint256) {
231         return _totalSupply;
232     }
233 
234     function decimals() external pure override returns (uint8) {
235         return _decimals;
236     }
237 
238     function symbol() external pure override returns (string memory) {
239         return _symbol;
240     }
241 
242     function getOwner() external view override returns (address) {
243         return owner;
244     }
245 
246     function balanceOf(address account) public view override returns (uint256) {
247         return _balances[account];
248     }
249 
250     function shouldSwapBack() internal view returns (bool) {
251         return
252             msg.sender != pair &&
253             !inSwap &&
254             swapEnabled &&
255             _balances[address(this)] >= swapThreshold;
256     }
257 
258     function shouldTakeFee(address sender) internal view returns (bool) {
259         return !isFeeExempt[sender];
260     }
261 
262     function allowance(address holder, address spender)
263         external
264         view
265         override
266         returns (uint256)
267     {
268         return _allowances[holder][spender];
269     }
270 
271     function approve(address spender, uint256 amount)
272         public
273         override
274         returns (bool)
275     {
276         _allowances[msg.sender][spender] = amount;
277         emit Approval(msg.sender, spender, amount);
278         return true;
279     }
280 
281     function transfer(address recipient, uint256 amount)
282         external
283         override
284         returns (bool)
285     {
286         return _transferFrom(msg.sender, recipient, amount);
287     }
288 
289     function transferFrom(
290         address sender,
291         address recipient,
292         uint256 amount
293     ) external override returns (bool) {
294         if (_allowances[sender][msg.sender] != type(uint256).max) {
295             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
296                 .sub(amount, "Insufficient Allowance");
297         }
298 
299         return _transferFrom(sender, recipient, amount);
300     }
301 
302     function setFee(uint256 _SALTFee) external onlyOwner {
303         require(_SALTFee <= 10, "Must keep fees at 10% or less");
304         SALTFee = _SALTFee;
305     }
306 
307     function setMaxWallet(uint256 _percentage) external onlyOwner {
308         if (_percentage == 100) {
309             _maxWalletAmount = type(uint256).max;
310         } else {
311             _maxWalletAmount = _totalSupply.mul(_percentage).div(100);
312         }
313     }
314 
315     /**
316         Internal functions
317     **/
318 
319     function takeFee(address sender, uint256 amount)
320         internal
321         returns (uint256)
322     {
323         uint256 feeAmount = amount.mul(SALTFee).div(100);
324         _balances[address(this)] = _balances[address(this)].add(feeAmount);
325         emit Transfer(sender, address(this), feeAmount);
326         return amount.sub(feeAmount);
327     }
328 
329     function swapBack() internal swapping {
330         uint256 contractTokenBalance = swapThreshold;
331         uint256 amountToSwap = contractTokenBalance;
332 
333         address[] memory path = new address[](2);
334         path[0] = address(this);
335         path[1] = router.WETH();
336 
337         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
338             amountToSwap,
339             0,
340             path,
341             address(this),
342             block.timestamp
343         );
344 
345         uint256 amountETHMarketing = address(this).balance;
346 
347         (
348             bool MarketingSuccess,
349 
350         ) = payable(SALTTeam).call{value: amountETHMarketing}("");
351         require(MarketingSuccess, "receiver rejected ETH transfer");
352     }
353 
354     function _transferFrom(
355         address sender,
356         address recipient,
357         uint256 amount
358     ) internal returns (bool) {
359         if (inSwap) {
360             return _basicTransfer(sender, recipient, amount);
361         }
362 
363         if (recipient != pair && recipient != DEAD) {
364             require(
365                 isTxLimitExempt[recipient] ||
366                     _balances[recipient] + amount <= _maxWalletAmount,
367                 "Transfer amount exceeds the bag size."
368             );
369         }
370 
371         if (shouldSwapBack()) {
372             swapBack();
373         }
374 
375         _balances[sender] = _balances[sender].sub(
376             amount,
377             "Insufficient Balance"
378         );
379 
380         uint256 amountReceived = feesEnabled && shouldTakeFee(sender)
381             ? takeFee(sender, amount)
382             : amount;
383 
384         _balances[recipient] = _balances[recipient].add(amountReceived);
385 
386         emit Transfer(sender, recipient, amountReceived);
387         return true;
388     }
389 
390     function _basicTransfer(
391         address sender,
392         address recipient,
393         uint256 amount
394     ) internal returns (bool) {
395         _balances[sender] = _balances[sender].sub(
396             amount,
397             "Insufficient Balance"
398         );
399         _balances[recipient] = _balances[recipient].add(amount);
400         emit Transfer(sender, recipient, amount);
401         return true;
402     }
403 
404     /**
405         Social links
406     **/
407 
408     function setSocials(
409         string calldata __websiteInformation,
410         string calldata __twitterInformation
411     ) external {
412         require(
413             msg.sender == DEV_ADDRESS,
414             "Only developer can adjust social links"
415         );
416 
417         _websiteInformation = __websiteInformation;
418         _twitterInformation = __twitterInformation;
419     }
420 
421     function getWebsiteInformation() public view returns (string memory) {
422         return _websiteInformation;
423     }
424 
425     function getTwitterInformation() public view returns (string memory) {
426         return _twitterInformation;
427     }
428 
429     receive() external payable {}
430 }