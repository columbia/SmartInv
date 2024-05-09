1 pragma solidity 0.4.24;
2 pragma experimental "v0.5.0";
3 
4 interface RTCoinInterface {
5     
6 
7     /** Functions - ERC20 */
8     function transfer(address _recipient, uint256 _amount) external returns (bool);
9 
10     function transferFrom(address _owner, address _recipient, uint256 _amount) external returns (bool);
11 
12     function approve(address _spender, uint256 _amount) external returns (bool approved);
13 
14     /** Getters - ERC20 */
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address _holder) external view returns (uint256);
18 
19     function allowance(address _owner, address _spender) external view returns (uint256);
20 
21     /** Getters - Custom */
22     function mint(address _recipient, uint256 _amount) external returns (bool);
23 
24     function stakeContractAddress() external view returns (address);
25 
26     function mergedMinerValidatorAddress() external view returns (address);
27     
28     /** Functions - Custom */
29     function freezeTransfers() external returns (bool);
30 
31     function thawTransfers() external returns (bool);
32 }
33 
34 /*
35     ERC20 Standard Token interface
36 */
37 interface ERC20Interface {
38     function owner() external view returns (address);
39     function decimals() external view returns (uint8);
40     function transfer(address _to, uint256 _value) external returns (bool);
41     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
42     function approve(address _spender, uint256 _amount) external returns (bool);
43     function totalSupply() external view returns (uint256);
44     function balanceOf(address _owner) external view returns (uint256);
45     function allowance(address _owner, address _spender) external view returns (uint256);
46 }
47 
48 library SafeMath {
49 
50   // We use `pure` bbecause it promises that the value for the function depends ONLY
51   // on the function arguments
52     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
53         uint256 c = a * b;
54         require(a == 0 || c / a == b);
55         return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a / b;
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         return a - b;
66     }
67 
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a);
71         return c;
72     }
73 }
74 
75 
76 /// @title This contract is used to handle staking, and subsequently can increase RTC token supply
77 /// @author Postables, RTrade Technologies Ltd
78 /// @dev We able V5 for safety features, see https://solidity.readthedocs.io/en/v0.4.24/security-considerations.html#take-warnings-seriously
79 contract Stake {
80 
81     using SafeMath for uint256;
82 
83     // we mark as constant private to reduce gas costs
84     // Minimum stake of 1RTC
85     uint256 constant private MINSTAKE = 1000000000000000000;
86     // NOTE ON MULTIPLIER: this is right now set to 10% this may however change before token is released
87     uint256 constant private MULTIPLIER = 100000000000000000;
88     // BLOCKHOLDPERIOD is used to determine how many blocks a stake is held for, and how many blocks will mint tokens
89     uint256 constant private BLOCKHOLDPERIOD = 2103840;
90     // BLOCKSEC uses 15 seconds as an average block time. Ultimately the only thing this "restricts" is the time at which a stake is withdrawn
91     // Yes, we use block timestamps which can be influenced to some degree by miners, however since this only determines the time at which an initial stake can be withdrawn at
92     // due to the fact that this is also limited by block height, it is an acceptable risk
93     uint256 constant private BLOCKSEC = 15;
94     string  constant public VERSION = "production";
95     // this is the address of the RTC token contract
96     address  constant public TOKENADDRESS = 0xecc043b92834c1ebDE65F2181B59597a6588D616;
97     // this is the interface used to interact with the RTC Token
98     RTCoinInterface   constant public RTI = RTCoinInterface(TOKENADDRESS);
99 
100     // keeps track of the number of active stakes
101     uint256 public activeStakes;
102     // keeps track of the admin address. For security purposes this can't be changed once set
103     address public admin;
104     // keeps track of whether or not new stakes can be made
105     bool public newStakesAllowed;
106 
107     // tracks the state of a stake
108     enum StakeStateEnum { nil, staking, staked }
109 
110     struct StakeStruct {
111         // how many tokens were initially staked
112         uint256 initialStake;
113         // the block that the stake was made
114         uint256 blockLocked;
115         // the block at which the initial stake can be withdrawn
116         uint256 blockUnlocked;
117         // the time at which the initial stake can be withdrawn
118         uint256 releaseDate;
119         // the total number of coins to mint
120         uint256 totalCoinsToMint;
121         // the current number of coins that have been minted
122         uint256 coinsMinted;
123         // the amount of coins generated per block
124         uint256 rewardPerBlock;
125         // the block at which a stake was last withdrawn at 
126         uint256 lastBlockWithdrawn;
127         // the current state of this stake
128         StakeStateEnum    state;
129     }
130 
131     event StakesDisabled();
132     event StakesEnabled();
133     event StakeDeposited(address indexed _staker, uint256 indexed _stakeNum, uint256 _coinsToMint, uint256 _releaseDate, uint256 _releaseBlock);
134     event StakeRewardWithdrawn(address indexed _staker, uint256 indexed _stakeNum, uint256 _reward);
135     event InitialStakeWithdrawn(address indexed _staker, uint256 indexed _stakeNumber, uint256 _amount);
136     event ForeignTokenTransfer(address indexed _sender, address indexed _recipient, uint256 _amount);
137 
138     // keeps track of the stakes a user has
139     mapping (address => mapping (uint256 => StakeStruct)) public stakes;
140     // keeps track of the total number of stakes a user has
141     mapping (address => uint256) public numberOfStakes;
142     // keeps track of the user's current RTC balance
143     mapping (address => uint256) public internalRTCBalances;
144 
145     modifier validInitialStakeRelease(uint256 _stakeNum) {
146         // make sure that the stake is active
147         require(stakes[msg.sender][_stakeNum].state == StakeStateEnum.staking, "stake is not active");
148         require(
149             // please see comment at top of contract about why we consider it safe to use block times
150             // linter warnings are left enabled on purpose
151             now >= stakes[msg.sender][_stakeNum].releaseDate && block.number >= stakes[msg.sender][_stakeNum].blockUnlocked, 
152             "attempting to withdraw initial stake before unlock block and date"
153         );
154         require(internalRTCBalances[msg.sender] >= stakes[msg.sender][_stakeNum].initialStake, "invalid internal rtc balance");
155         _;
156     }
157 
158     modifier validMint(uint256 _stakeNumber) {
159         // allow people to withdraw their rewards even if the staking period is over
160         require(
161             stakes[msg.sender][_stakeNumber].state == StakeStateEnum.staking || stakes[msg.sender][_stakeNumber].state == StakeStateEnum.staked, 
162             "stake must be active or inactive in order to mint tokens"
163         );
164         // make sure that the current coins minted are less than the total coins minted
165         require(
166             stakes[msg.sender][_stakeNumber].coinsMinted < stakes[msg.sender][_stakeNumber].totalCoinsToMint, 
167             "current coins minted must be less than total"
168         );
169         uint256 currentBlock = block.number;
170         uint256 lastBlockWithdrawn = stakes[msg.sender][_stakeNumber].lastBlockWithdrawn;
171         // verify that the current block is one higher than the last block a withdrawal was made
172         require(currentBlock > lastBlockWithdrawn, "current block must be one higher than last withdrawal");
173         _;
174     }
175 
176     modifier stakingEnabled(uint256 _numRTC) {
177         // make sure this contract can mint coins on the RTC token contract
178         require(canMint(), "staking contract is unable to mint tokens");
179         // make sure new stakes are allowed
180         require(newStakesAllowed, "new stakes are not allowed");
181         // make sure they are staking at least one RTC
182         require(_numRTC >= MINSTAKE, "specified stake is lower than minimum amount");
183         _;
184     }
185 
186     modifier onlyAdmin() {
187         require(msg.sender == admin, "sender is not admin");
188         _;
189     }
190 
191     constructor(address _admin) public {
192         require(TOKENADDRESS != address(0), "token address not set");
193         admin = _admin;
194     }
195 
196     /** @notice Used to disable new stakes from being made
197         * Only usable by contract admin
198      */
199     function disableNewStakes() public onlyAdmin returns (bool) {
200         newStakesAllowed = false;
201         return true;
202     }
203 
204     /** @notice Used to allow new stakes to be made
205         * @dev For this to be enabled, the RTC token contract must be configured properly
206      */
207     function allowNewStakes() public onlyAdmin returns (bool) {
208         newStakesAllowed = true;
209         require(RTI.stakeContractAddress() == address(this), "rtc token contract is not set to use this contract as the staking contract");
210         return true;
211     }
212 
213     /** @notice Used by a staker to claim currently staked coins
214         * @dev Can only be executed when at least one block has passed from the last execution
215         * @param _stakeNumber This is the particular stake to withdraw from
216      */
217     function mint(uint256 _stakeNumber) public validMint(_stakeNumber) returns (bool) {
218         // determine the amount of coins to be minted in this withdrawal
219         uint256 mintAmount = calculateMint(_stakeNumber);
220         // update current coins minted
221         stakes[msg.sender][_stakeNumber].coinsMinted = stakes[msg.sender][_stakeNumber].coinsMinted.add(mintAmount);
222         // update the last block a withdrawal was made at
223         stakes[msg.sender][_stakeNumber].lastBlockWithdrawn = block.number;
224         // emit an event
225         emit StakeRewardWithdrawn(msg.sender, _stakeNumber, mintAmount);
226         // mint the tokenz
227         require(RTI.mint(msg.sender, mintAmount), "token minting failed");
228         return true;
229     }
230 
231     /** @notice Used by a staker to withdraw their initial stake
232         * @dev Can only be executed after the specified block number, and unix timestamp has been passed
233         * @param _stakeNumber This is the particular stake to withdraw from
234      */
235     function withdrawInitialStake(uint256 _stakeNumber) public validInitialStakeRelease(_stakeNumber) returns (bool) {
236         // get the initial stake amount
237         uint256 initialStake = stakes[msg.sender][_stakeNumber].initialStake;
238         // de-activate the stake
239         stakes[msg.sender][_stakeNumber].state = StakeStateEnum.staked;
240         // decrease the total number of stakes
241         activeStakes = activeStakes.sub(1);
242         // reduce their internal RTC balance
243         internalRTCBalances[msg.sender] = internalRTCBalances[msg.sender].sub(initialStake);
244         // emit an event
245         emit InitialStakeWithdrawn(msg.sender, _stakeNumber, initialStake);
246         // transfer the tokenz
247         require(RTI.transfer(msg.sender, initialStake), "unable to transfer tokens likely due to incorrect balance");
248         return true;
249     }
250 
251     /** @notice This is used to deposit coins and start staking with at least one RTC
252         * @dev Staking must be enabled or this function will not execute
253         * @param _numRTC This is the number of RTC tokens to stake
254      */
255     function depositStake(uint256 _numRTC) public stakingEnabled(_numRTC) returns (bool) {
256         uint256 stakeCount = getStakeCount(msg.sender);
257 
258         // calculate the various stake parameters
259         (uint256 blockLocked, 
260         uint256 blockReleased, 
261         uint256 releaseDate, 
262         uint256 totalCoinsMinted,
263         uint256 rewardPerBlock) = calculateStake(_numRTC);
264 
265         // initialize this struct in memory
266         StakeStruct memory ss = StakeStruct({
267             initialStake: _numRTC,
268             blockLocked: blockLocked,
269             blockUnlocked: blockReleased,
270             releaseDate: releaseDate,
271             totalCoinsToMint: totalCoinsMinted,
272             coinsMinted: 0,
273             rewardPerBlock: rewardPerBlock,
274             lastBlockWithdrawn: blockLocked,
275             state: StakeStateEnum.staking
276         });
277 
278         // update the users list of stakes
279         stakes[msg.sender][stakeCount] = ss;
280         // update the users total stakes
281         numberOfStakes[msg.sender] = numberOfStakes[msg.sender].add(1);
282         // update their internal RTC balance
283         internalRTCBalances[msg.sender] = internalRTCBalances[msg.sender].add(_numRTC);
284         // increase the number of active stakes
285         activeStakes = activeStakes.add(1);
286         // emit an event
287         emit StakeDeposited(msg.sender, stakeCount, totalCoinsMinted, releaseDate, blockReleased);
288         // transfer tokens
289         require(RTI.transferFrom(msg.sender, address(this), _numRTC), "transfer from failed, likely needs approval");
290         return true;
291     }
292 
293 
294     // UTILITY FUNCTIONS //
295 
296     /** @notice This is a helper function used to calculate the parameters of a stake
297         * Will determine the block that the initial stake can be withdraw at
298         * Will determine the time that the initial stake can be withdrawn at
299         * Will determine the total number of RTC to be minted throughout hte stake
300         * Will determine how many RTC the stakee will be awarded per block
301         * @param _numRTC This is the number of RTC to be staked
302      */
303     function calculateStake(uint256 _numRTC) 
304         internal
305         view
306         returns (
307             uint256 blockLocked, 
308             uint256 blockReleased, 
309             uint256 releaseDate, 
310             uint256 totalCoinsMinted,
311             uint256 rewardPerBlock
312         ) 
313     {
314         // the block that the stake is being made at
315         blockLocked = block.number;
316         // the block at which the initial stake will be released
317         blockReleased = blockLocked.add(BLOCKHOLDPERIOD);
318         // the time at which the initial stake will be released
319         // please see comment at top of contract about why we consider it safe to use block times
320         // linter warnings are left enabled on purpose
321         releaseDate = now.add(BLOCKHOLDPERIOD.mul(BLOCKSEC));
322         // total coins that will be minted
323         totalCoinsMinted = _numRTC.mul(MULTIPLIER);
324         // make sure to scale down
325         totalCoinsMinted = totalCoinsMinted.div(1 ether);
326         // calculate the coins minted per block
327         rewardPerBlock = totalCoinsMinted.div(BLOCKHOLDPERIOD);
328     }
329 
330     /** @notice This is a helper function used to calculate how many coins will be awarded in a given internal
331         * @param _stakeNumber This is the particular stake to calculate from
332      */
333     function calculateMint(uint256 _stakeNumber)
334         internal
335         view
336         returns (uint256 reward)
337     {
338         // calculate how many blocks they can claim a stake for
339         uint256 currentBlock = calculateCurrentBlock(_stakeNumber);
340         //get the last block a withdrawal was made at
341         uint256 lastBlockWithdrawn = stakes[msg.sender][_stakeNumber].lastBlockWithdrawn;
342         // determine the number of blocks to generate a reward for
343         uint256 blocksToReward = currentBlock.sub(lastBlockWithdrawn);
344         // calculate the reward
345         reward = blocksToReward.mul(stakes[msg.sender][_stakeNumber].rewardPerBlock);
346         // get total number of coins to be minted
347         uint256 totalToMint = stakes[msg.sender][_stakeNumber].totalCoinsToMint;
348         // get current number of coins minted
349         uint256 currentCoinsMinted = stakes[msg.sender][_stakeNumber].coinsMinted;
350         // get the new numberof total coins to be minted
351         uint256 newCoinsMinted = currentCoinsMinted.add(reward);
352         // if for some reason more would be generated, prevent that from happening
353         if (newCoinsMinted > totalToMint) {
354             reward = newCoinsMinted.sub(totalToMint);
355         }
356     }
357 
358     /** @notice Allow us to transfer tokens that someone might've accidentally sent to this contract
359         @param _tokenAddress this is the address of the token contract
360         @param _recipient This is the address of the person receiving the tokens
361         @param _amount This is the amount of tokens to send
362      */
363     function transferForeignToken(
364         address _tokenAddress,
365         address _recipient,
366         uint256 _amount)
367         public
368         onlyAdmin
369         returns (bool)
370     {
371         require(_recipient != address(0), "recipient address can't be empty");
372         // don't allow us to transfer RTC tokens stored in this contract
373         require(_tokenAddress != TOKENADDRESS, "token can't be RTC");
374         ERC20Interface eI = ERC20Interface(_tokenAddress);
375         require(eI.transfer(_recipient, _amount), "token transfer failed");
376         emit ForeignTokenTransfer(msg.sender, _recipient, _amount);
377         return true;
378     }
379 
380     /** @notice This is a helper function used to calculate how many blocks to mint coins for
381         * @param _stakeNumber This is the stake to be used for calculations
382      */
383     function calculateCurrentBlock(uint256 _stakeNumber) internal view returns (uint256 currentBlock) {
384         currentBlock = block.number;
385         // if the current block is greater than the block at which coins can be unlocked at, 
386         // prevent them from generating more coins that allowed
387         if (currentBlock >= stakes[msg.sender][_stakeNumber].blockUnlocked) {
388             currentBlock = stakes[msg.sender][_stakeNumber].blockUnlocked;
389         }
390     }
391     
392     /** @notice This is a helper function used to get the total number of stakes a 
393         * @param _staker This is the address of the stakee
394      */
395     function getStakeCount(address _staker) internal view returns (uint256) {
396         return numberOfStakes[_staker];
397     }
398 
399     /** @notice This is a helper function that checks whether or not this contract can mint tokens
400         * @dev This should only ever be false under extreme circumstances such as a potential vulnerability
401      */
402     function canMint() public view returns (bool) {
403         require(RTI.stakeContractAddress() == address(this), "rtc token contract is not set to use this contract as the staking contract");
404         return true;
405     }
406 }