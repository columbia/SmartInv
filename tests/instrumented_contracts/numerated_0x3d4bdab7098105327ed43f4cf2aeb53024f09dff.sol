1 // SPDX-License-Identifier: AGPL-3.0-only
2 pragma solidity 0.8.19;
3 
4 /// @notice Simple single owner authorization mixin.
5 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)
6 abstract contract Owned {
7     /*//////////////////////////////////////////////////////////////
8                                  EVENTS
9     //////////////////////////////////////////////////////////////*/
10 
11     event OwnershipTransferred(address indexed user, address indexed newOwner);
12 
13     /*//////////////////////////////////////////////////////////////
14                             OWNERSHIP STORAGE
15     //////////////////////////////////////////////////////////////*/
16 
17     address public owner;
18 
19     modifier onlyOwner() virtual {
20         require(msg.sender == owner, "UNAUTHORIZED");
21 
22         _;
23     }
24 
25     /*//////////////////////////////////////////////////////////////
26                                CONSTRUCTOR
27     //////////////////////////////////////////////////////////////*/
28 
29     constructor(address _owner) {
30         owner = _owner;
31 
32         emit OwnershipTransferred(address(0), _owner);
33     }
34 
35     /*//////////////////////////////////////////////////////////////
36                              OWNERSHIP LOGIC
37     //////////////////////////////////////////////////////////////*/
38 
39     function transferOwnership(address newOwner) public virtual onlyOwner {
40         owner = newOwner;
41 
42         emit OwnershipTransferred(msg.sender, newOwner);
43     }
44 }
45 
46 interface IUniswapV2Router01 {
47     function factory() external pure returns (address);
48     function WETH() external pure returns (address);
49 
50     function addLiquidity(
51         address tokenA,
52         address tokenB,
53         uint amountADesired,
54         uint amountBDesired,
55         uint amountAMin,
56         uint amountBMin,
57         address to,
58         uint deadline
59     ) external returns (uint amountA, uint amountB, uint liquidity);
60     function addLiquidityETH(
61         address token,
62         uint amountTokenDesired,
63         uint amountTokenMin,
64         uint amountETHMin,
65         address to,
66         uint deadline
67     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
68     function removeLiquidity(
69         address tokenA,
70         address tokenB,
71         uint liquidity,
72         uint amountAMin,
73         uint amountBMin,
74         address to,
75         uint deadline
76     ) external returns (uint amountA, uint amountB);
77     function removeLiquidityETH(
78         address token,
79         uint liquidity,
80         uint amountTokenMin,
81         uint amountETHMin,
82         address to,
83         uint deadline
84     ) external returns (uint amountToken, uint amountETH);
85     function removeLiquidityWithPermit(
86         address tokenA,
87         address tokenB,
88         uint liquidity,
89         uint amountAMin,
90         uint amountBMin,
91         address to,
92         uint deadline,
93         bool approveMax, uint8 v, bytes32 r, bytes32 s
94     ) external returns (uint amountA, uint amountB);
95     function removeLiquidityETHWithPermit(
96         address token,
97         uint liquidity,
98         uint amountTokenMin,
99         uint amountETHMin,
100         address to,
101         uint deadline,
102         bool approveMax, uint8 v, bytes32 r, bytes32 s
103     ) external returns (uint amountToken, uint amountETH);
104     function swapExactTokensForTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external returns (uint[] memory amounts);
111     function swapTokensForExactTokens(
112         uint amountOut,
113         uint amountInMax,
114         address[] calldata path,
115         address to,
116         uint deadline
117     ) external returns (uint[] memory amounts);
118     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
119         external
120         payable
121         returns (uint[] memory amounts);
122     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
123         external
124         returns (uint[] memory amounts);
125     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
126         external
127         returns (uint[] memory amounts);
128     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
129         external
130         payable
131         returns (uint[] memory amounts);
132 
133     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
134     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
135     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
136     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
137     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
138 }
139 
140 interface IUniswapV2Router02 is IUniswapV2Router01 {
141     function removeLiquidityETHSupportingFeeOnTransferTokens(
142         address token,
143         uint liquidity,
144         uint amountTokenMin,
145         uint amountETHMin,
146         address to,
147         uint deadline
148     ) external returns (uint amountETH);
149     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
150         address token,
151         uint liquidity,
152         uint amountTokenMin,
153         uint amountETHMin,
154         address to,
155         uint deadline,
156         bool approveMax, uint8 v, bytes32 r, bytes32 s
157     ) external returns (uint amountETH);
158 
159     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
160         uint amountIn,
161         uint amountOutMin,
162         address[] calldata path,
163         address to,
164         uint deadline
165     ) external;
166     function swapExactETHForTokensSupportingFeeOnTransferTokens(
167         uint amountOutMin,
168         address[] calldata path,
169         address to,
170         uint deadline
171     ) external payable;
172     function swapExactTokensForETHSupportingFeeOnTransferTokens(
173         uint amountIn,
174         uint amountOutMin,
175         address[] calldata path,
176         address to,
177         uint deadline
178     ) external;
179 }
180 
181 // Homepage: https://gates.biz/
182 // Twitter: https://twitter.com/GatesSyndicate
183 // Telegram: https://t.me/GatesPortal
184 // Litepaper: https://docs.gates.biz/
185 
186 /// @notice Anti bot token
187 /// @author fico23
188 /// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
189 contract Gates is Owned {
190     /*//////////////////////////////////////////////////////////////
191                                  EVENTS
192     //////////////////////////////////////////////////////////////*/
193 
194     event Transfer(address indexed from, address indexed to, uint256 amount);
195 
196     event Approval(address indexed owner, address indexed spender, uint256 amount);
197 
198     event IsAddressExcludedChanged(address indexed user, bool value);
199 
200     /*//////////////////////////////////////////////////////////////
201                                  ERRORS
202     //////////////////////////////////////////////////////////////*/
203     error MaxBuyExceeded(uint256 maxBuy, uint256 amount);
204 
205     /*//////////////////////////////////////////////////////////////
206                                  STRUCTS
207     //////////////////////////////////////////////////////////////*/
208     struct UserInfo {
209         uint224 amount;
210         uint32 minTaxOn;
211     }
212 
213     /*//////////////////////////////////////////////////////////////
214                             METADATA STORAGE
215     //////////////////////////////////////////////////////////////*/
216 
217     string public name;
218 
219     string public symbol;
220 
221     uint8 public immutable decimals;
222 
223     /*//////////////////////////////////////////////////////////////
224                               ERC20 STORAGE
225     //////////////////////////////////////////////////////////////*/
226 
227     uint256 public totalSupply;
228 
229     mapping(address => UserInfo) private userInfo;
230 
231     mapping(address => mapping(address => uint256)) public allowance;
232 
233     /*//////////////////////////////////////////////////////////////
234                             EIP-2612 STORAGE
235     //////////////////////////////////////////////////////////////*/
236 
237     uint256 internal immutable INITIAL_CHAIN_ID;
238 
239     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
240 
241     mapping(address => uint256) public nonces;
242 
243     /*//////////////////////////////////////////////////////////////
244                             TAX LOGIC
245     //////////////////////////////////////////////////////////////*/
246     mapping(address => bool) public isAddressExcluded;
247     uint256 private constant MAX_TAX = 3000;
248     uint256 private constant TAX_DURATION = 1 hours;
249     uint256 private constant HUNDRED_PERCENT = 10000;
250     address private immutable TREASURY;
251     IUniswapV2Router02 private immutable router;
252     address private immutable WETH;
253 
254     /*//////////////////////////////////////////////////////////////
255                             ANTI-BOT MEASURES
256     //////////////////////////////////////////////////////////////*/
257     uint256 private constant MAX_BUY_ON_START = 1e23;
258     uint256 private constant MAX_BUY_ON_END = 1e24;
259     uint256 private constant MAX_BUY_DURATION = 15 minutes;
260     uint256 private immutable MAX_BUY_END_TIME;
261     uint256 private immutable MAX_BUY_DISABLED_TIME;
262 
263     /*//////////////////////////////////////////////////////////////
264                                CONSTRUCTOR
265     //////////////////////////////////////////////////////////////*/
266 
267     constructor(address treasury, address uniV2Router, address weth) Owned(msg.sender) {
268         name = "Gates Syndicate";
269         symbol = "GATES";
270         decimals = 18;
271 
272         INITIAL_CHAIN_ID = block.chainid;
273         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
274 
275         MAX_BUY_END_TIME = block.timestamp + MAX_BUY_DURATION;
276         MAX_BUY_DISABLED_TIME = block.timestamp + 1 hours;
277 
278         _mint(msg.sender, 1e25);
279 
280         isAddressExcluded[msg.sender] = true;
281         isAddressExcluded[treasury] = true;
282 
283         TREASURY = treasury;
284 
285         router = IUniswapV2Router02(uniV2Router);
286         allowance[address(this)][uniV2Router] = type(uint256).max;
287 
288         WETH = weth;
289     }
290 
291     /*//////////////////////////////////////////////////////////////
292                                ERC20 LOGIC
293     //////////////////////////////////////////////////////////////*/
294 
295     function balanceOf(address user) external view returns (uint256) {
296         return userInfo[user].amount;
297     }
298 
299     function approve(address spender, uint256 amount) public returns (bool) {
300         allowance[msg.sender][spender] = amount;
301 
302         emit Approval(msg.sender, spender, amount);
303 
304         return true;
305     }
306 
307     function transfer(address to, uint256 amount) public returns (bool) {
308         UserInfo storage fromUser = userInfo[msg.sender];
309 
310         fromUser.amount = uint224(uint256(fromUser.amount) - amount);
311 
312         if (!isAddressExcluded[msg.sender]) {
313             amount = _processTax(fromUser.minTaxOn, amount);
314         }
315 
316         // Cannot overflow because the sum of all user
317         // balances can't exceed the max uint224 value.
318         // taxAmount is always less than amount
319         unchecked {
320             uint256 newAmount = amount + userInfo[to].amount;
321 
322             if (!isAddressExcluded[to]) {
323                 _revertOnMaxBuyExceeded(newAmount);
324             }
325 
326             userInfo[to] = UserInfo({amount: uint224(newAmount), minTaxOn: uint32(block.timestamp + TAX_DURATION)});
327         }
328 
329         emit Transfer(msg.sender, to, amount);
330 
331         return true;
332     }
333 
334     function transferFrom(address from, address to, uint256 amount) public returns (bool) {
335         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
336 
337         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
338 
339         UserInfo storage fromUser = userInfo[from];
340         fromUser.amount = uint224(uint256(fromUser.amount) - amount);
341 
342         if (!isAddressExcluded[from]) {
343             amount = _processTax(fromUser.minTaxOn, amount);
344         }
345 
346         // Cannot overflow because the sum of all user
347         // balances can't exceed the max uint224 value.
348         // taxAmount is always less than amount
349         unchecked {
350             uint256 newAmount = amount + userInfo[to].amount;
351 
352             if (!isAddressExcluded[to]) {
353                 _revertOnMaxBuyExceeded(newAmount);
354             }
355 
356             userInfo[to] = UserInfo({amount: uint224(newAmount), minTaxOn: uint32(block.timestamp + TAX_DURATION)});
357         }
358 
359         emit Transfer(from, to, amount);
360 
361         return true;
362     }
363 
364     /*//////////////////////////////////////////////////////////////
365                              EIP-2612 LOGIC
366     //////////////////////////////////////////////////////////////*/
367 
368     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
369         public
370     {
371         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
372 
373         // Unchecked because the only math done is incrementing
374         // the owner's nonce which cannot realistically overflow.
375         unchecked {
376             address recoveredAddress = ecrecover(
377                 keccak256(
378                     abi.encodePacked(
379                         "\x19\x01",
380                         DOMAIN_SEPARATOR(),
381                         keccak256(
382                             abi.encode(
383                                 keccak256(
384                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
385                                 ),
386                                 owner,
387                                 spender,
388                                 value,
389                                 nonces[owner]++,
390                                 deadline
391                             )
392                         )
393                     )
394                 ),
395                 v,
396                 r,
397                 s
398             );
399 
400             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
401 
402             allowance[recoveredAddress][spender] = value;
403         }
404 
405         emit Approval(owner, spender, value);
406     }
407 
408     function DOMAIN_SEPARATOR() public view returns (bytes32) {
409         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
410     }
411 
412     function computeDomainSeparator() internal view returns (bytes32) {
413         return keccak256(
414             abi.encode(
415                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
416                 keccak256(bytes(name)),
417                 keccak256("1"),
418                 block.chainid,
419                 address(this)
420             )
421         );
422     }
423 
424     /*//////////////////////////////////////////////////////////////
425                         INTERNALS
426     //////////////////////////////////////////////////////////////*/
427 
428     function _mint(address to, uint256 amount) internal {
429         totalSupply += amount;
430 
431         UserInfo storage user = userInfo[to];
432 
433         // Cannot overflow because the sum of all user
434         // balances can't exceed the max uint256 value.
435         unchecked {
436             user.amount = uint224(uint256(user.amount) + amount);
437             user.minTaxOn = uint32(block.timestamp + TAX_DURATION);
438         }
439 
440         emit Transfer(address(0), to, amount);
441     }
442 
443     function _processTax(uint256 minTaxOn, uint256 amount) internal returns (uint256) {
444         if (minTaxOn <= block.timestamp) return amount;
445 
446         unchecked {
447             // cant overflow because:
448             // block.timestamp <= minTaxOn
449             // all numbers are small enough for type(uint256).max
450             uint256 taxAmount = MAX_TAX * (minTaxOn - block.timestamp) / TAX_DURATION * amount / HUNDRED_PERCENT;
451 
452             if (taxAmount != 0) {
453                 uint256 newAmount = taxAmount + userInfo[address(this)].amount;
454                 userInfo[address(this)].amount = uint224(newAmount);
455 
456                 address[] memory path = new address[](2);
457                 path[0] = address(this);
458                 path[1] = WETH;
459 
460                 try router.swapExactTokensForETH(newAmount, 0, path, TREASURY, block.timestamp) {
461                     // SWAP was successful.
462                 } catch {
463                     // Swap can fail if amount is too low, we dont want to handle it, next tax will sell everything together.
464                 }
465             }
466 
467             return (amount - taxAmount);
468         }
469     }
470 
471     function _revertOnMaxBuyExceeded(uint256 newAmount) internal view {
472         if (block.timestamp > MAX_BUY_DISABLED_TIME) {
473             return;
474         }
475 
476         if (block.timestamp > MAX_BUY_END_TIME) {
477             if (newAmount > MAX_BUY_ON_END) revert MaxBuyExceeded(MAX_BUY_ON_END, newAmount);
478         }
479 
480         unchecked {
481             // cant overflow because:
482             // MAX_BUY_ON_END > MAX_BUY_ON_START
483             // MAX_BUY_END_TIME >= block.timestamp
484             // all numbers are small enough for type(uint256).max
485             uint256 maxBuyAmount = MAX_BUY_ON_END
486                 - (MAX_BUY_END_TIME - block.timestamp) * (MAX_BUY_ON_END - MAX_BUY_ON_START) / MAX_BUY_DURATION;
487 
488             if (maxBuyAmount < newAmount) revert MaxBuyExceeded(maxBuyAmount, newAmount);
489         }
490     }
491 
492     function maxBuy() external view returns (uint256) {
493         if (block.timestamp > MAX_BUY_DISABLED_TIME) {
494             return type(uint256).max;
495         }
496 
497         if (block.timestamp > MAX_BUY_END_TIME) {
498             return MAX_BUY_ON_END;
499         }
500 
501         return MAX_BUY_ON_END
502             - (MAX_BUY_END_TIME - block.timestamp) * (MAX_BUY_ON_END - MAX_BUY_ON_START) / MAX_BUY_DURATION;
503     }
504 
505     function setIsAddressExcluded(address user, bool value) external onlyOwner {
506         isAddressExcluded[user] = value;
507 
508         emit IsAddressExcludedChanged(user, value);
509     }
510 
511     function renounceOwnership() external {
512         transferOwnership(address(0));
513     }
514 }