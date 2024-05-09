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
154     /**
155      * @dev Redeem ETH/ERC20 and mint Compound Tokens
156      * @param tokenAmt Amount of token To Redeem
157      */
158     function redeemUnderlying(address cErc20, uint tokenAmt) internal {
159         if (tokenAmt > 0) {
160             require(CTokenInterface(cErc20).redeemUnderlying(tokenAmt) == 0, "something went wrong");
161         }
162     }
163 
164     /**
165      * @dev Deposit ETH/ERC20 and mint Compound Tokens
166      */
167     function mintCETH(uint ethAmt) internal {
168         if (ethAmt > 0) {
169             CETHInterface cToken = CETHInterface(cEth);
170             cToken.mint.value(ethAmt)();
171             uint exchangeRate = CTokenInterface(cEth).exchangeRateCurrent();
172             uint cEthToReturn = wdiv(ethAmt, exchangeRate);
173             cEthToReturn = wmul(cEthToReturn, exchangeRate) <= ethAmt ? cEthToReturn : cEthToReturn - 1;
174             require(cToken.transfer(msg.sender, cEthToReturn), "CETH Transfer failed");
175         }
176     }
177 
178     /**
179      * @dev Deposit ETH/ERC20 and mint Compound Tokens
180      */
181     function fetchCETH(uint ethAmt) internal {
182         if (ethAmt > 0) {
183             CTokenInterface cToken = CTokenInterface(cEth);
184             uint exchangeRate = cToken.exchangeRateCurrent();
185             uint cTokenAmt = wdiv(ethAmt, exchangeRate);
186             cTokenAmt = wmul(cTokenAmt, exchangeRate) <= ethAmt ? cTokenAmt : cTokenAmt - 1;
187             require(ERC20Interface(cEth).transferFrom(msg.sender, address(this), cTokenAmt), "Contract Approved?");
188         }
189     }
190 
191     /**
192      * @dev If col/debt > user's balance/borrow. Then set max
193      */
194     function checkCompound(uint ethAmt, uint daiAmt) internal returns (uint ethCol, uint daiDebt) {
195         CTokenInterface cEthContract = CTokenInterface(cEth);
196         uint cEthBal = cEthContract.balanceOf(msg.sender);
197         uint ethExchangeRate = cEthContract.exchangeRateCurrent();
198         ethCol = wmul(cEthBal, ethExchangeRate);
199         ethCol = wdiv(ethCol, ethExchangeRate) <= cEthBal ? ethCol : ethCol - 1;
200         ethCol = ethCol <= ethAmt ? ethCol : ethAmt; // Set Max if amount is greater than the Col user have
201 
202         daiDebt = CDAIInterface(cDai).borrowBalanceCurrent(msg.sender);
203         daiDebt = daiDebt <= daiAmt ? daiDebt : daiAmt; // Set Max if amount is greater than the Debt user have
204     }
205 
206 }
207 
208 
209 contract MakerResolver is CompoundResolver {
210 
211     event LogOpen(uint cdpNum, address owner);
212     event LogWipe(uint cdpNum, uint daiAmt, uint mkrFee, uint daiFee, address owner);
213 
214     function open() internal returns (uint) {
215         bytes32 cup = TubInterface(sai).open();
216         emit LogOpen(uint(cup), address(this));
217         return uint(cup);
218     }
219 
220     /**
221      * @dev transfer CDP ownership
222      */
223     function give(uint cdpNum, address nextOwner) internal {
224         TubInterface(sai).give(bytes32(cdpNum), nextOwner);
225     }
226 
227     function wipe(uint cdpNum, uint _wad) internal returns (uint daiAmt) {
228         if (_wad > 0) {
229             TubInterface tub = TubInterface(sai);
230             UniswapExchange daiEx = UniswapExchange(ude);
231             UniswapExchange mkrEx = UniswapExchange(ume);
232             ERC20Interface dai = tub.sai();
233             ERC20Interface mkr = tub.gov();
234 
235             bytes32 cup = bytes32(cdpNum);
236 
237             (address lad,,,) = tub.cups(cup);
238             require(lad == address(this), "cup-not-owned");
239 
240             setAllowance(dai, sai);
241             setAllowance(mkr, sai);
242             setAllowance(dai, ude);
243 
244             (bytes32 val, bool ok) = tub.pep().peek();
245 
246             // MKR required for wipe = Stability fees accrued in Dai / MKRUSD value
247             uint mkrFee = wdiv(rmul(_wad, rdiv(tub.rap(cup), tub.tab(cup))), uint(val));
248 
249             uint daiFeeAmt = daiEx.getTokenToEthOutputPrice(mkrEx.getEthToTokenOutputPrice(mkrFee));
250             daiAmt = add(_wad, daiFeeAmt);
251 
252             redeemUnderlying(cDai, daiAmt);
253 
254             if (ok && val != 0) {
255                 daiEx.tokenToTokenSwapOutput(
256                     mkrFee,
257                     daiAmt,
258                     uint(999000000000000000000),
259                     uint(1899063809), // 6th March 2030 GMT // no logic
260                     address(mkr)
261                 );
262             }
263 
264             tub.wipe(cup, _wad);
265 
266             emit LogWipe(
267                 cdpNum,
268                 daiAmt,
269                 mkrFee,
270                 daiFeeAmt,
271                 address(this)
272             );
273 
274         }
275     }
276 
277     function free(uint cdpNum, uint jam) internal {
278         if (jam > 0) {
279             bytes32 cup = bytes32(cdpNum);
280             address tubAddr = sai;
281 
282             TubInterface tub = TubInterface(tubAddr);
283             ERC20Interface peth = tub.skr();
284             ERC20Interface weth = tub.gem();
285 
286             uint ink = rdiv(jam, tub.per());
287             ink = rmul(ink, tub.per()) <= jam ? ink : ink - 1;
288             tub.free(cup, ink);
289 
290             setAllowance(peth, tubAddr);
291 
292             tub.exit(ink);
293             uint freeJam = weth.balanceOf(address(this)); // withdraw possible previous stuck WETH as well
294             weth.withdraw(freeJam);
295         }
296     }
297 
298     function lock(uint cdpNum, uint ethAmt) internal {
299         if (ethAmt > 0) {
300             bytes32 cup = bytes32(cdpNum);
301             address tubAddr = sai;
302 
303             TubInterface tub = TubInterface(tubAddr);
304             ERC20Interface weth = tub.gem();
305             ERC20Interface peth = tub.skr();
306 
307             (address lad,,,) = tub.cups(cup);
308             require(lad == address(this), "cup-not-owned");
309 
310             weth.deposit.value(ethAmt)();
311 
312             uint ink = rdiv(ethAmt, tub.per());
313             ink = rmul(ink, tub.per()) <= ethAmt ? ink : ink - 1;
314 
315             setAllowance(weth, tubAddr);
316             tub.join(ink);
317 
318             setAllowance(peth, tubAddr);
319             tub.lock(cup, ink);
320         }
321     }
322 
323     function draw(uint cdpNum, uint _wad) internal {
324         bytes32 cup = bytes32(cdpNum);
325         if (_wad > 0) {
326             TubInterface tub = TubInterface(sai);
327 
328             tub.draw(cup, _wad);
329         }
330     }
331 
332     function checkCDP(bytes32 cup, uint ethAmt, uint daiAmt) internal returns (uint ethCol, uint daiDebt) {
333         TubInterface tub = TubInterface(sai);
334         ethCol = rmul(tub.ink(cup), tub.per()); // get ETH col from PETH col
335         daiDebt = tub.tab(cup);
336         daiDebt = daiAmt < daiDebt ? daiAmt : daiDebt; // if DAI amount > max debt. Set max debt
337         ethCol = ethAmt < ethCol ? ethAmt : ethCol; // if ETH amount > max Col. Set max col
338     }
339 
340     function wipeAndFree(uint cdpNum, uint jam, uint _wad) internal returns (uint daiAmt) {
341         daiAmt = wipe(cdpNum, _wad);
342         free(cdpNum, jam);
343     }
344 
345     function lockAndDraw(uint cdpNum, uint jam, uint _wad) internal {
346         lock(cdpNum, jam);
347         draw(cdpNum, _wad);
348     }
349 
350 }
351 
352 
353 contract BridgeResolver is MakerResolver {
354 
355     event LogMakerToCompound(uint cdpNum, uint ethAmt, uint daiAmt, uint fees, address owner);
356     event LogCompoundToMaker(uint cdpNum, uint ethAmt, uint daiAmt, uint fees, address owner);
357 
358     /**
359      * @dev initiated from user wallet to reimburse temporary DAI debt
360      */
361     function refillFunds(uint daiDebt) external {
362         if (daiDebt > 0) {
363             require(ERC20Interface(daiAddr).transferFrom(msg.sender, address(this), daiDebt), "Contract Approved?");
364             assert(CDAIInterface(cDai).mint(daiDebt) == 0);
365         }
366     }
367 
368     /**
369      * @dev paying back users debt
370      */
371     function payUserDebt(uint daiDebt) internal {
372         if (daiDebt > 0) {
373             redeemUnderlying(cDai, daiDebt);
374             require(CDAIInterface(cDai).repayBorrowBehalf(msg.sender, daiDebt) == 0, "Enough DAI?");
375         }
376     }
377 
378 }
379 
380 
381 contract LiquidityProvider is BridgeResolver {
382 
383     mapping (address => uint) public deposits; // amount of CDAI deposits
384     uint public totalDeposits;
385 
386     /**
387      * @dev Deposit DAI for liquidity
388      */
389     function depositDAI(uint amt) public {
390         require(ERC20Interface(daiAddr).transferFrom(msg.sender, address(this), amt), "Nothing to deposit");
391         CTokenInterface cToken = CTokenInterface(cDai);
392         assert(cToken.mint(amt) == 0);
393         uint exchangeRate = cToken.exchangeRateCurrent();
394         uint cDaiAmt = wdiv(amt, exchangeRate);
395         cDaiAmt = wmul(cDaiAmt, exchangeRate) <= amt ? cDaiAmt : cDaiAmt - 1;
396         deposits[msg.sender] += cDaiAmt;
397         totalDeposits += cDaiAmt;
398     }
399 
400     /**
401      * @dev Withdraw DAI from liquidity
402      */
403     function withdrawDAI(uint amt) public {
404         require(deposits[msg.sender] != 0, "Nothing to Withdraw");
405         CTokenInterface cToken = CTokenInterface(cDai);
406         uint exchangeRate = cToken.exchangeRateCurrent();
407         uint withdrawAmt = wdiv(amt, exchangeRate);
408         uint daiAmt = amt;
409         if (withdrawAmt > deposits[msg.sender]) {
410             withdrawAmt = deposits[msg.sender];
411             daiAmt = wmul(withdrawAmt, exchangeRate);
412         }
413         require(cToken.redeem(withdrawAmt) == 0, "something went wrong");
414         require(ERC20Interface(daiAddr).transfer(msg.sender, daiAmt), "Dai Transfer failed");
415         deposits[msg.sender] -= withdrawAmt;
416         totalDeposits -= withdrawAmt;
417     }
418 
419     /**
420      * @dev Deposit CDAI for liquidity
421      */
422     function depositCDAI(uint amt) public {
423         CTokenInterface cToken = CTokenInterface(cDai);
424         require(cToken.transferFrom(msg.sender, address(this), amt) == true, "Nothing to deposit");
425         deposits[msg.sender] += amt;
426         totalDeposits += amt;
427     }
428 
429     /**
430      * @dev Withdraw CDAI from liquidity
431      */
432     function withdrawCDAI(uint amt) public {
433         require(deposits[msg.sender] != 0, "Nothing to Withdraw");
434         uint withdrawAmt = amt;
435         if (withdrawAmt > deposits[msg.sender]) {
436             withdrawAmt = deposits[msg.sender];
437         }
438         require(CTokenInterface(cDai).transfer(msg.sender, withdrawAmt), "Dai Transfer failed");
439         deposits[msg.sender] -= withdrawAmt;
440         totalDeposits -= withdrawAmt;
441     }
442 
443     /**
444      * collecting unmapped CDAI
445      */
446     function collectCDAI(uint num) public {
447         CTokenInterface cToken = CTokenInterface(cDai);
448         uint cDaiBal = cToken.balanceOf(address(this));
449         uint withdrawAmt = sub(cDaiBal, totalDeposits);
450         if (num == 0) {
451             require(cToken.transfer(feeOne, withdrawAmt), "CDai Transfer failed");
452         } else {
453             require(cToken.transfer(feeTwo, withdrawAmt), "CDai Transfer failed");
454         }
455     }
456 
457     /**
458      * (HIGHLY UNLIKELY TO HAPPEN)
459      * collecting Tokens/ETH other than CDAI
460      */
461     function collectTokens(uint num, address token) public {
462         require(token != cDai, "Token address == CDAI address");
463         if (token == ethAddr) {
464             if (num == 0) {
465                 msg.sender.transfer(address(this).balance);
466             } else {
467                 msg.sender.transfer(address(this).balance);
468             }
469         } else {
470             ERC20Interface tokenContract = ERC20Interface(token);
471             uint tokenBal = tokenContract.balanceOf(address(this));
472             uint withdrawAmt = sub(tokenBal, totalDeposits);
473             if (num == 0) {
474                 require(tokenContract.transfer(feeOne, withdrawAmt), "Transfer failed");
475             } else {
476                 require(tokenContract.transfer(feeTwo, withdrawAmt), "Transfer failed");
477             }
478         }
479     }
480 
481     /**
482      * (HIGHLY UNLIKELY TO HAPPEN)
483      * Transfer CDP ownership (Just in case this contract has ownership of any CDP)
484      */
485     function transferUnmappedCDP(uint cdpNum, uint num) public {
486         if (num == 0) {
487             give(cdpNum, feeOne);
488         } else {
489             give(cdpNum, feeTwo);
490         }
491     }
492 
493 }
494 
495 
496 contract Bridge is LiquidityProvider {
497 
498     /**
499      * FOR SECURITY PURPOSE
500      * checks if only InstaDApp contract wallets can access the bridge
501      */
502     modifier isUserWallet {
503         address userAdd = UserWalletInterface(msg.sender).owner();
504         address walletAdd = RegistryInterface(registry).proxies(userAdd);
505         require(walletAdd != address(0), "not-user-wallet");
506         require(walletAdd == msg.sender, "not-wallet-owner");
507         _;
508     }
509 
510     /**
511      * @dev MakerDAO to Compound
512      */
513     function makerToCompound(uint cdpId, uint ethCol, uint daiDebt) public payable isUserWallet returns (uint daiAmt) {
514         uint ethAmt;
515         (ethAmt, daiAmt) = checkCDP(bytes32(cdpId), ethCol, daiDebt);
516         daiAmt = wipeAndFree(cdpId, ethAmt, daiAmt);
517         uint fees = wmul(daiAmt, 2000000000000000); // 0.2% fees
518         daiAmt = wmul(daiAmt, 1002000000000000000);
519         mintCETH(ethAmt);
520         give(cdpId, msg.sender);
521         emit LogMakerToCompound(
522             cdpId,
523             ethAmt,
524             daiAmt,
525             fees,
526             msg.sender
527         );
528     }
529 
530     /**
531      * @dev Compound to MakerDAO
532      */
533     function compoundToMaker(uint cdpId, uint ethCol, uint daiDebt) public payable isUserWallet {
534         (uint ethAmt, uint daiAmt) = checkCompound(ethCol, daiDebt);
535         payUserDebt(daiAmt);
536         fetchCETH(ethAmt);
537         redeemUnderlying(cEth, ethAmt);
538         uint cdpNum = cdpId > 0 ? cdpId : open();
539         uint fees = wmul(daiAmt, 2000000000000000); // 0.2% fees
540         daiAmt = wmul(daiAmt, 1002000000000000000);
541         lockAndDraw(cdpNum, ethAmt, daiAmt);
542         if (daiAmt > 0) {
543             assert(CDAIInterface(cDai).mint(daiAmt) == 0);
544         }
545         give(cdpNum, msg.sender);
546         emit LogCompoundToMaker(
547             cdpNum,
548             ethAmt,
549             daiAmt,
550             fees,
551             msg.sender
552         );
553     }
554 
555 }
556 
557 
558 contract MakerCompoundBridge is Bridge {
559 
560     /**
561      * @dev setting up all required token approvals
562      */
563     constructor() public {
564         setApproval(daiAddr, 10**30, cDai);
565         setApproval(cDai, 10**30, cDai);
566         setApproval(cEth, 10**30, cEth);
567     }
568 
569     function() external payable {}
570 
571 }