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
12  * @title Unripe Bean 3Crv is the Unripe token for the Bean3Crv Token.
13 **/
14 contract UnripeBean3Crv is BeanstalkERC20  {
15 
16     constructor()
17     BeanstalkERC20(msg.sender, "Unripe Bean3Crv", "urBEAN3CRV")
18     { }
19 }
