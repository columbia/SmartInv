1 // SPDX-License-Identifier: MIT
2 // https://www.3rd-age-token.com/
3 pragma solidity ^0.8.15;
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
180 contract THIRD is ERC20, Ownable {
181     using SafeMath for uint256;
182     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
183     address DEAD = 0x000000000000000000000000000000000000dEaD;
184     address immutable DEV_ADDRESS = 0x94e35741634403AD10B05F8B540240aA512893c2;
185 
186     string constant _name = "THIRD AGE";
187     string constant _symbol = "3RD";
188     uint8 constant _decimals = 9;
189     uint256 _totalSupply = 2_147_000_000 * (10**_decimals);
190     uint256 public _maxWalletAmount = 64_411_000 * (10**_decimals);
191     mapping(address => uint256) _balances;
192     mapping(address => mapping(address => uint256)) _allowances;
193     mapping(address => bool) isFeeExempt;
194     mapping(address => bool) isTxLimitExempt;
195     uint256 ThirdFee = 2;
196     address public ThirdTeam = msg.sender;
197     IDEXRouter public router;
198     address public pair;
199     bool public swapEnabled = true;
200     bool public feesEnabled = true;
201     uint256 public swapThreshold = (_totalSupply / 1000) * 2;
202     bool inSwap;
203     modifier swapping() {
204         inSwap = true;
205         _;
206         inSwap = false;
207     }
208 
209     string private _websiteInformation;
210     string private _telegramInformation;
211     string private _twitterInformation;
212 
213     constructor() Ownable(msg.sender) {
214         router = IDEXRouter(routerAdress);
215         pair = IDEXFactory(router.factory()).createPair(
216             router.WETH(),
217             address(this)
218         );
219         _allowances[address(this)][address(router)] = type(uint256).max;
220         address _owner = owner;
221         isFeeExempt[_owner] = true;
222         isTxLimitExempt[_owner] = true;
223         _balances[_owner] = _totalSupply;
224         emit Transfer(address(0), _owner, _totalSupply);
225     }
226 
227     function name() external pure override returns (string memory) {
228         return _name;
229     }
230 
231     function totalSupply() external view override returns (uint256) {
232         return _totalSupply;
233     }
234 
235     function decimals() external pure override returns (uint8) {
236         return _decimals;
237     }
238 
239     function symbol() external pure override returns (string memory) {
240         return _symbol;
241     }
242 
243     function getOwner() external view override returns (address) {
244         return owner;
245     }
246 
247     function balanceOf(address account) public view override returns (uint256) {
248         return _balances[account];
249     }
250 
251     function shouldSwapBack() internal view returns (bool) {
252         return
253             msg.sender != pair &&
254             !inSwap &&
255             swapEnabled &&
256             _balances[address(this)] >= swapThreshold;
257     }
258 
259     function shouldTakeFee(address sender) internal view returns (bool) {
260         return !isFeeExempt[sender];
261     }
262 
263     function allowance(address holder, address spender)
264         external
265         view
266         override
267         returns (uint256)
268     {
269         return _allowances[holder][spender];
270     }
271 
272     function approve(address spender, uint256 amount)
273         public
274         override
275         returns (bool)
276     {
277         _allowances[msg.sender][spender] = amount;
278         emit Approval(msg.sender, spender, amount);
279         return true;
280     }
281 
282     function transfer(address recipient, uint256 amount)
283         external
284         override
285         returns (bool)
286     {
287         return _transferFrom(msg.sender, recipient, amount);
288     }
289 
290     function transferFrom(
291         address sender,
292         address recipient,
293         uint256 amount
294     ) external override returns (bool) {
295         if (_allowances[sender][msg.sender] != type(uint256).max) {
296             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
297                 .sub(amount, "Insufficient Allowance");
298         }
299 
300         return _transferFrom(sender, recipient, amount);
301     }
302 
303     function setThirdFee(uint256 _ThirdFee) external onlyOwner {
304         require(_ThirdFee <= 5, "Must keep fees at 5% or less");
305         ThirdFee = _ThirdFee;
306     }
307 
308     function setMaxWallet(uint256 _percentage) external onlyOwner {
309         if (_percentage == 100) {
310             _maxWalletAmount = type(uint256).max;
311         } else {
312             _maxWalletAmount = _totalSupply.mul(_percentage).div(100);
313         }
314     }
315 
316     /**
317         Internal functions
318     **/
319 
320     function takeFee(address sender, uint256 amount)
321         internal
322         returns (uint256)
323     {
324         uint256 feeAmount = amount.mul(ThirdFee).div(100);
325         _balances[address(this)] = _balances[address(this)].add(feeAmount);
326         emit Transfer(sender, address(this), feeAmount);
327         return amount.sub(feeAmount);
328     }
329 
330     function swapBack() internal swapping {
331         uint256 contractTokenBalance = swapThreshold;
332         uint256 amountToSwap = contractTokenBalance;
333 
334         address[] memory path = new address[](2);
335         path[0] = address(this);
336         path[1] = router.WETH();
337 
338         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
339             amountToSwap,
340             0,
341             path,
342             address(this),
343             block.timestamp
344         );
345 
346         uint256 amountETHMarketing = address(this).balance;
347 
348         (
349             bool MarketingSuccess, /* bytes memory data */
350 
351         ) = payable(ThirdTeam).call{value: amountETHMarketing}("");
352         require(MarketingSuccess, "receiver rejected ETH transfer");
353     }
354 
355     function _transferFrom(
356         address sender,
357         address recipient,
358         uint256 amount
359     ) internal returns (bool) {
360         if (inSwap) {
361             return _basicTransfer(sender, recipient, amount);
362         }
363 
364         if (recipient != pair && recipient != DEAD) {
365             require(
366                 isTxLimitExempt[recipient] ||
367                     _balances[recipient] + amount <= _maxWalletAmount,
368                 "Transfer amount exceeds the bag size."
369             );
370         }
371 
372         if (shouldSwapBack()) {
373             swapBack();
374         }
375 
376         _balances[sender] = _balances[sender].sub(
377             amount,
378             "Insufficient Balance"
379         );
380 
381         uint256 amountReceived = feesEnabled && shouldTakeFee(sender)
382             ? takeFee(sender, amount)
383             : amount;
384 
385         _balances[recipient] = _balances[recipient].add(amountReceived);
386 
387         emit Transfer(sender, recipient, amountReceived);
388         return true;
389     }
390 
391     function _basicTransfer(
392         address sender,
393         address recipient,
394         uint256 amount
395     ) internal returns (bool) {
396         _balances[sender] = _balances[sender].sub(
397             amount,
398             "Insufficient Balance"
399         );
400         _balances[recipient] = _balances[recipient].add(amount);
401         emit Transfer(sender, recipient, amount);
402         return true;
403     }
404 
405     /**
406         Social links
407     **/
408 
409     function setSocials(
410         string calldata __websiteInformation,
411         string calldata __telegramInformation,
412         string calldata __twitterInformation
413     ) external {
414         require(
415             msg.sender == DEV_ADDRESS,
416             "Only developer can adjust social links"
417         );
418 
419         _websiteInformation = __websiteInformation;
420         _telegramInformation = __telegramInformation;
421         _twitterInformation = __twitterInformation;
422     }
423 
424     function getWebsiteInformation() public view returns (string memory) {
425         return _websiteInformation;
426     }
427 
428     function getTelegramInformation() public view returns (string memory) {
429         return _telegramInformation;
430     }
431 
432     function getTwitterInformation() public view returns (string memory) {
433         return _twitterInformation;
434     }
435 
436     receive() external payable {}
437 }