1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../../refs/CoreRef.sol";
5 import "../../Constants.sol";
6 
7 /// @title abstract contract for splitting PCV into different deposits
8 /// @author Fei Protocol
9 abstract contract PCVSplitter is CoreRef {
10     uint256[] private ratios;
11     address[] private pcvDeposits;
12 
13     event AllocationUpdate(
14         address[] oldPCVDeposits,
15         uint256[] oldRatios,
16         address[] newPCVDeposits,
17         uint256[] newRatios
18     );
19     event Allocate(address indexed caller, uint256 amount);
20 
21     /// @notice PCVSplitter constructor
22     /// @param _pcvDeposits list of PCV Deposits to split to
23     /// @param _ratios ratios for splitting PCV Deposit allocations
24     constructor(address[] memory _pcvDeposits, uint256[] memory _ratios) {
25         _setAllocation(_pcvDeposits, _ratios);
26     }
27 
28     /// @notice make sure an allocation has matching lengths and totals the ALLOCATION_GRANULARITY
29     /// @param _pcvDeposits new list of pcv deposits to send to
30     /// @param _ratios new ratios corresponding to the PCV deposits
31     function checkAllocation(address[] memory _pcvDeposits, uint256[] memory _ratios) public pure {
32         require(_pcvDeposits.length == _ratios.length, "PCVSplitter: PCV Deposits and ratios are different lengths");
33 
34         uint256 total;
35         for (uint256 i; i < _ratios.length; i++) {
36             total = total + _ratios[i];
37         }
38 
39         require(total == Constants.BASIS_POINTS_GRANULARITY, "PCVSplitter: ratios do not total 100%");
40     }
41 
42     /// @notice gets the pcvDeposits and ratios of the splitter
43     function getAllocation() public view returns (address[] memory, uint256[] memory) {
44         return (pcvDeposits, ratios);
45     }
46 
47     /// @notice sets the allocation of held PCV
48     function setAllocation(address[] calldata _allocations, uint256[] calldata _ratios) external onlyGovernorOrAdmin {
49         _setAllocation(_allocations, _ratios);
50     }
51 
52     /// @notice distribute funds to single PCV deposit
53     /// @param amount amount of funds to send
54     /// @param pcvDeposit the pcv deposit to send funds
55     function _allocateSingle(uint256 amount, address pcvDeposit) internal virtual;
56 
57     /// @notice sets a new allocation for the splitter
58     /// @param _pcvDeposits new list of pcv deposits to send to
59     /// @param _ratios new ratios corresponding to the PCV deposits. Must total ALLOCATION_GRANULARITY
60     function _setAllocation(address[] memory _pcvDeposits, uint256[] memory _ratios) internal {
61         address[] memory _oldPCVDeposits = pcvDeposits;
62         uint256[] memory _oldRatios = ratios;
63 
64         checkAllocation(_pcvDeposits, _ratios);
65 
66         pcvDeposits = _pcvDeposits;
67         ratios = _ratios;
68 
69         emit AllocationUpdate(_oldPCVDeposits, _oldRatios, _pcvDeposits, _ratios);
70     }
71 
72     /// @notice distribute funds to all pcv deposits at specified allocation ratios
73     /// @param total amount of funds to send
74     function _allocate(uint256 total) internal {
75         uint256 granularity = Constants.BASIS_POINTS_GRANULARITY;
76         for (uint256 i; i < ratios.length; i++) {
77             uint256 amount = (total * ratios[i]) / granularity;
78             _allocateSingle(amount, pcvDeposits[i]);
79         }
80         emit Allocate(msg.sender, total);
81     }
82 }
