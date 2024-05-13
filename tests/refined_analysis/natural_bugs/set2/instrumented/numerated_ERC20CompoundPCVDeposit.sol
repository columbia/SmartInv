1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./CompoundPCVDepositBase.sol";
5 
6 interface CErc20 {
7     function mint(uint256 amount) external returns (uint256);
8 
9     function underlying() external returns (address);
10 }
11 
12 /// @title ERC-20 implementation for a Compound PCV Deposit
13 /// @author Fei Protocol
14 contract ERC20CompoundPCVDeposit is CompoundPCVDepositBase {
15     /// @notice the token underlying the cToken
16     IERC20 public token;
17 
18     /// @notice Compound ERC20 PCV Deposit constructor
19     /// @param _core Fei Core for reference
20     /// @param _cToken Compound cToken to deposit
21     constructor(address _core, address _cToken) CompoundPCVDepositBase(_core, _cToken) {
22         token = IERC20(CErc20(_cToken).underlying());
23     }
24 
25     /// @notice deposit ERC-20 tokens to Compound
26     function deposit() external override whenNotPaused {
27         uint256 amount = token.balanceOf(address(this));
28 
29         token.approve(address(cToken), amount);
30 
31         // Compound returns non-zero when there is an error
32         require(CErc20(address(cToken)).mint(amount) == 0, "ERC20CompoundPCVDeposit: deposit error");
33 
34         emit Deposit(msg.sender, amount);
35     }
36 
37     function _transferUnderlying(address to, uint256 amount) internal override {
38         SafeERC20.safeTransfer(token, to, amount);
39     }
40 
41     /// @notice display the related token of the balance reported
42     function balanceReportedIn() public view override returns (address) {
43         return address(token);
44     }
45 }
