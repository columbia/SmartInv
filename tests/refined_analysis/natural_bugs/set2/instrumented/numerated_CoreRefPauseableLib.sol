1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../refs/CoreRef.sol";
5 import "@openzeppelin/contracts/security/Pausable.sol";
6 
7 /// @title PauseableLib
8 /// @notice PauseableLib is a library that can be used to pause and unpause contracts, amont other utilities.
9 /// @dev This library should only be used on contracts that implement CoreRef.
10 library CoreRefPauseableLib {
11     function _requireUnpaused(address _pausableCoreRefAddress) internal view {
12         require(
13             !CoreRef(_pausableCoreRefAddress).paused(),
14             "PausableLib: Address is paused but required to not be paused."
15         );
16     }
17 
18     function _requirePaused(address _pausableCoreRefAddress) internal view {
19         require(
20             CoreRef(_pausableCoreRefAddress).paused(),
21             "PausableLib: Address is not paused but required to be paused."
22         );
23     }
24 
25     function _ensureUnpaused(address _pausableCoreRefAddress) internal {
26         if (CoreRef(_pausableCoreRefAddress).paused()) {
27             CoreRef(_pausableCoreRefAddress).unpause();
28         }
29     }
30 
31     function _ensurePaused(address _pausableCoreRefAddress) internal {
32         if (!CoreRef(_pausableCoreRefAddress).paused()) {
33             CoreRef(_pausableCoreRefAddress).pause();
34         }
35     }
36 
37     function _pause(address _pauseableCoreRefAddress) internal {
38         CoreRef(_pauseableCoreRefAddress).pause();
39     }
40 
41     function _unpause(address _pauseableCoreRefAddress) internal {
42         CoreRef(_pauseableCoreRefAddress).unpause();
43     }
44 }
