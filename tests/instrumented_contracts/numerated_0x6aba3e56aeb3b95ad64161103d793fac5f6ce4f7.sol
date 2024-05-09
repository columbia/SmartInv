1 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.23;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
19 
20 pragma solidity ^0.4.23;
21 
22 
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29   function allowance(address owner, address spender)
30     public view returns (uint256);
31 
32   function transferFrom(address from, address to, uint256 value)
33     public returns (bool);
34 
35   function approve(address spender, uint256 value) public returns (bool);
36   event Approval(
37     address indexed owner,
38     address indexed spender,
39     uint256 value
40   );
41 }
42 
43 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
44 
45 pragma solidity ^0.4.23;
46 
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53 
54   /**
55   * @dev Multiplies two numbers, throws on overflow.
56   */
57   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
58     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
59     // benefit is lost if 'b' is also tested.
60     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
61     if (a == 0) {
62       return 0;
63     }
64 
65     c = a * b;
66     assert(c / a == b);
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers, truncating the quotient.
72   */
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     // uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return a / b;
78   }
79 
80   /**
81   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     assert(b <= a);
85     return a - b;
86   }
87 
88   /**
89   * @dev Adds two numbers, throws on overflow.
90   */
91   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
92     c = a + b;
93     assert(c >= a);
94     return c;
95   }
96 }
97 
98 // File: contracts/ERC900/ERC900.sol
99 
100 pragma solidity ^0.4.24;
101 
102 
103 /**
104  * @title ERC900 Simple Staking Interface
105  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
106  */
107 contract ERC900 {
108   event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
109   event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
110 
111   function stake(uint256 amount, bytes data) public;
112   function stakeFor(address user, uint256 amount, bytes data) public;
113   function unstake(uint256 amount, bytes data) public;
114   function totalStakedFor(address addr) public view returns (uint256);
115   function totalStaked() public view returns (uint256);
116   function token() public view returns (address);
117   function supportsHistory() public pure returns (bool);
118 
119   // NOTE: Not implementing the optional functions
120   // function lastStakedFor(address addr) public view returns (uint256);
121   // function totalStakedForAt(address addr, uint256 blockNumber) public view returns (uint256);
122   // function totalStakedAt(uint256 blockNumber) public view returns (uint256);
123 }
124 
125 // File: contracts/ERC900/ERC900BasicStakeContract.sol
126 
127 /* solium-disable security/no-block-members */
128 pragma solidity ^0.4.24;
129 
130 
131 
132 
133 
134 /**
135  * @title ERC900 Simple Staking Interface basic implementation
136  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
137  */
138 contract ERC900BasicStakeContract is ERC900 {
139   // @TODO: deploy this separately so we don't have to deploy it multiple times for each contract
140   using SafeMath for uint256;
141 
142   // Token used for staking
143   ERC20 stakingToken;
144 
145   // The default duration of stake lock-in (in seconds)
146   uint256 public defaultLockInDuration;
147 
148   // To save on gas, rather than create a separate mapping for totalStakedFor & personalStakes,
149   //  both data structures are stored in a single mapping for a given addresses.
150   //
151   // It's possible to have a non-existing personalStakes, but have tokens in totalStakedFor
152   //  if other users are staking on behalf of a given address.
153   mapping (address => StakeContract) public stakeHolders;
154 
155   // Struct for personal stakes (i.e., stakes made by this address)
156   // unlockedTimestamp - when the stake unlocks (in seconds since Unix epoch)
157   // actualAmount - the amount of tokens in the stake
158   // stakedFor - the address the stake was staked for
159   struct Stake {
160     uint256 unlockedTimestamp;
161     uint256 actualAmount;
162     address stakedFor;
163   }
164 
165   // Struct for all stake metadata at a particular address
166   // totalStakedFor - the number of tokens staked for this address
167   // personalStakeIndex - the index in the personalStakes array.
168   // personalStakes - append only array of stakes made by this address
169   // exists - whether or not there are stakes that involve this address
170   struct StakeContract {
171     uint256 totalStakedFor;
172 
173     uint256 personalStakeIndex;
174 
175     Stake[] personalStakes;
176 
177     bool exists;
178   }
179 
180   /**
181    * @dev Modifier that checks that this contract can transfer tokens from the
182    *  balance in the stakingToken contract for the given address.
183    * @dev This modifier also transfers the tokens.
184    * @param _address address to transfer tokens from
185    * @param _amount uint256 the number of tokens
186    */
187   modifier canStake(address _address, uint256 _amount) {
188     require(
189       stakingToken.transferFrom(_address, this, _amount),
190       "Stake required");
191 
192     _;
193   }
194 
195   /**
196    * @dev Constructor function
197    * @param _stakingToken ERC20 The address of the token contract used for staking
198    */
199   constructor(ERC20 _stakingToken) public {
200     stakingToken = _stakingToken;
201   }
202 
203   /**
204    * @dev Returns the timestamps for when active personal stakes for an address will unlock
205    * @dev These accessors functions are needed until https://github.com/ethereum/web3.js/issues/1241 is solved
206    * @param _address address that created the stakes
207    * @return uint256[] array of timestamps
208    */
209   function getPersonalStakeUnlockedTimestamps(address _address) external view returns (uint256[]) {
210     uint256[] memory timestamps;
211     (timestamps,,) = getPersonalStakes(_address);
212 
213     return timestamps;
214   }
215 
216   /**
217    * @dev Returns the stake actualAmount for active personal stakes for an address
218    * @dev These accessors functions are needed until https://github.com/ethereum/web3.js/issues/1241 is solved
219    * @param _address address that created the stakes
220    * @return uint256[] array of actualAmounts
221    */
222   function getPersonalStakeActualAmounts(address _address) external view returns (uint256[]) {
223     uint256[] memory actualAmounts;
224     (,actualAmounts,) = getPersonalStakes(_address);
225 
226     return actualAmounts;
227   }
228 
229   /**
230    * @dev Returns the addresses that each personal stake was created for by an address
231    * @dev These accessors functions are needed until https://github.com/ethereum/web3.js/issues/1241 is solved
232    * @param _address address that created the stakes
233    * @return address[] array of amounts
234    */
235   function getPersonalStakeForAddresses(address _address) external view returns (address[]) {
236     address[] memory stakedFor;
237     (,,stakedFor) = getPersonalStakes(_address);
238 
239     return stakedFor;
240   }
241 
242   /**
243    * @notice Stakes a certain amount of tokens, this MUST transfer the given amount from the user
244    * @notice MUST trigger Staked event
245    * @param _amount uint256 the amount of tokens to stake
246    * @param _data bytes optional data to include in the Stake event
247    */
248   function stake(uint256 _amount, bytes _data) public {
249     createStake(
250       msg.sender,
251       _amount,
252       defaultLockInDuration,
253       _data);
254   }
255 
256   /**
257    * @notice Stakes a certain amount of tokens, this MUST transfer the given amount from the caller
258    * @notice MUST trigger Staked event
259    * @param _user address the address the tokens are staked for
260    * @param _amount uint256 the amount of tokens to stake
261    * @param _data bytes optional data to include in the Stake event
262    */
263   function stakeFor(address _user, uint256 _amount, bytes _data) public {
264     createStake(
265       _user,
266       _amount,
267       defaultLockInDuration,
268       _data);
269   }
270 
271   /**
272    * @notice Unstakes a certain amount of tokens, this SHOULD return the given amount of tokens to the user, if unstaking is currently not possible the function MUST revert
273    * @notice MUST trigger Unstaked event
274    * @dev Unstaking tokens is an atomic operation—either all of the tokens in a stake, or none of the tokens.
275    * @dev Users can only unstake a single stake at a time, it is must be their oldest active stake. Upon releasing that stake, the tokens will be
276    *  transferred back to their account, and their personalStakeIndex will increment to the next active stake.
277    * @param _amount uint256 the amount of tokens to unstake
278    * @param _data bytes optional data to include in the Unstake event
279    */
280   function unstake(uint256 _amount, bytes _data) public {
281     withdrawStake(
282       _amount,
283       _data);
284   }
285 
286   /**
287    * @notice Returns the current total of tokens staked for an address
288    * @param _address address The address to query
289    * @return uint256 The number of tokens staked for the given address
290    */
291   function totalStakedFor(address _address) public view returns (uint256) {
292     return stakeHolders[_address].totalStakedFor;
293   }
294 
295   /**
296    * @notice Returns the current total of tokens staked
297    * @return uint256 The number of tokens staked in the contract
298    */
299   function totalStaked() public view returns (uint256) {
300     return stakingToken.balanceOf(this);
301   }
302 
303   /**
304    * @notice Address of the token being used by the staking interface
305    * @return address The address of the ERC20 token used for staking
306    */
307   function token() public view returns (address) {
308     return stakingToken;
309   }
310 
311   /**
312    * @notice MUST return true if the optional history functions are implemented, otherwise false
313    * @dev Since we don't implement the optional interface, this always returns false
314    * @return bool Whether or not the optional history functions are implemented
315    */
316   function supportsHistory() public pure returns (bool) {
317     return false;
318   }
319 
320   /**
321    * @dev Helper function to get specific properties of all of the personal stakes created by an address
322    * @param _address address The address to query
323    * @return (uint256[], uint256[], address[])
324    *  timestamps array, actualAmounts array, stakedFor array
325    */
326   function getPersonalStakes(
327     address _address
328   )
329     public
330     view
331     returns(uint256[], uint256[], address[])
332   {
333     StakeContract storage stakeContract = stakeHolders[_address];
334 
335     uint256 arraySize = stakeContract.personalStakes.length - stakeContract.personalStakeIndex;
336     uint256[] memory unlockedTimestamps = new uint256[](arraySize);
337     uint256[] memory actualAmounts = new uint256[](arraySize);
338     address[] memory stakedFor = new address[](arraySize);
339 
340     for (uint256 i = stakeContract.personalStakeIndex; i < stakeContract.personalStakes.length; i++) {
341       uint256 index = i - stakeContract.personalStakeIndex;
342       unlockedTimestamps[index] = stakeContract.personalStakes[i].unlockedTimestamp;
343       actualAmounts[index] = stakeContract.personalStakes[i].actualAmount;
344       stakedFor[index] = stakeContract.personalStakes[i].stakedFor;
345     }
346 
347     return (
348       unlockedTimestamps,
349       actualAmounts,
350       stakedFor
351     );
352   }
353 
354   /**
355    * @dev Helper function to create stakes for a given address
356    * @param _address address The address the stake is being created for
357    * @param _amount uint256 The number of tokens being staked
358    * @param _lockInDuration uint256 The duration to lock the tokens for
359    * @param _data bytes optional data to include in the Stake event
360    */
361   function createStake(
362     address _address,
363     uint256 _amount,
364     uint256 _lockInDuration,
365     bytes _data
366   )
367     internal
368     canStake(msg.sender, _amount)
369   {
370     require(
371       _amount > 0,
372       "Stake amount has to be greater than 0!");
373     if (!stakeHolders[msg.sender].exists) {
374       stakeHolders[msg.sender].exists = true;
375     }
376 
377     stakeHolders[_address].totalStakedFor = stakeHolders[_address].totalStakedFor.add(_amount);
378     stakeHolders[msg.sender].personalStakes.push(
379       Stake(
380         block.timestamp.add(_lockInDuration),
381         _amount,
382         _address)
383       );
384 
385     emit Staked(
386       _address,
387       _amount,
388       totalStakedFor(_address),
389       _data);
390   }
391 
392   /**
393    * @dev Helper function to withdraw stakes for the msg.sender
394    * @param _amount uint256 The amount to withdraw. MUST match the stake amount for the
395    *  stake at personalStakeIndex.
396    * @param _data bytes optional data to include in the Unstake event
397    */
398   function withdrawStake(
399     uint256 _amount,
400     bytes _data
401   )
402     internal
403   {
404     Stake storage personalStake = stakeHolders[msg.sender].personalStakes[stakeHolders[msg.sender].personalStakeIndex];
405 
406     // Check that the current stake has unlocked & matches the unstake amount
407     require(
408       personalStake.unlockedTimestamp <= block.timestamp,
409       "The current stake hasn't unlocked yet");
410 
411     require(
412       personalStake.actualAmount == _amount,
413       "The unstake amount does not match the current stake");
414 
415     // Transfer the staked tokens from this contract back to the sender
416     // Notice that we are using transfer instead of transferFrom here, so
417     //  no approval is needed beforehand.
418     require(
419       stakingToken.transfer(msg.sender, _amount),
420       "Unable to withdraw stake");
421 
422     stakeHolders[personalStake.stakedFor].totalStakedFor = stakeHolders[personalStake.stakedFor]
423       .totalStakedFor.sub(personalStake.actualAmount);
424 
425     personalStake.actualAmount = 0;
426     stakeHolders[msg.sender].personalStakeIndex++;
427 
428     emit Unstaked(
429       personalStake.stakedFor,
430       _amount,
431       totalStakedFor(personalStake.stakedFor),
432       _data);
433   }
434 }
435 
436 // File: contracts/ERC900/BasicStakingContract.sol
437 
438 pragma solidity ^0.4.24;
439 
440 
441 
442 /**
443  * @title BasicStakingContract
444  */
445 contract BasicStakingContract is ERC900BasicStakeContract {
446   /**
447    * @dev Constructor function
448    * @param _stakingToken ERC20 The address of the token used for staking
449    * @param _lockInDuration uint256 The duration (in seconds) that stakes are required to be locked for
450    */
451   constructor(
452     ERC20 _stakingToken,
453     uint256 _lockInDuration
454   )
455     public
456     ERC900BasicStakeContract(_stakingToken)
457   {
458     defaultLockInDuration = _lockInDuration;
459   }
460 }