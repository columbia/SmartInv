1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity ^0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
9 
10 /**
11  * @author Publius
12  * @title WETH Interface
13 **/
14 interface IWETH is IERC20 {
15 
16     function deposit() external payable;
17     function withdraw(uint) external;
18 
19 }
