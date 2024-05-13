1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 import "@openzeppelin/contracts-upgradeable-4.7.3/access/OwnableUpgradeable.sol";
6 import "@openzeppelin/contracts-upgradeable-4.7.3/security/PausableUpgradeable.sol";
7 
8 /**
9  * @title OwnerPausable
10  * @notice An ownable contract allows the owner to pause and unpause the
11  * contract without a delay.
12  * @dev Only methods using the provided modifiers will be paused.
13  */
14 abstract contract OwnerPausableUpgradeableV1 is
15     OwnableUpgradeable,
16     PausableUpgradeable
17 {
18     function __OwnerPausable_init() internal onlyInitializing {
19         __Context_init_unchained();
20         __Ownable_init_unchained();
21         __Pausable_init_unchained();
22     }
23 
24     /**
25      * @notice Pause the contract. Revert if already paused.
26      */
27     function pause() external onlyOwner {
28         PausableUpgradeable._pause();
29     }
30 
31     /**
32      * @notice Unpause the contract. Revert if already unpaused.
33      */
34     function unpause() external onlyOwner {
35         PausableUpgradeable._unpause();
36     }
37 }
