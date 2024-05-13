1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 import "../interfaces/IOracle.sol";
4 
5 /// @title PeggedOracle
6 /// @author BoringCrypto
7 /// @notice Oracle used for pegged prices that don't change
8 /// @dev
9 contract PeggedOracle is IOracle {
10     /// @notice
11     /// @dev
12     /// @param rate (uint256) The fixed exchange rate
13     /// @return  (bytes)
14     function getDataParameter(uint256 rate) public pure returns (bytes memory) {
15         return abi.encode(rate);
16     }
17 
18     // Get the exchange rate
19     /// @inheritdoc IOracle
20     function get(bytes calldata data) public override returns (bool, uint256) {
21         uint256 rate = abi.decode(data, (uint256));
22         return (rate != 0, rate);
23     }
24 
25     // Check the exchange rate without any state changes
26     /// @inheritdoc IOracle
27     function peek(bytes calldata data) public view override returns (bool, uint256) {
28         uint256 rate = abi.decode(data, (uint256));
29         return (rate != 0, rate);
30     }
31 
32     // Check the current spot exchange rate without any state changes
33     /// @inheritdoc IOracle
34     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
35         (, rate) = peek(data);
36     }
37 
38     /// @inheritdoc IOracle
39     function name(bytes calldata) public view override returns (string memory) {
40         return "Pegged";
41     }
42 
43     /// @inheritdoc IOracle
44     function symbol(bytes calldata) public view override returns (string memory) {
45         return "PEG";
46     }
47 }
