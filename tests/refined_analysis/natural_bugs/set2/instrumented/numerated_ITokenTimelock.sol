1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 
6 /// @title TokenTimelock interface
7 /// @author Fei Protocol
8 interface ITokenTimelock {
9     // ----------- Events -----------
10 
11     event Release(address indexed _beneficiary, address indexed _recipient, uint256 _amount);
12     event BeneficiaryUpdate(address indexed _beneficiary);
13     event PendingBeneficiaryUpdate(address indexed _pendingBeneficiary);
14 
15     // ----------- State changing api -----------
16 
17     function release(address to, uint256 amount) external;
18 
19     function releaseMax(address to) external;
20 
21     function setPendingBeneficiary(address _pendingBeneficiary) external;
22 
23     function acceptBeneficiary() external;
24 
25     // ----------- Getters -----------
26 
27     function lockedToken() external view returns (IERC20);
28 
29     function beneficiary() external view returns (address);
30 
31     function pendingBeneficiary() external view returns (address);
32 
33     function initialBalance() external view returns (uint256);
34 
35     function availableForRelease() external view returns (uint256);
36 
37     function totalToken() external view returns (uint256);
38 
39     function alreadyReleasedAmount() external view returns (uint256);
40 }
