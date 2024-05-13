1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/BEP20.sol";
5 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
6 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
7 
8 import "../library/SafeToken.sol";
9 import "../interfaces/IWETH.sol";
10 
11 contract safeSwapBNB {
12     using SafeBEP20 for IBEP20;
13     using SafeMath for uint256;
14 
15     /* ========== CONSTANTS ============= */
16 
17     address private constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
18 
19 
20     /* ========== CONSTRUCTOR ========== */
21 
22     constructor() public {}
23 
24     receive() external payable {}
25 
26     /* ========== FUNCTIONS ========== */
27 
28     function withdraw(uint amount) external {
29         require(IBEP20(WBNB).balanceOf(msg.sender) >= amount, "Not enough Tokens!");
30 
31         IBEP20(WBNB).transferFrom(msg.sender, address(this), amount);
32 
33         IWETH(WBNB).withdraw(amount);
34 
35         SafeToken.safeTransferETH(msg.sender, amount);
36 
37     }
38 }
