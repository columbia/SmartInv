1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.6;
4 pragma experimental ABIEncoderV2;
5 
6 // Import all of AppStorage to give importers of LibAppStorage access to {Account}, etc.
7 import "../beanstalk/AppStorage.sol";
8 
9 /**
10  * @title LibAppStorage 
11  * @author Publius
12  * @notice Allows libaries to access Beanstalk's state.
13  */
14 library LibAppStorage {
15     function diamondStorage() internal pure returns (AppStorage storage ds) {
16         assembly {
17             ds.slot := 0
18         }
19     }
20 }
