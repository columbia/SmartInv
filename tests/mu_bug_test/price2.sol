1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.5.0;

3 contract ExchangeTokens {
4         IERC20 public WETH;
5         IERC20 public USDC;
6         IUniswapV2Pair public pair; 
7         mapping(address => uint) public debt;
8         mapping(address => uint) public collateral;
9         uint256 oldPrice;

10         function liquidate(address user) public {
11             uint dAmount = debt[user];
12             uint cAmount = collateral[user];
13             require(getPrice() * cAmount * 80 / 100 < dAmount,
14             "the given user’s fund cannot be liquidated");
15             address _this = address(this);
16             USDC.transferFrom(msg.sender, _this, dAmount);
17             WETH.transferFrom(_this, msg.sender, cAmount);
18         }
19         function  calculatePrice() public payable returns (uint) { 

20             oldPrice =  (USDC.balanceOf(address(pair)) /
21             WETH.balanceOf(address(pair))); 
        
22             return (USDC.balanceOf(address(pair)) /
23             WETH.balanceOf(address(pair)));
24      }
25  }