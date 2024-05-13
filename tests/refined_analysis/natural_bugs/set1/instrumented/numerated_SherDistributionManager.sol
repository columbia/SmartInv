1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '@openzeppelin/contracts/utils/math/Math.sol';
10 
11 import './Manager.sol';
12 import '../interfaces/managers/ISherDistributionManager.sol';
13 
14 // This contract contains logic for calculating and sending SHER tokens to stakers
15 // The idea of the Kors curve is that we pay max SHER tokens to stakers up until a certain TVL (i.e. $100M)
16 // Then we pay fewer and fewer SHER tokens to stakers as the TVL climbs (linear relationship)
17 // Until finally we pay 0 SHER tokens out to stakers who stake above a certain TVL (i.e. $600M)
18 
19 /// @dev expects 6 decimals input tokens
20 contract SherDistributionManager is ISherDistributionManager, Manager {
21   using SafeERC20 for IERC20;
22 
23   uint256 internal constant DECIMALS = 10**6;
24 
25   // The TVL at which max SHER rewards STOP i.e. 100M USDC
26   uint256 internal immutable maxRewardsEndTVL;
27 
28   // The TVL at which SHER rewards stop entirely i.e. 600M USDC
29   uint256 internal immutable zeroRewardsStartTVL;
30 
31   // The SHER tokens paid per USDC staked per second at the max rate
32   uint256 internal immutable maxRewardsRate;
33 
34   // SHER token contract address
35   IERC20 public immutable sher;
36 
37   /// @dev With `_maxRewardsRate` being 10**18, 1 USDC == 1 SHER per second (on flat part of curve)
38   constructor(
39     uint256 _maxRewardsEndTVL,
40     uint256 _zeroRewardsStartTVL,
41     uint256 _maxRewardsRate,
42     IERC20 _sher
43   ) {
44     if (_maxRewardsEndTVL >= _zeroRewardsStartTVL) revert InvalidArgument();
45     if (_maxRewardsRate == 0) revert ZeroArgument();
46     if (address(_sher) == address(0)) revert ZeroArgument();
47 
48     maxRewardsEndTVL = _maxRewardsEndTVL;
49     zeroRewardsStartTVL = _zeroRewardsStartTVL;
50     maxRewardsRate = _maxRewardsRate;
51     sher = _sher;
52 
53     emit Initialized(_maxRewardsEndTVL, _zeroRewardsStartTVL, _maxRewardsRate);
54   }
55 
56   // This function is called (by core Sherlock contract) as soon as a staker stakes
57   // Calculates the SHER tokens owed to the stake, then transfers the SHER to the Sherlock core contract
58   // Staker won't actually receive these SHER tokens until the lockup has expired though
59   /// @notice Caller will receive `_sher` SHER tokens based on `_amount` and `_period`
60   /// @param _amount Amount of tokens (in USDC) staked
61   /// @param _period Period of time for stake, in seconds
62   /// @param _id ID for this NFT position
63   /// @param _receiver Address that will be linked to this position
64   /// @return _sher Amount of SHER tokens sent to Sherlock core contract
65   /// @dev Calling contract will depend on before + after balance diff and return value
66   /// @dev INCLUDES stake in calculation, function expects the `_amount` to be deposited already
67   /// @dev If tvl=50 and amount=50, this means it is calculating SHER rewards for the first 50 tokens going in
68   /// @dev Doesn't include whenNotPaused modifier as it's onlySherlockCore where pause is captured
69   /// @dev `_id` and `_receiver` are unused in this implementation
70   function pullReward(
71     uint256 _amount,
72     uint256 _period,
73     uint256 _id,
74     address _receiver
75   ) external override onlySherlockCore returns (uint256 _sher) {
76     // Uses calcReward() to get the SHER tokens owed to this stake
77     // Subtracts the amount from the total token balance to get the pre-stake USDC TVL
78     _sher = calcReward(sherlockCore.totalTokenBalanceStakers() - _amount, _amount, _period);
79     // Sends the SHER tokens to the core Sherlock contract where they are held until the unlock period for the stake expires
80     if (_sher != 0) sher.safeTransfer(msg.sender, _sher);
81   }
82 
83   /// @notice Calculates how many `_sher` SHER tokens are owed to a stake position based on `_amount` and `_period`
84   /// @param _tvl TVL to use for reward calculation (pre-stake TVL)
85   /// @param _amount Amount of tokens (USDC) staked
86   /// @param _period Stake period (in seconds)
87   /// @return _sher Amount of SHER tokens owed to this stake position
88   /// @dev EXCLUDES `_amount` of stake, this will be added on top of TVL (_tvl is excluding _amount)
89   /// @dev If tvl=0 and amount=50, it would calculate for the first 50 tokens going in (different from pullReward())
90   function calcReward(
91     uint256 _tvl,
92     uint256 _amount,
93     uint256 _period
94   ) public view override returns (uint256 _sher) {
95     if (_amount == 0) return 0;
96 
97     // Figures out how much of this stake should receive max rewards
98     // _tvl is the pre-stake TVL (call it $80M) and maxRewardsEndTVL could be $100M
99     // If maxRewardsEndTVL is bigger than the pre-stake TVL, then some or all of the stake could receive max rewards
100     // In this case, the amount of the stake to receive max rewards is maxRewardsEndTVL - _tvl
101     // Otherwise, the pre-stake TVL could be bigger than the maxRewardsEndTVL, in which case 0 max rewards are available
102     uint256 maxRewardsAvailable = maxRewardsEndTVL > _tvl ? maxRewardsEndTVL - _tvl : 0;
103 
104     // Same logic as above for the TVL at which all SHER rewards end
105     // If the pre-stake TVL is lower than the zeroRewardsStartTVL, then SHER rewards are still available to all or part of the stake
106     // The starting point of the slopeRewards is calculated using max(maxRewardsEndTVL, tvl).
107     // The starting point is either the beginning of the slope --> maxRewardsEndTVL
108     // Or it's the current amount of TVL in case the point on the curve is already on the slope.
109     uint256 slopeRewardsAvailable = zeroRewardsStartTVL > _tvl
110       ? zeroRewardsStartTVL - Math.max(maxRewardsEndTVL, _tvl)
111       : 0;
112 
113     // If there are some max rewards available...
114     if (maxRewardsAvailable != 0) {
115       // And if the entire stake is still within the maxRewardsAvailable amount
116       if (_amount <= maxRewardsAvailable) {
117         // Then the entire stake amount should accrue max SHER rewards
118         return (_amount * maxRewardsRate * _period) / DECIMALS;
119       } else {
120         // Otherwise, the stake takes all the maxRewardsAvailable left and the calc continues
121         // We add the maxRewardsAvailable amount to the TVL (now _tvl should be equal to maxRewardsEndTVL)
122         _tvl += maxRewardsAvailable;
123         // We subtract the amount of the stake that received max rewards
124         _amount -= maxRewardsAvailable;
125 
126         // We accrue the max rewards available at the max rewards rate for the stake period to the SHER balance
127         // This could be: $20M of maxRewardsAvailable which gets paid .01 SHER per second (max rate) for 3 months worth of seconds
128         // Calculation continues after this
129         _sher = (maxRewardsAvailable * maxRewardsRate * _period) / DECIMALS;
130       }
131     }
132 
133     // If there are SHER rewards still available (we didn't surpass zeroRewardsStartTVL)...
134     if (slopeRewardsAvailable != 0) {
135       // If the amount left is greater than the slope rewards available, we take all the remaining slope rewards
136       if (_amount > slopeRewardsAvailable) _amount = slopeRewardsAvailable;
137 
138       // We take the average position on the slope that the stake amount occupies
139       // This excludes any stake amount <= maxRewardsEndTVL or >= zeroRewardsStartTVL_
140       // e.g. if tvl = 100m (and maxRewardsEndTVL is $100M), 50m is deposited, point at 125m is taken
141       uint256 position = _tvl + (_amount / 2);
142 
143       // Calc SHER rewards based on position on the curve
144       // (zeroRewardsStartTVL - position) divided by (zeroRewardsStartTVL - maxRewardsEndTVL) gives the % of max rewards the amount should get
145       // Multiply this percentage by maxRewardsRate to get the rate at which this position should accrue SHER
146       // Multiply by the _amount to get the full SHER amount earned per second
147       // Multiply by the _period to get the total SHER amount owed to this position
148       _sher +=
149         (((zeroRewardsStartTVL - position) * _amount * maxRewardsRate * _period) /
150           (zeroRewardsStartTVL - maxRewardsEndTVL)) /
151         DECIMALS;
152     }
153   }
154 
155   /// @notice Function used to check if this is the current active distribution manager
156   /// @return Boolean indicating it's active
157   /// @dev If inactive the owner can pull all ERC20s and ETH
158   /// @dev Will be checked by calling the sherlock contract
159   function isActive() public view override returns (bool) {
160     return address(sherlockCore.sherDistributionManager()) == address(this);
161   }
162 
163   // Only contract owner can call this
164   // Sends all specified tokens in this contract to the receiver's address (as well as ETH)
165   function sweep(address _receiver, IERC20[] memory _extraTokens) external onlyOwner {
166     if (_receiver == address(0)) revert ZeroArgument();
167     // This contract must NOT be the current assigned distribution manager contract
168     if (isActive()) revert InvalidConditions();
169     // Executes the sweep for ERC-20s specified in _extraTokens as well as for ETH
170     _sweep(_receiver, _extraTokens);
171   }
172 }
