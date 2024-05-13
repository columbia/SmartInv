1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 
6 interface ISmartYield {
7     function sellTokens(
8         uint256 tokenAmount_,
9         uint256 minUnderlying_,
10         uint256 deadline_
11     ) external;
12 
13     function transfer(address account, uint256 amount) external;
14 }
15 
16 /// @title base class for a claiming BarnBridge Smar Yield tokens
17 /// @author Fei Protocol
18 contract SmartYieldRedeemer {
19     using SafeERC20 for IERC20;
20 
21     address public immutable target;
22 
23     IERC20 public immutable underlying;
24 
25     constructor(address _target, IERC20 _underlying) {
26         target = _target;
27         underlying = _underlying;
28     }
29 
30     /// @notice redeem BarnBridge SmartYield juniors
31     /// @param bbJunior smart yield token to redeem from
32     /// @param amount tokens to redeem
33     function redeem(ISmartYield bbJunior, uint256 amount) external {
34         bbJunior.sellTokens(amount, 0, block.timestamp);
35 
36         uint256 balance = underlying.balanceOf(address(this));
37         underlying.safeTransfer(target, balance);
38     }
39 
40     function sweep(IERC20 token, uint256 amount) external {
41         token.safeTransfer(target, amount);
42     }
43 }
