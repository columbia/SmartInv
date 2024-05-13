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
14 
15 interface IUSDC is IERC20 {
16     function masterMinter() external view returns (address);
17     function mint(address _to, uint256 _amount) external;
18 }