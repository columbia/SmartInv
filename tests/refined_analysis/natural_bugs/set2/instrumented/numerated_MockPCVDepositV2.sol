1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../refs/CoreRef.sol";
5 import "../pcv/IPCVDeposit.sol";
6 
7 contract MockPCVDepositV2 is IPCVDeposit, CoreRef {
8     address public override balanceReportedIn;
9 
10     uint256 private resistantBalance;
11     uint256 private resistantProtocolOwnedFei;
12 
13     constructor(
14         address _core,
15         address _token,
16         uint256 _resistantBalance,
17         uint256 _resistantProtocolOwnedFei
18     ) CoreRef(_core) {
19         balanceReportedIn = _token;
20         resistantBalance = _resistantBalance;
21         resistantProtocolOwnedFei = _resistantProtocolOwnedFei;
22     }
23 
24     receive() external payable {}
25 
26     function set(uint256 _resistantBalance, uint256 _resistantProtocolOwnedFei) public {
27         resistantBalance = _resistantBalance;
28         resistantProtocolOwnedFei = _resistantProtocolOwnedFei;
29     }
30 
31     // gets the resistant token balance and protocol owned fei of this deposit
32     function resistantBalanceAndFei() external view override returns (uint256, uint256) {
33         return (resistantBalance, resistantProtocolOwnedFei);
34     }
35 
36     // IPCVDeposit V1
37     function deposit() external override {
38         resistantBalance = IERC20(balanceReportedIn).balanceOf(address(this));
39     }
40 
41     function withdraw(address to, uint256 amount) external override {
42         IERC20(balanceReportedIn).transfer(to, amount);
43         resistantBalance = IERC20(balanceReportedIn).balanceOf(address(this));
44     }
45 
46     function withdrawERC20(
47         address token,
48         address to,
49         uint256 amount
50     ) external override {
51         IERC20(token).transfer(to, amount);
52     }
53 
54     function withdrawETH(address payable to, uint256 amount) external override onlyPCVController {
55         to.transfer(amount);
56     }
57 
58     function balance() external view override returns (uint256) {
59         return IERC20(balanceReportedIn).balanceOf(address(this));
60     }
61 }
