1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/governance/TimelockController.sol";
5 import "../../refs/CoreRef.sol";
6 
7 // Timelock with veto admin roles
8 contract OptimisticTimelock is TimelockController, CoreRef {
9     constructor(
10         address core_,
11         uint256 minDelay,
12         address[] memory proposers,
13         address[] memory executors
14     ) TimelockController(minDelay, proposers, executors) CoreRef(core_) {
15         // Only guardians and governors are timelock admins
16         revokeRole(TIMELOCK_ADMIN_ROLE, msg.sender);
17     }
18 
19     /**
20         @notice allow guardian or governor to assume timelock admin roles
21         This more elegantly achieves optimistic timelock as follows:
22         - veto: grant self PROPOSER_ROLE and cancel
23         - pause proposals: revoke PROPOSER_ROLE from target
24         - pause execution: revoke EXECUTOR_ROLE from target
25         - set new proposer: revoke old proposer and add new one
26 
27         In addition it allows for much more granular and flexible access for multisig operators
28     */
29     function becomeAdmin() public onlyGuardianOrGovernor {
30         this.grantRole(TIMELOCK_ADMIN_ROLE, msg.sender);
31     }
32 }
