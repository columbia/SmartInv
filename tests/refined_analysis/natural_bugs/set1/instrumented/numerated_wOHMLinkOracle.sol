1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
4 import "../interfaces/IOracle.sol";
5 
6 // Chainlink Aggregator
7 
8 interface IAggregator {
9     function latestAnswer() external view returns (int256 answer);
10 }
11 
12 interface IWOHM {
13     function sOHMTowOHM( uint256 _amount ) external view returns ( uint256 );
14 }
15 
16 contract wOHMOracle is IOracle {
17     using BoringMath for uint256; // Keep everything in uint256
18 
19     IAggregator public constant ohmOracle = IAggregator(0x90c2098473852E2F07678Fe1B6d595b1bd9b16Ed);
20     IAggregator public constant ethUSDOracle = IAggregator(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
21     IWOHM public constant WOHM = IWOHM(0xCa76543Cf381ebBB277bE79574059e32108e3E65);
22 
23     // Calculates the lastest exchange rate
24     // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
25     function _get() internal view returns (uint256) {
26         return 1e44 / (uint256(1e18).mul(uint256(ohmOracle.latestAnswer()).mul(uint256(ethUSDOracle.latestAnswer()))) / WOHM.sOHMTowOHM(1e9));
27     }
28 
29     // Get the latest exchange rate
30     /// @inheritdoc IOracle
31     function get(bytes calldata) public override returns (bool, uint256) {
32         return (true, _get());
33     }
34 
35     // Check the last exchange rate without any state changes
36     /// @inheritdoc IOracle
37     function peek(bytes calldata ) public view override returns (bool, uint256) {
38         return (true, _get());
39     }
40 
41     // Check the current spot exchange rate without any state changes
42     /// @inheritdoc IOracle
43     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
44         (, rate) = peek(data);
45     }
46 
47     /// @inheritdoc IOracle
48     function name(bytes calldata) public view override returns (string memory) {
49         return "wOHM Chainlink";
50     }
51 
52     /// @inheritdoc IOracle
53     function symbol(bytes calldata) public view override returns (string memory) {
54         return "LINK/wOHM";
55     }
56 }
