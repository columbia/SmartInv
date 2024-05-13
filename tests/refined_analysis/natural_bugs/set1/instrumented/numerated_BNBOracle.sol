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
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14 }
15 
16 contract BNBOracle is IOracle {
17     IAggregator constant public BNBUSD = IAggregator(0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE);
18 
19     // Calculates the lastest exchange rate
20     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
21     function _get() internal view returns (uint256) {
22 
23         return 1e26 / uint256(BNBUSD.latestAnswer());
24     }
25 
26     // Get the latest exchange rate
27     /// @inheritdoc IOracle
28     function get(bytes calldata) public view override returns (bool, uint256) {
29         return (true, _get());
30     }
31 
32     // Check the last exchange rate without any state changes
33     /// @inheritdoc IOracle
34     function peek(bytes calldata) public view override returns (bool, uint256) {
35         return (true, _get());
36     }
37 
38     // Check the current spot exchange rate without any state changes
39     /// @inheritdoc IOracle
40     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
41         (, rate) = peek(data);
42     }
43 
44     /// @inheritdoc IOracle
45     function name(bytes calldata) public pure override returns (string memory) {
46         return "Chainlink BNB";
47     }
48 
49     /// @inheritdoc IOracle
50     function symbol(bytes calldata) public pure override returns (string memory) {
51         return "LINK/BNB";
52     }
53 }
