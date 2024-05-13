1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 /**
9  * @author Publius
10  * @title Mock Contract with a getter and setter function
11 **/
12 contract MockContract {
13 
14     address account;
15 
16     function setAccount(address _account) external {
17         account = _account;
18     }
19 
20     function getAccount() external view returns (address _account) {
21         _account = account;
22     }
23 
24 }
