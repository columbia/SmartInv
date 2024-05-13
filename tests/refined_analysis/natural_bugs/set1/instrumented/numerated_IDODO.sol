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
11 
12 interface IDODO {
13     function init(
14         address owner,
15         address supervisor,
16         address maintainer,
17         address baseToken,
18         address quoteToken,
19         address oracle,
20         uint256 lpFeeRate,
21         uint256 mtFeeRate,
22         uint256 k,
23         uint256 gasPriceLimit
24     ) external;
25 
26     function transferOwnership(address newOwner) external;
27 
28     function claimOwnership() external;
29 
30     function sellBaseToken(
31         uint256 amount,
32         uint256 minReceiveQuote,
33         bytes calldata data
34     ) external returns (uint256);
35 
36     function buyBaseToken(
37         uint256 amount,
38         uint256 maxPayQuote,
39         bytes calldata data
40     ) external returns (uint256);
41 
42     function querySellBaseToken(uint256 amount) external view returns (uint256 receiveQuote);
43 
44     function queryBuyBaseToken(uint256 amount) external view returns (uint256 payQuote);
45 
46     function getExpectedTarget() external view returns (uint256 baseTarget, uint256 quoteTarget);
47 
48     function depositBaseTo(address to, uint256 amount) external returns (uint256);
49 
50     function withdrawBase(uint256 amount) external returns (uint256);
51 
52     function withdrawAllBase() external returns (uint256);
53 
54     function depositQuoteTo(address to, uint256 amount) external returns (uint256);
55 
56     function withdrawQuote(uint256 amount) external returns (uint256);
57 
58     function withdrawAllQuote() external returns (uint256);
59 
60     function _BASE_CAPITAL_TOKEN_() external view returns (address);
61 
62     function _QUOTE_CAPITAL_TOKEN_() external view returns (address);
63 
64     function _BASE_TOKEN_() external returns (address);
65 
66     function _QUOTE_TOKEN_() external returns (address);
67 }
