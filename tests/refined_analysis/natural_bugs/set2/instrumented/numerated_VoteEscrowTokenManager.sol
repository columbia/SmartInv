1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "../../refs/CoreRef.sol";
5 import "../../core/TribeRoles.sol";
6 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 
8 interface IVeToken {
9     function balanceOf(address) external view returns (uint256);
10 
11     function locked(address) external view returns (uint256);
12 
13     function create_lock(uint256 value, uint256 unlock_time) external;
14 
15     function increase_amount(uint256 value) external;
16 
17     function increase_unlock_time(uint256 unlock_time) external;
18 
19     function withdraw() external;
20 
21     function locked__end(address) external view returns (uint256);
22 
23     function checkpoint() external;
24 
25     function commit_smart_wallet_checker(address) external;
26 
27     function apply_smart_wallet_checker() external;
28 }
29 
30 /// @title Vote-escrowed Token Manager
31 /// Used to permanently lock tokens in a vote-escrow contract, and refresh
32 /// the lock duration as needed.
33 /// @author Fei Protocol
34 abstract contract VoteEscrowTokenManager is CoreRef {
35     // Events
36     event Lock(uint256 cummulativeTokensLocked, uint256 lockHorizon);
37     event Unlock(uint256 tokensUnlocked);
38 
39     /// @notice One week, in seconds. Vote-locking is rounded down to weeks.
40     uint256 private constant WEEK = 7 * 86400; // 1 week, in seconds
41 
42     /// @notice The lock duration of veTokens
43     uint256 public lockDuration;
44 
45     /// @notice The vote-escrowed token address
46     IVeToken public immutable veToken;
47 
48     /// @notice The token address
49     IERC20 public immutable liquidToken;
50 
51     /// @notice VoteEscrowTokenManager token Snapshot Delegator PCV Deposit constructor
52     /// @param _liquidToken the token to lock for vote-escrow
53     /// @param _veToken the vote-escrowed token used in governance
54     /// @param _lockDuration amount of time (in seconds) tokens will  be vote-escrowed for
55     constructor(
56         IERC20 _liquidToken,
57         IVeToken _veToken,
58         uint256 _lockDuration
59     ) {
60         liquidToken = _liquidToken;
61         veToken = _veToken;
62         lockDuration = _lockDuration;
63     }
64 
65     /// @notice Set the amount of time tokens will be vote-escrowed for in lock() calls
66     function setLockDuration(uint256 newLockDuration) external onlyTribeRole(TribeRoles.METAGOVERNANCE_TOKEN_STAKING) {
67         lockDuration = newLockDuration;
68     }
69 
70     /// @notice Deposit tokens to get veTokens. Set lock duration to lockDuration.
71     /// The only way to withdraw tokens will be to pause this contract
72     /// for lockDuration and then call exitLock().
73     function lock() external whenNotPaused onlyTribeRole(TribeRoles.METAGOVERNANCE_TOKEN_STAKING) {
74         uint256 tokenBalance = liquidToken.balanceOf(address(this));
75         uint256 locked = veToken.locked(address(this));
76         uint256 lockHorizon = ((block.timestamp + lockDuration) / WEEK) * WEEK;
77 
78         // First lock
79         if (tokenBalance != 0 && locked == 0) {
80             liquidToken.approve(address(veToken), tokenBalance);
81             veToken.create_lock(tokenBalance, lockHorizon);
82         }
83         // Increase amount of tokens locked & refresh duration to lockDuration
84         else if (tokenBalance != 0 && locked != 0) {
85             liquidToken.approve(address(veToken), tokenBalance);
86             veToken.increase_amount(tokenBalance);
87             if (veToken.locked__end(address(this)) != lockHorizon) {
88                 veToken.increase_unlock_time(lockHorizon);
89             }
90         }
91         // No additional tokens to lock, just refresh duration to lockDuration
92         else if (tokenBalance == 0 && locked != 0) {
93             veToken.increase_unlock_time(lockHorizon);
94         }
95         // If tokenBalance == 0 and locked == 0, there is nothing to do.
96 
97         emit Lock(tokenBalance + locked, lockHorizon);
98     }
99 
100     /// @notice Exit the veToken lock. For this function to be called and not
101     /// revert, tokens had to be locked previously, and the contract must have
102     /// been paused for lockDuration in order to prevent lock extensions
103     /// by calling lock(). This function will recover tokens on the contract,
104     /// which can then be moved by calling withdraw() as a PCVController if the
105     /// contract is also a PCVDeposit, for instance.
106     function exitLock() external onlyTribeRole(TribeRoles.METAGOVERNANCE_TOKEN_STAKING) {
107         veToken.withdraw();
108 
109         emit Unlock(liquidToken.balanceOf(address(this)));
110     }
111 
112     /// @notice returns total balance of tokens, vote-escrowed or liquid.
113     function _totalTokensManaged() internal view returns (uint256) {
114         return liquidToken.balanceOf(address(this)) + veToken.locked(address(this));
115     }
116 }
