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
15 Contract: Smart Contract for orchestrating the X7 Finance V1 to V2 Migration
16 
17 WARNING:
18 
19     DO NOT SEND YOUR TOKENS DIRECTLY TO THIS CONTRACT.
20     IF YOU DO SO, IT WILL BE A DONATION TO THE PROJECT AND YOU WILL RECEIVE NOTHING IN RETURN.
21     YOU MUST USE THE submitManyTokens FUNCTION VIA ETHERSCAN, A SCRIPT, OR THE dAPP.
22 
23                                 YOU HAVE BEEN WARNED.
24 
25 The migration from the V1 ecosystem to the V2 ecosystem will happen in time bound phases
26 that are encoded in the contract.
27 
28 Phase 0: Review
29 
30     The contract goes live and is verified.
31     The community will have some time to review the contract before it is live.
32 
33 Phase 1: Migrate In
34 
35     The function goLive() will be called by the contract owner.
36     This will start the clock on the migration and there is no turning back.
37 
38     The contents of the goLive function is copied here:
39 
40         function goLive() external onlyOwner {
41             // This allows migration to begin
42             liveTime = block.timestamp;
43 
44             // This allows the migration wallet snapshot to be submitted
45             walletSnapshotAllowTime = liveTime + walletSnapshotSecondsOffset;
46 
47             // Once this time is passed, the migration steps are unlocked
48             migrationFreeTime = block.timestamp + migrationFreeSecondsOffset;
49 
50             // The migration is expected to be run to completion once the migrationFreeTime has passed.
51             // However, to ensure that there is no risk that tokens would be permanently locked within this contract
52             // after this time is passed any one may run the migration steps.
53             // This is not an expected outcome but is provided as an additional safety measure to reduce the trust needed
54             // to carry out a successful migration.
55             migrationNoRunAuthTimeout = block.timestamp + migrationNoRunAuthOffset;
56         }
57 
58     After the migration has been live for 2 days, the function to submit the wallet
59     snapshot will be enabled. Anyone that migrates their tokens will automatically
60     be included in the migration. However long term holders or holders that lost track
61     of this investment should not be penalized. This snapshot will ensure that those
62     unengaged holders are included in the token snapshot that will happen during the
63     migration phase.
64 
65     The community will then have 1 day to review that list.
66 
67     The developers will continue to update the list of active wallets as best they can,
68     but after the initial list is submitted, any new wallets that buy can only guarantee
69     their inclusion in the migration by migrating themselves via the migration dApp or
70     contract call.
71 
72 Phase 2: Migrate Out
73 
74     This phase will be accomplished via numbered, ordered functions that can only be called in that specific order
75 
76     They look like:
77 
78         function migrationStep{number}{Thing that it is doing}
79 
80     These functions can be called by the contract owner after the migrationFreeTime (3 days)
81     has passed, or by anyone after the migrationNoRunAuthTimeout (6 days) has passed.
82 
83     The method for the migration has to account for a number of factors:
84 
85         1. Preserving investor value
86         2. Improving the liquidity ratio for improved trading experience post migration
87         3. Preventing any possibility for griefing or exploitation
88         4. Ensuring it is as trustless as possible. If you cannot live by your own tenets, who else will?
89 
90     a. Prior to the migration start we will deploy ALL the uniswap pair contracts (unfunded), as this is a
91         gas intensive step that cannot be accomplished later. Since all relevant v2 tokens will be locked
92         in this contract, there is no external affect other than the creation of new Uniswap pairs. There
93         are 17 Uniswap trading pairs (7 token/ETH pairs and 10 pairs inside the constellation). Additionally
94         the v2 tokens owner will temporarily transfer ownership to this contract, so the migration contract
95         can act as the v2 token owner and set the proper settings like marking which addresses are trading
96         pairs and enabling trading in the final stage.
97 
98     b. In a single transaction for each V1 token, a holder balance snapshot will be taken. this snapshot
99         determines how many tokens may be migrated for that wallet. The wallet will be unable to migrate
100         more than that amount. This will also snapshot the liquidity and market cap of the tokens.
101 
102         All tokens that have been submitted to this contract will be swapped for ETH via the V1 token pair.
103         Whatever capital is left within the V1 token pair may be recovered post migration as additional
104         wallets migrate their tokens manually.
105 
106     c. Based on the harvested liquidity from step (b) we will calculate the new ETH and token reserves
107         for each ETH pair. We will cap liquidity increases in X7R and X7DAO to a 2X improvement to liquidity
108         and 3X improvement to liquidity for each X7100 token. Holder token positions will be modified so
109         that their pre-migration and post-migration total value will be equivalent.
110 
111     d. In a single transaction we will add liquidity to all V2 token trading pairs. At this point the
112         V2 tokens will be READY to go live. However, to ensure that all V1 token holders have possession
113         of their new v2 tokens, the token contracts will NOT be enabled for any transfers accept from
114         this migration contract until enabled at the end of the migration.
115 
116     e. In a number of additional steps, we will airdrop all the V2 tokens. These have been split up to due
117         to the gas costs associated with transferring tokens to many 100s of wallets.
118 
119     f. Once all v2 tokens have been airdropped, the final migration step migrationStep14EnableTrading() will
120         be called. This will enable trading and transfers on all v2 tokens.
121 
122     Any holder of v1 tokens may continue to use the dAPP or call the submitManyTokens() function on the
123     contract to migrate any tokens that were included in the wallet snapshots earlier.
124 
125     The final step that will be taken is the owner of this contract will regain ownership of all the v2 tokens.
126     Please see each v2 token to see the limited changes that can be made by the contract owner.
127 
128     This migration is necessary for the future success of the X7 ecosystem and product offerings. The greater
129     the participation, the greater the success!
130 
131     A note on trust and safety:
132 
133         Migrations often involve, at some point, a single individual holding all the tokens and/or all the
134         capital from the v1. The investors are often asked to, just momentarily, trust that single individual
135         to do the right thing and use that capital for the migration.
136 
137         The developers of this project are not known to you. You have no reason to trust us. We will never ask
138         for you to trust us.
139 
140         This migration contract is deterministic, and once it is live, either the developer will execute each
141         step of the migration in series, or if enough time passes, any one can do so.
142 
143         The only trust that exists is the wallet snapshot to preserve the token value for inactive or inattentive
144         investors. That is why there is a delay between the wallet snapshot and the migration - to allow the
145         community to verify its accuracy.
146 
147         In addition to the X7 product offerings, we think X7 can represent a model for how every DeFi project
148         should handle trust. Not by promising or doxxing or reputation, but by game theory and code.
149 
150         Trust no one. Trust code. Long live DeFi.
151 
152 */
153 
154 abstract contract Ownable {
155     address private _owner;
156 
157     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
158 
159     constructor(address owner_) {
160         _transferOwnership(owner_);
161     }
162 
163     modifier onlyOwner() {
164         _checkOwner();
165         _;
166     }
167 
168     function owner() public view virtual returns (address) {
169         return _owner;
170     }
171 
172     function _checkOwner() internal view virtual {
173         require(owner() == msg.sender, "Ownable: caller is not the owner");
174     }
175 
176     function renounceOwnership() public virtual onlyOwner {
177         _transferOwnership(address(0));
178     }
179 
180     function transferOwnership(address newOwner) public virtual onlyOwner {
181         require(newOwner != address(0), "Ownable: new owner is the zero address");
182         _transferOwnership(newOwner);
183     }
184 
185     function _transferOwnership(address newOwner) internal virtual {
186         address oldOwner = _owner;
187         _owner = newOwner;
188         emit OwnershipTransferred(oldOwner, newOwner);
189     }
190 }
191 
192 interface IUniswapV2Router01 {
193     function factory() external pure returns (address);
194     function WETH() external pure returns (address);
195 
196     function addLiquidity(
197         address tokenA,
198         address tokenB,
199         uint amountADesired,
200         uint amountBDesired,
201         uint amountAMin,
202         uint amountBMin,
203         address to,
204         uint deadline
205     ) external returns (uint amountA, uint amountB, uint liquidity);
206     function addLiquidityETH(
207         address token,
208         uint amountTokenDesired,
209         uint amountTokenMin,
210         uint amountETHMin,
211         address to,
212         uint deadline
213     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
214 }
215 
216 interface IUniswapV2Router02 is IUniswapV2Router01 {
217     function swapExactTokensForETHSupportingFeeOnTransferTokens(
218         uint amountIn,
219         uint amountOutMin,
220         address[] calldata path,
221         address to,
222         uint deadline
223     ) external;
224 }
225 
226 interface IUniswapV2Factory {
227     function getPair(address tokenA, address tokenB) external view returns (address pair);
228     function createPair(address tokenA, address tokenB) external returns (address pair);
229 }
230 
231 interface IERC20 {
232     function totalSupply() external view returns (uint256);
233     function balanceOf(address account) external view returns (uint256);
234     function transfer(address to, uint256 amount) external returns (bool);
235     function approve(address spender, uint256 amount) external returns (bool);
236     function transferFrom(
237         address from,
238         address to,
239         uint256 amount
240     ) external returns (bool);
241 }
242 
243 interface IX7Token is IERC20 {
244     function setAMM(address, bool) external;
245     function setOffRampPair(address) external;
246     function enableTrading() external;
247 }
248 
249 interface IX7LiquidityHub {
250     function setOffRampPair(address) external;
251 }
252 
253 interface IX7100LiquidityHub {
254     function setOffRampPair(address, address) external;
255     function setConstellationToken(address, bool) external;
256 }
257 
258 contract X7V1toV2Migration is Ownable {
259     // v1 token address => ETH
260     mapping(address => uint256) public oldETHReserves;
261 
262     // v2 token address => ETH
263     mapping(address => uint256) public newETHReserves;
264 
265     // v1 token address => ETH
266     mapping(address => uint256) public oldTokenReserves;
267 
268     // v2 token address => ETH
269     mapping(address => uint256) public newTokenReserves;
270 
271     mapping(address => mapping(address => uint256)) public X7000TokenReserves;
272 
273     // v1 token address => v2 token interface
274     mapping(address => address) public v2TokenLookup;
275 
276     // v1 token address => is a constellation token
277     mapping(address => bool) public isConstellation;
278 
279     // v2 token address => v1 token
280     mapping(address => address) public oldConstellationTokenLookup;
281 
282     // v1 token address => total tokens in the "internal" pairs
283     mapping(address => uint256) public oldConstellationNonCirculatingTokenSupply;
284 
285     // v1 token address => v1 token address => total tokens in the token-token trading pair
286     mapping(address => mapping(address => uint256)) public oldConstellationNonCirculatingTokenReserve;
287 
288     // token => bool
289     mapping(address => bool) public isV1Token;
290 
291     // token => list of holders
292     mapping(address => address[]) public v1TokenHolders;
293 
294     // token => address => isAv1TokenHolder
295     mapping(address => mapping(address => bool)) public isAv1TokenHolder;
296 
297     // v1 token => old supply
298     mapping(address => uint256) public oldSupply;
299 
300     // v1 token => new supply (weighted)
301     mapping(address => uint256) public newSupplyLookup;
302 
303     uint256 public totalOldETHReserves;
304     uint256 public totalX7000ETHReserves;
305 
306     bool public migrationStep01Complete;
307     bool public migrationStep02Complete;
308     bool public migrationStep03Complete;
309     bool public migrationStep04Complete;
310     bool public migrationStep05Complete;
311     bool public migrationStep06Complete;
312 
313     bool public migrationStep07Complete;
314     bool public migrationStep08Complete;
315     bool public migrationStep09Complete;
316     bool public migrationStep10Complete;
317     bool public migrationStep11Complete;
318     bool public migrationStep12Complete;
319     bool public migrationStep13Complete;
320     bool public migrationStep14Complete;
321 
322     address public X7DAOv1;
323     address public X7DAOv2;
324     address public X7001;
325     address public X7101;
326     address public X7002;
327     address public X7102;
328     address public X7003;
329     address public X7103;
330     address public X7004;
331     address public X7104;
332     address public X7005;
333     address public X7105;
334     address public X7;
335     address public X7m105;
336     address public X7R;
337 
338     address public X7TokenTimelock;
339     IX7100LiquidityHub public X7100LiquidityHub;
340     IX7LiquidityHub public X7RLiquidityHub;
341     IX7LiquidityHub public X7DAOLiquidityHub;
342 
343     IERC20 public WETH;
344     address public X7DAOv1Pair;
345     address public X7Pair;
346     address public X7m105Pair;
347     address public X7001Pair;
348     address public X7002Pair;
349     address public X7003Pair;
350     address public X7004Pair;
351     address public X7005Pair;
352 
353     mapping(address => mapping(address => uint256)) public balance;
354     mapping(address => mapping(address => uint256)) public allowableToMigrate;
355     mapping(address => mapping(address => uint256)) public migrated;
356 
357     // token => address = token amount
358     mapping(address => mapping(address => uint256)) public v2Received;
359 
360     bool public postMigration;
361 
362     IUniswapV2Router02 public router;
363     IUniswapV2Factory public factory;
364 
365     // See goLive() function for details on each of these times.
366     uint256 public migrationNoRunAuthTimeout;
367     uint256 public liveTime;
368     uint256 public walletSnapshotAllowTime;
369     uint256 public migrationFreeTime;
370 
371     uint256 public migrationNoRunAuthOffset;
372     uint256 public migrationFreeSecondsOffset;
373     uint256 public walletSnapshotSecondsOffset;
374 
375     address payable public excessETHReceiver;
376 
377     constructor (
378         address router_,
379         uint256 walletSnapshotSecondsOffset_,
380         uint256 migrationFreeSecondsOffset_,
381         uint256 migrationNoRunAuthOffset_,
382         address excessETHReceiver_
383     ) Ownable(address(0x7000a09c425ABf5173FF458dF1370C25d1C58105)) {
384         router = IUniswapV2Router02(router_);
385         excessETHReceiver = payable(excessETHReceiver_);
386         X7TokenTimelock = address(0x7000F4Cddca46FB77196466C3833Be4E89ab810C);
387 
388         // TEST SHIM
389         migrationFreeSecondsOffset = migrationFreeSecondsOffset_;
390         walletSnapshotSecondsOffset = walletSnapshotSecondsOffset_;
391         migrationNoRunAuthOffset = migrationNoRunAuthOffset_;
392 
393         X7DAOv1 = address(0x7105AA393b9cF9b2497b460837313EA3dBA67Da0);
394         X7DAOv2 = address(0x7105E64bF67ECA3Ae9b123F0e5Ca2b83b2eF2dA0);
395         X7m105 = address(0x06D5cA7C9accd15a87d4993A421B7e702BDBaB20);
396         X7 = address(0x33DaD834eca1290A330C4C4634bC3b64a0197120);
397 
398         X7001 = address(0x7001629B8BF9A5D5F204B6d464a06f506fBFA105);
399         X7101 = address(0x7101a9392EAc53B01e7c07ca3baCa945A56EE105);
400         X7002 = address(0x70021e5edA64e68F035356Ea3DCe14ef87B6F105);
401         X7102 = address(0x7102DC82EF61bfB0410B1b1bF8EA74575bf0A105);
402         X7003 = address(0x70036Ddf2F2850f6d1B9D78D652776A0d1caB105);
403         X7103 = address(0x7103eBdbF1f89be2d53EFF9B3CF996C9E775c105);
404         X7004 = address(0x70041dB5aCDf2F8aa648A000FA4A87067AbAE105);
405         X7104 = address(0x7104D1f179Cc9cc7fb5c79Be6Da846E3FBC4C105);
406         X7005 = address(0x7005D9011F4275747D5cb38bC3deB0C46EdbD105);
407         X7105 = address(0x7105FAA4a26eD1c67B8B2b41BEc98F06Ee21D105);
408         X7R = address(0x70008F18Fc58928dcE982b0A69C2c21ff80Dca54);
409 
410         isV1Token[X7DAOv1] = true;
411         isV1Token[X7m105] = true;
412         isV1Token[X7] = true;
413         isV1Token[X7001] = true;
414         isV1Token[X7002] = true;
415         isV1Token[X7003] = true;
416         isV1Token[X7004] = true;
417         isV1Token[X7005] = true;
418 
419         v2TokenLookup[X7m105] = X7R;
420         v2TokenLookup[X7] = X7R;
421         v2TokenLookup[X7DAOv1] = X7DAOv2;
422         v2TokenLookup[X7001] = X7101;
423         v2TokenLookup[X7002] = X7102;
424         v2TokenLookup[X7003] = X7103;
425         v2TokenLookup[X7004] = X7104;
426         v2TokenLookup[X7005] = X7105;
427 
428         oldConstellationTokenLookup[X7101] = X7001;
429         oldConstellationTokenLookup[X7102] = X7002;
430         oldConstellationTokenLookup[X7103] = X7003;
431         oldConstellationTokenLookup[X7104] = X7004;
432         oldConstellationTokenLookup[X7105] = X7005;
433 
434         isConstellation[X7001] = true;
435         isConstellation[X7002] = true;
436         isConstellation[X7003] = true;
437         isConstellation[X7004] = true;
438         isConstellation[X7005] = true;
439 
440         factory = IUniswapV2Factory(router.factory());
441 
442         WETH = IERC20(router.WETH());
443 
444         X7100LiquidityHub = IX7100LiquidityHub(address(0x7102407afa5d6581AAb694FEB03fEB0e7Cf69ebb));
445         X7RLiquidityHub = IX7LiquidityHub(address(0x712a166E741405fCb9815Aa5c3442f2Cd3328ebb));
446         X7DAOLiquidityHub = IX7LiquidityHub(address(0x7Da0a524d323cdDaF3d465Ba617230f6b91d3ebb));
447     }
448 
449     modifier migrationLive {
450         require(liveTime != 0 && block.timestamp > liveTime);
451         _;
452     }
453 
454     modifier ownerOrAfterTime {
455         require(msg.sender == owner() || (migrationNoRunAuthTimeout != 0 && block.timestamp > migrationNoRunAuthTimeout));
456         _;
457     }
458 
459     modifier after48Hours {
460         require(migrationFreeTime != 0 && block.timestamp > walletSnapshotAllowTime);
461         _;
462     }
463 
464     modifier after72Hours {
465         require(migrationFreeTime != 0 && block.timestamp > migrationFreeTime);
466         _;
467     }
468 
469     receive() external payable {}
470 
471     function goLive() external onlyOwner {
472         // This allows migration to begin
473         liveTime = block.timestamp;
474 
475         // This allows the migration wallet snapshot to be submitted
476         walletSnapshotAllowTime = liveTime + walletSnapshotSecondsOffset;
477 
478         // Once this time is passed, the migration steps are unlocked
479         migrationFreeTime = block.timestamp + migrationFreeSecondsOffset;
480 
481         // The migration is expected to be run to completion once the migrationFreeTime has passed.
482         // However, to ensure that there is no risk that tokens would be permanently locked within this contract
483         // after this time is passed any one may run the migration steps.
484         // This is not an expected outcome but is provided as an additional safety measure to reduce the trust needed
485         // to carry out a successful migration.
486         migrationNoRunAuthTimeout = block.timestamp + migrationNoRunAuthOffset;
487     }
488 
489     function harvestLiquidity(address tokenAddress) external ownerOrAfterTime {
490         _harvestLiquidity(tokenAddress);
491     }
492 
493     function sweepETH() external ownerOrAfterTime {
494         require(postMigration);
495         require(excessETHReceiver != address(0));
496         (bool success, ) = excessETHReceiver.call{value: address(this).balance}("");
497         require(success);
498     }
499 
500     // A wallet must have contributed at least 1000 tokens from across the ecosystem to be considered
501     // "in" the migration, for purposes of whitelists and additional perks.
502     function inMigration(address holder) external view returns (bool) {
503         uint256 tokensMigrated = balance[X7DAOv1][holder];
504         tokensMigrated += balance[X7m105][holder];
505         tokensMigrated += balance[X7][holder];
506         tokensMigrated += balance[X7001][holder];
507         tokensMigrated += balance[X7002][holder];
508         tokensMigrated += balance[X7003][holder];
509         tokensMigrated += balance[X7004][holder];
510         tokensMigrated += balance[X7005][holder];
511 
512         if (tokensMigrated < 1000 * 10**18) {
513             return false;
514         } else {
515             return true;
516         }
517     }
518 
519     function submitManyTokens(address[] memory tokenAddresses, uint256[] memory tokenAmount) external migrationLive {
520         require(tokenAddresses.length == tokenAmount.length);
521 
522         for (uint i; i < tokenAddresses.length; i++) {
523             _submitTokens(tokenAddresses[i], tokenAmount[i]);
524         }
525     }
526 
527     function withdrawTokens(address tokenAddress, uint256 tokenAmount) external migrationLive {
528         require(isV1Token[tokenAddress]);
529         if (!postMigration) {
530             require(balance[tokenAddress][msg.sender] >= tokenAmount);
531             balance[tokenAddress][msg.sender] -= tokenAmount;
532             IERC20(tokenAddress).transfer(msg.sender, tokenAmount);
533         } else {
534             _airdropWalletTokens(tokenAddress, msg.sender);
535         }
536     }
537 
538     function setV1TokenHolderAddresses(address tokenAddress, address[] memory wallets) external after48Hours ownerOrAfterTime {
539         require(!migrationStep01Complete);
540 
541         for (uint i=0; i < wallets.length; i++) {
542             if (!isAv1TokenHolder[tokenAddress][wallets[i]]) {
543                 v1TokenHolders[tokenAddress].push(wallets[i]);
544                 isAv1TokenHolder[tokenAddress][wallets[i]] = true;
545             }
546         }
547     }
548 
549     //
550     //                  START MIGRATION PHASES
551     //
552 
553     // This step would happen automatically within the migration, but
554     // is implemented in a standalone manner to allow creation of token pair contracts
555     // prior to the migration for gas cost reasons.
556     function migrationStep00CreatePair(uint i) external ownerOrAfterTime {
557 
558         address weth = address(WETH);
559 
560         address[17] memory tokenAddress = [
561             X7R,
562             X7DAOv2,
563             X7101,
564             X7102,
565             X7103,
566             X7104,
567             X7105,
568 
569             X7101,
570             X7101,
571             X7101,
572             X7101,
573             X7102,
574             X7102,
575             X7102,
576             X7103,
577             X7103,
578             X7104
579         ];
580 
581         address[17] memory otherTokenAddress = [
582             weth,
583             weth,
584             weth,
585             weth,
586             weth,
587             weth,
588             weth,
589 
590             X7102,
591             X7103,
592             X7104,
593             X7105,
594             X7103,
595             X7104,
596             X7105,
597             X7104,
598             X7105,
599             X7105
600         ];
601 
602         _createPair(tokenAddress[i], otherTokenAddress[i]);
603 
604     }
605 
606     function migrationStep01SnapshotAndHarvestX7DAO()  external after72Hours ownerOrAfterTime {
607         require(!migrationStep01Complete);
608 
609         _takeSnapshot(X7DAOv1);
610         _harvestLiquidity(X7DAOv1);
611 
612         migrationStep01Complete = true;
613     }
614 
615     function migrationStep02SnapshotAndHarvestX7m105()  external after72Hours ownerOrAfterTime {
616         require(migrationStep01Complete);
617         require(!migrationStep02Complete);
618 
619         _takeSnapshot(X7m105);
620         _harvestLiquidity(X7m105);
621 
622         migrationStep02Complete = true;
623     }
624 
625     function migrationStep03SnapshotAndHarvestX7()  external after72Hours ownerOrAfterTime {
626         require(migrationStep02Complete);
627         require(!migrationStep03Complete);
628 
629         _takeSnapshot(X7);
630         _harvestLiquidity(X7);
631 
632         migrationStep03Complete = true;
633     }
634 
635     function migrationStep04SnapshotAndHarvestX7000()  external after72Hours ownerOrAfterTime {
636         require(migrationStep03Complete);
637         require(!migrationStep04Complete);
638 
639         _takeSnapshot(X7001);
640         _takeSnapshot(X7002);
641         _takeSnapshot(X7003);
642         _takeSnapshot(X7004);
643         _takeSnapshot(X7005);
644         _harvestLiquidity(X7001);
645         _harvestLiquidity(X7002);
646         _harvestLiquidity(X7003);
647         _harvestLiquidity(X7004);
648         _harvestLiquidity(X7005);
649 
650         migrationStep04Complete = true;
651     }
652 
653     function migrationStep05CalculateNewLiquidity()  external after72Hours ownerOrAfterTime {
654         require(migrationStep04Complete);
655         require(!migrationStep05Complete);
656 
657         _calculateNewLiquidity();
658 
659         migrationStep05Complete = true;
660     }
661 
662     function migrationStep06AddLiquidity()  external after72Hours ownerOrAfterTime {
663         require(migrationStep05Complete);
664         require(!migrationStep06Complete);
665 
666         _addLiquidity(X7DAOv2);
667         _addLiquidity(X7R);
668         _initiateX7100Launch();
669         _setupTokens();
670 
671         migrationStep06Complete = true;
672         postMigration = true;
673     }
674 
675     function migrationStep07DistributeV2X7DAO(uint256 startIndex, uint256 endIndex)  external after72Hours ownerOrAfterTime {
676         require(migrationStep06Complete);
677         _airdropMigrationTokens(X7DAOv1, X7DAOv2, startIndex, endIndex);
678         migrationStep07Complete = true;
679     }
680 
681     function migrationStep08DistributeX7R(uint256 startIndex, uint256 endIndex)  external after72Hours ownerOrAfterTime {
682         require(migrationStep06Complete);
683         _airdropMigrationTokens(X7m105, X7R, startIndex, endIndex);
684         _airdropMigrationTokens(X7, X7R, startIndex, endIndex);
685         migrationStep08Complete = true;
686     }
687 
688     function migrationStep09DistributeX7101(uint256 startIndex, uint256 endIndex)  external after72Hours ownerOrAfterTime {
689         require(migrationStep06Complete);
690         _airdropMigrationTokens(X7001, X7101, startIndex, endIndex);
691         migrationStep09Complete = true;
692     }
693 
694     function migrationStep10DistributeX7102(uint256 startIndex, uint256 endIndex)  external after72Hours ownerOrAfterTime {
695         require(migrationStep06Complete);
696         _airdropMigrationTokens(X7002, X7102, startIndex, endIndex);
697         migrationStep10Complete = true;
698     }
699 
700     function migrationStep11DistributeX7103(uint256 startIndex, uint256 endIndex)  external after72Hours ownerOrAfterTime {
701         require(migrationStep06Complete);
702         _airdropMigrationTokens(X7003, X7103, startIndex, endIndex);
703         migrationStep11Complete = true;
704     }
705 
706     function migrationStep12DistributeX7104(uint256 startIndex, uint256 endIndex)  external after72Hours ownerOrAfterTime {
707         require(migrationStep06Complete);
708         _airdropMigrationTokens(X7004, X7104, startIndex, endIndex);
709         migrationStep12Complete = true;
710     }
711 
712     function migrationStep13DistributeX7105(uint256 startIndex, uint256 endIndex)  external after72Hours ownerOrAfterTime {
713         require(migrationStep06Complete);
714         _airdropMigrationTokens(X7005, X7105, startIndex, endIndex);
715         migrationStep13Complete = true;
716     }
717 
718     function migrationStep14EnableTrading()  external after72Hours ownerOrAfterTime {
719         require(
720             migrationStep13Complete
721             && migrationStep12Complete
722             && migrationStep11Complete
723             && migrationStep10Complete
724             && migrationStep09Complete
725             && migrationStep08Complete
726             && migrationStep07Complete
727         );
728 
729         IX7Token(X7R).enableTrading();
730         IX7Token(X7DAOv2).enableTrading();
731         IX7Token(X7101).enableTrading();
732         IX7Token(X7102).enableTrading();
733         IX7Token(X7103).enableTrading();
734         IX7Token(X7104).enableTrading();
735         IX7Token(X7105).enableTrading();
736 
737         _resetOwnership(X7R);
738         _resetOwnership(X7DAOv2);
739         _resetOwnership(X7101);
740         _resetOwnership(X7102);
741         _resetOwnership(X7103);
742         _resetOwnership(X7104);
743         _resetOwnership(X7105);
744 
745         _resetOwnership(address(X7RLiquidityHub));
746         _resetOwnership(address(X7DAOLiquidityHub));
747         _resetOwnership(address(X7100LiquidityHub));
748     }
749 
750     //
751     //                  END MIGRATION PHASES
752     //
753 
754     function resetOwnership(address contractAddress) external onlyOwner {
755         _resetOwnership(contractAddress);
756     }
757 
758     function _submitTokens(address tokenAddress, uint256 tokenAmount) internal {
759         require(isV1Token[tokenAddress], "Bad Token");
760         if (tokenAmount == 0) {
761             return;
762         }
763 
764         IERC20(tokenAddress).transferFrom(msg.sender, address(this), tokenAmount);
765         balance[tokenAddress][msg.sender] += tokenAmount;
766 
767         if (postMigration) {
768             require(balance[tokenAddress][msg.sender] + migrated[tokenAddress][msg.sender] <= allowableToMigrate[tokenAddress][msg.sender]);
769             _airdropWalletTokens(tokenAddress, msg.sender);
770         } else {
771             if (!isAv1TokenHolder[tokenAddress][msg.sender]) {
772                 v1TokenHolders[tokenAddress].push(msg.sender);
773                 isAv1TokenHolder[tokenAddress][msg.sender] = true;
774             }
775         }
776     }
777 
778     function _airdropWalletTokens(address tokenAddress, address v1TokenHolder) internal {
779         uint256 migrateBalance = balance[tokenAddress][v1TokenHolder];
780         balance[tokenAddress][v1TokenHolder] = 0;
781         migrated[tokenAddress][v1TokenHolder] += migrateBalance;
782 
783         IERC20 token = IERC20(v2TokenLookup[tokenAddress]);
784 
785         uint256 numerator = newTokenReserves[address(token)] * oldETHReserves[tokenAddress];
786         uint256 denominator = oldTokenReserves[tokenAddress] * newETHReserves[address(token)];
787 
788         uint256 airdropAmount = migrateBalance * numerator / denominator / 10**14 * 10**14;
789 
790         if (airdropAmount == 0) {
791             return;
792         }
793 
794         v2Received[address(token)][v1TokenHolder] += airdropAmount;
795 
796         token.transfer(v1TokenHolder, airdropAmount);
797     }
798 
799     function _createPair(address tokenAddress, address otherTokenAddress) internal {
800         address pairAddress = factory.getPair(tokenAddress, otherTokenAddress);
801         if (pairAddress == address(0)) {
802             pairAddress = factory.createPair(tokenAddress, otherTokenAddress);
803         }
804     }
805 
806     function _calculateNewETHReserves() internal {
807         uint256 baseETHAmount;
808         uint256 extraConstellationETH;
809         uint256 totalOldETHReserves_ = totalOldETHReserves;
810 
811         // We are capping ETH liquidity increase to 2X for the existing pairs and 3X for the constellation
812         if (address(this).balance > 2 * totalOldETHReserves_) {
813             baseETHAmount = totalOldETHReserves_ * 2;
814             if (address(this).balance - baseETHAmount > totalX7000ETHReserves) {
815                 extraConstellationETH = totalX7000ETHReserves;
816             } else {
817                 extraConstellationETH = address(this).balance - baseETHAmount;
818             }
819         } else {
820             baseETHAmount = address(this).balance;
821         }
822 
823         newETHReserves[X7DAOv2] = baseETHAmount * oldETHReserves[X7DAOv1] / totalOldETHReserves_;
824         newETHReserves[X7R] = baseETHAmount * (oldETHReserves[X7] + oldETHReserves[X7m105]) / totalOldETHReserves_;
825 
826         // The constellation will get a greater amount of liquidity, if available
827         newETHReserves[X7101] = (baseETHAmount * oldETHReserves[X7001] / totalOldETHReserves_) + (extraConstellationETH * oldETHReserves[X7001] / totalX7000ETHReserves);
828         newETHReserves[X7102] = (baseETHAmount * oldETHReserves[X7002] / totalOldETHReserves_) + (extraConstellationETH * oldETHReserves[X7002] / totalX7000ETHReserves);
829         newETHReserves[X7103] = (baseETHAmount * oldETHReserves[X7003] / totalOldETHReserves_) + (extraConstellationETH * oldETHReserves[X7003] / totalX7000ETHReserves);
830         newETHReserves[X7104] = (baseETHAmount * oldETHReserves[X7004] / totalOldETHReserves_) + (extraConstellationETH * oldETHReserves[X7004] / totalX7000ETHReserves);
831         newETHReserves[X7105] = (baseETHAmount * oldETHReserves[X7005] / totalOldETHReserves_) + (extraConstellationETH * oldETHReserves[X7005] / totalX7000ETHReserves);
832     }
833 
834     function _calculateNewLiquidity() internal {
835         _calculateNewETHReserves();
836 
837         address newTokenAddress;
838         address oldTokenAddress;
839 
840         newTokenAddress = X7DAOv2;
841         oldTokenAddress = X7DAOv1;
842         newTokenReserves[newTokenAddress] = _getNewDAOReserves(
843             100000000 * 10**18,
844             newETHReserves[newTokenAddress],
845             oldETHReserves[oldTokenAddress],
846             oldTokenReserves[oldTokenAddress]
847         ) / 10**14 * 10**14;
848 
849         newTokenAddress = X7R;
850         newTokenReserves[newTokenAddress] = _getNewX7RReserves(
851             100000000 * 10**18,
852             newETHReserves[newTokenAddress]
853         ) / 10**14 * 10**14;
854 
855         newTokenAddress = X7101;
856         oldTokenAddress = X7001;
857         newTokenReserves[newTokenAddress] = _getNewConstellationReserves(
858             100000000 * 10**18,
859             newETHReserves[newTokenAddress],
860             oldETHReserves[oldTokenAddress],
861             oldTokenReserves[oldTokenAddress],
862             oldConstellationNonCirculatingTokenSupply[oldTokenAddress]
863         ) / 10**14 * 10**14;
864 
865         newTokenAddress = X7102;
866         oldTokenAddress = X7002;
867         newTokenReserves[newTokenAddress] = _getNewConstellationReserves(
868             100000000 * 10**18,
869             newETHReserves[newTokenAddress],
870             oldETHReserves[oldTokenAddress],
871             oldTokenReserves[oldTokenAddress],
872             oldConstellationNonCirculatingTokenSupply[oldTokenAddress]
873         ) / 10**14 * 10**14;
874 
875         newTokenAddress = X7103;
876         oldTokenAddress = X7003;
877         newTokenReserves[newTokenAddress] = _getNewConstellationReserves(
878             100000000 * 10**18,
879             newETHReserves[newTokenAddress],
880             oldETHReserves[oldTokenAddress],
881             oldTokenReserves[oldTokenAddress],
882             oldConstellationNonCirculatingTokenSupply[oldTokenAddress]
883         ) / 10**14 * 10**14;
884 
885         newTokenAddress = X7104;
886         oldTokenAddress = X7004;
887         newTokenReserves[newTokenAddress] = _getNewConstellationReserves(
888             100000000 * 10**18,
889             newETHReserves[newTokenAddress],
890             oldETHReserves[oldTokenAddress],
891             oldTokenReserves[oldTokenAddress],
892             oldConstellationNonCirculatingTokenSupply[oldTokenAddress]
893         ) / 10**14 * 10**14;
894 
895         newTokenAddress = X7105;
896         oldTokenAddress = X7005;
897         newTokenReserves[newTokenAddress] = _getNewConstellationReserves(
898             100000000 * 10**18,
899             newETHReserves[newTokenAddress],
900             oldETHReserves[oldTokenAddress],
901             oldTokenReserves[oldTokenAddress],
902             oldConstellationNonCirculatingTokenSupply[oldTokenAddress]
903         ) / 10**14 * 10**14;
904     }
905 
906     // The math here is that the goal is to find the new reserves that allows for the total holder value to remain constant.
907     //      Old Held tokens                   Old Price                   New Held Tokens                 New Price
908     //  (supply - old token pair) * old eth pair / old token pair == (supply - new token pair) * new eth pair / new token pair
909     //
910     //  This math will allow us to increase the ETH and Token reserves (and therefore create a better liquidity ratio)
911     //  while fully maintaining investor value. This math works no matter how much ETH is provided for liquidity from
912     //  the harvested V1 liquidity and any other source.
913 
914     function _getNewDAOReserves(uint256 supply, uint256 newWETH, uint256 oldWETH, uint256 oldReserve) internal pure returns (uint256) {
915         return supply * newWETH / (
916         (
917         // DAOv1 Holder mcap
918         (supply - oldReserve) * oldWETH / oldReserve
919         ) + newWETH
920         );
921     }
922 
923     function _getNewX7RReserves(uint256 newSupply, uint256 newWETH) internal view returns (uint256) {
924         return (newSupply * newWETH) /
925         (
926         // X7m105 holder mcap
927         ((oldSupply[X7m105] - oldTokenReserves[X7m105]) * oldETHReserves[X7m105] / oldTokenReserves[X7m105])
928         // X7 holder mcap
929         + ((oldSupply[X7] - oldTokenReserves[X7]) * oldETHReserves[X7] / oldTokenReserves[X7])
930         + newWETH
931         );
932     }
933 
934     // We are transferring over 1x1 the "internal" token-token pairs.
935     // Therefore we only need to account for the supply - oldReserve - "non circulating (the token-token pairs)"
936     function _getNewConstellationReserves(uint256 supply, uint256 newWETH, uint256 oldWETH, uint256 oldReserve, uint256 nonCirculating) internal pure returns (uint256) {
937         return (supply * newWETH - nonCirculating * newWETH) / (
938         (
939         // mcap of outstanding v1 tokens
940         (supply - oldReserve - nonCirculating) * oldWETH / oldReserve
941         ) + newWETH
942         );
943     }
944 
945     function _initiateX7100Launch() internal {
946         _createTokenPair(X7101, X7102);
947         _createTokenPair(X7101, X7103);
948         _createTokenPair(X7101, X7104);
949         _createTokenPair(X7101, X7105);
950         _createTokenPair(X7102, X7103);
951         _createTokenPair(X7102, X7104);
952         _createTokenPair(X7102, X7105);
953         _createTokenPair(X7103, X7104);
954         _createTokenPair(X7103, X7105);
955         _createTokenPair(X7104, X7105);
956 
957         _createETHPair(X7101, newTokenReserves[X7101], newETHReserves[X7101]);
958         _createETHPair(X7102, newTokenReserves[X7102], newETHReserves[X7102]);
959         _createETHPair(X7103, newTokenReserves[X7103], newETHReserves[X7103]);
960         _createETHPair(X7104, newTokenReserves[X7104], newETHReserves[X7104]);
961         _createETHPair(X7105, newTokenReserves[X7105], newETHReserves[X7105]);
962     }
963 
964     function _createETHPair(address tokenAddress, uint256 tokenAmount, uint256 ethAmount) internal {
965         IX7Token token = IX7Token(tokenAddress);
966 
967         address nativePairAddress = factory.getPair(tokenAddress, address(WETH));
968         if (nativePairAddress == address(0)) {
969             nativePairAddress = factory.createPair(tokenAddress, address(WETH));
970         }
971 
972         addLiquidityETH(tokenAddress, tokenAmount, ethAmount);
973         token.setOffRampPair(nativePairAddress);
974     }
975 
976     function _createTokenPair(address tokenAddress, address otherTokenAddress) internal {
977         address v1TokenAddress = oldConstellationTokenLookup[tokenAddress];
978         address v1OtherTokenAddress = oldConstellationTokenLookup[otherTokenAddress];
979 
980         uint256 tokenAmount = oldConstellationNonCirculatingTokenReserve[v1OtherTokenAddress][v1TokenAddress];
981         uint256 otherTokenAmount = oldConstellationNonCirculatingTokenReserve[v1TokenAddress][v1OtherTokenAddress];
982 
983         address pairAddress = factory.getPair(tokenAddress, otherTokenAddress);
984         if (pairAddress == address(0)) {
985             pairAddress = factory.createPair(tokenAddress, otherTokenAddress);
986         }
987 
988         addLiquidity(tokenAddress, tokenAmount, otherTokenAddress, otherTokenAmount);
989     }
990 
991     function _takePairSnapshot(address tokenAddress) internal {
992         address pair = factory.getPair(address(WETH), tokenAddress);
993         uint256 wethBalance;
994 
995         wethBalance = WETH.balanceOf(pair);
996         oldETHReserves[tokenAddress] = wethBalance;
997         totalOldETHReserves += wethBalance;
998 
999         if (isConstellation[tokenAddress]) {
1000             _snapshotConstellationPair(tokenAddress);
1001             totalX7000ETHReserves += wethBalance;
1002         } else {
1003             oldTokenReserves[tokenAddress] = IERC20(tokenAddress).balanceOf(pair);
1004         }
1005     }
1006 
1007     function _takeTokenHolderSnapshot(address tokenAddress) internal {
1008         IERC20 token = IERC20(tokenAddress);
1009         address holder;
1010 
1011         for (uint i=0; i < v1TokenHolders[tokenAddress].length; i++) {
1012             holder = v1TokenHolders[tokenAddress][i];
1013             allowableToMigrate[tokenAddress][holder] = token.balanceOf(holder) + balance[tokenAddress][holder];
1014         }
1015     }
1016 
1017     function _takeSnapshot(address tokenAddress) internal {
1018         if (tokenAddress == X7m105) {
1019             // We are only accounting for burned tokens in the case of X7m105, for simplicity.
1020             oldSupply[X7m105] = 100000000*10**18 - IERC20(X7m105).balanceOf(address(0xdead));
1021         } else if (tokenAddress == X7) {
1022             oldSupply[X7] = 100000000*10**18;
1023         }
1024 
1025         _takeTokenHolderSnapshot(tokenAddress);
1026         _takePairSnapshot(tokenAddress);
1027     }
1028 
1029     function _snapshotConstellationPair(address tokenAddress) internal {
1030         uint256 pairBalance;
1031 
1032         oldTokenReserves[tokenAddress] = IERC20(tokenAddress).balanceOf(factory.getPair(tokenAddress, address(WETH)));
1033 
1034         if (tokenAddress != X7001) {
1035             pairBalance = IX7Token(X7001).balanceOf(factory.getPair(tokenAddress, X7001));
1036             oldConstellationNonCirculatingTokenSupply[X7001] += pairBalance;
1037             oldConstellationNonCirculatingTokenReserve[tokenAddress][X7001] = pairBalance;
1038         }
1039 
1040         if (tokenAddress != X7002) {
1041             pairBalance = IX7Token(X7002).balanceOf(factory.getPair(tokenAddress, X7002));
1042             oldConstellationNonCirculatingTokenSupply[X7002] += pairBalance;
1043             oldConstellationNonCirculatingTokenReserve[tokenAddress][X7002] = pairBalance;
1044         }
1045 
1046         if (tokenAddress != X7003) {
1047             pairBalance = IX7Token(X7003).balanceOf(factory.getPair(tokenAddress, X7003));
1048             oldConstellationNonCirculatingTokenSupply[X7003] += pairBalance;
1049             oldConstellationNonCirculatingTokenReserve[tokenAddress][X7003] = pairBalance;
1050         }
1051 
1052         if (tokenAddress != X7004) {
1053             pairBalance = IX7Token(X7004).balanceOf(factory.getPair(tokenAddress, X7004));
1054             oldConstellationNonCirculatingTokenSupply[X7004] += pairBalance;
1055             oldConstellationNonCirculatingTokenReserve[tokenAddress][X7004] = pairBalance;
1056         }
1057 
1058         if (tokenAddress != X7005) {
1059             pairBalance = IX7Token(X7005).balanceOf(factory.getPair(tokenAddress, X7005));
1060             oldConstellationNonCirculatingTokenSupply[X7005] += pairBalance;
1061             oldConstellationNonCirculatingTokenReserve[tokenAddress][X7005] = pairBalance;
1062         }
1063     }
1064 
1065     function _harvestLiquidity(address tokenAddress) internal {
1066         IERC20 token = IERC20(tokenAddress);
1067         uint256 tokenBalance = token.balanceOf(address(this));
1068         if (tokenBalance > 0) {
1069             swapTokensForEth(tokenAddress, tokenBalance);
1070         }
1071     }
1072 
1073     function _addLiquidity(address v2TokenAddress) internal {
1074         IERC20(v2TokenAddress).approve(address(router), newTokenReserves[v2TokenAddress]);
1075         router.addLiquidityETH{value: newETHReserves[v2TokenAddress]}(
1076             v2TokenAddress,
1077             newTokenReserves[v2TokenAddress],
1078             0,
1079             0,
1080             X7TokenTimelock,
1081             block.timestamp
1082         );
1083     }
1084 
1085     function _resetOwnership(address contractAddress) internal {
1086         require(Ownable(contractAddress).owner() == address(this));
1087         Ownable(contractAddress).transferOwnership(owner());
1088     }
1089 
1090     function addLiquidityETH(address tokenAddress, uint256 tokenAmount, uint256 ethAmount) internal {
1091         IERC20(tokenAddress).approve(address(router), tokenAmount);
1092         router.addLiquidityETH{value: ethAmount}(
1093             tokenAddress,
1094             tokenAmount,
1095             0,
1096             0,
1097             X7TokenTimelock,
1098             block.timestamp
1099         );
1100     }
1101 
1102     function addLiquidity(address tokenAAddress, uint256 tokenAAmount, address tokenBAddress, uint256 tokenBAmount) internal {
1103         IERC20(tokenAAddress).approve(address(router), tokenAAmount);
1104         IERC20(tokenBAddress).approve(address(router), tokenBAmount);
1105         router.addLiquidity(
1106             tokenAAddress,
1107             tokenBAddress,
1108             tokenAAmount,
1109             tokenBAmount,
1110             0,
1111             0,
1112             X7TokenTimelock,
1113             block.timestamp
1114         );
1115     }
1116 
1117     function swapTokensForEth(address tokenAddress, uint256 tokenAmount) internal {
1118         if (tokenAmount == 0) {
1119             return;
1120         }
1121 
1122         address[] memory path = new address[](2);
1123         path[0] = tokenAddress;
1124         path[1] = address(WETH);
1125 
1126         IERC20(tokenAddress).approve(address(router), tokenAmount);
1127         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1128             tokenAmount,
1129             0,
1130             path,
1131             address(this),
1132             block.timestamp
1133         );
1134     }
1135 
1136     function _setupTokens() internal {
1137         _setupToken(X7DAOv2);
1138         _setupToken(X7R);
1139         _setupToken(X7101);
1140         _setupToken(X7102);
1141         _setupToken(X7103);
1142         _setupToken(X7104);
1143         _setupToken(X7105);
1144     }
1145 
1146     function _setupToken(address tokenAddress) internal {
1147         address pair;
1148         IX7Token token = IX7Token(tokenAddress);
1149         pair = factory.getPair(address(WETH), tokenAddress);
1150 
1151         if (tokenAddress == X7DAOv2) {
1152             X7DAOLiquidityHub.setOffRampPair(pair);
1153         } else if (tokenAddress == X7R) {
1154             X7RLiquidityHub.setOffRampPair(pair);
1155         } else {
1156             X7100LiquidityHub.setOffRampPair(tokenAddress, pair);
1157             X7100LiquidityHub.setConstellationToken(tokenAddress, true);
1158         }
1159 
1160         token.setAMM(pair, true);
1161         token.setOffRampPair(pair);
1162     }
1163 
1164     function _airdropMigrationTokens(address v1TokenAddress, address v2TokenAddress, uint256 startIndex, uint256 endIndex) internal {
1165         uint256 numerator = newTokenReserves[v2TokenAddress] * oldETHReserves[v1TokenAddress];
1166         uint256 denominator = oldTokenReserves[v1TokenAddress] * newETHReserves[v2TokenAddress];
1167 
1168         uint256 airdropAmount;
1169         uint256 migrationBalance;
1170         address holder;
1171 
1172         IERC20 v2Token = IERC20(v2TokenAddress);
1173 
1174         if (startIndex >= v1TokenHolders[v1TokenAddress].length) {
1175             return;
1176         }
1177 
1178         uint256 stopIndex;
1179         if (endIndex == 0) {
1180             stopIndex = v1TokenHolders[v1TokenAddress].length;
1181         } else if (v1TokenHolders[v1TokenAddress].length <= endIndex) {
1182             stopIndex = v1TokenHolders[v1TokenAddress].length;
1183         } else {
1184             stopIndex = endIndex;
1185         }
1186 
1187         require(startIndex < stopIndex);
1188 
1189         for (uint i=startIndex; i < stopIndex; i++) {
1190             holder = v1TokenHolders[v1TokenAddress][i];
1191             migrationBalance = balance[v1TokenAddress][holder];
1192 
1193             // A holder must have migrated >= 1000 tokens to be airdropped their tokens.
1194             // Their tokens may still be migrated manually
1195             if (migrationBalance < 1000 * 10**18) {
1196                 continue;
1197             }
1198 
1199             airdropAmount = migrationBalance * numerator / denominator / 10**14 * 10**14;
1200 
1201             // If the airdrop amount becomes 0 due to rounding/truncation then I recommend
1202             // a holder register a formal complaint with a community authority to be
1203             // compensated for their finney. We do not however decrement their balance in
1204             // this case in the event they have eligible tokens that can be added.
1205             if (airdropAmount == 0) {
1206                 continue;
1207             }
1208 
1209             balance[v1TokenAddress][holder] = 0;
1210             migrated[v1TokenAddress][holder] += migrationBalance;
1211             v2Received[v2TokenAddress][holder] += airdropAmount;
1212             v2Token.transfer(holder, airdropAmount);
1213         }
1214     }
1215 
1216 }