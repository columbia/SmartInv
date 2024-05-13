1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../pcv/IPCVDeposit.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
7 
8 contract MockERC20PCVDeposit is IPCVDeposit {
9     address payable public beneficiary;
10     IERC20 public token;
11     uint256 public total;
12 
13     constructor(address payable _beneficiary, IERC20 _token) {
14         beneficiary = _beneficiary;
15         token = _token;
16     }
17 
18     function deposit() external override {
19         total += balance();
20         token.transfer(beneficiary, balance());
21     }
22 
23     function withdraw(address to, uint256 amount) external override {
24         total -= amount;
25         token.transfer(to, amount);
26     }
27 
28     function withdrawERC20(
29         address _token,
30         address to,
31         uint256 amount
32     ) public override {
33         SafeERC20.safeTransfer(IERC20(_token), to, amount);
34         emit WithdrawERC20(msg.sender, to, _token, amount);
35     }
36 
37     function withdrawETH(address payable to, uint256 amountOut) external virtual override {
38         Address.sendValue(to, amountOut);
39         emit WithdrawETH(msg.sender, to, amountOut);
40     }
41 
42     function balance() public view override returns (uint256) {
43         return token.balanceOf(address(this));
44     }
45 
46     /// @notice display the related token of the balance reported
47     function balanceReportedIn() public view override returns (address) {
48         return address(token);
49     }
50 
51     function resistantBalanceAndFei() public view virtual override returns (uint256, uint256) {
52         return (balance(), 0);
53     }
54 
55     function setBeneficiary(address payable _beneficiary) public {
56         beneficiary = _beneficiary;
57     }
58 }
