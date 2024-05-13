1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.6;
4 pragma experimental ABIEncoderV2;
5 
6 import {LibUsdOracle, LibEthUsdOracle, LibWstethUsdOracle} from "contracts/libraries/Oracle/LibUsdOracle.sol";
7 import {LibWstethEthOracle} from "contracts/libraries/Oracle/LibWstethEthOracle.sol";
8 
9 /**
10  * @title UsdOracle
11  * @author Publius
12  * @notice Holds functions to query USD prices of tokens.
13  */
14 contract UsdOracle {
15     
16     // USD : Token
17 
18     function getUsdTokenPrice(address token) external view returns (uint256) {
19         return LibUsdOracle.getUsdPrice(token);
20     }
21 
22     function getUsdTokenTwap(address token, uint256 lookback) external view returns (uint256) {
23         return LibUsdOracle.getUsdPrice(token, lookback);
24     }
25 
26     // Token : USD
27 
28     function getTokenUsdPrice(address token) external view returns (uint256) {
29         return LibUsdOracle.getTokenPrice(token);
30     }
31 
32     function getTokenUsdTwap(address token, uint256 lookback) external view returns (uint256) {
33         return LibUsdOracle.getTokenPrice(token, lookback);
34     }
35 
36     // ETH : USD
37 
38     function getEthUsdPrice() external view returns (uint256) {
39         return LibEthUsdOracle.getEthUsdPrice();
40     }
41 
42     function getEthUsdTwap(uint256 lookback) external view returns (uint256) {
43         return LibEthUsdOracle.getEthUsdPrice(lookback);
44     }
45 
46     // WstETH : USD
47 
48     function getWstethUsdPrice() external view returns (uint256) {
49         return LibWstethUsdOracle.getWstethUsdPrice();
50     }
51 
52     function getWstethUsdTwap(uint256 lookback) external view returns (uint256) {
53         return LibWstethUsdOracle.getWstethUsdPrice(lookback);
54     }
55 
56     // WstETH : ETH
57 
58     function getWstethEthPrice() external view returns (uint256) {
59         return LibWstethEthOracle.getWstethEthPrice();
60     }
61 
62     function getWstethEthTwap(uint256 lookback) external view returns (uint256) {
63         return LibWstethEthOracle.getWstethEthPrice(lookback);
64     }
65 
66 }
