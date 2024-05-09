1 pragma solidity =0.8.4;
2 pragma experimental ABIEncoderV2;
3 // Leak alpha with https://twitter.com/mevalphaleak
4 
5 // All existing flash-loan providers have at least one of the following downsides
6 // - Taking excessive fee for the service
7 // - Hard to loan multiple assets at once
8 // - Horribly inefficient in terms of gas:
9 //  - Emitting pointless events
10 //  - Creating useless additional transfers
11 //  - No SLOAD/SSTORE optimisation past EIP-2929
12 
13 // ApeBank is introduced to make most gas efficient flash-loans available to everyone completely for free
14 // Combined with native gas refunds without any additional sstore operations
15 
16 // ApeBank doesnt use safeMath and cuts corners everywhere, it isn't suitable for flash-mintable tokens
17 // Contract wasnt audited by anyone and there's no benefit for depositing tokens into this contract and no APY
18 // Anyone with half-working brain should think twice before putting anything into this contract
19 contract ApeBank {
20     string  public   constant name = "https://twitter.com/mevalphaleak";
21     address internal constant TOKEN_ETH  = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
22     address internal constant TOKEN_WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
23     address internal constant TOKEN_WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
24     address internal constant TOKEN_DAI  = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
25     address internal constant TOKEN_USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
26     address internal constant TOKEN_USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
27 
28     uint256 internal constant TOKEN_WETH_MULTIPLIER = 10 ** 14; // 0.4$ at the time of contract creation
29     uint256 internal constant TOKEN_WBTC_MULTIPLIER = 10 ** 3;  // 0.5$ at the time of contract creation
30     uint256 internal constant TOKEN_DAI_MULTIPLIER  = 10 ** 18;
31     uint256 internal constant TOKEN_USDC_MULTIPLIER = 10 ** 6;
32     uint256 internal constant TOKEN_USDT_MULTIPLIER = 10 ** 6;
33 
34     uint256 internal constant FLAG_BORROW_ETH  = 0x1;
35     uint256 internal constant FLAG_BORROW_WETH = 0x2;
36     uint256 internal constant FLAG_BORROW_WBTC = 0x4;
37     uint256 internal constant FLAG_BORROW_DAI  = 0x8;
38     uint256 internal constant FLAG_BORROW_USDC = 0x10;
39     uint256 internal constant FLAG_BORROW_USDT = 0x20;
40     uint256 internal constant FLAG_COVER_WETH  = 0x40;
41 
42     uint256 internal constant FLAG_BURN_NATIVE = 0x80;
43     uint256 internal constant FLAG_BURN_GST2   = 0x100;
44     uint256 internal constant FLAG_BURN_CHI    = 0x200;
45 
46     uint256 internal constant FLAG_SMALL_CALLBACK = 0x400;
47     uint256 internal constant FLAG_LARGE_CALLBACK = 0x800;
48 
49     uint256 internal constant FLAG_FREE_GAS_TOKEN               = 0x1000;
50     uint256 internal constant FLAG_GAS_TOKEN_BURN_AMOUNT_SHIFT  = 0x1000000000000000000000000000000000000000000000000000000000000;
51 
52     Types.BankState public state;
53     Types.GasTokenPrices public gasTokenBurnPrices;
54 
55     // Total amount of tokens deposited into ApeBank, this value can be lower than balances in 'state'
56     mapping (address => uint256) public totalDeposits;
57     mapping (address => uint256) public userEthBalances;
58     mapping (address => Types.BankState) public userTokenBalances;
59     // Our hall of fame which allows to use gas tokens for free
60     mapping (address => bool) public bestApeOperators;
61     
62     // Used to collect excess balances and acquire gas tokens
63     address public treasury;
64     address public pendingTresury;
65 
66     event Deposit(address indexed user, address indexed token, uint256 amount);
67     event Withdrawal(address indexed user, address indexed token, uint256 amount);
68     event SkimmedBalance(address indexed treasury, address indexed token, uint256 amount);
69     event TreasuryUpdated(address indexed oldTreasury, address indexed newTreasury);
70 
71     constructor () {
72         treasury = msg.sender;
73         pendingTresury = 0x0000000000000000000000000000000000000000;
74         emit TreasuryUpdated(pendingTresury, treasury);
75     }
76     function nominateTreasury(address nomination) external {
77         require(msg.sender == treasury);
78         pendingTresury = nomination;
79     }
80     function acceptNomination() external {
81         require(msg.sender == pendingTresury);
82         emit TreasuryUpdated(treasury, pendingTresury);
83         treasury = pendingTresury;
84         pendingTresury = 0x0000000000000000000000000000000000000000;
85     }
86     function updateGasTokenPrices(uint80 priceGST2, uint80 priceCHI, uint80 priceNative) external {
87         require(msg.sender == treasury);
88         Types.GasTokenPrices memory cachedPrices;
89         cachedPrices.priceGST2 = priceGST2;
90         cachedPrices.priceCHI = priceCHI;
91         cachedPrices.priceNative = priceNative;
92         gasTokenBurnPrices = cachedPrices;
93     }
94     function promoteToFreeGasTokens(address apeOperator) external {
95         require(msg.sender == treasury);
96         bestApeOperators[apeOperator] = true;
97     }
98     
99     fallback() external payable {}
100 
101     // Logic to skim excess balances into treasury to acquire more gas tokens
102     function skimExcessBalances(address token) external {
103         require(msg.sender == treasury);
104         uint256 minBalanceToKeep = totalDeposits[token] + 1;
105 
106         Types.BankState memory cachedBankState = state;
107         uint256 availableBalance;
108         if (token == TOKEN_ETH) {
109             availableBalance = address(this).balance;
110             require(availableBalance > minBalanceToKeep);
111             TransferHelper.safeTransferETH(
112                 msg.sender,
113                 availableBalance - minBalanceToKeep
114             );
115             // ETH balances aren't saved in state
116         } else {
117             availableBalance = IERC20Token(token).balanceOf(address(this));
118             require(availableBalance > minBalanceToKeep);
119             TransferHelper.safeTransfer(
120                 token,
121                 msg.sender,
122                 availableBalance - minBalanceToKeep
123             );
124 
125             if (token == TOKEN_WETH) {
126                 cachedBankState.wethBalance = uint32(minBalanceToKeep / TOKEN_WETH_MULTIPLIER);
127             } else if (token == TOKEN_WBTC) {
128                 cachedBankState.wbtcBalance = uint32(minBalanceToKeep / TOKEN_WBTC_MULTIPLIER);
129             } else if (token == TOKEN_DAI) {
130                 cachedBankState.daiBalance  = uint32(minBalanceToKeep / TOKEN_DAI_MULTIPLIER );
131             } else if (token == TOKEN_USDC) {
132                 cachedBankState.usdcBalance = uint32(minBalanceToKeep / TOKEN_USDC_MULTIPLIER);
133             } else if (token == TOKEN_USDT) {
134                 cachedBankState.usdtBalance = uint32(minBalanceToKeep / TOKEN_USDT_MULTIPLIER);
135             }
136         }
137 
138         require(cachedBankState.numCalls == state.numCalls);
139         cachedBankState.numCalls += 1;
140         state = cachedBankState;
141         emit SkimmedBalance(msg.sender, token, availableBalance - minBalanceToKeep);
142     }
143 
144     function deposit(address token, uint256 amount) external payable {
145         Types.BankState memory cachedBankState = state;
146         if (msg.value > 0) {
147             require(token == TOKEN_ETH && msg.value == amount, "Incorrect deposit amount");
148             userEthBalances[msg.sender] += msg.value;
149         } else {
150             TransferHelper.safeTransferFrom(
151                 token,
152                 msg.sender,
153                 address(this),
154                 amount
155             );            
156             if (token == TOKEN_WETH) {
157                 require(amount % TOKEN_WETH_MULTIPLIER == 0, "Incorrect deposit amount");
158                 uint256 newBalance = cachedBankState.wethBalance + (amount / TOKEN_WETH_MULTIPLIER);
159                 require(newBalance < (2 ** 32), "Bank size is excessive");
160                 cachedBankState.wethBalance = uint32(newBalance);
161                 userTokenBalances[msg.sender].wethBalance += uint32(amount / TOKEN_WETH_MULTIPLIER);
162             } else if (token == TOKEN_WBTC) {
163                 require(amount % TOKEN_WBTC_MULTIPLIER == 0, "Incorrect deposit amount");
164                 uint256 newBalance = cachedBankState.wbtcBalance + (amount / TOKEN_WBTC_MULTIPLIER);
165                 require(newBalance < (2 ** 32), "Bank size is excessive");
166                 cachedBankState.wbtcBalance = uint32(newBalance);
167                 userTokenBalances[msg.sender].wbtcBalance += uint32(amount / TOKEN_WBTC_MULTIPLIER);
168             } else if (token == TOKEN_DAI) {
169                 require(amount % TOKEN_DAI_MULTIPLIER == 0, "Incorrect deposit amount");
170                 uint256 newBalance = cachedBankState.daiBalance + (amount / TOKEN_DAI_MULTIPLIER);
171                 require(newBalance < (2 ** 32), "Bank size is excessive");
172                 cachedBankState.daiBalance = uint32(newBalance);
173                 userTokenBalances[msg.sender].daiBalance += uint32(amount / TOKEN_DAI_MULTIPLIER);
174             } else if (token == TOKEN_USDC) {
175                 require(amount % TOKEN_USDC_MULTIPLIER == 0, "Incorrect deposit amount");
176                 uint256 newBalance = cachedBankState.usdcBalance + (amount / TOKEN_USDC_MULTIPLIER);
177                 require(newBalance < (2 ** 32), "Bank size is excessive");
178                 cachedBankState.usdcBalance = uint32(newBalance);
179                 userTokenBalances[msg.sender].usdcBalance += uint32(amount / TOKEN_USDC_MULTIPLIER);
180             } else {
181                 require(token == TOKEN_USDT, "Token not supported");
182                 require(amount % TOKEN_USDT_MULTIPLIER == 0, "Incorrect deposit amount");
183                 uint256 newBalance = cachedBankState.usdtBalance + (amount / TOKEN_USDT_MULTIPLIER);
184                 require(newBalance < (2 ** 32), "Bank size is excessive");
185                 cachedBankState.usdtBalance = uint32(newBalance);
186                 userTokenBalances[msg.sender].usdtBalance += uint32(amount / TOKEN_USDT_MULTIPLIER);
187             }
188         }
189         totalDeposits[token] += amount;
190         
191         require(cachedBankState.numCalls == state.numCalls);
192         cachedBankState.numCalls += 1;
193         state = cachedBankState;
194         emit Deposit(msg.sender, token, amount);
195     }
196 
197     function withdraw(address token, uint256 amount) external {
198         Types.BankState memory cachedBankState = state;
199         
200         totalDeposits[token] -= amount;
201         if (token == TOKEN_ETH) {
202             require(userEthBalances[msg.sender] >= amount);
203             userEthBalances[msg.sender] -= amount;
204             // ETH balances aren't saved into state
205             TransferHelper.safeTransferETH(
206                 msg.sender,
207                 amount
208             );
209         } else {
210             if (token == TOKEN_WETH) {
211                 require(amount % TOKEN_WETH_MULTIPLIER == 0, "Incorrect withdraw amount");
212                 uint256 amountDelta = amount / TOKEN_WETH_MULTIPLIER;
213                 require(uint256(userTokenBalances[msg.sender].wethBalance) >= amountDelta);
214                 userTokenBalances[msg.sender].wethBalance -= uint32(amountDelta);
215                 cachedBankState.wethBalance -= uint32(amountDelta);
216             } else if (token == TOKEN_WBTC) {
217                 require(amount % TOKEN_WBTC_MULTIPLIER == 0, "Incorrect withdraw amount");
218                 uint256 amountDelta = amount / TOKEN_WBTC_MULTIPLIER;
219                 require(uint256(userTokenBalances[msg.sender].wbtcBalance) >= amountDelta);
220                 userTokenBalances[msg.sender].wbtcBalance -= uint32(amountDelta);
221                 cachedBankState.wbtcBalance -= uint32(amountDelta);
222             } else if (token == TOKEN_DAI) {
223                 require(amount % TOKEN_DAI_MULTIPLIER == 0, "Incorrect withdraw amount");
224                 uint256 amountDelta = amount / TOKEN_DAI_MULTIPLIER;
225                 require(uint256(userTokenBalances[msg.sender].daiBalance) >= amountDelta);
226                 userTokenBalances[msg.sender].daiBalance -= uint32(amountDelta);
227                 cachedBankState.daiBalance -= uint32(amountDelta);
228             } else if (token == TOKEN_USDC) {
229                 require(amount % TOKEN_USDC_MULTIPLIER == 0, "Incorrect withdraw amount");
230                 uint256 amountDelta = amount / TOKEN_USDC_MULTIPLIER;
231                 require(uint256(userTokenBalances[msg.sender].usdcBalance) >= amountDelta);
232                 userTokenBalances[msg.sender].usdcBalance -= uint32(amountDelta);
233                 cachedBankState.usdcBalance -= uint32(amountDelta);
234             } else {
235                 require(token == TOKEN_USDT, "Token not supported");
236                 require(amount % TOKEN_USDT_MULTIPLIER == 0, "Incorrect withdraw amount");
237                 uint256 amountDelta = amount / TOKEN_USDT_MULTIPLIER;
238                 require(uint256(userTokenBalances[msg.sender].usdtBalance) >= amountDelta);
239                 userTokenBalances[msg.sender].usdtBalance -= uint32(amountDelta);
240                 cachedBankState.usdtBalance -= uint32(amountDelta);
241             }
242             TransferHelper.safeTransfer(
243                 token,
244                 msg.sender,
245                 amount
246             );        
247         }
248         
249         require(cachedBankState.numCalls == state.numCalls);
250         cachedBankState.numCalls += 1;
251         state = cachedBankState;
252         emit Withdrawal(msg.sender, token, amount);
253     }
254     
255     function flashApe(address payable callTo, uint256 flags, bytes calldata params) external payable {
256         Types.BankState memory cachedBankState = state;
257 
258         if ((flags & FLAG_BORROW_WETH) > 0) {
259             TransferHelper.safeTransfer(
260                 TOKEN_WETH,
261                 callTo,
262                 uint256(cachedBankState.wethBalance) * TOKEN_WETH_MULTIPLIER
263             );
264         }
265         if ((flags & (FLAG_BORROW_WBTC | FLAG_BORROW_DAI | FLAG_BORROW_USDC | FLAG_BORROW_USDT)) > 0) {
266             if ((flags & FLAG_BORROW_WBTC) > 0) {
267                 TransferHelper.safeTransfer(
268                     TOKEN_WBTC,
269                     callTo,
270                     uint256(cachedBankState.wbtcBalance) * TOKEN_WBTC_MULTIPLIER
271                 );
272             }
273             if ((flags & FLAG_BORROW_DAI) > 0) {
274                 TransferHelper.safeTransfer(
275                     TOKEN_DAI,
276                     callTo,
277                     uint256(cachedBankState.daiBalance) * TOKEN_DAI_MULTIPLIER
278                 );
279             }
280             if ((flags & FLAG_BORROW_USDC) > 0) {
281                 TransferHelper.safeTransfer(
282                     TOKEN_USDC,
283                     callTo,
284                     uint256(cachedBankState.usdcBalance) * TOKEN_USDC_MULTIPLIER
285                 );
286             }
287             if ((flags & FLAG_BORROW_USDT) > 0) {
288                 TransferHelper.safeTransfer(
289                     TOKEN_USDT,
290                     callTo,
291                     uint256(cachedBankState.usdtBalance) * TOKEN_USDT_MULTIPLIER
292                 );
293             }
294         }
295         uint256 oldSelfBalance = address(this).balance;
296 
297         // For "ease" of integration allowing several different callback options
298         if ((flags & (FLAG_SMALL_CALLBACK | FLAG_LARGE_CALLBACK)) > 0) {
299             // Native payable callbacks
300             if ((flags & FLAG_SMALL_CALLBACK) > 0) {
301                 IApeBot(callTo).smallApeCallback{value: ((flags & FLAG_BORROW_ETH) > 0) ? oldSelfBalance - 1 : 0}(
302                     params
303                 );
304             } else {
305                 IApeBot(callTo).largeApeCallback{value: ((flags & FLAG_BORROW_ETH) > 0) ? oldSelfBalance - 1 : 0}(
306                     msg.sender,
307                     (((flags & FLAG_BORROW_WETH) > 0) ? uint256(cachedBankState.wethBalance) * TOKEN_WETH_MULTIPLIER : 0),
308                     (((flags & FLAG_BORROW_WBTC) > 0) ? uint256(cachedBankState.wbtcBalance) * TOKEN_WBTC_MULTIPLIER : 0),
309                     (((flags & FLAG_BORROW_DAI ) > 0) ? uint256(cachedBankState.daiBalance ) * TOKEN_DAI_MULTIPLIER  : 0),
310                     (((flags & FLAG_BORROW_USDC) > 0) ? uint256(cachedBankState.usdcBalance) * TOKEN_USDC_MULTIPLIER : 0),
311                     (((flags & FLAG_BORROW_USDT) > 0) ? uint256(cachedBankState.usdtBalance) * TOKEN_USDT_MULTIPLIER : 0),
312                     params
313                 );
314             }
315         } else {
316             // Immitating popular non-payable callback
317             if ((flags & FLAG_BORROW_ETH) > 0) {
318                 TransferHelper.safeTransferETH(
319                     callTo,
320                     oldSelfBalance - 1
321                 );
322             }
323             IApeBot(callTo).callFunction(
324                 msg.sender,
325                 Types.AccountInfo({
326                     owner: address(msg.sender),
327                     number: 1
328                 }),
329                 params
330             );
331         }
332 
333         // Verifying that all funds were returned
334         // If Ether was sent into this function it shouldn't be counted against original balance
335         oldSelfBalance -= msg.value;
336         uint256 newSelfBalance = address(this).balance;
337         // Performing gas refunds
338         if ((flags & (FLAG_BURN_NATIVE | FLAG_BURN_GST2 | FLAG_BURN_CHI)) > 0) {
339             // No point in burning more than 256 tokens
340             uint32 tokensToBurn = uint32((flags / FLAG_GAS_TOKEN_BURN_AMOUNT_SHIFT) & 0xff);
341 
342             Types.GasTokenPrices memory cachedBurnPrices;
343             if ((flags & FLAG_FREE_GAS_TOKEN) > 0) {
344                 // Bot can enter hall of fame and get free gas tokens for life
345                 require(bestApeOperators[msg.sender]);
346             } else {
347                 // Otherwise price of these gas tokens would have to be deducted
348                 cachedBurnPrices = gasTokenBurnPrices;
349             }
350 
351             if (((flags & FLAG_BURN_NATIVE) > 0) && (cachedBankState.totalContractsCreated > cachedBankState.firstContractToDestroy + tokensToBurn)) {
352                 _destroyContracts(cachedBankState.firstContractToDestroy, cachedBankState.firstContractToDestroy + tokensToBurn);
353                 cachedBankState.firstContractToDestroy += tokensToBurn;
354                 require(newSelfBalance > tokensToBurn * cachedBurnPrices.priceNative);
355                 newSelfBalance -= tokensToBurn * cachedBurnPrices.priceNative;
356             } else if ((flags & FLAG_BURN_GST2) > 0) {
357                 IGasToken(0x0000000000b3F879cb30FE243b4Dfee438691c04).free(tokensToBurn);
358                 require(newSelfBalance > tokensToBurn * cachedBurnPrices.priceGST2);
359                 newSelfBalance -= tokensToBurn * cachedBurnPrices.priceGST2;
360             } else if ((flags & FLAG_BURN_CHI) > 0) {
361                 IGasToken(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c).free(tokensToBurn);
362                 require(newSelfBalance > tokensToBurn * cachedBurnPrices.priceCHI);
363                 newSelfBalance -= tokensToBurn * cachedBurnPrices.priceCHI;
364             }
365         }
366 
367         if ((flags & (FLAG_BORROW_WETH | FLAG_COVER_WETH)) > 0) {
368             // We can combine ETH and WETH balances in this case
369             uint256 wethBalance = IERC20Token(TOKEN_WETH).balanceOf(address(this));
370             require(wethBalance < (2 ** 32) * TOKEN_WETH_MULTIPLIER && (newSelfBalance + wethBalance > oldSelfBalance + uint256(cachedBankState.wethBalance) * TOKEN_WETH_MULTIPLIER));
371 
372             if (wethBalance <= uint256(cachedBankState.wethBalance) * TOKEN_WETH_MULTIPLIER) {
373                 // User didn't return enough WETH covering via excess ETH
374                 uint256 deltaToCover = uint256(cachedBankState.wethBalance) * TOKEN_WETH_MULTIPLIER + 1 - wethBalance;
375                 require(newSelfBalance >= oldSelfBalance + deltaToCover);
376 
377                 WETH9(TOKEN_WETH).deposit{value: deltaToCover}();
378                 // newSelfBalance won't be used anywhere below
379                 // WETH balance stays the same in the newState
380             } else if (newSelfBalance < oldSelfBalance) {
381                 // User didn't return enough ETH covering via excess WETH
382                 require(wethBalance > uint256(cachedBankState.wethBalance) * TOKEN_WETH_MULTIPLIER + (oldSelfBalance - newSelfBalance));
383 
384                 WETH9(TOKEN_WETH).withdraw(oldSelfBalance - newSelfBalance);
385                 // newSelfBalance won't be used anywhere below
386                 cachedBankState.wethBalance = uint32((wethBalance - (oldSelfBalance - newSelfBalance)) / TOKEN_WETH_MULTIPLIER);
387             } else {
388                 cachedBankState.wethBalance = uint32(wethBalance / TOKEN_WETH_MULTIPLIER);
389             }
390         } else {
391             require(newSelfBalance >= oldSelfBalance);
392         }
393 
394         if ((flags & (FLAG_BORROW_WBTC | FLAG_BORROW_DAI | FLAG_BORROW_USDC | FLAG_BORROW_USDT)) > 0) {
395             if ((flags & FLAG_BORROW_WBTC) > 0) {
396                 uint256 wbtcBalance = IERC20Token(TOKEN_WBTC).balanceOf(address(this));
397                 // We use strict comparison here to make sure that token transfers always cost 5k gas and not (20k - 15k)
398                 require(wbtcBalance < (2 ** 32) * TOKEN_WBTC_MULTIPLIER && wbtcBalance > uint256(cachedBankState.wbtcBalance) * TOKEN_WBTC_MULTIPLIER);
399                 cachedBankState.wbtcBalance = uint32(wbtcBalance / TOKEN_WBTC_MULTIPLIER);
400             }
401             if ((flags & FLAG_BORROW_DAI) > 0) {
402                 uint256 daiBalance = IERC20Token(TOKEN_DAI).balanceOf(address(this));
403                 // We use strict comparison here to make sure that token transfers always cost 5k gas and not (20k - 15k)
404                 require(daiBalance < (2 ** 32) * TOKEN_DAI_MULTIPLIER && daiBalance > uint256(cachedBankState.daiBalance) * TOKEN_DAI_MULTIPLIER);
405                 cachedBankState.daiBalance = uint32(daiBalance / TOKEN_DAI_MULTIPLIER);
406             }
407             if ((flags & FLAG_BORROW_USDC) > 0) {
408                 uint256 usdcBalance = IERC20Token(TOKEN_USDC).balanceOf(address(this));
409                 // We use strict comparison here to make sure that token transfers always cost 5k gas and not (20k - 15k)
410                 require(usdcBalance < (2 ** 32) * TOKEN_USDC_MULTIPLIER && usdcBalance > uint256(cachedBankState.usdcBalance) * TOKEN_USDC_MULTIPLIER);
411                 cachedBankState.usdcBalance = uint32(usdcBalance / TOKEN_USDC_MULTIPLIER);
412             }
413             if ((flags & FLAG_BORROW_USDT) > 0) {
414                 uint256 usdtBalance = IERC20Token(TOKEN_USDT).balanceOf(address(this));
415                 // We use strict comparison here to make sure that token transfers always cost 5k gas and not (20k - 15k)
416                 require(usdtBalance < (2 ** 32) * TOKEN_USDT_MULTIPLIER && usdtBalance > uint256(cachedBankState.usdtBalance) * TOKEN_USDT_MULTIPLIER);
417                 cachedBankState.usdtBalance = uint32(usdtBalance / TOKEN_USDT_MULTIPLIER);
418             }
419         }
420 
421         require(cachedBankState.numCalls == state.numCalls);
422         cachedBankState.numCalls += 1;
423         state = cachedBankState;
424     }
425 
426     // Logic related to native gas refunds, it's very short but brainfuck level ugly
427     function generateContracts(uint256 amount) external {
428         Types.BankState memory cachedState = state;
429         uint256 offset = cachedState.totalContractsCreated;
430         assembly {
431             mstore(callvalue(), 0x766f454a11ca3a574738c0aab442b62d5d453318585733FF60005260176009f3)
432             for {let i := div(amount, 32)} i {i := sub(i, 1)} {
433                 pop(create2(callvalue(), callvalue(), 32, offset))          pop(create2(callvalue(), callvalue(), 32, add(offset, 1)))
434                 pop(create2(callvalue(), callvalue(), 32, add(offset, 2)))  pop(create2(callvalue(), callvalue(), 32, add(offset, 3)))
435                 pop(create2(callvalue(), callvalue(), 32, add(offset, 4)))  pop(create2(callvalue(), callvalue(), 32, add(offset, 5)))
436                 pop(create2(callvalue(), callvalue(), 32, add(offset, 6)))  pop(create2(callvalue(), callvalue(), 32, add(offset, 7)))
437                 pop(create2(callvalue(), callvalue(), 32, add(offset, 8)))  pop(create2(callvalue(), callvalue(), 32, add(offset, 9)))
438                 pop(create2(callvalue(), callvalue(), 32, add(offset, 10))) pop(create2(callvalue(), callvalue(), 32, add(offset, 11)))
439                 pop(create2(callvalue(), callvalue(), 32, add(offset, 12))) pop(create2(callvalue(), callvalue(), 32, add(offset, 13)))
440                 pop(create2(callvalue(), callvalue(), 32, add(offset, 14))) pop(create2(callvalue(), callvalue(), 32, add(offset, 15)))
441                 pop(create2(callvalue(), callvalue(), 32, add(offset, 16))) pop(create2(callvalue(), callvalue(), 32, add(offset, 17)))
442                 pop(create2(callvalue(), callvalue(), 32, add(offset, 18))) pop(create2(callvalue(), callvalue(), 32, add(offset, 19)))
443                 pop(create2(callvalue(), callvalue(), 32, add(offset, 20))) pop(create2(callvalue(), callvalue(), 32, add(offset, 21)))
444                 pop(create2(callvalue(), callvalue(), 32, add(offset, 22))) pop(create2(callvalue(), callvalue(), 32, add(offset, 23)))
445                 pop(create2(callvalue(), callvalue(), 32, add(offset, 24))) pop(create2(callvalue(), callvalue(), 32, add(offset, 25)))
446                 pop(create2(callvalue(), callvalue(), 32, add(offset, 26))) pop(create2(callvalue(), callvalue(), 32, add(offset, 27)))
447                 pop(create2(callvalue(), callvalue(), 32, add(offset, 28))) pop(create2(callvalue(), callvalue(), 32, add(offset, 29)))
448                 pop(create2(callvalue(), callvalue(), 32, add(offset, 30))) pop(create2(callvalue(), callvalue(), 32, add(offset, 31)))
449                 offset := add(offset, 32)
450             }
451 
452             for {let i := and(amount, 0x1F)} i {i := sub(i, 1)} {
453                 pop(create2(callvalue(), callvalue(), 32, offset))
454                 offset := add(offset, 1)
455             }
456         }
457 
458         require(cachedState.numCalls == state.numCalls && offset < 2 ** 32);
459         cachedState.totalContractsCreated = uint32(offset);
460         cachedState.numCalls += 1;
461         state = cachedState;
462     }
463     function _destroyContracts(uint256 firstSlot, uint256 lastSlot) internal {
464         assembly {
465             let i := firstSlot
466 
467             let data := mload(0x40)
468             mstore(data, 0xff00000000454a11ca3a574738c0aab442b62d5d450000000000000000000000)
469             mstore(add(data, 53), 0x51b94132314e7e963fa256338c05c5dd9c15d277c686d6750c3bc97835a1ed27)
470             let ptr := add(data, 21)
471             for { } lt(i, lastSlot) { i := add(i, 1) } {
472                 mstore(ptr, i)
473                 pop(call(gas(), keccak256(data, 85), 0, 0, 0, 0, 0))
474             }
475         }
476     }
477 }
478 
479 interface IApeBot {
480     function smallApeCallback(bytes calldata data) external payable;
481     function largeApeCallback(
482         address sender,
483         uint wethToReturn,
484         uint wbtcToReturn,
485         uint daiToReturn,
486         uint usdcToReturn,
487         uint usdtToReturn,
488         bytes calldata data
489     ) external payable;
490     function callFunction(address sender, Types.AccountInfo memory accountInfo, bytes memory data) external;
491 }
492 
493 library Types {
494     struct BankState {
495         uint32 wethBalance;
496         uint32 wbtcBalance;
497         uint32 daiBalance;
498         uint32 usdcBalance;
499         uint32 usdtBalance;
500         uint32 firstContractToDestroy;
501         uint32 totalContractsCreated;
502         uint32 numCalls;
503     }
504     struct GasTokenPrices {
505         uint80 priceGST2;
506         uint80 priceCHI;
507         uint80 priceNative;
508     }
509     struct AccountInfo {
510         address owner;
511         uint256 number;
512     }
513 }
514 
515 
516 library TransferHelper {
517     function safeApprove(address token, address to, uint value) internal {
518         // bytes4(keccak256(bytes('approve(address,uint256)')));
519         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
520         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
521     }
522 
523     function safeTransfer(address token, address to, uint value) internal {
524         // bytes4(keccak256(bytes('transfer(address,uint256)')));
525         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
526         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
527     }
528 
529     function safeTransferFrom(address token, address from, address to, uint value) internal {
530         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
531         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
532         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
533     }
534 
535     function safeTransferETH(address to, uint value) internal {
536         (bool success,) = to.call{value:value}(new bytes(0));
537         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
538     }
539 }
540 
541 // Only relevant calls in interfaces below
542 interface IERC20Token {
543     function balanceOf(address _owner) external view returns (uint256);
544     function allowance(address _owner, address _spender) external view returns (uint256);
545     function transfer(address _to, uint256 _value) external returns (bool success);
546     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
547     function approve(address _spender, uint256 _value) external returns (bool success);
548 }
549 interface WETH9 {
550     function deposit() external payable;
551     function withdraw(uint wad) external;
552 }
553 interface IGasToken {
554     function free(uint256 value) external returns (uint256);
555 }