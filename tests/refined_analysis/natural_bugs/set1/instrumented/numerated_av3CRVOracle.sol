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
11 interface ICurvePool {
12     function get_virtual_price() external view returns (uint256 price);
13 }
14 
15 contract av3CRVOracle is IOracle {
16     ICurvePool constant public threecrv = ICurvePool(0x7f90122BF0700F9E7e1F688fe926940E8839F353);
17     IAggregator constant public DAI = IAggregator(0x51D7180edA2260cc4F6e4EebB82FEF5c3c2B8300);
18     IAggregator constant public USDC = IAggregator(0xF096872672F44d6EBA71458D74fe67F9a77a23B9);
19     IAggregator constant public USDT = IAggregator(0xEBE676ee90Fe1112671f19b6B7459bC678B67e8a);
20 
21     /**
22      * @dev Returns the smallest of two numbers.
23      */
24     // FROM: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/6d97f0919547df11be9443b54af2d90631eaa733/contracts/utils/math/Math.sol
25     function min(uint256 a, uint256 b) internal pure returns (uint256) {
26         return a < b ? a : b;
27     }
28 
29     // Calculates the latest exchange rate
30     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
31     function _get() internal view returns (uint256) {
32 
33         // As the price should never be negative, the unchecked conversion is acceptable
34         uint256 minStable = min(uint256(DAI.latestAnswer()), min(uint256(USDC.latestAnswer()), uint256(USDT.latestAnswer())));
35 
36         uint256 yVCurvePrice = threecrv.get_virtual_price() * minStable;
37 
38         return 1e44 / yVCurvePrice;
39     }
40 
41     // Get the latest exchange rate
42     /// @inheritdoc IOracle
43     function get(bytes calldata) public view override returns (bool, uint256) {
44         return (true, _get());
45     }
46 
47     // Check the last exchange rate without any state changes
48     /// @inheritdoc IOracle
49     function peek(bytes calldata) public view override returns (bool, uint256) {
50         return (true, _get());
51     }
52 
53     // Check the current spot exchange rate without any state changes
54     /// @inheritdoc IOracle
55     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
56         (, rate) = peek(data);
57     }
58 
59     /// @inheritdoc IOracle
60     function name(bytes calldata) public pure override returns (string memory) {
61         return "Chainlink av3CRV";
62     }
63 
64     /// @inheritdoc IOracle
65     function symbol(bytes calldata) public pure override returns (string memory) {
66         return "av3CRV/USD";
67     }
68 }
