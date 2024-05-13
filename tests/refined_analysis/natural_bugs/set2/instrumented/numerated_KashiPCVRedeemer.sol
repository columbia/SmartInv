1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 
6 interface IKashi {
7     function removeAsset(address to, uint256 fraction) external returns (uint256 share);
8 }
9 
10 /// @title base class for a claiming Kashi pair tokens
11 /// @author Fei Protocol
12 contract KashiPCVRedeemer {
13     using SafeERC20 for IERC20;
14 
15     address public immutable target;
16 
17     constructor(address _target) {
18         target = _target;
19     }
20 
21     /// @notice redeem Kashi shares
22     /// @param pair kashi pair to redeem from
23     /// @param fraction asset fraction to redeem
24     function redeem(IKashi pair, uint256 fraction) external {
25         pair.removeAsset(target, fraction);
26     }
27 
28     function sweep(IERC20 token, uint256 amount) external {
29         token.safeTransfer(target, amount);
30     }
31 }
