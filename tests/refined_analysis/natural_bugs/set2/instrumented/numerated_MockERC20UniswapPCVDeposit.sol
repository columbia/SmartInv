1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../pcv/IPCVDeposit.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
7 
8 contract MockERC20UniswapPCVDeposit is IPCVDeposit {
9     IERC20 public token;
10 
11     constructor(IERC20 _token) {
12         token = _token;
13     }
14 
15     function deposit() external override {}
16 
17     function withdraw(address to, uint256 amount) external override {
18         token.transfer(to, amount);
19     }
20 
21     function withdrawERC20(
22         address _token,
23         address to,
24         uint256 amount
25     ) public override {
26         SafeERC20.safeTransfer(IERC20(_token), to, amount);
27         emit WithdrawERC20(msg.sender, to, _token, amount);
28     }
29 
30     function withdrawETH(address payable to, uint256 amountOut) external virtual override {
31         Address.sendValue(to, amountOut);
32         emit WithdrawETH(msg.sender, to, amountOut);
33     }
34 
35     function balance() public view override returns (uint256) {
36         return token.balanceOf(address(this));
37     }
38 
39     /// @notice display the related token of the balance reported
40     function balanceReportedIn() public view override returns (address) {
41         return address(token);
42     }
43 
44     function resistantBalanceAndFei() public view virtual override returns (uint256, uint256) {
45         return (balance(), 0);
46     }
47 }
