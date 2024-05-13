1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.4;
3 import "../interfaces/IOracle.sol";
4 
5 // Chainlink Aggregator
6 
7 interface IAggregator {
8     function latestAnswer() external view returns (int256 answer);
9 }
10 
11 interface IJoePair {
12     function getReserves() external view returns ( uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
13     function totalSupply() external view returns (uint256);
14 }
15 
16 contract JLPWAVAXUSDCOracle is IOracle {
17     IJoePair constant public joePair = IJoePair(0xf4003F4efBE8691B60249E6afbD307aBE7758adb);
18     IAggregator constant public AVAX = IAggregator(0x0A77230d17318075983913bC2145DB16C7366156);
19     IAggregator constant public USDC = IAggregator(0xF096872672F44d6EBA71458D74fe67F9a77a23B9);
20 
21     function _get() internal view returns (uint256) {
22 
23         uint256 usdcPrice = uint256(USDC.latestAnswer());
24         uint256 avaxPrice = uint256(AVAX.latestAnswer());
25         (uint112 wavaxReserve, uint112 usdcReserve, ) = joePair.getReserves();
26 
27         uint256 price = (wavaxReserve * avaxPrice + usdcReserve * usdcPrice * 1e12) / uint256(joePair.totalSupply());
28 
29         return 1e26 / price;
30     }
31 
32     // Get the latest exchange rate
33     /// @inheritdoc IOracle
34     function get(bytes calldata) public view override returns (bool, uint256) {
35         return (true, _get());
36     }
37 
38     // Check the last exchange rate without any state changes
39     /// @inheritdoc IOracle
40     function peek(bytes calldata) public view override returns (bool, uint256) {
41         return (true, _get());
42     }
43 
44     // Check the current spot exchange rate without any state changes
45     /// @inheritdoc IOracle
46     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
47         (, rate) = peek(data);
48     }
49 
50     /// @inheritdoc IOracle
51     function name(bytes calldata) public pure override returns (string memory) {
52         return "Chainlink WAVAX-USDC JLP";
53     }
54 
55     /// @inheritdoc IOracle
56     function symbol(bytes calldata) public pure override returns (string memory) {
57         return "WAVAX-USDC JLP/USD";
58     }
59 }
