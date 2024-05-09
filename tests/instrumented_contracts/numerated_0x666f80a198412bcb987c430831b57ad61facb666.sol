1 pragma solidity =0.8.4;
2 pragma experimental ABIEncoderV2;
3 // Leak alpha for run and profit with https://twitter.com/mevalphaleak
4 
5 contract DyDxFlashLoanHelper {
6     function marketIdFromTokenAddress(address tokenAddress) internal pure returns (uint256 resultId) {
7         assembly {
8             switch tokenAddress
9             case 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 {
10                 resultId := 0
11             }
12             case 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 {
13                 resultId := 2
14             }
15             case 0x6B175474E89094C44Da98b954EedeAC495271d0F {
16                 resultId := 3
17             }
18             default {
19                 revert(0, 0)
20             }
21         }
22     }
23     function wrapWithDyDx(address requiredToken, uint256 requiredBalance, bool requiredApprove, bytes calldata data) public {
24         Types.ActionArgs[] memory operations = new Types.ActionArgs[](3);
25         operations[0] = Types.ActionArgs({
26             actionType: Types.ActionType.Withdraw,
27             accountId: 0,
28             amount: Types.AssetAmount({
29                 sign: false,
30                 denomination: Types.AssetDenomination.Wei,
31                 ref: Types.AssetReference.Delta,
32                 value: requiredBalance
33             }),
34             primaryMarketId: marketIdFromTokenAddress(requiredToken),
35             secondaryMarketId: 0,
36             otherAddress: address(this),
37             otherAccountId: 0,
38             data: ""
39         });
40         operations[1] = Types.ActionArgs({
41             actionType: Types.ActionType.Call,
42             accountId: 0,
43             amount: Types.AssetAmount({
44                 sign: false,
45                 denomination: Types.AssetDenomination.Wei,
46                 ref: Types.AssetReference.Delta,
47                 value: 0
48             }),
49             primaryMarketId: 0,
50             secondaryMarketId: 0,
51             otherAddress: address(this),
52             otherAccountId: 0,
53             data: data
54         });
55         operations[2] = Types.ActionArgs({
56             actionType: Types.ActionType.Deposit,
57             accountId: 0,
58             amount: Types.AssetAmount({
59                 sign: true,
60                 denomination: Types.AssetDenomination.Wei,
61                 ref: Types.AssetReference.Delta,
62                 value: requiredBalance + (requiredToken == 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 ? 1 : 2)
63             }),
64             primaryMarketId: marketIdFromTokenAddress(requiredToken),
65             secondaryMarketId: 0,
66             otherAddress: address(this),
67             otherAccountId: 0,
68             data: ""
69         });
70 
71         Types.AccountInfo[] memory accountInfos = new Types.AccountInfo[](1);
72         accountInfos[0] = Types.AccountInfo({
73             owner: address(this),
74             number: 1
75         });
76         if (requiredApprove) {
77           // Approval might be already set or can be set inside of 'operations[1]'
78           IERC20Token(requiredToken).approve(
79             0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e,
80             0xffffffffffffffffffffffffffffffff // Max uint112
81           );
82         }
83         ISoloMargin(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e).operate(accountInfos, operations);
84     }
85 }
86 
87 contract IAlphaLeakConstants {
88     address internal constant TOKEN_WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
89     address internal constant TOKEN_USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
90     address internal constant TOKEN_DAI  = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
91 
92     address internal constant PROXY_DYDX  = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;
93     address internal constant ORACLE_USDC = 0x986b5E1e1755e3C2440e960477f25201B0a8bbD4;
94     address internal constant ORACLE_DAI  = 0x773616E4d11A78F511299002da57A0a94577F1f4;
95 
96     uint256 internal constant FLAG_TRANSFORM_ETH_TO_WETH_BEFORE_APE = 0x1;
97     uint256 internal constant FLAG_TRANSFORM_WETH_TO_ETH_BEFORE_APE = 0x2;
98     uint256 internal constant FLAG_TRANSFORM_ETH_TO_WETH_AFTER_APE  = 0x4;
99     uint256 internal constant FLAG_TRANSFORM_WETH_TO_ETH_AFTER_APE  = 0x8;
100 
101     uint256 internal constant FLAG_FLASH_DYDY_WETH     = 0x10;
102     uint256 internal constant FLAG_FLASH_DYDY_USDC     = 0x20;
103     uint256 internal constant FLAG_FLASH_DYDY_DAI      = 0x40;
104 
105     uint256 internal constant FLAG_WETH_ACCOUNTING     = 0x80;
106     uint256 internal constant FLAG_USDC_ACCOUNTING     = 0x100;
107     uint256 internal constant FLAG_DAI_ACCOUNTING      = 0x200;
108 
109 
110     uint256 internal constant FLAG_EXIT_WETH           = 0x400;
111     uint256 internal constant FLAG_PAY_COINBASE_SHARE  = 0x800;
112     uint256 internal constant FLAG_PAY_COINBASE_AMOUNT = 0x1000;
113 
114 
115     uint256 internal constant FLAG_RETURN_WETH         = 0x2000;
116     uint256 internal constant FLAG_RETURN_USDC         = 0x4000;
117     uint256 internal constant FLAG_RETURN_DAI          = 0x8000;
118 }
119 
120 contract ApeBot is DyDxFlashLoanHelper, IAlphaLeakConstants {
121     string  public constant name = "https://twitter.com/mevalphaleak";
122 
123     fallback() external payable {}
124     function callFunction(
125         address,
126         Types.AccountInfo memory,
127         bytes calldata data
128     ) external {
129         // Added to support DyDx flash loans natively
130         // Security checks aren't necessary since I'm an ape
131         address(this).call(data);
132     }
133     function executeOperation(
134         address,
135         uint256,
136         uint256,
137         bytes calldata _params
138     ) external {
139         // Added to support AAVE v1 flash loans natively
140         // Security checks aren't necessary since I'm an ape
141         address(this).call(_params);
142     }
143     function executeOperation(
144         address[] calldata,
145         uint256[] calldata,
146         uint256[] calldata,
147         address,
148         bytes calldata params
149     )
150         external
151         returns (bool)
152     {
153         // Added to support AAVE v2 flash loans natively
154         // Security checks aren't necessary since I'm an ape
155         address(this).call(params);
156         return true;
157     }
158 
159     function uniswapV2Call(
160         address,
161         uint,
162         uint,
163         bytes calldata data
164     ) external {
165         // Added to support uniswap v2 flash swaps natively
166         // Security checks aren't necessary since I'm an ape
167         address(this).call(data);
168     }
169     function uniswapV3FlashCallback(
170         uint256,
171         uint256,
172         bytes calldata data
173     ) external {
174         // Added to support uniswap v3 flash loans natively
175         // Security checks aren't necessary since I'm an ape
176         address(this).call(data);
177     }
178     function uniswapV3MintCallback(
179         uint256,
180         uint256,
181         bytes calldata data
182     ) external {
183         // Added to support uniswap v3 flash mints natively
184         // Security checks aren't necessary since I'm an ape
185         address(this).call(data);
186     }
187     function uniswapV3SwapCallback(
188         int256,
189         int256,
190         bytes calldata data
191     ) external {
192         // Added to support uniswap v3 flash swaps natively
193         // Security checks aren't necessary since I'm an ape
194         address(this).call(data);
195     }
196 
197     // All funds left on this contract will be imidiately lost to snipers
198     // This function is completely permision-less and allows anyone to execute any arbitrary logic
199     // Overall goal is to make a contract which allows to execute all types of nested flash loans
200     function ape(uint256 actionFlags, uint256[] memory data) public payable {
201         // FLAGS are used to simplify some common actions, they aren't necessary
202         if ((actionFlags & (FLAG_TRANSFORM_ETH_TO_WETH_BEFORE_APE | FLAG_TRANSFORM_WETH_TO_ETH_BEFORE_APE)) > 0) {
203             if ((actionFlags & FLAG_TRANSFORM_ETH_TO_WETH_BEFORE_APE) > 0) {
204                 uint selfbalance = address(this).balance;
205                 if (selfbalance > 1) WETH9(TOKEN_WETH).deposit{value: selfbalance - 1}();
206             } else {
207                 uint wethbalance = IERC20Token(TOKEN_WETH).balanceOf(address(this));
208                 if (wethbalance > 1) WETH9(TOKEN_WETH).withdraw(wethbalance - 1);
209             }
210         }
211 
212         uint callId = 0;
213         for (; callId < data.length;) {
214             assembly {
215                 let callInfo := mload(add(data, mul(add(callId, 1), 0x20)))
216                 let callLength := and(div(callInfo, 0x1000000000000000000000000000000000000000000000000000000), 0xffff)
217                 let p := mload(0x40)   // Find empty storage location using "free memory pointer"
218                 // Place signature at begining of empty storage, hacky logic to compute shift here
219                 let callSignDataShiftResult := mul(and(callInfo, 0xffffffff0000000000000000000000000000000000000000000000), 0x10000000000)
220                 switch callSignDataShiftResult
221                 case 0 {
222                     callLength := mul(callLength, 0x20)
223                     callSignDataShiftResult := add(data, mul(0x20, add(callId, 3)))
224                     for { let i := 0 } lt(i, callLength) { i := add(i, 0x20) } {
225                         mstore(add(p, i), mload(add(callSignDataShiftResult, i)))
226                     }
227                 }
228                 default {
229                     mstore(p, callSignDataShiftResult)
230                     callLength := add(mul(callLength, 0x20), 4)
231                     callSignDataShiftResult := add(data, sub(mul(0x20, add(callId, 3)), 4))
232                     for { let i := 4 } lt(i, callLength) { i := add(i, 0x20) } {
233                         mstore(add(p, i), mload(add(callSignDataShiftResult, i)))
234                     }
235                 }
236 
237                 mstore(0x40, add(p, add(callLength, 0x20)))
238                 // new free pointer position after the output values of the called function.
239 
240                 let callContract := and(callInfo, 0xffffffffffffffffffffffffffffffffffffffff)
241                 // Re-use callSignDataShiftResult as success
242                 switch and(callInfo, 0xf000000000000000000000000000000000000000000000000000000000000000)
243                 case 0x1000000000000000000000000000000000000000000000000000000000000000 {
244                     callSignDataShiftResult := delegatecall(
245                                     and(div(callInfo, 0x10000000000000000000000000000000000000000), 0xffffff), // allowed gas to use
246                                     callContract, // contract to execute
247                                     p,    // Inputs are at location p
248                                     callLength, //Inputs size
249                                     p,    //Store output over input
250                                     0x20) //Output is 32 bytes long
251                 }
252                 default {
253                     callSignDataShiftResult := call(
254                                     and(div(callInfo, 0x10000000000000000000000000000000000000000), 0xffffff), // allowed gas to use
255                                     callContract, // contract to execute
256                                     mload(add(data, mul(add(callId, 2), 0x20))), // wei value amount
257                                     p,    // Inputs are at location p
258                                     callLength, //Inputs size
259                                     p,    //Store output over input
260                                     0x20) //Output is 32 bytes long
261                 }
262 
263                 callSignDataShiftResult := and(div(callInfo, 0x10000000000000000000000000000000000000000000000000000000000), 0xff)
264                 if gt(callSignDataShiftResult, 0) {
265                     // We're copying call result as input to some futher call
266                     mstore(add(data, mul(callSignDataShiftResult, 0x20)), mload(p))
267                 }
268                 callId := add(callId, add(and(div(callInfo, 0x1000000000000000000000000000000000000000000000000000000), 0xffff), 2))
269                 mstore(0x40, p) // Set storage pointer to empty space
270             }
271         }
272 
273         // FLAGS are used to simplify some common actions, they aren't necessary
274         if ((actionFlags & (FLAG_TRANSFORM_ETH_TO_WETH_AFTER_APE | FLAG_TRANSFORM_WETH_TO_ETH_AFTER_APE)) > 0) {
275             if ((actionFlags & FLAG_TRANSFORM_ETH_TO_WETH_AFTER_APE) > 0) {
276                 uint selfbalance = address(this).balance;
277                 if (selfbalance > 1) WETH9(TOKEN_WETH).deposit{value: selfbalance - 1}();
278             } else {
279                 uint wethbalance = IERC20Token(TOKEN_WETH).balanceOf(address(this));
280                 if (wethbalance > 1) WETH9(TOKEN_WETH).withdraw(wethbalance - 1);
281             }
282         }
283     }
284 
285     // Function signature 0x00000000
286     // Should be main entry point for any simple MEV searcher
287     // Though you can always use 'ape' function directly with general purpose logic
288     function wfjizxua(
289         uint256 actionFlags,
290         uint256[] calldata actionData
291     ) external payable returns(int256 ethProfitDelta) {
292         int256[4] memory balanceDeltas;
293         balanceDeltas[0] = int256(address(this).balance);
294         if ((actionFlags & (FLAG_WETH_ACCOUNTING | FLAG_USDC_ACCOUNTING | FLAG_DAI_ACCOUNTING)) > 0) {
295             // In general ACCOUNTING flags should be used only during simulation and not production to avoid wasting gas on oracle calls
296             if ((actionFlags & FLAG_WETH_ACCOUNTING) > 0) {
297                 balanceDeltas[1] = int256(IERC20Token(TOKEN_WETH).balanceOf(address(this)));
298             }
299             if ((actionFlags & FLAG_USDC_ACCOUNTING) > 0) {
300                 balanceDeltas[2] = int256(IERC20Token(TOKEN_USDC).balanceOf(address(this)));
301             }
302             if ((actionFlags & FLAG_DAI_ACCOUNTING) > 0) {
303                 balanceDeltas[3] = int256(IERC20Token(TOKEN_DAI).balanceOf(address(this)));
304             }
305         }
306 
307         if ((actionFlags & (FLAG_FLASH_DYDY_WETH | FLAG_FLASH_DYDY_USDC | FLAG_FLASH_DYDY_DAI)) > 0) {
308             // This simple logic only supports single token flashloans
309             // For multiple tokens or multiple providers you should use general purpose logic using 'ape' function
310             if ((actionFlags & FLAG_FLASH_DYDY_WETH) > 0) {
311                 uint256 balanceToFlash = IERC20Token(TOKEN_WETH).balanceOf(PROXY_DYDX);
312                 this.wrapWithDyDx(
313                     TOKEN_WETH,
314                     balanceToFlash - 1,
315                     IERC20Token(TOKEN_WETH).allowance(address(this), PROXY_DYDX) < balanceToFlash,
316                     abi.encodeWithSignature('ape(uint256,uint256[])', actionFlags, actionData)
317                 );
318             } else if ((actionFlags & FLAG_FLASH_DYDY_USDC) > 0) {
319                 uint256 balanceToFlash = IERC20Token(TOKEN_USDC).balanceOf(PROXY_DYDX);
320                 this.wrapWithDyDx(
321                     TOKEN_USDC,
322                     balanceToFlash - 1,
323                     IERC20Token(TOKEN_USDC).allowance(address(this), PROXY_DYDX) < balanceToFlash,
324                     abi.encodeWithSignature('ape(uint256,uint256[])', actionFlags, actionData)
325                 );
326             } else if ((actionFlags & FLAG_FLASH_DYDY_DAI) > 0) {
327                 uint256 balanceToFlash = IERC20Token(TOKEN_DAI).balanceOf(PROXY_DYDX);
328                 this.wrapWithDyDx(
329                     TOKEN_DAI,
330                     balanceToFlash - 1,
331                     IERC20Token(TOKEN_DAI).allowance(address(this), PROXY_DYDX) < balanceToFlash,
332                     abi.encodeWithSignature('ape(uint256,uint256[])', actionFlags, actionData)
333                 );
334             }
335         } else {
336             this.ape(actionFlags, actionData);
337         }
338 
339         if ((actionFlags & FLAG_EXIT_WETH) > 0) {
340             uint wethbalance = IERC20Token(TOKEN_WETH).balanceOf(address(this));
341             if (wethbalance > 1) WETH9(TOKEN_WETH).withdraw(wethbalance - 1);
342         }
343 
344 
345         ethProfitDelta = int256(address(this).balance) - balanceDeltas[0];
346         if ((actionFlags & (FLAG_WETH_ACCOUNTING | FLAG_USDC_ACCOUNTING | FLAG_DAI_ACCOUNTING)) > 0) {
347             if ((actionFlags & FLAG_WETH_ACCOUNTING) > 0) {
348                 ethProfitDelta += int256(IERC20Token(TOKEN_WETH).balanceOf(address(this))) - balanceDeltas[1];
349             }
350             if ((actionFlags & FLAG_USDC_ACCOUNTING) > 0) {
351                 ethProfitDelta += (int256(IERC20Token(TOKEN_USDC).balanceOf(address(this))) - balanceDeltas[2]) * IChainlinkAggregator(ORACLE_USDC).latestAnswer() / (1 ether);
352             }
353             if ((actionFlags & FLAG_DAI_ACCOUNTING) > 0) {
354                 ethProfitDelta += (int256(IERC20Token(TOKEN_DAI).balanceOf(address(this))) - balanceDeltas[3]) * IChainlinkAggregator(ORACLE_DAI).latestAnswer() / (1 ether);
355             }
356         }
357 
358 
359         if ((actionFlags & FLAG_PAY_COINBASE_AMOUNT) > 0) {
360             uint selfbalance = address(this).balance;
361             uint amountToPay = actionFlags / 0x100000000000000000000000000000000;
362             if (selfbalance < amountToPay) {
363                 // Attempting to cover the gap via WETH token
364                 WETH9(TOKEN_WETH).withdraw(amountToPay - selfbalance);
365             }
366             payable(block.coinbase).transfer(amountToPay);
367         } else if ((actionFlags & FLAG_PAY_COINBASE_SHARE) > 0) {
368             uint selfbalance = address(this).balance;
369             uint amountToPay = (actionFlags / 0x100000000000000000000000000000000) * uint256(ethProfitDelta) / (1 ether);
370             if (selfbalance < amountToPay) {
371                 // Attempting to cover the gap via WETH token
372                 WETH9(TOKEN_WETH).withdraw(amountToPay - selfbalance);
373             }
374             payable(block.coinbase).transfer(amountToPay);
375         }
376 
377         uint selfBalance = address(this).balance;
378         if (selfBalance > 1) payable(msg.sender).transfer(selfBalance - 1);
379         if ((actionFlags & (FLAG_RETURN_WETH | FLAG_RETURN_USDC | FLAG_RETURN_DAI)) > 0) {
380             // Majority of simple atomic arbs should just need ETH
381             if ((actionFlags & FLAG_RETURN_WETH) > 0) {
382                 uint tokenBalance = IERC20Token(TOKEN_WETH).balanceOf(address(this));
383                 if (tokenBalance > 1) IERC20Token(TOKEN_WETH).transfer(msg.sender, tokenBalance - 1);
384             }
385             if ((actionFlags & FLAG_RETURN_USDC) > 0) {
386                 uint tokenBalance = IERC20Token(TOKEN_USDC).balanceOf(address(this));
387                 if (tokenBalance > 1) IERC20Token(TOKEN_USDC).transfer(msg.sender, tokenBalance - 1);
388             }
389             if ((actionFlags & FLAG_RETURN_DAI) > 0) {
390                 uint tokenBalance = IERC20Token(TOKEN_DAI).balanceOf(address(this));
391                 if (tokenBalance > 1) IERC20Token(TOKEN_DAI).transfer(msg.sender, tokenBalance - 1);
392             }
393         }
394     }
395 }
396 
397 library Types {
398     enum ActionType {
399         Deposit,   // supply tokens
400         Withdraw,  // borrow tokens
401         Transfer,  // transfer balance between accounts
402         Buy,       // buy an amount of some token (externally)
403         Sell,      // sell an amount of some token (externally)
404         Trade,     // trade tokens against another account
405         Liquidate, // liquidate an undercollateralized or expiring account
406         Vaporize,  // use excess tokens to zero-out a completely negative account
407         Call       // send arbitrary data to an address
408     }
409 
410     enum AssetDenomination {
411         Wei, // the amount is denominated in wei
412         Par  // the amount is denominated in par
413     }
414 
415     enum AssetReference {
416         Delta, // the amount is given as a delta from the current value
417         Target // the amount is given as an exact number to end up at
418     }
419 
420     struct AssetAmount {
421         bool sign; // true if positive
422         AssetDenomination denomination;
423         AssetReference ref;
424         uint256 value;
425     }
426 
427     struct Wei {
428         bool sign; // true if positive
429         uint256 value;
430     }
431 
432     struct ActionArgs {
433         ActionType actionType;
434         uint256 accountId;
435         AssetAmount amount;
436         uint256 primaryMarketId;
437         uint256 secondaryMarketId;
438         address otherAddress;
439         uint256 otherAccountId;
440         bytes data;
441     }
442 
443     struct AccountInfo {
444         address owner;  // The address that owns the account
445         uint256 number; // A nonce that allows a single address to control many accounts
446     }
447 }
448 
449 contract ISoloMargin {
450     function operate(Types.AccountInfo[] memory accounts, Types.ActionArgs[] memory actions) public {}
451     function getMarketTokenAddress(uint256 marketId) public view returns (address) {}
452 }
453 
454 /*
455     ERC20 Standard Token interface
456 */
457 contract IERC20Token {
458     string public name;
459     string public symbol;
460     function decimals() public view returns (uint8) {}
461     function totalSupply() public view returns (uint256) {}
462     function balanceOf(address _owner) public view returns (uint256) { _owner; }
463     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
464 
465     function transfer(address _to, uint256 _value) public returns (bool success) {}
466     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
467     function approve(address _spender, uint256 _value) public returns (bool success) {}
468 }
469 
470 contract WETH9 {
471     function deposit() public payable {}
472     function withdraw(uint wad) public {}
473 }
474 
475 interface IChainlinkAggregator {
476   function latestAnswer() external view returns (int256);
477 }