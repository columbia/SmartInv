1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 /// @title IPCVGuardian
5 /// @notice an interface for defining how the PCVGuardian functions
6 /// @dev any implementation of this contract should be granted the roles of Guardian and PCVController in order to work correctly
7 interface IPCVGuardian {
8     // ---------- Events ----------
9     event SafeAddressAdded(address indexed safeAddress);
10 
11     event SafeAddressRemoved(address indexed safeAddress);
12 
13     event PCVGuardianWithdrawal(address indexed pcvDeposit, address indexed destination, uint256 amount);
14 
15     event PCVGuardianETHWithdrawal(address indexed pcvDeposit, address indexed destination, uint256 amount);
16 
17     event PCVGuardianERC20Withdrawal(
18         address indexed pcvDeposit,
19         address indexed destination,
20         address indexed token,
21         uint256 amount
22     );
23 
24     // ---------- Read-Only API ----------
25 
26     /// @notice returns true if the the provided address is a valid destination to withdraw funds to
27     /// @param pcvDeposit the address to check
28     function isSafeAddress(address pcvDeposit) external view returns (bool);
29 
30     /// @notice returns all safe addresses
31     function getSafeAddresses() external view returns (address[] memory);
32 
33     // ---------- Governor-Only State-Changing API ----------
34 
35     /// @notice governor-only method to set an address as "safe" to withdraw funds to
36     /// @param pcvDeposit the address to set as safe
37     function setSafeAddress(address pcvDeposit) external;
38 
39     /// @notice batch version of setSafeAddress
40     /// @param safeAddresses the addresses to set as safe, as calldata
41     function setSafeAddresses(address[] calldata safeAddresses) external;
42 
43     // ---------- Governor-or-Guardian-Only State-Changing API ----------
44 
45     /// @notice governor-or-guardian-only method to un-set an address as "safe" to withdraw funds to
46     /// @param pcvDeposit the address to un-set as safe
47     function unsetSafeAddress(address pcvDeposit) external;
48 
49     /// @notice batch version of unsetSafeAddresses
50     /// @param safeAddresses the addresses to un-set as safe
51     function unsetSafeAddresses(address[] calldata safeAddresses) external;
52 
53     /// @notice governor-or-guardian-only method to withdraw funds from a pcv deposit, by calling the withdraw() method on it
54     /// @param pcvDeposit the address of the pcv deposit contract
55     /// @param safeAddress the destination address to withdraw to
56     /// @param amount the amount to withdraw
57     /// @param pauseAfter if true, the pcv contract will be paused after the withdraw
58     /// @param depositAfter if true, attempts to deposit to the target PCV deposit
59     function withdrawToSafeAddress(
60         address pcvDeposit,
61         address safeAddress,
62         uint256 amount,
63         bool pauseAfter,
64         bool depositAfter
65     ) external;
66 
67     /// @notice governor-or-guardian-only method to withdraw funds from a pcv deposit, by calling the withdraw() method on it
68     /// @param pcvDeposit the address of the pcv deposit contract
69     /// @param safeAddress the destination address to withdraw to
70     /// @param amount the amount of tokens to withdraw
71     /// @param pauseAfter if true, the pcv contract will be paused after the withdraw
72     /// @param depositAfter if true, attempts to deposit to the target PCV deposit
73     function withdrawETHToSafeAddress(
74         address pcvDeposit,
75         address payable safeAddress,
76         uint256 amount,
77         bool pauseAfter,
78         bool depositAfter
79     ) external;
80 
81     /// @notice governor-or-guardian-only method to withdraw funds from a pcv deposit, by calling the withdraw() method on it
82     /// @param pcvDeposit the deposit to pull funds from
83     /// @param safeAddress the destination address to withdraw to
84     /// @param token the token to withdraw
85     /// @param amount the amount of funds to withdraw
86     /// @param pauseAfter whether to pause the pcv after withdrawing
87     /// @param depositAfter if true, attempts to deposit to the target PCV deposit
88     function withdrawERC20ToSafeAddress(
89         address pcvDeposit,
90         address safeAddress,
91         address token,
92         uint256 amount,
93         bool pauseAfter,
94         bool depositAfter
95     ) external;
96 }
