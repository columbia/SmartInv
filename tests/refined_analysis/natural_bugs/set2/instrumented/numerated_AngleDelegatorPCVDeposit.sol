1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./SnapshotDelegatorPCVDeposit.sol";
5 import "./utils/VoteEscrowTokenManager.sol";
6 import "./utils/LiquidityGaugeManager.sol";
7 import "./utils/GovernorVoter.sol";
8 
9 /// @title ANGLE Token PCV Deposit
10 /// @author Fei Protocol
11 contract AngleDelegatorPCVDeposit is
12     SnapshotDelegatorPCVDeposit,
13     VoteEscrowTokenManager,
14     LiquidityGaugeManager,
15     GovernorVoter
16 {
17     address private constant ANGLE_TOKEN = 0x31429d1856aD1377A8A0079410B297e1a9e214c2;
18     address private constant ANGLE_VE_TOKEN = 0x0C462Dbb9EC8cD1630f1728B2CFD2769d09f0dd5;
19     address private constant ANGLE_GAUGE_MANAGER = 0x9aD7e7b0877582E14c17702EecF49018DD6f2367;
20     bytes32 private constant ANGLE_SNAPSHOT_SPACE = "anglegovernance.eth";
21 
22     /// @notice ANGLE token manager
23     /// @param _core Fei Core for reference
24     /// @param _initialDelegate initial delegate for snapshot votes
25     constructor(address _core, address _initialDelegate)
26         SnapshotDelegatorPCVDeposit(
27             _core,
28             IERC20(ANGLE_TOKEN), // token used in reporting
29             ANGLE_SNAPSHOT_SPACE, // snapshot spaceId
30             _initialDelegate
31         )
32         VoteEscrowTokenManager(
33             IERC20(ANGLE_TOKEN), // liquid token
34             IVeToken(ANGLE_VE_TOKEN), // vote-escrowed token
35             4 * 365 * 86400 // vote-escrow time = 4 years
36         )
37         LiquidityGaugeManager(ANGLE_GAUGE_MANAGER)
38         GovernorVoter()
39     {}
40 
41     /// @notice returns total balance of PCV in the Deposit
42     function balance() public view override returns (uint256) {
43         return _totalTokensManaged(); // liquid and vote-escrowed tokens
44     }
45 
46     /// @notice returns the token address to be staked in the given gauge
47     function _tokenStakedInGauge(address gaugeAddress) internal view override returns (address) {
48         return ILiquidityGauge(gaugeAddress).staking_token();
49     }
50 }
