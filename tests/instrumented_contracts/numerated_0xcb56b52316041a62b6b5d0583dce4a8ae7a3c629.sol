1 // SPDX-License-Identifier: MIT
2 // SYS 64738
3 // Version 2.0
4 // Author: 0xTycoon
5 // Contributor: Alphasoup <twitter: alphasoups>
6 // Special Thanks: straybits1, cryptopunkart, cyounessi1, ethereumdegen, Punk7572, sherone.eth,
7 //                 songadaymann, Redlioneye.eth, tw1tte7, PabloPunkasso, Kaprekar_Punk, aradtski,
8 //                 phantom_scribbs, Cryptopapa.eth, johnhenderson, thekriskay, PerfectoidPeter,
9 //                 uxt_exe, 0xUnicorn, dansickles.eth, Blon Dee#9649, VRPunk1, Don Seven Slices, hogo.eth,
10 //                 GeoCities#5700, "HP OfficeJet Pro 9015e #2676", gigiuz#0061, danpolko.eth, mariano.eth,
11 //                 0xfoobar, jakerockland, Mudit__Gupta, BokkyPooBah, 0xaaby.eth, and
12 //                 everyone at the discord, and all the awesome people who gave feedback for this project!
13 // Greetings to:   Punk3395, foxthepunk, bushleaf.eth, 570KylΞ.eth, bushleaf.eth, Tokyolife, Joshuad.eth (1641),
14 //                 markchesler_coinwitch, decideus.eth, zachologylol, punk8886, jony_bee, nfttank, DolAtoR, punk8886
15 //                 DonJon.eth, kilifibaobab, joked507, cryptoed#3040, DroScott#7162, 0xAllen.eth, Tschuuuly#5158,
16 //                 MetasNomadic#0349, punk8653, NittyB, heygareth.eth, Aaru.eth, robertclarke.eth, Acmonides#6299,
17 //                 Gustavus99 (1871), Foobazzler
18 // Repo: github.com/0xTycoon/punksceo
19 
20 pragma solidity ^0.8.11;
21 
22 //import "./safemath.sol"; // don't need since v0.8
23 //import "./ceo.sol";
24 //import "hardhat/console.sol";
25 /*
26 
27 PUNKS CEO (and "Cigarette" token)
28 WEB: https://punksceo.eth.limo / https://punksceo.eth.link
29 IPFS: See content hash record for punksceo.eth
30 Token Address: cigtoken.eth
31 
32          , - ~ ~ ~ - ,
33      , '               ' ,
34    ,                    🚬  ,
35   ,                     🚬   ,
36  ,                      🚬    ,
37  ,                      🚬    ,
38  ,         =============     ,
39   ,                   ||█   ,
40    ,       =============   ,
41      ,                  , '
42        ' - , _ _ _ ,  '
43 
44 
45 ### THE RULES OF THE GAME
46 
47 1. Anybody can buy the CEO title at any time using Cigarettes. (The CEO of all cryptopunks)
48 2. When buying the CEO title, you must nominate a punk, set the price and pre-pay the tax.
49 3. The CEO title can be bought from the existing CEO at any time.
50 4. To remain a CEO, a daily tax needs to be paid.
51 5. The tax is 0.1% of the price to buy the CEO title, to be charged per epoch.
52 6. The CEO can be removed if they fail to pay the tax. A reward of CIGs is paid to the whistleblower.
53 7. After Removing a CEO: A dutch auction is held, where the price will decrease 10% every half-an-epoch.
54 8. The price can be changed by the CEO at any time. (Once per block)
55 9. An epoch is 7200 blocks.
56 10. All the Cigarettes from the sale are burned.
57 11. All tax is burned
58 12. After buying the CEO title, the old CEO will get their unspent tax deposit refunded
59 
60 ### CEO perk
61 
62 13. The CEO can increase or decrease the CIG farming block reward by 20% every 2nd epoch!
63 However, note that the issuance can never be more than 1000 CIG per block, also never under 0.0001 CIG.
64 14. THE CEO gets to hold a NFT in their wallet. There will only be ever 1 this NFT.
65 The purpose of this NFT is so that everyone can see that they are the CEO.
66 IMPORTANT: This NFT will be revoked once the CEO title changes.
67 Also, the NFT cannot be transferred by the owner, the only way to transfer is for someone else to buy the CEO title! (Think of this NFT as similar to a "title belt" in boxing.)
68 
69 END
70 
71 * states
72 * 0 = initial
73 * 1 = CEO reigning
74 * 2 = Dutch auction
75 * 3 = Migration
76 
77 Notes:
78 It was decided that whoever buys the CEO title does not have to hold a punk and can nominate any punk they wish.
79 This is because some may hold their punks in cold storage, plus checking ownership costs additional gas.
80 Besides, CEOs are usually appointed by the board.
81 
82 Credits:
83 - LP Staking based on code from SushiSwap's MasterChef.sol
84 - ERC20 & SafeMath based on lib from OpenZeppelin
85 
86 */
87 
88 contract Cig {
89     //using SafeMath for uint256; // no need since Solidity 0.8
90     string public constant name = "Cigarette Token";
91     string public constant symbol = "CIG";
92     uint8 public constant decimals = 18;
93     uint256 public totalSupply = 0;
94     mapping(address => uint256) public balanceOf;
95     mapping(address => mapping(address => uint256)) public allowance;
96     event Transfer(address indexed from, address indexed to, uint256 value);
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98     // UserInfo keeps track of user LP deposits and withdrawals
99     struct UserInfo {
100         uint256 deposit;    // How many LP tokens the user has deposited.
101         uint256 rewardDebt; // keeps track of how much reward was paid out
102     }
103     mapping(address => UserInfo) public farmers;  // keeps track of UserInfo for each staking address with own pool
104     mapping(address => UserInfo) public farmersMasterchef;  // keeps track of UserInfo for each staking address with masterchef pool
105     mapping(address => uint256) public wBal;      // keeps tracked of wrapped old cig
106     address public admin;                         // admin is used for deployment, burned after
107     ILiquidityPoolERC20 public lpToken;           // lpToken is the address of LP token contract that's being staked.
108     uint256 public lastRewardBlock;               // Last block number that cigarettes distribution occurs.
109     uint256 public accCigPerShare;                // Accumulated cigarettes per share, times 1e12. See below.
110     uint256 public masterchefDeposits;            // How much has been deposited onto the masterchef contract
111     uint256 public cigPerBlock;                   // CIGs per-block rewarded and split with LPs
112     bytes32 public graffiti;                      // a 32 character graffiti set when buying a CEO
113     ICryptoPunk public punks;                     // a reference to the CryptoPunks contract
114     event Deposit(address indexed user, uint256 amount);           // when depositing LP tokens to stake
115     event Harvest(address indexed user, address to, uint256 amount);// when withdrawing LP tokens form staking
116     event Withdraw(address indexed user, uint256 amount); // when withdrawing LP tokens, no rewards claimed
117     event EmergencyWithdraw(address indexed user, uint256 amount); // when withdrawing LP tokens, no rewards claimed
118     event ChefDeposit(address indexed user, uint256 amount);       // when depositing LP tokens to stake
119     event ChefWithdraw(address indexed user, uint256 amount);      // when withdrawing LP tokens, no rewards claimed
120     event RewardUp(uint256 reward, uint256 upAmount);              // when cigPerBlock is increased
121     event RewardDown(uint256 reward, uint256 downAmount);          // when cigPerBlock is decreased
122     event Claim(address indexed owner, uint indexed punkIndex, uint256 value); // when a punk is claimed
123     mapping(uint => bool) public claims;                           // keep track of claimed punks
124     modifier onlyAdmin {
125         require(
126             msg.sender == admin,
127             "Only admin can call this"
128         );
129         _;
130     }
131     uint256 constant MIN_PRICE = 1e12;            // 0.000001 CIG
132     uint256 constant CLAIM_AMOUNT = 100000 ether; // claim amount for each punk
133     uint256 constant MIN_REWARD = 1e14;           // minimum block reward of 0.0001 CIG (1e14 wei)
134     uint256 constant MAX_REWARD = 1000 ether;     // maximum block reward of 1000 CIG
135     uint256 constant STARTING_REWARDS = 512 ether;// starting rewards at end of migration
136     address public The_CEO;                       // address of CEO
137     uint public CEO_punk_index;                   // which punk id the CEO is using
138     uint256 public CEO_price = 50000 ether;       // price to buy the CEO title
139     uint256 public CEO_state;                     // state has 3 states, described above.
140     uint256 public CEO_tax_balance;               // deposit to be used to pay the CEO tax
141     uint256 public taxBurnBlock;                  // The last block when the tax was burned
142     uint256 public rewardsChangedBlock;           // which block was the last reward increase / decrease
143     uint256 private immutable CEO_epoch_blocks;   // secs per day divided by 12 (86400 / 12), assuming 12 sec blocks
144     uint256 private immutable CEO_auction_blocks; // 3600 blocks
145     // NewCEO 0x09b306c6ea47db16bdf4cc36f3ea2479af494cd04b4361b6485d70f088658b7e
146     event NewCEO(address indexed user, uint indexed punk_id, uint256 new_price, bytes32 graffiti); // when a CEO is bought
147     // TaxDeposit 0x2ab3b3b53aa29a0599c58f343221e29a032103d015c988fae9a5cdfa5c005d9d
148     event TaxDeposit(address indexed user,  uint256 amount);                               // when tax is deposited
149     // RevenueBurned 0x1b1be00a9ca19f9c14f1ca5d16e4aba7d4dd173c2263d4d8a03484e1c652c898
150     event RevenueBurned(address indexed user,  uint256 amount);                            // when tax is burned
151     // TaxBurned 0x9ad3c710e1cc4e96240264e5d3cd5aeaa93fd8bd6ee4b11bc9be7a5036a80585
152     event TaxBurned(address indexed user,  uint256 amount);                                // when tax is burned
153     // CEODefaulted b69f2aeff650d440d3e7385aedf764195cfca9509e33b69e69f8c77cab1e1af1
154     event CEODefaulted(address indexed called_by,  uint256 reward);                        // when CEO defaulted on tax
155     // CEOPriceChange 0x10c342a321267613a25f77d4273d7f2688bef174a7214bc3dde44b31c5064ff6
156     event CEOPriceChange(uint256 price);                                                   // when CEO changed price
157     modifier onlyCEO {
158         require(
159             msg.sender == The_CEO,
160             "only CEO can call this"
161         );
162         _;
163     }
164     IRouterV2 private immutable V2ROUTER;    // address of router used to get the price quote
165     ICEOERC721 private immutable The_NFT;    // reference to the CEO NFT token
166     address private immutable MASTERCHEF_V2; // address pointing to SushiSwap's MasterChefv2 contract
167     IOldCigtoken private immutable OC;       // Old Contract
168     /**
169     * @dev constructor
170     * @param _cigPerBlock Number of CIG tokens rewarded per block
171     * @param _punks address of the cryptopunks contract
172     * @param _CEO_epoch_blocks how many blocks between each epochs
173     * @param _CEO_auction_blocks how many blocks between each auction discount
174     * @param _CEO_price starting price to become CEO (in CIG)
175     * @param _graffiti bytes32 initial graffiti message
176     * @param _NFT address pointing to the NFT contract
177     * @param _V2ROUTER address pointing to the SushiSwap router
178     * @param _OC address pointing to the original Cig Token contract
179     * @param _MASTERCHEF_V2 address for the sushi masterchef v2 contract
180     */
181     constructor(
182         uint256 _cigPerBlock,
183         address _punks,
184         uint _CEO_epoch_blocks,
185         uint _CEO_auction_blocks,
186         uint256 _CEO_price,
187         bytes32 _graffiti,
188         address _NFT,
189         address _V2ROUTER,
190         address _OC,
191         uint256 _migration_epochs,
192         address _MASTERCHEF_V2
193     ) {
194         cigPerBlock        = _cigPerBlock;
195         admin              = msg.sender;             // the admin key will be burned after deployment
196         punks              = ICryptoPunk(_punks);
197         CEO_epoch_blocks   = _CEO_epoch_blocks;
198         CEO_auction_blocks = _CEO_auction_blocks;
199         CEO_price          = _CEO_price;
200         graffiti           = _graffiti;
201         The_NFT            = ICEOERC721(_NFT);
202         V2ROUTER           = IRouterV2(_V2ROUTER);
203         OC                 = IOldCigtoken(_OC);
204         lastRewardBlock =
205             block.number + (CEO_epoch_blocks * _migration_epochs); // set the migration window end
206         MASTERCHEF_V2 = _MASTERCHEF_V2;
207         CEO_state = 3;                               // begin in migration state
208     }
209 
210     /**
211     * @dev buyCEO allows anybody to be the CEO
212     * @param _max_spend the total CIG that can be spent
213     * @param _new_price the new price for the punk (in CIG)
214     * @param _tax_amount how much to pay in advance (in CIG)
215     * @param _punk_index the id of the punk 0-9999
216     * @param _graffiti a little message / ad from the buyer
217     */
218     function buyCEO(
219         uint256 _max_spend,
220         uint256 _new_price,
221         uint256 _tax_amount,
222         uint256 _punk_index,
223         bytes32 _graffiti
224     ) external  {
225         require (CEO_state != 3); // disabled in in migration state
226         if (CEO_state == 1 && (taxBurnBlock != block.number)) {
227             _burnTax();                                                    // _burnTax can change CEO_state to 2
228         }
229         if (CEO_state == 2) {
230             // Auction state. The price goes down 10% every `CEO_auction_blocks` blocks
231             CEO_price = _calcDiscount();
232         }
233         require (CEO_price + _tax_amount <= _max_spend, "overpaid");       // prevent CEO over-payment
234         require (_new_price >= MIN_PRICE, "price 2 smol");                 // price cannot be under 0.000001 CIG
235         require (_punk_index <= 9999, "invalid punk");                     // validate the punk index
236         require (_tax_amount >= _new_price / 1000, "insufficient tax" );   // at least %0.1 fee paid for 1 epoch
237         transfer(address(this), CEO_price);                                // pay for the CEO title
238         _burn(address(this), CEO_price);                                   // burn the revenue
239         emit RevenueBurned(msg.sender, CEO_price);
240         _returnDeposit(The_CEO, CEO_tax_balance);                          // return deposited tax back to old CEO
241         transfer(address(this), _tax_amount);                              // deposit tax (reverts if not enough)
242         CEO_tax_balance = _tax_amount;                                     // store the tax deposit amount
243         _transferNFT(The_CEO, msg.sender);                                 // yank the NFT to the new CEO
244         CEO_price = _new_price;                                            // set the new price
245         CEO_punk_index = _punk_index;                                      // store the punk id
246         The_CEO = msg.sender;                                              // store the CEO's address
247         taxBurnBlock = block.number;                                       // store the block number
248         // (tax may not have been burned if the
249         // previous state was 0)
250         CEO_state = 1;
251         graffiti = _graffiti;
252         emit TaxDeposit(msg.sender, _tax_amount);
253         emit NewCEO(msg.sender, _punk_index, _new_price, _graffiti);
254     }
255 
256     /**
257     * @dev _returnDeposit returns the tax deposit back to the CEO
258     * @param _to address The address which you want to transfer to
259     * remember to update CEO_tax_balance after calling this
260     */
261     function _returnDeposit(
262         address _to,
263         uint256 _amount
264     )
265     internal
266     {
267         if (_amount == 0) {
268             return;
269         }
270         balanceOf[address(this)] = balanceOf[address(this)] - _amount;
271         balanceOf[_to] = balanceOf[_to] + _amount;
272         emit Transfer(address(this), _to, _amount);
273         //CEO_tax_balance = 0; // can be omitted since value gets overwritten by caller
274     }
275 
276     /**
277     * @dev transfer the NFT to a new wallet
278     */
279     function _transferNFT(address _oldCEO, address _newCEO) internal {
280         The_NFT.transferFrom(_oldCEO, _newCEO, 0);
281     }
282 
283     /**
284     * @dev depositTax pre-pays tax for the existing CEO.
285     * It may also burn any tax debt the CEO may have.
286     * @param _amount amount of tax to pre-pay
287     */
288     function depositTax(uint256 _amount) external onlyCEO {
289         require (CEO_state == 1, "no CEO");
290         if (_amount > 0) {
291             transfer(address(this), _amount);                   // place the tax on deposit
292             CEO_tax_balance = CEO_tax_balance + _amount;        // record the balance
293             emit TaxDeposit(msg.sender, _amount);
294         }
295         if (taxBurnBlock != block.number) {
296             _burnTax();                                         // settle any tax debt
297             taxBurnBlock = block.number;
298         }
299     }
300 
301     /**
302     * @dev burnTax is called to burn tax.
303     * It removes the CEO if tax is unpaid.
304     * 1. deduct tax, update last update
305     * 2. if not enough tax, remove & begin auction
306     * 3. reward the caller by minting a reward from the amount indebted
307     * A Dutch auction begins where the price decreases 10% every hour.
308     */
309 
310     function burnTax() external  {
311         if (taxBurnBlock == block.number) return;
312         if (CEO_state == 1) {
313             _burnTax();
314             taxBurnBlock = block.number;
315         }
316     }
317 
318     /**
319     * @dev _burnTax burns any tax debt. Boots the CEO if defaulted, paying a reward to the caller
320     */
321     function _burnTax() internal {
322         // calculate tax per block (tpb)
323         uint256 tpb = CEO_price / 1000 / CEO_epoch_blocks;       // 0.1% per epoch
324         uint256 debt = (block.number - taxBurnBlock) * tpb;
325         if (CEO_tax_balance !=0 && CEO_tax_balance >= debt) {    // Does CEO have enough deposit to pay debt?
326             CEO_tax_balance = CEO_tax_balance - debt;            // deduct tax
327             _burn(address(this), debt);                          // burn the tax
328             emit TaxBurned(msg.sender, debt);
329         } else {
330             // CEO defaulted
331             uint256 default_amount = debt - CEO_tax_balance;     // calculate how much defaulted
332             _burn(address(this), CEO_tax_balance);               // burn the tax
333             emit TaxBurned(msg.sender, CEO_tax_balance);
334             CEO_state = 2;                                       // initiate a Dutch auction.
335             CEO_tax_balance = 0;
336             _transferNFT(The_CEO, address(this));                // This contract holds the NFT temporarily
337             The_CEO = address(this);                             // This contract is the "interim CEO"
338             _mint(msg.sender, default_amount);                   // reward the caller for reporting tax default
339             emit CEODefaulted(msg.sender, default_amount);
340         }
341     }
342 
343     /**
344      * @dev setPrice changes the price for the CEO title.
345      * @param _price the price to be paid. The new price most be larger tan MIN_PRICE and not default on debt
346      */
347     function setPrice(uint256 _price) external onlyCEO  {
348         require(CEO_state == 1, "No CEO in charge");
349         require (_price >= MIN_PRICE, "price 2 smol");
350         require (CEO_tax_balance >= _price / 1000, "price would default"); // need at least 0.1% for tax
351         if (block.number != taxBurnBlock) {
352             _burnTax();
353             taxBurnBlock = block.number;
354         }
355         // The state is 1 if the CEO hasn't defaulted on tax
356         if (CEO_state == 1) {
357             CEO_price = _price;                                   // set the new price
358             emit CEOPriceChange(_price);
359         }
360     }
361 
362     /**
363     * @dev rewardUp allows the CEO to increase the block rewards by %20
364     * Can only be called by the CEO every 2 epochs
365     * @return _amount increased by
366     */
367     function rewardUp() external onlyCEO returns (uint256)  {
368         require(CEO_state == 1, "No CEO in charge");
369         require(block.number > rewardsChangedBlock + (CEO_epoch_blocks*2), "wait more blocks");
370         require (cigPerBlock < MAX_REWARD, "reward already max");
371         rewardsChangedBlock = block.number;
372         uint256 _amount = cigPerBlock / 5;            // %20
373         uint256 _new_reward = cigPerBlock + _amount;
374         if (_new_reward > MAX_REWARD) {
375             _amount = MAX_REWARD - cigPerBlock;
376             _new_reward = MAX_REWARD;                 // cap
377         }
378         cigPerBlock = _new_reward;
379         emit RewardUp(_new_reward, _amount);
380         return _amount;
381     }
382 
383     /**
384     * @dev rewardDown decreases the block rewards by 20%
385     * Can only be called by the CEO every 2 epochs
386     */
387     function rewardDown() external onlyCEO returns (uint256) {
388         require(CEO_state == 1, "No CEO in charge");
389         require(block.number > rewardsChangedBlock + (CEO_epoch_blocks*2), "wait more blocks");
390         require(cigPerBlock > MIN_REWARD, "reward already low");
391         rewardsChangedBlock = block.number;
392         uint256 _amount = cigPerBlock / 5;            // %20
393         uint256 _new_reward = cigPerBlock - _amount;
394         if (_new_reward < MIN_REWARD) {
395             _amount = cigPerBlock - MIN_REWARD;
396             _new_reward = MIN_REWARD;                 // limit
397         }
398         cigPerBlock = _new_reward;
399         emit RewardDown(_new_reward, _amount);
400         return _amount;
401     }
402 
403     /**
404     * @dev _calcDiscount calculates the discount for the CEO title based on how many blocks passed
405     */
406     function _calcDiscount() internal view returns (uint256) {
407         unchecked {
408             uint256 d = (CEO_price / 10)           // 10% discount
409             // multiply by the number of discounts accrued
410             * ((block.number - taxBurnBlock) / CEO_auction_blocks);
411             if (d > CEO_price) {
412                 // overflow assumed, reset to MIN_PRICE
413                 return MIN_PRICE;
414             }
415             uint256 price = CEO_price - d;
416             if (price < MIN_PRICE) {
417                 price = MIN_PRICE;
418             }
419             return price;
420         }
421     }
422 
423     /*
424     * 🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬 Information used by the UI 🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬
425     */
426 
427     /**
428     * @dev getStats helps to fetch some stats for the GUI in a single web3 call
429     * @param _user the address to return the report for
430     * @return uint256[27] the stats
431     * @return address of the current CEO
432     * @return bytes32 Current graffiti
433     */
434     function getStats(address _user) external view returns(uint256[] memory, address, bytes32, uint112[] memory) {
435         uint[] memory ret = new uint[](27);
436         uint112[] memory reserves = new uint112[](2);
437         uint256 tpb = (CEO_price / 1000) / (CEO_epoch_blocks); // 0.1% per epoch
438         uint256 debt = (block.number - taxBurnBlock) * tpb;
439         uint256 price = CEO_price;
440         UserInfo memory info = farmers[_user];
441         if (CEO_state == 2) {
442             price = _calcDiscount();
443         }
444         ret[0] = CEO_state;
445         ret[1] = CEO_tax_balance;
446         ret[2] = taxBurnBlock;                     // the block number last tax burn
447         ret[3] = rewardsChangedBlock;              // the block of the last staking rewards change
448         ret[4] = price;                            // price of the CEO title
449         ret[5] = CEO_punk_index;                   // punk ID of CEO
450         ret[6] = cigPerBlock;                      // staking reward per block
451         ret[7] = totalSupply;                      // total supply of CIG
452         if (address(lpToken) != address(0)) {
453             ret[8] = lpToken.balanceOf(address(this)); // Total LP staking
454             ret[16] = lpToken.balanceOf(_user);        // not staked by user
455             ret[17] = pendingCig(_user);               // pending harvest
456             (reserves[0], reserves[1], ) = lpToken.getReserves();        // uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast
457             ret[18] = V2ROUTER.getAmountOut(1 ether, uint(reserves[0]), uint(reserves[1])); // CIG price in ETH
458             if (isContract(address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2))) { // are we on mainnet?
459                 ILiquidityPoolERC20 ethusd = ILiquidityPoolERC20(address(0xC3D03e4F041Fd4cD388c549Ee2A29a9E5075882f));  // sushi DAI-WETH pool
460                 uint112 r0;
461                 uint112 r1;
462                 (r0, r1, ) = ethusd.getReserves();
463                 // get the price of ETH in USD
464                 ret[19] =  V2ROUTER.getAmountOut(1 ether, uint(r0), uint(r1));      // ETH price in USD
465             }
466             ret[22] = lpToken.totalSupply();       // total supply
467         }
468         ret[9] = block.number;                       // current block number
469         ret[10] = tpb;                               // "tax per block" (tpb)
470         ret[11] = debt;                              // tax debt accrued
471         ret[12] = lastRewardBlock;                   // the block of the last staking rewards payout update
472         ret[13] = info.deposit;                      // amount of LP tokens staked by user
473         ret[14] = info.rewardDebt;                   // amount of rewards paid out
474         ret[15] = balanceOf[_user];                  // amount of CIG held by user
475         ret[20] = accCigPerShare;                    // Accumulated cigarettes per share
476         ret[21] = balanceOf[address(punks)];         // amount of CIG to be claimed
477         ret[23] = wBal[_user];                       // wrapped cig balance
478         ret[24] = OC.balanceOf(_user);               // balance of old cig in old isContract
479         ret[25] = OC.allowance(_user, address(this));// is old contract approved
480         (ret[26], ) = OC.userInfo(_user);            // old contract stake bal
481         return (ret, The_CEO, graffiti, reserves);
482     }
483 
484     /**
485      * @dev Returns true if `account` is a contract.
486      *
487      * credits https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
488      */
489     function isContract(address account) internal view returns (bool) {
490         uint256 size;
491         assembly {
492             size := extcodesize(account)
493         }
494         return size > 0;
495     }
496 
497     /*
498     * 🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬 Token distribution and farming stuff 🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬
499     */
500 
501     /**
502     * @dev isClaimed checks to see if a punk was claimed
503     * @param _punkIndex the punk number
504     */
505     function isClaimed(uint256 _punkIndex) external view returns (bool) {
506         if (claims[_punkIndex]) {
507             return true;
508         }
509         if (OC.claims(_punkIndex)) {
510             return true;
511         }
512         return false;
513     }
514 
515     /**
516     * Claim claims the initial CIG airdrop using a punk
517     * @param _punkIndex the index of the punk, number between 0-9999
518     */
519     function claim(uint256 _punkIndex) external returns(bool) {
520         require (CEO_state != 3, "invalid state");                            // disabled in migration state
521         require (_punkIndex <= 9999, "invalid punk");
522         require(claims[_punkIndex] == false, "punk already claimed");
523         require(OC.claims(_punkIndex) == false, "punk already claimed");      // claimed in old contract
524         require(msg.sender == punks.punkIndexToAddress(_punkIndex), "punk 404");
525         claims[_punkIndex] = true;
526         balanceOf[address(punks)] = balanceOf[address(punks)] - CLAIM_AMOUNT; // deduct from the punks contract
527         balanceOf[msg.sender] = balanceOf[msg.sender] + CLAIM_AMOUNT;         // deposit to the caller
528         emit Transfer(address(punks), msg.sender, CLAIM_AMOUNT);
529         emit Claim(msg.sender, _punkIndex, CLAIM_AMOUNT);
530         return true;
531     }
532 
533     /**
534     * @dev Gets the LP supply, with masterchef deposits taken into account.
535     */
536     function stakedlpSupply() public view returns(uint256)
537     {
538         return lpToken.balanceOf(address(this)) + masterchefDeposits;
539     }
540     /**
541     * @dev update updates the accCigPerShare value and mints new CIG rewards to be distributed to LP stakers
542     * Credits go to MasterChef.sol
543     * Modified the original by removing poolInfo as there is only a single pool
544     * Removed totalAllocPoint and pool.allocPoint
545     * pool.lastRewardBlock moved to lastRewardBlock
546     * There is no need for getMultiplier (rewards are adjusted by the CEO)
547     *
548     */
549     function update() public {
550         if (block.number <= lastRewardBlock) {
551             return;
552         }
553         uint256 supply = stakedlpSupply();
554         if (supply == 0) {
555             lastRewardBlock = block.number;
556             return;
557         }
558         // mint some new cigarette rewards to be distributed
559         uint256 cigReward = (block.number - lastRewardBlock) * cigPerBlock;
560         _mint(address(this), cigReward);
561         accCigPerShare = accCigPerShare + (
562         cigReward * 1e12 / supply
563         );
564         lastRewardBlock = block.number;
565     }
566 
567     /**
568     * @dev pendingCig displays the amount of cig to be claimed
569     * @param _user the address to report
570     */
571     function pendingCig(address _user) view public returns (uint256) {
572         uint256 _acps = accCigPerShare;
573         // accumulated cig per share
574         UserInfo storage user = farmers[_user];
575         uint256 supply = stakedlpSupply();
576         if (block.number > lastRewardBlock && supply != 0) {
577             uint256 cigReward = (block.number - lastRewardBlock) * cigPerBlock;
578             _acps = _acps + (
579             cigReward * 1e12 / supply
580             );
581         }
582         return (user.deposit * _acps / 1e12) - user.rewardDebt;
583     }
584 
585 
586     /**
587     * @dev userInfo is added for compatibility with the Snapshot.org interface.
588     */
589     function userInfo(uint256, address _user) view external returns (uint256, uint256 depositAmount) {
590         return (0,farmers[_user].deposit + farmersMasterchef[_user].deposit);
591     }
592     /**
593     * @dev deposit deposits LP tokens to be staked.
594     * @param _amount the amount of LP tokens to deposit. Assumes this contract has been approved for the _amount.
595     */
596     function deposit(uint256 _amount) external {
597         require(_amount != 0, "You cannot deposit only 0 tokens"); // Check how many bytes
598         UserInfo storage user = farmers[msg.sender];
599 
600         update();
601         _deposit(user, _amount);
602         require(lpToken.transferFrom(
603                 address(msg.sender),
604                 address(this),
605                 _amount
606             ));
607         emit Deposit(msg.sender, _amount);
608     }
609     
610     function _deposit(UserInfo storage _user, uint256 _amount) internal {
611         _user.deposit += _amount;
612         _user.rewardDebt += _amount * accCigPerShare / 1e12;
613     }
614     /**
615     * @dev withdraw takes out the LP tokens
616     * @param _amount the amount to withdraw
617     */
618     function withdraw(uint256 _amount) external {
619         UserInfo storage user = farmers[msg.sender];
620         update();
621         /* harvest beforehand, so _withdraw can safely decrement their reward count */
622         _harvest(user, msg.sender);
623         _withdraw(user, _amount);
624         /* Interact */
625         require(lpToken.transferFrom(
626             address(this),
627             address(msg.sender),
628             _amount
629         ));
630         emit Withdraw(msg.sender, _amount);
631     }
632     
633     /**
634     * @dev Internal withdraw, updates internal accounting after withdrawing LP
635     * @param _amount to subtract
636     */
637     function _withdraw(UserInfo storage _user, uint256 _amount) internal {
638         require(_user.deposit >= _amount, "Balance is too low");
639         _user.deposit -= _amount;
640         uint256 _rewardAmount = _amount * accCigPerShare / 1e12;
641         _user.rewardDebt -= _rewardAmount;
642     }
643 
644     /**
645     * @dev harvest redeems pending rewards & updates state
646     */
647     function harvest() external {
648         UserInfo storage user = farmers[msg.sender];
649         update();
650         _harvest(user, msg.sender);
651     }
652 
653     /**
654     * @dev Internal harvest
655     * @param _to the amount to harvest
656     */
657     function _harvest(UserInfo storage _user, address _to) internal {
658         uint256 potentialValue = (_user.deposit * accCigPerShare / 1e12);
659         uint256 delta = potentialValue - _user.rewardDebt;
660         safeSendPayout(_to, delta);
661         // Recalculate their reward debt now that we've given them their reward
662         _user.rewardDebt = _user.deposit * accCigPerShare / 1e12;
663         emit Harvest(msg.sender, _to, delta);
664     }
665 
666     /**
667     * @dev safeSendPayout, just in case if rounding error causes pool to not have enough CIGs.
668     * @param _to recipient address
669     * @param _amount the value to send
670     */
671     function safeSendPayout(address _to, uint256 _amount) internal {
672         uint256 cigBal = balanceOf[address(this)];
673         require(cigBal >= _amount, "insert more tobacco leaves...");
674         unchecked {
675             balanceOf[address(this)] = balanceOf[address(this)] - _amount;
676             balanceOf[_to] = balanceOf[_to] + _amount;
677         }
678         emit Transfer(address(this), _to, _amount);
679     }
680 
681     /**
682     * @dev emergencyWithdraw does a withdraw without caring about rewards. EMERGENCY ONLY.
683     */
684     function emergencyWithdraw() external {
685         UserInfo storage user = farmers[msg.sender];
686         uint256 amount = user.deposit;
687         user.deposit = 0;
688         user.rewardDebt = 0;
689         // Interact
690         require(lpToken.transfer(
691                 address(msg.sender),
692                 amount
693             ));
694         emit EmergencyWithdraw(msg.sender, amount);
695     }
696 
697     /*
698     * 🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬 Migration 🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬
699     */
700 
701     /**
702     * @dev renounceOwnership burns the admin key, so this contract is unruggable
703     */
704     function renounceOwnership() external onlyAdmin {
705         admin = address(0);
706     }
707 
708     /**
709     * @dev setStartingBlock sets the starting block for LP staking rewards
710     * Admin only, used only for initial configuration.
711     * @param _startBlock the block to start rewards for
712     */
713     function setStartingBlock(uint256 _startBlock) external onlyAdmin {
714         lastRewardBlock = _startBlock;
715     }
716 
717     /**
718     * @dev setPool address to an LP pool. Only Admin. (used only in testing/deployment)
719     */
720     function setPool(ILiquidityPoolERC20 _addr) external onlyAdmin {
721         require(address(lpToken) == address(0), "pool already set");
722         lpToken = _addr;
723     }
724 
725     /**
726     * @dev setReward sets the reward. Admin only (used only in testing/deployment)
727     */
728     function setReward(uint256 _value) public onlyAdmin {
729         cigPerBlock = _value;
730     }
731 
732     /**
733     * @dev migrationComplete completes the migration
734     */
735     function migrationComplete() external  {
736         require (CEO_state == 3);
737         require (OC.CEO_state() == 1);
738         require (block.number > lastRewardBlock, "cannot end migration yet");
739         CEO_state = 1;                         // CEO is in charge state
740         OC.burnTax();                          // before copy, burn the old CEO's tax
741         /* copy the state over to this contract */
742         _mint(address(punks), OC.balanceOf(address(punks))); // CIG to be set aside for the remaining airdrop
743         uint256 taxDeposit = OC.CEO_tax_balance();
744         The_CEO = OC.The_CEO();                // copy the CEO
745         if (taxDeposit > 0) {                  // copy the CEO's outstanding tax
746             _mint(address(this), taxDeposit);  // mint tax that CEO had locked in previous contract (cannot be migrated)
747             CEO_tax_balance =  taxDeposit;
748         }
749         taxBurnBlock = OC.taxBurnBlock();
750         CEO_price = OC.CEO_price();
751         graffiti = OC.graffiti();
752         CEO_punk_index = OC.CEO_punk_index();
753         cigPerBlock = STARTING_REWARDS;        // set special rewards
754         lastRewardBlock = OC.lastRewardBlock();// start rewards
755         rewardsChangedBlock = OC.rewardsChangedBlock();
756         /* Historical records */
757         _transferNFT(
758             address(0),
759             address(0x1e32a859d69dde58d03820F8f138C99B688D132F)
760         );
761         emit NewCEO(
762             address(0x1e32a859d69dde58d03820F8f138C99B688D132F),
763             0x00000000000000000000000000000000000000000000000000000000000015c9,
764             0x000000000000000000000000000000000000000000007618fa42aac317900000,
765             0x41732043454f2049206465636c617265204465632032322050756e6b20446179
766         );
767         _transferNFT(
768             address(0x1e32a859d69dde58d03820F8f138C99B688D132F),
769             address(0x72014B4EEdee216E47786C4Ab27Cc6344589950d)
770         );
771         emit NewCEO(
772             address(0x72014B4EEdee216E47786C4Ab27Cc6344589950d),
773             0x0000000000000000000000000000000000000000000000000000000000000343,
774             0x00000000000000000000000000000000000000000001a784379d99db42000000,
775             0x40617a756d615f626974636f696e000000000000000000000000000000000000
776         );
777         _transferNFT(
778             address(0x72014B4EEdee216E47786C4Ab27Cc6344589950d),
779             address(0x4947DA4bEF9D79bc84bD584E6c12BfFa32D1bEc8)
780         );
781         emit NewCEO(
782             address(0x4947DA4bEF9D79bc84bD584E6c12BfFa32D1bEc8),
783             0x00000000000000000000000000000000000000000000000000000000000007fa,
784             0x00000000000000000000000000000000000000000014adf4b7320334b9000000,
785             0x46697273742070756e6b7320746f6b656e000000000000000000000000000000
786         );
787     }
788 
789     /**
790     * @dev wrap wraps old CIG and issues new CIG 1:1
791     * @param _value how much old cig to wrap
792     */
793     function wrap(uint256 _value) external {
794         require (CEO_state == 3);
795         OC.transferFrom(msg.sender, address(this), _value); // transfer old cig to here
796         _mint(msg.sender, _value);                          // give user new cig
797         wBal[msg.sender] = wBal[msg.sender] + _value;       // record increase of wrapped old cig for caller
798     }
799 
800     /**
801     * @dev unwrap unwraps old CIG and burns new CIG 1:1
802     */
803     function unwrap(uint256 _value) external {
804         require (CEO_state == 3);
805         _burn(msg.sender, _value);                          // burn new cig
806         OC.transfer(msg.sender, _value);                    // give back old cig
807         wBal[msg.sender] = wBal[msg.sender] - _value;       // record decrease of wrapped old cig for caller
808     }
809     /*
810     * 🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬 ERC20 Token stuff 🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬
811     */
812 
813     /**
814     * @dev burn some tokens
815     * @param _from The address to burn from
816     * @param _amount The amount to burn
817     */
818     function _burn(address _from, uint256 _amount) internal {
819         balanceOf[_from] = balanceOf[_from] - _amount;
820         totalSupply = totalSupply - _amount;
821         emit Transfer(_from, address(0), _amount);
822     }
823 
824     /**
825     * @dev mint new tokens
826    * @param _to The address to mint to.
827    * @param _amount The amount to be minted.
828    */
829     function _mint(address _to, uint256 _amount) internal {
830         require(_to != address(0), "ERC20: mint to the zero address");
831         unchecked {
832             totalSupply = totalSupply + _amount;
833             balanceOf[_to] = balanceOf[_to] + _amount;
834         }
835         emit Transfer(address(0), _to, _amount);
836     }
837 
838     /**
839     * @dev transfer token for a specified address
840     * @param _to The address to transfer to.
841     * @param _value The amount to be transferred.
842     */
843     function transfer(address _to, uint256 _value) public returns (bool) {
844         //require(_value <= balanceOf[msg.sender], "value exceeds balance"); // SafeMath already checks this
845         balanceOf[msg.sender] = balanceOf[msg.sender] - _value;
846         balanceOf[_to] = balanceOf[_to] + _value;
847         emit Transfer(msg.sender, _to, _value);
848         return true;
849     }
850 
851     /**
852     * @dev Transfer tokens from one address to another
853     * @param _from address The address which you want to send tokens from
854     * @param _to address The address which you want to transfer to
855     * @param _value uint256 the amount of tokens to be transferred
856     */
857     function transferFrom(
858         address _from,
859         address _to,
860         uint256 _value
861     )
862     public
863     returns (bool)
864     {
865         uint256 a = allowance[_from][msg.sender]; // read allowance
866         //require(_value <= balanceOf[_from], "value exceeds balance"); // SafeMath already checks this
867         if (a != type(uint256).max) {             // not infinite approval
868             require(_value <= a, "not approved");
869             unchecked {
870                 allowance[_from][msg.sender] = a - _value;
871             }
872         }
873         balanceOf[_from] = balanceOf[_from] - _value;
874         balanceOf[_to] = balanceOf[_to] + _value;
875         emit Transfer(_from, _to, _value);
876         return true;
877     }
878 
879     /**
880     * @dev Approve tokens of mount _value to be spent by _spender
881     * @param _spender address The spender
882     * @param _value the stipend to spend
883     */
884     function approve(address _spender, uint256 _value) external returns (bool) {
885         allowance[msg.sender][_spender] = _value;
886         emit Approval(msg.sender, _spender, _value);
887         return true;
888     }
889 
890     /*
891     * 🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬 Masterchef v2 integration 🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬
892     */
893 
894     /**
895     * @dev onSushiReward implements the SushiSwap masterchefV2 callback, guarded by the onlyMCV2 modifier
896     * @param _user address called on behalf of
897     * @param _to address who send rewards to
898     * @param _sushiAmount uint256, if not 0 then the rewards will be harvested
899     * @param _newLpAmount uint256, amount of LP tokens staked at Sushi
900     */
901     function onSushiReward (
902         uint256 /* pid */,
903         address _user,
904         address _to,
905         uint256 _sushiAmount,
906         uint256 _newLpAmount)  external onlyMCV2 {
907         UserInfo storage user = farmersMasterchef[_user];
908         update();
909         // Harvest sushi when there is sushiAmount passed through as this only comes in the event of the masterchef contract harvesting
910         if(_sushiAmount != 0) _harvest(user, _to); // send outstanding CIG to _to
911         uint256 delta;
912         // Withdraw stake
913         if(user.deposit >= _newLpAmount) { // Delta is withdraw
914             delta = user.deposit - _newLpAmount;
915             masterchefDeposits -= delta;   // subtract from staked total
916             _withdraw(user, delta);
917             emit ChefWithdraw(_user, delta);
918         }
919         // Deposit stake
920         else if(user.deposit != _newLpAmount) { // Delta is deposit
921             delta = _newLpAmount - user.deposit;
922             masterchefDeposits += delta;        // add to staked total
923             _deposit(user, delta);
924             emit ChefDeposit(_user, delta);
925         }
926     }
927 
928     // onlyMCV2 ensures only the MasterChefV2 contract can call this
929     modifier onlyMCV2 {
930         require(
931             msg.sender == MASTERCHEF_V2,
932             "Only MCV2"
933         );
934         _;
935     }
936 }
937 
938 /*
939 * 🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬 interfaces 🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬🚬
940 */
941 
942 /**
943 * @dev IRouterV2 is the sushi router 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F
944 */
945 interface IRouterV2 {
946     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns(uint256 amountOut);
947 }
948 
949 /**
950 * @dev ICryptoPunk used to query the cryptopunks contract to verify the owner
951 */
952 interface ICryptoPunk {
953     //function balanceOf(address account) external view returns (uint256);
954     function punkIndexToAddress(uint256 punkIndex) external returns (address);
955     //function punksOfferedForSale(uint256 punkIndex) external returns (bool, uint256, address, uint256, address);
956     //function buyPunk(uint punkIndex) external payable;
957     //function transferPunk(address to, uint punkIndex) external;
958 }
959 
960 interface ICEOERC721 {
961     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
962 }
963 
964 /*
965  * @dev Interface of the ERC20 standard as defined in the EIP.
966  */
967 interface IERC20 {
968     /**
969      * @dev Returns the amount of tokens in existence.
970      */
971     function totalSupply() external view returns (uint256);
972     /**
973      * @dev Returns the amount of tokens owned by `account`.
974      */
975     function balanceOf(address account) external view returns (uint256);
976     /**
977      * @dev Moves `amount` tokens from the caller's account to `recipient`.
978      *
979      * Returns a boolean value indicating whether the operation succeeded.
980      *
981      * Emits a {Transfer} event.
982      */
983     function transfer(address recipient, uint256 amount) external returns (bool);
984     /**
985      * @dev Returns the remaining number of tokens that `spender` will be
986      * allowed to spend on behalf of `owner` through {transferFrom}. This is
987      * zero by default.
988      *
989      * This value changes when {approve} or {transferFrom} are called.
990      */
991     function allowance(address owner, address spender) external view returns (uint256);
992     /**
993      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
994      *
995      * Returns a boolean value indicating whether the operation succeeded.
996      *
997      * IMPORTANT: Beware that changing an allowance with this method brings the risk
998      * that someone may use both the old and the new allowance by unfortunate
999      * transaction ordering. One possible solution to mitigate this race
1000      * condition is to first reduce the spender's allowance to 0 and set the
1001      * desired value afterwards:
1002      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1003      * 0xTycoon was here
1004      * Emits an {Approval} event.
1005      */
1006     function approve(address spender, uint256 amount) external returns (bool);
1007     /**
1008      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1009      * allowance mechanism. `amount` is then deducted from the caller's
1010      * allowance.
1011      *
1012      * Returns a boolean value indicating whether the operation succeeded.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1017     /**
1018      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1019      * another (`to`).
1020      *
1021      * Note that `value` may be zero.
1022      */
1023     event Transfer(address indexed from, address indexed to, uint256 value);
1024     /**
1025      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1026      * a call to {approve}. `value` is the new allowance.
1027      */
1028     event Approval(address indexed owner, address indexed spender, uint256 value);
1029 }
1030 
1031 /**
1032 * @dev from UniswapV2Pair.sol
1033 */
1034 interface ILiquidityPoolERC20 is IERC20 {
1035     function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
1036     function totalSupply() external view returns(uint);
1037 }
1038 
1039 interface IOldCigtoken is IERC20 {
1040     function claims(uint256) external view returns (bool);
1041     function graffiti() external view returns (bytes32);
1042     function cigPerBlock() external view returns (uint256);
1043     function The_CEO() external view returns (address);
1044     function CEO_punk_index() external view returns (uint);
1045     function CEO_price() external view returns (uint256);
1046     function CEO_state() external view returns (uint256);
1047     function CEO_tax_balance() external view returns (uint256);
1048     function taxBurnBlock() external view returns (uint256);
1049     function lastRewardBlock() external view returns (uint256);
1050     function rewardsChangedBlock() external view returns (uint256);
1051     function userInfo(address) external view returns (uint256, uint256);
1052     function burnTax() external;
1053 }
1054 
1055 // 🚬