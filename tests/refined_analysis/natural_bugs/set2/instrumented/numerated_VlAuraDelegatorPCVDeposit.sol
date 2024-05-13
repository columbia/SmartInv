1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./IAuraLocker.sol";
5 import "../core/TribeRoles.sol";
6 import "./DelegatorPCVDeposit.sol";
7 
8 interface IAuraMerkleDrop {
9     function claim(
10         bytes32[] calldata _proof,
11         uint256 _amount,
12         bool _lock
13     ) external returns (bool);
14 }
15 
16 /// @title Vote-locked AURA PCVDeposit
17 /// This contract is a derivative of the DelegatorPCVDeposit contract, that performs an
18 /// on-chain delegation. This contract is meant to hold AURA and vlAURA tokens, and allow
19 /// locking of AURA to vlAURA and renew vlAURA locks, or exit vlAURA locks to get back
20 /// liquid AURA. This contract can also claim vlAURA rewards.
21 /// The first version of this contract also allows claiming of the AURA airdrop.
22 /// @author eswak
23 contract VlAuraDelegatorPCVDeposit is DelegatorPCVDeposit {
24     using SafeERC20 for IERC20;
25 
26     address public aura;
27     address public auraLocker;
28     address public auraMerkleDrop;
29 
30     /// @notice constructor
31     /// @param _core Fei Core for reference
32     constructor(address _core)
33         DelegatorPCVDeposit(
34             _core,
35             address(0), // token
36             address(0) // initialDelegate
37         )
38     {}
39 
40     // At deploy time, Aura Protocol wasn't live yet, so we need to set the
41     // contract addresses manually, not in the constructor.
42     function initialize(
43         address _aura,
44         address _auraLocker,
45         address _auraMerkleDrop
46     ) external {
47         require(
48             aura == address(0) ||
49                 auraLocker == address(0) ||
50                 auraMerkleDrop == address(0) ||
51                 address(token) == address(0),
52             "initialized"
53         );
54 
55         aura = _aura;
56         auraLocker = _auraLocker;
57         auraMerkleDrop = _auraMerkleDrop;
58         token = ERC20Votes(_auraLocker);
59     }
60 
61     /// @notice noop, vlAURA can't be transferred.
62     /// wait for lock expiry, and call withdrawERC20 on AURA.
63     function withdraw(address, uint256) external override {}
64 
65     /// @notice returns the balance of locked + unlocked
66     function balance() public view virtual override returns (uint256) {
67         return IERC20(aura).balanceOf(address(this)) + IERC20(auraLocker).balanceOf(address(this));
68     }
69 
70     /// @notice claim AURA airdrop and vote-lock it for 16 weeks
71     /// this function is not access controlled & can be called by anyone.
72     function claimAirdropAndLock(bytes32[] calldata _proof, uint256 _amount) external returns (bool) {
73         return IAuraMerkleDrop(auraMerkleDrop).claim(_proof, _amount, true);
74     }
75 
76     /// @notice lock AURA held on this contract to vlAURA
77     function lock() external whenNotPaused onlyTribeRole(TribeRoles.METAGOVERNANCE_TOKEN_STAKING) {
78         uint256 amount = IERC20(aura).balanceOf(address(this));
79         IERC20(aura).safeApprove(auraLocker, amount);
80         IAuraLocker(auraLocker).lock(address(this), amount);
81     }
82 
83     /// @notice refresh lock after it has expired
84     function relock() external whenNotPaused onlyTribeRole(TribeRoles.METAGOVERNANCE_TOKEN_STAKING) {
85         IAuraLocker(auraLocker).processExpiredLocks(true);
86     }
87 
88     /// @notice exit lock after it has expired
89     function unlock() external whenNotPaused onlyTribeRole(TribeRoles.METAGOVERNANCE_TOKEN_STAKING) {
90         IAuraLocker(auraLocker).processExpiredLocks(false);
91     }
92 
93     /// @notice emergency withdraw if system is shut down
94     function emergencyWithdraw() external whenNotPaused onlyTribeRole(TribeRoles.METAGOVERNANCE_TOKEN_STAKING) {
95         IAuraLocker(auraLocker).emergencyWithdraw();
96     }
97 
98     /// @notice get rewards & stake them (rewards claiming is permissionless)
99     function getReward() external {
100         IAuraLocker(auraLocker).getReward(address(this), true);
101     }
102 }
