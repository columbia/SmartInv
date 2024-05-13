1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 
7 import "./MockToken.sol";
8 import {IWsteth} from "contracts/libraries/Oracle/LibWstethEthOracle.sol";
9 
10 /**
11  * @author Brendan
12  * @title Mock WStEth
13 **/
14 contract MockWsteth is MockToken {
15 
16     uint256 _stEthPerToken;
17 
18     constructor() MockToken("Wrapped Staked Ether", "WSTETH") {
19         _stEthPerToken = 1e18;
20     }
21 
22     function setStEthPerToken(uint256 __stEthPerToken) external {
23         _stEthPerToken = __stEthPerToken;
24     }
25 
26     function stEthPerToken() external view returns (uint256) {
27         return _stEthPerToken;
28     }
29 
30 
31 }
