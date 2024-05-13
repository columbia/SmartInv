1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import './managers/ISherDistributionManager.sol';
10 import './managers/ISherlockProtocolManager.sol';
11 import './managers/ISherlockClaimManager.sol';
12 import './managers/IStrategyManager.sol';
13 
14 /// @title Sherlock core interface for governance
15 /// @author Evert Kors
16 interface ISherlockGov {
17   event ClaimPayout(address receiver, uint256 amount);
18   event YieldStrategyUpdateWithdrawAllError(bytes error);
19   event YieldStrategyUpdated(IStrategyManager previous, IStrategyManager current);
20   event ProtocolManagerUpdated(ISherlockProtocolManager previous, ISherlockProtocolManager current);
21   event ClaimManagerUpdated(ISherlockClaimManager previous, ISherlockClaimManager current);
22   event NonStakerAddressUpdated(address previous, address current);
23   event SherDistributionManagerUpdated(
24     ISherDistributionManager previous,
25     ISherDistributionManager current
26   );
27 
28   event StakingPeriodEnabled(uint256 period);
29 
30   event StakingPeriodDisabled(uint256 period);
31 
32   /// @notice Allows stakers to stake for `_period` of time
33   /// @param _period Period of time, in seconds,
34   /// @dev should revert if already enabled
35   function enableStakingPeriod(uint256 _period) external;
36 
37   /// @notice Disallow stakers to stake for `_period` of time
38   /// @param _period Period of time, in seconds,
39   /// @dev should revert if already disabled
40   function disableStakingPeriod(uint256 _period) external;
41 
42   /// @notice View if `_period` is a valid period
43   /// @return Boolean indicating if period is valid
44   function stakingPeriods(uint256 _period) external view returns (bool);
45 
46   /// @notice Update SHER distribution manager contract
47   /// @param _sherDistributionManager New adddress of the manager
48   function updateSherDistributionManager(ISherDistributionManager _sherDistributionManager)
49     external;
50 
51   /// @notice Deletes the SHER distribution manager altogether (if Sherlock decides to no longer pay out SHER rewards)
52   function removeSherDistributionManager() external;
53 
54   /// @notice Read SHER distribution manager
55   /// @return Address of current SHER distribution manager
56   function sherDistributionManager() external view returns (ISherDistributionManager);
57 
58   /// @notice Update address eligible for non staker rewards from protocol premiums
59   /// @param _nonStakers Address eligible for non staker rewards
60   function updateNonStakersAddress(address _nonStakers) external;
61 
62   /// @notice View current non stakers address
63   /// @return Current non staker address
64   /// @dev Is able to pull funds out of the contract
65   function nonStakersAddress() external view returns (address);
66 
67   /// @notice View current address able to manage protocols
68   /// @return Protocol manager implemenation
69   function sherlockProtocolManager() external view returns (ISherlockProtocolManager);
70 
71   /// @notice Transfer protocol manager implementation address
72   /// @param _protocolManager new implementation address
73   function updateSherlockProtocolManager(ISherlockProtocolManager _protocolManager) external;
74 
75   /// @notice View current address able to pull payouts
76   /// @return Address able to pull payouts
77   function sherlockClaimManager() external view returns (ISherlockClaimManager);
78 
79   /// @notice Transfer claim manager role to different address
80   /// @param _claimManager New address of claim manager
81   function updateSherlockClaimManager(ISherlockClaimManager _claimManager) external;
82 
83   /// @notice Update yield strategy
84   /// @param _yieldStrategy New address of the strategy
85   /// @dev try a yieldStrategyWithdrawAll() on old, ignore failure
86   function updateYieldStrategy(IStrategyManager _yieldStrategy) external;
87 
88   /// @notice Update yield strategy ignoring current state
89   /// @param _yieldStrategy New address of the strategy
90   /// @dev tries a yieldStrategyWithdrawAll() on old strategy, ignore failure
91   function updateYieldStrategyForce(IStrategyManager _yieldStrategy) external;
92 
93   /// @notice Read current strategy
94   /// @return Address of current strategy
95   /// @dev can never be address(0)
96   function yieldStrategy() external view returns (IStrategyManager);
97 }
