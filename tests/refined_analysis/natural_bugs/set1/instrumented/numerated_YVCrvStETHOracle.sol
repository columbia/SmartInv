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
11 interface IYearnVault {
12     function pricePerShare() external view returns (uint256 price);
13 }
14 
15 interface ICurvePool {
16     function get_virtual_price() external view returns (uint256 price);
17 }
18 
19 contract YVCrvStETHOracle is IOracle {
20     ICurvePool constant public STETH = ICurvePool(0xDC24316b9AE028F1497c275EB9192a3Ea0f67022);
21     IYearnVault constant public YVSTETH = IYearnVault(0xdCD90C7f6324cfa40d7169ef80b12031770B4325);
22     IAggregator constant public ETH = IAggregator(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
23 
24     /**
25      * @dev Returns the smallest of two numbers.
26      */
27     // FROM: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/6d97f0919547df11be9443b54af2d90631eaa733/contracts/utils/math/Math.sol
28     function min(uint256 a, uint256 b) internal pure returns (uint256) {
29         return a < b ? a : b;
30     }
31 
32     // Calculates the lastest exchange rate
33     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
34     function _get() internal view returns (uint256) {
35 
36         uint256 yVCurvePrice = STETH.get_virtual_price() * uint256(ETH.latestAnswer()) * YVSTETH.pricePerShare();
37 
38         return 1e62 / yVCurvePrice;
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
61         return "Yearn Chainlink Curve STETH";
62     }
63 
64     /// @inheritdoc IOracle
65     function symbol(bytes calldata) public pure override returns (string memory) {
66         return "LINK/yvCRVSTETH";
67     }
68 }
