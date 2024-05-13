1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
5 import "../refs/CoreRef.sol";
6 import "./IPCVGuardian.sol";
7 import "./IPCVDeposit.sol";
8 import "../libs/CoreRefPauseableLib.sol";
9 import {TribeRoles} from "../core/TribeRoles.sol";
10 
11 contract PCVGuardian is IPCVGuardian, CoreRef {
12     using CoreRefPauseableLib for address;
13     using EnumerableSet for EnumerableSet.AddressSet;
14 
15     // If an address is in this set, it's a safe address to withdraw to
16     EnumerableSet.AddressSet private safeAddresses;
17 
18     constructor(address _core, address[] memory _safeAddresses) CoreRef(_core) {
19         for (uint256 i = 0; i < _safeAddresses.length; i++) {
20             _setSafeAddress(_safeAddresses[i]);
21         }
22     }
23 
24     // ---------- Read-Only API ----------
25 
26     /// @notice returns true if the the provided address is a valid destination to withdraw funds to
27     /// @param pcvDeposit the address to check
28     function isSafeAddress(address pcvDeposit) public view override returns (bool) {
29         return safeAddresses.contains(pcvDeposit);
30     }
31 
32     /// @notice returns all safe addresses
33     function getSafeAddresses() public view override returns (address[] memory) {
34         return safeAddresses.values();
35     }
36 
37     // ---------- GOVERNOR-or-PCV_GUARDIAN_ADMIN-Only State-Changing API ----------
38 
39     /// @notice governor-only method to set an address as "safe" to withdraw funds to
40     /// @param pcvDeposit the address to set as safe
41     function setSafeAddress(address pcvDeposit)
42         external
43         override
44         hasAnyOfTwoRoles(TribeRoles.GOVERNOR, TribeRoles.PCV_GUARDIAN_ADMIN)
45     {
46         _setSafeAddress(pcvDeposit);
47     }
48 
49     /// @notice batch version of setSafeAddress
50     /// @param _safeAddresses the addresses to set as safe, as calldata
51     function setSafeAddresses(address[] calldata _safeAddresses)
52         external
53         override
54         hasAnyOfTwoRoles(TribeRoles.GOVERNOR, TribeRoles.PCV_GUARDIAN_ADMIN)
55     {
56         require(_safeAddresses.length != 0, "empty");
57         for (uint256 i = 0; i < _safeAddresses.length; i++) {
58             _setSafeAddress(_safeAddresses[i]);
59         }
60     }
61 
62     // ---------- GOVERNOR-or-PCV_GUARDIAN_ADMIN-Or-GUARDIAN-Only State-Changing API ----------
63 
64     /// @notice governor-or-guardian-only method to un-set an address as "safe" to withdraw funds to
65     /// @param pcvDeposit the address to un-set as safe
66     function unsetSafeAddress(address pcvDeposit)
67         external
68         override
69         hasAnyOfThreeRoles(TribeRoles.GOVERNOR, TribeRoles.GUARDIAN, TribeRoles.PCV_GUARDIAN_ADMIN)
70     {
71         _unsetSafeAddress(pcvDeposit);
72     }
73 
74     /// @notice batch version of unsetSafeAddresses
75     /// @param _safeAddresses the addresses to un-set as safe
76     function unsetSafeAddresses(address[] calldata _safeAddresses)
77         external
78         override
79         hasAnyOfThreeRoles(TribeRoles.GOVERNOR, TribeRoles.GUARDIAN, TribeRoles.PCV_GUARDIAN_ADMIN)
80     {
81         require(_safeAddresses.length != 0, "empty");
82         for (uint256 i = 0; i < _safeAddresses.length; i++) {
83             _unsetSafeAddress(_safeAddresses[i]);
84         }
85     }
86 
87     /// @notice governor-or-guardian-only method to withdraw funds from a pcv deposit, by calling the withdraw() method on it
88     /// @param pcvDeposit the address of the pcv deposit contract
89     /// @param safeAddress the destination address to withdraw to
90     /// @param amount the amount to withdraw
91     /// @param pauseAfter if true, the pcv contract will be paused after the withdraw
92     /// @param depositAfter if true, attempts to deposit to the target PCV deposit
93     function withdrawToSafeAddress(
94         address pcvDeposit,
95         address safeAddress,
96         uint256 amount,
97         bool pauseAfter,
98         bool depositAfter
99     ) external override hasAnyOfThreeRoles(TribeRoles.GOVERNOR, TribeRoles.PCV_SAFE_MOVER_ROLE, TribeRoles.GUARDIAN) {
100         require(isSafeAddress(safeAddress), "Provided address is not a safe address!");
101 
102         pcvDeposit._ensureUnpaused();
103 
104         IPCVDeposit(pcvDeposit).withdraw(safeAddress, amount);
105 
106         if (pauseAfter) {
107             pcvDeposit._pause();
108         }
109 
110         if (depositAfter) {
111             IPCVDeposit(safeAddress).deposit();
112         }
113 
114         emit PCVGuardianWithdrawal(pcvDeposit, safeAddress, amount);
115     }
116 
117     /// @notice governor-or-guardian-only method to withdraw funds from a pcv deposit, by calling the withdraw() method on it
118     /// @param pcvDeposit the address of the pcv deposit contract
119     /// @param safeAddress the destination address to withdraw to
120     /// @param amount the amount of tokens to withdraw
121     /// @param pauseAfter if true, the pcv contract will be paused after the withdraw
122     /// @param depositAfter if true, attempts to deposit to the target PCV deposit
123     function withdrawETHToSafeAddress(
124         address pcvDeposit,
125         address payable safeAddress,
126         uint256 amount,
127         bool pauseAfter,
128         bool depositAfter
129     ) external override hasAnyOfThreeRoles(TribeRoles.GOVERNOR, TribeRoles.PCV_SAFE_MOVER_ROLE, TribeRoles.GUARDIAN) {
130         require(isSafeAddress(safeAddress), "Provided address is not a safe address!");
131 
132         pcvDeposit._ensureUnpaused();
133 
134         IPCVDeposit(pcvDeposit).withdrawETH(safeAddress, amount);
135 
136         if (pauseAfter) {
137             pcvDeposit._pause();
138         }
139 
140         if (depositAfter) {
141             IPCVDeposit(safeAddress).deposit();
142         }
143 
144         emit PCVGuardianETHWithdrawal(pcvDeposit, safeAddress, amount);
145     }
146 
147     /// @notice governor-or-guardian-only method to withdraw funds from a pcv deposit, by calling the withdraw() method on it
148     /// @param pcvDeposit the deposit to pull funds from
149     /// @param safeAddress the destination address to withdraw to
150     /// @param amount the amount of funds to withdraw
151     /// @param pauseAfter whether to pause the pcv after withdrawing
152     /// @param depositAfter if true, attempts to deposit to the target PCV deposit
153     function withdrawERC20ToSafeAddress(
154         address pcvDeposit,
155         address safeAddress,
156         address token,
157         uint256 amount,
158         bool pauseAfter,
159         bool depositAfter
160     ) external override hasAnyOfThreeRoles(TribeRoles.GOVERNOR, TribeRoles.PCV_SAFE_MOVER_ROLE, TribeRoles.GUARDIAN) {
161         require(isSafeAddress(safeAddress), "Provided address is not a safe address!");
162 
163         pcvDeposit._ensureUnpaused();
164 
165         IPCVDeposit(pcvDeposit).withdrawERC20(token, safeAddress, amount);
166 
167         if (pauseAfter) {
168             pcvDeposit._pause();
169         }
170 
171         if (depositAfter) {
172             IPCVDeposit(safeAddress).deposit();
173         }
174 
175         emit PCVGuardianERC20Withdrawal(pcvDeposit, safeAddress, token, amount);
176     }
177 
178     // ---------- Internal Functions ----------
179 
180     function _setSafeAddress(address anAddress) internal {
181         require(safeAddresses.add(anAddress), "set");
182         emit SafeAddressAdded(anAddress);
183     }
184 
185     function _unsetSafeAddress(address anAddress) internal {
186         require(safeAddresses.remove(anAddress), "unset");
187         emit SafeAddressRemoved(anAddress);
188     }
189 }
