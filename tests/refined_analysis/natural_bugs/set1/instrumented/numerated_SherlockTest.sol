1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '../Sherlock.sol';
10 
11 /// @notice this contract is used for testing to view all storage variables
12 contract SherlockTest is Sherlock {
13   constructor(
14     IERC20 _token,
15     IERC20 _sher,
16     string memory _name,
17     string memory _symbol,
18     IStrategyManager _strategy,
19     ISherDistributionManager _sherDistributionManager,
20     address _nonStakersAddress,
21     ISherlockProtocolManager _sherlockProtocolManager,
22     ISherlockClaimManager _sherlockClaimManager,
23     uint256[] memory _initialPeriods
24   )
25     Sherlock(
26       _token,
27       _sher,
28       _name,
29       _symbol,
30       _strategy,
31       _sherDistributionManager,
32       _nonStakersAddress,
33       _sherlockProtocolManager,
34       _sherlockClaimManager,
35       _initialPeriods
36     )
37   {}
38 
39   function viewStakeShares(uint256 _id) external view returns (uint256) {
40     return stakeShares[_id];
41   }
42 
43   function viewTotalStakeShares() external view returns (uint256) {
44     return totalStakeShares;
45   }
46 
47   function transfer(address _receiver, uint256 _amount) external {
48     require(token.transfer(_receiver, _amount), 'F');
49   }
50 }
