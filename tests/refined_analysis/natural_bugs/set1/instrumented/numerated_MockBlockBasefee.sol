1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 import "../interfaces/IBlockBasefee.sol";
9 
10 /**
11  * @author Chaikitty
12  * @title MockBlockBasefee is a Mock version of Block basefee contract for getting current block's base fee
13 **/
14 contract MockBlockBasefee is IBlockBasefee  {
15 
16     uint256 private answer;
17 
18     function block_basefee() external view override returns (uint256) {
19         return answer;
20     }
21 
22     function setAnswer(uint256 ans) public {
23         answer = ans;
24     }
25 }
