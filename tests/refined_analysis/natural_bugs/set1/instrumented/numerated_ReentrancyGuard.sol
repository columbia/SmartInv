1 
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity =0.7.6;
5 pragma experimental ABIEncoderV2;
6 import "./AppStorage.sol";
7 
8 /**
9  * @author Beanstalk Farms
10  * @title Variation of Oepn Zeppelins reentrant guard to include Silo Update
11  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts%2Fsecurity%2FReentrancyGuard.sol
12 **/
13 abstract contract ReentrancyGuard {
14     uint256 private constant _NOT_ENTERED = 1;
15     uint256 private constant _ENTERED = 2;
16 
17     AppStorage internal s;
18     
19     modifier nonReentrant() {
20         require(s.reentrantStatus != _ENTERED, "ReentrancyGuard: reentrant call");
21         s.reentrantStatus = _ENTERED;
22         _;
23         s.reentrantStatus = _NOT_ENTERED;
24     }
25 }