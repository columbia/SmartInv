1 // SPDX-License-Identifier: MIT
2 // Using the same Copyleft License as in the original Repository
3 pragma solidity 0.6.12;
4 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
5 import "../interfaces/IOracle.sol";
6 
7 contract CompositeOracle is IOracle {
8     using BoringMath for uint256;
9 
10     function getDataParameter(
11         IOracle oracle1,
12         IOracle oracle2,
13         bytes memory data1,
14         bytes memory data2
15     ) public pure returns (bytes memory) {
16         return abi.encode(oracle1, oracle2, data1, data2);
17     }
18 
19     // Get the latest exchange rate, if no valid (recent) rate is available, return false
20     /// @inheritdoc IOracle
21     function get(bytes calldata data) external override returns (bool, uint256) {
22         (IOracle oracle1, IOracle oracle2, bytes memory data1, bytes memory data2) = abi.decode(data, (IOracle, IOracle, bytes, bytes));
23         (bool success1, uint256 price1) = oracle1.get(data1);
24         (bool success2, uint256 price2) = oracle2.get(data2);
25         return (success1 && success2, price1.mul(price2) / 10**18);
26     }
27 
28     // Check the last exchange rate without any state changes
29     /// @inheritdoc IOracle
30     function peek(bytes calldata data) public view override returns (bool, uint256) {
31         (IOracle oracle1, IOracle oracle2, bytes memory data1, bytes memory data2) = abi.decode(data, (IOracle, IOracle, bytes, bytes));
32         (bool success1, uint256 price1) = oracle1.peek(data1);
33         (bool success2, uint256 price2) = oracle2.peek(data2);
34         return (success1 && success2, price1.mul(price2) / 10**18);
35     }
36 
37     // Check the current spot exchange rate without any state changes
38     /// @inheritdoc IOracle
39     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
40         (IOracle oracle1, IOracle oracle2, bytes memory data1, bytes memory data2) = abi.decode(data, (IOracle, IOracle, bytes, bytes));
41         uint256 price1 = oracle1.peekSpot(data1);
42         uint256 price2 = oracle2.peekSpot(data2);
43         return price1.mul(price2) / 10**18;
44     }
45 
46     /// @inheritdoc IOracle
47     function name(bytes calldata data) public view override returns (string memory) {
48         (IOracle oracle1, IOracle oracle2, bytes memory data1, bytes memory data2) = abi.decode(data, (IOracle, IOracle, bytes, bytes));
49         return string(abi.encodePacked(oracle1.name(data1), "+", oracle2.name(data2)));
50     }
51 
52     /// @inheritdoc IOracle
53     function symbol(bytes calldata data) public view override returns (string memory) {
54         (IOracle oracle1, IOracle oracle2, bytes memory data1, bytes memory data2) = abi.decode(data, (IOracle, IOracle, bytes, bytes));
55         return string(abi.encodePacked(oracle1.symbol(data1), "+", oracle2.symbol(data2)));
56     }
57 }
