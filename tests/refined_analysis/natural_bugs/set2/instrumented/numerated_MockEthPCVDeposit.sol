1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../pcv/IPCVDeposit.sol";
5 import "@openzeppelin/contracts/utils/Address.sol";
6 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
7 
8 contract MockEthPCVDeposit is IPCVDeposit {
9     address payable beneficiary;
10     uint256 total = 0;
11 
12     constructor(address payable _beneficiary) {
13         beneficiary = _beneficiary;
14     }
15 
16     receive() external payable {
17         total += msg.value;
18         if (beneficiary != address(this)) {
19             Address.sendValue(beneficiary, msg.value);
20         }
21     }
22 
23     function deposit() external override {}
24 
25     function withdraw(address to, uint256 amount) external override {
26         require(address(this).balance >= amount, "MockEthPCVDeposit: Not enough value held");
27         total -= amount;
28         Address.sendValue(payable(to), amount);
29     }
30 
31     function withdrawERC20(
32         address token,
33         address to,
34         uint256 amount
35     ) public override {
36         SafeERC20.safeTransfer(IERC20(token), to, amount);
37         emit WithdrawERC20(msg.sender, to, token, amount);
38     }
39 
40     function withdrawETH(address payable to, uint256 amountOut) external virtual override {
41         Address.sendValue(to, amountOut);
42         emit WithdrawETH(msg.sender, to, amountOut);
43     }
44 
45     function balance() public view override returns (uint256) {
46         return total;
47     }
48 
49     function setBeneficiary(address payable _beneficiary) public {
50         beneficiary = _beneficiary;
51     }
52 
53     /// @notice display the related token of the balance reported
54     function balanceReportedIn() public pure override returns (address) {
55         return address(0);
56     }
57 
58     function resistantBalanceAndFei() public view virtual override returns (uint256, uint256) {
59         return (balance(), 0);
60     }
61 }
