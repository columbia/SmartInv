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
110     function sub(uint a, uint b) internal pure returns (uint c) {
111         require(b <= a, "SafeMath: subtraction overflow");
112         c = a - b;
113     }
114 
115 }
116 
117 
118 contract Helper is DSMath {
119 
120     address public ethAddr = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
121     address public daiAddr = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
122     address public registry = 0x498b3BfaBE9F73db90D252bCD4Fa9548Cd0Fd981;
123     address public sai = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
124     address public ume = 0x2C4Bd064b998838076fa341A83d007FC2FA50957; // Uniswap Maker Exchange
125     address public ude = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14; // Uniswap DAI Exchange
126     address public cEth = 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5;
127     address public cDai = 0xF5DCe57282A584D2746FaF1593d3121Fcac444dC;
128 
129     address public feeOne = 0xd8db02A498E9AFbf4A32BC006DC1940495b4e592;
130     address public feeTwo = 0xa7615CD307F323172331865181DC8b80a2834324;
131     uint public fees = 0;
132 
133     /**
134      * @dev setting allowance to compound for the "user proxy" if required
135      */
136     function setApproval(address erc20, uint srcAmt, address to) internal {
137         ERC20Interface erc20Contract = ERC20Interface(erc20);
138         uint tokenAllowance = erc20Contract.allowance(address(this), to);
139         if (srcAmt > tokenAllowance) {
140             erc20Contract.approve(to, 2**255);
141         }
142     }
143 
144     function setAllowance(ERC20Interface _token, address _spender) internal {
145         if (_token.allowance(address(this), _spender) != uint(-1)) {
146             _token.approve(_spender, uint(-1));
147         }
148     }
149 
150 }
151 
152 
153 contract CompoundResolver is Helper {
154 
155     /**
156      * @dev Redeem ETH/ERC20 and mint Compound Tokens
157      * @param tokenAmt Amount of token To Redeem
158      */
159     function redeemUnderlying(address cErc20, uint tokenAmt) internal {
160         if (tokenAmt > 0) {
161             require(CTokenInterface(cErc20).redeemUnderlying(tokenAmt) == 0, "something went wrong");
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
172             uint exchangeRate = CTokenInterface(cEth).exchangeRateCurrent();
173             uint cEthToReturn = wdiv(ethAmt, exchangeRate);
174             cEthToReturn = wmul(cEthToReturn, exchangeRate) <= ethAmt ? cEthToReturn : cEthToReturn - 1;
175             require(cToken.transfer(msg.sender, cEthToReturn), "CETH Transfer failed");
176         }
177     }
178 
179     /**
180      * @dev Deposit ETH/ERC20 and mint Compound Tokens
181      */
182     function fetchCETH(uint ethAmt) internal {
183         if (ethAmt > 0) {
184             CTokenInterface cToken = CTokenInterface(cEth);
185             uint exchangeRate = cToken.exchangeRateCurrent();
186             uint cTokenAmt = wdiv(ethAmt, exchangeRate);
187             cTokenAmt = wmul(cTokenAmt, exchangeRate) <= ethAmt ? cTokenAmt : cTokenAmt - 1;
188             require(ERC20Interface(cEth).transferFrom(msg.sender, address(this), cTokenAmt), "Contract Approved?");
189         }
190     }
191 
192     /**
193      * @dev If col/debt > user's balance/borrow. Then set max
194      */
195     function checkCompound(uint ethAmt, uint daiAmt) internal returns (uint ethCol, uint daiDebt) {
196         CTokenInterface cEthContract = CTokenInterface(cEth);
197         uint cEthBal = cEthContract.balanceOf(msg.sender);
198         uint ethExchangeRate = cEthContract.exchangeRateCurrent();
199         ethCol = wmul(cEthBal, ethExchangeRate);
200         ethCol = wdiv(ethCol, ethExchangeRate) <= cEthBal ? ethCol : ethCol - 1;
201         ethCol = ethCol <= ethAmt ? ethCol : ethAmt; // Set Max if amount is greater than the Col user have
202 
203         daiDebt = CDAIInterface(cDai).borrowBalanceCurrent(msg.sender);
204         daiDebt = daiDebt <= daiAmt ? daiDebt : daiAmt; // Set Max if amount is greater than the Debt user have
205     }
206 
207 }
208 
209 
210 contract MakerResolver is CompoundResolver {
211 
212     event LogOpen(uint cdpNum, address owner);
213     event LogWipe(uint cdpNum, uint daiAmt, uint mkrFee, uint daiFee, address owner);
214 
215     function open() internal returns (uint) {
216         bytes32 cup = TubInterface(sai).open();
217         emit LogOpen(uint(cup), address(this));
218         return uint(cup);
219     }
220 
221     /**
222      * @dev transfer CDP ownership
223      */
224     function give(uint cdpNum, address nextOwner) internal {
225         TubInterface(sai).give(bytes32(cdpNum), nextOwner);
226     }
227 
228     function wipe(uint cdpNum, uint _wad) internal returns (uint daiAmt) {
229         if (_wad > 0) {
230             TubInterface tub = TubInterface(sai);
231             UniswapExchange daiEx = UniswapExchange(ude);
232             UniswapExchange mkrEx = UniswapExchange(ume);
233             ERC20Interface dai = tub.sai();
234             ERC20Interface mkr = tub.gov();
235 
236             bytes32 cup = bytes32(cdpNum);
237 
238             (address lad,,,) = tub.cups(cup);
239             require(lad == address(this), "cup-not-owned");
240 
241             setAllowance(dai, sai);
242             setAllowance(mkr, sai);
243             setAllowance(dai, ude);
244 
245             (bytes32 val, bool ok) = tub.pep().peek();
246 
247             // MKR required for wipe = Stability fees accrued in Dai / MKRUSD value
248             uint mkrFee = wdiv(rmul(_wad, rdiv(tub.rap(cup), tub.tab(cup))), uint(val));
249 
250             uint daiFeeAmt = daiEx.getTokenToEthOutputPrice(mkrEx.getEthToTokenOutputPrice(mkrFee));
251             daiAmt = add(_wad, daiFeeAmt);
252 
253             redeemUnderlying(cDai, daiAmt);
254 
255             if (ok && val != 0) {
256                 daiEx.tokenToTokenSwapOutput(
257                     mkrFee,
258                     daiAmt,
259                     uint(999000000000000000000),
260                     uint(1899063809), // 6th March 2030 GMT // no logic
261                     address(mkr)
262                 );
263             }
264 
265             tub.wipe(cup, _wad);
266 
267             emit LogWipe(
268                 cdpNum,
269                 daiAmt,
270                 mkrFee,
271                 daiFeeAmt,
272                 address(this)
273             );
274 
275         }
276     }
277 
278     function free(uint cdpNum, uint jam) internal {
279         if (jam > 0) {
280             bytes32 cup = bytes32(cdpNum);
281             address tubAddr = sai;
282 
283             TubInterface tub = TubInterface(tubAddr);
284             ERC20Interface peth = tub.skr();
285             ERC20Interface weth = tub.gem();
286 
287             uint ink = rdiv(jam, tub.per());
288             ink = rmul(ink, tub.per()) <= jam ? ink : ink - 1;
289             tub.free(cup, ink);
290 
291             setAllowance(peth, tubAddr);
292 
293             tub.exit(ink);
294             uint freeJam = weth.balanceOf(address(this)); // withdraw possible previous stuck WETH as well
295             weth.withdraw(freeJam);
296         }
297     }
298 
299     function lock(uint cdpNum, uint ethAmt) internal {
300         if (ethAmt > 0) {
301             bytes32 cup = bytes32(cdpNum);
302             address tubAddr = sai;
303 
304             TubInterface tub = TubInterface(tubAddr);
305             ERC20Interface weth = tub.gem();
306             ERC20Interface peth = tub.skr();
307 
308             (address lad,,,) = tub.cups(cup);
309             require(lad == address(this), "cup-not-owned");
310 
311             weth.deposit.value(ethAmt)();
312 
313             uint ink = rdiv(ethAmt, tub.per());
314             ink = rmul(ink, tub.per()) <= ethAmt ? ink : ink - 1;
315 
316             setAllowance(weth, tubAddr);
317             tub.join(ink);
318 
319             setAllowance(peth, tubAddr);
320             tub.lock(cup, ink);
321         }
322     }
323 
324     function draw(uint cdpNum, uint _wad) internal {
325         bytes32 cup = bytes32(cdpNum);
326         if (_wad > 0) {
327             TubInterface tub = TubInterface(sai);
328 
329             tub.draw(cup, _wad);
330         }
331     }
332 
333     function checkCDP(bytes32 cup, uint ethAmt, uint daiAmt) internal returns (uint ethCol, uint daiDebt) {
334         TubInterface tub = TubInterface(sai);
335         ethCol = rmul(tub.ink(cup), tub.per()); // get ETH col from PETH col
336         daiDebt = tub.tab(cup);
337         daiDebt = daiAmt < daiDebt ? daiAmt : daiDebt; // if DAI amount > max debt. Set max debt
338         ethCol = ethAmt < ethCol ? ethAmt : ethCol; // if ETH amount > max Col. Set max col
339     }
340 
341     function wipeAndFree(uint cdpNum, uint jam, uint _wad) internal returns (uint daiAmt) {
342         daiAmt = wipe(cdpNum, _wad);
343         free(cdpNum, jam);
344     }
345 
346     function lockAndDraw(uint cdpNum, uint jam, uint _wad) internal {
347         lock(cdpNum, jam);
348         draw(cdpNum, _wad);
349     }
350 
351 }
352 
353 
354 contract BridgeResolver is MakerResolver {
355 
356     event LogMakerToCompound(uint cdpNum, uint ethAmt, uint daiAmt, uint fees, address owner);
357     event LogCompoundToMaker(uint cdpNum, uint ethAmt, uint daiAmt, uint fees, address owner);
358 
359     /**
360      * @dev initiated from user wallet to reimburse temporary DAI debt
361      */
362     function refillFunds(uint daiDebt) external {
363         if (daiDebt > 0) {
364             require(ERC20Interface(daiAddr).transferFrom(msg.sender, address(this), daiDebt), "Contract Approved?");
365             assert(CDAIInterface(cDai).mint(daiDebt) == 0);
366         }
367     }
368 
369     /**
370      * @dev paying back users debt
371      */
372     function payUserDebt(uint daiDebt) internal {
373         if (daiDebt > 0) {
374             redeemUnderlying(cDai, daiDebt);
375             require(CDAIInterface(cDai).repayBorrowBehalf(msg.sender, daiDebt) == 0, "Enough DAI?");
376         }
377     }
378 
379 }
380 
381 
382 contract LiquidityProvider is BridgeResolver {
383 
384     mapping (address => uint) public deposits; // amount of CDAI deposits
385     uint public totalDeposits;
386 
387     /**
388      * @dev Deposit DAI for liquidity
389      */
390     function depositDAI(uint amt) public {
391         require(ERC20Interface(daiAddr).transferFrom(msg.sender, address(this), amt), "Nothing to deposit");
392         CTokenInterface cToken = CTokenInterface(cDai);
393         assert(cToken.mint(amt) == 0);
394         uint exchangeRate = cToken.exchangeRateCurrent();
395         uint cDaiAmt = wdiv(amt, exchangeRate);
396         cDaiAmt = wmul(cDaiAmt, exchangeRate) <= amt ? cDaiAmt : cDaiAmt - 1;
397         deposits[msg.sender] += cDaiAmt;
398         totalDeposits += cDaiAmt;
399     }
400 
401     /**
402      * @dev Withdraw DAI from liquidity
403      */
404     function withdrawDAI(uint amt) public {
405         require(deposits[msg.sender] != 0, "Nothing to Withdraw");
406         CTokenInterface cToken = CTokenInterface(cDai);
407         uint exchangeRate = cToken.exchangeRateCurrent();
408         uint withdrawAmt = wdiv(amt, exchangeRate);
409         uint daiAmt = amt;
410         if (withdrawAmt > deposits[msg.sender]) {
411             withdrawAmt = deposits[msg.sender];
412             daiAmt = wmul(withdrawAmt, exchangeRate);
413         }
414         require(cToken.redeem(withdrawAmt) == 0, "something went wrong");
415         require(ERC20Interface(daiAddr).transfer(msg.sender, daiAmt), "Dai Transfer failed");
416         deposits[msg.sender] -= withdrawAmt;
417         totalDeposits -= withdrawAmt;
418     }
419 
420     /**
421      * @dev Deposit CDAI for liquidity
422      */
423     function depositCDAI(uint amt) public {
424         CTokenInterface cToken = CTokenInterface(cDai);
425         require(cToken.transferFrom(msg.sender, address(this), amt) == true, "Nothing to deposit");
426         deposits[msg.sender] += amt;
427         totalDeposits += amt;
428     }
429 
430     /**
431      * @dev Withdraw CDAI from liquidity
432      */
433     function withdrawCDAI(uint amt) public {
434         require(deposits[msg.sender] != 0, "Nothing to Withdraw");
435         uint withdrawAmt = amt;
436         if (withdrawAmt > deposits[msg.sender]) {
437             withdrawAmt = deposits[msg.sender];
438         }
439         require(CTokenInterface(cDai).transfer(msg.sender, withdrawAmt), "Dai Transfer failed");
440         deposits[msg.sender] -= withdrawAmt;
441         totalDeposits -= withdrawAmt;
442     }
443 
444     /**
445      * collecting unmapped CDAI
446      */
447     function collectCDAI(uint num) public {
448         CTokenInterface cToken = CTokenInterface(cDai);
449         uint cDaiBal = cToken.balanceOf(address(this));
450         uint withdrawAmt = sub(cDaiBal, totalDeposits);
451         if (num == 0) {
452             require(cToken.transfer(feeOne, withdrawAmt), "CDai Transfer failed");
453         } else {
454             require(cToken.transfer(feeTwo, withdrawAmt), "CDai Transfer failed");
455         }
456     }
457 
458     /**
459      * (HIGHLY UNLIKELY TO HAPPEN)
460      * collecting Tokens/ETH other than CDAI
461      */
462     function collectTokens(uint num, address token) public {
463         require(token != cDai, "Token address == CDAI address");
464         if (token == ethAddr) {
465             if (num == 0) {
466                 msg.sender.transfer(address(this).balance);
467             } else {
468                 msg.sender.transfer(address(this).balance);
469             }
470         } else {
471             ERC20Interface tokenContract = ERC20Interface(token);
472             uint tokenBal = tokenContract.balanceOf(address(this));
473             uint withdrawAmt = sub(tokenBal, totalDeposits);
474             if (num == 0) {
475                 require(tokenContract.transfer(feeOne, withdrawAmt), "Transfer failed");
476             } else {
477                 require(tokenContract.transfer(feeTwo, withdrawAmt), "Transfer failed");
478             }
479         }
480     }
481 
482     /**
483      * (HIGHLY UNLIKELY TO HAPPEN)
484      * Transfer CDP ownership (Just in case this contract has ownership of any CDP)
485      */
486     function transferUnmappedCDP(uint cdpNum, uint num) public {
487         if (num == 0) {
488             give(cdpNum, feeOne);
489         } else {
490             give(cdpNum, feeTwo);
491         }
492     }
493 
494     function setFees(uint amt) public {
495         require(msg.sender == feeOne || msg.sender == feeTwo, "Not manager address");
496         if (amt > 3000000000000000) {
497             fees = 3000000000000000; // max fees 0.3%
498         } else {
499             fees = amt;
500         }
501     }
502 
503 }
504 
505 
506 contract Bridge is LiquidityProvider {
507 
508     /**
509      * FOR SECURITY PURPOSE
510      * checks if only InstaDApp contract wallets can access the bridge
511      */
512     modifier isUserWallet {
513         address userAdd = UserWalletInterface(msg.sender).owner();
514         address walletAdd = RegistryInterface(registry).proxies(userAdd);
515         require(walletAdd != address(0), "not-user-wallet");
516         require(walletAdd == msg.sender, "not-wallet-owner");
517         _;
518     }
519 
520     /**
521      * @dev MakerDAO to Compound
522      */
523     function makerToCompound(uint cdpId, uint ethCol, uint daiDebt) public payable isUserWallet returns (uint daiAmt) {
524         uint ethAmt;
525         (ethAmt, daiAmt) = checkCDP(bytes32(cdpId), ethCol, daiDebt);
526         daiAmt = wipeAndFree(cdpId, ethAmt, daiAmt);
527         uint cut = wmul(daiAmt, fees);
528         daiAmt = wmul(daiAmt, add(1000000000000000000, fees));
529         mintCETH(ethAmt);
530         give(cdpId, msg.sender);
531         emit LogMakerToCompound(
532             cdpId,
533             ethAmt,
534             daiAmt,
535             cut,
536             msg.sender
537         );
538     }
539 
540     /**
541      * @dev Compound to MakerDAO
542      */
543     function compoundToMaker(uint cdpId, uint ethCol, uint daiDebt) public payable isUserWallet {
544         (uint ethAmt, uint daiAmt) = checkCompound(ethCol, daiDebt);
545         payUserDebt(daiAmt);
546         fetchCETH(ethAmt);
547         redeemUnderlying(cEth, ethAmt);
548         uint cdpNum = cdpId > 0 ? cdpId : open();
549         uint cut = wmul(daiAmt, fees);
550         daiAmt = wmul(daiAmt, add(1000000000000000000, fees));
551         lockAndDraw(cdpNum, ethAmt, daiAmt);
552         if (daiAmt > 0) {
553             assert(CDAIInterface(cDai).mint(daiAmt) == 0);
554         }
555         give(cdpNum, msg.sender);
556         emit LogCompoundToMaker(
557             cdpNum,
558             ethAmt,
559             daiAmt,
560             cut,
561             msg.sender
562         );
563     }
564 
565 }
566 
567 
568 contract MakerCompoundBridge is Bridge {
569 
570     /**
571      * @dev setting up all required token approvals
572      */
573     constructor() public {
574         setApproval(daiAddr, 10**30, cDai);
575         setApproval(cDai, 10**30, cDai);
576         setApproval(cEth, 10**30, cEth);
577     }
578 
579     function() external payable {}
580 
581 }