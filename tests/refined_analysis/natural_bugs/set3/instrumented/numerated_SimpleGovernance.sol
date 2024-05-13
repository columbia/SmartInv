1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.6;
4 
5 import "@openzeppelin/contracts-4.2.0/utils/Context.sol";
6 
7 abstract contract SimpleGovernance is Context {
8     address public governance;
9     address public pendingGovernance;
10 
11     event SetGovernance(address indexed governance);
12 
13     /**
14      * @notice Changes governance of this contract
15      */
16     modifier onlyGovernance() {
17         require(
18             _msgSender() == governance,
19             "only governance can perform this action"
20         );
21         _;
22     }
23 
24     /**
25      * @notice Changes governance of this contract
26      * @dev Only governance can call this function. The new governance must call `acceptGovernance` after.
27      * @param newGovernance new address to become the governance
28      */
29     function changeGovernance(address newGovernance) external onlyGovernance {
30         require(
31             newGovernance != governance,
32             "governance must be different from current one"
33         );
34         require(newGovernance != address(0), "governance cannot be empty");
35         pendingGovernance = newGovernance;
36     }
37 
38     /**
39      * @notice Accept the new role of governance
40      * @dev `changeGovernance` must be called first to set `pendingGovernance`
41      */
42     function acceptGovernance() external {
43         address _pendingGovernance = pendingGovernance;
44         require(
45             _pendingGovernance != address(0),
46             "changeGovernance must be called first"
47         );
48         require(
49             _msgSender() == _pendingGovernance,
50             "only pendingGovernance can accept this role"
51         );
52         pendingGovernance = address(0);
53         governance = _msgSender();
54         emit SetGovernance(_msgSender());
55     }
56 }
