1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./TokemakPCVDepositBase.sol";
5 import "../../Constants.sol";
6 
7 interface ITokemakEthPool {
8     function deposit(uint256 amount) external payable;
9 
10     function withdraw(uint256 requestedAmount, bool asEth) external;
11 }
12 
13 /// @title ETH implementation for a Tokemak PCV Deposit
14 /// @author Fei Protocol
15 contract EthTokemakPCVDeposit is TokemakPCVDepositBase {
16     /// @notice Tokemak ETH PCV Deposit constructor
17     /// @param _core Fei Core for reference
18     /// @param _pool Tokemak pool to deposit in
19     /// @param _rewards Tokemak rewards contract
20     constructor(
21         address _core,
22         address _pool,
23         address _rewards
24     ) TokemakPCVDepositBase(_core, _pool, _rewards) {}
25 
26     receive() external payable {}
27 
28     /// @notice deposit ETH to Tokemak
29     function deposit() external override whenNotPaused {
30         uint256 amount = address(this).balance;
31 
32         ITokemakEthPool(pool).deposit{value: amount}(amount);
33 
34         emit Deposit(msg.sender, amount);
35     }
36 
37     /// @notice withdraw tokens from the PCV allocation
38     /// @param amountUnderlying of tokens withdrawn
39     /// @param to the address to send PCV to
40     function withdraw(address to, uint256 amountUnderlying) external override onlyPCVController whenNotPaused {
41         ITokemakEthPool(pool).withdraw(amountUnderlying, true);
42 
43         Address.sendValue(payable(to), amountUnderlying);
44 
45         emit Withdrawal(msg.sender, to, amountUnderlying);
46     }
47 }
