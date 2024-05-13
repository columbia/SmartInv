1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./Timelock.sol";
5 import "../../refs/CoreRef.sol";
6 
7 /** 
8  @title Fei DAO Timelock
9  @notice Timelock with veto admin roles
10  @dev this timelock has the ability for the Guardian to pause queing or executing proposals, as well as being able to veto specific transactions. 
11  The timelock itself could not unpause the timelock while in paused state.
12 */
13 contract FeiDAOTimelock is Timelock, CoreRef {
14     address public constant OLD_TIMELOCK = 0x639572471f2f318464dc01066a56867130e45E25;
15     uint256 public constant ROLLBACK_DEADLINE = 1635724800; // Nov 1, 2021 midnight UTC
16 
17     constructor(
18         address core_,
19         address admin_,
20         uint256 delay_,
21         uint256 minDelay_
22     ) Timelock(admin_, delay_, minDelay_) CoreRef(core_) {}
23 
24     /// @notice queue a transaction, with pausability
25     function queueTransaction(
26         address target,
27         uint256 value,
28         string memory signature,
29         bytes memory data,
30         uint256 eta
31     ) public override whenNotPaused returns (bytes32) {
32         return super.queueTransaction(target, value, signature, data, eta);
33     }
34 
35     /// @notice veto a group of transactions
36     function vetoTransactions(
37         address[] memory targets,
38         uint256[] memory values,
39         string[] memory signatures,
40         bytes[] memory datas,
41         uint256[] memory etas
42     ) public onlyGuardianOrGovernor {
43         for (uint256 i = 0; i < targets.length; i++) {
44             _cancelTransaction(targets[i], values[i], signatures[i], datas[i], etas[i]);
45         }
46     }
47 
48     /// @notice execute a transaction, with pausability
49     function executeTransaction(
50         address target,
51         uint256 value,
52         string memory signature,
53         bytes memory data,
54         uint256 eta
55     ) public payable override whenNotPaused returns (bytes memory) {
56         return super.executeTransaction(target, value, signature, data, eta);
57     }
58 
59     /// @notice allow a governor to set a new pending timelock admin
60     function governorSetPendingAdmin(address newAdmin) public onlyGovernor {
61         pendingAdmin = newAdmin;
62         emit NewPendingAdmin(newAdmin);
63     }
64 
65     /// @notice one-time option to roll back the Timelock to old timelock
66     /// @dev guardian-only, and expires after the deadline. This function is here as a fallback in case something goes wrong.
67     function rollback() external onlyGuardianOrGovernor {
68         require(block.timestamp <= ROLLBACK_DEADLINE, "FeiDAOTimelock: rollback expired");
69 
70         IFeiDAO(admin).updateTimelock(OLD_TIMELOCK);
71     }
72 }
73 
74 interface IFeiDAO {
75     function updateTimelock(address newTimelock) external;
76 }
