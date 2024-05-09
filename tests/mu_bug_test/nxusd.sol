1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.4;
3 import "./IOracle.sol";
4 
5 
6 interface IAggregator {
7     function latestAnswer() external view returns (int256 answer);
8 }
9 
10 interface IJoePair {
11     function getReserves() external view returns ( uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
12     function totalSupply() external view returns (uint256);
13 }
14 
15 contract JLPWAVAXUSDCOracle is IOracle {
16     IJoePair constant public joePair = IJoePair(0xf4003F4efBE8691B60249E6afbD307aBE7758adb);
17     IAggregator constant public AVAX = IAggregator(0x0A77230d17318075983913bC2145DB16C7366156);
18     IAggregator constant public USDC = IAggregator(0xF096872672F44d6EBA71458D74fe67F9a77a23B9);
19 
20     function _get() internal view returns (uint256) {
21 
22         uint256 usdcPrice = uint256(USDC.latestAnswer());
23         uint256 avaxPrice = uint256(AVAX.latestAnswer());
24         (uint112 wavaxReserve, uint112 usdcReserve, ) = joePair.getReserves();
25 
26         uint256 price = (wavaxReserve * avaxPrice + usdcReserve * usdcPrice * 1e12) / uint256(joePair.totalSupply());
27 
28         return 1e26 / price;
29     }
30 
31     function get(bytes calldata) public view override returns (bool, uint256) {
32         return (true, _get());
33     }
34 
35 
36     function peek(bytes calldata) public view override returns (bool, uint256) {
37         return (true, _get());
38     }
39 
40     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
41         (, rate) = peek(data);
42     }
43 
44     function name(bytes calldata) public pure override returns (string memory) {
45         return "Chainlink WAVAX-USDC JLP";
46     }
47 
48     function symbol(bytes calldata) public pure override returns (string memory) {
49         return "WAVAX-USDC JLP/USD";
50     }
51 }