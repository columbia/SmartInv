1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./SnapshotDelegatorPCVDeposit.sol";
5 import "./utils/VoteEscrowTokenManager.sol";
6 import "./utils/LiquidityGaugeManager.sol";
7 import "./utils/GovernorVoter.sol";
8 
9 /// @title 80-BAL-20-WETH BPT PCV Deposit
10 /// @author Fei Protocol
11 contract VeBalDelegatorPCVDeposit is
12     SnapshotDelegatorPCVDeposit,
13     VoteEscrowTokenManager,
14     LiquidityGaugeManager,
15     GovernorVoter
16 {
17     address public constant B_80BAL_20WETH = 0x5c6Ee304399DBdB9C8Ef030aB642B10820DB8F56;
18     address public constant VE_BAL = 0xC128a9954e6c874eA3d62ce62B468bA073093F25;
19     address public constant BALANCER_GAUGE_CONTROLLER = 0xC128468b7Ce63eA702C1f104D55A2566b13D3ABD;
20 
21     /// @notice veBAL token manager
22     /// @param _core Fei Core for reference
23     /// @param _initialDelegate initial delegate for snapshot votes
24     constructor(address _core, address _initialDelegate)
25         SnapshotDelegatorPCVDeposit(
26             _core,
27             IERC20(B_80BAL_20WETH), // token used in reporting
28             "balancer.eth", // initial snapshot spaceId
29             _initialDelegate
30         )
31         VoteEscrowTokenManager(
32             IERC20(B_80BAL_20WETH), // liquid token
33             IVeToken(VE_BAL), // vote-escrowed token
34             365 * 86400 // vote-escrow time = 1 year
35         )
36         LiquidityGaugeManager(BALANCER_GAUGE_CONTROLLER)
37         GovernorVoter()
38     {}
39 
40     /// @notice returns total balance of PCV in the Deposit
41     function balance() public view override returns (uint256) {
42         return _totalTokensManaged(); // liquid and vote-escrowed tokens
43     }
44 }
