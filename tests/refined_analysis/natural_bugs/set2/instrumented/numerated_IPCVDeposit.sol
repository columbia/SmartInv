1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./IPCVDepositBalances.sol";
5 
6 /// @title a PCV Deposit interface
7 /// @author Fei Protocol
8 interface IPCVDeposit is IPCVDepositBalances {
9     // ----------- Events -----------
10     event Deposit(address indexed _from, uint256 _amount);
11 
12     event Withdrawal(address indexed _caller, address indexed _to, uint256 _amount);
13 
14     event WithdrawERC20(address indexed _caller, address indexed _token, address indexed _to, uint256 _amount);
15 
16     event WithdrawETH(address indexed _caller, address indexed _to, uint256 _amount);
17 
18     // ----------- State changing api -----------
19 
20     function deposit() external;
21 
22     // ----------- PCV Controller only state changing api -----------
23 
24     function withdraw(address to, uint256 amount) external;
25 
26     function withdrawERC20(
27         address token,
28         address to,
29         uint256 amount
30     ) external;
31 
32     function withdrawETH(address payable to, uint256 amount) external;
33 }
