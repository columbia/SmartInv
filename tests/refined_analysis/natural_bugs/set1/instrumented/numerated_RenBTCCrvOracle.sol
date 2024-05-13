1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.4;
3 import "../interfaces/IOracle.sol";
4 
5 // Chainlink Aggregator
6 
7 interface IAggregator {
8     function latestAnswer() external view returns (int256 answer);
9 }
10 interface ICurvePool {
11     function get_virtual_price() external view returns (uint256 price);
12 }
13 
14 contract RenBTCCrvOracle is IOracle {
15     ICurvePool constant public renCrv = ICurvePool(0x93054188d876f558f4a66B2EF1d97d16eDf0895B);
16     IAggregator constant public BTC = IAggregator(0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c);
17 
18     /**
19      * @dev Returns the smallest of two numbers.
20      */
21     // FROM: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/6d97f0919547df11be9443b54af2d90631eaa733/contracts/utils/math/Math.sol
22     function min(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a < b ? a : b;
24     }
25 
26     // Calculates the lastest exchange rate
27     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
28     function _get() internal view returns (uint256) {
29 
30         // As the price should never be negative, the unchecked conversion is acceptable
31         uint256 renCrvPrice = renCrv.get_virtual_price() * uint256(BTC.latestAnswer());
32 
33         return 1e44 / renCrvPrice;
34     }
35 
36     // Get the latest exchange rate
37     /// @inheritdoc IOracle
38     function get(bytes calldata) public view override returns (bool, uint256) {
39         return (true, _get());
40     }
41 
42     // Check the last exchange rate without any state changes
43     /// @inheritdoc IOracle
44     function peek(bytes calldata) public view override returns (bool, uint256) {
45         return (true, _get());
46     }
47 
48     // Check the current spot exchange rate without any state changes
49     /// @inheritdoc IOracle
50     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
51         (, rate) = peek(data);
52     }
53 
54     /// @inheritdoc IOracle
55     function name(bytes calldata) public pure override returns (string memory) {
56         return "Chainlink Ren Swap";
57     }
58 
59     /// @inheritdoc IOracle
60     function symbol(bytes calldata) public pure override returns (string memory) {
61         return "LINK/RenCrv";
62     }
63 }
