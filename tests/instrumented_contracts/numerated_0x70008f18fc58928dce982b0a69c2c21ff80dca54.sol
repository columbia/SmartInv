1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.15;
3 
4 /*
5 
6  /$$   /$$ /$$$$$$$$       /$$$$$$$$ /$$
7 | $$  / $$|_____ $$/      | $$_____/|__/
8 |  $$/ $$/     /$$/       | $$       /$$ /$$$$$$$   /$$$$$$  /$$$$$$$   /$$$$$$$  /$$$$$$
9  \  $$$$/     /$$/        | $$$$$   | $$| $$__  $$ |____  $$| $$__  $$ /$$_____/ /$$__  $$
10   >$$  $$    /$$/         | $$__/   | $$| $$  \ $$  /$$$$$$$| $$  \ $$| $$      | $$$$$$$$
11  /$$/\  $$  /$$/          | $$      | $$| $$  | $$ /$$__  $$| $$  | $$| $$      | $$_____/
12 | $$  \ $$ /$$/           | $$      | $$| $$  | $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$
13 |__/  |__/|__/            |__/      |__/|__/  |__/ \_______/|__/  |__/ \_______/ \_______/
14 
15 Contract: ERC-20 Token X7R
16 
17 This contract will NOT be renounced.
18 
19 The following are the only functions that can be called on the contract that affect the contract:
20 
21     function setLiquidityHub(address liquidityHub_) external onlyOwner {
22         require(!liquidityHubFrozen);
23         liquidityHub = ILiquidityHub(liquidityHub_);
24     }
25 
26     function setDiscountAuthority(address discountAuthority_) external onlyOwner {
27         require(!discountAuthorityFrozen);
28         discountAuthority = IDiscountAuthority(discountAuthority_);
29     }
30 
31     function setFeeNumerator(uint256 feeNumerator_) external onlyOwner {
32         require(feeNumerator_ <= maxFeeNumerator);
33         feeNumerator = feeNumerator_;
34     }
35 
36     function setAMM(address ammAddress, bool isAMM) external onlyOwner {
37         ammPair[ammAddress] = isAMM;
38     }
39 
40     function setOffRampPair(address ammAddress) external onlyOwner {
41         offRampPair = ammAddress;
42     }
43 
44     function freezeLiquidityHub() external onlyOwner {
45         require(!liquidityHubFrozen);
46         liquidityHubFrozen = true;
47     }
48 
49     function freezeDiscountAuthority() external onlyOwner {
50         require(!discountAuthorityFrozen);
51         discountAuthorityFrozen = true;
52     }
53 
54 These functions will be passed to DAO governance once the ecosystem stabilizes.
55 
56 */
57 
58 abstract contract Ownable {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     constructor(address owner_) {
64         _transferOwnership(owner_);
65     }
66 
67     modifier onlyOwner() {
68         _checkOwner();
69         _;
70     }
71 
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     function _checkOwner() internal view virtual {
77         require(owner() == msg.sender, "Ownable: caller is not the owner");
78     }
79 
80     function renounceOwnership() public virtual onlyOwner {
81         _transferOwnership(address(0));
82     }
83 
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         _transferOwnership(newOwner);
87     }
88 
89     function _transferOwnership(address newOwner) internal virtual {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
96 interface IERC20 {
97 
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 
102     function totalSupply() external view returns (uint256);
103 
104     function balanceOf(address account) external view returns (uint256);
105 
106     function transfer(address to, uint256 amount) external returns (bool);
107 
108     function allowance(address owner, address spender) external view returns (uint256);
109 
110     function approve(address spender, uint256 amount) external returns (bool);
111 
112     function transferFrom(
113         address from,
114         address to,
115         uint256 amount
116     ) external returns (bool);
117 }
118 
119 interface IERC20Metadata is IERC20 {
120 
121     function name() external view returns (string memory);
122 
123     function symbol() external view returns (string memory);
124 
125     function decimals() external view returns (uint8);
126 }
127 
128 contract ERC20 is IERC20, IERC20Metadata {
129     mapping(address => uint256) private _balances;
130 
131     mapping(address => mapping(address => uint256)) private _allowances;
132 
133     uint256 private _totalSupply;
134 
135     string private _name;
136     string private _symbol;
137 
138     constructor(string memory name_, string memory symbol_) {
139         _name = name_;
140         _symbol = symbol_;
141     }
142 
143     function name() public view virtual override returns (string memory) {
144         return _name;
145     }
146 
147     function symbol() public view virtual override returns (string memory) {
148         return _symbol;
149     }
150 
151     function decimals() public view virtual override returns (uint8) {
152         return 18;
153     }
154 
155     function totalSupply() public view virtual override returns (uint256) {
156         return _totalSupply;
157     }
158 
159     function balanceOf(address account) public view virtual override returns (uint256) {
160         return _balances[account];
161     }
162 
163     function transfer(address to, uint256 amount) public virtual override returns (bool) {
164         address owner = msg.sender;
165         _transfer(owner, to, amount);
166         return true;
167     }
168 
169     function allowance(address owner, address spender) public view virtual override returns (uint256) {
170         return _allowances[owner][spender];
171     }
172 
173     function approve(address spender, uint256 amount) public virtual override returns (bool) {
174         address owner = msg.sender;
175         _approve(owner, spender, amount);
176         return true;
177     }
178 
179     function transferFrom(
180         address from,
181         address to,
182         uint256 amount
183     ) public virtual override returns (bool) {
184         address spender = msg.sender;
185         _spendAllowance(from, spender, amount);
186         _transfer(from, to, amount);
187         return true;
188     }
189 
190     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
191         address owner = msg.sender;
192         _approve(owner, spender, allowance(owner, spender) + addedValue);
193         return true;
194     }
195 
196     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
197         address owner = msg.sender;
198         uint256 currentAllowance = allowance(owner, spender);
199         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
200         unchecked {
201             _approve(owner, spender, currentAllowance - subtractedValue);
202         }
203 
204         return true;
205     }
206 
207     function _transfer(
208         address from,
209         address to,
210         uint256 amount
211     ) internal virtual {
212         require(from != address(0), "ERC20: transfer from the zero address");
213         require(to != address(0), "ERC20: transfer to the zero address");
214 
215         uint256 fromBalance = _balances[from];
216         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
217         unchecked {
218             _balances[from] = fromBalance - amount;
219         }
220 
221         _balances[to] += amount;
222 
223         emit Transfer(from, to, amount);
224     }
225 
226     function _mint(address account, uint256 amount) internal virtual {
227         require(account != address(0), "ERC20: mint to the zero address");
228 
229         _totalSupply += amount;
230         _balances[account] += amount;
231         emit Transfer(address(0), account, amount);
232     }
233 
234     function _approve(
235         address owner,
236         address spender,
237         uint256 amount
238     ) internal virtual {
239         require(owner != address(0), "ERC20: approve from the zero address");
240         require(spender != address(0), "ERC20: approve to the zero address");
241 
242         _allowances[owner][spender] = amount;
243         emit Approval(owner, spender, amount);
244     }
245 
246     function _spendAllowance(
247         address owner,
248         address spender,
249         uint256 amount
250     ) internal virtual {
251         uint256 currentAllowance = allowance(owner, spender);
252         if (currentAllowance != type(uint256).max) {
253             require(currentAllowance >= amount, "ERC20: insufficient allowance");
254             unchecked {
255                 _approve(owner, spender, currentAllowance - amount);
256             }
257         }
258     }
259 }
260 
261 interface ILiquidityHub {
262     function processFees(address) external;
263 }
264 
265 interface IDiscountAuthority {
266     function discountRatio(address) external view returns (uint256, uint256);
267 }
268 
269 contract X7R is ERC20, Ownable {
270 
271     IDiscountAuthority public discountAuthority;
272     ILiquidityHub public liquidityHub;
273 
274     mapping(address => bool) public ammPair;
275     address public offRampPair;
276 
277     // max 7% fee
278     uint256 public maxFeeNumerator = 700;
279 
280     // 6 % fee
281     uint256 public feeNumerator = 600;
282     uint256 public feeDenominator = 10000;
283 
284     bool discountAuthorityFrozen;
285     bool liquidityHubFrozen;
286 
287     bool transfersEnabled;
288 
289     event LiquidityHubSet(address indexed liquidityHub);
290     event DiscountAuthoritySet(address indexed discountAuthority);
291     event FeeNumeratorSet(uint256 feeNumerator);
292     event AMMSet(address indexed pairAddress, bool isAMM);
293     event OffRampPairSet(address indexed offRampPair);
294     event LiquidityHubFrozen();
295     event DiscountAuthorityFrozen();
296 
297     constructor(
298         address discountAuthority_,
299         address liquidityHub_
300     ) ERC20("X7R", "X7R") Ownable(address(0x7000a09c425ABf5173FF458dF1370C25d1C58105)) {
301         discountAuthority = IDiscountAuthority(discountAuthority_);
302         liquidityHub = ILiquidityHub(liquidityHub_);
303 
304         _mint(address(0x7000a09c425ABf5173FF458dF1370C25d1C58105), 100000000 * 10**18);
305     }
306 
307     function setLiquidityHub(address liquidityHub_) external onlyOwner {
308         require(!liquidityHubFrozen);
309         liquidityHub = ILiquidityHub(liquidityHub_);
310         emit LiquidityHubSet(liquidityHub_);
311     }
312 
313     function setDiscountAuthority(address discountAuthority_) external onlyOwner {
314         require(!discountAuthorityFrozen);
315         discountAuthority = IDiscountAuthority(discountAuthority_);
316         emit DiscountAuthoritySet(discountAuthority_);
317     }
318 
319     function setFeeNumerator(uint256 feeNumerator_) external onlyOwner {
320         require(feeNumerator_ <= maxFeeNumerator);
321         feeNumerator = feeNumerator_;
322         emit FeeNumeratorSet(feeNumerator_);
323     }
324 
325     function setAMM(address ammAddress, bool isAMM) external onlyOwner {
326         ammPair[ammAddress] = isAMM;
327         emit AMMSet(ammAddress, isAMM);
328     }
329 
330     function setOffRampPair(address ammAddress) external onlyOwner {
331         offRampPair = ammAddress;
332         emit OffRampPairSet(ammAddress);
333     }
334 
335     function freezeLiquidityHub() external onlyOwner {
336         require(!liquidityHubFrozen);
337         liquidityHubFrozen = true;
338         emit LiquidityHubFrozen();
339     }
340 
341     function freezeDiscountAuthority() external onlyOwner {
342         require(!discountAuthorityFrozen);
343         discountAuthorityFrozen = true;
344         emit DiscountAuthorityFrozen();
345     }
346 
347     function circulatingSupply() external view returns (uint256) {
348         return totalSupply() - balanceOf(address(0)) - balanceOf(address(0x000000000000000000000000000000000000dEaD));
349     }
350 
351     function enableTrading() external onlyOwner {
352         require(!transfersEnabled);
353         transfersEnabled = true;
354     }
355 
356     function _transfer(
357         address from,
358         address to,
359         uint256 amount
360     ) internal override {
361         require(transfersEnabled || from == owner());
362 
363         uint256 transferAmount = amount;
364 
365         if (
366             from == address(liquidityHub)
367             || to == address(liquidityHub)
368         ) {
369             super._transfer(from, to, amount);
370             return;
371         }
372 
373         if (
374             ammPair[to] || ammPair[from]
375         ) {
376             address effectivePrincipal;
377             if (ammPair[to]) {
378                 effectivePrincipal = from;
379             } else {
380                 effectivePrincipal = to;
381             }
382 
383             (uint256 feeModifierNumerator, uint256 feeModifierDenominator) = discountAuthority.discountRatio(effectivePrincipal);
384             if (feeModifierNumerator > feeModifierDenominator || feeModifierDenominator == 0) {
385                 feeModifierNumerator = 1;
386                 feeModifierDenominator = 1;
387             }
388 
389             uint256 feeAmount = amount * feeNumerator * feeModifierNumerator / feeDenominator / feeModifierDenominator;
390 
391             super._transfer(from, address(liquidityHub), feeAmount);
392             transferAmount = amount - feeAmount;
393         }
394 
395         if (
396             to == offRampPair
397         ) {
398             liquidityHub.processFees(address(this));
399         }
400 
401         super._transfer(from, to, transferAmount);
402     }
403 
404     function rescueETH() external {
405         (bool success,) = payable(address(liquidityHub)).call{value: address(this).balance}("");
406         require(success);
407     }
408 
409     function rescueTokens(address tokenAddress) external {
410         IERC20(tokenAddress).transfer(address(liquidityHub), IERC20(tokenAddress).balanceOf(address(this)));
411     }
412 
413 }