1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";
5 import {CoreRef} from "../refs/CoreRef.sol";
6 
7 /// @title PodExecutor
8 /// @notice Executor gateway contract which exposes the execution of prepared timelock transactions and makes them public
9 /// @dev EXECUTOR_ROLE must be granted to this contract by the relevant timelock, in order for this contract to execute
10 contract PodExecutor is CoreRef {
11     event ExecuteTransaction(address timelock, bytes32 proposalId);
12 
13     constructor(address _core) CoreRef(_core) {}
14 
15     /// @notice Execute a timelock transaction. Must have EXECUTOR_ROLE on the appropriate timelock
16     function execute(
17         address timelock,
18         address target,
19         uint256 value,
20         bytes calldata data,
21         bytes32 predecessor,
22         bytes32 salt
23     ) public payable whenNotPaused returns (bytes32) {
24         bytes32 proposalId = TimelockController(payable(timelock)).hashOperation(
25             target,
26             value,
27             data,
28             predecessor,
29             salt
30         );
31         TimelockController(payable(timelock)).execute(target, value, data, predecessor, salt);
32         emit ExecuteTransaction(timelock, proposalId);
33         return proposalId;
34     }
35 
36     /// @notice Execute a transaction which contains a set of actions which were batch scheduled on a timelock
37     function executeBatch(
38         address timelock,
39         address[] calldata targets,
40         uint256[] calldata values,
41         bytes[] calldata payloads,
42         bytes32 predecessor,
43         bytes32 salt
44     ) external payable whenNotPaused returns (bytes32) {
45         bytes32 proposalId = TimelockController(payable(timelock)).hashOperationBatch(
46             targets,
47             values,
48             payloads,
49             predecessor,
50             salt
51         );
52         TimelockController(payable(timelock)).executeBatch(targets, values, payloads, predecessor, salt);
53         emit ExecuteTransaction(timelock, proposalId);
54         return proposalId;
55     }
56 }
