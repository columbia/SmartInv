1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 import "./ERC20/BeanstalkERC20.sol";
9 
10 /**
11  * @author Publius
12  * @title Bean is the ERC-20 Stablecoin for Beanstalk.
13 **/
14 contract Bean is BeanstalkERC20  {
15 
16     constructor()
17     BeanstalkERC20(msg.sender, "Bean", "BEAN")
18     { }
19 }
