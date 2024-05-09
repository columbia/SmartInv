1 // SPDX-License-Identifier: MIT
2 // Author: 0xTycoon
3 // Repo: github.com/0xTycoon/punksceo
4 
5 pragma solidity ^0.8.11;
6 
7 //import "./safemath.sol"; // don't need since v0.8
8 //import "./ceo.sol";
9 /*
10 
11 PUNKS CEO (and "Cigarette" token)
12 WEB: https://punksceo.eth.limo / https://punksceo.eth.link
13 IPFS: See content hash record for punksceo.eth
14 Token Address: cigtoken.eth
15 
16 There is NO trade tax or any other fee in the standard ERC20 methods of this token.
17 
18 The "CEO of CryptoPunks" game element is optional and implemented for your entertainment.
19 
20 ### THE RULES OF THE GAME
21 
22 1. Anybody can buy the CEO title at any time using Cigarettes. (The CEO of all cryptopunks)
23 2. When buying the CEO title, you must nominate a punk, set the price and pre-pay the tax.
24 3. The CEO title can be bought from the existing CEO at any time.
25 4. To remain a CEO, a daily tax needs to be paid.
26 5. The tax is 0.1% of the price to buy the CEO title, to be charged per epoch.
27 6. The CEO can be removed if they fail to pay the tax. A reward of CIGs is paid to the whistleblower.
28 7. After Removing a CEO: A dutch auction is held, where the price will decrease 10% every half-an-epoch.
29 8. The price can be changed by the CEO at any time. (Once per block)
30 9. An epoch is 7200 blocks.
31 10. All the Cigarettes from the sale are burned.
32 11. All tax is burned
33 12. After buying the CEO title, the old CEO will get their unspent tax deposit refunded
34 
35 ### CEO perk
36 
37 13. The CEO can increase or decrease the CIG farming block reward by 20% every 2nd epoch!
38 However, note that the issuance can never be more than 1000 CIG per block, also never under 0.0001 CIG.
39 14. THE CEO gets to hold a NFT in their wallet. There will only be ever 1 this NFT.
40 The purpose of this NFT is so that everyone can see that they are the CEO.
41 IMPORTANT: This NFT will be revoked once the CEO title changes.
42 Also, the NFT cannot be transferred by the owner, the only way to transfer is for someone else to buy the CEO title! (Think of this NFT as similar to a "title belt" in boxing.)
43 
44 END
45 
46 * states
47 * 0 = initial
48 * 1 = CEO reigning
49 * 2 = Dutch auction
50 
51 Notes:
52 It was decided that whoever buys the CEO title does not have to hold a punk and can nominate any punk they wish.
53 This is because some may hold their punks in cold storage, plus checking ownership costs additional gas.
54 Besides, CEOs are usually appointed by the board.
55 
56 Credits:
57 - LP Staking based on code from SushiSwap's MasterChef.sol
58 - ERC20 & SafeMath based on lib from OpenZeppelin
59 
60 */
61 
62 contract Cig {
63     //using SafeMath for uint256; // no need since Solidity 0.8
64     // ERC20 stuff
65     string public constant name = "Cigarette Token";
66     string public constant symbol = "CIG";
67     uint8 public constant decimals = 18;
68     uint256 public totalSupply = 0;
69     mapping(address => uint256) public balanceOf;
70     mapping(address => mapping(address => uint256)) public allowance;
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73     // UserInfo keeps track of user LP deposits and withdrawals
74     struct UserInfo {
75         uint256 deposit;    // How many LP tokens the user has deposited.
76         uint256 rewardDebt; // keeps track of how much reward was paid out
77     }
78     mapping(address => UserInfo) public userInfo; // keeps track of UserInfo for each staking address
79     address public admin;                         // admin is used for deployment, burned after
80     ILiquidityPoolERC20 public lpToken;           // lpToken is the address of LP token contract that's being staked.
81     uint256 public lastRewardBlock;               // Last block number that cigarettes distribution occurs.
82     uint256 public accCigPerShare;                // Accumulated cigarettes per share, times 1e12. See below.
83     uint256 public cigPerBlock;                   // CIGs per-block rewarded and split with LPs
84     bytes32 public graffiti;                      // a 32 character graffiti set when buying a CEO
85     ICryptoPunk public punks;                     // a reference to the CryptoPunks contract
86     event Deposit(address indexed user, uint256 amount);           // when depositing LP tokens to stake, or harvest
87     event Withdraw(address indexed user, uint256 amount);          // when withdrawing LP tokens form staking
88     event EmergencyWithdraw(address indexed user, uint256 amount); // when withdrawing LP tokens, no rewards claimed
89     event RewardUp(uint256 reward, uint256 upAmount);              // when cigPerBlock is increased
90     event RewardDown(uint256 reward, uint256 downAmount);          // when cigPerBlock is decreased
91     event Claim(address indexed owner, uint indexed punkIndex, uint256 value); // when a punk is claimed
92     mapping(uint => bool) public claims;                           // keep track of claimed punks
93     modifier onlyAdmin {
94         require(
95             msg.sender == admin,
96             "Only admin can call this"
97         );
98         _;
99     }
100     uint256 constant MIN_PRICE = 1e12;            // 0.000001 CIG
101     uint256 constant CLAIM_AMOUNT = 100000 ether; // claim amount for each punk
102     uint256 constant MIN_REWARD = 1e14;           // minimum block reward of 0.0001 CIG (1e14 wei)
103     uint256 constant MAX_REWARD = 1000 ether;     // maximum block reward of 1000 CIG
104     address public The_CEO;                       // address of CEO
105     uint public CEO_punk_index;                   // which punk id the CEO is using
106     uint256 public CEO_price = 50000 ether;       // price to buy the CEO title
107     uint256 public CEO_state;                     // state has 3 states, described above.
108     uint256 public CEO_tax_balance;               // deposit to be used to pay the CEO tax
109     uint256 public taxBurnBlock;                  // The last block when the tax was burned
110     uint256 public rewardsChangedBlock;           // which block was the last reward increase / decrease
111     uint256 private immutable CEO_epoch_blocks;   // secs per day divided by 12 (86400 / 12), assuming 12 sec blocks
112     uint256 private immutable CEO_auction_blocks; // 3600 blocks
113     event NewCEO(address indexed user, uint indexed punk_id, uint256 new_price, bytes32 graffiti); // when a CEO is bought
114     event TaxDeposit(address indexed user,  uint256 amount);                               // when tax is deposited
115     event RevenueBurned(address indexed user,  uint256 amount);                            // when tax is burned
116     event TaxBurned(address indexed user,  uint256 amount);                                // when tax is burned
117     event CEODefaulted(address indexed called_by,  uint256 reward);                        // when CEO defaulted on tax
118     event CEOPriceChange(uint256 price);                                                   // when CEO changed price
119     modifier onlyCEO {
120         require(
121             msg.sender == The_CEO,
122             "only CEO can call this"
123         );
124         _;
125     }
126     IRouterV2 private immutable V2ROUTER;    // address of router used to get the price quote
127     ICEOERC721 private immutable The_NFT;    // reference to the CEO NFT token
128     address private immutable MASTERCHEF_V2; // address pointing to SushiSwap's MasterChefv2 contract
129     /**
130     * @dev constructor
131     * @param _startBlock starting block when rewards start
132     * @param _cigPerBlock Number of CIG tokens rewarded per block
133     * @param _punks address of the cryptopunks contract
134     * @param _CEO_epoch_blocks how many blocks between each epochs
135     * @param _CEO_auction_blocks how many blocks between each auction discount
136     * @param _CEO_price starting price to become CEO (in CIG)
137     * @param _MASTERCHEF_V2 address of the MasterChefv2 contract
138     */
139     constructor(
140         uint256 _startBlock,
141         uint256 _cigPerBlock,
142         address _punks,
143         uint _CEO_epoch_blocks,
144         uint _CEO_auction_blocks,
145         uint256 _CEO_price,
146         address _MASTERCHEF_V2,
147         bytes32 _graffiti,
148         address _NFT,
149         address _V2ROUTER
150     ) {
151         lastRewardBlock    = _startBlock;
152         cigPerBlock        = _cigPerBlock;
153         admin              = msg.sender;                 // the admin key will be burned after deployment
154         punks              = ICryptoPunk(_punks);
155         CEO_epoch_blocks   = _CEO_epoch_blocks;
156         CEO_auction_blocks = _CEO_auction_blocks;
157         CEO_price          = _CEO_price;
158         MASTERCHEF_V2      = _MASTERCHEF_V2;
159         graffiti           = _graffiti;
160         The_NFT            = ICEOERC721(_NFT);
161         V2ROUTER           = IRouterV2(_V2ROUTER);
162         // mint the tokens for the airdrop and place them in the CryptoPunks contract.
163         mint(_punks, CLAIM_AMOUNT * 10000);
164     }
165 
166     /**
167     * @dev renounceOwnership burns the admin key, so this contract is unruggable
168     */
169     function renounceOwnership() external onlyAdmin {
170         admin = address(0);
171     }
172 
173     /**
174     * @dev setStartingBlock sets the starting block for LP staking rewards
175     * Admin only, used only for initial configuration.
176     * @param _startBlock the block to start rewards for
177     */
178     function setStartingBlock(uint256 _startBlock) external onlyAdmin {
179         lastRewardBlock = _startBlock;
180     }
181 
182     /**
183     * @dev setPool address to an LP pool. Only Admin. (used only in testing/deployment)
184     */
185     function setPool(ILiquidityPoolERC20 _addr) external onlyAdmin {
186         require(address(lpToken) == address(0), "pool already set");
187         lpToken = _addr;
188     }
189 
190     /**
191     * @dev setReward sets the reward. Admin only (used only in testing/deployment)
192     */
193     function setReward(uint256 _value) public onlyAdmin {
194         cigPerBlock = _value;
195     }
196 
197     /**
198     * @dev buyCEO allows anybody to be the CEO
199     * @param _max_spend the total CIG that can be spent
200     * @param _new_price the new price for the punk (in CIG)
201     * @param _tax_amount how much to pay in advance (in CIG)
202     * @param _punk_index the id of the punk 0-9999
203     * @param _graffiti a little message / ad from the buyer
204     */
205     function buyCEO(
206         uint256 _max_spend,
207         uint256 _new_price,
208         uint256 _tax_amount,
209         uint256 _punk_index,
210         bytes32 _graffiti
211     ) external  {
212         if (CEO_state == 1 && (taxBurnBlock != block.number)) {
213             _burnTax();                                                    // _burnTax can change CEO_state to 2
214         }
215         if (CEO_state == 2) {
216             // Auction state. The price goes down 10% every `CEO_auction_blocks` blocks
217             CEO_price = _calcDiscount();
218         }
219         require (CEO_price + _tax_amount <= _max_spend, "overpaid");        // prevent CEO over-payment
220         require (_new_price >= MIN_PRICE, "price 2 smol");                 // price cannot be under 0.000001 CIG
221         require (_punk_index <= 9999, "invalid punk");                     // validate the punk index
222         require (_tax_amount >= _new_price / 1000, "insufficient tax" );   // at least %0.1 fee paid for 1 epoch
223         transfer(address(this), CEO_price);                                // pay for the CEO title
224         burn(address(this), CEO_price);                                    // burn the revenue
225         emit RevenueBurned(msg.sender, CEO_price);
226         _returnDeposit(The_CEO, CEO_tax_balance);                          // return deposited tax back to old CEO
227         transfer(address(this), _tax_amount);                              // deposit tax (reverts if not enough)
228         CEO_tax_balance = _tax_amount;                                     // store the tax deposit amount
229         _transferNFT(The_CEO, msg.sender);                                 // yank the NFT to the new CEO
230         CEO_price = _new_price;                                            // set the new price
231         CEO_punk_index = _punk_index;                                      // store the punk id
232         The_CEO = msg.sender;                                              // store the CEO's address
233         taxBurnBlock = block.number;                                       // store the block number
234                                                                            // (tax may not have been burned if the
235                                                                            // previous state was 0)
236         CEO_state = 1;
237         graffiti = _graffiti;
238         emit TaxDeposit(msg.sender, _tax_amount);
239         emit NewCEO(msg.sender, _punk_index, _new_price, _graffiti);
240     }
241 
242     /**
243     * @dev _returnDeposit returns the tax deposit back to the CEO
244     * @param _to address The address which you want to transfer to
245     * remember to update CEO_tax_balance after calling this
246     */
247     function _returnDeposit(
248         address _to,
249         uint256 _amount
250     )
251     internal
252     {
253         if (_amount == 0) {
254             return;
255         }
256         balanceOf[address(this)] = balanceOf[address(this)] - _amount;
257         balanceOf[_to] = balanceOf[_to] + _amount;
258         emit Transfer(address(this), _to, _amount);
259         //CEO_tax_balance = 0; // can be omitted since value gets overwritten by caller
260     }
261 
262     /**
263     * @dev transfer the NFT to a new wallet
264     */
265     function _transferNFT(address _oldCEO, address _newCEO) internal {
266         if (_oldCEO != _newCEO) {
267             The_NFT.transferFrom(_oldCEO, _newCEO, 0);
268         }
269     }
270 
271     /**
272     * @dev depositTax pre-pays tax for the existing CEO.
273     * It may also burn any tax debt the CEO may have.
274     * @param _amount amount of tax to pre-pay
275     */
276     function depositTax(uint256 _amount) external onlyCEO {
277         require (CEO_state == 1, "no CEO");
278         if (_amount > 0) {
279             transfer(address(this), _amount);                   // place the tax on deposit
280             CEO_tax_balance = CEO_tax_balance + _amount;        // record the balance
281             emit TaxDeposit(msg.sender, _amount);
282         }
283         if (taxBurnBlock != block.number) {
284             _burnTax();                                         // settle any tax debt
285             taxBurnBlock = block.number;
286         }
287     }
288 
289     /**
290     * @dev burnTax is called to burn tax.
291     * It removes the CEO if tax is unpaid.
292     * 1. deduct tax, update last update
293     * 2. if not enough tax, remove & begin auction
294     * 3. reward the caller by minting a reward from the amount indebted
295     * A Dutch auction begins where the price decreases 10% every hour.
296     */
297 
298     function burnTax() external  {
299         if (taxBurnBlock == block.number) return;
300         if (CEO_state == 1) {
301             _burnTax();
302             taxBurnBlock = block.number;
303         }
304     }
305 
306     /**
307     * @dev _burnTax burns any tax debt. Boots the CEO if defaulted, paying a reward to the caller
308     */
309     function _burnTax() internal {
310         // calculate tax per block (tpb)
311         uint256 tpb = CEO_price / 1000 / CEO_epoch_blocks;       // 0.1% per epoch
312         uint256 debt = (block.number - taxBurnBlock) * tpb;
313         if (CEO_tax_balance !=0 && CEO_tax_balance >= debt) {    // Does CEO have enough deposit to pay debt?
314             CEO_tax_balance = CEO_tax_balance - debt;            // deduct tax
315             burn(address(this), debt);                           // burn the tax
316             emit TaxBurned(msg.sender, debt);
317         } else {
318             // CEO defaulted
319             uint256 default_amount = debt - CEO_tax_balance;     // calculate how much defaulted
320             burn(address(this), CEO_tax_balance);                // burn the tax
321             emit TaxBurned(msg.sender, CEO_tax_balance);
322             CEO_state = 2;                                       // initiate a Dutch auction.
323             CEO_tax_balance = 0;
324             _transferNFT(The_CEO, address(this));                // This contract holds the NFT temporarily
325             The_CEO = address(this);                             // This contract is the "interim CEO"
326             mint(msg.sender, default_amount);                    // reward the caller for reporting tax default
327             emit CEODefaulted(msg.sender, default_amount);
328         }
329     }
330 
331     /**
332      * @dev setPrice changes the price for the CEO title.
333      * @param _price the price to be paid. The new price most be larger tan MIN_PRICE and not default on debt
334      */
335     function setPrice(uint256 _price) external onlyCEO  {
336         require(CEO_state == 1, "No CEO in charge");
337         require (_price >= MIN_PRICE, "price 2 smol");
338         require (CEO_tax_balance >= _price / 1000, "price would default"); // need at least 0.1% for tax
339         if (block.number != taxBurnBlock) {
340             _burnTax();
341             taxBurnBlock = block.number;
342         }
343         // The state is 1 if the CEO hasn't defaulted on tax
344         if (CEO_state == 1) {
345             CEO_price = _price; // set the new price
346             emit CEOPriceChange(_price);
347         }
348     }
349 
350     /**
351     * @dev rewardUp allows the CEO to increase the block rewards by %1
352     * Can only be called by the CEO every 7 epochs
353     * @return _amount increased by
354     */
355     function rewardUp() external onlyCEO returns (uint256)  {
356         require(CEO_state == 1, "No CEO in charge");
357         require(block.number > rewardsChangedBlock + (CEO_epoch_blocks*2), "wait more blocks");
358         require (cigPerBlock <= MAX_REWARD, "reward already max");
359         rewardsChangedBlock = block.number;
360         uint256 _amount = cigPerBlock / 5;                // %20
361         uint256 _new_reward = cigPerBlock + _amount;
362         if (_new_reward > MAX_REWARD) {
363             _amount = MAX_REWARD - cigPerBlock;
364             _new_reward = MAX_REWARD; // cap
365         }
366         cigPerBlock = _new_reward;
367         emit RewardUp(_new_reward, _amount);
368         return _amount;
369     }
370 
371     /**
372     * @dev rewardDown decreases the block rewards by 1%
373     * Can only be called by the CEO every 7 epochs
374     */
375     function rewardDown() external onlyCEO returns (uint256) {
376         require(CEO_state == 1, "No CEO in charge");
377         require(block.number > rewardsChangedBlock + (CEO_epoch_blocks*2), "wait more blocks");
378         require(cigPerBlock >= MIN_REWARD, "reward already low");
379         rewardsChangedBlock = block.number;
380         uint256 _amount = cigPerBlock / 5;            // %20
381         uint256 _new_reward = cigPerBlock - _amount;
382         if (_new_reward < MIN_REWARD) {
383             _amount = cigPerBlock - MIN_REWARD;
384             _new_reward = MIN_REWARD;
385         }
386         cigPerBlock = _new_reward;
387         emit RewardDown(_new_reward, _amount);
388         return _amount;
389     }
390 
391     /**
392     * @dev _calcDiscount calculates the discount for the CEO title based on how many blocks passed
393     */
394     function _calcDiscount() internal view returns (uint256) {
395         unchecked {
396             uint256 d = (CEO_price / 10)           // 10% discount
397             // multiply by the number of discounts accrued
398             * (block.number - taxBurnBlock) / CEO_auction_blocks;
399             if (d > CEO_price) {
400                 // overflow assumed, reset to MIN_PRICE
401                 return MIN_PRICE;
402             }
403             uint256 price = CEO_price - d;
404             if (price < MIN_PRICE) {
405                 price = MIN_PRICE;
406             }
407         return price;
408         }
409     }
410 
411     /**
412     * @dev getStats helps to fetch some stats for the GUI in a single web3 call
413     * @param _user the address to return the report for
414     * @return uint256[22] the stats
415     * @return address of the current CEO
416     * @return bytes32 Current graffiti
417     */
418     function getStats(address _user) external view returns(uint256[] memory, address, bytes32, uint112[] memory) {
419         uint[] memory ret = new uint[](22);
420         uint112[] memory reserves = new uint112[](2);
421         uint256 tpb = (CEO_price / 1000) / (CEO_epoch_blocks); // 0.1% per epoch
422         uint256 debt = (block.number - taxBurnBlock) * tpb;
423         uint256 price = CEO_price;
424         UserInfo memory info = userInfo[_user];
425         if (CEO_state == 2) {
426             price = _calcDiscount();
427         }
428         ret[0] = CEO_state;
429         ret[1] = CEO_tax_balance;
430         ret[2] = taxBurnBlock;                     // the block number last tax burn
431         ret[3] = rewardsChangedBlock;              // the block of the last staking rewards change
432         ret[4] = price;                            // price of the CEO title
433         ret[5] = CEO_punk_index;                   // punk ID of CEO
434         ret[6] = cigPerBlock;                      // staking reward per block
435         ret[7] = totalSupply;                      // total supply of CIG
436         if (address(lpToken) != address(0)) {
437             ret[8] = lpToken.balanceOf(address(this)); // Total LP staking
438             ret[16] = lpToken.balanceOf(_user);        // not staked by user
439             ret[17] = pendingCig(_user);               // pending harvest
440             (reserves[0], reserves[1], ) = lpToken.getReserves();        // uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast
441             ret[18] = V2ROUTER.getAmountOut(1 ether, uint(reserves[0]), uint(reserves[1])); // CIG price in ETH
442             if (isContract(address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2))) { // are we on mainnet?
443                 ILiquidityPoolERC20 ethusd = ILiquidityPoolERC20(address(0xC3D03e4F041Fd4cD388c549Ee2A29a9E5075882f));  // sushi DAI-WETH pool
444                 uint112 r0;
445                 uint112 r1;
446                 (r0, r1, ) = ethusd.getReserves();
447                 // get the price of ETH in USD
448                 ret[19] =  V2ROUTER.getAmountOut(1 ether, uint(r0), uint(r1));      // ETH price in USD
449             }
450         }
451 
452         ret[9] = block.number;                     // current block number
453         ret[10] = tpb;                             // "tax per block" (tpb)
454         ret[11] = debt;                            // tax debt accrued
455         ret[12] = lastRewardBlock;                 // the block of the last staking rewards payout update
456         ret[13] = info.deposit;                    // amount of LP tokens staked by user
457         ret[14] = info.rewardDebt;                 // amount of rewards paid out
458         ret[15] = balanceOf[_user];                // amount of CIG held by user
459         ret[20] = balanceOf[address(0)];           // amount of CIG burned
460         ret[21] = balanceOf[address(punks)];       // amount of CIG to be claimed
461 
462         return (ret, The_CEO, graffiti, reserves);
463     }
464 
465     /*
466     * ************************ Token distribution and farming stuff ****************
467     */
468 
469     /**
470     * Claim claims the initial CIG airdrop using a punk
471     * @param _punkIndex the index of the punk, number between 0-9999
472     */
473     function claim(uint256 _punkIndex) external returns(bool) {
474         require (_punkIndex <= 9999, "invalid punk");
475         require(claims[_punkIndex] == false, "punk already claimed");
476         require(msg.sender == punks.punkIndexToAddress(_punkIndex), "punk 404");
477         claims[_punkIndex] = true;
478         balanceOf[address(punks)] = balanceOf[address(punks)] - CLAIM_AMOUNT; // deduct from the punks contract
479         balanceOf[msg.sender] = balanceOf[msg.sender] + CLAIM_AMOUNT;         // deposit to the caller
480         emit Transfer(address(punks), msg.sender, CLAIM_AMOUNT);
481         emit Claim(msg.sender, _punkIndex, CLAIM_AMOUNT);
482         return true;
483     }
484 
485     /**
486     * @dev update updates the accCigPerShare value and mints new CIG rewards to be distributed to LP stakers
487     * Credits go to MasterChef.sol
488     * Modified the original by removing poolInfo as there is only a single pool
489     * Removed totalAllocPoint and pool.allocPoint
490     * pool.lastRewardBlock moved to lastRewardBlock
491     * There is no need for getMultiplier (rewards are adjusted by the CEO)
492     *
493     */
494     function update() public {
495         if (block.number <= lastRewardBlock) {
496             return;
497         }
498         uint256 lpSupply = lpToken.balanceOf(address(this));
499         if (lpSupply == 0) {
500             lastRewardBlock = block.number;
501             return;
502         }
503         // mint some new cigarette rewards to be distributed
504         uint256 cigReward = (block.number - lastRewardBlock) * cigPerBlock;
505         mint(address(this), cigReward);
506         accCigPerShare = accCigPerShare + (
507             cigReward * 1e12 / lpSupply
508         );
509         lastRewardBlock = block.number;
510     }
511 
512     /**
513     * @dev pendingCig displays the amount of cig to be claimed
514     * @param _user the address to report
515     */
516     function pendingCig(address _user) view public returns (uint256) {
517         uint256 _acps = accCigPerShare;
518         // accumulated cig per share
519         UserInfo storage user = userInfo[_user];
520         uint256 lpSupply = lpToken.balanceOf(address(this));
521         if (block.number > lastRewardBlock && lpSupply != 0) {
522             uint256 cigReward = (block.number - lastRewardBlock) * cigPerBlock;
523             _acps = _acps + (
524                 cigReward * 1e12 / lpSupply
525             );
526         }
527         return (user.deposit * _acps / 1e12) - user.rewardDebt;
528     }
529 
530     /**
531     * @dev deposit deposits LP tokens to be staked. It also harvests rewards.
532     * @param _amount the amount of LP tokens to deposit. Assumes this contract has been approved for the _amount.
533     */
534     function deposit(uint256 _amount) public {
535         UserInfo storage user = userInfo[msg.sender];
536         update();
537         if (user.deposit > 0) {
538             uint256 pending =
539             (user.deposit * (accCigPerShare) / 1e12) - user.rewardDebt;
540             safeSendPayout(msg.sender, pending);
541         }
542         if (_amount > 0) {
543             lpToken.transferFrom(
544                 address(msg.sender),
545                 address(this),
546                 _amount
547             );
548             user.deposit = user.deposit + _amount;
549             emit Deposit(msg.sender, _amount);
550         }
551         user.rewardDebt = user.deposit * accCigPerShare / 1e12;
552     }
553 
554     /**
555     * @dev withdraw takes out the LP tokens and pending rewards
556     * @param _amount the amount to withdraw
557     */
558     function withdraw(uint256 _amount) external {
559         UserInfo storage user = userInfo[msg.sender];
560         require(user.deposit >= _amount, "withdraw: not good");
561         update();
562         uint256 pending = (user.deposit * accCigPerShare / 1e12) - user.rewardDebt;
563         safeSendPayout(msg.sender, pending);
564         user.deposit = user.deposit - _amount;
565         user.rewardDebt = user.deposit * accCigPerShare / 1e12;
566         lpToken.transfer(address(msg.sender), _amount);
567         emit Withdraw(msg.sender, _amount);
568     }
569     /**
570     * @dev emergencyWithdraw does a withdraw without caring about rewards. EMERGENCY ONLY.
571     */
572     function emergencyWithdraw() external {
573         UserInfo storage user = userInfo[msg.sender];
574         uint256 amount = user.deposit;
575         user.deposit = 0;
576         user.rewardDebt = 0;
577         lpToken.transfer(address(msg.sender), amount);
578         emit EmergencyWithdraw(msg.sender, amount);
579 
580     }
581     /**
582     * @dev safeSendPayout, just in case if rounding error causes pool to not have enough CIGs.
583     * @param _to recipient address
584     * @param _amount the value to send
585     */
586     function safeSendPayout(address _to, uint256 _amount) internal {
587         uint256 cigBal = balanceOf[address(this)];
588         if (_amount > cigBal) {
589             _amount = cigBal;
590         }
591         balanceOf[address(this)] = balanceOf[address(this)] - _amount;
592         balanceOf[_to] = balanceOf[_to] + _amount;
593         emit Transfer(address(this), _to, _amount);
594     }
595 
596     /*
597     * ************************ ERC20 Token stuff ********************************
598     */
599 
600     /**
601     * @dev burn some tokens
602     * @param _from The address to burn from
603     * @param _amount The amount to burn
604     */
605    function burn(address _from, uint256 _amount) internal {
606        balanceOf[_from] = balanceOf[_from] - _amount;
607        totalSupply = totalSupply - _amount;
608        emit Transfer(_from, address(0), _amount);
609    }
610 
611    /**
612    * @dev mint new tokens
613    * @param _to The address to mint to.
614    * @param _amount The amount to be minted.
615    */
616     function mint(address _to, uint256 _amount) internal {
617         require(_to != address(0), "ERC20: mint to the zero address");
618         totalSupply = totalSupply + _amount;
619         balanceOf[_to] = balanceOf[_to] + _amount;
620         emit Transfer(address(0), _to, _amount);
621     }
622 
623     /**
624     * @dev transfer token for a specified address
625     * @param _to The address to transfer to.
626     * @param _value The amount to be transferred.
627     */
628     function transfer(address _to, uint256 _value) public returns (bool) {
629         // require(_value <= balanceOf[msg.sender], "value exceeds balance"); // SafeMath already checks this
630         balanceOf[msg.sender] = balanceOf[msg.sender] - _value;
631         balanceOf[_to] = balanceOf[_to] + _value;
632         emit Transfer(msg.sender, _to, _value);
633         return true;
634     }
635 
636     /**
637     * @dev Transfer tokens from one address to another
638     * @param _from address The address which you want to send tokens from
639     * @param _to address The address which you want to transfer to
640     * @param _value uint256 the amount of tokens to be transferred
641     */
642     function transferFrom(
643         address _from,
644         address _to,
645         uint256 _value
646     )
647     public
648     returns (bool)
649     {
650         //require(_value <= balanceOf[_from], "value exceeds balance"); // SafeMath already checks this
651         require(_value <= allowance[_from][msg.sender], "not approved");
652         balanceOf[_from] = balanceOf[_from] - _value;
653         balanceOf[_to] = balanceOf[_to] + _value;
654         emit Transfer(_from, _to, _value);
655         return true;
656     }
657 
658 
659     /**
660     * @dev Approve tokens of mount _value to be spent by _spender
661     * @param _spender address The spender
662     * @param _value the stipend to spend
663     */
664     function approve(address _spender, uint256 _value) public returns (bool) {
665         allowance[msg.sender][_spender] = _value;
666         emit Approval(msg.sender, _spender, _value);
667         return true;
668     }
669 
670     /********************************************************************
671     * @dev onSushiReward IRewarder methods to be called by the SushSwap MasterChefV2 contract
672     */
673 
674     function onSushiReward (
675         uint256 /* pid */,
676         address _user,
677         address _to,
678         uint256 /* sushiAmount*/,
679         uint256 _newLpAmount)  external onlyMCV2 {
680         UserInfo storage user = userInfo[_user];
681         update();
682         if (user.deposit > 0) {
683             uint256 pending = (user.deposit * accCigPerShare / 1e12) - user.rewardDebt;
684             safeSendPayout(_to, pending);
685         }
686         user.deposit = _newLpAmount;
687         user.rewardDebt = user.deposit * accCigPerShare / 1e12;
688     }
689 
690     /**
691     * pendingTokens returns the number of pending CIG rewards, implementing IRewarder
692     * @param user it is the only parameter we look at
693     */
694     function pendingTokens(uint256 pid, address user, uint256 sushiAmount) external view returns (IERC20[] memory, uint256[] memory) {
695         IERC20[] memory _rewardTokens = new IERC20[](1);
696         _rewardTokens[0] = IERC20(address(this));
697         uint256[] memory _rewardAmounts = new uint256[](1);
698         _rewardAmounts[0] = pendingCig(user);
699         return (_rewardTokens, _rewardAmounts);
700     }
701     // onlyMCV2 ensures only the MasterChefV2 contract can call this
702     modifier onlyMCV2 {
703         require(
704             msg.sender == MASTERCHEF_V2,
705             "Only MCV2"
706         );
707         _;
708     }
709 
710     /**
711      * @dev Returns true if `account` is a contract.
712      *
713      * credits https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
714      */
715     function isContract(address account) internal view returns (bool) {
716         uint256 size;
717         assembly {
718             size := extcodesize(account)
719         }
720         return size > 0;
721     }
722 }
723 
724 /**
725 * @dev sushi router 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F
726 */
727 interface IRouterV2 {
728     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns(uint256 amountOut);
729 
730 }
731 
732 
733 
734 interface ICryptoPunk {
735     //function balanceOf(address account) external view returns (uint256);
736     function punkIndexToAddress(uint256 punkIndex) external returns (address);
737     //function punksOfferedForSale(uint256 punkIndex) external returns (bool, uint256, address, uint256, address);
738     //function buyPunk(uint punkIndex) external payable;
739     //function transferPunk(address to, uint punkIndex) external;
740 }
741 
742 interface ICEOERC721 {
743     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
744 }
745 
746 // IRewarder allows the contract to be called by SushSwap MasterChefV2
747 // example impl https://etherscan.io/address/0x7519c93fc5073e15d89131fd38118d73a72370f8/advanced#code
748 interface IRewarder {
749     function onSushiReward(uint256 pid, address user, address recipient, uint256 sushiAmount, uint256 newLpAmount) external;
750     function pendingTokens(uint256 pid, address user, uint256 sushiAmount) external view returns (IERC20[] memory, uint256[] memory);
751 }
752 
753 /*
754  * @dev Interface of the ERC20 standard as defined in the EIP.
755  */
756 interface IERC20 is IRewarder {
757     /**
758      * @dev Returns the amount of tokens in existence.
759      */
760     function totalSupply() external view returns (uint256);
761     /**
762      * @dev Returns the amount of tokens owned by `account`.
763      */
764     function balanceOf(address account) external view returns (uint256);
765     /**
766      * @dev Moves `amount` tokens from the caller's account to `recipient`.
767      *
768      * Returns a boolean value indicating whether the operation succeeded.
769      *
770      * Emits a {Transfer} event.
771      */
772     function transfer(address recipient, uint256 amount) external returns (bool);
773     /**
774      * @dev Returns the remaining number of tokens that `spender` will be
775      * allowed to spend on behalf of `owner` through {transferFrom}. This is
776      * zero by default.
777      *
778      * This value changes when {approve} or {transferFrom} are called.
779      */
780     function allowance(address owner, address spender) external view returns (uint256);
781     /**
782      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
783      *
784      * Returns a boolean value indicating whether the operation succeeded.
785      *
786      * IMPORTANT: Beware that changing an allowance with this method brings the risk
787      * that someone may use both the old and the new allowance by unfortunate
788      * transaction ordering. One possible solution to mitigate this race
789      * condition is to first reduce the spender's allowance to 0 and set the
790      * desired value afterwards:
791      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
792      * 0xTycoon was here
793      * Emits an {Approval} event.
794      */
795     function approve(address spender, uint256 amount) external returns (bool);
796     /**
797      * @dev Moves `amount` tokens from `sender` to `recipient` using the
798      * allowance mechanism. `amount` is then deducted from the caller's
799      * allowance.
800      *
801      * Returns a boolean value indicating whether the operation succeeded.
802      *
803      * Emits a {Transfer} event.
804      */
805     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
806     /**
807      * @dev Emitted when `value` tokens are moved from one account (`from`) to
808      * another (`to`).
809      *
810      * Note that `value` may be zero.
811      */
812     event Transfer(address indexed from, address indexed to, uint256 value);
813     /**
814      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
815      * a call to {approve}. `value` is the new allowance.
816      */
817     event Approval(address indexed owner, address indexed spender, uint256 value);
818 }
819 
820 /**
821 * @dev from UniswapV2Pair.sol
822 */
823 interface ILiquidityPoolERC20 is IERC20 {
824     function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
825 }