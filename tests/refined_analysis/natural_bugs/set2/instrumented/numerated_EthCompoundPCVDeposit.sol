1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./CompoundPCVDepositBase.sol";
5 import "../../Constants.sol";
6 
7 interface CEther {
8     function mint() external payable;
9 }
10 
11 /// @title ETH implementation for a Compound PCV Deposit
12 /// @author Fei Protocol
13 contract EthCompoundPCVDeposit is CompoundPCVDepositBase {
14     /// @notice Compound ETH PCV Deposit constructor
15     /// @param _core Fei Core for reference
16     /// @param _cToken Compound cToken to deposit
17     constructor(address _core, address _cToken) CompoundPCVDepositBase(_core, _cToken) {
18         // require(cToken.isCEther(), "EthCompoundPCVDeposit: Not a CEther");
19     }
20 
21     receive() external payable {}
22 
23     /// @notice deposit ETH to Compound
24     function deposit() external override whenNotPaused {
25         uint256 amount = address(this).balance;
26 
27         // CEth deposits revert on failure
28         CEther(address(cToken)).mint{value: amount}();
29         emit Deposit(msg.sender, amount);
30     }
31 
32     function _transferUnderlying(address to, uint256 amount) internal override {
33         Address.sendValue(payable(to), amount);
34     }
35 
36     /// @notice display the related token of the balance reported
37     function balanceReportedIn() public pure override returns (address) {
38         return address(Constants.WETH);
39     }
40 }
