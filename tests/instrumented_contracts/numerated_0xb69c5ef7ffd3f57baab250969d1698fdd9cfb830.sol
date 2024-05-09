1 pragma solidity ^0.5.7;
2 
3 interface RegistryInterface {
4     function proxies(address) external view returns (address);
5 }
6 
7 interface UserWalletInterface {
8     function owner() external view returns (address);
9 }
10 
11 interface TubInterface {
12     function open() external returns (bytes32);
13     function join(uint) external;
14     function exit(uint) external;
15     function lock(bytes32, uint) external;
16     function free(bytes32, uint) external;
17     function draw(bytes32, uint) external;
18     function wipe(bytes32, uint) external;
19     function give(bytes32, address) external;
20     function shut(bytes32) external;
21     function cups(bytes32) external view returns (address, uint, uint, uint);
22     function gem() external view returns (ERC20Interface);
23     function gov() external view returns (ERC20Interface);
24     function skr() external view returns (ERC20Interface);
25     function sai() external view returns (ERC20Interface);
26     function ink(bytes32) external view returns (uint);
27     function tab(bytes32) external returns (uint);
28     function rap(bytes32) external returns (uint);
29     function per() external view returns (uint);
30     function pep() external view returns (PepInterface);
31 }
32 
33 interface PepInterface {
34     function peek() external returns (bytes32, bool);
35 }
36 
37 interface ERC20Interface {
38     function allowance(address, address) external view returns (uint);
39     function balanceOf(address) external view returns (uint);
40     function approve(address, uint) external;
41     function transfer(address, uint) external returns (bool);
42     function transferFrom(address, address, uint) external returns (bool);
43     function deposit() external payable;
44     function withdraw(uint) external;
45 }
46 
47 interface UniswapExchange {
48     function getEthToTokenOutputPrice(uint256 tokensBought) external view returns (uint256 ethSold);
49     function getTokenToEthOutputPrice(uint256 ethBought) external view returns (uint256 tokensSold);
50     function tokenToTokenSwapOutput(
51         uint256 tokensBought,
52         uint256 maxTokensSold,
53         uint256 maxEthSold,
54         uint256 deadline,
55         address tokenAddr
56         ) external returns (uint256  tokensSold);
57 }
58 
59 interface CTokenInterface {
60     function mint(uint mintAmount) external returns (uint); // For ERC20
61     function redeem(uint redeemTokens) external returns (uint);
62     function redeemUnderlying(uint redeemAmount) external returns (uint);
63     function exchangeRateCurrent() external returns (uint);
64     function transfer(address, uint) external returns (bool);
65     function transferFrom(address, address, uint) external returns (bool);
66     function balanceOf(address) external view returns (uint);
67 }
68 
69 interface CETHInterface {
70     function mint() external payable; // For ETH
71     function transfer(address, uint) external returns (bool);
72 }
73 
74 interface CDAIInterface {
75     function mint(uint mintAmount) external returns (uint); // For ERC20
76     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);
77     function borrowBalanceCurrent(address account) external returns (uint);
78 }
79 
80 
81 contract DSMath {
82 
83     function add(uint x, uint y) internal pure returns (uint z) {
84         require((z = x + y) >= x, "math-not-safe");
85     }
86 
87     function mul(uint x, uint y) internal pure returns (uint z) {
88         require(y == 0 || (z = x * y) / y == x, "math-not-safe");
89     }
90 
91     uint constant WAD = 10 ** 18;
92     uint constant RAY = 10 ** 27;
93 
94     function rmul(uint x, uint y) internal pure returns (uint z) {
95         z = add(mul(x, y), RAY / 2) / RAY;
96     }
97 
98     function rdiv(uint x, uint y) internal pure returns (uint z) {
99         z = add(mul(x, RAY), y / 2) / y;
100     }
101 
102     function wmul(uint x, uint y) internal pure returns (uint z) {
103         z = add(mul(x, y), WAD / 2) / WAD;
104     }
105 
106     function wdiv(uint x, uint y) internal pure returns (uint z) {
107         z = add(mul(x, WAD), y / 2) / y;
108     }
109 
110 }
111 
112 
113 contract Helper is DSMath {
114 
115     address public ethAddr = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
116     address public daiAddr = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
117     address public registry = 0x498b3BfaBE9F73db90D252bCD4Fa9548Cd0Fd981;
118     address public sai = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
119     address public ume = 0x2C4Bd064b998838076fa341A83d007FC2FA50957; // Uniswap Maker Exchange
120     address public ude = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14; // Uniswap DAI Exchange
121     address public cEth = 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5;
122     address public cDai = 0xF5DCe57282A584D2746FaF1593d3121Fcac444dC;
123 
124     /**
125      * @dev setting allowance to compound for the "user proxy" if required
126      */
127     function setApproval(address erc20, uint srcAmt, address to) internal {
128         ERC20Interface erc20Contract = ERC20Interface(erc20);
129         uint tokenAllowance = erc20Contract.allowance(address(this), to);
130         if (srcAmt > tokenAllowance) {
131             erc20Contract.approve(to, 2**255);
132         }
133     }
134 
135     function setAllowance(ERC20Interface _token, address _spender) internal {
136         if (_token.allowance(address(this), _spender) != uint(-1)) {
137             _token.approve(_spender, uint(-1));
138         }
139     }
140 
141 }
142 
143 
144 contract CompoundResolver is Helper {
145 
146     event LogMint(address erc20, address cErc20, uint tokenAmt, address owner);
147     event LogRedeem(address erc20, address cErc20, uint tokenAmt, address owner);
148     event LogBorrow(address erc20, address cErc20, uint tokenAmt, address owner);
149     event LogRepay(address erc20, address cErc20, uint tokenAmt, address owner);
150 
151     /**
152      * @dev Redeem ETH/ERC20 and mint Compound Tokens
153      * @param tokenAmt Amount of token To Redeem
154      */
155     function redeemUnderlying(address cErc20, uint tokenAmt) internal {
156         if (tokenAmt > 0) {
157             CTokenInterface cToken = CTokenInterface(cErc20);
158             uint toBurn = cToken.balanceOf(address(this));
159             uint tokenToReturn = wmul(toBurn, cToken.exchangeRateCurrent());
160             tokenToReturn = tokenToReturn > tokenAmt ? tokenAmt : tokenToReturn;
161             require(cToken.redeemUnderlying(tokenToReturn) == 0, "something went wrong");
162         }
163     }
164 
165     /**
166      * @dev Deposit ETH/ERC20 and mint Compound Tokens
167      */
168     function mintCETH(uint ethAmt) internal {
169         if (ethAmt > 0) {
170             CETHInterface cToken = CETHInterface(cEth);
171             cToken.mint.value(ethAmt)();
172             uint cEthToReturn = wdiv(ethAmt, CTokenInterface(cEth).exchangeRateCurrent());
173             cToken.transfer(msg.sender, cEthToReturn);
174             emit LogMint(
175                 ethAddr,
176                 cEth,
177                 ethAmt,
178                 msg.sender
179             );
180         }
181     }
182 
183     /**
184      * @dev Deposit ETH/ERC20 and mint Compound Tokens
185      */
186     function mintCDAI(uint tokenAmt) internal {
187         if (tokenAmt > 0) {
188             ERC20Interface token = ERC20Interface(daiAddr);
189             uint toDeposit = token.balanceOf(msg.sender);
190             toDeposit = toDeposit > tokenAmt ? tokenAmt : toDeposit;
191             token.transferFrom(msg.sender, address(this), toDeposit);
192             CDAIInterface cToken = CDAIInterface(cDai);
193             assert(cToken.mint(toDeposit) == 0);
194             emit LogMint(
195                 daiAddr,
196                 cDai,
197                 tokenAmt,
198                 msg.sender
199             );
200         }
201     }
202 
203     /**
204      * @dev Deposit ETH/ERC20 and mint Compound Tokens
205      */
206     function fetchCETH(uint ethAmt) internal {
207         if (ethAmt > 0) {
208             CTokenInterface cToken = CTokenInterface(cEth);
209             uint cTokenAmt = wdiv(ethAmt, cToken.exchangeRateCurrent());
210             uint cEthBal = cToken.balanceOf(msg.sender);
211             cTokenAmt = cEthBal >= cTokenAmt ? cTokenAmt : cTokenAmt - 1;
212             require(ERC20Interface(cEth).transferFrom(msg.sender, address(this), cTokenAmt), "Contract Approved?");
213         }
214     }
215 
216     /**
217      * @dev If col/debt > user's balance/borrow. Then set max
218      */
219     function checkCompound(uint ethAmt, uint daiAmt) internal returns (uint ethCol, uint daiDebt) {
220         CTokenInterface cEthContract = CTokenInterface(cEth);
221         uint cEthBal = cEthContract.balanceOf(address(this));
222         uint ethExchangeRate = cEthContract.exchangeRateCurrent();
223         ethCol = wmul(cEthBal, ethExchangeRate);
224         ethCol = wdiv(ethCol, ethExchangeRate) <= cEthBal ? ethCol : ethCol - 1;
225         if (ethCol > ethAmt) {
226             ethCol = ethAmt;
227         }
228 
229         daiDebt = CDAIInterface(cDai).borrowBalanceCurrent(msg.sender);
230         if (daiDebt > daiAmt) {
231             daiDebt = daiAmt;
232         }
233     }
234 
235 }
236 
237 
238 contract MakerResolver is CompoundResolver {
239 
240     event LogOpen(uint cdpNum, address owner);
241     event LogGive(uint cdpNum, address owner, address nextOwner);
242     event LogLock(uint cdpNum, uint amtETH, uint amtPETH, address owner);
243     event LogFree(uint cdpNum, uint amtETH, uint amtPETH, address owner);
244     event LogDraw(uint cdpNum, uint amtDAI, address owner);
245     event LogDrawSend(uint cdpNum, uint amtDAI, address to);
246     event LogWipe(uint cdpNum, uint daiAmt, uint mkrFee, uint daiFee, address owner);
247     event LogShut(uint cdpNum);
248 
249     function open() internal returns (uint) {
250         bytes32 cup = TubInterface(sai).open();
251         emit LogOpen(uint(cup), address(this));
252         return uint(cup);
253     }
254 
255     /**
256      * @dev transfer CDP ownership
257      */
258     function give(uint cdpNum, address nextOwner) internal {
259         TubInterface(sai).give(bytes32(cdpNum), nextOwner);
260     }
261 
262     function wipe(uint cdpNum, uint _wad) internal returns (uint daiAmt) {
263         if (_wad > 0) {
264             TubInterface tub = TubInterface(sai);
265             UniswapExchange daiEx = UniswapExchange(ude);
266             UniswapExchange mkrEx = UniswapExchange(ume);
267             ERC20Interface dai = tub.sai();
268             ERC20Interface mkr = tub.gov();
269 
270             bytes32 cup = bytes32(cdpNum);
271 
272             (address lad,,,) = tub.cups(cup);
273             require(lad == address(this), "cup-not-owned");
274 
275             setAllowance(dai, sai);
276             setAllowance(mkr, sai);
277             setAllowance(dai, ude);
278 
279             (bytes32 val, bool ok) = tub.pep().peek();
280 
281             // MKR required for wipe = Stability fees accrued in Dai / MKRUSD value
282             uint mkrFee = wdiv(rmul(_wad, rdiv(tub.rap(cup), tub.tab(cup))), uint(val));
283 
284             uint daiFeeAmt = daiEx.getTokenToEthOutputPrice(mkrEx.getEthToTokenOutputPrice(mkrFee));
285             daiAmt = add(_wad, daiFeeAmt);
286 
287             redeemUnderlying(cDai, daiAmt);
288 
289             if (ok && val != 0) {
290                 daiEx.tokenToTokenSwapOutput(
291                     mkrFee,
292                     daiAmt,
293                     uint(999000000000000000000),
294                     uint(1899063809), // 6th March 2030 GMT // no logic
295                     address(mkr)
296                 );
297             }
298 
299             tub.wipe(cup, _wad);
300 
301             emit LogWipe(
302                 cdpNum,
303                 daiAmt,
304                 mkrFee,
305                 daiFeeAmt,
306                 address(this)
307             );
308 
309         }
310     }
311 
312     function free(uint cdpNum, uint jam) internal {
313         if (jam > 0) {
314             bytes32 cup = bytes32(cdpNum);
315             address tubAddr = sai;
316 
317             TubInterface tub = TubInterface(tubAddr);
318             ERC20Interface peth = tub.skr();
319             ERC20Interface weth = tub.gem();
320 
321             uint ink = rdiv(jam, tub.per());
322             ink = rmul(ink, tub.per()) <= jam ? ink : ink - 1;
323             tub.free(cup, ink);
324 
325             setAllowance(peth, tubAddr);
326 
327             tub.exit(ink);
328             uint freeJam = weth.balanceOf(address(this)); // withdraw possible previous stuck WETH as well
329             weth.withdraw(freeJam);
330 
331             emit LogFree(
332                 cdpNum,
333                 freeJam,
334                 ink,
335                 address(this)
336             );
337         }
338     }
339 
340     function lock(uint cdpNum, uint ethAmt) internal {
341         if (ethAmt > 0) {
342             bytes32 cup = bytes32(cdpNum);
343             address tubAddr = sai;
344 
345             TubInterface tub = TubInterface(tubAddr);
346             ERC20Interface weth = tub.gem();
347             ERC20Interface peth = tub.skr();
348 
349             (address lad,,,) = tub.cups(cup);
350             require(lad == address(this), "cup-not-owned");
351 
352             weth.deposit.value(ethAmt)();
353 
354             uint ink = rdiv(ethAmt, tub.per());
355             ink = rmul(ink, tub.per()) <= ethAmt ? ink : ink - 1;
356 
357             setAllowance(weth, tubAddr);
358             tub.join(ink);
359 
360             setAllowance(peth, tubAddr);
361             tub.lock(cup, ink);
362 
363             emit LogLock(
364                 cdpNum,
365                 ethAmt,
366                 ink,
367                 address(this)
368             );
369         }
370     }
371 
372     function draw(uint cdpNum, uint _wad) internal {
373         bytes32 cup = bytes32(cdpNum);
374         if (_wad > 0) {
375             TubInterface tub = TubInterface(sai);
376 
377             tub.draw(cup, _wad);
378 
379             emit LogDraw(cdpNum, _wad, address(this));
380         }
381     }
382 
383     function getCDPStats(bytes32 cup) internal returns (uint ethCol, uint daiDebt) {
384         TubInterface tub = TubInterface(sai);
385         ethCol = rmul(tub.ink(cup), tub.per()); // get ETH col from PETH col
386         daiDebt = tub.tab(cup);
387     }
388 
389     function wipeAndFree(uint cdpNum, uint jam, uint _wad) internal returns (uint ethAmt, uint daiAmt) {
390         (uint ethCol, uint daiDebt) = getCDPStats(bytes32(cdpNum));
391         daiDebt = _wad < daiDebt ? _wad : daiDebt; // if DAI amount > max debt. Set max debt
392         ethCol = jam < ethCol ? jam : ethCol; // if ETH amount > max Col. Set max col
393         daiAmt = wipe(cdpNum, daiDebt);
394         ethAmt = ethCol;
395         free(cdpNum, ethCol);
396     }
397 
398     function lockAndDraw(uint cdpNum, uint jam, uint _wad) internal {
399         lock(cdpNum, jam);
400         draw(cdpNum, _wad);
401     }
402 
403 }
404 
405 
406 contract BridgeResolver is MakerResolver {
407 
408     /**
409      * @dev initiated from user wallet to reimburse temporary DAI debt
410      */
411     function refillFunds(uint daiDebt) external {
412         require(ERC20Interface(daiAddr).transferFrom(msg.sender, address(this),daiDebt), "Contract Approved?");
413         mintCDAI(daiDebt);
414     }
415 
416     /**
417      * @dev paying back users debt
418      */
419     function payUserDebt(uint daiDebt) internal {
420         if (daiDebt > 0) {
421             redeemUnderlying(cDai, daiDebt);
422             require(CDAIInterface(cDai).repayBorrowBehalf(msg.sender, daiDebt) == 0, "Enough DAI?");
423         }
424     }
425 
426 }
427 
428 
429 contract LiquidityProvider is BridgeResolver {
430 
431     mapping (address => uint) public deposits; // amount of CDAI deposits
432 
433     /**
434      * @dev Deposit DAI for liquidity
435      */
436     function depositDAI(uint amt) public {
437         ERC20Interface(daiAddr).transferFrom(msg.sender, address(this), amt);
438         CTokenInterface cToken = CTokenInterface(cDai);
439         assert(cToken.mint(amt) == 0);
440         uint cDaiAmt = wdiv(amt, cToken.exchangeRateCurrent());
441         deposits[msg.sender] += cDaiAmt;
442     }
443 
444     /**
445      * @dev Withdraw DAI from liquidity
446      */
447     function withdrawDAI(uint amt) public {
448         require(deposits[msg.sender] != 0, "Nothing to Withdraw");
449         CTokenInterface cToken = CTokenInterface(cDai);
450         uint withdrawAmt = wdiv(amt, cToken.exchangeRateCurrent());
451         uint daiAmt = amt;
452         if (withdrawAmt > deposits[msg.sender]) {
453             withdrawAmt = deposits[msg.sender];
454             daiAmt = wmul(withdrawAmt, cToken.exchangeRateCurrent());
455         }
456         require(cToken.redeem(withdrawAmt) == 0, "something went wrong");
457         ERC20Interface(daiAddr).transfer(msg.sender, daiAmt);
458         deposits[msg.sender] -= withdrawAmt;
459     }
460 
461     /**
462      * @dev Deposit CDAI for liquidity
463      */
464     function depositCDAI(uint amt) public {
465         CTokenInterface cToken = CTokenInterface(cDai);
466         require(cToken.transferFrom(msg.sender, address(this), amt) == true, "Nothing to deposit");
467         deposits[msg.sender] += amt;
468     }
469 
470     /**
471      * @dev Withdraw CDAI from liquidity
472      */
473     function withdrawCDAI(uint amt) public {
474         require(deposits[msg.sender] != 0, "Nothing to Withdraw");
475         CTokenInterface cToken = CTokenInterface(cDai);
476         uint withdrawAmt = amt;
477         if (withdrawAmt > deposits[msg.sender]) {
478             withdrawAmt = deposits[msg.sender];
479         }
480         cToken.transfer(msg.sender, withdrawAmt);
481         deposits[msg.sender] -= withdrawAmt;
482     }
483 
484 }
485 
486 
487 contract Bridge is LiquidityProvider {
488 
489     /**
490      * FOR SECURITY PURPOSE
491      * checks if only InstaDApp contract wallets can access the bridge
492      */
493     modifier isUserWallet {
494         address userAdd = UserWalletInterface(msg.sender).owner();
495         address walletAdd = RegistryInterface(registry).proxies(userAdd);
496         require(walletAdd != address(0), "not-user-wallet");
497         require(walletAdd == msg.sender, "not-wallet-owner");
498         _;
499     }
500 
501     /**
502      * @dev MakerDAO to Compound
503      */
504     function makerToCompound(uint cdpId, uint ethCol, uint daiDebt) public payable isUserWallet returns (uint daiAmt) {
505         uint ethAmt;
506         (ethAmt, daiAmt) = wipeAndFree(cdpId, ethCol, daiDebt);
507         mintCETH(ethAmt);
508         give(cdpId, msg.sender);
509     }
510 
511     /**
512      * @dev Compound to MakerDAO
513      */
514     function compoundToMaker(uint cdpId, uint ethCol, uint daiDebt) public payable isUserWallet {
515         (uint ethAmt, uint daiAmt) = checkCompound(ethCol, daiDebt);
516         payUserDebt(daiAmt);
517         fetchCETH(ethAmt);
518         redeemUnderlying(cEth, ethAmt);
519         uint cdpNum = cdpId > 0 ? cdpId : open();
520         lockAndDraw(cdpNum, ethAmt, daiAmt);
521         mintCDAI(daiAmt);
522         give(cdpNum, msg.sender);
523     }
524 
525 }
526 
527 
528 contract MakerCompoundBridge is Bridge {
529 
530     /**
531      * @dev setting up all required token approvals
532      */
533     constructor() public {
534         setApproval(daiAddr, 10**30, cDai);
535         setApproval(cDai, 10**30, cDai);
536         setApproval(cEth, 10**30, cEth);
537     }
538 
539     function() external payable {}
540 
541 }