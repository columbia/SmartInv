1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 
6 /**
7  @title Contract to exchange REPT-b for FEI
8 */
9 contract REPTbRedeemer {
10     using SafeERC20 for IERC20;
11 
12     event Exchange(address indexed from, address indexed to, uint256 amount);
13 
14     IERC20 public immutable reptB;
15     IERC20 public immutable fei;
16 
17     constructor(IERC20 _reptB, IERC20 _fei) {
18         reptB = _reptB;
19         fei = _fei;
20     }
21 
22     /// @notice call to exchange REPT-b for FEI
23     /// @param to the destination address
24     /// @param amount the amount to exchange
25     function exchange(address to, uint256 amount) public {
26         reptB.safeTransferFrom(msg.sender, address(this), amount);
27         fei.safeTransfer(to, amount);
28         emit Exchange(msg.sender, to, amount);
29     }
30 }
