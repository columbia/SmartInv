1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 
6 interface IChainlinkAggregatorV2V3 {
7     function decimals() external view returns (uint8);
8     function description() external view returns (string memory);
9     function latestAnswer() external view returns (int256);
10     function latestTimestamp() external view returns (uint256);
11 }
12 
13 interface IStETH {
14     function getPooledEthByShares(uint256 _sharesAmount) external view returns (uint256);
15 }
16 
17 /// @notice Provides wstETH/ETH price using stETH/ETH Chainlink oracle and wstETH/stETH exchange rate provided by stETH smart contract
18 contract WSTETHOracle is IChainlinkAggregatorV2V3 {
19     address immutable public stETH;
20     address immutable public chainlinkAggregator;
21 
22     constructor(
23         address _stETH, 
24         address _chainlinkAggregator
25     ) {
26         //stETH = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
27         //chainlinkAggregator = 0x86392dC19c0b719886221c78AB11eb8Cf5c52812;
28 
29         stETH = _stETH;
30         chainlinkAggregator = _chainlinkAggregator;
31     }
32 
33     function decimals() external pure override returns (uint8) {
34         return 18;
35     }
36 
37     function description() external pure override returns (string memory) {
38         return "WSTETH/ETH";
39     }
40 
41     function latestTimestamp() external view override returns (uint256) {
42         return IChainlinkAggregatorV2V3(chainlinkAggregator).latestTimestamp();
43     }
44 
45     /// @notice Get wstETH/ETH price. It does not check Chainlink oracle staleness! If staleness check needed, it's recommended to use latestTimestamp() function
46     /// @return answer wstETH/ETH price or 0 if failure
47     function latestAnswer() external view override returns (int256 answer) {
48         // get the stETH/ETH price from Chainlink oracle
49         int256 stETHPrice = IChainlinkAggregatorV2V3(chainlinkAggregator).latestAnswer();
50         if (stETHPrice <= 0) return 0;
51 
52         // get wstETH/stETH exchange rate
53         uint256 stEthPerWstETH = IStETH(stETH).getPooledEthByShares(1 ether);
54 
55         // calculate wstETH/ETH price
56         return int256(stEthPerWstETH) * stETHPrice / 1e18;
57     }
58 }
