1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 
6 interface IIdleToken {
7     function redeemIdleToken(uint256 _amount) external;
8 
9     function token() external view returns (IERC20);
10 
11     function transfer(address account, uint256 amount) external;
12 }
13 
14 /// @title base class for a claiming Idle tokens
15 /// @author Fei Protocol
16 contract IdlePCVRedeemer {
17     using SafeERC20 for IERC20;
18 
19     address public immutable target;
20 
21     IIdleToken public immutable idleToken;
22 
23     constructor(address _target, IIdleToken _idleToken) {
24         target = _target;
25         idleToken = _idleToken;
26     }
27 
28     /// @notice redeem Idle Token shares
29     /// @param amount asset amount to redeem
30     function redeem(uint256 amount) external {
31         idleToken.redeemIdleToken(amount);
32 
33         IERC20 token = idleToken.token();
34 
35         uint256 balance = token.balanceOf(address(this));
36         token.safeTransfer(target, balance);
37     }
38 
39     function sweep(IERC20 token, uint256 amount) external {
40         token.safeTransfer(target, amount);
41     }
42 }
