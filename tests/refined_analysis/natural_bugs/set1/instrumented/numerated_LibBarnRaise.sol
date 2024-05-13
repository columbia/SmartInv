1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.6;
4 pragma experimental ABIEncoderV2;
5 
6 import {IWell} from "contracts/interfaces/basin/IWell.sol";
7 import {C} from "contracts/C.sol";
8 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
9 import {AppStorage, LibAppStorage} from "contracts/libraries/LibAppStorage.sol";
10 
11 
12 /**
13  * @title LibBarnRaise
14  * @author Brendan
15  * @notice Library fetching Barn Raise Token
16  */
17 library LibBarnRaise {
18 
19     function getBarnRaiseToken() internal view returns (address) {
20         IERC20[] memory tokens = IWell(getBarnRaiseWell()).tokens();
21         return address(address(tokens[0]) == C.BEAN ? tokens[1] : tokens[0]);
22     }
23 
24     function getBarnRaiseWell() internal view returns (address) {
25         AppStorage storage s = LibAppStorage.diamondStorage();
26         return
27             s.u[C.UNRIPE_LP].underlyingToken == address(0)
28                 ? C.BEAN_ETH_WELL
29                 : s.u[C.UNRIPE_LP].underlyingToken;
30     }
31 }
