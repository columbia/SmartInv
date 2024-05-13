1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 import {IDODO} from "../intf/IDODO.sol";
12 import {IERC20} from "../intf/IERC20.sol";
13 import {SafeMath} from "../lib/SafeMath.sol";
14 
15 
16 interface IDODOMine {
17     function getUserLpBalance(address _lpToken, address _user) external view returns (uint256);
18 }
19 
20 
21 contract DODOMineReader {
22     using SafeMath for uint256;
23 
24     function getUserStakedBalance(
25         address _dodoMine,
26         address _dodo,
27         address _user
28     ) external view returns (uint256 baseBalance, uint256 quoteBalance) {
29         address baseLpToken = IDODO(_dodo)._BASE_CAPITAL_TOKEN_();
30         address quoteLpToken = IDODO(_dodo)._QUOTE_CAPITAL_TOKEN_();
31 
32         uint256 baseLpBalance = IDODOMine(_dodoMine).getUserLpBalance(baseLpToken, _user);
33         uint256 quoteLpBalance = IDODOMine(_dodoMine).getUserLpBalance(quoteLpToken, _user);
34 
35         uint256 baseLpTotalSupply = IERC20(baseLpToken).totalSupply();
36         uint256 quoteLpTotalSupply = IERC20(quoteLpToken).totalSupply();
37 
38         (uint256 baseTarget, uint256 quoteTarget) = IDODO(_dodo).getExpectedTarget();
39         baseBalance = baseTarget.mul(baseLpBalance).div(baseLpTotalSupply);
40         quoteBalance = quoteTarget.mul(quoteLpBalance).div(quoteLpTotalSupply);
41 
42         return (baseBalance, quoteBalance);
43     }
44 }
