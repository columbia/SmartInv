1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/utils/Address.sol";
5 import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
6 import "@rari-capital/solmate/src/utils/ReentrancyGuard.sol";
7 import "../core/TribeRoles.sol";
8 import "../refs/CoreRef.sol";
9 import "../pcv/IPCVDeposit.sol";
10 import "./IPCVSentinel.sol";
11 import "./IGuard.sol";
12 
13 /**
14  * @title PCV Sentinel
15  * @dev the PCV Sentinel should be granted the role Guardian
16  * @notice The PCV Sentinel is a automated extension of the Guardian.
17  * The Guardian can add Guards to the PCV Sentinel. Guards run checks
18  * and provide addresses and calldata for the Sentinel to run, if needed.
19  */
20 contract PCVSentinel is IPCVSentinel, CoreRef, ReentrancyGuard {
21     using EnumerableSet for EnumerableSet.AddressSet;
22 
23     // The set of all guards
24     EnumerableSet.AddressSet private guards;
25 
26     /**
27      * @notice Creates a PCV Sentinel with no guards
28      * @param _core the Tribe core address
29      */
30     constructor(address _core) CoreRef(_core) {}
31 
32     // ---------- Read-Only API ----------
33 
34     /**
35      * @notice returns whether or not the given address is a guard
36      * @param guard the address to check
37      */
38     function isGuard(address guard) external view override returns (bool) {
39         return guards.contains(guard);
40     }
41 
42     /**
43      * @notice returns a list of all guards
44      */
45     function allGuards() external view override returns (address[] memory all) {
46         all = new address[](guards.length());
47 
48         for (uint256 i = 0; i < guards.length(); i++) {
49             all[i] = guards.at(i);
50         }
51 
52         return all;
53     }
54 
55     // ---------- Governor-or-Admin-Or-Guardian-Only State-Changing API ----------
56 
57     /**
58      * @notice adds a guard contract to the PCV Sentinel
59      * @param guard the guard-contract to add
60      */
61     function knight(address guard) external override hasAnyOfTwoRoles(TribeRoles.GUARDIAN, TribeRoles.GOVERNOR) {
62         guards.add(guard);
63 
64         // Inform the kingdom of this glorious news
65         emit GuardAdded(guard);
66     }
67 
68     /**
69      * @notice removes a guard
70      * @param traitor the guard-contract to remove
71      */
72     function slay(address traitor) external override hasAnyOfTwoRoles(TribeRoles.GUARDIAN, TribeRoles.GOVERNOR) {
73         guards.remove(traitor);
74 
75         // Inform the kingdom of this sudden and inevitable betrayal
76         emit GuardRemoved(traitor);
77     }
78 
79     // ---------- Public State-Changing API ----------
80 
81     /**
82      * @notice checks the guard and runs its protec actions if needed
83      * @param guard the guard to activate
84      */
85     function protec(address guard) external override nonReentrant {
86         require(guards.contains(guard), "Guard does not exist.");
87         require(IGuard(guard).check(), "No need to protec.");
88 
89         (address[] memory targets, bytes[] memory calldatas, uint256[] memory values) = IGuard(guard)
90             .getProtecActions();
91 
92         for (uint256 i = 0; i < targets.length; i++) {
93             require(targets[i] != address(this), "Cannot target self.");
94             require(address(this).balance >= values[i], "Insufficient ETH.");
95             (bool success, bytes memory returndata) = targets[i].call{value: values[i]}(calldatas[i]);
96             Address.verifyCallResult(success, returndata, "Guard sub-action failed with empty error message.");
97         }
98 
99         emit Protected(guard);
100     }
101 
102     /**
103      * @dev receive() and fallback() have been added and made payable for cases where the contract
104      * needs to be able to receive eth as part of an operation - such as receiving an incentivization
105      * (in eth) from a contract as part of operation. For similar (and not unlikely) edge cases,
106      * the contract also has the capability of sending eth inside when instructed by a guard to do so.
107      */
108     receive() external payable {}
109 
110     fallback() external payable {}
111 }
