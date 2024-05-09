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
131 
132     /**
133      * @dev setting allowance to compound for the "user proxy" if required
134      */
135     function setApproval(address erc20, uint srcAmt, address to) internal {
136         ERC20Interface erc20Contract = ERC20Interface(erc20);
137         uint tokenAllowance = erc20Contract.allowance(address(this), to);
138         if (srcAmt > tokenAllowance) {
139             erc20Contract.approve(to, 2**255);
140         }
141     }
142 
143     function setAllowance(ERC20Interface _token, address _spender) internal {
144         if (_token.allowance(address(this), _spender) != uint(-1)) {
145             _token.approve(_spender, uint(-1));
146         }
147     }
148 
149 }
150 
151 
152 contract CompoundResolver is Helper {
153 
154     event LogMint(address erc20, address cErc20, uint tokenAmt, address owner);
155     event LogRedeem(address erc20, address cErc20, uint tokenAmt, address owner);
156     event LogBorrow(address erc20, address cErc20, uint tokenAmt, address owner);
157     event LogRepay(address erc20, address cErc20, uint tokenAmt, address owner);
158 
159     /**
160      * @dev Redeem ETH/ERC20 and mint Compound Tokens
161      * @param tokenAmt Amount of token To Redeem
162      */
163     function redeemUnderlying(address cErc20, uint tokenAmt) internal {
164         if (tokenAmt > 0) {
165             require(CTokenInterface(cErc20).redeemUnderlying(tokenAmt) == 0, "something went wrong");
166         }
167     }
168 
169     /**
170      * @dev Deposit ETH/ERC20 and mint Compound Tokens
171      */
172     function mintCETH(uint ethAmt) internal {
173         if (ethAmt > 0) {
174             CETHInterface cToken = CETHInterface(cEth);
175             cToken.mint.value(ethAmt)();
176             uint exchangeRate = CTokenInterface(cEth).exchangeRateCurrent();
177             uint cEthToReturn = wdiv(ethAmt, exchangeRate);
178             cEthToReturn = wmul(cEthToReturn, exchangeRate) <= ethAmt ? cEthToReturn : cEthToReturn - 1;
179             require(cToken.transfer(msg.sender, cEthToReturn), "CETH Transfer failed");
180             emit LogMint(
181                 ethAddr,
182                 cEth,
183                 ethAmt,
184                 msg.sender
185             );
186         }
187     }
188 
189     /**
190      * @dev Deposit ETH/ERC20 and mint Compound Tokens
191      */
192     function fetchCETH(uint ethAmt) internal {
193         if (ethAmt > 0) {
194             CTokenInterface cToken = CTokenInterface(cEth);
195             uint exchangeRate = cToken.exchangeRateCurrent();
196             uint cTokenAmt = wdiv(ethAmt, exchangeRate);
197             cTokenAmt = wmul(cTokenAmt, exchangeRate) <= ethAmt ? cTokenAmt : cTokenAmt - 1;
198             require(ERC20Interface(cEth).transferFrom(msg.sender, address(this), cTokenAmt), "Contract Approved?");
199         }
200     }
201 
202     /**
203      * @dev If col/debt > user's balance/borrow. Then set max
204      */
205     function checkCompound(uint ethAmt, uint daiAmt) internal returns (uint ethCol, uint daiDebt) {
206         CTokenInterface cEthContract = CTokenInterface(cEth);
207         uint cEthBal = cEthContract.balanceOf(msg.sender);
208         uint ethExchangeRate = cEthContract.exchangeRateCurrent();
209         ethCol = wmul(cEthBal, ethExchangeRate);
210         ethCol = wdiv(ethCol, ethExchangeRate) <= cEthBal ? ethCol : ethCol - 1;
211         ethCol = ethCol <= ethAmt ? ethCol : ethAmt; // Set Max if amount is greater than the Col user have
212 
213         daiDebt = CDAIInterface(cDai).borrowBalanceCurrent(msg.sender);
214         daiDebt = daiDebt <= daiAmt ? daiDebt : daiAmt; // Set Max if amount is greater than the Debt user have
215     }
216 
217 }
218 
219 
220 contract MakerResolver is CompoundResolver {
221 
222     event LogOpen(uint cdpNum, address owner);
223     event LogGive(uint cdpNum, address owner, address nextOwner);
224     event LogLock(uint cdpNum, uint amtETH, uint amtPETH, address owner);
225     event LogFree(uint cdpNum, uint amtETH, uint amtPETH, address owner);
226     event LogDraw(uint cdpNum, uint amtDAI, address owner);
227     event LogDrawSend(uint cdpNum, uint amtDAI, address to);
228     event LogWipe(uint cdpNum, uint daiAmt, uint mkrFee, uint daiFee, address owner);
229     event LogShut(uint cdpNum);
230 
231     function open() internal returns (uint) {
232         bytes32 cup = TubInterface(sai).open();
233         emit LogOpen(uint(cup), address(this));
234         return uint(cup);
235     }
236 
237     /**
238      * @dev transfer CDP ownership
239      */
240     function give(uint cdpNum, address nextOwner) internal {
241         TubInterface(sai).give(bytes32(cdpNum), nextOwner);
242     }
243 
244     function wipe(uint cdpNum, uint _wad) internal returns (uint daiAmt) {
245         if (_wad > 0) {
246             TubInterface tub = TubInterface(sai);
247             UniswapExchange daiEx = UniswapExchange(ude);
248             UniswapExchange mkrEx = UniswapExchange(ume);
249             ERC20Interface dai = tub.sai();
250             ERC20Interface mkr = tub.gov();
251 
252             bytes32 cup = bytes32(cdpNum);
253 
254             (address lad,,,) = tub.cups(cup);
255             require(lad == address(this), "cup-not-owned");
256 
257             setAllowance(dai, sai);
258             setAllowance(mkr, sai);
259             setAllowance(dai, ude);
260 
261             (bytes32 val, bool ok) = tub.pep().peek();
262 
263             // MKR required for wipe = Stability fees accrued in Dai / MKRUSD value
264             uint mkrFee = wdiv(rmul(_wad, rdiv(tub.rap(cup), tub.tab(cup))), uint(val));
265 
266             uint daiFeeAmt = daiEx.getTokenToEthOutputPrice(mkrEx.getEthToTokenOutputPrice(mkrFee));
267             daiAmt = add(_wad, daiFeeAmt);
268 
269             redeemUnderlying(cDai, daiAmt);
270 
271             if (ok && val != 0) {
272                 daiEx.tokenToTokenSwapOutput(
273                     mkrFee,
274                     daiAmt,
275                     uint(999000000000000000000),
276                     uint(1899063809), // 6th March 2030 GMT // no logic
277                     address(mkr)
278                 );
279             }
280 
281             tub.wipe(cup, _wad);
282 
283             emit LogWipe(
284                 cdpNum,
285                 daiAmt,
286                 mkrFee,
287                 daiFeeAmt,
288                 address(this)
289             );
290 
291         }
292     }
293 
294     function free(uint cdpNum, uint jam) internal {
295         if (jam > 0) {
296             bytes32 cup = bytes32(cdpNum);
297             address tubAddr = sai;
298 
299             TubInterface tub = TubInterface(tubAddr);
300             ERC20Interface peth = tub.skr();
301             ERC20Interface weth = tub.gem();
302 
303             uint ink = rdiv(jam, tub.per());
304             ink = rmul(ink, tub.per()) <= jam ? ink : ink - 1;
305             tub.free(cup, ink);
306 
307             setAllowance(peth, tubAddr);
308 
309             tub.exit(ink);
310             uint freeJam = weth.balanceOf(address(this)); // withdraw possible previous stuck WETH as well
311             weth.withdraw(freeJam);
312 
313             emit LogFree(
314                 cdpNum,
315                 freeJam,
316                 ink,
317                 address(this)
318             );
319         }
320     }
321 
322     function lock(uint cdpNum, uint ethAmt) internal {
323         if (ethAmt > 0) {
324             bytes32 cup = bytes32(cdpNum);
325             address tubAddr = sai;
326 
327             TubInterface tub = TubInterface(tubAddr);
328             ERC20Interface weth = tub.gem();
329             ERC20Interface peth = tub.skr();
330 
331             (address lad,,,) = tub.cups(cup);
332             require(lad == address(this), "cup-not-owned");
333 
334             weth.deposit.value(ethAmt)();
335 
336             uint ink = rdiv(ethAmt, tub.per());
337             ink = rmul(ink, tub.per()) <= ethAmt ? ink : ink - 1;
338 
339             setAllowance(weth, tubAddr);
340             tub.join(ink);
341 
342             setAllowance(peth, tubAddr);
343             tub.lock(cup, ink);
344 
345             emit LogLock(
346                 cdpNum,
347                 ethAmt,
348                 ink,
349                 address(this)
350             );
351         }
352     }
353 
354     function draw(uint cdpNum, uint _wad) internal {
355         bytes32 cup = bytes32(cdpNum);
356         if (_wad > 0) {
357             TubInterface tub = TubInterface(sai);
358 
359             tub.draw(cup, _wad);
360 
361             emit LogDraw(cdpNum, _wad, address(this));
362         }
363     }
364 
365     function checkCDP(bytes32 cup, uint ethAmt, uint daiAmt) internal returns (uint ethCol, uint daiDebt) {
366         TubInterface tub = TubInterface(sai);
367         ethCol = rmul(tub.ink(cup), tub.per()); // get ETH col from PETH col
368         daiDebt = tub.tab(cup);
369         daiDebt = daiAmt < daiDebt ? daiAmt : daiDebt; // if DAI amount > max debt. Set max debt
370         ethCol = ethAmt < ethCol ? ethAmt : ethCol; // if ETH amount > max Col. Set max col
371     }
372 
373     function wipeAndFree(uint cdpNum, uint jam, uint _wad) internal returns (uint daiAmt) {
374         daiAmt = wipe(cdpNum, _wad);
375         free(cdpNum, jam);
376     }
377 
378     function lockAndDraw(uint cdpNum, uint jam, uint _wad) internal {
379         lock(cdpNum, jam);
380         draw(cdpNum, _wad);
381     }
382 
383 }
384 
385 
386 contract BridgeResolver is MakerResolver {
387 
388     /**
389      * @dev initiated from user wallet to reimburse temporary DAI debt
390      */
391     function refillFunds(uint daiDebt) external {
392         if (daiDebt > 0) {
393             require(ERC20Interface(daiAddr).transferFrom(msg.sender, address(this), daiDebt), "Contract Approved?");
394             assert(CDAIInterface(cDai).mint(daiDebt) == 0);
395         }
396     }
397 
398     /**
399      * @dev paying back users debt
400      */
401     function payUserDebt(uint daiDebt) internal {
402         if (daiDebt > 0) {
403             redeemUnderlying(cDai, daiDebt);
404             require(CDAIInterface(cDai).repayBorrowBehalf(msg.sender, daiDebt) == 0, "Enough DAI?");
405         }
406     }
407 
408 }
409 
410 
411 contract LiquidityProvider is BridgeResolver {
412 
413     mapping (address => uint) public deposits; // amount of CDAI deposits
414     uint public totalDeposits;
415 
416     /**
417      * @dev Deposit DAI for liquidity
418      */
419     function depositDAI(uint amt) public {
420         require(ERC20Interface(daiAddr).transferFrom(msg.sender, address(this), amt), "Nothing to deposit");
421         CTokenInterface cToken = CTokenInterface(cDai);
422         assert(cToken.mint(amt) == 0);
423         uint exchangeRate = cToken.exchangeRateCurrent();
424         uint cDaiAmt = wdiv(amt, exchangeRate);
425         cDaiAmt = wmul(cDaiAmt, exchangeRate) <= amt ? cDaiAmt : cDaiAmt - 1;
426         deposits[msg.sender] += cDaiAmt;
427         totalDeposits += cDaiAmt;
428     }
429 
430     /**
431      * @dev Withdraw DAI from liquidity
432      */
433     function withdrawDAI(uint amt) public {
434         require(deposits[msg.sender] != 0, "Nothing to Withdraw");
435         CTokenInterface cToken = CTokenInterface(cDai);
436         uint exchangeRate = cToken.exchangeRateCurrent();
437         uint withdrawAmt = wdiv(amt, exchangeRate);
438         uint daiAmt = amt;
439         if (withdrawAmt > deposits[msg.sender]) {
440             withdrawAmt = deposits[msg.sender];
441             daiAmt = wmul(withdrawAmt, exchangeRate);
442         }
443         require(cToken.redeem(withdrawAmt) == 0, "something went wrong");
444         require(ERC20Interface(daiAddr).transfer(msg.sender, daiAmt), "Dai Transfer failed");
445         deposits[msg.sender] -= withdrawAmt;
446         totalDeposits -= withdrawAmt;
447     }
448 
449     /**
450      * @dev Deposit CDAI for liquidity
451      */
452     function depositCDAI(uint amt) public {
453         CTokenInterface cToken = CTokenInterface(cDai);
454         require(cToken.transferFrom(msg.sender, address(this), amt) == true, "Nothing to deposit");
455         deposits[msg.sender] += amt;
456         totalDeposits += amt;
457     }
458 
459     /**
460      * @dev Withdraw CDAI from liquidity
461      */
462     function withdrawCDAI(uint amt) public {
463         require(deposits[msg.sender] != 0, "Nothing to Withdraw");
464         uint withdrawAmt = amt;
465         if (withdrawAmt > deposits[msg.sender]) {
466             withdrawAmt = deposits[msg.sender];
467         }
468         require(CTokenInterface(cDai).transfer(msg.sender, withdrawAmt), "Dai Transfer failed");
469         deposits[msg.sender] -= withdrawAmt;
470         totalDeposits -= withdrawAmt;
471     }
472 
473     /**
474      * collecting fees generated overtime
475      */
476     function withdrawFeesInCDai(uint num) public {
477         CTokenInterface cToken = CTokenInterface(cDai);
478         uint cDaiBal = cToken.balanceOf(address(this));
479         uint withdrawAmt = sub(cDaiBal, totalDeposits);
480         if (num == 0) {
481             require(cToken.transfer(feeOne, withdrawAmt), "Dai Transfer failed");
482         } else {
483             require(cToken.transfer(feeTwo, withdrawAmt), "Dai Transfer failed");
484         }
485     }
486 
487 }
488 
489 
490 contract Bridge is LiquidityProvider {
491 
492     /**
493      * FOR SECURITY PURPOSE
494      * checks if only InstaDApp contract wallets can access the bridge
495      */
496     modifier isUserWallet {
497         address userAdd = UserWalletInterface(msg.sender).owner();
498         address walletAdd = RegistryInterface(registry).proxies(userAdd);
499         require(walletAdd != address(0), "not-user-wallet");
500         require(walletAdd == msg.sender, "not-wallet-owner");
501         _;
502     }
503 
504     /**
505      * @dev MakerDAO to Compound
506      */
507     function makerToCompound(uint cdpId, uint ethCol, uint daiDebt) public payable isUserWallet returns (uint daiAmt) {
508         uint ethAmt;
509         (ethAmt, daiAmt) = checkCDP(bytes32(cdpId), ethCol, daiDebt);
510         daiAmt = wipeAndFree(cdpId, ethAmt, daiAmt);
511         daiAmt = wmul(daiAmt, 1002000000000000000); // 0.2% fees
512         mintCETH(ethAmt);
513         give(cdpId, msg.sender);
514     }
515 
516     /**
517      * @dev Compound to MakerDAO
518      */
519     function compoundToMaker(uint cdpId, uint ethCol, uint daiDebt) public payable isUserWallet {
520         (uint ethAmt, uint daiAmt) = checkCompound(ethCol, daiDebt);
521         payUserDebt(daiAmt);
522         fetchCETH(ethAmt);
523         redeemUnderlying(cEth, ethAmt);
524         uint cdpNum = cdpId > 0 ? cdpId : open();
525         daiAmt = wmul(daiAmt, 1002000000000000000); // 0.2% fees
526         lockAndDraw(cdpNum, ethAmt, daiAmt);
527         if (daiAmt > 0) {
528             assert(CDAIInterface(cDai).mint(daiAmt) == 0);
529         }
530         give(cdpNum, msg.sender);
531     }
532 
533 }
534 
535 
536 contract MakerCompoundBridge is Bridge {
537 
538     /**
539      * @dev setting up all required token approvals
540      */
541     constructor() public {
542         setApproval(daiAddr, 10**30, cDai);
543         setApproval(cDai, 10**30, cDai);
544         setApproval(cEth, 10**30, cEth);
545     }
546 
547     function() external payable {}
548 
549 }