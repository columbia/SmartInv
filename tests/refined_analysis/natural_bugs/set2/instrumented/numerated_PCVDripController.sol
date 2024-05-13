1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./IPCVDripController.sol";
5 import "../../utils/Incentivized.sol";
6 import "../../fei/minter/RateLimitedMinter.sol";
7 import "../../utils/Timed.sol";
8 
9 /// @title a PCV dripping controller
10 /// @author Fei Protocol
11 contract PCVDripController is IPCVDripController, Timed, RateLimitedMinter, Incentivized {
12     /// @notice source PCV deposit to withdraw from
13     IPCVDeposit public override source;
14 
15     /// @notice target address to drip to
16     IPCVDeposit public override target;
17 
18     /// @notice amount to drip after each window
19     uint256 public override dripAmount;
20 
21     /// @notice PCV Drip Controller constructor
22     /// @param _core Fei Core for reference
23     /// @param _source the PCV deposit to drip from
24     /// @param _target the PCV deposit to drip to
25     /// @param _frequency frequency of dripping
26     /// @param _dripAmount amount to drip on each drip
27     /// @param _incentiveAmount the FEI incentive for calling drip
28     constructor(
29         address _core,
30         IPCVDeposit _source,
31         IPCVDeposit _target,
32         uint256 _frequency,
33         uint256 _dripAmount,
34         uint256 _incentiveAmount
35     )
36         CoreRef(_core)
37         Timed(_frequency)
38         Incentivized(_incentiveAmount)
39         RateLimitedMinter(_incentiveAmount / _frequency, _incentiveAmount, false)
40     {
41         target = _target;
42         emit TargetUpdate(address(0), address(_target));
43 
44         source = _source;
45         emit SourceUpdate(address(0), address(_source));
46 
47         dripAmount = _dripAmount;
48         emit DripAmountUpdate(0, _dripAmount);
49 
50         // start timer
51         _initTimed();
52     }
53 
54     /// @notice drip PCV to target by withdrawing from source
55     function drip() external override afterTime whenNotPaused {
56         require(dripEligible(), "PCVDripController: not eligible");
57 
58         // reset timer
59         _initTimed();
60 
61         // incentivize caller
62         _incentivize();
63 
64         // drip
65         source.withdraw(address(target), dripAmount);
66         target.deposit(); // trigger any deposit logic on the target
67         emit Dripped(address(source), address(target), dripAmount);
68     }
69 
70     /// @notice set the new PCV Deposit source
71     function setSource(IPCVDeposit newSource) external override onlyGovernor {
72         require(address(newSource) != address(0), "PCVDripController: zero address");
73 
74         address oldSource = address(source);
75         source = newSource;
76         emit SourceUpdate(oldSource, address(newSource));
77     }
78 
79     /// @notice set the new PCV Deposit target
80     function setTarget(IPCVDeposit newTarget) external override onlyGovernor {
81         require(address(newTarget) != address(0), "PCVDripController: zero address");
82 
83         address oldTarget = address(target);
84         target = newTarget;
85         emit TargetUpdate(oldTarget, address(newTarget));
86     }
87 
88     /// @notice set the new drip amount
89     function setDripAmount(uint256 newDripAmount) external override onlyGovernorOrAdmin {
90         require(newDripAmount != 0, "PCVDripController: zero drip amount");
91 
92         uint256 oldDripAmount = dripAmount;
93         dripAmount = newDripAmount;
94         emit DripAmountUpdate(oldDripAmount, newDripAmount);
95     }
96 
97     /// @notice checks whether the target balance is less than the drip amount
98     function dripEligible() public view virtual override returns (bool) {
99         return target.balance() < dripAmount;
100     }
101 
102     function _mintFei(address to, uint256 amountIn) internal override(CoreRef, RateLimitedMinter) {
103         RateLimitedMinter._mintFei(to, amountIn);
104     }
105 }
