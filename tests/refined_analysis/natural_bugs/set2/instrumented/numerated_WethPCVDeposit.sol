1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "../PCVDeposit.sol";
5 import "../../Constants.sol";
6 import "@openzeppelin/contracts/utils/Address.sol";
7 
8 /// @title base class for a WethPCVDeposit PCV Deposit
9 /// @author Fei Protocol
10 abstract contract WethPCVDeposit is PCVDeposit {
11     /// @notice Empty callback on ETH reception
12     receive() external payable virtual {}
13 
14     /// @notice Wraps all ETH held by the contract to WETH
15     /// Anyone can call it
16     function wrapETH() public {
17         uint256 ethBalance = address(this).balance;
18         if (ethBalance != 0) {
19             Constants.WETH.deposit{value: ethBalance}();
20         }
21     }
22 
23     /// @notice deposit
24     function deposit() external virtual override {
25         wrapETH();
26     }
27 
28     /// @notice withdraw ETH from the contract
29     /// @param to address to send ETH
30     /// @param amountOut amount of ETH to send
31     function withdrawETH(address payable to, uint256 amountOut) external override onlyPCVController {
32         Constants.WETH.withdraw(amountOut);
33         Address.sendValue(to, amountOut);
34         emit WithdrawETH(msg.sender, to, amountOut);
35     }
36 }
