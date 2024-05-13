1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../../refs/CoreRef.sol";
5 import "./RatioPCVControllerV2.sol";
6 
7 /// @title a PCV controller for moving a ratio of the total value in a
8 /// PCV deposit, after a certain deadline. PCV_CONTROLLER_ROLE has to be
9 /// granted temporarily, and this contract renounce to this role after
10 /// it has executed the scheduled PCV movement.
11 /// @author Fei Protocol
12 contract DelayedPCVMover is CoreRef {
13     using SafeERC20 for IERC20;
14 
15     /// @notice deadline to wait before PCV movement.
16     uint256 public immutable deadline;
17     /// @notice controller used to move PCV.
18     RatioPCVControllerV2 public immutable controller;
19     /// @notice deposit to withdraw funds from.
20     IPCVDeposit public immutable deposit;
21     /// @notice target to send funds to.
22     address public immutable target;
23     /// @notice basis points for the ratio of funds to move.
24     uint256 public immutable basisPoints;
25 
26     /// @notice DelayedPCVMover constructor
27     /// @param _core Fei Core for reference
28     /// @param _deadline to wait before PCV movement
29     /// @param _controller used for moving funds
30     /// @param _deposit used to withdraw funds from
31     /// @param _target to send funds to
32     /// @param _basisPoints used to know what ratio of funds to move
33     constructor(
34         address _core,
35         uint256 _deadline,
36         RatioPCVControllerV2 _controller,
37         IPCVDeposit _deposit,
38         address _target,
39         uint256 _basisPoints
40     ) CoreRef(_core) {
41         deadline = _deadline;
42         controller = _controller;
43         deposit = _deposit;
44         target = _target;
45         basisPoints = _basisPoints;
46     }
47 
48     /// @notice PCV movement by calling withdrawRatio on the PCVController.
49     /// This will enforce the deadline check, and renounce to the
50     /// PCV_CONTROLLER_ROLE role after a successful call.
51     function withdrawRatio() public whenNotPaused {
52         // Check that deadline has been reached
53         require(block.timestamp >= deadline, "DelayedPCVMover: deadline not reached");
54 
55         // Perform PCV movement
56         controller.withdrawRatio(deposit, target, basisPoints);
57 
58         // Revoke PCV_CONTROLLER_ROLE from self
59         core().renounceRole(keccak256("PCV_CONTROLLER_ROLE"), address(this));
60     }
61 }
