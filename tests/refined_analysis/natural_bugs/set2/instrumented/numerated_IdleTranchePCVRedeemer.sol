1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 
6 interface IIdleTrancheMinter {
7     function withdrawAA(uint256 _amount) external returns (uint256);
8 
9     function token() external view returns (IERC20);
10 }
11 
12 /// @title base class for a claiming Idle tokens
13 /// @author Fei Protocol
14 contract IdleTranchePCVRedeemer {
15     using SafeERC20 for IERC20;
16 
17     address public immutable target;
18 
19     IIdleTrancheMinter public immutable idleToken;
20 
21     constructor(address _target, IIdleTrancheMinter _idleToken) {
22         target = _target;
23         idleToken = _idleToken;
24     }
25 
26     /// @notice redeem Idle Token shares
27     /// @param amount asset amount to redeem
28     function redeem(uint256 amount) external {
29         idleToken.withdrawAA(amount);
30 
31         IERC20 token = idleToken.token();
32 
33         uint256 balance = token.balanceOf(address(this));
34         token.safeTransfer(target, balance);
35     }
36 
37     function sweep(IERC20 token, uint256 amount) external {
38         token.safeTransfer(target, amount);
39     }
40 }
